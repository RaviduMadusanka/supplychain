package com.globaltrade.ejb.timer;

import com.globaltrade.core.entity.InventoryAlert;
import com.globaltrade.core.entity.InventoryStock;
import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.util.List;

@Singleton
@Startup
public class InventoryAlertTimerBean {

    @PersistenceContext(unitName = "SupplyChainPU")
    private EntityManager em;

    @Schedule(hour = "*", minute = "*", second = "0", persistent = false)
    public void checkLowStockLevels() {
        System.out.println("--- Executing Timer Service: checkLowStockLevels ---");

        List<InventoryStock> lowStockItems = em.createQuery(
                "SELECT s FROM InventoryStock s WHERE s.stockQty <= s.item.reorderLevel", 
                InventoryStock.class)
                .getResultList();

        for (InventoryStock stock : lowStockItems) {
            Long alertCount = em.createQuery(
                    "SELECT COUNT(a) FROM InventoryAlert a WHERE a.item.id = :itemId AND a.warehouse.id = :warehouseId AND a.resolved = false", 
                    Long.class)
                    .setParameter("itemId", stock.getItem().getId())
                    .setParameter("warehouseId", stock.getWarehouse().getId())
                    .getSingleResult();

            if (alertCount == 0) {
                InventoryAlert alert = new InventoryAlert();
                alert.setItem(stock.getItem());
                alert.setWarehouse(stock.getWarehouse());
                
                if (stock.getStockQty() == 0) {
                    alert.setAlertType("OUT_OF_STOCK");
                } else {
                    alert.setAlertType("LOW_STOCK");
                }
                
                alert.setResolved(false);
                em.persist(alert);
                
                System.out.println(">>> Generated " + alert.getAlertType() + " alert for SKU: " + stock.getItem().getSku() + " at " + stock.getWarehouse().getWarehouseCode());
            }
        }

        List<InventoryAlert> openAlerts = em.createQuery(
                "SELECT a FROM InventoryAlert a WHERE a.resolved = false", 
                InventoryAlert.class)
                .getResultList();
                
        for (InventoryAlert alert : openAlerts) {
            InventoryStock stock = em.createQuery(
                    "SELECT s FROM InventoryStock s WHERE s.item.id = :itemId AND s.warehouse.id = :warehouseId", 
                    InventoryStock.class)
                    .setParameter("itemId", alert.getItem().getId())
                    .setParameter("warehouseId", alert.getWarehouse().getId())
                    .getSingleResult();
                    
            if (stock != null && stock.getStockQty() > stock.getItem().getReorderLevel()) {
                alert.setResolved(true);
                em.merge(alert);
                System.out.println(">>> Auto-resolved alert for SKU: " + stock.getItem().getSku() + " as stock is replenished.");
            }
        }
    }
}
