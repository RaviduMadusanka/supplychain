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

@Stateless
@TransactionManagement(TransactionManagementType.CONTAINER)
public class InventoryServiceBean implements InventoryService {

    @PersistenceContext(unitName = "SupplyChainPU")
    private EntityManager em;

    /**
     * CMT Example: REQUIRES_NEW ensures that this critical stock reservation 
     * happens in its own isolated transaction. If this fails, the parent transaction 
     * can decide how to handle it, but if it succeeds, it commits independently.
     */
    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRES_NEW)
    public void reserveStock(Long itemId, Long warehouseId, Integer quantity) throws InsufficientStockException {
        // Find the stock record
        InventoryStock stock = em.createQuery(
                "SELECT s FROM InventoryStock s WHERE s.item.id = :itemId AND s.warehouse.id = :warehouseId", 
                InventoryStock.class)
                .setParameter("itemId", itemId)
                .setParameter("warehouseId", warehouseId)
                .setLockMode(LockModeType.PESSIMISTIC_WRITE) // Prevent concurrent updates
                .getSingleResult();

        if (stock == null) {
            throw new InsufficientStockException("Stock record not found for Item ID: " + itemId);
        }

        if (stock.getQuantityAvailable() < quantity) {
            throw new InsufficientStockException("Not enough stock available. Requested: " + quantity + ", Available: " + stock.getQuantityAvailable());
        }

        // Reserve the stock
        stock.setQuantityAvailable(stock.getQuantityAvailable() - quantity);
        stock.setQuantityReserved(stock.getQuantityReserved() + quantity);
        
        em.merge(stock);
    }

    /**
     * CMT Example: REQUIRED (default) joins the existing transaction if there is one.
     */
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
            stock.setQuantityAvailable(stock.getQuantityAvailable() + quantityToAdd);
            em.merge(stock);
        }
    }
}
