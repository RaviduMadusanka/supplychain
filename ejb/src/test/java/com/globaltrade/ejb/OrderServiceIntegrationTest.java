package com.globaltrade.ejb;

import com.globaltrade.core.dto.OrderDTO;
import com.globaltrade.core.service.OrderService;
import org.jboss.arquillian.container.test.api.Deployment;
import org.jboss.arquillian.junit5.ArquillianExtension;
import org.jboss.shrinkwrap.api.ShrinkWrap;
import org.jboss.shrinkwrap.api.spec.JavaArchive;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;

import jakarta.ejb.EJB;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Arquillian Container Integration Tests for OrderServiceBean.
 *
 * These tests deploy a real micro-archive into the running GlassFish 7 container
 * and invoke EJB business methods in-container -- verifying that JPA, transactions,
 * and interceptor chains behave identically to the production runtime environment.
 *
 * Unlike the unit tests (which use Mockito to simulate container behaviour),
 * these tests exercise the full Jakarta EE stack:
 *   - EclipseLink JPA provider with the real SupplyChainPU persistence unit
 *   - GlassFish EJB container with full interceptor chain
 *   - JDBC DataSource (jdbc/SupplyChainDS)
 *   - BMT UserTransaction managed by the container
 *
 * Activation:
 *   mvn clean test -Parq-glassfish-remote
 *
 * Prerequisites:
 *   1. GlassFish 7 running on localhost:4848
 *   2. jdbc/SupplyChainDS JNDI resource configured
 *   3. ear-1.0-SNAPSHOT.ear deployed (or datasource accessible)
 */
@ExtendWith(ArquillianExtension.class)
@Tag("integration")
@DisplayName("OrderServiceBean -- Arquillian Container Integration Tests")
public class OrderServiceIntegrationTest {

    /**
     * ShrinkWrap deployment archive.
     * Assembles the minimal set of classes needed for this test into a JAR
     * that Arquillian deploys into the running GlassFish instance.
     */
    @Deployment
    public static JavaArchive createDeployment() {
        return ShrinkWrap.create(JavaArchive.class, "order-service-integration-test.jar")
                .addPackages(true, "com.globaltrade.core")
                .addPackages(true, "com.globaltrade.ejb")
                .addAsManifestResource("META-INF/persistence.xml", "persistence.xml")
                .addAsManifestResource("META-INF/beans.xml", "beans.xml");
    }

    /** Container injects the real EJB proxy -- full JPA + transaction stack active. */
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