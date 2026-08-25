package com.globaltrade.ejb.interceptor;

import com.globaltrade.core.context.UserContext;
import com.globaltrade.core.dto.UserDTO;
import com.globaltrade.core.security.RequiresRole;
import jakarta.interceptor.AroundInvoke;
import jakarta.interceptor.InvocationContext;
import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AuthorizationInterceptor {

    private static final Logger LOGGER = Logger.getLogger(AuthorizationInterceptor.class.getName());

    @AroundInvoke
    public Object checkAuthorization(InvocationContext ic) throws Exception {
        Method method = ic.getMethod();
        Class<?> targetClass = ic.getTarget().getClass();

        RequiresRole annotation = method.getAnnotation(RequiresRole.class);
        if (annotation == null) {
            annotation = targetClass.getAnnotation(RequiresRole.class);
        }

        if (annotation != null) {
            String[] allowedRoles = annotation.value();
            UserDTO currentUser = UserContext.getUser();

            if (currentUser == null) {
                LOGGER.log(Level.WARNING, "[SECURITY-VIOLATION] Unauthenticated caller attempted invocation on: {0}.{1}()",
                        new Object[]{targetClass.getSimpleName(), method.getName()});
                throw new SecurityException("Authentication Required: No authenticated security context found.");
            }

            String userRole = currentUser.getRole() != null ? currentUser.getRole().toUpperCase() : "";

            boolean authorized = false;
            for (String allowed : allowedRoles) {
                if (allowed.equalsIgnoreCase(userRole)) {
                    authorized = true;
                    break;
                }
            }

            if (!authorized) {
                LOGGER.log(Level.WARNING, "[SECURITY-VIOLATION] Unauthorized access attempt! Caller: {0} (Role: {1}) denied for {2}.{3}(). Required Roles: {4}",
                        new Object[]{currentUser.getUsername(), userRole, targetClass.getSimpleName(), method.getName(), Arrays.toString(allowedRoles)});
                throw new SecurityException("Access Denied: Caller [" + currentUser.getUsername() + " | " + userRole + "] lacks required privileges " + Arrays.toString(allowedRoles));
            }
        }

        return ic.proceed();
    }
}