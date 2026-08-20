package com.globaltrade.core.service;

import com.globaltrade.core.dto.VendorDTO;
import com.globaltrade.core.entity.Vendor;
import jakarta.ejb.Local;

import java.math.BigDecimal;
import java.util.List;

@Local
public interface VendorService {
    List<VendorDTO> getAllVendors();
    VendorDTO getVendorById(Long id);
    Vendor createVendor(String companyName, String contactPerson, String email, String phone, Long countryId, BigDecimal rating, Long userId) throws Exception;
    void updateVendorStatus(Long vendorId, String statusName) throws Exception;
}
