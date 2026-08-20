package com.globaltrade.core.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class VendorDTO implements Serializable {
    private Long id;
    private String vendorCode;
    private String companyName;
    private String contactPerson;
    private String email;
    private String phone;
    private Long countryId;
    private String countryName;
    private BigDecimal rating;
    private String statusName;
    private LocalDateTime createdAt;

    public VendorDTO() {}

    public VendorDTO(Long id, String companyName) {
        this.id = id;
        this.companyName = companyName;
        this.vendorCode = "VEN-" + String.format("%03d", id != null ? id : 0);
    }

    public VendorDTO(Long id, String vendorCode, String companyName, String contactPerson, 
                     String email, String phone, Long countryId, String countryName, 
                     BigDecimal rating, String statusName, LocalDateTime createdAt) {
        this.id = id;
        this.vendorCode = vendorCode;
        this.companyName = companyName;
        this.contactPerson = contactPerson;
        this.email = email;
        this.phone = phone;
        this.countryId = countryId;
        this.countryName = countryName;
        this.rating = rating;
        this.statusName = statusName;
        this.createdAt = createdAt;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getVendorCode() { 
        if (vendorCode != null && !vendorCode.isEmpty()) return vendorCode;
        return "VEN-" + String.format("%03d", id != null ? id : 0); 
    }
    public void setVendorCode(String vendorCode) { this.vendorCode = vendorCode; }

    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    public String getContactPerson() { return contactPerson; }
    public void setContactPerson(String contactPerson) { this.contactPerson = contactPerson; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public Long getCountryId() { return countryId; }
    public void setCountryId(Long countryId) { this.countryId = countryId; }

    public String getCountryName() { return countryName; }
    public void setCountryName(String countryName) { this.countryName = countryName; }

    public BigDecimal getRating() { return rating; }
    public void setRating(BigDecimal rating) { this.rating = rating; }

    public String getStatusName() { return statusName; }
    public void setStatusName(String statusName) { this.statusName = statusName; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
