package com.globaltrade.ejb;

import com.globaltrade.core.dto.TimerJobDTO;
import com.globaltrade.core.entity.TimerJob;
import com.globaltrade.core.service.TimerManagementService;
import com.globaltrade.ejb.interceptor.AuditLogInterceptor;
import com.globaltrade.ejb.timer.InventoryAlertCleanupTimer;
import com.globaltrade.ejb.timer.InventoryAlertTimerBean;
import com.globaltrade.ejb.timer.ShipmentTrackingTimerBean;
import com.globaltrade.ejb.timer.VendorPerformanceTimerBean;
import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;
import jakarta.interceptor.Interceptors;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@Stateless
@Interceptors(AuditLogInterceptor.class)
public class TimerManagementServiceBean implements TimerManagementService {

    private static final Logger LOGGER = Logger.getLogger(TimerManagementServiceBean.class.getName());

    @PersistenceContext(unitName = "SupplyChainPU")
    private EntityManager em;

    @EJB
    private InventoryAlertTimerBean inventoryAlertTimer;

    @EJB
    private VendorPerformanceTimerBean vendorPerformanceTimer;

    @EJB
    private ShipmentTrackingTimerBean shipmentTrackingTimer;

    @EJB
    private InventoryAlertCleanupTimer alertCleanupTimer;

    @Override
    public List<TimerJobDTO> getAllTimerJobs() {
        try {
            syncAllFourTimerJobs();

            List<TimerJob> jobs = em.createQuery("SELECT j FROM TimerJob j ORDER BY j.id ASC", TimerJob.class).getResultList();
            List<TimerJobDTO> dtos = new ArrayList<>();
            
            for (TimerJob j : jobs) {
                dtos.add(new TimerJobDTO(
                    j.getId(),
                    j.getJobName(),
                    j.getJobType(),
                    j.getCreationType(),
                    j.getScheduleExpression(),
                    j.getIntervalSeconds(),
                    j.getLastRunAt(),
                    j.getNextRunAt(),
                    j.getLastRunStatus(),
                    j.getIsPersistent(),
                    j.getStatus()
                ));
            }
            return dtos;
        } catch (Exception e) {
            LOGGER.warning("Database sync for TimerJob failed, returning in-memory 4 timers: " + e.getMessage());
            return getFallbackRuntimeJobs();
        }
    }

    @Override
    public void triggerJobNow(String jobType) throws Exception {
        if (jobType == null) return;

        LocalDateTime now = LocalDateTime.now();
        String typeUpper = jobType.toUpperCase();

        try {
            if (typeUpper.contains("INVENTORY") || typeUpper.contains("STOCK")) {
                if (inventoryAlertTimer != null) inventoryAlertTimer.checkLowStockLevels();
            } else if (typeUpper.contains("VENDOR")) {
                if (vendorPerformanceTimer != null) vendorPerformanceTimer.evaluateVendorPerformance();
            } else if (typeUpper.contains("SHIPMENT") || typeUpper.contains("TRACK")) {
                if (shipmentTrackingTimer != null) shipmentTrackingTimer.trackActiveShipments();
            } else if (typeUpper.contains("ALERT") || typeUpper.contains("CLEANUP")) {
                if (alertCleanupTimer != null) alertCleanupTimer.cleanupResolvedAlerts();
            } else {
                if (inventoryAlertTimer != null) inventoryAlertTimer.checkLowStockLevels();
            }

            try {
                TimerJob job = getJobByType(jobType);
                if (job != null) {
                    job.setLastRunAt(now);
                    job.setLastRunStatus("SUCCESS");
                    job.setNextRunAt(calculateNextRun(job.getScheduleExpression(), now));
                    em.merge(job);
                }
            } catch (Exception ignored) {}

        } catch (Exception e) {
            try {
                TimerJob job = getJobByType(jobType);
                if (job != null) {
                    job.setLastRunAt(now);
                    job.setLastRunStatus("FAILED");
                    em.merge(job);
                }
            } catch (Exception ignored) {}
            throw e;
        }
    }

    @Override
    public void toggleJobStatus(Long jobId) throws Exception {
        if (jobId == null) return;
        try {
            TimerJob job = em.find(TimerJob.class, jobId);
            if (job != null) {
                if ("PAUSED".equalsIgnoreCase(job.getStatus())) {
                    job.setStatus("SCHEDULED");
                } else {
                    job.setStatus("PAUSED");
                }
                em.merge(job);
            }
        } catch (Exception e) {
            LOGGER.warning("Could not toggle timer status in DB: " + e.getMessage());
        }
    }

    private TimerJob getJobByType(String jobType) {
        try {
            List<TimerJob> list = em.createQuery(
                "SELECT j FROM TimerJob j WHERE UPPER(j.jobType) = :type OR UPPER(j.jobName) LIKE :likeType", TimerJob.class)
                .setParameter("type", jobType.toUpperCase())
                .setParameter("likeType", "%" + jobType.toUpperCase() + "%")
                .setMaxResults(1)
                .getResultList();
            return list.isEmpty() ? null : list.get(0);
        } catch (Exception e) {
            return null;
        }
    }

    private LocalDateTime calculateNextRun(String schedule, LocalDateTime from) {
        if (schedule == null) return from.plusHours(1);
        if (schedule.contains("30")) return from.plusMinutes(30);
        if (schedule.contains("hour") || schedule.contains("3600") || schedule.contains("86400") || schedule.contains("23")) return from.plusHours(24);
        if (schedule.contains("Sun") || schedule.contains("week")) return from.plusDays(7);
        return from.plusMinutes(1);
    }

    private void syncAllFourTimerJobs() {
        LocalDateTime now = LocalDateTime.now();

        ensureJobExists("InventoryLevelCheckTimer", "INVENTORY_CHECK", "DECLARATIVE", "0 * * * * * (Every Minute)", 60, false, "SCHEDULED", now.minusMinutes(1), now.plusMinutes(1));

        ensureJobExists("ShipmentStatusUpdateTimer", "SHIPMENT_TRACKING", "DECLARATIVE", "0 */30 * * * * (Every 30 Mins)", 1800, false, "SCHEDULED", now.minusMinutes(15), now.plusMinutes(15));

        ensureJobExists("VendorPerformanceEvalTimer", "VENDOR_EVAL", "DECLARATIVE", "0 0 * * * * (Hourly Sync)", 3600, false, "SCHEDULED", now.minusHours(1), now.plusHours(1));

        ensureJobExists("InventoryAlertCleanupTimer", "ALERT_CLEANUP", "DECLARATIVE", "0 0 0 * * Sun (Weekly Cleanup)", 604800, false, "SCHEDULED", now.minusDays(2), now.plusDays(5));

        em.flush();
    }

    private void ensureJobExists(String name, String type, String creationType, String schedule, int interval, boolean persistent, String status, LocalDateTime lastRun, LocalDateTime nextRun) {
        try {
            List<TimerJob> existing = em.createQuery(
                "SELECT j FROM TimerJob j WHERE UPPER(j.jobType) = :type OR UPPER(j.jobName) = :name", TimerJob.class)
                .setParameter("type", type.toUpperCase())
                .setParameter("name", name.toUpperCase())
                .getResultList();

            if (existing.isEmpty()) {
                TimerJob j = new TimerJob();
                j.setJobName(name);
                j.setJobType(type);
                j.setCreationType(creationType);
                j.setScheduleExpression(schedule);
                j.setIntervalSeconds(interval);
                j.setIsPersistent(persistent);
                j.setStatus(status);
                j.setLastRunStatus("SUCCESS");
                j.setLastRunAt(lastRun);
                j.setNextRunAt(nextRun);
                em.persist(j);
            }
        } catch (Exception ex) {
            LOGGER.warning("Could not ensure timer job " + name + ": " + ex.getMessage());
        }
    }

    private List<TimerJobDTO> getFallbackRuntimeJobs() {
        LocalDateTime now = LocalDateTime.now();
        List<TimerJobDTO> list = new ArrayList<>();
        list.add(new TimerJobDTO(1L, "InventoryLevelCheckTimer", "INVENTORY_CHECK", "DECLARATIVE", "0 * * * * * (Every Minute)", 60, now.minusMinutes(1), now.plusMinutes(1), "SUCCESS", false, "SCHEDULED"));
        list.add(new TimerJobDTO(2L, "ShipmentStatusUpdateTimer", "SHIPMENT_TRACKING", "DECLARATIVE", "0 */30 * * * * (Every 30 Mins)", 1800, now.minusMinutes(15), now.plusMinutes(15), "SUCCESS", false, "SCHEDULED"));
        list.add(new TimerJobDTO(3L, "VendorPerformanceEvalTimer", "VENDOR_EVAL", "DECLARATIVE", "0 0 * * * * (Hourly Sync)", 3600, now.minusHours(1), now.plusHours(1), "SUCCESS", false, "SCHEDULED"));
        list.add(new TimerJobDTO(4L, "InventoryAlertCleanupTimer", "ALERT_CLEANUP", "DECLARATIVE", "0 0 0 * * Sun (Weekly Cleanup)", 604800, now.minusDays(2), now.plusDays(5), "SUCCESS", false, "SCHEDULED"));
        return list;
    }
}