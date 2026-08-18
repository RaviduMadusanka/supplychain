package com.globaltrade.core.service;

import com.globaltrade.core.entity.InventoryItem;
import com.globaltrade.core.entity.InventoryStock;
import com.globaltrade.core.entity.Warehouse;
import com.globaltrade.core.exception.InsufficientStockException;
import jakarta.ejb.Local;
import java.math.BigDecimal;
import java.util.List;

@Local
public interface InventoryService {
    void reserveStock(Long itemId, Long warehouseId, Integer quantity) throws InsufficientStockException;
    void updateStockLevels(Long itemId, Long warehouseId, Integer quantityToAdd);
    
    List<InventoryItem> getAllProducts();
    List<Warehouse> getAllWarehouses();
    List<InventoryStock> getAllStock();
    void addOrUpdateStock(Long productId, Long warehouseId, Integer qty, BigDecimal unitPrice, Integer reorderLevel, Long statusId);
    void quickUpdateStock(Long stockId, Integer newQty);
}
