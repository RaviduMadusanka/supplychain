package com.globaltrade.ejb;

import com.globaltrade.core.dto.OrderDTO;
import com.globaltrade.core.service.OrderService;
import org.jboss.arquillian.container.test.api.Deployment;
import org.jboss.arquillian.junit5.ArquillianExtension;
import org.jboss.shrinkwrap.api.ShrinkWrap;
import org.jboss.shrinkwrap.api.asset.EmptyAsset;
import org.jboss.shrinkwrap.api.spec.JavaArchive;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;

import jakarta.ejb.EJB;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(ArquillianExtension.class)
@Tag("integration")
@DisplayName("OrderServiceBean -- Arquillian Container Integration Tests")
public class OrderServiceIntegrationTest {

    @Deployment
    public static JavaArchive createDeployment() {
        return ShrinkWrap.create(JavaArchive.class, "order-service-integration-test.jar")
                .addPackages(true, "com.globaltrade.core")
                .addClasses(
                        OrderServiceBean.class,
                        InventoryServiceBean.class,
                        com.globaltrade.ejb.interceptor.AuditLogInterceptor.class,
                        com.globaltrade.ejb.interceptor.PerformanceMonitorInterceptor.class,
                        com.globaltrade.ejb.interceptor.ExceptionLoggingInterceptor.class,
                        com.globaltrade.ejb.interceptor.AuthorizationInterceptor.class,
                        com.globaltrade.ejb.interceptor.VendorDataValidationInterceptor.class
                )
                .addAsManifestResource("META-INF/persistence.xml", "persistence.xml")
                .addAsManifestResource(EmptyAsset.INSTANCE, "beans.xml");
    }

    @EJB(beanName = "OrderServiceBean")
    private OrderService orderService;

    @Test
    @DisplayName("getAllOrders() must return non-null list from container JPA context")
    void testGetAllOrdersReturnsListFromContainer() {
        List<OrderDTO> orders = orderService.getAllOrders();
        assertNotNull(orders,
                "getAllOrders() must return non-null list -- empty list is valid for fresh DB");
    }

    @Test
    @DisplayName("getOrderDetails() with unknown ID must return null without exception")
    void testGetOrderDetailsWithUnknownIdReturnsNull() {
        Long nonExistentId = 999_999L;
        OrderDTO result = orderService.getOrderDetails(nonExistentId);
        assertNull(result,
                "getOrderDetails() with unknown PK must return null gracefully, not throw");
    }

    @Test
    @DisplayName("getOrdersByCustomerUserId() must return empty list for non-existent customer")
    void testGetOrdersByNonExistentCustomer() {
        Long ghostUserId = 888_888L;
        List<OrderDTO> result = orderService.getOrdersByCustomerUserId(ghostUserId);
        assertNotNull(result, "Result must never be null");
        assertTrue(result.isEmpty(), "No orders must exist for a non-existent userId");
    }
}