package com.globaltrade.core.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class StockDTO implements Serializable {
    private Long id;
    private Long itemId;
    private String itemSku;
    private String productName;
    private String categoryName;
    private String warehouseName;
    private Integer stockQty;
    private BigDecimal unitPrice;
    private String statusName;
    private Integer productReorderLevel;
    private LocalDateTime lastUpdated;

    public StockDTO() {}

    public StockDTO(Long id, String productName, String warehouseName, Integer stockQty, BigDecimal unitPrice, String statusName, Integer productReorderLevel, LocalDateTime lastUpdated) {
        this.id = id;
        this.productName = productName;
        this.warehouseName = warehouseName;
        this.stockQty = stockQty;
        this.unitPrice = unitPrice;
        this.statusName = statusName;
        this.productReorderLevel = productReorderLevel;
        this.lastUpdated = lastUpdated;
    }

    public StockDTO(Long id, Long itemId, String itemSku, String productName, String categoryName, String warehouseName, Integer stockQty, BigDecimal unitPrice, String statusName, Integer productReorderLevel, LocalDateTime lastUpdated) {
        this.id = id;
        this.itemId = itemId;
        this.itemSku = itemSku;
        this.productName = productName;
        this.categoryName = categoryName;
        this.warehouseName = warehouseName;
        this.stockQty = stockQty;
        this.unitPrice = unitPrice;
        this.statusName = statusName;
        this.productReorderLevel = productReorderLevel;
        this.lastUpdated = lastUpdated;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getItemId() { return itemId != null ? itemId : id; }
    public void setItemId(Long itemId) { this.itemId = itemId; }
    public String getItemSku() { return itemSku != null ? itemSku : "SKU-" + (itemId != null ? itemId : id); }
    public void setItemSku(String itemSku) { this.itemSku = itemSku; }
    public String getSku() { return getItemSku(); }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getCategoryName() { return categoryName != null ? categoryName : "General"; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    public String getWarehouseName() { return warehouseName; }
    public void setWarehouseName(String warehouseName) { this.warehouseName = warehouseName; }
    public Integer getStockQty() { return stockQty; }
    public void setStockQty(Integer stockQty) { this.stockQty = stockQty; }
    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }
    public String getStatusName() { return statusName; }
    public void setStatusName(String statusName) { this.statusName = statusName; }
    public String getStatus() { return statusName; }
    public Integer getQuantity() { return stockQty; }
    public Integer getProductReorderLevel() { return productReorderLevel; }
    public void setProductReorderLevel(Integer productReorderLevel) { this.productReorderLevel = productReorderLevel; }
    public LocalDateTime getLastUpdated() { return lastUpdated; }
    public void setLastUpdated(LocalDateTime lastUpdated) { this.lastUpdated = lastUpdated; }
}