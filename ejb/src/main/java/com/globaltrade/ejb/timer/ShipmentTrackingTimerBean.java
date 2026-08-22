package com.globaltrade.ejb.timer;

import com.globaltrade.core.entity.Shipment;
import com.globaltrade.core.entity.ShipmentStatus;
import com.globaltrade.core.exception.ShipmentTrackingException;
import com.globaltrade.core.util.RetryExecutor;
import com.globaltrade.ejb.interceptor.ExceptionLoggingInterceptor;
import com.globaltrade.ejb.interceptor.PerformanceMonitorInterceptor;
import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import jakarta.interceptor.Interceptors;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@Singleton
@Startup
@Interceptors({PerformanceMonitorInterceptor.class, ExceptionLoggingInterceptor.class})
public class ShipmentTrackingTimerBean {

    private static final Logger LOGGER = Logger.getLogger(ShipmentTrackingTimerBean.class.getName());
    private static final int MAX_RETRIES = 3;
    private static final long RETRY_DELAY_MS = 200L;

    @PersistenceContext(unitName = "SupplyChainPU")
    private EntityManager em;

    @Schedule(minute = "*/30", hour = "*", persistent = false)
    public void trackActiveShipments() {
        LOGGER.info("--- [TIMER-SERVICE] Executing Automated Shipment Tracking & Milestone Evaluator ---");

        try {
            // Enterprise Resilience: Execute with automatic retry & fallback recovery
            int updatedCount = RetryExecutor.executeWithRetry(
                    this::processActiveShipments,
                    MAX_RETRIES,
                    RETRY_DELAY_MS,
                    "Automated Shipment Milestone Evaluation",
                    () -> {
                        LOGGER.log(Level.WARNING, "[FALLBACK-RECOVERY] Executing graceful fallback for ShipmentTrackingTimer.");
                        return 0; // Return safe default without crashing timer thread
                    }
            );

            LOGGER.info("[TIMER-COMPLETED] Shipment Tracking successfully evaluated. Milestones updated: " + updatedCount);
        } catch (Exception e) {
            LOGGER.severe("[TIMER-ERROR] Unrecoverable error during shipment tracking: " + e.getMessage());
        }
    }

    private Integer processActiveShipments() throws ShipmentTrackingException {
        try {
            List<Shipment> activeShipments = em.createQuery(
                    "SELECT s FROM Shipment s WHERE s.shipmentStatus.name != 'DELIVERED' AND s.shipmentStatus.name != 'CANCELLED'", 
                    Shipment.class)
                    .getResultList();

            LocalDateTime now = LocalDateTime.now();
            int updatedCount = 0;

            for (Shipment s : activeShipments) {
                if (s.getEstimatedDelivery() == null || s.getEstimatedDelivery().isBefore(now)) {
                    s.setActualDelivery(now);

                    ShipmentStatus deliveredStatus = getOrCreateShipmentStatus("DELIVERED", "Shipment successfully received at destination");
                    s.setShipmentStatus(deliveredStatus);
                    em.merge(s);
                    updatedCount++;
                    LOGGER.info(">>> Auto-updated Shipment " + s.getShipmentCode() + " to DELIVERED status.");
                }
            }

            return updatedCount;
        } catch (Exception ex) {
            throw new ShipmentTrackingException("Database error during shipment query/update: " + ex.getMessage());
        }
    }

    private ShipmentStatus getOrCreateShipmentStatus(String name, String desc) {
        List<ShipmentStatus> list = em.createQuery("SELECT st FROM ShipmentStatus st WHERE st.name = :name", ShipmentStatus.class)
                .setParameter("name", name)
                .getResultList();
        if (!list.isEmpty()) {
            return list.get(0);
        }
        ShipmentStatus status = new ShipmentStatus();
        status.setName(name);
        status.setDescription(desc);
        em.persist(status);
        return status;
    }
}