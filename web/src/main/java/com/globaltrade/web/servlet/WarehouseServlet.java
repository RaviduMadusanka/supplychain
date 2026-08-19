package com.globaltrade.web.servlet;

import com.globaltrade.core.dto.UserDTO;
import com.globaltrade.core.entity.Warehouse;
import com.globaltrade.core.service.WarehouseService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/warehouses")
public class WarehouseServlet extends HttpServlet {

    @EJB
    private WarehouseService warehouseService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("warehouses", warehouseService.getAllWarehouseDetails());
        req.setAttribute("countries", warehouseService.getAllCountries());
        req.getRequestDispatcher("/warehouses.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String warehouseCode = req.getParameter("warehouseCode");
            String name = req.getParameter("name");
            String location = req.getParameter("location");
            String capacityStr = req.getParameter("capacity");
            String countryIdStr = req.getParameter("countryId");

            if (warehouseCode == null || warehouseCode.trim().isEmpty()) {
                warehouseCode = "WH-" + (System.currentTimeMillis() % 10000);
            }

            int capacity = (capacityStr != null && !capacityStr.trim().isEmpty()) ? Integer.parseInt(capacityStr.trim()) : 10000;
            Long countryId = (countryIdStr != null && !countryIdStr.trim().isEmpty()) ? Long.parseLong(countryIdStr.trim()) : null;

            HttpSession session = req.getSession(false);
            Long managerUserId = null;
            if (session != null && session.getAttribute("user") != null) {
                UserDTO user = (UserDTO) session.getAttribute("user");
                managerUserId = user.getId();
            }

            Warehouse warehouse = new Warehouse();
            warehouse.setWarehouseCode(warehouseCode.trim());
            warehouse.setName(name.trim());
            warehouse.setLocation(location != null ? location.trim() : "");
            warehouse.setCapacity(capacity);
            warehouse.setCurrentUtilization(0);

            warehouseService.addWarehouse(warehouse, countryId, managerUserId);

            resp.sendRedirect(req.getContextPath() + "/warehouses?success=WarehouseAdded");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to add warehouse: " + e.getMessage());
            doGet(req, resp);
        }
    }
}
