package com.globaltrade.web.servlet;

import com.globaltrade.core.dto.ProductDTO;
import com.globaltrade.core.dto.PurchaseOrderDTO;
import com.globaltrade.core.dto.UserDTO;
import com.globaltrade.core.dto.VendorDTO;
import com.globaltrade.core.dto.VendorPerformanceDTO;
import com.globaltrade.core.service.PurchaseOrderService;
import com.globaltrade.core.service.VendorService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "VendorDashboardServlet", urlPatterns = {"/dashboard/vendor", "/vendor/dashboard"})
public class VendorDashboardServlet extends HttpServlet {

    @EJB
    private VendorService vendorService;

    @EJB
    private PurchaseOrderService purchaseOrderService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserDTO user = (session != null) ? (UserDTO) session.getAttribute("user") : null;

        Long userId = (user != null) ? user.getId() : 3L;
        VendorDTO vendor = vendorService.getVendorByUserId(userId);

        if (vendor == null) {
            List<VendorDTO> all = vendorService.getAllVendors();
            if (!all.isEmpty()) vendor = all.get(0);
        }

        Long vendorId = (vendor != null) ? vendor.getId() : 1L;

        List<PurchaseOrderDTO> vendorPOs = purchaseOrderService.getPurchaseOrdersForVendor(vendorId);
        List<ProductDTO> vendorProducts = vendorService.getProductsByVendorId(vendorId);
        VendorPerformanceDTO performance = vendorService.getLatestPerformanceByVendorId(vendorId);

        long openOrderCount = vendorPOs.stream()
                .filter(po -> po.getStatusName() != null && ("PENDING".equalsIgnoreCase(po.getStatusName())
                        || "PROCESSING".equalsIgnoreCase(po.getStatusName())))
                .count();

        req.setAttribute("vendor", vendor);
        req.setAttribute("vendorPOs", vendorPOs);
        req.setAttribute("vendorProducts", vendorProducts);
        req.setAttribute("performance", performance);
        req.setAttribute("openOrderCount", openOrderCount);

        req.getRequestDispatcher("/dashboard-vendor.jsp").forward(req, resp);
    }
}