package com.globaltrade.core.dto;

import java.io.Serializable;
import java.time.LocalDateTime;

public class AuditLogDTO implements Serializable {
    private Long id;
    private String entityName;
    private Long entityId;
    private String action;
    private String performedByUserName;
    private String performedByFullName;
    private LocalDateTime performedAt;
    private String details;
    
    public AuditLogDTO() {}
    
    public AuditLogDTO(Long id, String entityName, Long entityId, String action, String performedByUserName, String performedByFullName, LocalDateTime performedAt, String details) {
        this.id = id;
        this.entityName = entityName;
        this.entityId = entityId;
        this.action = action;
        this.performedByUserName = performedByUserName;
        this.performedByFullName = performedByFullName;
        this.performedAt = performedAt;
        this.details = details;
    }
    
    public Long getId() { return id; }
    public String getEntityName() { return entityName; }
    public Long getEntityId() { return entityId; }
    public String getAction() { return action; }
    public String getPerformedByUserName() { return performedByUserName; }
    public String getPerformedByFullName() { return performedByFullName; }
    public LocalDateTime getPerformedAt() { return performedAt; }
    public String getDetails() { return details; }
}