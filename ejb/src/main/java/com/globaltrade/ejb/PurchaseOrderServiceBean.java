package com.globaltrade.ejb;

import com.globaltrade.core.dto.PurchaseOrderDTO;
import com.globaltrade.core.dto.PurchaseOrderItemDTO;
import com.globaltrade.core.entity.Country;
import com.globaltrade.core.entity.InventoryItem;
import com.globaltrade.core.entity.InventoryStock;
import com.globaltrade.core.entity.OrderStatus;
import com.globaltrade.core.entity.PurchaseOrder;
import com.globaltrade.core.entity.PurchaseOrderItem;
import com.globaltrade.core.entity.Status;
import com.globaltrade.core.entity.Vendor;
import com.globaltrade.core.entity.Warehouse;
import com.globaltrade.ejb.interceptor.AuditLogInterceptor;
import com.globaltrade.core.service.PurchaseOrderService;
import jakarta.annotation.Resource;
import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionManagement;
import jakarta.ejb.TransactionManagementType;
import jakarta.interceptor.Interceptors;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.UserTransaction;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Stateless
@TransactionManagement(TransactionManagementType.BEAN)
@Interceptors(AuditLogInterceptor.class)
public class PurchaseOrderServiceBean implements PurchaseOrderService {

    @PersistenceContext(unitName = "SupplyChainPU")
    private EntityManager em;

    @Resource
    private UserTransaction userTransaction;

    @Override
    public List<PurchaseOrderDTO> getAllPurchaseOrders() {
        List<PurchaseOrder> pos = em.createQuery(
                "SELECT po FROM PurchaseOrder po " +
                "LEFT JOIN FETCH po.warehouse w LEFT JOIN FETCH w.country " +
                "LEFT JOIN FETCH po.vendor v LEFT JOIN FETCH v.company vc LEFT JOIN FETCH vc.country " +
                "LEFT JOIN FETCH po.orderStatus " +
                "ORDER BY po.id DESC", PurchaseOrder.class).getResultList();

        List<PurchaseOrderDTO> dtos = new ArrayList<>();
        for (PurchaseOrder po : pos) {
            dtos.add(mapToDTO(po));
        }
        return dtos;
    }

    @Override
    public List<PurchaseOrderDTO> getPurchaseOrdersForWarehouse(Long warehouseId) {
        List<PurchaseOrder> pos = em.createQuery(
                "SELECT po FROM PurchaseOrder po " +
                "LEFT JOIN FETCH po.warehouse w LEFT JOIN FETCH w.country " +
                "LEFT JOIN FETCH po.vendor v LEFT JOIN FETCH v.company vc LEFT JOIN FETCH vc.country " +
                "LEFT JOIN FETCH po.orderStatus " +
                "WHERE po.warehouse.id = :wid ORDER BY po.id DESC", PurchaseOrder.class)
                .setParameter("wid", warehouseId)
                .getResultList();

        List<PurchaseOrderDTO> dtos = new ArrayList<>();
        for (PurchaseOrder po : pos) {
            dtos.add(mapToDTO(po));
        }
        return dtos;
    }

    @Override
    public List<PurchaseOrderDTO> getPurchaseOrdersForVendor(Long vendorId) {
        List<PurchaseOrder> pos = em.createQuery(
                "SELECT po FROM PurchaseOrder po " +
                "LEFT JOIN FETCH po.warehouse w LEFT JOIN FETCH w.country " +
                "LEFT JOIN FETCH po.vendor v LEFT JOIN FETCH v.company vc LEFT JOIN FETCH vc.country " +
                "LEFT JOIN FETCH po.orderStatus " +
                "WHERE po.vendor.id = :vid ORDER BY po.id DESC", PurchaseOrder.class)
                .setParameter("vid", vendorId)
                .getResultList();

        List<PurchaseOrderDTO> dtos = new ArrayList<>();
        for (PurchaseOrder po : pos) {
            dtos.add(mapToDTO(po));
        }
        return dtos;
    }

    @Override
    public PurchaseOrderDTO getPurchaseOrderDetails(Long poId) {
        PurchaseOrder po = em.find(PurchaseOrder.class, poId);
        if (po == null) return null;
        return mapToDTO(po);
    }

    @Override
    public void createPurchaseOrder(Long warehouseId, Long vendorId, Map<Long, Integer> productQuantities) {
        try {
            userTransaction.begin();

            Warehouse warehouse = em.find(Warehouse.class, warehouseId);
            if (warehouse == null) {
                throw new IllegalArgumentException("Warehouse not found: " + warehouseId);
            }

            Vendor vendor = em.find(Vendor.class, vendorId);
            if (vendor == null) {
                throw new IllegalArgumentException("Vendor not found: " + vendorId);
            }

            OrderStatus pendingStatus = getOrCreateOrderStatus("PENDING", "Pending vendor fulfillment");

            String poCode = "PO-" + LocalDateTime.now().getYear() + "-" + (System.currentTimeMillis() % 100000);

            PurchaseOrder po = new PurchaseOrder();
            po.setPoCode(poCode);
            po.setWarehouse(warehouse);
            po.setVendor(vendor);
            po.setOrderStatus(pendingStatus);

            em.persist(po);

            BigDecimal subtotal = BigDecimal.ZERO;

            for (Map.Entry<Long, Integer> entry : productQuantities.entrySet()) {
                Long productId = entry.getKey();
                Integer quantity = entry.getValue();

                if (quantity == null || quantity <= 0) continue;

                InventoryItem item = em.find(InventoryItem.class, productId);
                if (item == null) {
                    throw new IllegalArgumentException("Product not found: " + productId);
                }

                // Determine unit purchase price (from item or from warehouse stock)
                BigDecimal unitPrice = BigDecimal.valueOf(50.00); // default fallback
                List<InventoryStock> existingStocks = em.createQuery(
                        "SELECT s FROM InventoryStock s WHERE s.item.id = :itemId", InventoryStock.class)
                        .setParameter("itemId", item.getId())
                        .setMaxResults(1)
                        .getResultList();
                if (!existingStocks.isEmpty() && existingStocks.get(0).getUnitPrice() != null) {
                    unitPrice = existingStocks.get(0).getUnitPrice();
                }

                PurchaseOrderItem poi = new PurchaseOrderItem();
                poi.setPurchaseOrder(po);
                poi.setItem(item);
                poi.setQuantity(quantity);
                poi.setUnitPrice(unitPrice);

                em.persist(poi);

                BigDecimal lineTotal = unitPrice.multiply(BigDecimal.valueOf(quantity));
                subtotal = subtotal.add(lineTotal);
            }

            // Calculate VAT and Customs Duty
            BigDecimal vatRate = BigDecimal.ZERO;
            BigDecimal importRate = BigDecimal.ZERO;

            if (warehouse.getCountry() != null) {
                vatRate = warehouse.getCountry().getVatPercentage() != null ? warehouse.getCountry().getVatPercentage() : BigDecimal.ZERO;
                
                // If Cross-border (Vendor Country != Warehouse Country), apply import tariff
                Country vendorCountry = (vendor.getCompany() != null) ? vendor.getCompany().getCountry() : null;
                if (vendorCountry != null && !warehouse.getCountry().getId().equals(vendorCountry.getId())) {
                    importRate = warehouse.getCountry().getImportTaxPercentage() != null ? warehouse.getCountry().getImportTaxPercentage() : BigDecimal.ZERO;
                }
            }

            BigDecimal totalTaxRate = vatRate.add(importRate);
            BigDecimal taxAmount = subtotal.multiply(totalTaxRate).divide(new BigDecimal("100"), 2, RoundingMode.HALF_UP);
            BigDecimal totalAmount = subtotal.add(taxAmount);

            po.setSubtotal(subtotal);
            po.setTaxAmount(taxAmount);
            po.setTotalAmount(totalAmount);

            em.merge(po);

            userTransaction.commit();
        } catch (Exception e) {
            rollbackQuietly();
            throw new RuntimeException("Failed to create purchase order: " + e.getMessage(), e);
        }
    }

    @Override
    public void updatePurchaseOrderStatus(Long poId, String statusName) {
        try {
            userTransaction.begin();
            PurchaseOrder po = em.find(PurchaseOrder.class, poId);
            if (po != null) {
                OrderStatus status = getOrCreateOrderStatus(statusName, "Purchase order status updated to " + statusName);
                po.setOrderStatus(status);
                em.merge(po);
            }
            userTransaction.commit();
        } catch (Exception e) {
            rollbackQuietly();
            throw new RuntimeException("Failed to update purchase order status: " + e.getMessage(), e);
        }
    }

    @Override
    public void receivePurchaseOrderGoods(Long poId) {
        try {
            userTransaction.begin();
            PurchaseOrder po = em.find(PurchaseOrder.class, poId);
            if (po == null) {
                throw new IllegalArgumentException("Purchase Order not found: " + poId);
            }

            Warehouse warehouse = po.getWarehouse();
            if (warehouse == null) {
                throw new IllegalArgumentException("Purchase Order has no destination warehouse specified");
            }

            List<PurchaseOrderItem> items = em.createQuery(
                    "SELECT poi FROM PurchaseOrderItem poi JOIN FETCH poi.item WHERE poi.purchaseOrder.id = :poid", PurchaseOrderItem.class)
                    .setParameter("poid", poId)
                    .getResultList();

            for (PurchaseOrderItem poi : items) {
                InventoryItem item = poi.getItem();
                if (item == null) continue;

                // Find existing stock in target warehouse or create a new stock entry
                List<InventoryStock> stocks = em.createQuery(
                        "SELECT s FROM InventoryStock s WHERE s.item.id = :itemId AND s.warehouse.id = :whId", InventoryStock.class)
                        .setParameter("itemId", item.getId())
                        .setParameter("whId", warehouse.getId())
                        .getResultList();

                InventoryStock stock;
                if (!stocks.isEmpty()) {
                    stock = stocks.get(0);
                    stock.setStockQty(stock.getStockQty() + poi.getQuantity());
                    if (poi.getUnitPrice() != null && poi.getUnitPrice().compareTo(BigDecimal.ZERO) > 0) {
                        stock.setUnitPrice(poi.getUnitPrice());
                    }
                } else {
                    stock = new InventoryStock();
                    stock.setItem(item);
                    stock.setWarehouse(warehouse);
                    stock.setStockQty(poi.getQuantity());
                    stock.setUnitPrice(poi.getUnitPrice() != null ? poi.getUnitPrice() : BigDecimal.valueOf(50.00));
                }

                // Check reorder level status
                Integer reorderLvl = item.getReorderLevel() != null ? item.getReorderLevel() : 0;
                String stName = (stock.getStockQty() == 0) ? "OUT_OF_STOCK" : (stock.getStockQty() <= reorderLvl ? "LOW_STOCK" : "IN_STOCK");
                try {
                    Status st = em.createQuery("SELECT s FROM Status s WHERE s.name = :n", Status.class)
                            .setParameter("n", stName)
                            .getSingleResult();
                    stock.setStatus(st);
                } catch (Exception ignored) {}

                em.merge(stock);
            }

            OrderStatus completedStatus = getOrCreateOrderStatus("COMPLETED", "Goods received and restocked into warehouse inventory");
            po.setOrderStatus(completedStatus);
            em.merge(po);

            userTransaction.commit();
        } catch (Exception e) {
            rollbackQuietly();
            throw new RuntimeException("Failed to receive goods for purchase order: " + e.getMessage(), e);
        }
    }

    private PurchaseOrderDTO mapToDTO(PurchaseOrder po) {
        String whName = po.getWarehouse() != null ? po.getWarehouse().getName() : "Central Warehouse";
        String whCode = po.getWarehouse() != null ? po.getWarehouse().getWarehouseCode() : "WH-MAIN";
        String whCountry = (po.getWarehouse() != null && po.getWarehouse().getCountry() != null) ? po.getWarehouse().getCountry().getName() : "Sri Lanka";

        String vName = po.getVendor() != null && po.getVendor().getCompany() != null ? po.getVendor().getCompany().getCompanyName() : "Vendor";
        String vCode = po.getVendor() != null ? po.getVendor().getVendorCode() : "VEN-001";
        Country vCountryObj = (po.getVendor() != null && po.getVendor().getCompany() != null) ? po.getVendor().getCompany().getCountry() : null;
        String vCountry = vCountryObj != null ? vCountryObj.getName() : whCountry;

        String statusName = po.getOrderStatus() != null ? po.getOrderStatus().getName() : "PENDING";

        BigDecimal subtotal = (po.getSubtotal() != null && po.getSubtotal().compareTo(BigDecimal.ZERO) > 0) ? po.getSubtotal() : (po.getTotalAmount() != null ? po.getTotalAmount() : BigDecimal.ZERO);
        BigDecimal taxAmount = (po.getTaxAmount() != null && po.getTaxAmount().compareTo(BigDecimal.ZERO) > 0) ? po.getTaxAmount() : BigDecimal.ZERO;

        BigDecimal vatRate = (po.getWarehouse() != null && po.getWarehouse().getCountry() != null && po.getWarehouse().getCountry().getVatPercentage() != null) ? po.getWarehouse().getCountry().getVatPercentage() : BigDecimal.ZERO;
        BigDecimal importRate = BigDecimal.ZERO;

        boolean crossBorder = (po.getWarehouse() != null && po.getWarehouse().getCountry() != null && vCountryObj != null && !po.getWarehouse().getCountry().getId().equals(vCountryObj.getId()));

        if (crossBorder && po.getWarehouse().getCountry().getImportTaxPercentage() != null) {
            importRate = po.getWarehouse().getCountry().getImportTaxPercentage();
        }

        if (taxAmount.compareTo(BigDecimal.ZERO) == 0 && (vatRate.compareTo(BigDecimal.ZERO) > 0 || importRate.compareTo(BigDecimal.ZERO) > 0)) {
            BigDecimal totalRate = vatRate.add(importRate);
            taxAmount = subtotal.multiply(totalRate).divide(new BigDecimal("100"), 2, RoundingMode.HALF_UP);
        }

        BigDecimal totalAmount = (po.getTotalAmount() != null && po.getSubtotal() != null && po.getSubtotal().compareTo(BigDecimal.ZERO) > 0) ? po.getTotalAmount() : subtotal.add(taxAmount);

        PurchaseOrderDTO dto = new PurchaseOrderDTO(
                po.getId(),
                po.getPoCode(),
                po.getWarehouse() != null ? po.getWarehouse().getId() : null,
                whName,
                whCode,
                whCountry,
                po.getVendor() != null ? po.getVendor().getId() : null,
                vName,
                vCode,
                vCountry,
                statusName,
                subtotal,
                taxAmount,
                totalAmount,
                po.getCreatedAt()
        );

        dto.setVatPercentage(vatRate);
        dto.setImportTaxPercentage(importRate);
        dto.setCrossBorder(crossBorder);

        List<PurchaseOrderItem> items = em.createQuery(
                "SELECT poi FROM PurchaseOrderItem poi JOIN FETCH poi.item WHERE poi.purchaseOrder.id = :poid", PurchaseOrderItem.class)
                .setParameter("poid", po.getId())
                .getResultList();

        List<PurchaseOrderItemDTO> itemDtos = new ArrayList<>();
        for (PurchaseOrderItem poi : items) {
            itemDtos.add(new PurchaseOrderItemDTO(
                    poi.getId(),
                    poi.getItem() != null ? poi.getItem().getId() : null,
                    poi.getItem() != null ? poi.getItem().getSku() : "N/A",
                    poi.getItem() != null ? poi.getItem().getName() : "Item",
                    poi.getQuantity(),
                    poi.getUnitPrice()
            ));
        }
        dto.setItems(itemDtos);

        return dto;
    }

    private OrderStatus getOrCreateOrderStatus(String name, String description) {
        try {
            return em.createQuery("SELECT s FROM OrderStatus s WHERE s.name = :n", OrderStatus.class)
                    .setParameter("n", name)
                    .getSingleResult();
        } catch (Exception e) {
            OrderStatus status = new OrderStatus();
            status.setName(name);
            status.setDescription(description);
            em.persist(status);
            return status;
        }
    }

    private void rollbackQuietly() {
        try {
            if (userTransaction.getStatus() == jakarta.transaction.Status.STATUS_ACTIVE
                    || userTransaction.getStatus() == jakarta.transaction.Status.STATUS_MARKED_ROLLBACK) {
                userTransaction.rollback();
            }
        } catch (Exception ignored) {}
    }
}
