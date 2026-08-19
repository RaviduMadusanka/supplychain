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
        Object result = null;
        try {
            result = ic.proceed();
        } catch (Exception e) {
            throw e;
        }

        try {
            UserDTO currentUserDTO = UserContext.getUser();
            if (currentUserDTO != null) {
                User performedBy = em.find(User.class, currentUserDTO.getId());

                AuditLog log = new AuditLog();
                log.setEntityName(ic.getTarget().getClass().getSimpleName());
                log.setAction(ic.getMethod().getName());
                log.setPerformedBy(performedBy);

                String details = "Method " + ic.getMethod().getName() + " called with arguments: " + 
                                 Arrays.toString(ic.getParameters());
                log.setDetails(details);
                log.setEntityId(0L); 

                em.persist(log);
            }
        } catch (Exception e) {
            System.err.println("Failed to write Audit Log: " + e.getMessage());
        }

        return result;
    }
}
