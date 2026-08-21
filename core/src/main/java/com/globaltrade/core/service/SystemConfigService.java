package com.globaltrade.core.service;

import com.globaltrade.core.dto.CategoryDTO;
import com.globaltrade.core.dto.CountryTaxDTO;
import com.globaltrade.core.dto.StatusTypeDTO;
import jakarta.ejb.Local;
import java.math.BigDecimal;
import java.util.List;

@Local
public interface SystemConfigService {
    List<CategoryDTO> getAllCategories();
    void createCategory(String name, String description) throws Exception;
    void deleteCategory(Long id) throws Exception;

    List<StatusTypeDTO> getAllShipmentStatuses();
    void createShipmentStatus(String name, String description) throws Exception;
    void deleteShipmentStatus(Long id) throws Exception;

    List<CountryTaxDTO> getAllCountries();
    void updateCountryTax(Long countryId, BigDecimal vat, BigDecimal importTax) throws Exception;
}