package com.globaltrade.ejb.interceptor;

import com.globaltrade.core.context.UserContext;
import com.globaltrade.core.dto.UserDTO;
import com.globaltrade.core.entity.AuditLog;
import com.globaltrade.core.entity.User;
import jakarta.annotation.Resource;
import jakarta.ejb.SessionContext;
import jakarta.interceptor.AroundInvoke;
import jakarta.interceptor.InvocationContext;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.util.Arrays;

public class AuditLogInterceptor {

    @PersistenceContext(unitName = "SupplyChainPU")
    private EntityManager em;

    @AroundInvoke
    public Object logAudit(InvocationContext ic) throws Exception {
        // Proceed with the actual method execution first
        Object result = null;
        try {
            result = ic.proceed();
        } catch (Exception e) {
            // Even if it failed, we could log it, but usually we log successful actions
            throw e;
        }

        // After successful execution, log the audit
        try {
            UserDTO currentUserDTO = UserContext.getUser();
            if (currentUserDTO != null) {
                User performedBy = em.find(User.class, currentUserDTO.getId());

                AuditLog log = new AuditLog();
                log.setEntityName(ic.getTarget().getClass().getSimpleName());
                log.setAction(ic.getMethod().getName());
                log.setPerformedBy(performedBy);
                
                // Construct details from parameters
                String details = "Method " + ic.getMethod().getName() + " called with arguments: " + 
                                 Arrays.toString(ic.getParameters());
                log.setDetails(details);

                // We don't have a specific entityId here universally unless we parse the return type or arguments, 
                // so we just log the general action.
                log.setEntityId(0L); 

                em.persist(log);
            }
        } catch (Exception e) {
            System.err.println("Failed to write Audit Log: " + e.getMessage());
        }

        return result;
    }
}
