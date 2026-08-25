package com.globaltrade.web.servlet;

import com.globaltrade.core.dto.OrderDTO;
import com.globaltrade.core.dto.UserDTO;
import com.globaltrade.core.service.OrderService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "CustomerDashboardServlet", urlPatterns = {"/dashboard/customer"})
public class CustomerDashboardServlet extends HttpServlet {

    @EJB(beanName = "OrderServiceBean")
    private OrderService orderService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserDTO user = (session != null) ? (UserDTO) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            List<OrderDTO> orders = orderService.getOrdersByCustomerUserId(user.getId());
            req.setAttribute("orders", orders);

            int totalOrders = orders.size();
            long inTransitCount = orders.stream()
                    .filter(o -> o.getStatusName() != null && 
                            (o.getStatusName().equalsIgnoreCase("PROCESSING") || 
                             o.getStatusName().equalsIgnoreCase("IN_TRANSIT") ||
                             o.getStatusName().equalsIgnoreCase("PENDING")))
                    .count();
            long deliveredCount = orders.stream()
                    .filter(o -> o.getStatusName() != null && 
                            (o.getStatusName().equalsIgnoreCase("DELIVERED") || 
                             o.getStatusName().equalsIgnoreCase("COMPLETED")))
                    .count();

            BigDecimal totalSpent = orders.stream()
                    .map(o -> o.getTotalAmount() != null ? o.getTotalAmount() : BigDecimal.ZERO)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            req.setAttribute("totalOrders", totalOrders);
            req.setAttribute("inTransitCount", inTransitCount);
            req.setAttribute("deliveredCount", deliveredCount);
            req.setAttribute("totalSpent", totalSpent);

            req.getRequestDispatcher("/dashboard-customer.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to load customer orders: " + e.getMessage());
            req.getRequestDispatcher("/dashboard-customer.jsp").forward(req, resp);
        }
    }
}