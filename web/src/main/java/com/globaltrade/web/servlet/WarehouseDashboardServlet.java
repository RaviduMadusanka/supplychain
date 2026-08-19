package com.globaltrade.web.servlet;

import com.globaltrade.core.dto.StockDTO;
import com.globaltrade.core.service.InventoryService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "WarehouseDashboardServlet", urlPatterns = {"/dashboard/warehouse"})
public class WarehouseDashboardServlet extends HttpServlet {

    @EJB
    private InventoryService inventoryService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<StockDTO> allStocks = inventoryService.getAllStock();

        long totalSkus = allStocks.stream().map(StockDTO::getProductName).distinct().count();
        long lowStockCount = allStocks.stream()
            .filter(s -> "LOW_STOCK".equals(s.getStatusName()) || "OUT_OF_STOCK".equals(s.getStatusName()))
            .count();
            
        req.setAttribute("stocks", allStocks);
        req.setAttribute("totalSkus", totalSkus);
        req.setAttribute("lowStockCount", lowStockCount);

        req.getRequestDispatcher("/dashboard-wh.jsp").forward(req, resp);
    }
}
