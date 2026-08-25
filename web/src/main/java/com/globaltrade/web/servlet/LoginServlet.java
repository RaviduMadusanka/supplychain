package com.globaltrade.web.servlet;

import com.globaltrade.core.dto.UserDTO;
import com.globaltrade.core.service.AuthService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @EJB(beanName = "AuthServiceBean")
    private AuthService authService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try {
            UserDTO user = authService.authenticate(username, password);

            HttpSession oldSession = req.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }
            HttpSession session = req.getSession(true);
            session.setAttribute("user", user);

            String redirectUrl;
            switch (user.getRole().toLowerCase()) {
                case "admin":
                    redirectUrl = "dashboard/admin";
                    break;
                case "warehouse_manager":
                    redirectUrl = "dashboard/warehouse";
                    break;
                case "vendor":
                    redirectUrl = "dashboard/vendor";
                    break;
                case "customer":
                    redirectUrl = "dashboard/customer";
                    break;
                default:
                    redirectUrl = "dashboard/admin";
            }
            resp.sendRedirect(req.getContextPath() + "/" + redirectUrl);

        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}
