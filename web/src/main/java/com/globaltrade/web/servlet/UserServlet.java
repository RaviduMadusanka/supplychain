package com.globaltrade.web.servlet;

import com.globaltrade.core.service.UserService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(urlPatterns = {"/users", "/users/action"})
public class UserServlet extends HttpServlet {

    @EJB
    private UserService userService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setAttribute("users", userService.getAllUsers());
            req.getRequestDispatcher("/users.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to load users");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String fullName = req.getParameter("fullName");
            String email = req.getParameter("email");
            String roleName = req.getParameter("roleName");

            userService.createUser(fullName, email, roleName);
            
            resp.sendRedirect(req.getContextPath() + "/users?success=" + URLEncoder.encode("User registered successfully. Credentials sent via email.", StandardCharsets.UTF_8.name()));
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/users?error=" + URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "Failed to register user", StandardCharsets.UTF_8.name()));
        }
    }
}