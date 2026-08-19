package com.globaltrade.web.filter;

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

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String uri = req.getRequestURI();

        if (uri.endsWith("login.jsp") || uri.endsWith("register.jsp") || uri.endsWith("error.jsp") || uri.endsWith("403.jsp") || uri.contains("/includes/") || uri.endsWith("/login") || uri.endsWith("/register") || uri.contains("/images/")) {
            chain.doFilter(request, response);
            return;
        }

        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        if (isLoggedIn) {
            UserDTO user = (UserDTO) session.getAttribute("user");

            com.globaltrade.core.context.UserContext.setUser(user);
            
            try {
                chain.doFilter(request, response);
            } finally {
                com.globaltrade.core.context.UserContext.clear();
            }
        } else {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }
}
