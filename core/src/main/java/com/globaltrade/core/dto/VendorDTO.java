package com.globaltrade.core.dto;

import java.io.Serializable;

public class VendorDTO implements Serializable {
    private Long id;
    private String companyName;

    public VendorDTO() {}

    public VendorDTO(Long id, String companyName) {
        this.id = id;
        this.companyName = companyName;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }
}
