package com.globaltrade.core.dto;

import java.io.Serializable;
import java.math.BigDecimal;

public class CountryDTO implements Serializable {
    private Long id;
    private String name;
    private String countryCode;
    private BigDecimal vatPercentage = BigDecimal.ZERO;
    private BigDecimal importTaxPercentage = BigDecimal.ZERO;

    public CountryDTO() {}

    public CountryDTO(Long id, String name) {
        this.id = id;
        this.name = name;
    }

    public CountryDTO(Long id, String name, BigDecimal vatPercentage, BigDecimal importTaxPercentage) {
        this.id = id;
        this.name = name;
        this.vatPercentage = vatPercentage != null ? vatPercentage : BigDecimal.ZERO;
        this.importTaxPercentage = importTaxPercentage != null ? importTaxPercentage : BigDecimal.ZERO;
    }

    public CountryDTO(Long id, String name, String countryCode, BigDecimal vatPercentage, BigDecimal importTaxPercentage) {
        this.id = id;
        this.name = name;
        this.countryCode = countryCode;
        this.vatPercentage = vatPercentage != null ? vatPercentage : BigDecimal.ZERO;
        this.importTaxPercentage = importTaxPercentage != null ? importTaxPercentage : BigDecimal.ZERO;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getCountryCode() { return countryCode != null ? countryCode : ""; }
    public void setCountryCode(String countryCode) { this.countryCode = countryCode; }
    public BigDecimal getVatPercentage() { return vatPercentage; }
    public void setVatPercentage(BigDecimal vatPercentage) { this.vatPercentage = vatPercentage; }
    public BigDecimal getImportTaxPercentage() { return importTaxPercentage; }
    public void setImportTaxPercentage(BigDecimal importTaxPercentage) { this.importTaxPercentage = importTaxPercentage; }
}
