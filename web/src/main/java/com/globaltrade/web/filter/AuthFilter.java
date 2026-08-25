package com.globaltrade.web.filter;

import com.globaltrade.core.context.UserContext;
import com.globaltrade.core.dto.UserDTO;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

@WebFilter("/*")
public class AuthFilter implements Filter {

    private static final Set<String> PUBLIC_EXTENSIONS = new HashSet<>(Arrays.asList(
            ".css", ".js", ".png", ".jpg", ".jpeg", ".gif", ".svg", ".ico", ".woff", ".woff2", ".ttf"
    ));

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String contextPath = req.getContextPath();
        String uri = req.getRequestURI();
        String path = uri.substring(contextPath.length());

        if (isPublicAsset(path)) {
            chain.doFilter(request, response);
            return;
        }

        if (isPublicEndpoint(path)) {
            chain.doFilter(request, response);
            return;
        }

        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        if (!isLoggedIn) {
            res.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        UserDTO user = (UserDTO) session.getAttribute("user");
        String role = (user != null && user.getRole() != null) ? user.getRole().toUpperCase() : "";

        if (!isAuthorized(path, role)) {
            res.setStatus(HttpServletResponse.SC_FORBIDDEN);
            req.getRequestDispatcher("/403.jsp").forward(request, response);
            return;
        }

        UserContext.setUser(user);
        try {
            chain.doFilter(request, response);
        } finally {
            UserContext.clear();
        }
    }

    private boolean isPublicAsset(String path) {
        if (path.contains("/includes/") || path.contains("/images/")) return true;
        for (String ext : PUBLIC_EXTENSIONS) {
            if (path.endsWith(ext)) return true;
        }
        return false;
    }

    private boolean isPublicEndpoint(String path) {
        return path.equals("/") ||
               path.equals("/login.jsp") ||
               path.equals("/login") ||
               path.equals("/logout") ||
               path.equals("/register.jsp") ||
               path.equals("/register") ||
               path.equals("/403.jsp") ||
               path.equals("/error.jsp");
    }

    private boolean isAuthorized(String path, String role) {

        if ("ADMIN".equals(role)) {
            return true;
        }

        if (path.startsWith("/dashboard/admin") ||
            path.startsWith("/dashboard-admin.jsp") ||
            path.startsWith("/users") ||
            path.startsWith("/timers") ||
            path.startsWith("/system-config") ||
            path.startsWith("/monitoring")) {
            return false;
        }

        // WAREHOUSE MANAGER Modules (Warehouse Dashboard, Stock, Warehouses, Customer Order Processing)
        if (path.startsWith("/dashboard/warehouse") ||
            path.startsWith("/dashboard-wh.jsp") ||
            path.startsWith("/inventory") ||
            path.startsWith("/warehouses") ||
            path.startsWith("/warehouse") ||
            path.startsWith("/orders") ||
            path.startsWith("/product/add")) {
            return "WAREHOUSE_MANAGER".equals(role);
        }

        // VENDOR Modules
        if (path.startsWith("/dashboard/vendor") ||
            path.startsWith("/dashboard-vendor.jsp") ||
            path.startsWith("/vendor/")) {
            return "VENDOR".equals(role);
        }

        // CUSTOMER Modules
        if (path.startsWith("/dashboard/customer") ||
            path.startsWith("/dashboard-customer.jsp") ||
            path.startsWith("/browse-products.jsp") ||
            path.startsWith("/checkout.jsp") ||
            path.startsWith("/place-order.jsp") ||
            path.startsWith("/place-order") ||
            path.startsWith("/customer/") ||
            path.startsWith("/customer")) {
            return "CUSTOMER".equals(role) || "ADMIN".equals(role);
        }

        return true;
    }
}