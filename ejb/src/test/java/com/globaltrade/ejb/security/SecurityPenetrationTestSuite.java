package com.globaltrade.ejb.security;

import com.globaltrade.core.context.UserContext;
import com.globaltrade.core.dto.UserDTO;
import com.globaltrade.core.security.RequiresRole;
import com.globaltrade.ejb.interceptor.AuthorizationInterceptor;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.lang.reflect.Method;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("SecurityPenetrationTestSuite -- AuthorizationInterceptor Adversarial Tests")
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class SecurityPenetrationTestSuite {

    @Mock
    private jakarta.interceptor.InvocationContext invocationContext;

    private AuthorizationInterceptor interceptor;


    static class AdminOnlyBean {
        @RequiresRole("ADMIN")
        public void deleteUser() {}
    }

    static class WarehouseBean {
        @RequiresRole("WAREHOUSE_MANAGER")
        public void updateStockLevel() {}
    }

    static class ReportBean {
        @RequiresRole({"ADMIN", "WAREHOUSE_MANAGER"})
        public void generateInventoryReport() {}
    }

    @BeforeEach
    void setUp() {
        interceptor = new AuthorizationInterceptor();
        UserContext.clear();
    }

    @AfterEach
    void tearDown() {
        UserContext.clear();
    }

    @Test
    @Order(1)
    @DisplayName("[PENTEST-01] Unauthenticated caller (null UserContext) must be BLOCKED")
    void test_unauthenticated_caller_blocked() throws Exception {
        UserContext.clear();
        Method method = AdminOnlyBean.class.getMethod("deleteUser");
        when(invocationContext.getMethod()).thenReturn(method);
        when(invocationContext.getTarget()).thenReturn(new AdminOnlyBean());

        SecurityException ex = assertThrows(SecurityException.class,
                () -> interceptor.checkAuthorization(invocationContext));

        assertTrue(ex.getMessage().contains("Authentication Required"),
                "Must report missing authentication context");
        System.out.println("[PENTEST-01 BLOCKED] " + ex.getMessage());
    }

    @Test
    @Order(2)
    @DisplayName("[PENTEST-02] CUSTOMER attempting ADMIN method must be BLOCKED")
    void test_customer_accessing_admin_method_blocked() throws Exception {
        UserContext.setUser(buildUser(42L, "malicious_customer", "CUSTOMER"));
        Method method = AdminOnlyBean.class.getMethod("deleteUser");
        when(invocationContext.getMethod()).thenReturn(method);
        when(invocationContext.getTarget()).thenReturn(new AdminOnlyBean());

        SecurityException ex = assertThrows(SecurityException.class,
                () -> interceptor.checkAuthorization(invocationContext));

        assertTrue(ex.getMessage().contains("malicious_customer"),
                "Audit message must include attacker username");
        assertTrue(ex.getMessage().contains("CUSTOMER"),
                "Audit message must include caller's actual role");
        System.out.println("[PENTEST-02 BLOCKED] " + ex.getMessage());
    }

    @Test
    @Order(3)
    @DisplayName("[PENTEST-03] VENDOR attempting WAREHOUSE_MANAGER resource must be BLOCKED")
    void test_vendor_accessing_warehouse_operation_blocked() throws Exception {
        UserContext.setUser(buildUser(77L, "apex_tech_vendor", "VENDOR"));
        Method method = WarehouseBean.class.getMethod("updateStockLevel");
        when(invocationContext.getMethod()).thenReturn(method);
        when(invocationContext.getTarget()).thenReturn(new WarehouseBean());

        SecurityException ex = assertThrows(SecurityException.class,
                () -> interceptor.checkAuthorization(invocationContext));

        assertTrue(ex.getMessage().contains("apex_tech_vendor"),
                "Audit message must identify the vendor account");
        System.out.println("[PENTEST-03 BLOCKED] " + ex.getMessage());
    }

    @Test
    @Order(4)
    @DisplayName("[PENTEST-04] SQL-injection role string must NOT bypass role check")
    void test_role_injection_attempt_blocked() throws Exception {
        UserContext.setUser(buildUser(13L, "sqli_attacker", "CUSTOMER' OR '1'='1"));
        Method method = AdminOnlyBean.class.getMethod("deleteUser");
        when(invocationContext.getMethod()).thenReturn(method);
        when(invocationContext.getTarget()).thenReturn(new AdminOnlyBean());

        SecurityException ex = assertThrows(SecurityException.class,
                () -> interceptor.checkAuthorization(invocationContext));

        System.out.println("[PENTEST-04 BLOCKED] " + ex.getMessage());
    }

    @Test
    @Order(5)
    @DisplayName("[PENTEST-05] Empty role must be BLOCKED")
    void test_empty_role_bypass_blocked() throws Exception {
        UserContext.setUser(buildUser(55L, "broken_session_user", ""));
        Method method = AdminOnlyBean.class.getMethod("deleteUser");
        when(invocationContext.getMethod()).thenReturn(method);
        when(invocationContext.getTarget()).thenReturn(new AdminOnlyBean());

        SecurityException ex = assertThrows(SecurityException.class,
                () -> interceptor.checkAuthorization(invocationContext));

        assertTrue(ex.getMessage().contains("Access Denied"),
                "Must clearly state denial");
        System.out.println("[PENTEST-05 BLOCKED] " + ex.getMessage());
    }

    @Test
    @Order(6)
    @DisplayName("[PENTEST-06] Legitimate ADMIN on multi-role endpoint must be PERMITTED")
    void test_admin_accessing_multi_role_endpoint_permitted() throws Exception {
        UserContext.setUser(buildUser(1L, "nadeesha_admin", "ADMIN"));
        Method method = ReportBean.class.getMethod("generateInventoryReport");
        when(invocationContext.getMethod()).thenReturn(method);
        when(invocationContext.getTarget()).thenReturn(new ReportBean());
        when(invocationContext.proceed()).thenReturn("REPORT_DATA");

        Object result = interceptor.checkAuthorization(invocationContext);

        assertEquals("REPORT_DATA", result);
        verify(invocationContext, times(1)).proceed();
        System.out.println("[PENTEST-06 PERMITTED] ADMIN access to multi-role endpoint: ALLOWED");
    }

    private UserDTO buildUser(Long id, String username, String role) {
        UserDTO user = new UserDTO();
        user.setId(id);
        user.setUsername(username);
        user.setRole(role);
        return user;
    }
}