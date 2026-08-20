package com.globaltrade.ejb;

import com.globaltrade.core.dto.OrderDTO;
import com.globaltrade.core.dto.OrderItemDTO;
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
import com.globaltrade.core.entity.Vendor;
import com.globaltrade.core.entity.Warehouse;
import com.globaltrade.core.service.InventoryService;
import com.globaltrade.core.service.OrderService;

import jakarta.annotation.Resource;
import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionManagement;
import jakarta.ejb.TransactionManagementType;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.UserTransaction;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Stateless
@TransactionManagement(TransactionManagementType.BEAN)
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

            if (customer == null || vendor == null) {
                throw new IllegalArgumentException("Invalid Customer or Vendor ID");
            }

            order.setOrderCode("ORD-" + System.currentTimeMillis());
            order.setCustomer(customer);
            OrderStatus status;
            try {
                status = em.createQuery("SELECT o FROM OrderStatus o WHERE o.name = 'PENDING'", OrderStatus.class).getSingleResult();
            } catch (Exception e) {
                try {
                    status = em.createQuery("SELECT o FROM OrderStatus o WHERE o.name = 'CREATED'", OrderStatus.class).getSingleResult();
                } catch (Exception ex) {
                    status = new OrderStatus();
                    status.setName("PENDING");
                    em.persist(status);
                }
            }
            order.setOrderStatus(status);
            order.setTotalAmount(BigDecimal.ZERO);

            em.persist(order);

            BigDecimal totalAmount = BigDecimal.ZERO;

            for (Map.Entry<Long, Integer> entry : itemsWithQuantities.entrySet()) {
                Long itemId = entry.getKey();
                Integer quantity = entry.getValue();

                InventoryItem item = em.find(InventoryItem.class, itemId);
                if (item == null) {
                    throw new IllegalArgumentException("Invalid Item ID: " + itemId);
                }

                InventoryStock stock = em.createQuery(
                                "SELECT s FROM InventoryStock s WHERE s.item.id = :itemId AND s.warehouse.id = :warehouseId",
                                InventoryStock.class)
                        .setParameter("itemId", itemId)
                        .setParameter("warehouseId", warehouseId)
                        .getSingleResult();

                if (stock == null || stock.getUnitPrice() == null) {
                    throw new IllegalArgumentException("No priced stock record found for Item ID: " + itemId + " at Warehouse ID: " + warehouseId);
                }

                inventoryService.reserveStock(itemId, warehouseId, quantity);

                OrderItem orderItem = new OrderItem();
                orderItem.setOrder(order);
                orderItem.setItem(item);
                orderItem.setQuantity(quantity);
                orderItem.setUnitPrice(stock.getUnitPrice());
                em.persist(orderItem);

                BigDecimal subtotal = stock.getUnitPrice().multiply(new BigDecimal(quantity));
                totalAmount = totalAmount.add(subtotal);
            }

            order.setTotalAmount(totalAmount);
            em.merge(order);

            userTransaction.commit();
            return order;

        } catch (Exception e) {
            try {
                if (userTransaction.getStatus() == jakarta.transaction.Status.STATUS_ACTIVE
                        || userTransaction.getStatus() == jakarta.transaction.Status.STATUS_MARKED_ROLLBACK) {
                    userTransaction.rollback();
                }
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
            throw new Exception("Order creation failed: " + e.getMessage(), e);
        }
    }

    @Override
    public List<OrderDTO> getAllOrders() {
        List<Order> orders = em.createQuery("SELECT o FROM Order o LEFT JOIN FETCH o.customer LEFT JOIN FETCH o.orderStatus ORDER BY o.id DESC", Order.class).getResultList();
        List<OrderDTO> dtos = new ArrayList<>();

        for (Order o : orders) {
            String custName = o.getCustomer() != null ? o.getCustomer().getName() : "Direct Customer";
            String custEmail = o.getCustomer() != null ? o.getCustomer().getEmail() : "";
            String custPhone = o.getCustomer() != null ? o.getCustomer().getPhone() : "";
            String custAddr = o.getCustomer() != null ? o.getCustomer().getAddress() : "";
            String statusName = o.getOrderStatus() != null ? o.getOrderStatus().getName() : "PENDING";

            OrderDTO dto = new OrderDTO(
                    o.getId(),
                    o.getOrderCode(),
                    o.getCustomer() != null ? o.getCustomer().getId() : null,
                    custName,
                    custEmail,
                    custPhone,
                    custAddr,
                    o.getTotalAmount(),
                    statusName,
                    o.getCreatedAt()
            );

            // Fetch line items
            List<OrderItem> items = em.createQuery("SELECT oi FROM OrderItem oi JOIN FETCH oi.item WHERE oi.order.id = :oid", OrderItem.class)
                    .setParameter("oid", o.getId())
                    .getResultList();

            List<OrderItemDTO> itemDtos = new ArrayList<>();
            for (OrderItem oi : items) {
                itemDtos.add(new OrderItemDTO(
                        oi.getId(),
                        oi.getItem() != null ? oi.getItem().getId() : null,
                        oi.getItem() != null ? oi.getItem().getSku() : "N/A",
                        oi.getItem() != null ? oi.getItem().getName() : "Item",
                        oi.getQuantity(),
                        oi.getUnitPrice()
                ));
            }
            dto.setItems(itemDtos);

            // Check linked shipment
            if (o.getCustomer() != null) {
                List<Shipment> shipments = em.createQuery("SELECT s FROM Shipment s LEFT JOIN FETCH s.shipmentStatus WHERE s.customer.id = :cid ORDER BY s.id DESC", Shipment.class)
                        .setParameter("cid", o.getCustomer().getId())
                        .setMaxResults(1)
                        .getResultList();
                if (!shipments.isEmpty()) {
                    Shipment sh = shipments.get(0);
                    dto.setShipmentCode(sh.getShipmentCode());
                    dto.setCarrierName(sh.getCarrierName());
                    dto.setShipmentStatus(sh.getShipmentStatus() != null ? sh.getShipmentStatus().getName() : "IN_TRANSIT");
                }
            }

            dtos.add(dto);
        }

        return dtos;
    }

    @Override
    public OrderDTO getOrderDetails(Long orderId) {
        Order o = em.find(Order.class, orderId);
        if (o == null) return null;

        String custName = o.getCustomer() != null ? o.getCustomer().getName() : "Direct Customer";
        String custEmail = o.getCustomer() != null ? o.getCustomer().getEmail() : "";
        String custPhone = o.getCustomer() != null ? o.getCustomer().getPhone() : "";
        String custAddr = o.getCustomer() != null ? o.getCustomer().getAddress() : "";
        String statusName = o.getOrderStatus() != null ? o.getOrderStatus().getName() : "PENDING";

        OrderDTO dto = new OrderDTO(
                o.getId(),
                o.getOrderCode(),
                o.getCustomer() != null ? o.getCustomer().getId() : null,
                custName,
                custEmail,
                custPhone,
                custAddr,
                o.getTotalAmount(),
                statusName,
                o.getCreatedAt()
        );

        List<OrderItem> items = em.createQuery("SELECT oi FROM OrderItem oi JOIN FETCH oi.item WHERE oi.order.id = :oid", OrderItem.class)
                .setParameter("oid", o.getId())
                .getResultList();

        List<OrderItemDTO> itemDtos = new ArrayList<>();
        for (OrderItem oi : items) {
            itemDtos.add(new OrderItemDTO(
                    oi.getId(),
                    oi.getItem() != null ? oi.getItem().getId() : null,
                    oi.getItem() != null ? oi.getItem().getSku() : "N/A",
                    oi.getItem() != null ? oi.getItem().getName() : "Item",
                    oi.getQuantity(),
                    oi.getUnitPrice()
            ));
        }
        dto.setItems(itemDtos);
        return dto;
    }

    @Override
    public void startProcessingOrder(Long orderId) {
        try {
            userTransaction.begin();
            Order order = em.find(Order.class, orderId);
            if (order != null) {
                OrderStatus status = getOrCreateOrderStatus("PROCESSING", "Being packed in warehouse");
                order.setOrderStatus(status);
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
            if (order == null) {
                throw new IllegalArgumentException("Order not found: " + orderId);
            }

            Warehouse warehouse = em.find(Warehouse.class, originWarehouseId);
            if (warehouse == null) {
                throw new IllegalArgumentException("Warehouse not found: " + originWarehouseId);
            }

            ShipmentStatus inTransitStatus = getOrCreateShipmentStatus("IN_TRANSIT", "Dispatched and in transit");

            Shipment shipment = new Shipment();
            shipment.setShipmentCode("SHP-" + (System.currentTimeMillis() % 100000));
            shipment.setCustomer(order.getCustomer());
            shipment.setOriginWarehouse(warehouse);
            shipment.setCarrierName(carrierName != null && !carrierName.trim().isEmpty() ? carrierName : "DHL Express");
            
            String dest = (destination != null && !destination.trim().isEmpty()) ? destination : (order.getCustomer() != null ? order.getCustomer().getAddress() : "Customer Address");
            shipment.setDestination(dest);
            shipment.setEstimatedDelivery(LocalDateTime.now().plusDays(deliveryDays > 0 ? deliveryDays : 3));
            shipment.setShipmentStatus(inTransitStatus);

            em.persist(shipment);

            // Fetch order items to link into shipment and deduct warehouse stock
            List<OrderItem> orderItems = em.createQuery("SELECT oi FROM OrderItem oi JOIN FETCH oi.item WHERE oi.order.id = :oid", OrderItem.class)
                    .setParameter("oid", orderId)
                    .getResultList();

            for (OrderItem oi : orderItems) {
                ShipmentItem si = new ShipmentItem();
                si.setShipment(shipment);
                si.setItem(oi.getItem());
                si.setQuantity(oi.getQuantity());
                em.persist(si);

                // Deduct stock from the origin warehouse
                if (oi.getItem() != null) {
                    List<InventoryStock> stocks = em.createQuery("SELECT s FROM InventoryStock s WHERE s.item.id = :itemId AND s.warehouse.id = :whId", InventoryStock.class)
                            .setParameter("itemId", oi.getItem().getId())
                            .setParameter("whId", originWarehouseId)
                            .getResultList();

                    if (!stocks.isEmpty()) {
                        InventoryStock stock = stocks.get(0);
                        int newQty = Math.max(0, stock.getStockQty() - (oi.getQuantity() != null ? oi.getQuantity() : 0));
                        stock.setStockQty(newQty);

                        Integer reorderLvl = oi.getItem().getReorderLevel() != null ? oi.getItem().getReorderLevel() : 0;
                        String stName = (newQty == 0) ? "OUT_OF_STOCK" : (newQty <= reorderLvl ? "LOW_STOCK" : "IN_STOCK");
                        try {
                            Status st = em.createQuery("SELECT s FROM Status s WHERE s.name = :n", Status.class)
                                    .setParameter("n", stName)
                                    .getSingleResult();
                            stock.setStatus(st);
                        } catch (Exception ignored) {}

                        em.merge(stock);
                    }
                }
            }

            // Ensure order status is at least PROCESSING
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

                // Mark linked shipment as DELIVERED
                if (order.getCustomer() != null) {
                    List<Shipment> shipments = em.createQuery("SELECT s FROM Shipment s WHERE s.customer.id = :cid ORDER BY s.id DESC", Shipment.class)
                            .setParameter("cid", order.getCustomer().getId())
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
            }
            userTransaction.commit();
        } catch (Exception e) {
            rollbackQuietly();
            throw new RuntimeException("Failed to complete order: " + e.getMessage(), e);
        }
    }

    private OrderStatus getOrCreateOrderStatus(String name, String description) {
        try {
            return em.createQuery("SELECT s FROM OrderStatus s WHERE s.name = :name", OrderStatus.class)
                    .setParameter("name", name)
                    .getSingleResult();
        } catch (Exception e) {
            OrderStatus status = new OrderStatus();
            status.setName(name);
            status.setDescription(description);
            em.persist(status);
            return status;
        }
    }

    private ShipmentStatus getOrCreateShipmentStatus(String name, String description) {
        try {
            return em.createQuery("SELECT s FROM ShipmentStatus s WHERE s.name = :name", ShipmentStatus.class)
                    .setParameter("name", name)
                    .getSingleResult();
        } catch (Exception e) {
            ShipmentStatus status = new ShipmentStatus();
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
