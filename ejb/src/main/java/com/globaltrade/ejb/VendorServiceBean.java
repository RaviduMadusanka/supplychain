package com.globaltrade.ejb;

import com.globaltrade.core.dto.VendorDTO;
import com.globaltrade.core.entity.AccountStatus;
import com.globaltrade.core.entity.Company;
import com.globaltrade.core.entity.Country;
import com.globaltrade.core.entity.User;
import com.globaltrade.core.entity.Vendor;
import com.globaltrade.core.service.VendorService;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Stateless
public class VendorServiceBean implements VendorService {

    @PersistenceContext(unitName = "SupplyChainPU")
    private EntityManager em;

    @Override
    public List<VendorDTO> getAllVendors() {
        List<Vendor> vendors = em.createQuery(
                "SELECT v FROM Vendor v LEFT JOIN FETCH v.company c LEFT JOIN FETCH c.country LEFT JOIN FETCH v.status ORDER BY v.id DESC",
                Vendor.class
        ).getResultList();

        List<VendorDTO> dtos = new ArrayList<>();
        for (Vendor v : vendors) {
            String compName = (v.getCompany() != null) ? v.getCompany().getCompanyName() : "Vendor #" + v.getId();
            String contact  = (v.getCompany() != null) ? v.getCompany().getContactPerson() : "";
            String email    = (v.getCompany() != null) ? v.getCompany().getEmail() : "";
            String phone    = (v.getCompany() != null) ? v.getCompany().getPhone() : "";
            Long countryId  = (v.getCompany() != null && v.getCompany().getCountry() != null) ? v.getCompany().getCountry().getId() : null;
            String countryName = (v.getCompany() != null && v.getCompany().getCountry() != null) ? v.getCompany().getCountry().getName() : "Global";
            BigDecimal rating  = (v.getRating() != null) ? v.getRating() : new BigDecimal("5.00");
            String statusName  = (v.getStatus() != null) ? v.getStatus().getName() : "ACTIVE";
            String code        = (v.getVendorCode() != null && !v.getVendorCode().isEmpty()) ? v.getVendorCode() : ("VEN-" + String.format("%03d", v.getId()));

            dtos.add(new VendorDTO(v.getId(), code, compName, contact, email, phone, countryId, countryName, rating, statusName, v.getCreatedAt()));
        }
        return dtos;
    }

    @Override
    public VendorDTO getVendorById(Long id) {
        if (id == null) return null;
        Vendor v = em.find(Vendor.class, id);
        if (v == null) return null;

        String compName    = (v.getCompany() != null) ? v.getCompany().getCompanyName() : "Vendor #" + v.getId();
        String contact     = (v.getCompany() != null) ? v.getCompany().getContactPerson() : "";
        String email       = (v.getCompany() != null) ? v.getCompany().getEmail() : "";
        String phone       = (v.getCompany() != null) ? v.getCompany().getPhone() : "";
        Long countryId     = (v.getCompany() != null && v.getCompany().getCountry() != null) ? v.getCompany().getCountry().getId() : null;
        String countryName = (v.getCompany() != null && v.getCompany().getCountry() != null) ? v.getCompany().getCountry().getName() : "Global";
        BigDecimal rating  = (v.getRating() != null) ? v.getRating() : new BigDecimal("5.00");
        String statusName  = (v.getStatus() != null) ? v.getStatus().getName() : "ACTIVE";
        String code        = (v.getVendorCode() != null && !v.getVendorCode().isEmpty()) ? v.getVendorCode() : ("VEN-" + String.format("%03d", v.getId()));

        return new VendorDTO(v.getId(), code, compName, contact, email, phone, countryId, countryName, rating, statusName, v.getCreatedAt());
    }

    @Override
    public Vendor createVendor(String companyName, String contactPerson, String email, String phone,
                               Long countryId, BigDecimal rating, Long userId) throws Exception {
        if (companyName == null || companyName.trim().isEmpty()) {
            throw new IllegalArgumentException("Company name is required.");
        }

        Country country = null;
        if (countryId != null) {
            country = em.find(Country.class, countryId);
        }

        Company company = new Company();
        company.setCompanyName(companyName.trim());
        company.setContactPerson(contactPerson != null ? contactPerson.trim() : "");
        company.setEmail(email != null ? email.trim() : "");
        company.setPhone(phone != null ? phone.trim() : "");
        company.setCountry(country);
        em.persist(company);

        AccountStatus status = null;
        try {
            status = em.createQuery("SELECT a FROM AccountStatus a WHERE UPPER(a.name) = 'ACTIVE'", AccountStatus.class)
                    .setMaxResults(1)
                    .getSingleResult();
        } catch (Exception e) {
            status = new AccountStatus();
            status.setName("ACTIVE");
            status.setDescription("Active account status");
            em.persist(status);
        }

        // Resolve session user by id
        User createdByUser = null;
        if (userId != null) {
            createdByUser = em.find(User.class, userId);
        }

        Vendor vendor = new Vendor();
        vendor.setCompany(company);
        vendor.setStatus(status);
        vendor.setRating(rating != null ? rating : new BigDecimal("5.00"));
        vendor.setVendorCode("VEN-" + (System.currentTimeMillis() % 100000));
        vendor.setUser(createdByUser);

        em.persist(vendor);
        em.flush();

        vendor.setVendorCode("VEN-" + String.format("%03d", vendor.getId()));
        em.merge(vendor);

        return vendor;
    }

    @Override
    public void updateVendorStatus(Long vendorId, String statusName) throws Exception {
        if (vendorId == null || statusName == null) return;
        Vendor vendor = em.find(Vendor.class, vendorId);
        if (vendor == null) {
            throw new IllegalArgumentException("Vendor not found with ID: " + vendorId);
        }

        AccountStatus status;
        try {
            status = em.createQuery("SELECT a FROM AccountStatus a WHERE UPPER(a.name) = :name", AccountStatus.class)
                    .setParameter("name", statusName.toUpperCase())
                    .setMaxResults(1)
                    .getSingleResult();
        } catch (Exception e) {
            status = new AccountStatus();
            status.setName(statusName.toUpperCase());
            em.persist(status);
        }

        vendor.setStatus(status);
        em.merge(vendor);
    }
}