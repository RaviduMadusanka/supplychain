package com.globaltrade.ejb.interceptor;

import com.globaltrade.core.entity.ExceptionLog;
import jakarta.interceptor.AroundInvoke;
import jakarta.interceptor.InvocationContext;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.time.LocalDateTime;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ExceptionLoggingInterceptor {

    private static final Logger LOGGER = Logger.getLogger(ExceptionLoggingInterceptor.class.getName());

    @PersistenceContext(unitName = "SupplyChainPU")
    private EntityManager em;

    @AroundInvoke
    public Object handleAndLogException(InvocationContext ic) throws Exception {
        try {
            return ic.proceed();
        } catch (Exception ex) {
            String className = ic.getTarget().getClass().getSimpleName().replaceAll("\\$\\$Lambda.*", "");
            String methodName = ic.getMethod().getName();

            LOGGER.log(Level.SEVERE, "[EXCEPTION-INTERCEPTOR] Intercepted Exception in EJB: {0}.{1}(): {2}",
                    new Object[]{className, methodName, ex.getMessage()});

            try {
                if (em != null) {
                    ExceptionLog log = new ExceptionLog();
                    log.setSourceComponent(className + "." + methodName + "()");
                    log.setExceptionType(ex.getClass().getName());
                    log.setMessage(ex.getMessage() != null ? ex.getMessage() : "No message provided");
                    log.setResolvedStatus("UNRESOLVED");
                    log.setOccurredAt(LocalDateTime.now());

                    StringWriter sw = new StringWriter();
                    PrintWriter pw = new PrintWriter(sw);
                    ex.printStackTrace(pw);
                    String stackTraceStr = sw.toString();
                    if (stackTraceStr.length() > 2000) {
                        stackTraceStr = stackTraceStr.substring(0, 2000) + "... [truncated]";
                    }
                    log.setStackTrace(stackTraceStr);

                    em.persist(log);
                }
            } catch (Exception dbEx) {
                LOGGER.log(Level.WARNING, "[EXCEPTION-INTERCEPTOR] Could not persist ExceptionLog to DB: {0}", dbEx.getMessage());
            }

            // Always rethrow original exception to maintain transactional integrity and client visibility
            throw ex;
        }
    }
}