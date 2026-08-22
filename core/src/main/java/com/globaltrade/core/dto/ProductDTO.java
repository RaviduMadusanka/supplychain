package com.globaltrade.core.dto;

import java.io.Serializable;
import java.math.BigDecimal;

public class ProductDTO implements Serializable {
    private Long id;
    private String sku;
    private String name;
    private String categoryName;
    private Long categoryId;
    private BigDecimal weight;
    private Integer reorderLevel;
    private String vendorCompanyName;
    private Long vendorId;
    private String imageUrl;

    public ProductDTO() {}

    public ProductDTO(Long id, String sku, String name, String categoryName, BigDecimal weight, Integer reorderLevel, String vendorCompanyName, String imageUrl) {
        this.id = id;
        this.sku = sku;
        this.name = name;
        this.categoryName = categoryName;
        this.weight = weight;
        this.reorderLevel = reorderLevel;
        this.vendorCompanyName = vendorCompanyName;
        this.imageUrl = imageUrl;
    }

    public ProductDTO(Long id, String sku, String name, BigDecimal weight, Integer reorderLevel, String imageUrl, Long categoryId, String categoryName, Long vendorId, String vendorCompanyName) {
        this.id = id;
        this.sku = sku;
        this.name = name;
        this.weight = weight;
        this.reorderLevel = reorderLevel;
        this.imageUrl = imageUrl;
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.vendorId = vendorId;
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
    public Long getCategoryId() { return categoryId; }
    public void setCategoryId(Long categoryId) { this.categoryId = categoryId; }
    public BigDecimal getWeight() { return weight; }
    public void setWeight(BigDecimal weight) { this.weight = weight; }
    public Integer getReorderLevel() { return reorderLevel; }
    public void setReorderLevel(Integer reorderLevel) { this.reorderLevel = reorderLevel; }
    public String getVendorCompanyName() { return vendorCompanyName; }
    public void setVendorCompanyName(String vendorCompanyName) { this.vendorCompanyName = vendorCompanyName; }
    public Long getVendorId() { return vendorId; }
    public void setVendorId(Long vendorId) { this.vendorId = vendorId; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}