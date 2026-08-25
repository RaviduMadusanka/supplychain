package com.globaltrade.web.servlet;

import com.globaltrade.core.service.InventoryService;
import com.globaltrade.core.service.WarehouseService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "CustomerCatalogServlet", urlPatterns = {"/customer/browse", "/browse-products"})
public class CustomerCatalogServlet extends HttpServlet {

    @EJB(beanName = "InventoryServiceBean")
    private InventoryService inventoryService;

    @EJB(beanName = "WarehouseServiceBean")
    private WarehouseService warehouseService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setAttribute("stocks", inventoryService.getAllStock());
            req.setAttribute("categories", inventoryService.getAllCategories());
            req.setAttribute("countries", warehouseService.getAllCountries());
            req.getRequestDispatcher("/browse-products.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to load product catalog: " + e.getMessage());
            req.getRequestDispatcher("/browse-products.jsp").forward(req, resp);
        }
    }
}