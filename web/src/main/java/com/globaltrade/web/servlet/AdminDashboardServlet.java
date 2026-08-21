package com.globaltrade.web.servlet;

import com.globaltrade.core.dto.AuditLogDTO;
import com.globaltrade.core.dto.ProductDTO;
import com.globaltrade.core.dto.StockDTO;
import com.globaltrade.core.dto.TimerJobDTO;
import com.globaltrade.core.dto.UserDTO;
import com.globaltrade.core.dto.VendorDTO;
import com.globaltrade.core.service.AuditLogService;
import com.globaltrade.core.service.InventoryService;
import com.globaltrade.core.service.TimerManagementService;
import com.globaltrade.core.service.UserService;
import com.globaltrade.core.service.VendorService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/dashboard/admin", "/admin"})
public class AdminDashboardServlet extends HttpServlet {

    @EJB
    private UserService userService;

    @EJB
    private InventoryService inventoryService;

    @EJB
    private VendorService vendorService;

    @EJB
    private AuditLogService auditLogService;

    @EJB
    private TimerManagementService timerService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<UserDTO> users = userService.getAllUsers();
            List<ProductDTO> products = inventoryService.getAllProducts();
            List<StockDTO> stocks = inventoryService.getAllStock();
            List<VendorDTO> vendors = vendorService.getAllVendors();
            List<AuditLogDTO> recentLogs = auditLogService.getRecentAuditLogs(6);
            List<TimerJobDTO> timers = timerService.getAllTimerJobs();

            long adminCount = users.stream().filter(u -> "ADMIN".equalsIgnoreCase(u.getRole())).count();
            long whCount = users.stream().filter(u -> "WAREHOUSE_MANAGER".equalsIgnoreCase(u.getRole())).count();
            long vendorUserCount = users.stream().filter(u -> "VENDOR".equalsIgnoreCase(u.getRole())).count();
            long customerCount = users.stream().filter(u -> "CUSTOMER".equalsIgnoreCase(u.getRole())).count();

            long lowStockCount = stocks.stream()
                    .filter(s -> "LOW_STOCK".equalsIgnoreCase(s.getStatusName()) || "OUT_OF_STOCK".equalsIgnoreCase(s.getStatusName()))
                    .count();

            req.setAttribute("users", users);
            req.setAttribute("products", products);
            req.setAttribute("stocks", stocks);
            req.setAttribute("vendors", vendors);
            req.setAttribute("recentLogs", recentLogs);
            req.setAttribute("timers", timers);

            req.setAttribute("adminCount", adminCount);
            req.setAttribute("whCount", whCount);
            req.setAttribute("vendorUserCount", vendorUserCount);
            req.setAttribute("customerCount", customerCount);
            req.setAttribute("lowStockCount", lowStockCount);

            req.getRequestDispatcher("/dashboard-admin.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to load admin dashboard: " + e.getMessage());
        }
    }
}