package com.globaltrade.ejb.interceptor;

import jakarta.interceptor.AroundInvoke;
import jakarta.interceptor.InvocationContext;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PerformanceMonitorInterceptor {

    private static final Logger LOGGER = Logger.getLogger(PerformanceMonitorInterceptor.class.getName());
    private static final long LATENCY_THRESHOLD_MS = 500L; // Threshold for warning

    @AroundInvoke
    public Object monitorPerformance(InvocationContext ic) throws Exception {
        long startTime = System.currentTimeMillis();
        String className = ic.getTarget().getClass().getSimpleName().replaceAll("\\$\\$Lambda.*", "");
        String methodName = ic.getMethod().getName();

        try {
            return ic.proceed();
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            if (duration > LATENCY_THRESHOLD_MS) {
                LOGGER.log(Level.WARNING, "[PERFORMANCE-ALERT] High latency in EJB method: {0}.{1}() executed in {2} ms (Threshold: {3} ms)",
                        new Object[]{className, methodName, duration, LATENCY_THRESHOLD_MS});
            } else {
                LOGGER.log(Level.INFO, "[PERFORMANCE] EJB method: {0}.{1}() executed in {2} ms",
                        new Object[]{className, methodName, duration});
            }
        }
    }
}