package com.globaltrade.ejb.interceptor;

import jakarta.interceptor.AroundInvoke;
import jakarta.interceptor.InvocationContext;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * PerformanceMonitorInterceptor -- EJB Method-Level Latency and Throughput Monitor.
 *
 * Intercepts every EJB method invocation and records:
 *   - Wall-clock execution time (ms)
 *   - Cumulative call count per method
 *   - Running min / avg / max duration per method
 *
 * Metrics are stored in a JVM-scoped ConcurrentHashMap and dumped hourly by
 * PerformanceMetricsReportTimerBean and via the /monitoring/performance admin endpoint.
 */
public class PerformanceMonitorInterceptor {

    private static final Logger LOGGER = Logger.getLogger(PerformanceMonitorInterceptor.class.getName());
    private static final long LATENCY_THRESHOLD_MS = 500L;

    // ------------------------------------------------------------------
    // Per-method metrics record
    // ------------------------------------------------------------------

    public static final class MethodMetrics {
        public final String methodKey;
        public final AtomicLong callCount = new AtomicLong(0);
        public final AtomicLong totalMs   = new AtomicLong(0);
        public final AtomicLong minMs     = new AtomicLong(Long.MAX_VALUE);
        public final AtomicLong maxMs     = new AtomicLong(0);

        public MethodMetrics(String methodKey) { this.methodKey = methodKey; }

        public long getAvgMs() {
            long count = callCount.get();
            return count == 0 ? 0 : totalMs.get() / count;
        }

        public void record(long durationMs) {
            callCount.incrementAndGet();
            totalMs.addAndGet(durationMs);
            long prev;
            do { prev = minMs.get(); } while (durationMs < prev && !minMs.compareAndSet(prev, durationMs));
            do { prev = maxMs.get(); } while (durationMs > prev && !maxMs.compareAndSet(prev, durationMs));
        }

        @Override
        public String toString() {
            return String.format("%-55s | calls=%4d | min=%3dms | avg=%3dms | max=%4dms | total=%5dms",
                    methodKey, callCount.get(),
                    minMs.get() == Long.MAX_VALUE ? 0 : minMs.get(),
                    getAvgMs(), maxMs.get(), totalMs.get());
        }
    }

    /** Global metrics registry -- shared across all EJB instances in this JVM. */
    public static final ConcurrentHashMap<String, MethodMetrics> METRICS_REGISTRY =
            new ConcurrentHashMap<>();

    // ------------------------------------------------------------------
    // Interceptor
    // ------------------------------------------------------------------

    @AroundInvoke
    public Object monitorPerformance(InvocationContext ic) throws Exception {
        String className  = ic.getTarget().getClass().getSimpleName().replaceAll("[$].*", "");
        String methodName = ic.getMethod().getName();
        String metricKey  = className + "." + methodName;

        long startTime = System.currentTimeMillis();
        try {
            return ic.proceed();
        } finally {
            long duration = System.currentTimeMillis() - startTime;

            METRICS_REGISTRY.computeIfAbsent(metricKey, MethodMetrics::new).record(duration);

            if (duration > LATENCY_THRESHOLD_MS) {
                LOGGER.log(Level.WARNING,
                        "[PERFORMANCE-ALERT] HIGH LATENCY in EJB method: {0}.{1}() -- {2} ms (threshold: {3} ms)",
                        new Object[]{className, methodName, duration, LATENCY_THRESHOLD_MS});
            } else {
                LOGGER.log(Level.INFO,
                        "[PERFORMANCE] EJB method: {0}.{1}() executed in {2} ms",
                        new Object[]{className, methodName, duration});
            }
        }
    }

    // ------------------------------------------------------------------
    // Report generator (called by timer + admin endpoint)
    // ------------------------------------------------------------------

    public static String dumpMetricsReport() {
        if (METRICS_REGISTRY.isEmpty()) {
            String msg = "[PERFORMANCE-REPORT] No EJB metrics recorded yet.";
            LOGGER.info(msg);
            return msg;
        }

        StringBuilder sb = new StringBuilder();
        sb.append("\n");
        sb.append("==========================================================================================================================================\n");
        sb.append(" NexTrade SCM -- EJB Performance Metrics Report\n");
        sb.append("==========================================================================================================================================\n");
        sb.append(String.format(" Generated at    : %s%n", java.time.LocalDateTime.now()));
        sb.append(String.format(" Tracked methods : %d%n", METRICS_REGISTRY.size()));
        sb.append("------------------------------------------------------------------------------------------------------------------------------------------\n");
        sb.append(String.format(" %-55s | %-8s | %-8s | %-8s | %-9s | %-10s%n",
                "EJB Method", "Calls", "Min(ms)", "Avg(ms)", "Max(ms)", "Total(ms)"));
        sb.append("------------------------------------------------------------------------------------------------------------------------------------------\n");

        METRICS_REGISTRY.values().stream()
                .sorted((a, b) -> Long.compare(b.totalMs.get(), a.totalMs.get()))
                .forEach(m -> sb.append(" ").append(m).append("\n"));

        sb.append("==========================================================================================================================================");

        String report = sb.toString();
        LOGGER.info(report);
        return report;
    }

    public static void resetMetrics() {
        int cleared = METRICS_REGISTRY.size();
        METRICS_REGISTRY.clear();
        LOGGER.info("[PERFORMANCE] Metrics registry cleared. " + cleared + " method entries removed.");
    }
}