package com.globaltrade.core.util;

import com.globaltrade.core.exception.SystemIntegrationException;
import java.util.concurrent.Callable;
import java.util.logging.Level;
import java.util.logging.Logger;

public class RetryExecutor {

    private static final Logger LOGGER = Logger.getLogger(RetryExecutor.class.getName());

    public static <T> T executeWithRetry(Callable<T> task, int maxRetries, long delayMs, String operationName, Callable<T> fallback) throws Exception {
        int attempts = 0;
        Exception lastException = null;

        while (attempts < maxRetries) {
            try {
                attempts++;
                return task.call();
            } catch (Exception ex) {
                lastException = ex;
                LOGGER.log(Level.WARNING, "[RETRY-POLICY] Attempt {0}/{1} failed for operation ''{2}'': {3}",
                        new Object[]{attempts, maxRetries, operationName, ex.getMessage()});

                if (attempts < maxRetries) {
                    try {
                        Thread.sleep(delayMs * attempts);
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                        throw new SystemIntegrationException("Execution interrupted during retry backoff for " + operationName, ie);
                    }
                }
            }
        }

        LOGGER.log(Level.SEVERE, "[RECOVERY-TRIGGERED] All {0} attempts exhausted for ''{1}''. Invoking fallback mechanism.",
                new Object[]{maxRetries, operationName});

        if (fallback != null) {
            try {
                return fallback.call();
            } catch (Exception fallbackEx) {
                LOGGER.log(Level.SEVERE, "[FALLBACK-FAILURE] Fallback handler failed for ''{0}'': {1}",
                        new Object[]{operationName, fallbackEx.getMessage()});
                throw fallbackEx;
            }
        }

        throw new SystemIntegrationException("Operation '" + operationName + "' failed after " + maxRetries + " retry attempts.", lastException);
    }
}