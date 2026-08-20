package com.globaltrade.core.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class StockDTO implements Serializable {
    private Long id;
    private String productName;
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

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
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
