package com.globaltrade.web.servlet;

import com.globaltrade.core.service.OrderService;
import com.globaltrade.core.service.WarehouseService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(urlPatterns = {"/orders", "/orders/action"})
public class OrderServlet extends HttpServlet {

    @EJB(beanName = "OrderServiceBean")
    private OrderService orderService;

    @EJB(beanName = "WarehouseServiceBean")
    private WarehouseService warehouseService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("orders", orderService.getAllOrders());
        req.setAttribute("warehouses", warehouseService.getAllWarehouses());
        req.getRequestDispatcher("/orders.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String action = req.getParameter("action");
            String orderIdStr = req.getParameter("orderId");

            if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/orders?error=MissingOrderId");
                return;
            }

            Long orderId = Long.parseLong(orderIdStr.trim());

            if ("process".equalsIgnoreCase(action)) {
                orderService.startProcessingOrder(orderId);
                resp.sendRedirect(req.getContextPath() + "/orders?success=OrderProcessing");
            } else if ("ship".equalsIgnoreCase(action)) {
                String warehouseIdStr = req.getParameter("warehouseId");
                String carrier = req.getParameter("carrier");
                String destination = req.getParameter("destination");
                String daysStr = req.getParameter("deliveryDays");

                Long warehouseId = (warehouseIdStr != null && !warehouseIdStr.trim().isEmpty()) ? Long.parseLong(warehouseIdStr.trim()) : null;
                int deliveryDays = (daysStr != null && !daysStr.trim().isEmpty()) ? Integer.parseInt(daysStr.trim()) : 3;

                if (warehouseId == null) {
                    resp.sendRedirect(req.getContextPath() + "/orders?error=MissingWarehouse");
                    return;
                }

                orderService.createShipmentForOrder(orderId, warehouseId, carrier, destination, deliveryDays);
                resp.sendRedirect(req.getContextPath() + "/orders?success=ShipmentCreated");
            } else if ("complete".equalsIgnoreCase(action)) {
                orderService.completeOrder(orderId);
                resp.sendRedirect(req.getContextPath() + "/orders?success=OrderCompleted");
            } else {
                resp.sendRedirect(req.getContextPath() + "/orders");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/orders?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }
}
