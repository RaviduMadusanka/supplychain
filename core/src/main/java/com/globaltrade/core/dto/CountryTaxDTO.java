package com.globaltrade.core.dto;

import java.io.Serializable;
import java.math.BigDecimal;

public class CountryTaxDTO implements Serializable {
    private Long id;
    private String name;
    private BigDecimal vatPercentage;
    private BigDecimal importTaxPercentage;

    public CountryTaxDTO() {}

    public CountryTaxDTO(Long id, String name, BigDecimal vatPercentage, BigDecimal importTaxPercentage) {
        this.id = id;
        this.name = name;
        this.vatPercentage = vatPercentage;
        this.importTaxPercentage = importTaxPercentage;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public BigDecimal getVatPercentage() { return vatPercentage; }
    public void setVatPercentage(BigDecimal vatPercentage) { this.vatPercentage = vatPercentage; }
    public BigDecimal getImportTaxPercentage() { return importTaxPercentage; }
    public void setImportTaxPercentage(BigDecimal importTaxPercentage) { this.importTaxPercentage = importTaxPercentage; }
}