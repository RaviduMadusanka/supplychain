package com.globaltrade.web.servlet;

import com.globaltrade.core.dto.CategoryDTO;
import com.globaltrade.core.dto.ProductDTO;
import com.globaltrade.core.dto.VendorDTO;
import com.globaltrade.core.entity.InventoryItem;
import com.globaltrade.core.service.InventoryService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;

@WebServlet(urlPatterns = {"/products", "/product/add"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,
    maxFileSize = 1024 * 1024 * 5,      // 5 MB
    maxRequestSize = 1024 * 1024 * 10   // 10 MB
)
public class ProductServlet extends HttpServlet {

    @EJB
    private InventoryService inventoryService;

    private static final String UPLOAD_DIR = "C:\\Users\\ravid\\Documents\\SupplyChain_Images";

    @Override
    public void init() throws ServletException {
        File uploadDir = new File(UPLOAD_DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/products".equals(path)) {
            List<ProductDTO> products = inventoryService.getAllProducts();
            List<CategoryDTO> categories = inventoryService.getAllCategories();
            List<VendorDTO> vendors = inventoryService.getAllVendors();

            req.setAttribute("products", products);
            req.setAttribute("categories", categories);
            req.setAttribute("vendors", vendors);
            req.getRequestDispatcher("/products.jsp").forward(req, resp);
            return;
        }

        if ("/product/add".equals(path)) {
            req.setAttribute("categories", inventoryService.getAllCategories());
            req.setAttribute("vendors", inventoryService.getAllVendors());
            req.getRequestDispatcher("/add-product.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String name = req.getParameter("name");
            String categoryStr = req.getParameter("category");
            String vendorStr = req.getParameter("vendor");
            String sku = req.getParameter("sku");
            String weightStr = req.getParameter("weight");
            String reorderLevelStr = req.getParameter("reorderLevel");

            if (sku == null || sku.trim().isEmpty()) {
                sku = "SKU-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            }

            BigDecimal weight = new BigDecimal(weightStr != null && !weightStr.isEmpty() ? weightStr : "0.00");
            Integer reorderLevel = (reorderLevelStr != null && !reorderLevelStr.isEmpty()) ? Integer.parseInt(reorderLevelStr) : 0;

            Part filePart = req.getPart("productImage");
            String fileName = null;
            String imageUrl = null;

            if (filePart != null && filePart.getSize() > 0) {
                String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
                fileName = UUID.randomUUID().toString() + fileExtension;
                
                Path uploadPath = Paths.get(UPLOAD_DIR, fileName);
                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input, uploadPath, StandardCopyOption.REPLACE_EXISTING);
                }

                imageUrl = "/images/" + fileName;
            }

            InventoryItem item = new InventoryItem();
            item.setName(name);
            item.setSku(sku);
            item.setWeight(weight);
            item.setReorderLevel(reorderLevel);
            item.setImageUrl(imageUrl);

            Long categoryId = (categoryStr != null && !categoryStr.isEmpty()) ? Long.parseLong(categoryStr) : null;
            Long vendorId = (vendorStr != null && !vendorStr.isEmpty()) ? Long.parseLong(vendorStr) : null;

            inventoryService.addProduct(item, categoryId, vendorId);

            resp.sendRedirect(req.getContextPath() + "/products?success=ProductAdded");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to add product: " + e.getMessage());
            req.setAttribute("categories", inventoryService.getAllCategories());
            req.setAttribute("vendors", inventoryService.getAllVendors());
            req.getRequestDispatcher("/add-product.jsp").forward(req, resp);
        }
    }
}