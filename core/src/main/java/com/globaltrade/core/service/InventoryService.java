package com.globaltrade.core.service;

import com.globaltrade.core.dto.ProductDTO;
import com.globaltrade.core.dto.StockDTO;
import com.globaltrade.core.dto.WarehouseDTO;
import com.globaltrade.core.exception.InsufficientStockException;
import jakarta.ejb.Local;
import java.math.BigDecimal;
import java.util.List;

@Local
public interface InventoryService {
    void reserveStock(Long itemId, Long warehouseId, Integer quantity) throws InsufficientStockException;
    void updateStockLevels(Long itemId, Long warehouseId, Integer quantityToAdd);
    
    List<String> getAllCategoryNames();
    List<ProductDTO> getAllProducts();
    List<WarehouseDTO> getAllWarehouses();
    List<StockDTO> getAllStock();
    void addOrUpdateStock(Long productId, Long warehouseId, Integer qty, BigDecimal unitPrice, Integer reorderLevel, Long statusId);
    void quickUpdateStock(Long stockId, Integer newQty);
    void addProduct(ProductDTO productDTO);
}
