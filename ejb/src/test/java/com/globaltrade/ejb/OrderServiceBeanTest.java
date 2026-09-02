package com.globaltrade.ejb;

import com.globaltrade.core.dto.OrderDTO;
import com.globaltrade.core.entity.Customer;
import com.globaltrade.core.entity.InventoryItem;
import com.globaltrade.core.entity.InventoryStock;
import com.globaltrade.core.entity.Order;
import com.globaltrade.core.entity.OrderStatus;
import com.globaltrade.core.entity.Vendor;
import com.globaltrade.core.service.InventoryService;
import com.globaltrade.core.entity.Shipment;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import jakarta.transaction.UserTransaction;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class OrderServiceBeanTest {

    @Mock
    private EntityManager em;

    @Mock
    private UserTransaction userTransaction;

    @Mock
    private InventoryService inventoryService;

    @Mock
    private TypedQuery<Order> orderQuery;

    @Mock
    private TypedQuery<OrderStatus> statusQuery;

    @Mock
    private TypedQuery<Shipment> shipmentQuery;

    @InjectMocks
    private OrderServiceBean orderService;

    @BeforeEach
    void setUp() throws Exception {
        Field emField = OrderServiceBean.class.getDeclaredField("em");
        emField.setAccessible(true);
        emField.set(orderService, em);

        Field utField = OrderServiceBean.class.getDeclaredField("userTransaction");
        utField.setAccessible(true);
        utField.set(orderService, userTransaction);

        Field invField = OrderServiceBean.class.getDeclaredField("inventoryService");
        invField.setAccessible(true);
        invField.set(orderService, inventoryService);
    }

    @Test
    @DisplayName("Should retrieve all orders and correctly map to DTOs")
    void testGetAllOrders() {
        Order order = new Order();
        order.setId(101L);
        order.setOrderCode("ORD-9988");
        order.setTotalAmount(new BigDecimal("1500.00"));
        order.setCreatedAt(LocalDateTime.now());

        Customer customer = new Customer();
        customer.setName("Apex Global Trade");
        order.setCustomer(customer);

        OrderStatus status = new OrderStatus();
        status.setName("PROCESSING");
        order.setOrderStatus(status);

        when(em.createQuery(anyString(), eq(Order.class))).thenReturn(orderQuery);
        when(orderQuery.getResultList()).thenReturn(Collections.singletonList(order));

        when(em.createQuery(anyString(), eq(Shipment.class))).thenReturn(shipmentQuery);
        when(shipmentQuery.setParameter(anyString(), any())).thenReturn(shipmentQuery);
        when(shipmentQuery.getResultList()).thenReturn(Collections.emptyList());

        TypedQuery<com.globaltrade.core.entity.OrderItem> orderItemQuery = mock(TypedQuery.class);
        when(em.createQuery(anyString(), eq(com.globaltrade.core.entity.OrderItem.class))).thenReturn(orderItemQuery);
        when(orderItemQuery.setParameter(anyString(), any())).thenReturn(orderItemQuery);
        when(orderItemQuery.getResultList()).thenReturn(Collections.emptyList());

        List<OrderDTO> orders = orderService.getAllOrders();

        assertNotNull(orders);
        assertEquals(1, orders.size());
        assertEquals("ORD-9988", orders.get(0).getOrderCode());
        assertEquals(new BigDecimal("1500.00"), orders.get(0).getTotalAmount());
        assertEquals("Apex Global Trade", orders.get(0).getCustomerName());
        assertEquals("PROCESSING", orders.get(0).getStatusName());
    }

    @Test
    @DisplayName("Should return null gracefully when order ID is not found")
    void testGetOrderDetailsNotFound() {
        when(em.find(Order.class, 99999L)).thenReturn(null);

        OrderDTO result = orderService.getOrderDetails(99999L);
        assertNull(result);
    }

    @Test
    @DisplayName("Should retrieve orders filtered by customer user ID")
    void testGetOrdersByCustomerUserId() {
        Customer dummyCustomer = new Customer();
        dummyCustomer.setId(99L);

        TypedQuery<Customer> customerQuery = mock(TypedQuery.class);
        when(em.createQuery(anyString(), eq(Customer.class))).thenReturn(customerQuery);
        when(customerQuery.setParameter(anyString(), any())).thenReturn(customerQuery);
        when(customerQuery.getResultList()).thenReturn(Collections.singletonList(dummyCustomer));

        when(em.createQuery(anyString(), eq(Order.class))).thenReturn(orderQuery);
        when(orderQuery.setParameter(anyString(), any())).thenReturn(orderQuery);
        when(orderQuery.getResultList()).thenReturn(Collections.emptyList());

        List<OrderDTO> orders = orderService.getOrdersByCustomerUserId(12L);
        assertNotNull(orders);
        assertTrue(orders.isEmpty());
    }

    @Test
    @DisplayName("createOrderWithBMT should deduct stock and commit the Bean-Managed Transaction")
    void testCreateOrderWithBMT_CommitsAndDeductsStock() throws Exception {
        Long customerId = 5L, vendorId = 7L, warehouseId = 1L, itemId = 20L;

        Customer customer = new Customer();
        customer.setId(customerId);
        customer.setName("Test Customer");

        Vendor vendor = new Vendor();
        vendor.setId(vendorId);

        InventoryItem item = new InventoryItem();
        item.setId(itemId);
        item.setName("Test Widget");

        InventoryStock stock = new InventoryStock();
        stock.setItem(item);
        stock.setStockQty(100);
        stock.setUnitPrice(new BigDecimal("10.00"));

        when(em.find(Customer.class, customerId)).thenReturn(customer);
        when(em.find(Vendor.class, vendorId)).thenReturn(vendor);
        when(em.find(InventoryItem.class, itemId)).thenReturn(item);

        TypedQuery<InventoryStock> stockLookupQuery = mock(TypedQuery.class);
        when(em.createQuery(anyString(), eq(InventoryStock.class))).thenReturn(stockLookupQuery);
        when(stockLookupQuery.setParameter(anyString(), any())).thenReturn(stockLookupQuery);
        when(stockLookupQuery.getSingleResult()).thenReturn(stock);

        Map<Long, Integer> items = new HashMap<>();
        items.put(itemId, 3);

        Order result = orderService.createOrderWithBMT(customerId, vendorId, items, warehouseId);

        assertNotNull(result);
        assertEquals(97, stock.getStockQty(), "Stock must be decremented by the ordered quantity");
        verify(userTransaction, times(1)).begin();
        verify(userTransaction, times(1)).commit();
        verify(userTransaction, never()).rollback();
    }

    @Test
    @DisplayName("createOrderWithBMT should roll back the transaction when requested quantity exceeds available stock")
    void testCreateOrderWithBMT_RollsBackOnInsufficientStock() throws Exception {
        Long customerId = 5L, vendorId = 7L, warehouseId = 1L, itemId = 20L;

        Customer customer = new Customer();
        customer.setId(customerId);

        InventoryItem item = new InventoryItem();
        item.setId(itemId);
        item.setName("Scarce Widget");

        InventoryStock stock = new InventoryStock();
        stock.setItem(item);
        stock.setStockQty(2);

        when(em.find(Customer.class, customerId)).thenReturn(customer);
        when(em.find(Vendor.class, vendorId)).thenReturn(new Vendor());
        when(em.find(InventoryItem.class, itemId)).thenReturn(item);

        TypedQuery<InventoryStock> stockLookupQuery = mock(TypedQuery.class);
        when(em.createQuery(anyString(), eq(InventoryStock.class))).thenReturn(stockLookupQuery);
        when(stockLookupQuery.setParameter(anyString(), any())).thenReturn(stockLookupQuery);
        when(stockLookupQuery.getSingleResult()).thenReturn(stock);

        when(userTransaction.getStatus()).thenReturn(jakarta.transaction.Status.STATUS_ACTIVE);

        Map<Long, Integer> items = new HashMap<>();
        items.put(itemId, 5);

        Exception ex = assertThrows(Exception.class, () ->
                orderService.createOrderWithBMT(customerId, vendorId, items, warehouseId));

        assertTrue(ex.getMessage().contains("Order creation failed"),
                "Wrapped exception must explain the BMT rollback cause");
        verify(userTransaction, times(1)).rollback();
        verify(userTransaction, never()).commit();
    }
}
