package com.globaltrade.core.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "exception_log")
public class ExceptionLog implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "exception_type", length = 200)
    private String exceptionType;

    @Column(name = "source_component", length = 200)
    private String sourceComponent;

    @Column(columnDefinition = "TEXT")
    private String message;

    @Column(name = "stack_trace", columnDefinition = "TEXT")
    private String stackTrace;

    @Column(name = "occurred_at")
    private LocalDateTime occurredAt;

    @Column(name = "resolved_status", length = 50)
    private String resolvedStatus;

    @PrePersist
    protected void onCreate() {
        occurredAt = LocalDateTime.now();
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getExceptionType() { return exceptionType; }
    public void setExceptionType(String exceptionType) { this.exceptionType = exceptionType; }
    public String getSourceComponent() { return sourceComponent; }
    public void setSourceComponent(String sourceComponent) { this.sourceComponent = sourceComponent; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public String getStackTrace() { return stackTrace; }
    public void setStackTrace(String stackTrace) { this.stackTrace = stackTrace; }
    public LocalDateTime getOccurredAt() { return occurredAt; }
    public void setOccurredAt(LocalDateTime occurredAt) { this.occurredAt = occurredAt; }
    public String getResolvedStatus() { return resolvedStatus; }
    public void setResolvedStatus(String resolvedStatus) { this.resolvedStatus = resolvedStatus; }
}
