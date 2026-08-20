package com.globaltrade.core.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class OrderDTO implements Serializable {
    private Long id;
    private String orderCode;
    private Long customerId;
    private String customerName;
    private String customerEmail;
    private String customerPhone;
    private String customerAddress;
    private String countryName;
    private boolean crossBorder = false;
    private BigDecimal vatPercentage = BigDecimal.ZERO;
    private BigDecimal importTaxPercentage = BigDecimal.ZERO;
    private BigDecimal subtotal = BigDecimal.ZERO;
    private BigDecimal taxAmount = BigDecimal.ZERO;
    private BigDecimal totalAmount = BigDecimal.ZERO;
    private String statusName;
    private LocalDateTime createdAt;
    private List<OrderItemDTO> items = new ArrayList<>();
    private String shipmentCode;
    private String carrierName;
    private String shipmentStatus;

    public OrderDTO() {}

    public OrderDTO(Long id, String orderCode, Long customerId, String customerName, String customerEmail, String customerPhone, String customerAddress, BigDecimal subtotal, BigDecimal taxAmount, BigDecimal totalAmount, String statusName, LocalDateTime createdAt) {
        this.id = id;
        this.orderCode = orderCode;
        this.customerId = customerId;
        this.customerName = customerName;
        this.customerEmail = customerEmail;
        this.customerPhone = customerPhone;
        this.customerAddress = customerAddress;
        this.subtotal = subtotal != null ? subtotal : BigDecimal.ZERO;
        this.taxAmount = taxAmount != null ? taxAmount : BigDecimal.ZERO;
        this.totalAmount = totalAmount != null ? totalAmount : BigDecimal.ZERO;
        this.statusName = statusName;
        this.createdAt = createdAt;
    }

    public int getItemCount() {
        return items != null ? items.stream().mapToInt(i -> i.getQuantity() != null ? i.getQuantity() : 0).sum() : 0;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getOrderCode() { return orderCode; }
    public void setOrderCode(String orderCode) { this.orderCode = orderCode; }
    public Long getCustomerId() { return customerId; }
    public void setCustomerId(Long customerId) { this.customerId = customerId; }
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public String getCustomerEmail() { return customerEmail; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }
    public String getCustomerPhone() { return customerPhone; }
    public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; }
    public String getCustomerAddress() { return customerAddress; }
    public void setCustomerAddress(String customerAddress) { this.customerAddress = customerAddress; }
    public String getCountryName() { return countryName; }
    public void setCountryName(String countryName) { this.countryName = countryName; }
    public boolean isCrossBorder() { return crossBorder; }
    public void setCrossBorder(boolean crossBorder) { this.crossBorder = crossBorder; }
    public BigDecimal getVatPercentage() { return vatPercentage; }
    public void setVatPercentage(BigDecimal vatPercentage) { this.vatPercentage = vatPercentage; }
    public BigDecimal getImportTaxPercentage() { return importTaxPercentage; }
    public void setImportTaxPercentage(BigDecimal importTaxPercentage) { this.importTaxPercentage = importTaxPercentage; }
    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }
    public BigDecimal getTaxAmount() { return taxAmount; }
    public void setTaxAmount(BigDecimal taxAmount) { this.taxAmount = taxAmount; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public String getStatusName() { return statusName; }
    public void setStatusName(String statusName) { this.statusName = statusName; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public List<OrderItemDTO> getItems() { return items; }
    public void setItems(List<OrderItemDTO> items) { this.items = items; }
    public String getShipmentCode() { return shipmentCode; }
    public void setShipmentCode(String shipmentCode) { this.shipmentCode = shipmentCode; }
    public String getCarrierName() { return carrierName; }
    public void setCarrierName(String carrierName) { this.carrierName = carrierName; }
    public String getShipmentStatus() { return shipmentStatus; }
    public void setShipmentStatus(String shipmentStatus) { this.shipmentStatus = shipmentStatus; }
}
