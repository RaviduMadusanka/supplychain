package com.globaltrade.web.servlet;

import com.globaltrade.core.context.UserContext;
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
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "CustomerOrderServlet", urlPatterns = {"/customer/order/create", "/customer/order/place"})
public class CustomerOrderServlet extends HttpServlet {

    @EJB(beanName = "OrderServiceBean")
    private OrderService orderService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserDTO user = (session != null) ? (UserDTO) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            UserContext.setUser(user);

            String address = req.getParameter("deliveryAddress");
            String countryIdStr = req.getParameter("countryId");
            Long countryId = (countryIdStr != null && !countryIdStr.trim().isEmpty()) ? Long.parseLong(countryIdStr.trim()) : null;

            Map<Long, Integer> productQuantities = new HashMap<>();

            String[] itemIds = req.getParameterValues("itemIds");
            if (itemIds != null && itemIds.length > 0) {
                for (String idStr : itemIds) {
                    if (idStr == null || idStr.trim().isEmpty()) continue;
                    Long itemId = Long.parseLong(idStr.trim());
                    String qtyStr = req.getParameter("qty_" + itemId);
                    int qty = (qtyStr != null && !qtyStr.trim().isEmpty()) ? Integer.parseInt(qtyStr.trim()) : 1;
                    if (qty > 0) {
                        productQuantities.put(itemId, qty);
                    }
                }
            } else {
                String singleItemIdStr = req.getParameter("productId");
                String singleQtyStr = req.getParameter("quantity");
                if (singleItemIdStr != null && !singleItemIdStr.trim().isEmpty()) {
                    Long itemId = Long.parseLong(singleItemIdStr.trim());
                    int qty = (singleQtyStr != null && !singleQtyStr.trim().isEmpty()) ? Integer.parseInt(singleQtyStr.trim()) : 1;
                    productQuantities.put(itemId, qty);
                }
            }

            if (productQuantities.isEmpty()) {
                throw new IllegalArgumentException("Please select at least 1 item to order.");
            }

            OrderDTO createdOrder = orderService.createCustomerOrder(user.getId(), productQuantities, address, countryId);

            String successMsg = "Order " + createdOrder.getOrderCode() + " placed successfully! Tracking ref: " + (createdOrder.getShipmentCode() != null ? createdOrder.getShipmentCode() : "Assigned");
            resp.sendRedirect(req.getContextPath() + "/dashboard/customer?success=" + URLEncoder.encode(successMsg, StandardCharsets.UTF_8.name()));

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/customer/browse?error=" + URLEncoder.encode("Failed to place order: " + e.getMessage(), StandardCharsets.UTF_8.name()));
        } finally {
            UserContext.clear();
        }
    }
}