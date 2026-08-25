package com.globaltrade.ejb;

import com.globaltrade.core.dto.CategoryDTO;
import com.globaltrade.core.dto.ProductDTO;
import com.globaltrade.core.dto.StockDTO;
import com.globaltrade.core.dto.VendorDTO;
import com.globaltrade.core.dto.WarehouseDTO;
import com.globaltrade.core.entity.Category;
import com.globaltrade.core.entity.InventoryItem;
import com.globaltrade.core.entity.InventoryStock;
import com.globaltrade.core.entity.Status;
import com.globaltrade.core.entity.Vendor;
import com.globaltrade.core.entity.Warehouse;
import com.globaltrade.core.exception.InsufficientStockException;
import com.globaltrade.core.service.InventoryService;
import com.globaltrade.ejb.interceptor.AuditLogInterceptor;

import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;
import jakarta.ejb.TransactionManagement;
import jakarta.ejb.TransactionManagementType;
import jakarta.interceptor.Interceptors;
import jakarta.persistence.EntityManager;
import jakarta.persistence.LockModeType;
import jakarta.persistence.PersistenceContext;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

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
    public List<CategoryDTO> getAllCategories() {
        return em.createQuery("SELECT new com.globaltrade.core.dto.CategoryDTO(c.id, c.name) FROM Category c", CategoryDTO.class).getResultList();
    }

    @Override
    public List<VendorDTO> getAllVendors() {
        return em.createQuery("SELECT new com.globaltrade.core.dto.VendorDTO(v.id, c.companyName) FROM Vendor v JOIN v.company c", VendorDTO.class).getResultList();
    }

    @Override
    public List<ProductDTO> getAllProducts() {
        List<InventoryItem> items = em.createQuery("SELECT i FROM InventoryItem i JOIN FETCH i.category JOIN FETCH i.vendor v JOIN FETCH v.company", InventoryItem.class).getResultList();
        return items.stream().map(i -> new ProductDTO(
                i.getId(),
                i.getSku(),
                i.getName(),
                i.getCategory() != null ? i.getCategory().getName() : "Uncategorized",
                i.getWeight(),
                i.getReorderLevel(),
                (i.getVendor() != null && i.getVendor().getCompany() != null) ? i.getVendor().getCompany().getCompanyName() : "Unknown",
                i.getImageUrl()
        )).collect(Collectors.toList());
    }

    @Override
    public List<WarehouseDTO> getAllWarehouses() {
        List<Warehouse> warehouses = em.createQuery("SELECT w FROM Warehouse w ORDER BY w.name ASC", Warehouse.class).getResultList();
        return warehouses.stream().map(w -> new WarehouseDTO(w.getId(), w.getName())).collect(Collectors.toList());
    }

    @Override
    public List<StockDTO> getAllStock() {
        List<InventoryStock> stocks = em.createQuery("SELECT s FROM InventoryStock s JOIN FETCH s.item i LEFT JOIN FETCH i.category JOIN FETCH s.warehouse JOIN FETCH s.status", InventoryStock.class).getResultList();
        return stocks.stream().map(s -> new StockDTO(
                s.getId(),
                s.getItem() != null ? s.getItem().getId() : s.getId(),
                s.getItem() != null ? s.getItem().getSku() : "SKU-" + s.getId(),
                s.getItem() != null ? s.getItem().getName() : "Unknown",
                (s.getItem() != null && s.getItem().getCategory() != null) ? s.getItem().getCategory().getName() : "General",
                s.getWarehouse() != null ? s.getWarehouse().getName() : "Unknown",
                s.getStockQty(),
                s.getUnitPrice(),
                s.getStatus() != null ? s.getStatus().getName() : "Unknown",
                s.getItem() != null ? s.getItem().getReorderLevel() : 0,
                s.getLastUpdated()
        )).collect(Collectors.toList());
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public void addOrUpdateStock(Long productId, Long warehouseId, Integer qty, BigDecimal unitPrice, Integer reorderLevel, Long statusId) {

        InventoryItem item = em.find(InventoryItem.class, productId);
        if (item != null && reorderLevel != null) {
            item.setReorderLevel(reorderLevel);
            em.merge(item);
        }

        Status status = resolveStatusForQty(qty, item != null ? item.getReorderLevel() : null);

        List<InventoryStock> stocks = em.createQuery(
                "SELECT s FROM InventoryStock s WHERE s.item.id = :itemId AND s.warehouse.id = :warehouseId AND s.unitPrice = :unitPrice", 
                InventoryStock.class)
                .setParameter("itemId", productId)
                .setParameter("warehouseId", warehouseId)
                .setParameter("unitPrice", unitPrice)
                .getResultList();

        if (stocks.isEmpty()) {
            InventoryStock newStock = new InventoryStock();
            newStock.setItem(item);
            newStock.setWarehouse(em.find(Warehouse.class, warehouseId));
            newStock.setStockQty(qty);
            newStock.setUnitPrice(unitPrice);
            newStock.setStatus(status);
            em.persist(newStock);
        } else {
            InventoryStock existingStock = stocks.get(0);
            existingStock.setStockQty(existingStock.getStockQty() + qty);
            existingStock.setStatus(resolveStatusForQty(existingStock.getStockQty(), item != null ? item.getReorderLevel() : null));
            em.merge(existingStock);
        }
    }

    private Status resolveStatusForQty(Integer qty, Integer reorderLevel) {
        String statusName = "IN_STOCK";
        if (qty == 0) {
            statusName = "OUT_OF_STOCK";
        } else if (qty <= (reorderLevel != null ? reorderLevel : 0)) {
            statusName = "LOW_STOCK";
        }
        
        try {
            return em.createQuery("SELECT s FROM Status s WHERE s.name = :name", Status.class)
                     .setParameter("name", statusName)
                     .getSingleResult();
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public void quickUpdateStock(Long stockId, Integer newQty) {
        InventoryStock stock = em.find(InventoryStock.class, stockId);
        if (stock != null) {
            stock.setStockQty(newQty);
            Integer reorderLevel = (stock.getItem() != null) ? stock.getItem().getReorderLevel() : 0;
            stock.setStatus(resolveStatusForQty(newQty, reorderLevel));
            em.merge(stock);
        }
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public void addProduct(InventoryItem item, Long categoryId, Long vendorId) {
        if (categoryId != null) {
            Category cat = em.find(Category.class, categoryId);
            item.setCategory(cat);
        }
        if (vendorId != null) {
            Vendor vendor = em.find(Vendor.class, vendorId);
            item.setVendor(vendor);
        }
        em.persist(item);
    }
}
