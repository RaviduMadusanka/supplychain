package com.globaltrade.ejb;

import com.globaltrade.core.dto.AuditLogDTO;
import com.globaltrade.core.entity.AuditLog;
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
    }
}