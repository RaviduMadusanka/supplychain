package com.globaltrade.core.exception;

import jakarta.ejb.ApplicationException;

@ApplicationException(rollback = true)
public class VendorValidationException extends Exception {
    public VendorValidationException(String message) {
        super(message);
    }
}