package com.globaltrade.ejb.timer;

import com.globaltrade.core.entity.InventoryAlert;
import com.globaltrade.core.entity.InventoryStock;
import com.globaltrade.ejb.interceptor.ExceptionLoggingInterceptor;
import com.globaltrade.ejb.interceptor.PerformanceMonitorInterceptor;
import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import jakarta.interceptor.Interceptors;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;
import java.util.logging.Logger;

@Singleton
@Startup
@Interceptors({PerformanceMonitorInterceptor.class, ExceptionLoggingInterceptor.class})
public class InventoryAlertTimerBean {

    private static final Logger LOGGER = Logger.getLogger(InventoryAlertTimerBean.class.getName());

    @PersistenceContext(unitName = "SupplyChainPU")
    private EntityManager em;

    @Schedule(hour = "*", minute = "*", second = "0", persistent = false)
    public void checkLowStockLevels() {
        LOGGER.info("--- Executing Timer Service: checkLowStockLevels ---");

        try {
            List<InventoryStock> allStocks = em.createQuery(
                    "SELECT s FROM InventoryStock s LEFT JOIN FETCH s.item LEFT JOIN FETCH s.warehouse", 
                    InventoryStock.class)
                    .getResultList();

            int alertsCreated = 0;
            int alertsResolved = 0;

            for (InventoryStock stock : allStocks) {
                if (stock.getItem() == null || stock.getWarehouse() == null) continue;

                int reorderLevel = (stock.getItem().getReorderLevel() != null) ? stock.getItem().getReorderLevel() : 10;
                int currentQty = (stock.getStockQty() != null) ? stock.getStockQty() : 0;

                if (currentQty <= reorderLevel) {
                    List<InventoryAlert> existingAlerts = em.createQuery(
                            "SELECT a FROM InventoryAlert a WHERE a.item.id = :itemId AND a.warehouse.id = :whId AND a.resolved = false", 
                            InventoryAlert.class)
                            .setParameter("itemId", stock.getItem().getId())
                            .setParameter("whId", stock.getWarehouse().getId())
                            .getResultList();

                    if (existingAlerts.isEmpty()) {
                        InventoryAlert alert = new InventoryAlert();
                        alert.setItem(stock.getItem());
                        alert.setWarehouse(stock.getWarehouse());
                        alert.setAlertType(currentQty == 0 ? "OUT_OF_STOCK" : "LOW_STOCK");
                        alert.setResolved(false);
                        em.persist(alert);
                        alertsCreated++;
                        LOGGER.info(">>> Created " + alert.getAlertType() + " alert for Product: " + stock.getItem().getName() + " at " + stock.getWarehouse().getName());
                    }
                } else {
                    List<InventoryAlert> openAlerts = em.createQuery(
                            "SELECT a FROM InventoryAlert a WHERE a.item.id = :itemId AND a.warehouse.id = :whId AND a.resolved = false", 
                            InventoryAlert.class)
                            .setParameter("itemId", stock.getItem().getId())
                            .setParameter("whId", stock.getWarehouse().getId())
                            .getResultList();

                    for (InventoryAlert a : openAlerts) {
                        a.setResolved(true);
                        em.merge(a);
                        alertsResolved++;
                        LOGGER.info(">>> Auto-resolved alert for Product: " + stock.getItem().getName() + " (Stock replenished to " + currentQty + ")");
                    }
                }
            }

            LOGGER.info("Stock Check Complete. New Alerts: " + alertsCreated + ", Resolved: " + alertsResolved);
        } catch (Exception e) {
            LOGGER.severe("Error during checkLowStockLevels: " + e.getMessage());
            e.printStackTrace();
        }
    }
}