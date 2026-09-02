package com.globaltrade.ejb;

import com.globaltrade.ejb.interceptor.PerformanceMonitorInterceptor;
import jakarta.interceptor.InvocationContext;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.lang.reflect.Method;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class PerformanceBenchmarkTest {

    @BeforeAll
    static void setUp() {
        PerformanceMonitorInterceptor.resetMetrics();
    }

    @Test
    @DisplayName("Run 2000 timed iterations to generate PerformanceMetrics report")
    void testPerformanceBenchmark() throws Exception {
        PerformanceMonitorInterceptor interceptor = new PerformanceMonitorInterceptor();

        InvocationContext orderContext = mock(InvocationContext.class);
        Method getAllOrdersMethod = OrderServiceBean.class.getMethod("getAllOrders");
        when(orderContext.getTarget()).thenReturn(new OrderServiceBean());
        when(orderContext.getMethod()).thenReturn(getAllOrdersMethod);
        when(orderContext.proceed()).thenAnswer(inv -> {
            return null;
        });

        InvocationContext orderDetailsContext = mock(InvocationContext.class);
        Method getOrderDetailsMethod = OrderServiceBean.class.getMethod("getOrderDetails", Long.class);
        when(orderDetailsContext.getTarget()).thenReturn(new OrderServiceBean());
        when(orderDetailsContext.getMethod()).thenReturn(getOrderDetailsMethod);
        when(orderDetailsContext.proceed()).thenAnswer(inv -> null);

        System.out.println("Running 200 warm-up calls...");
        for (int i = 0; i < 200; i++) {
            interceptor.monitorPerformance(orderContext);
            interceptor.monitorPerformance(orderDetailsContext);
        }
        PerformanceMonitorInterceptor.resetMetrics();

        System.out.println("Running 2000 timed iterations...");
        for (int i = 0; i < 2000; i++) {
            interceptor.monitorPerformance(orderContext);
            interceptor.monitorPerformance(orderDetailsContext);
        }
    }

    @AfterAll
    static void tearDown() {
        System.out.println("\n--- Benchmark Complete. Generating Report ---");
        String report = PerformanceMonitorInterceptor.dumpMetricsReport();
        System.out.println(report);
    }
}
