package com.globaltrade.web.servlet;

import com.globaltrade.core.service.InventoryService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name = "InventoryServlet", urlPatterns = {"/inventory", "/inventory/add", "/inventory/quick-update"})
public class InventoryServlet extends HttpServlet {

    @EJB
    private InventoryService inventoryService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/inventory".equals(path)) {
            // Load all stock and products for the main inventory page
            req.setAttribute("products", inventoryService.getAllProducts());
            req.setAttribute("stocks", inventoryService.getAllStock());
            req.getRequestDispatcher("/products-inventory.jsp").forward(req, resp);
        } else if ("/inventory/add".equals(path)) {
            // Load products, warehouses for the Add Inventory dropdowns
            req.setAttribute("products", inventoryService.getAllProducts());
            req.setAttribute("warehouses", inventoryService.getAllWarehouses());
            // In a real app we'd load Statuses too, but we can hardcode Active/Inactive mapping or assume "ACTIVE" is id 1
            req.getRequestDispatcher("/add-inventory.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/inventory/add".equals(path)) {
            try {
                Long productId = Long.parseLong(req.getParameter("productId"));
                Long warehouseId = Long.parseLong(req.getParameter("warehouseId"));
                Integer quantity = Integer.parseInt(req.getParameter("stockQuantity"));
                BigDecimal unitPrice = new BigDecimal(req.getParameter("unitPrice"));
                Integer lowStockThreshold = Integer.parseInt(req.getParameter("lowStockThreshold"));
                // Long statusId = Long.parseLong(req.getParameter("statusId")); // simplified
                
                inventoryService.addOrUpdateStock(productId, warehouseId, quantity, unitPrice, lowStockThreshold, null);
                
                req.getSession().setAttribute("successMsg", "Inventory successfully updated.");
                resp.sendRedirect(req.getContextPath() + "/inventory");
            } catch (Exception e) {
                req.setAttribute("errorMsg", "Failed to update inventory: " + e.getMessage());
                // Reload form
                req.setAttribute("products", inventoryService.getAllProducts());
                req.setAttribute("warehouses", inventoryService.getAllWarehouses());
                req.getRequestDispatcher("/add-inventory.jsp").forward(req, resp);
            }
        } else if ("/inventory/quick-update".equals(path)) {
            try {
                Long stockId = Long.parseLong(req.getParameter("stockId"));
                Integer newQty = Integer.parseInt(req.getParameter("newQty"));
                inventoryService.quickUpdateStock(stockId, newQty);
                req.getSession().setAttribute("successMsg", "Stock quantity updated.");
            } catch (Exception e) {
                req.getSession().setAttribute("errorMsg", "Failed to update stock.");
            }
            resp.sendRedirect(req.getContextPath() + "/inventory");
        }
    }
}
