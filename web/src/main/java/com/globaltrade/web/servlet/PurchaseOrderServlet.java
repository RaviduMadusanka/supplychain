package com.globaltrade.web.servlet;

import com.globaltrade.core.dto.ProductDTO;
import com.globaltrade.core.dto.PurchaseOrderDTO;
import com.globaltrade.core.dto.StockDTO;
import com.globaltrade.core.dto.UserDTO;
import com.globaltrade.core.dto.VendorDTO;
import com.globaltrade.core.dto.WarehouseDTO;
import com.globaltrade.core.service.InventoryService;
import com.globaltrade.core.service.PurchaseOrderService;
import com.globaltrade.core.service.VendorService;
import com.globaltrade.core.service.WarehouseService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(name = "PurchaseOrderServlet",
        urlPatterns = {"/purchase-orders", "/purchase-orders/action", "/purchase-orders/create"})
public class PurchaseOrderServlet extends HttpServlet {

    @EJB
    private PurchaseOrderService purchaseOrderService;

    @EJB
    private WarehouseService warehouseService;

    @EJB
    private InventoryService inventoryService;

    @EJB
    private VendorService vendorService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            UserDTO user = (session != null) ? (UserDTO) session.getAttribute("user") : null;

            List<PurchaseOrderDTO> purchaseOrders;
            if (user != null && "VENDOR".equalsIgnoreCase(user.getRole())) {
                VendorDTO v = vendorService.getVendorByUserId(user.getId());
                Long vendorId = (v != null) ? v.getId() : 1L;
                purchaseOrders = purchaseOrderService.getPurchaseOrdersForVendor(vendorId);
            } else {
                purchaseOrders = purchaseOrderService.getAllPurchaseOrders();
            }

            List<WarehouseDTO> warehouses = warehouseService.getAllWarehouseDetails();
            List<VendorDTO> vendors = inventoryService.getAllVendors();
            List<ProductDTO> products = inventoryService.getAllProducts();
            List<StockDTO> allStocks = inventoryService.getAllStock();

            List<StockDTO> lowStocks = allStocks.stream()
                    .filter(s -> "LOW_STOCK".equalsIgnoreCase(s.getStatusName())
                            || "OUT_OF_STOCK".equalsIgnoreCase(s.getStatusName())
                            || (s.getStockQty() != null && s.getStockQty() <= 10))
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
                String[] productIds = request.getParameterValues("productId");
                String[] quantities = request.getParameterValues("quantity");

                if (warehouseIdStr == null || vendorIdStr == null || productIds == null || productIds.length == 0) {
                    throw new IllegalArgumentException("Destination Warehouse, Vendor and at least one Product are required.");
                }

                Long warehouseId = Long.parseLong(warehouseIdStr);
                Long vendorId = Long.parseLong(vendorIdStr);

                Map<Long, Integer> productQuantities = new HashMap<>();
                for (int i = 0; i < productIds.length; i++) {
                    String pIdStr = productIds[i];
                    if (pIdStr == null || pIdStr.trim().isEmpty()) continue;
                    
                    int qty = 1;
                    if (quantities != null && i < quantities.length && quantities[i] != null && !quantities[i].trim().isEmpty()) {
                        qty = Math.max(1, Integer.parseInt(quantities[i].trim()));
                    }

                    Long pId = Long.parseLong(pIdStr.trim());
                    productQuantities.merge(pId, qty, Integer::sum);
                }

                if (productQuantities.isEmpty()) {
                    throw new IllegalArgumentException("Please select at least one valid product to restock.");
                }

                purchaseOrderService.createPurchaseOrder(warehouseId, vendorId, productQuantities);
                response.sendRedirect(request.getContextPath() + "/purchase-orders?success="
                        + URLEncoder.encode("PO Created with " + productQuantities.size()
                        + " items successfully.", StandardCharsets.UTF_8.name()));
                return;

            } else if ("receive".equalsIgnoreCase(action)) {
                String poIdStr = request.getParameter("poId");
                if (poIdStr == null) {
                    throw new IllegalArgumentException("PO ID is required to receive goods.");
                }
                Long poId = Long.parseLong(poIdStr);
                purchaseOrderService.receivePurchaseOrderGoods(poId);
                response.sendRedirect(request.getContextPath() + "/purchase-orders?success="
                        + URLEncoder.encode("Goods Received and Inventory Stock Updated.", StandardCharsets.UTF_8.name()));
                return;

            } else if ("accept".equalsIgnoreCase(action)) {
                String poIdStr = request.getParameter("poId");
                if (poIdStr != null) {
                    purchaseOrderService.updatePurchaseOrderStatus(Long.parseLong(poIdStr), "PROCESSING");
                }
                response.sendRedirect(request.getContextPath() + "/purchase-orders?success="
                        + URLEncoder.encode("Purchase Order Accepted.", StandardCharsets.UTF_8.name()));
                return;

            } else if ("reject".equalsIgnoreCase(action)) {
                String poIdStr = request.getParameter("poId");
                if (poIdStr != null) {
                    purchaseOrderService.updatePurchaseOrderStatus(Long.parseLong(poIdStr), "CANCELLED");
                }
                response.sendRedirect(request.getContextPath() + "/purchase-orders?success="
                        + URLEncoder.encode("Purchase Order Rejected.", StandardCharsets.UTF_8.name()));
                return;

            } else if ("dispatch".equalsIgnoreCase(action)) {
                String poIdStr = request.getParameter("poId");
                if (poIdStr != null) {
                    purchaseOrderService.updatePurchaseOrderStatus(Long.parseLong(poIdStr), "PROCESSING");
                }
                response.sendRedirect(request.getContextPath() + "/purchase-orders?success="
                        + URLEncoder.encode("Purchase Order Dispatched.", StandardCharsets.UTF_8.name()));
                return;
            }

            response.sendRedirect(request.getContextPath() + "/purchase-orders");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/purchase-orders?error="
                    + URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8.name()));
        }
    }
}