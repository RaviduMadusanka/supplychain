package com.globaltrade.core.dto;

import java.io.Serializable;
import java.math.BigDecimal;

public class ProductDTO implements Serializable {
    private Long id;
    private String sku;
    private String name;
    private String categoryName;
    private BigDecimal weight;
    private Integer reorderLevel;
    private String vendorCompanyName;
    
    // New fields
    private BigDecimal unitPrice;
    private String unitOfMeasure;
    private String description;
    private String imageUrl;

    public ProductDTO() {}

    public ProductDTO(Long id, String sku, String name, String categoryName, BigDecimal weight, Integer reorderLevel, String vendorCompanyName) {
        this.id = id;
        this.sku = sku;
        this.name = name;
        this.categoryName = categoryName;
        this.weight = weight;
        this.reorderLevel = reorderLevel;
        this.vendorCompanyName = vendorCompanyName;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getSku() { return sku; }
    public void setSku(String sku) { this.sku = sku; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    public BigDecimal getWeight() { return weight; }
    public void setWeight(BigDecimal weight) { this.weight = weight; }
    public Integer getReorderLevel() { return reorderLevel; }
    public void setReorderLevel(Integer reorderLevel) { this.reorderLevel = reorderLevel; }
    public String getVendorCompanyName() { return vendorCompanyName; }
    public void setVendorCompanyName(String vendorCompanyName) { this.vendorCompanyName = vendorCompanyName; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }
    public String getUnitOfMeasure() { return unitOfMeasure; }
    public void setUnitOfMeasure(String unitOfMeasure) { this.unitOfMeasure = unitOfMeasure; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}
