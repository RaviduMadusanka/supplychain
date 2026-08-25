package com.globaltrade.ejb;

import com.globaltrade.core.dto.CountryDTO;
import com.globaltrade.core.dto.WarehouseDTO;
import com.globaltrade.core.entity.Country;
import com.globaltrade.core.entity.User;
import com.globaltrade.core.entity.Warehouse;
import com.globaltrade.core.service.WarehouseService;
import com.globaltrade.ejb.interceptor.AuditLogInterceptor;

import jakarta.ejb.Local;
import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;
import jakarta.ejb.TransactionManagement;
import jakarta.ejb.TransactionManagementType;
import jakarta.interceptor.Interceptors;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.util.List;
import java.util.stream.Collectors;

@Stateless(name = "WarehouseServiceBean")
@Local(WarehouseService.class)
@TransactionManagement(TransactionManagementType.CONTAINER)
@Interceptors(AuditLogInterceptor.class)
public class WarehouseServiceBean implements WarehouseService {

    @PersistenceContext(unitName = "SupplyChainPU")
    private EntityManager em;

    @Override
    public List<CountryDTO> getAllCountries() {
        return em.createQuery("SELECT new com.globaltrade.core.dto.CountryDTO(c.id, c.name, c.vatPercentage, c.importTaxPercentage) FROM Country c ORDER BY c.name", CountryDTO.class).getResultList();
    }

    @Override
    public List<WarehouseDTO> getAllWarehouseDetails() {
        List<Warehouse> warehouses = em.createQuery("SELECT w FROM Warehouse w LEFT JOIN FETCH w.country LEFT JOIN FETCH w.user ORDER BY w.id ASC", Warehouse.class).getResultList();
        return warehouses.stream().map(w -> new WarehouseDTO(
                w.getId(),
                w.getWarehouseCode(),
                w.getName(),
                w.getLocation(),
                w.getCountry() != null ? w.getCountry().getName() : "Unknown",
                w.getCapacity(),
                w.getCurrentUtilization(),
                w.getUser() != null ? w.getUser().getFullName() : "Unassigned"
        )).collect(Collectors.toList());
    }

    @Override
    public List<WarehouseDTO> getAllWarehouses() {
        List<Warehouse> warehouses = em.createQuery("SELECT w FROM Warehouse w ORDER BY w.name ASC", Warehouse.class).getResultList();
        return warehouses.stream().map(w -> new WarehouseDTO(w.getId(), w.getName())).collect(Collectors.toList());
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public void addWarehouse(Warehouse warehouse, Long countryId, Long managerUserId) {
        if (countryId != null) {
            Country country = em.find(Country.class, countryId);
            warehouse.setCountry(country);
        }
        if (managerUserId != null) {
            User user = em.find(User.class, managerUserId);
            warehouse.setUser(user);
        }
        if (warehouse.getCurrentUtilization() == null) {
            warehouse.setCurrentUtilization(0);
        }
        em.persist(warehouse);
    }
}
