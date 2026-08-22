package com.globaltrade.ejb.interceptor;

import com.globaltrade.core.exception.VendorValidationException;
import jakarta.interceptor.AroundInvoke;
import jakarta.interceptor.InvocationContext;
import java.util.Map;
import java.util.logging.Logger;

public class VendorDataValidationInterceptor {

    private static final Logger LOGGER = Logger.getLogger(VendorDataValidationInterceptor.class.getName());

    @AroundInvoke
    public Object validateVendorData(InvocationContext ic) throws Exception {
        String methodName = ic.getMethod().getName();
        Object[] params = ic.getParameters();

        LOGGER.info("[VALIDATION-INTERCEPTOR] Validating parameters for method: " + methodName);

        if ("createVendor".equals(methodName)) {
            if (params.length > 0 && (params[0] == null || params[0].toString().trim().isEmpty())) {
                throw new VendorValidationException("Company name cannot be null or empty.");
            }
            if (params.length > 2 && params[2] != null) {
                String email = params[2].toString().trim();
                if (!email.isEmpty() && !email.contains("@")) {
                    throw new VendorValidationException("Invalid vendor contact email address format: " + email);
                }
            }
        } else if ("createVendorProduct".equals(methodName)) {
            if (params.length > 0 && (params[0] == null || (Long) params[0] <= 0)) {
                throw new VendorValidationException("Valid Vendor ID (> 0) is mandatory for product listing.");
            }
            if (params.length > 1 && (params[1] == null || params[1].toString().trim().isEmpty())) {
                throw new VendorValidationException("Product SKU code is required.");
            }
            if (params.length > 2 && (params[2] == null || params[2].toString().trim().isEmpty())) {
                throw new VendorValidationException("Product Title / Name is required.");
            }
        } else if ("createPurchaseOrder".equals(methodName)) {
            if (params.length > 0 && (params[0] == null || (Long) params[0] <= 0)) {
                throw new VendorValidationException("Valid Destination Warehouse ID is required for purchase order.");
            }
            if (params.length > 1 && (params[1] == null || (Long) params[1] <= 0)) {
                throw new VendorValidationException("Valid Supplier / Vendor ID is required for purchase order.");
            }
            if (params.length > 2) {
                if (params[2] == null || ((Map<?, ?>) params[2]).isEmpty()) {
                    throw new VendorValidationException("Purchase order must include at least one restock product item line.");
                }
            }
        } else if ("updateVendorStatus".equals(methodName)) {
            if (params.length > 0 && (params[0] == null || (Long) params[0] <= 0)) {
                throw new VendorValidationException("Vendor ID is mandatory for status update.");
            }
            if (params.length > 1 && (params[1] == null || params[1].toString().trim().isEmpty())) {
                throw new VendorValidationException("Target Account Status cannot be null or blank.");
            }
        }

        return ic.proceed();
    }
}