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
}
