package com.globaltrade.web.servlet;

import com.globaltrade.core.dto.ProductDTO;
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
import java.util.UUID;

@WebServlet("/product/add")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 5,      // 5 MB
    maxRequestSize = 1024 * 1024 * 10   // 10 MB
)
public class ProductServlet extends HttpServlet {

    @EJB
    private InventoryService inventoryService;

    // Define the external folder in the user's Documents
    private static final String UPLOAD_DIR = "C:\\Users\\ravid\\Documents\\SupplyChain_Images";

    @Override
    public void init() throws ServletException {
        // Create upload directory if it doesn't exist
        File uploadDir = new File(UPLOAD_DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("categories", inventoryService.getAllCategoryNames());
        req.getRequestDispatcher("/add-product.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Get form fields
            String name = req.getParameter("name");
            String category = req.getParameter("category");
            String sku = req.getParameter("sku");
            String unitPriceStr = req.getParameter("unitPrice");
            String unitOfMeasure = req.getParameter("unitOfMeasure");
            String description = req.getParameter("description");
            
            // Auto-generate SKU if blank
            if (sku == null || sku.trim().isEmpty()) {
                sku = "SKU-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            }

            BigDecimal unitPrice = new BigDecimal(unitPriceStr != null && !unitPriceStr.isEmpty() ? unitPriceStr : "0.00");

            // Handle file upload
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
                
                // Set the URL path that the ImageServlet will serve
                imageUrl = "/images/" + fileName;
            }

            // Create DTO and save
            ProductDTO dto = new ProductDTO();
            dto.setName(name);
            dto.setCategoryName(category);
            dto.setSku(sku);
            dto.setUnitPrice(unitPrice);
            dto.setUnitOfMeasure(unitOfMeasure);
            dto.setDescription(description);
            dto.setImageUrl(imageUrl);

            inventoryService.addProduct(dto);

            // Redirect to inventory list
            resp.sendRedirect(req.getContextPath() + "/inventory?success=ProductAdded");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to add product: " + e.getMessage());
            doGet(req, resp);
        }
    }
}
