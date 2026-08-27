package com.globaltrade.ejb.timer;

import com.globaltrade.ejb.interceptor.PerformanceMonitorInterceptor;
import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import java.util.logging.Logger;

@Singleton
@Startup
public class PerformanceMetricsReportTimerBean {

    private static final Logger LOGGER = Logger.getLogger(PerformanceMetricsReportTimerBean.class.getName());
    @Schedule(hour = "*", minute = "0", second = "0", persistent = false,
              info = "NexTrade-EJB-PerformanceMetrics-HourlyReport")
    public void generatePerformanceReport() {
        LOGGER.info("[TIMER] PerformanceMetricsReportTimerBean firing -- generating EJB performance evidence...");
        PerformanceMonitorInterceptor.dumpMetricsReport();
        LOGGER.info("[TIMER] Performance report complete. Methods tracked: "
                + PerformanceMonitorInterceptor.METRICS_REGISTRY.size());
    }
}