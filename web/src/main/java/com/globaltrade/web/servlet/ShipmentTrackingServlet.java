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
import java.util.List;

@WebServlet(name = "ShipmentTrackingServlet", urlPatterns = {"/shipment/track", "/shipment-tracking", "/track"})
public class ShipmentTrackingServlet extends HttpServlet {

    @EJB(beanName = "OrderServiceBean")
    private OrderService orderService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processTracking(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processTracking(req, resp);
    }

    private void processTracking(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String code = req.getParameter("code");
        if (code == null || code.trim().isEmpty()) {
            code = req.getParameter("orderCode");
        }
        if (code == null || code.trim().isEmpty()) {
            code = req.getParameter("shipmentCode");
        }

        OrderDTO order = null;

        if (code != null && !code.trim().isEmpty()) {
            order = orderService.getOrderByCode(code.trim());
            if (order == null) {
                req.setAttribute("error", "No shipment or order found with tracking reference: " + code);
            }
        } else {
            HttpSession session = req.getSession(false);
            UserDTO user = (session != null) ? (UserDTO) session.getAttribute("user") : null;
            if (user != null) {
                List<OrderDTO> userOrders = orderService.getOrdersByCustomerUserId(user.getId());
                if (userOrders != null && !userOrders.isEmpty()) {
                    order = userOrders.get(0);
                }
            }
        }

        req.setAttribute("order", order);
        req.setAttribute("searchCode", code);
        req.getRequestDispatcher("/shipment-tracking.jsp").forward(req, resp);
    }
}