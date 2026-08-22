package com.globaltrade.core.dto;

import java.io.Serializable;
import java.time.LocalDateTime;

public class ExceptionLogDTO implements Serializable {
    private Long id;
    private String sourceComponent;
    private String exceptionType;
    private String message;
    private String stackTrace;
    private LocalDateTime occurredAt;
    private String resolvedStatus;

    public ExceptionLogDTO() {}

    public ExceptionLogDTO(Long id, String sourceComponent, String exceptionType, String message, String stackTrace, LocalDateTime occurredAt, String resolvedStatus) {
        this.id = id;
        this.sourceComponent = sourceComponent;
        this.exceptionType = exceptionType;
        this.message = message;
        this.stackTrace = stackTrace;
        this.occurredAt = occurredAt;
        this.resolvedStatus = resolvedStatus != null ? resolvedStatus : "UNRESOLVED";
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getSourceComponent() { return sourceComponent; }
    public void setSourceComponent(String sourceComponent) { this.sourceComponent = sourceComponent; }
    public String getExceptionType() { return exceptionType; }
    public void setExceptionType(String exceptionType) { this.exceptionType = exceptionType; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public String getStackTrace() { return stackTrace; }
    public void setStackTrace(String stackTrace) { this.stackTrace = stackTrace; }
    public LocalDateTime getOccurredAt() { return occurredAt; }
    public void setOccurredAt(LocalDateTime occurredAt) { this.occurredAt = occurredAt; }
    public String getResolvedStatus() { return resolvedStatus; }
    public void setResolvedStatus(String resolvedStatus) { this.resolvedStatus = resolvedStatus; }
}