package com.globaltrade.web.servlet;

import com.globaltrade.core.dto.ProductDTO;
import com.globaltrade.core.dto.UserDTO;
import com.globaltrade.core.dto.VendorDTO;
import com.globaltrade.core.service.VendorService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "VendorProductServlet", urlPatterns = {"/vendor/products"})
public class VendorProductServlet extends HttpServlet {

    @EJB
    private VendorService vendorService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserDTO user = (session != null) ? (UserDTO) session.getAttribute("user") : null;

        Long userId = (user != null) ? user.getId() : 3L;
        VendorDTO vendor = vendorService.getVendorByUserId(userId);
        Long vendorId = (vendor != null) ? vendor.getId() : 1L;

        List<ProductDTO> products = vendorService.getProductsByVendorId(vendorId);

        req.setAttribute("vendor", vendor);
        req.setAttribute("products", products);

        req.getRequestDispatcher("/vendor-products.jsp").forward(req, resp);
    }
}