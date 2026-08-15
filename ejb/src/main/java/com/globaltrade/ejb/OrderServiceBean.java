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
@TransactionManagement(TransactionManagementType.BEAN) // BMT Example
public class OrderServiceBean implements OrderService {

    @PersistenceContext(unitName = "SupplyChainPU")
    private EntityManager em;

    @Resource
    private UserTransaction userTransaction;

    @EJB
    private InventoryService inventoryService;

    /**
     * BMT Example: Manually starting, committing, and rolling back a multi-step transaction.
     */
    @Override
    public Order createOrderWithBMT(Long customerId, Long vendorId, Map<Long, Integer> itemsWithQuantities, Long warehouseId) throws Exception {
        Order order = new Order();
        try {
            // Step 1: Begin Transaction
            userTransaction.begin();

            Customer customer = em.find(Customer.class, customerId);
            Vendor vendor = em.find(Vendor.class, vendorId);

            if (customer == null || vendor == null) {
                throw new IllegalArgumentException("Invalid Customer or Vendor ID");
            }

            // Create Order Header
            order.setOrderCode("ORD-" + System.currentTimeMillis());
            order.setCustomer(customer);
            order.setVendor(vendor);
            order.setStatus("CREATED");
            order.setTotalAmount(BigDecimal.ZERO);
            
            em.persist(order);

            BigDecimal totalAmount = BigDecimal.ZERO;

            // Step 2: Process Items and Reserve Stock
            for (Map.Entry<Long, Integer> entry : itemsWithQuantities.entrySet()) {
                Long itemId = entry.getKey();
                Integer quantity = entry.getValue();

                InventoryItem item = em.find(InventoryItem.class, itemId);
                if (item == null) {
                    throw new IllegalArgumentException("Invalid Item ID: " + itemId);
                }

                // Call CMT bean (REQUIRES_NEW) to reserve stock
                // Even though this is BMT, calling a CMT REQUIRES_NEW bean will suspend this tx, 
                // run the reservation, and resume this tx.
                inventoryService.reserveStock(itemId, warehouseId, quantity);

                // Create OrderItem
                OrderItem orderItem = new OrderItem();
                orderItem.setOrder(order);
                orderItem.setItem(item);
                orderItem.setQuantity(quantity);
                orderItem.setUnitPrice(item.getUnitPrice());
                em.persist(orderItem);

                // Calculate subtotal
                BigDecimal subtotal = item.getUnitPrice().multiply(new BigDecimal(quantity));
                totalAmount = totalAmount.add(subtotal);
            }

            order.setTotalAmount(totalAmount);
            em.merge(order);

            // Step 3: Commit Transaction
            userTransaction.commit();
            return order;

        } catch (Exception e) {
            // Step 4: Rollback Transaction on Failure
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
