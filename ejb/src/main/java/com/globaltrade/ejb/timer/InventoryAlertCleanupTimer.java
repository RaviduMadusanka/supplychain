package com.globaltrade.ejb.timer;

import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;
import java.time.LocalDateTime;
import java.util.logging.Logger;

@Singleton
@Startup
public class InventoryAlertCleanupTimer {

    private static final Logger LOGGER = Logger.getLogger(InventoryAlertCleanupTimer.class.getName());

    @PersistenceContext(unitName = "SupplyChainPU")
    private EntityManager em;

    @Schedule(hour = "0", minute = "0", second = "0", dayOfWeek = "Sun", persistent = false)
    public void cleanupResolvedAlerts() {
        LOGGER.info("Starting scheduled cleanup of resolved inventory alerts...");

        try {
            LocalDateTime oneWeekAgo = LocalDateTime.now().minusDays(7);

            Query query = em.createQuery("DELETE FROM InventoryAlert a WHERE a.resolved = true AND a.triggeredAt < :cutoffDate");
            query.setParameter("cutoffDate", oneWeekAgo);
            
            int deletedCount = query.executeUpdate();
            
            if (deletedCount > 0) {
                LOGGER.info("Successfully cleaned up " + deletedCount + " resolved inventory alerts older than 7 days.");
            }
        } catch (Exception e) {
            LOGGER.severe("Error during inventory alerts cleanup: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
