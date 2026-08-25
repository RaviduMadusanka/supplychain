package com.globaltrade.web.servlet;

import com.globaltrade.core.service.SystemConfigService;
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

@WebServlet(name = "SystemConfigServlet", urlPatterns = {
        "/system-config",
        "/system-config/category/add",
        "/system-config/category/delete",
        "/system-config/status/add",
        "/system-config/status/delete",
        "/system-config/country/add",
        "/system-config/tax/update"
})
public class SystemConfigServlet extends HttpServlet {

    @EJB(beanName = "SystemConfigServiceBean")
    private SystemConfigService configService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setAttribute("categories", configService.getAllCategories());
            req.setAttribute("statuses", configService.getAllShipmentStatuses());
            req.setAttribute("countries", configService.getAllCountries());
            req.getRequestDispatcher("/system-config.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to load system configurations");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        try {
            if ("/system-config/category/add".equals(path)) {
                String name = req.getParameter("name");
                String desc = req.getParameter("description");
                configService.createCategory(name, desc);
                resp.sendRedirect(req.getContextPath() + "/system-config?tab=categories&success=" + URLEncoder.encode("Category '" + name + "' created successfully.", StandardCharsets.UTF_8.name()));
                return;
            } else if ("/system-config/category/delete".equals(path)) {
                Long id = Long.parseLong(req.getParameter("id"));
                configService.deleteCategory(id);
                resp.sendRedirect(req.getContextPath() + "/system-config?tab=categories&success=" + URLEncoder.encode("Category deleted successfully.", StandardCharsets.UTF_8.name()));
                return;
            } else if ("/system-config/status/add".equals(path)) {
                String name = req.getParameter("name");
                String desc = req.getParameter("description");
                configService.createShipmentStatus(name, desc);
                resp.sendRedirect(req.getContextPath() + "/system-config?tab=statuses&success=" + URLEncoder.encode("Status '" + name + "' created successfully.", StandardCharsets.UTF_8.name()));
                return;
            } else if ("/system-config/status/delete".equals(path)) {
                Long id = Long.parseLong(req.getParameter("id"));
                configService.deleteShipmentStatus(id);
                resp.sendRedirect(req.getContextPath() + "/system-config?tab=statuses&success=" + URLEncoder.encode("Status deleted successfully.", StandardCharsets.UTF_8.name()));
                return;
            } else if ("/system-config/country/add".equals(path)) {
                String name = req.getParameter("name");
                BigDecimal vat = new BigDecimal(req.getParameter("vat"));
                BigDecimal importTax = new BigDecimal(req.getParameter("importTax"));
                configService.createCountry(name, vat, importTax);
                resp.sendRedirect(req.getContextPath() + "/system-config?tab=tariffs&success=" + URLEncoder.encode("Country '" + name + "' and customs tariffs registered successfully.", StandardCharsets.UTF_8.name()));
                return;
            } else if ("/system-config/tax/update".equals(path)) {
                Long countryId = Long.parseLong(req.getParameter("countryId"));
                BigDecimal vat = new BigDecimal(req.getParameter("vat"));
                BigDecimal importTax = new BigDecimal(req.getParameter("importTax"));
                configService.updateCountryTax(countryId, vat, importTax);
                resp.sendRedirect(req.getContextPath() + "/system-config?tab=tariffs&success=" + URLEncoder.encode("Tax rates updated successfully.", StandardCharsets.UTF_8.name()));
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/system-config?tab=tariffs&error=" + URLEncoder.encode("Operation failed: " + e.getMessage(), StandardCharsets.UTF_8.name()));
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/system-config");
    }
}