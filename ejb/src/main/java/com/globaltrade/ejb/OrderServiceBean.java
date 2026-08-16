package com.globaltrade.ejb;

import com.globaltrade.core.entity.Customer;
import com.globaltrade.core.entity.InventoryItem;
import com.globaltrade.core.entity.Order;
import com.globaltrade.core.entity.OrderItem;
import com.globaltrade.core.entity.Vendor;
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
            order.setVendor(vendor);
            order.setStatus("CREATED");
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

                inventoryService.reserveStock(itemId, warehouseId, quantity);

                OrderItem orderItem = new OrderItem();
                orderItem.setOrder(order);
                orderItem.setItem(item);
                orderItem.setQuantity(quantity);
//                orderItem.setUnitPrice(item.getUnitPrice());
                em.persist(orderItem);
//
//                BigDecimal subtotal = item.getUnitPrice().multiply(new BigDecimal(quantity));
//                totalAmount = totalAmount.add(subtotal);
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
}
