package com.globaltrade.core.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class PurchaseOrderDTO implements Serializable {
    private Long id;
    private String poCode;
    private Long warehouseId;
    private String warehouseName;
    private String warehouseCode;
    private String warehouseCountry;
    private Long vendorId;
    private String vendorName;
    private String vendorCode;
    private String vendorCountry;
    private String statusName;
    private BigDecimal subtotal = BigDecimal.ZERO;
    private BigDecimal taxAmount = BigDecimal.ZERO;
    private BigDecimal shippingAmount = BigDecimal.ZERO;
    private BigDecimal totalAmount = BigDecimal.ZERO;
    private BigDecimal vatPercentage = BigDecimal.ZERO;
    private BigDecimal importTaxPercentage = BigDecimal.ZERO;
    private boolean crossBorder = false;
    private LocalDateTime createdAt;
    private List<PurchaseOrderItemDTO> items = new ArrayList<>();

    public PurchaseOrderDTO() {}

    public PurchaseOrderDTO(Long id, String poCode, Long warehouseId, String warehouseName, String warehouseCode, String warehouseCountry, Long vendorId, String vendorName, String vendorCode, String vendorCountry, String statusName, BigDecimal subtotal, BigDecimal taxAmount, BigDecimal totalAmount, LocalDateTime createdAt) {
        this.id = id;
        this.poCode = poCode;
        this.warehouseId = warehouseId;
        this.warehouseName = warehouseName;
        this.warehouseCode = warehouseCode;
        this.warehouseCountry = warehouseCountry;
        this.vendorId = vendorId;
        this.vendorName = vendorName;
        this.vendorCode = vendorCode;
        this.vendorCountry = vendorCountry;
        this.statusName = statusName;
        this.subtotal = subtotal != null ? subtotal : BigDecimal.ZERO;
        this.taxAmount = taxAmount != null ? taxAmount : BigDecimal.ZERO;
        this.totalAmount = totalAmount != null ? totalAmount : BigDecimal.ZERO;
        this.createdAt = createdAt;
    }

    public int getItemCount() {
        return items != null ? items.stream().mapToInt(i -> i.getQuantity() != null ? i.getQuantity() : 0).sum() : 0;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getPoCode() { return poCode; }
    public void setPoCode(String poCode) { this.poCode = poCode; }
    public Long getWarehouseId() { return warehouseId; }
    public void setWarehouseId(Long warehouseId) { this.warehouseId = warehouseId; }
    public String getWarehouseName() { return warehouseName; }
    public void setWarehouseName(String warehouseName) { this.warehouseName = warehouseName; }
    public String getWarehouseCode() { return warehouseCode; }
    public void setWarehouseCode(String warehouseCode) { this.warehouseCode = warehouseCode; }
    public String getWarehouseCountry() { return warehouseCountry; }
    public void setWarehouseCountry(String warehouseCountry) { this.warehouseCountry = warehouseCountry; }
    public Long getVendorId() { return vendorId; }
    public void setVendorId(Long vendorId) { this.vendorId = vendorId; }
    public String getVendorName() { return vendorName; }
    public void setVendorName(String vendorName) { this.vendorName = vendorName; }
    public String getVendorCode() { return vendorCode; }
    public void setVendorCode(String vendorCode) { this.vendorCode = vendorCode; }
    public String getVendorCountry() { return vendorCountry; }
    public void setVendorCountry(String vendorCountry) { this.vendorCountry = vendorCountry; }
    public String getStatusName() { return statusName; }
    public void setStatusName(String statusName) { this.statusName = statusName; }
    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }
    public BigDecimal getTaxAmount() { return taxAmount; }
    public void setTaxAmount(BigDecimal taxAmount) { this.taxAmount = taxAmount; }
    public BigDecimal getShippingAmount() { return shippingAmount; }
    public void setShippingAmount(BigDecimal shippingAmount) { this.shippingAmount = shippingAmount; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public BigDecimal getVatPercentage() { return vatPercentage; }
    public void setVatPercentage(BigDecimal vatPercentage) { this.vatPercentage = vatPercentage; }
    public BigDecimal getImportTaxPercentage() { return importTaxPercentage; }
    public void setImportTaxPercentage(BigDecimal importTaxPercentage) { this.importTaxPercentage = importTaxPercentage; }
    public boolean isCrossBorder() { return crossBorder; }
    public void setCrossBorder(boolean crossBorder) { this.crossBorder = crossBorder; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public List<PurchaseOrderItemDTO> getItems() { return items; }
    public void setItems(List<PurchaseOrderItemDTO> items) { this.items = items; }
}
