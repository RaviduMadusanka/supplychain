package com.globaltrade.core.exception;

import jakarta.ejb.ApplicationException;

@ApplicationException(rollback = true)
public class ShipmentTrackingException extends Exception {
    public ShipmentTrackingException(String message) {
        super(message);
    }
}