package com.globaltrade.ejb;

import com.globaltrade.core.dto.ProductDTO;
import com.globaltrade.core.dto.VendorDTO;
import com.globaltrade.core.dto.VendorPerformanceDTO;
import com.globaltrade.core.entity.AccountStatus;
import com.globaltrade.core.entity.Category;
import com.globaltrade.core.entity.Company;
import com.globaltrade.core.entity.Country;
import com.globaltrade.core.entity.InventoryItem;
import com.globaltrade.core.entity.InventoryStock;
import com.globaltrade.core.entity.Status;
import com.globaltrade.core.entity.User;
import com.globaltrade.core.entity.Vendor;
import com.globaltrade.core.entity.VendorPerformance;
import com.globaltrade.core.entity.Warehouse;
import com.globaltrade.core.service.VendorService;
import com.globaltrade.ejb.interceptor.AuditLogInterceptor;
import com.globaltrade.ejb.interceptor.ExceptionLoggingInterceptor;
import com.globaltrade.ejb.interceptor.PerformanceMonitorInterceptor;
import com.globaltrade.ejb.interceptor.VendorDataValidationInterceptor;
import jakarta.ejb.Stateless;
import jakarta.interceptor.Interceptors;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Stateless
@Interceptors({AuditLogInterceptor.class, PerformanceMonitorInterceptor.class, ExceptionLoggingInterceptor.class})
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
    public VendorDTO getVendorByUserId(Long userId) {
        if (userId == null) return null;
        try {
            List<Vendor> list = em.createQuery(
                    "SELECT v FROM Vendor v LEFT JOIN FETCH v.company c LEFT JOIN FETCH c.country LEFT JOIN FETCH v.status WHERE v.user.id = :uid",
                    Vendor.class)
                    .setParameter("uid", userId)
                    .setMaxResults(1)
                    .getResultList();

            if (list.isEmpty()) {
                // Fallback to first vendor if not specifically linked
                List<Vendor> all = em.createQuery("SELECT v FROM Vendor v LEFT JOIN FETCH v.company c LEFT JOIN FETCH c.country LEFT JOIN FETCH v.status ORDER BY v.id ASC", Vendor.class)
                        .setMaxResults(1)
                        .getResultList();
                if (all.isEmpty()) return null;
                Vendor v = all.get(0);
                return getVendorById(v.getId());
            }

            Vendor v = list.get(0);
            return getVendorById(v.getId());
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<ProductDTO> getProductsByVendorId(Long vendorId) {
        if (vendorId == null) return new ArrayList<>();
        List<InventoryItem> items = em.createQuery(
                "SELECT p FROM InventoryItem p LEFT JOIN FETCH p.category c LEFT JOIN FETCH p.vendor v LEFT JOIN FETCH v.company comp WHERE p.vendor.id = :vid ORDER BY p.id DESC",
                InventoryItem.class)
                .setParameter("vid", vendorId)
                .getResultList();

        List<ProductDTO> dtos = new ArrayList<>();
        for (InventoryItem item : items) {
            String catName = (item.getCategory() != null) ? item.getCategory().getName() : "General";
            Long catId = (item.getCategory() != null) ? item.getCategory().getId() : null;
            String compName = (item.getVendor() != null && item.getVendor().getCompany() != null) ? item.getVendor().getCompany().getCompanyName() : "Vendor";
            
            dtos.add(new ProductDTO(
                    item.getId(),
                    item.getSku(),
                    item.getName(),
                    item.getWeight(),
                    item.getReorderLevel(),
                    item.getImageUrl(),
                    catId,
                    catName,
                    item.getVendor() != null ? item.getVendor().getId() : null,
                    compName
            ));
        }
        return dtos;
    }

    @Override
    @Interceptors(VendorDataValidationInterceptor.class)
    public void createVendorProduct(Long vendorId, String sku, String name, Long categoryId, BigDecimal weight, Integer reorderLevel, String imageUrl) throws Exception {
        if (sku == null || sku.trim().isEmpty() || name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("SKU and Product Name are required.");
        }

        Vendor vendor = em.find(Vendor.class, vendorId);
        Category category = (categoryId != null) ? em.find(Category.class, categoryId) : null;

        InventoryItem item = new InventoryItem();
        item.setSku(sku.trim().toUpperCase());
        item.setName(name.trim());
        item.setWeight(weight != null ? weight : BigDecimal.ONE);
        item.setReorderLevel(reorderLevel != null ? reorderLevel : 10);
        item.setImageUrl(imageUrl != null && !imageUrl.trim().isEmpty() ? imageUrl.trim() : "/images/default_product.png");
        item.setVendor(vendor);
        item.setCategory(category);
        em.persist(item);
        em.flush();

        try {
            Warehouse wh = em.find(Warehouse.class, 1L);
            if (wh != null) {
                Status status = em.find(Status.class, 1L);
                InventoryStock stock = new InventoryStock();
                stock.setItem(item);
                stock.setWarehouse(wh);
                stock.setStockQty(50);
                stock.setUnitPrice(new BigDecimal("100.00"));
                stock.setStatus(status);
                stock.setLastUpdated(LocalDateTime.now());
                em.persist(stock);
            }
        } catch (Exception ignored) {}
    }

    @Override
    public VendorPerformanceDTO getLatestPerformanceByVendorId(Long vendorId) {
        if (vendorId == null) return null;
        try {
            List<VendorPerformance> list = em.createQuery(
                    "SELECT vp FROM VendorPerformance vp WHERE vp.vendor.id = :vid ORDER BY vp.id DESC",
                    VendorPerformance.class)
                    .setParameter("vid", vendorId)
                    .setMaxResults(1)
                    .getResultList();

            if (!list.isEmpty()) {
                VendorPerformance vp = list.get(0);
                String vName = (vp.getVendor() != null && vp.getVendor().getCompany() != null) ? vp.getVendor().getCompany().getCompanyName() : "Vendor";
                return new VendorPerformanceDTO(
                        vp.getId(),
                        vp.getVendor() != null ? vp.getVendor().getId() : vendorId,
                        vName,
                        vp.getEvaluationDate(),
                        vp.getOnTimeDeliveryRate(),
                        vp.getQualityScore(),
                        vp.getResponseTimeHours(),
                        vp.getOverallRating()
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new VendorPerformanceDTO(1L, vendorId, "Vendor", null, new BigDecimal("98.50"), new BigDecimal("92.00"), new BigDecimal("4.50"), new BigDecimal("4.60"));
    }

    @Override
    @Interceptors(VendorDataValidationInterceptor.class)
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

        User user = null;
        if (userId != null) {
            user = em.find(User.class, userId);
        }

        Vendor vendor = new Vendor();
        vendor.setCompany(company);
        vendor.setStatus(status);
        vendor.setUser(user);
        vendor.setRating(rating != null ? rating : new BigDecimal("5.00"));
        vendor.setCreatedAt(LocalDateTime.now());
        
        String autoCode = "VEN-" + System.currentTimeMillis() % 10000;
        vendor.setVendorCode(autoCode);

        em.persist(vendor);
        em.flush();

        return vendor;
    }

    @Override
    public void updateVendorStatus(Long vendorId, String statusName) throws Exception {
        Vendor v = em.find(Vendor.class, vendorId);
        if (v == null) {
            throw new IllegalArgumentException("Vendor not found with ID: " + vendorId);
        }

        AccountStatus status = em.createQuery("SELECT a FROM AccountStatus a WHERE UPPER(a.name) = :sname", AccountStatus.class)
                .setParameter("sname", statusName.toUpperCase())
                .getSingleResult();

        v.setStatus(status);
        em.merge(v);
    }
}