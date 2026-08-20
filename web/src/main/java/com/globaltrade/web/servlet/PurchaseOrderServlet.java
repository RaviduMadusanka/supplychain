package com.globaltrade.web.servlet;

import com.globaltrade.core.dto.ProductDTO;
import com.globaltrade.core.dto.PurchaseOrderDTO;
import com.globaltrade.core.dto.StockDTO;
import com.globaltrade.core.dto.VendorDTO;
import com.globaltrade.core.dto.WarehouseDTO;
import com.globaltrade.core.service.InventoryService;
import com.globaltrade.core.service.PurchaseOrderService;
import com.globaltrade.core.service.WarehouseService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(name = "PurchaseOrderServlet", urlPatterns = {"/purchase-orders", "/purchase-orders/action", "/purchase-orders/create"})
public class PurchaseOrderServlet extends HttpServlet {

    @EJB
    private PurchaseOrderService purchaseOrderService;

    @EJB
    private WarehouseService warehouseService;

    @EJB
    private InventoryService inventoryService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<PurchaseOrderDTO> purchaseOrders = purchaseOrderService.getAllPurchaseOrders();
            List<WarehouseDTO> warehouses = warehouseService.getAllWarehouseDetails();
            List<VendorDTO> vendors = inventoryService.getAllVendors();
            List<ProductDTO> products = inventoryService.getAllProducts();
            List<StockDTO> allStocks = inventoryService.getAllStock();

            // Filter low stock alerts
            List<StockDTO> lowStocks = allStocks.stream()
                    .filter(s -> "LOW_STOCK".equalsIgnoreCase(s.getStatusName()) || "OUT_OF_STOCK".equalsIgnoreCase(s.getStatusName()) || (s.getStockQty() != null && s.getStockQty() <= 10))
                    .collect(Collectors.toList());

            request.setAttribute("purchaseOrders", purchaseOrders);
            request.setAttribute("warehouses", warehouses);
            request.setAttribute("vendors", vendors);
            request.setAttribute("products", products);
            request.setAttribute("lowStocks", lowStocks);

            request.getRequestDispatcher("/purchase-orders.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading purchase orders: " + e.getMessage());
            request.getRequestDispatcher("/purchase-orders.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        try {
            if ("create".equalsIgnoreCase(action)) {
                String warehouseIdStr = request.getParameter("warehouseId");
                String vendorIdStr = request.getParameter("vendorId");
                String productIdStr = request.getParameter("productId");
                String quantityStr = request.getParameter("quantity");

                if (warehouseIdStr == null || vendorIdStr == null || productIdStr == null || quantityStr == null) {
                    throw new IllegalArgumentException("Missing required fields to create purchase order.");
                }

                Long warehouseId = Long.parseLong(warehouseIdStr);
                Long vendorId = Long.parseLong(vendorIdStr);
                Long productId = Long.parseLong(productIdStr);
                int quantity = Integer.parseInt(quantityStr);

                Map<Long, Integer> productQuantities = new HashMap<>();
                productQuantities.put(productId, quantity);

                purchaseOrderService.createPurchaseOrder(warehouseId, vendorId, productQuantities);
                response.sendRedirect(request.getContextPath() + "/purchase-orders?success=PO+Created+Successfully");
                return;

            } else if ("receive".equalsIgnoreCase(action)) {
                String poIdStr = request.getParameter("poId");
                if (poIdStr == null) {
                    throw new IllegalArgumentException("PO ID is required to receive goods.");
                }
                Long poId = Long.parseLong(poIdStr);
                purchaseOrderService.receivePurchaseOrderGoods(poId);
                response.sendRedirect(request.getContextPath() + "/purchase-orders?success=Goods+Received+and+Inventory+Stock+Updated");
                return;

            } else if ("accept".equalsIgnoreCase(action)) {
                String poIdStr = request.getParameter("poId");
                if (poIdStr != null) {
                    purchaseOrderService.updatePurchaseOrderStatus(Long.parseLong(poIdStr), "PROCESSING");
                }
                response.sendRedirect(request.getContextPath() + "/purchase-orders?success=Purchase+Order+Accepted");
                return;

            } else if ("dispatch".equalsIgnoreCase(action)) {
                String poIdStr = request.getParameter("poId");
                if (poIdStr != null) {
                    purchaseOrderService.updatePurchaseOrderStatus(Long.parseLong(poIdStr), "PROCESSING");
                }
                response.sendRedirect(request.getContextPath() + "/purchase-orders?success=Purchase+Order+Dispatched");
                return;
            }

            response.sendRedirect(request.getContextPath() + "/purchase-orders");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/purchase-orders?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }
}
