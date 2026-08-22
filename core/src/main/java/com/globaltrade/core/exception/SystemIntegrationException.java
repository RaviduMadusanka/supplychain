package com.globaltrade.core.exception;

public class SystemIntegrationException extends RuntimeException {
    public SystemIntegrationException(String message) {
        super(message);
    }

    public SystemIntegrationException(String message, Throwable cause) {
        super(message, cause);
    }
}