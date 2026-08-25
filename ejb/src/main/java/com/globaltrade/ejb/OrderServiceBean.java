package com.globaltrade.ejb;

import com.globaltrade.core.dto.OrderDTO;
import com.globaltrade.core.dto.OrderItemDTO;
import com.globaltrade.core.entity.Country;
import com.globaltrade.core.entity.Customer;
import com.globaltrade.core.entity.InventoryItem;
import com.globaltrade.core.entity.InventoryStock;
import com.globaltrade.core.entity.Order;
import com.globaltrade.core.entity.OrderItem;
import com.globaltrade.core.entity.OrderStatus;
import com.globaltrade.core.entity.Shipment;
import com.globaltrade.core.entity.ShipmentItem;
import com.globaltrade.core.entity.ShipmentStatus;
import com.globaltrade.core.entity.Status;
import com.globaltrade.core.entity.User;
import com.globaltrade.core.entity.Vendor;
import com.globaltrade.core.entity.Warehouse;
import com.globaltrade.core.service.InventoryService;
import com.globaltrade.core.service.OrderService;
import com.globaltrade.ejb.interceptor.AuditLogInterceptor;
import com.globaltrade.ejb.interceptor.ExceptionLoggingInterceptor;
import com.globaltrade.ejb.interceptor.PerformanceMonitorInterceptor;
import jakarta.annotation.Resource;
import jakarta.ejb.EJB;
import jakarta.ejb.Local;
import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionManagement;
import jakarta.ejb.TransactionManagementType;
import jakarta.interceptor.Interceptors;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.UserTransaction;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Stateless(name = "OrderServiceBean")
@Local(OrderService.class)
@TransactionManagement(TransactionManagementType.BEAN)
@Interceptors({AuditLogInterceptor.class, PerformanceMonitorInterceptor.class, ExceptionLoggingInterceptor.class})
public class OrderServiceBean implements OrderService {

    @PersistenceContext(unitName = "SupplyChainPU")
    private EntityManager em;

    @Resource
    private UserTransaction userTransaction;

    @EJB
    private InventoryService inventoryService;

    @Override
    public Order createOrderWithBMT(Long customerId, Long vendorId, Map<Long, Integer> itemsWithQuantities, Long warehouseId) throws Exception {
        Order order = new Order();
        try {
            userTransaction.begin();

            Customer customer = em.find(Customer.class, customerId);
            Vendor vendor = em.find(Vendor.class, vendorId);
            OrderStatus pendingStatus = getOrCreateOrderStatus("PENDING", "Order placed, awaiting processing");

            String orderCode = "ORD-" + System.currentTimeMillis() % 100000;
            order.setOrderCode(orderCode);
            order.setCustomer(customer);
            order.setOrderStatus(pendingStatus);
            order.setCreatedAt(LocalDateTime.now());
            em.persist(order);

            BigDecimal subtotal = BigDecimal.ZERO;
            List<OrderItem> orderItems = new ArrayList<>();

            for (Map.Entry<Long, Integer> entry : itemsWithQuantities.entrySet()) {
                Long itemId = entry.getKey();
                Integer qty = entry.getValue();

                InventoryItem item = em.find(InventoryItem.class, itemId);
                if (item == null) {
                    throw new IllegalArgumentException("Item not found with ID: " + itemId);
                }

                InventoryStock stock = em.createQuery(
                        "SELECT s FROM InventoryStock s WHERE s.item.id = :itemId AND s.warehouse.id = :whId", InventoryStock.class)
                        .setParameter("itemId", itemId)
                        .setParameter("whId", warehouseId)
                        .getSingleResult();

                if (stock == null || stock.getStockQty() < qty) {
                    throw new IllegalStateException("Insufficient stock for item: " + item.getName());
                }

                stock.setStockQty(stock.getStockQty() - qty);
                em.merge(stock);

                BigDecimal unitPrice = stock.getUnitPrice() != null ? stock.getUnitPrice() : BigDecimal.valueOf(100.0);
                BigDecimal lineTotal = unitPrice.multiply(BigDecimal.valueOf(qty));
                subtotal = subtotal.add(lineTotal);

                OrderItem oi = new OrderItem();
                oi.setOrder(order);
                oi.setItem(item);
                oi.setQuantity(qty);
                oi.setUnitPrice(unitPrice);
                em.persist(oi);
                orderItems.add(oi);
            }

            BigDecimal vatRate = (customer != null && customer.getCountry() != null && customer.getCountry().getVatPercentage() != null)
                    ? customer.getCountry().getVatPercentage() : BigDecimal.ZERO;
            BigDecimal importRate = (customer != null && customer.getCountry() != null && customer.getCountry().getImportTaxPercentage() != null)
                    ? customer.getCountry().getImportTaxPercentage() : BigDecimal.ZERO;
            BigDecimal totalRate = vatRate.add(importRate);
            BigDecimal taxAmount = subtotal.multiply(totalRate).divide(new BigDecimal("100"), 2, java.math.RoundingMode.HALF_UP);
            BigDecimal shippingAmount = new BigDecimal("25.00");
            BigDecimal totalAmount = subtotal.add(taxAmount).add(shippingAmount);

            order.setSubtotal(subtotal);
            order.setTaxAmount(taxAmount);
            order.setShippingAmount(shippingAmount);
            order.setTotalAmount(totalAmount);
            em.merge(order);

            userTransaction.commit();
            return order;

        } catch (Exception e) {
            rollbackQuietly();
            throw new Exception("Order creation failed: " + e.getMessage(), e);
        }
    }

    @Override
    public List<OrderDTO> getAllOrders() {
        List<Order> orders = em.createQuery(
                "SELECT o FROM Order o LEFT JOIN FETCH o.customer c LEFT JOIN FETCH c.country LEFT JOIN FETCH o.orderStatus ORDER BY o.id DESC", 
                Order.class).getResultList();
        List<OrderDTO> dtos = new ArrayList<>();
        for (Order o : orders) {
            dtos.add(mapToDTO(o));
        }
        return dtos;
    }

    @Override
    public OrderDTO getOrderDetails(Long orderId) {
        Order o = em.find(Order.class, orderId);
        return mapToDTO(o);
    }

    @Override
    public List<OrderDTO> getOrdersByCustomerUserId(Long userId) {
        try {
            Customer customer = getOrCreateCustomerForUser(userId);
            List<Order> orders = em.createQuery(
                    "SELECT o FROM Order o LEFT JOIN FETCH o.customer c LEFT JOIN FETCH c.country LEFT JOIN FETCH o.orderStatus " +
                    "WHERE o.customer.id = :cid ORDER BY o.createdAt DESC", Order.class)
                    .setParameter("cid", customer.getId())
                    .getResultList();

            List<OrderDTO> dtos = new ArrayList<>();
            for (Order o : orders) {
                dtos.add(mapToDTO(o));
            }
            return dtos;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    @Override
    public Customer getOrCreateCustomerForUser(Long userId) throws Exception {
        List<Customer> list = em.createQuery("SELECT c FROM Customer c WHERE c.user.id = :uid", Customer.class)
                .setParameter("uid", userId)
                .getResultList();
        if (!list.isEmpty()) {
            return list.get(0);
        }

        User user = em.find(User.class, userId);
        if (user == null) {
            throw new IllegalArgumentException("User not found: " + userId);
        }

        Country defaultCountry = null;
        List<Country> countries = em.createQuery("SELECT c FROM Country c", Country.class).setMaxResults(1).getResultList();
        if (!countries.isEmpty()) {
            defaultCountry = countries.get(0);
        }

        boolean startedTx = false;
        if (userTransaction.getStatus() != jakarta.transaction.Status.STATUS_ACTIVE) {
            userTransaction.begin();
            startedTx = true;
        }

        Customer customer = new Customer();
        customer.setUser(user);
        customer.setName(user.getFullName() != null && !user.getFullName().trim().isEmpty() ? user.getFullName().trim() : user.getUsername());
        customer.setEmail(user.getEmail() != null && !user.getEmail().trim().isEmpty() ? user.getEmail().trim() : user.getUsername() + "@customer.com");
        customer.setPhone("0771234567");
        customer.setAddress("Colombo Retail District, Sri Lanka");
        customer.setCountry(defaultCountry);
        em.persist(customer);

        if (startedTx) {
            userTransaction.commit();
        }

        return customer;
    }

    @Override
    public OrderDTO createCustomerOrder(Long userId, Map<Long, Integer> productQuantities, String destinationAddress, Long countryId) throws Exception {
        if (productQuantities == null || productQuantities.isEmpty()) {
            throw new IllegalArgumentException("Cart cannot be empty. Please select at least one item.");
        }

        try {
            userTransaction.begin();

            Customer customer = getOrCreateCustomerForUser(userId);
            if (destinationAddress != null && !destinationAddress.trim().isEmpty()) {
                customer.setAddress(destinationAddress.trim());
            }
            if (countryId != null) {
                Country c = em.find(Country.class, countryId);
                if (c != null) customer.setCountry(c);
            }
            em.merge(customer);

            OrderStatus pendingStatus = getOrCreateOrderStatus("PROCESSING", "Order placed by customer and ready for dispatch");
            String orderCode = "ORD-" + LocalDateTime.now().getYear() + "-" + (System.currentTimeMillis() % 100000);

            Order order = new Order();
            order.setOrderCode(orderCode);
            order.setCustomer(customer);
            order.setUser(customer.getUser());
            order.setOrderStatus(pendingStatus);
            order.setCreatedAt(LocalDateTime.now());
            em.persist(order);

            BigDecimal subtotal = BigDecimal.ZERO;
            Warehouse originWarehouse = null;

            for (Map.Entry<Long, Integer> entry : productQuantities.entrySet()) {
                Long productId = entry.getKey();
                Integer qty = entry.getValue();
                if (qty == null || qty <= 0) continue;

                InventoryItem item = em.find(InventoryItem.class, productId);
                if (item == null) {
                    InventoryStock stk = em.find(InventoryStock.class, productId);
                    if (stk != null) {
                        item = stk.getItem();
                    }
                }
                if (item == null) continue;

                List<InventoryStock> stocks = em.createQuery(
                        "SELECT s FROM InventoryStock s WHERE s.item.id = :itemId ORDER BY s.stockQty DESC", InventoryStock.class)
                        .setParameter("itemId", item.getId())
                        .getResultList();

                BigDecimal unitPrice = BigDecimal.valueOf(50.00);
                if (!stocks.isEmpty()) {
                    InventoryStock stock = stocks.get(0);
                    if (stock.getUnitPrice() != null && stock.getUnitPrice().compareTo(BigDecimal.ZERO) > 0) {
                        unitPrice = stock.getUnitPrice();
                    }
                    if (originWarehouse == null) {
                        originWarehouse = stock.getWarehouse();
                    }
                    int currentStock = stock.getStockQty() != null ? stock.getStockQty() : 0;
                    stock.setStockQty(Math.max(0, currentStock - qty));
                    em.merge(stock);
                }

                OrderItem orderItem = new OrderItem();
                orderItem.setOrder(order);
                orderItem.setItem(item);
                orderItem.setQuantity(qty);
                orderItem.setUnitPrice(unitPrice);
                em.persist(orderItem);

                BigDecimal lineTotal = unitPrice.multiply(BigDecimal.valueOf(qty));
                subtotal = subtotal.add(lineTotal);
            }

            BigDecimal vatRate = BigDecimal.ZERO;
            BigDecimal importRate = BigDecimal.ZERO;
            if (customer.getCountry() != null) {
                vatRate = customer.getCountry().getVatPercentage() != null ? customer.getCountry().getVatPercentage() : BigDecimal.ZERO;
                importRate = customer.getCountry().getImportTaxPercentage() != null ? customer.getCountry().getImportTaxPercentage() : BigDecimal.ZERO;
            }

            BigDecimal totalRate = vatRate.add(importRate);
            BigDecimal taxAmount = subtotal.multiply(totalRate).divide(new BigDecimal("100"), 2, java.math.RoundingMode.HALF_UP);
            BigDecimal shippingAmount = new BigDecimal("25.00");
            BigDecimal totalAmount = subtotal.add(taxAmount).add(shippingAmount);

            order.setSubtotal(subtotal);
            order.setTaxAmount(taxAmount);
            order.setShippingAmount(shippingAmount);
            order.setTotalAmount(totalAmount);
            em.merge(order);

            if (originWarehouse == null) {
                List<Warehouse> whs = em.createQuery("SELECT w FROM Warehouse w", Warehouse.class).setMaxResults(1).getResultList();
                if (!whs.isEmpty()) originWarehouse = whs.get(0);
            }

            ShipmentStatus inTransitStatus = getOrCreateShipmentStatus("IN_TRANSIT", "Dispatched from warehouse and en route to customer");
            Shipment shipment = new Shipment();
            shipment.setShipmentCode("SHP-" + LocalDateTime.now().getYear() + "-" + (System.currentTimeMillis() % 100000));
            shipment.setOrder(order);
            shipment.setOriginWarehouse(originWarehouse);
            shipment.setCarrierName("Global Freight Express");
            shipment.setShipmentStatus(inTransitStatus);
            shipment.setCreatedAt(LocalDateTime.now());
            shipment.setEstimatedDelivery(LocalDateTime.now().plusDays(3));
            em.persist(shipment);

            userTransaction.commit();
            return mapToDTO(order);
        } catch (Exception e) {
            rollbackQuietly();
            throw e;
        }
    }

    @Override
    public void startProcessingOrder(Long orderId) {
        try {
            userTransaction.begin();
            Order order = em.find(Order.class, orderId);
            if (order != null) {
                OrderStatus processingStatus = getOrCreateOrderStatus("PROCESSING", "Order is being packed and prepared for shipment");
                order.setOrderStatus(processingStatus);
                em.merge(order);
            }
            userTransaction.commit();
        } catch (Exception e) {
            rollbackQuietly();
            throw new RuntimeException("Failed to start processing order: " + e.getMessage(), e);
        }
    }

    @Override
    public void createShipmentForOrder(Long orderId, Long originWarehouseId, String carrierName, String destination, int deliveryDays) {
        try {
            userTransaction.begin();
            Order order = em.find(Order.class, orderId);
            Warehouse warehouse = em.find(Warehouse.class, originWarehouseId);
            if (order == null || warehouse == null) {
                throw new IllegalArgumentException("Invalid order or warehouse ID");
            }

            ShipmentStatus inTransitStatus = getOrCreateShipmentStatus("IN_TRANSIT", "Package in transit");
            Shipment shipment = new Shipment();
            shipment.setShipmentCode("SHP-" + System.currentTimeMillis() % 100000);
            shipment.setOrder(order);
            shipment.setOriginWarehouse(warehouse);
            shipment.setCarrierName(carrierName != null ? carrierName : "Default Express");
            shipment.setDestination(destination != null ? destination : "Customer Destination");
            shipment.setShipmentStatus(inTransitStatus);
            shipment.setCreatedAt(LocalDateTime.now());
            shipment.setEstimatedDelivery(LocalDateTime.now().plusDays(deliveryDays > 0 ? deliveryDays : 3));
            em.persist(shipment);

            OrderStatus processingStatus = getOrCreateOrderStatus("PROCESSING", "Being packed and shipped");
            order.setOrderStatus(processingStatus);
            em.merge(order);

            userTransaction.commit();
        } catch (Exception e) {
            rollbackQuietly();
            throw new RuntimeException("Failed to create shipment: " + e.getMessage(), e);
        }
    }

    @Override
    public void completeOrder(Long orderId) {
        try {
            userTransaction.begin();
            Order order = em.find(Order.class, orderId);
            if (order != null) {
                OrderStatus completedStatus = getOrCreateOrderStatus("COMPLETED", "Order fulfilled and delivered");
                order.setOrderStatus(completedStatus);
                em.merge(order);

                List<Shipment> shipments = em.createQuery("SELECT s FROM Shipment s WHERE s.order.id = :oid ORDER BY s.id DESC", Shipment.class)
                        .setParameter("oid", order.getId())
                        .setMaxResults(1)
                        .getResultList();
                if (!shipments.isEmpty()) {
                    ShipmentStatus deliveredStatus = getOrCreateShipmentStatus("DELIVERED", "Package delivered to customer");
                    Shipment sh = shipments.get(0);
                    sh.setShipmentStatus(deliveredStatus);
                    sh.setActualDelivery(LocalDateTime.now());
                    em.merge(sh);
                }
            }
            userTransaction.commit();
        } catch (Exception e) {
            rollbackQuietly();
            throw new RuntimeException("Failed to complete order: " + e.getMessage(), e);
        }
    }

    private OrderDTO mapToDTO(Order o) {
        if (o == null) return null;

        String custName = o.getCustomer() != null ? o.getCustomer().getName() : "Direct Customer";
        String custEmail = o.getCustomer() != null ? o.getCustomer().getEmail() : "";
        String custPhone = o.getCustomer() != null ? o.getCustomer().getPhone() : "";
        String custAddr = o.getCustomer() != null ? o.getCustomer().getAddress() : "";
        String statusName = o.getOrderStatus() != null ? o.getOrderStatus().getName() : "PENDING";

        BigDecimal subtotal = (o.getSubtotal() != null && o.getSubtotal().compareTo(BigDecimal.ZERO) > 0) 
                ? o.getSubtotal() 
                : (o.getTotalAmount() != null ? o.getTotalAmount() : BigDecimal.ZERO);
        BigDecimal taxAmount = (o.getTaxAmount() != null && o.getTaxAmount().compareTo(BigDecimal.ZERO) > 0) 
                ? o.getTaxAmount() 
                : BigDecimal.ZERO;

        BigDecimal vatRate = BigDecimal.ZERO;
        BigDecimal importRate = BigDecimal.ZERO;
        String countryName = "";

        if (o.getCustomer() != null && o.getCustomer().getCountry() != null) {
            countryName = o.getCustomer().getCountry().getName();
            vatRate = o.getCustomer().getCountry().getVatPercentage() != null ? o.getCustomer().getCountry().getVatPercentage() : BigDecimal.ZERO;
            importRate = o.getCustomer().getCountry().getImportTaxPercentage() != null ? o.getCustomer().getCountry().getImportTaxPercentage() : BigDecimal.ZERO;
        }

        List<Shipment> shipments = em.createQuery(
                "SELECT s FROM Shipment s LEFT JOIN FETCH s.originWarehouse ow LEFT JOIN FETCH ow.country LEFT JOIN FETCH s.shipmentStatus WHERE s.order.id = :oid ORDER BY s.id DESC", 
                Shipment.class)
                .setParameter("oid", o.getId())
                .getResultList();

        boolean isCrossBorder = false;
        String shpCode = null;
        String carrier = null;
        String shpStatus = null;

        String originWh = "Colombo Central Warehouse";
        String destAddr = custAddr;
        LocalDateTime estDeliv = o.getCreatedAt() != null ? o.getCreatedAt().plusDays(3) : LocalDateTime.now().plusDays(3);

        if (!shipments.isEmpty()) {
            Shipment sh = shipments.get(0);
            shpCode = sh.getShipmentCode();
            carrier = sh.getCarrierName();
            shpStatus = sh.getShipmentStatus() != null ? sh.getShipmentStatus().getName() : "IN_TRANSIT";
            if (sh.getOriginWarehouse() != null) {
                originWh = sh.getOriginWarehouse().getName();
            }
            if (sh.getDestination() != null && !sh.getDestination().trim().isEmpty()) {
                destAddr = sh.getDestination();
            }
            if (sh.getEstimatedDelivery() != null) {
                estDeliv = sh.getEstimatedDelivery();
            }

            if (sh.getOriginWarehouse() != null && sh.getOriginWarehouse().getCountry() != null && o.getCustomer() != null && o.getCustomer().getCountry() != null) {
                isCrossBorder = !sh.getOriginWarehouse().getCountry().getId().equals(o.getCustomer().getCountry().getId());
            }
        }

        if (!isCrossBorder) {
            importRate = BigDecimal.ZERO;
        }

        if (taxAmount.compareTo(BigDecimal.ZERO) == 0 && (vatRate.compareTo(BigDecimal.ZERO) > 0 || importRate.compareTo(BigDecimal.ZERO) > 0)) {
            BigDecimal totalRate = vatRate.add(importRate);
            taxAmount = subtotal.multiply(totalRate).divide(new BigDecimal("100"), 2, java.math.RoundingMode.HALF_UP);
        }

        List<OrderItem> items = em.createQuery("SELECT oi FROM OrderItem oi JOIN FETCH oi.item WHERE oi.order.id = :oid", OrderItem.class)
                .setParameter("oid", o.getId())
                .getResultList();

        List<OrderItemDTO> itemDtos = new ArrayList<>();
        BigDecimal totalWeightKg = BigDecimal.ZERO;
        for (OrderItem oi : items) {
            itemDtos.add(new OrderItemDTO(
                    oi.getId(),
                    oi.getItem() != null ? oi.getItem().getId() : null,
                    oi.getItem() != null ? oi.getItem().getSku() : "N/A",
                    oi.getItem() != null ? oi.getItem().getName() : "Item",
                    oi.getQuantity(),
                    oi.getUnitPrice()
            ));

            if (oi.getItem() != null && oi.getItem().getWeight() != null && oi.getQuantity() != null) {
                totalWeightKg = totalWeightKg.add(oi.getItem().getWeight().multiply(BigDecimal.valueOf(oi.getQuantity())));
            }
        }

        BigDecimal shippingAmount = (o.getShippingAmount() != null && o.getShippingAmount().compareTo(BigDecimal.ZERO) > 0) 
                ? o.getShippingAmount() 
                : BigDecimal.ZERO;

        if (shippingAmount.compareTo(BigDecimal.ZERO) == 0 && !items.isEmpty()) {
            BigDecimal shippingRatePerKg = isCrossBorder ? new BigDecimal("5.00") : new BigDecimal("2.00");
            BigDecimal minShipping = isCrossBorder ? new BigDecimal("25.00") : new BigDecimal("10.00");
            shippingAmount = totalWeightKg.multiply(shippingRatePerKg).setScale(2, java.math.RoundingMode.HALF_UP);
            if (shippingAmount.compareTo(minShipping) < 0) {
                shippingAmount = minShipping;
            }
        }

        BigDecimal finalTotal = subtotal.add(taxAmount).add(shippingAmount);

        OrderDTO dto = new OrderDTO(
                o.getId(),
                o.getOrderCode(),
                o.getCustomer() != null ? o.getCustomer().getId() : null,
                custName,
                custEmail,
                custPhone,
                custAddr,
                subtotal,
                taxAmount,
                finalTotal,
                statusName,
                o.getCreatedAt()
        );

        dto.setShippingAmount(shippingAmount);
        dto.setCountryName(countryName);
        dto.setVatPercentage(vatRate);
        dto.setImportTaxPercentage(importRate);
        dto.setCrossBorder(isCrossBorder);
        dto.setShipmentCode(shpCode);
        dto.setCarrierName(carrier != null ? carrier : "Global Freight Express");
        dto.setShipmentStatus(shpStatus != null ? shpStatus : "IN_TRANSIT");
        dto.setOriginWarehouseName(originWh);
        dto.setDestination(destAddr);
        dto.setEstimatedDelivery(estDeliv);
        dto.setItems(itemDtos);

        return dto;
    }

    @Override
    public OrderDTO getOrderByCode(String code) {
        if (code == null || code.trim().isEmpty()) return null;
        String cleanCode = code.trim();
        try {
            List<Order> list = em.createQuery("SELECT o FROM Order o LEFT JOIN FETCH o.customer c LEFT JOIN FETCH c.country LEFT JOIN FETCH o.orderStatus WHERE o.orderCode = :code", Order.class)
                    .setParameter("code", cleanCode)
                    .getResultList();
            if (!list.isEmpty()) {
                return mapToDTO(list.get(0));
            }

            List<Shipment> shpList = em.createQuery("SELECT s FROM Shipment s WHERE s.shipmentCode = :code", Shipment.class)
                    .setParameter("code", cleanCode)
                    .getResultList();
            if (!shpList.isEmpty() && shpList.get(0).getOrder() != null) {
                return mapToDTO(shpList.get(0).getOrder());
            }

            try {
                Long id = Long.parseLong(cleanCode);
                Order o = em.find(Order.class, id);
                if (o != null) return mapToDTO(o);
            } catch (NumberFormatException ignored) {}

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private OrderStatus getOrCreateOrderStatus(String name, String description) {
        try {
            return em.createQuery("SELECT s FROM OrderStatus s WHERE UPPER(s.name) = :name", OrderStatus.class)
                    .setParameter("name", name.toUpperCase())
                    .getSingleResult();
        } catch (Exception e) {
            OrderStatus status = new OrderStatus();
            status.setName(name.toUpperCase());
            status.setDescription(description);
            em.persist(status);
            return status;
        }
    }

    private ShipmentStatus getOrCreateShipmentStatus(String name, String description) {
        try {
            return em.createQuery("SELECT s FROM ShipmentStatus s WHERE UPPER(s.name) = :name", ShipmentStatus.class)
                    .setParameter("name", name.toUpperCase())
                    .getSingleResult();
        } catch (Exception e) {
            ShipmentStatus status = new ShipmentStatus();
            status.setName(name.toUpperCase());
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