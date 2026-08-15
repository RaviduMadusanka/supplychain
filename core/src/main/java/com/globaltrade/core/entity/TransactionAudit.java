package com.globaltrade.core.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "transaction_audit")
public class TransactionAudit implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "transaction_type", length = 100)
    private String transactionType;

    @Column(name = "entity_reference", length = 200)
    private String entityReference;

    @Column(length = 50)
    private String status;

    @Column(name = "attribute_used", length = 50)
    private String attributeUsed;

    private LocalDateTime timestamp;

    @PrePersist
    protected void onCreate() {
        timestamp = LocalDateTime.now();
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getTransactionType() { return transactionType; }
    public void setTransactionType(String transactionType) { this.transactionType = transactionType; }
    public String getEntityReference() { return entityReference; }
    public void setEntityReference(String entityReference) { this.entityReference = entityReference; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getAttributeUsed() { return attributeUsed; }
    public void setAttributeUsed(String attributeUsed) { this.attributeUsed = attributeUsed; }
    public LocalDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
}
