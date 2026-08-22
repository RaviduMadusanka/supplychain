package com.globaltrade.ejb;

import com.globaltrade.core.dto.AuditLogDTO;
import com.globaltrade.core.dto.ExceptionLogDTO;
import com.globaltrade.core.entity.AuditLog;
import com.globaltrade.core.entity.ExceptionLog;
import com.globaltrade.core.service.AuditLogService;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.ArrayList;
import java.util.List;

@Stateless
public class AuditLogServiceBean implements AuditLogService {

    @PersistenceContext(unitName = "SupplyChainPU")
    private EntityManager em;

    @Override
    public List<AuditLogDTO> getRecentAuditLogs(int maxResults) {
        try {
            List<AuditLog> logs = em.createQuery("SELECT a FROM AuditLog a LEFT JOIN FETCH a.performedBy ORDER BY a.performedAt DESC", AuditLog.class)
                                    .setMaxResults(maxResults)
                                    .getResultList();
            
            List<AuditLogDTO> dtos = new ArrayList<>();
            for (AuditLog log : logs) {
                String userName = (log.getPerformedBy() != null) ? log.getPerformedBy().getUsername() : "SYSTEM";
                String fullName = (log.getPerformedBy() != null) ? log.getPerformedBy().getFullName() : "System Task";
                dtos.add(new AuditLogDTO(
                    log.getId(),
                    log.getEntityName(),
                    log.getEntityId(),
                    log.getAction(),
                    userName,
                    fullName,
                    log.getPerformedAt(),
                    log.getDetails()
                ));
            }
            return dtos;
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    @Override
    public List<ExceptionLogDTO> getRecentExceptionLogs(int maxResults) {
        try {
            List<ExceptionLog> logs = em.createQuery("SELECT e FROM ExceptionLog e ORDER BY e.occurredAt DESC", ExceptionLog.class)
                                        .setMaxResults(maxResults)
                                        .getResultList();

            List<ExceptionLogDTO> dtos = new ArrayList<>();
            for (ExceptionLog log : logs) {
                dtos.add(new ExceptionLogDTO(
                    log.getId(),
                    log.getSourceComponent(),
                    log.getExceptionType(),
                    log.getMessage(),
                    log.getStackTrace(),
                    log.getOccurredAt(),
                    log.getResolvedStatus()
                ));
            }
            return dtos;
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
}