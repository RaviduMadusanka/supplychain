package com.globaltrade.core.service;

import com.globaltrade.core.dto.ProductDTO;
import com.globaltrade.core.dto.VendorDTO;
import com.globaltrade.core.dto.VendorPerformanceDTO;
import com.globaltrade.core.entity.Vendor;
import jakarta.ejb.Local;

import java.math.BigDecimal;
import java.util.List;

@Local
public interface VendorService {
    List<VendorDTO> getAllVendors();
    VendorDTO getVendorById(Long id);
    VendorDTO getVendorByUserId(Long userId);
    List<ProductDTO> getProductsByVendorId(Long vendorId);
    void createVendorProduct(Long vendorId, String sku, String name, Long categoryId, BigDecimal weight, Integer reorderLevel, String imageUrl) throws Exception;
    VendorPerformanceDTO getLatestPerformanceByVendorId(Long vendorId);
    Vendor createVendor(String companyName, String contactPerson, String email, String phone, Long countryId, BigDecimal rating, Long userId) throws Exception;
    void updateVendorStatus(Long vendorId, String statusName) throws Exception;
}