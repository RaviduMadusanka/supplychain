package com.globaltrade.ejb;

import com.globaltrade.core.dto.CategoryDTO;
import com.globaltrade.core.dto.CountryTaxDTO;
import com.globaltrade.core.dto.StatusTypeDTO;
import com.globaltrade.core.entity.Category;
import com.globaltrade.core.entity.Country;
import com.globaltrade.core.entity.ShipmentStatus;
import com.globaltrade.core.service.SystemConfigService;
import com.globaltrade.ejb.interceptor.AuditLogInterceptor;
import com.globaltrade.ejb.interceptor.ExceptionLoggingInterceptor;
import com.globaltrade.ejb.interceptor.PerformanceMonitorInterceptor;
import jakarta.ejb.Local;
import jakarta.ejb.Stateless;
import jakarta.interceptor.Interceptors;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Stateless(name = "SystemConfigServiceBean")
@Local(SystemConfigService.class)
@Interceptors({AuditLogInterceptor.class, PerformanceMonitorInterceptor.class, ExceptionLoggingInterceptor.class})
public class SystemConfigServiceBean implements SystemConfigService {

    @PersistenceContext(unitName = "SupplyChainPU")
    private EntityManager em;

    @Override
    public List<CategoryDTO> getAllCategories() {
        List<Category> categories = em.createQuery("SELECT c FROM Category c ORDER BY c.id ASC", Category.class).getResultList();
        List<CategoryDTO> dtos = new ArrayList<>();

        for (Category c : categories) {
            Long count = em.createQuery("SELECT COUNT(p) FROM InventoryItem p WHERE p.category.id = :catId", Long.class)
                    .setParameter("catId", c.getId())
                    .getSingleResult();
            dtos.add(new CategoryDTO(c.getId(), c.getName(), c.getDescription(), count));
        }
        return dtos;
    }

    @Override
    public void createCategory(String name, String description) throws Exception {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Category name is required");
        }
        Category cat = new Category();
        cat.setName(name.trim());
        cat.setDescription(description != null ? description.trim() : "");
        em.persist(cat);
    }

    @Override
    public void deleteCategory(Long id) throws Exception {
        Category cat = em.find(Category.class, id);
        if (cat != null) {
            Long count = em.createQuery("SELECT COUNT(p) FROM InventoryItem p WHERE p.category.id = :catId", Long.class)
                    .setParameter("catId", id)
                    .getSingleResult();
            if (count > 0) {
                throw new IllegalStateException("Cannot delete category because " + count + " product(s) are assigned to it.");
            }
            em.remove(cat);
        }
    }

    @Override
    public List<StatusTypeDTO> getAllShipmentStatuses() {
        List<ShipmentStatus> statuses = em.createQuery("SELECT s FROM ShipmentStatus s ORDER BY s.id ASC", ShipmentStatus.class).getResultList();
        List<StatusTypeDTO> dtos = new ArrayList<>();
        for (ShipmentStatus s : statuses) {
            dtos.add(new StatusTypeDTO(s.getId(), s.getName(), s.getDescription(), "SHIPMENT"));
        }
        return dtos;
    }

    @Override
    public void createShipmentStatus(String name, String description) throws Exception {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Status name is required");
        }
        ShipmentStatus status = new ShipmentStatus();
        status.setName(name.trim().toUpperCase().replace(" ", "_"));
        status.setDescription(description != null ? description.trim() : "");
        em.persist(status);
    }

    @Override
    public void deleteShipmentStatus(Long id) throws Exception {
        ShipmentStatus status = em.find(ShipmentStatus.class, id);
        if (status != null) {
            em.remove(status);
        }
    }

    @Override
    public List<CountryTaxDTO> getAllCountries() {
        List<Country> countries = em.createQuery("SELECT c FROM Country c ORDER BY c.id ASC", Country.class).getResultList();
        List<CountryTaxDTO> dtos = new ArrayList<>();
        for (Country c : countries) {
            dtos.add(new CountryTaxDTO(c.getId(), c.getName(), c.getVatPercentage(), c.getImportTaxPercentage()));
        }
        return dtos;
    }

    @Override
    public void createCountry(String name, BigDecimal vat, BigDecimal importTax) throws Exception {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Country name is required.");
        }

        String countryName = name.trim();
        List<Country> existing = em.createQuery("SELECT c FROM Country c WHERE LOWER(c.name) = LOWER(:name)", Country.class)
                .setParameter("name", countryName)
                .getResultList();

        if (!existing.isEmpty()) {
            throw new IllegalArgumentException("Country '" + countryName + "' is already registered in the system.");
        }

        Country country = new Country();
        country.setName(countryName);
        country.setVatPercentage(vat != null ? vat : BigDecimal.ZERO);
        country.setImportTaxPercentage(importTax != null ? importTax : BigDecimal.ZERO);
        em.persist(country);
    }

    @Override
    public void updateCountryTax(Long countryId, BigDecimal vat, BigDecimal importTax) throws Exception {
        Country country = em.find(Country.class, countryId);
        if (country != null) {
            country.setVatPercentage(vat != null ? vat : BigDecimal.ZERO);
            country.setImportTaxPercentage(importTax != null ? importTax : BigDecimal.ZERO);
            em.merge(country);
        }
    }
}