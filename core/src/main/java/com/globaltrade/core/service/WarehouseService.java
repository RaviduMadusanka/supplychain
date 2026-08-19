package com.globaltrade.core.service;

import com.globaltrade.core.dto.CountryDTO;
import com.globaltrade.core.dto.WarehouseDTO;
import com.globaltrade.core.entity.Warehouse;
import jakarta.ejb.Local;

import java.util.List;

@Local
public interface WarehouseService {
    List<CountryDTO> getAllCountries();
    List<WarehouseDTO> getAllWarehouseDetails();
    List<WarehouseDTO> getAllWarehouses();
    void addWarehouse(Warehouse warehouse, Long countryId, Long managerUserId);
}
