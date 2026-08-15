package com.globaltrade.core.service;

import com.globaltrade.core.exception.InsufficientStockException;
import jakarta.ejb.Local;

@Local
public interface InventoryService {
    void reserveStock(Long itemId, Long warehouseId, Integer quantity) throws InsufficientStockException;
    void updateStockLevels(Long itemId, Long warehouseId, Integer quantityToAdd);
}
