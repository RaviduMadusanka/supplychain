package com.globaltrade.ejb.timer;

import com.globaltrade.ejb.interceptor.PerformanceMonitorInterceptor;
import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import java.util.logging.Logger;

/**
 * PerformanceMetricsReportTimerBean -- Scheduled EJB Performance Evidence Generator.
 *
 * Fires hourly and dumps a complete formatted EJB performance metrics table to the
 * GlassFish server log, providing measurable evidence of PerformanceMonitorInterceptor
 * data collection for documentation and assessment purposes.
 *
 * Metrics captured per EJB method:
 *   - Total invocation count
 *   - Minimum / Average / Maximum execution time (ms)
 *   - Cumulative total execution time (ms)
 *
 * Timer Strategy: persistent=false because performance metrics are ephemeral diagnostic
 * data -- they reset on each server restart to reflect fresh runtime behaviour rather
 * than carrying stale data from a previous JVM run.
 * (Contrast with ShipmentTrackingTimerBean which uses persistent=true for business-critical
 * state transitions.)
 */
@Singleton
@Startup
public class PerformanceMetricsReportTimerBean {

    private static final Logger LOGGER = Logger.getLogger(PerformanceMetricsReportTimerBean.class.getName());

    /**
     * Fires every hour at minute 0 and dumps the EJB performance metrics report.
     * persistent=false: performance metrics are ephemeral diagnostic data.
     */
    @Schedule(hour = "*", minute = "0", second = "0", persistent = false,
              info = "NexTrade-EJB-PerformanceMetrics-HourlyReport")
    public void generatePerformanceReport() {
        LOGGER.info("[TIMER] PerformanceMetricsReportTimerBean firing -- generating EJB performance evidence...");
        PerformanceMonitorInterceptor.dumpMetricsReport();
        LOGGER.info("[TIMER] Performance report complete. Methods tracked: "
                + PerformanceMonitorInterceptor.METRICS_REGISTRY.size());
    }
}