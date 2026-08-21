package com.globaltrade.web.servlet;

import com.globaltrade.core.dto.VendorDTO;
import com.globaltrade.core.service.VendorService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

@WebServlet(urlPatterns = {"/vendor-performance"})
public class VendorPerformanceServlet extends HttpServlet {

    @EJB
    private VendorService vendorService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<VendorDTO> vendors = vendorService.getAllVendors();
            
            int activeCount = 0;
            int suspendedCount = 0;
            BigDecimal totalRating = BigDecimal.ZERO;
            int ratedVendorsCount = 0;
            
            for (VendorDTO v : vendors) {
                if ("ACTIVE".equalsIgnoreCase(v.getStatusName())) {
                    activeCount++;
                } else {
                    suspendedCount++;
                }
                if (v.getRating() != null) {
                    totalRating = totalRating.add(v.getRating());
                    ratedVendorsCount++;
                }
            }
            
            BigDecimal avgRating = BigDecimal.ZERO;
            if (ratedVendorsCount > 0) {
                avgRating = totalRating.divide(new BigDecimal(ratedVendorsCount), 2, RoundingMode.HALF_UP);
            }
            
            req.setAttribute("vendors", vendors);
            req.setAttribute("activeCount", activeCount);
            req.setAttribute("suspendedCount", suspendedCount);
            req.setAttribute("avgRating", avgRating);
            req.setAttribute("totalVendors", vendors.size());

            req.getRequestDispatcher("/vendor-performance.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading vendor performance data.");
        }
    }
}