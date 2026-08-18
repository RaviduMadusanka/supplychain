package com.globaltrade.ejb;

import com.globaltrade.core.entity.InventoryStock;
import com.globaltrade.core.exception.InsufficientStockException;
import com.globaltrade.core.service.InventoryService;
import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;
import jakarta.ejb.TransactionManagement;
import jakarta.ejb.TransactionManagementType;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.LockModeType;

import jakarta.interceptor.Interceptors;
import com.globaltrade.ejb.interceptor.AuditLogInterceptor;

@Stateless
@TransactionManagement(TransactionManagementType.CONTAINER)
@Interceptors(AuditLogInterceptor.class)
public class InventoryServiceBean implements InventoryService {

    @PersistenceContext(unitName = "SupplyChainPU")
    private EntityManager em;

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    public void reserveStock(Long itemId, Long warehouseId, Integer quantity) throws InsufficientStockException {

        InventoryStock stock = em.createQuery(
                "SELECT s FROM InventoryStock s WHERE s.item.id = :itemId AND s.warehouse.id = :warehouseId", 
                InventoryStock.class)
                .setParameter("itemId", itemId)
                .setParameter("warehouseId", warehouseId)
                .setLockMode(LockModeType.PESSIMISTIC_WRITE)
                .getSingleResult();

        if (stock == null) {
            throw new InsufficientStockException("Stock record not found for Item ID: " + itemId);
        }

        if (stock.getStockQty() < quantity) {
            throw new InsufficientStockException("Not enough stock available. Requested: " + quantity + ", Available: " + stock.getStockQty());
        }

        stock.setStockQty(stock.getStockQty() - quantity);
        
        em.merge(stock);
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public void updateStockLevels(Long itemId, Long warehouseId, Integer quantityToAdd) {
        InventoryStock stock = em.createQuery(
                "SELECT s FROM InventoryStock s WHERE s.item.id = :itemId AND s.warehouse.id = :warehouseId", 
                InventoryStock.class)
                .setParameter("itemId", itemId)
                .setParameter("warehouseId", warehouseId)
                .getSingleResult();

        if (stock != null) {
            stock.setStockQty(stock.getStockQty() + quantityToAdd);
            em.merge(stock);
        }
    }

    @Override
    public java.util.List<com.globaltrade.core.entity.InventoryItem> getAllProducts() {
        return em.createQuery("SELECT i FROM InventoryItem i", com.globaltrade.core.entity.InventoryItem.class).getResultList();
    }

    @Override
    public java.util.List<com.globaltrade.core.entity.Warehouse> getAllWarehouses() {
        return em.createQuery("SELECT w FROM Warehouse w", com.globaltrade.core.entity.Warehouse.class).getResultList();
    }

    @Override
    public java.util.List<InventoryStock> getAllStock() {
        return em.createQuery("SELECT s FROM InventoryStock s JOIN FETCH s.item JOIN FETCH s.warehouse JOIN FETCH s.status", InventoryStock.class).getResultList();
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public void addOrUpdateStock(Long productId, Long warehouseId, Integer qty, java.math.BigDecimal unitPrice, Integer reorderLevel, Long statusId) {
        // Update product reorder level
        com.globaltrade.core.entity.InventoryItem item = em.find(com.globaltrade.core.entity.InventoryItem.class, productId);
        if (item != null && reorderLevel != null) {
            item.setReorderLevel(reorderLevel);
            em.merge(item);
        }

        com.globaltrade.core.entity.Status status = null;
        if (statusId != null) {
            status = em.find(com.globaltrade.core.entity.Status.class, statusId);
        } else {
            // Find "ACTIVE" status by default if missing
            try {
                status = em.createQuery("SELECT s FROM Status s WHERE s.name = 'ACTIVE'", com.globaltrade.core.entity.Status.class).getSingleResult();
            } catch (Exception e) {}
        }

        // Check if stock exists matching Product, Warehouse AND Price
        java.util.List<InventoryStock> stocks = em.createQuery(
                "SELECT s FROM InventoryStock s WHERE s.item.id = :itemId AND s.warehouse.id = :warehouseId AND s.unitPrice = :unitPrice", 
                InventoryStock.class)
                .setParameter("itemId", productId)
                .setParameter("warehouseId", warehouseId)
                .setParameter("unitPrice", unitPrice)
                .getResultList();

        if (stocks.isEmpty()) {
            InventoryStock newStock = new InventoryStock();
            newStock.setItem(item);
            newStock.setWarehouse(em.find(com.globaltrade.core.entity.Warehouse.class, warehouseId));
            newStock.setStockQty(qty);
            newStock.setUnitPrice(unitPrice);
            newStock.setStatus(status);
            em.persist(newStock);
        } else {
            InventoryStock existingStock = stocks.get(0);
            existingStock.setStockQty(existingStock.getStockQty() + qty);
            if (status != null) {
                existingStock.setStatus(status);
            }
            em.merge(existingStock);
        }
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public void quickUpdateStock(Long stockId, Integer newQty) {
        InventoryStock stock = em.find(InventoryStock.class, stockId);
        if (stock != null) {
            stock.setStockQty(newQty);
            em.merge(stock);
        }
    }
}
