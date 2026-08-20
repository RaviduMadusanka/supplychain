package com.globaltrade.core.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;

@Entity
@Table(name = "countries")
public class Country implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false, length = 100)
    private String name;

    @Column(name = "vat_percentage", precision = 5, scale = 2)
    private BigDecimal vatPercentage = BigDecimal.ZERO;

    @Column(name = "import_tax_percentage", precision = 5, scale = 2)
    private BigDecimal importTaxPercentage = BigDecimal.ZERO;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public BigDecimal getVatPercentage() { return vatPercentage; }
    public void setVatPercentage(BigDecimal vatPercentage) { this.vatPercentage = vatPercentage; }

    public BigDecimal getImportTaxPercentage() { return importTaxPercentage; }
    public void setImportTaxPercentage(BigDecimal importTaxPercentage) { this.importTaxPercentage = importTaxPercentage; }
}
