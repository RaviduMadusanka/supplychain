package com.globaltrade.ejb.interceptor;

import com.globaltrade.core.context.UserContext;
import com.globaltrade.core.dto.UserDTO;
import com.globaltrade.core.exception.VendorValidationException;
import com.globaltrade.core.security.RequiresRole;
import jakarta.interceptor.InvocationContext;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.lang.reflect.Method;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class InterceptorSuiteTest {

    @Mock
    private InvocationContext invocationContext;

    @AfterEach
    void tearDown() {
        UserContext.clear();
    }

    @RequiresRole("ADMIN")
    static class SampleSecuredBean {
        public void executeAdminTask() {}
        public void createVendor(String companyName, String contact, String email, String phone) {}
    }

    @Test
    @DisplayName("PerformanceMonitorInterceptor should proceed invocation and measure elapsed time")
    void testPerformanceMonitorInterceptorProceeds() throws Exception {
        PerformanceMonitorInterceptor interceptor = new PerformanceMonitorInterceptor();

        Method sampleMethod = SampleSecuredBean.class.getMethod("executeAdminTask");
        when(invocationContext.getTarget()).thenReturn(new SampleSecuredBean());
        when(invocationContext.getMethod()).thenReturn(sampleMethod);
        when(invocationContext.proceed()).thenReturn("SUCCESS");

        Object result = interceptor.monitorPerformance(invocationContext);

        assertEquals("SUCCESS", result);
        verify(invocationContext, times(1)).proceed();
    }

    @Test
    @DisplayName("VendorDataValidationInterceptor should throw VendorValidationException on blank company name")
    void testVendorDataValidationInterceptorRejectsBlankName() throws Exception {
        VendorDataValidationInterceptor interceptor = new VendorDataValidationInterceptor();

        Method createVendorMethod = SampleSecuredBean.class.getMethod("createVendor", String.class, String.class, String.class, String.class);
        when(invocationContext.getMethod()).thenReturn(createVendorMethod);
        when(invocationContext.getParameters()).thenReturn(new Object[]{"   ", "Contact", "email@test.com", "123"});

        assertThrows(VendorValidationException.class, () -> {
            interceptor.validateVendorData(invocationContext);
        });
    }

    @Test
    @DisplayName("AuthorizationInterceptor should throw SecurityException when caller lacks ADMIN role")
    void testAuthorizationInterceptorRejectsNonAdmin() throws Exception {
        AuthorizationInterceptor interceptor = new AuthorizationInterceptor();

        UserDTO customerUser = new UserDTO();
        customerUser.setId(99L);
        customerUser.setUsername("customer1");
        customerUser.setRole("CUSTOMER");
        UserContext.setUser(customerUser);

        Method sampleMethod = SampleSecuredBean.class.getMethod("executeAdminTask");
        when(invocationContext.getTarget()).thenReturn(new SampleSecuredBean());
        when(invocationContext.getMethod()).thenReturn(sampleMethod);

        assertThrows(SecurityException.class, () -> {
            interceptor.checkAuthorization(invocationContext);
        });
    }

    @Test
    @DisplayName("AuthorizationInterceptor should permit invocation when caller possesses ADMIN role")
    void testAuthorizationInterceptorAllowsAdmin() throws Exception {
        AuthorizationInterceptor interceptor = new AuthorizationInterceptor();

        UserDTO adminUser = new UserDTO();
        adminUser.setId(1L);
        adminUser.setUsername("admin1");
        adminUser.setRole("ADMIN");
        UserContext.setUser(adminUser);

        Method sampleMethod = SampleSecuredBean.class.getMethod("executeAdminTask");
        when(invocationContext.getTarget()).thenReturn(new SampleSecuredBean());
        when(invocationContext.getMethod()).thenReturn(sampleMethod);
        when(invocationContext.proceed()).thenReturn("ALLOWED");

        Object result = interceptor.checkAuthorization(invocationContext);

        assertEquals("ALLOWED", result);
        verify(invocationContext, times(1)).proceed();
    }
}