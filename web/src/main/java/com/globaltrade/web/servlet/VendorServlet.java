package com.globaltrade.web.servlet;

import com.globaltrade.core.service.VendorService;
import com.globaltrade.core.service.WarehouseService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(urlPatterns = {"/vendors", "/vendors/action"})
public class VendorServlet extends HttpServlet {

    @EJB(beanName = "VendorServiceBean")
    private VendorService vendorService;

    @EJB(beanName = "WarehouseServiceBean")
    private WarehouseService warehouseService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("vendors", vendorService.getAllVendors());
        req.setAttribute("countries", warehouseService.getAllCountries());
        req.getRequestDispatcher("/vendors.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String companyName   = req.getParameter("companyName");
            String contactPerson = req.getParameter("contactPerson");
            String email         = req.getParameter("email");
            String phone         = req.getParameter("phone");
            String countryIdStr  = req.getParameter("countryId");
            String ratingStr     = req.getParameter("rating");

            if (companyName == null || companyName.trim().isEmpty()) {
                throw new IllegalArgumentException("Company Name is required.");
            }

            Long countryId = (countryIdStr != null && !countryIdStr.trim().isEmpty()) ? Long.parseLong(countryIdStr.trim()) : null;
            BigDecimal rating = new BigDecimal("5.00");
            if (ratingStr != null && !ratingStr.trim().isEmpty()) {
                rating = new BigDecimal(ratingStr.trim());
            }

            Long sessionUserId = null;
            com.globaltrade.core.dto.UserDTO sessionUser =
                    (com.globaltrade.core.dto.UserDTO) req.getSession().getAttribute("user");
            if (sessionUser != null) {
                sessionUserId = sessionUser.getId();
            }

            vendorService.createVendor(companyName, contactPerson, email, phone, countryId, rating, sessionUserId);
            resp.sendRedirect(req.getContextPath() + "/vendors?success="
                    + URLEncoder.encode("Vendor registered successfully!", StandardCharsets.UTF_8.name()));

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/vendors?error="
                    + URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "Failed to register vendor", StandardCharsets.UTF_8.name()));
        }
    }
}
