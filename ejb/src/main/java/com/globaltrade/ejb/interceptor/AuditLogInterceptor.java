package com.globaltrade.ejb.interceptor;

import com.globaltrade.core.context.UserContext;
import com.globaltrade.core.dto.UserDTO;
import com.globaltrade.core.entity.AuditLog;
import com.globaltrade.core.entity.InventoryItem;
import com.globaltrade.core.entity.InventoryStock;
import com.globaltrade.core.entity.PurchaseOrder;
import com.globaltrade.core.entity.User;
import com.globaltrade.core.entity.Warehouse;
import jakarta.interceptor.AroundInvoke;
import jakarta.interceptor.InvocationContext;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.util.Arrays;

public class AuditLogInterceptor {

    @PersistenceContext(unitName = "SupplyChainPU")
    private EntityManager em;

    @AroundInvoke
    public Object logAudit(InvocationContext ic) throws Exception {
        Object result = null;
        try {
            result = ic.proceed();
        } catch (Exception e) {
            throw e;
        }

        try {
            String rawMethodName = ic.getMethod().getName();
            String lowerMethodName = rawMethodName.toLowerCase();

            // Skip read-only/fetching methods to avoid log spam
            if (lowerMethodName.startsWith("get") ||
                lowerMethodName.startsWith("find") ||
                lowerMethodName.startsWith("load") ||
                lowerMethodName.startsWith("list") ||
                lowerMethodName.startsWith("count") ||
                lowerMethodName.startsWith("is") ||
                lowerMethodName.startsWith("search") ||
                lowerMethodName.startsWith("fetch") ||
                lowerMethodName.startsWith("check")) {
                return result;
            }

            UserDTO currentUserDTO = UserContext.getUser();
            User performedBy = null;
            if (currentUserDTO != null && currentUserDTO.getId() != null) {
                performedBy = em.find(User.class, currentUserDTO.getId());
            }

            Object[] params = ic.getParameters();
            String entityName = ic.getTarget().getClass().getSimpleName().replace("ServiceBean", "").replace("Bean", "");
            String action = rawMethodName.toUpperCase();
            String details = "";
            Long entityId = 0L;

            if (lowerMethodName.contains("receivepurchaseordergoods") && params != null && params.length >= 1) {
                entityName = "PurchaseOrder";
                action = "GOODS_RECEIVED";
                Long poId = (params[0] instanceof Long) ? (Long) params[0] : null;
                entityId = (poId != null) ? poId : 0L;
                
                String poCode = "PO #" + poId;
                String whName = "";
                if (poId != null) {
                    PurchaseOrder po = em.find(PurchaseOrder.class, poId);
                    if (po != null) {
                        poCode = po.getPoCode();
                        if (po.getWarehouse() != null) {
                            whName = "at " + po.getWarehouse().getName();
                        }
                    }
                }
                details = String.format("Received goods for %s and auto-updated warehouse stock %s", poCode, whName);

            } else if (lowerMethodName.contains("acceptpurchaseorder") && params != null && params.length >= 1) {
                entityName = "PurchaseOrder";
                action = "PO_ACCEPTED";
                Long poId = (params[0] instanceof Long) ? (Long) params[0] : null;
                entityId = (poId != null) ? poId : 0L;
                details = "Vendor accepted Purchase Order #" + poId;

            } else if (lowerMethodName.contains("rejectpurchaseorder") && params != null && params.length >= 1) {
                entityName = "PurchaseOrder";
                action = "PO_REJECTED";
                Long poId = (params[0] instanceof Long) ? (Long) params[0] : null;
                entityId = (poId != null) ? poId : 0L;
                details = "Vendor rejected Purchase Order #" + poId;

            } else if (lowerMethodName.equals("addorupdatestock") && params != null && params.length >= 3) {
                entityName = "Inventory";
                action = "STOCK_UPDATE";
                Long prodId = (params[0] instanceof Long) ? (Long) params[0] : null;
                Long whId = (params[1] instanceof Long) ? (Long) params[1] : null;
                Integer qty = (params[2] instanceof Integer) ? (Integer) params[2] : 0;
                
                String prodName = "Item #" + prodId;
                if (prodId != null) {
                    entityId = prodId;
                    InventoryItem item = em.find(InventoryItem.class, prodId);
                    if (item != null) prodName = item.getName() + " (" + item.getSku() + ")";
                }
                String whName = (whId != null) ? "WH #" + whId : "";
                if (whId != null) {
                    Warehouse wh = em.find(Warehouse.class, whId);
                    if (wh != null) whName = wh.getName();
                }
                details = String.format("Updated stock for '%s' to %d units at %s", prodName, qty, whName);

            } else if (lowerMethodName.equals("quickupdatestock") && params != null && params.length >= 2) {
                entityName = "Inventory";
                action = "STOCK_UPDATE";
                Long stockId = (params[0] instanceof Long) ? (Long) params[0] : null;
                Integer newQty = (params[1] instanceof Integer) ? (Integer) params[1] : 0;
                
                String prodName = "Stock #" + stockId;
                String whName = "";
                if (stockId != null) {
                    InventoryStock stock = em.find(InventoryStock.class, stockId);
                    if (stock != null) {
                        if (stock.getItem() != null) {
                            entityId = stock.getItem().getId();
                            prodName = stock.getItem().getName() + " (" + stock.getItem().getSku() + ")";
                        }
                        if (stock.getWarehouse() != null) {
                            whName = "at " + stock.getWarehouse().getName();
                        }
                    }
                }
                details = String.format("Quick-updated stock for '%s' to %d units %s", prodName, newQty, whName);

            } else if (lowerMethodName.equals("reservestock") && params != null && params.length >= 3) {
                entityName = "Inventory";
                action = "STOCK_RESERVE";
                Long itemId = (params[0] instanceof Long) ? (Long) params[0] : null;
                Integer qty = (params[2] instanceof Integer) ? (Integer) params[2] : 0;
                
                String prodName = "Item #" + itemId;
                if (itemId != null) {
                    entityId = itemId;
                    InventoryItem item = em.find(InventoryItem.class, itemId);
                    if (item != null) prodName = item.getName() + " (" + item.getSku() + ")";
                }
                details = String.format("Reserved %d units of '%s'", qty, prodName);

            } else if (lowerMethodName.equals("updatestocklevels") && params != null && params.length >= 3) {
                entityName = "Inventory";
                action = "STOCK_RESTOCK";
                Long itemId = (params[0] instanceof Long) ? (Long) params[0] : null;
                Integer qtyToAdd = (params[2] instanceof Integer) ? (Integer) params[2] : 0;
                
                String prodName = "Item #" + itemId;
                if (itemId != null) {
                    entityId = itemId;
                    InventoryItem item = em.find(InventoryItem.class, itemId);
                    if (item != null) prodName = item.getName() + " (" + item.getSku() + ")";
                }
                details = String.format("Added %d units to stock for '%s'", qtyToAdd, prodName);

            } else if (lowerMethodName.contains("createvendor")) {
                entityName = "Vendor";
                action = "CREATE";
                String compName = (params != null && params.length > 0 && params[0] != null) ? params[0].toString() : "Unknown";
                String contact = (params != null && params.length > 1 && params[1] != null) ? params[1].toString() : "";
                details = String.format("Registered new vendor '%s' (Contact: %s)", compName, contact);

            } else if (lowerMethodName.contains("updatevendorstatus")) {
                entityName = "Vendor";
                action = "UPDATE_STATUS";
                Long vId = (params != null && params.length > 0 && params[0] instanceof Long) ? (Long) params[0] : 0L;
                String status = (params != null && params.length > 1 && params[1] != null) ? params[1].toString() : "";
                entityId = vId;
                details = String.format("Changed Vendor #%d status to %s", vId, status);

            } else if (lowerMethodName.contains("createuser")) {
                entityName = "User";
                action = "CREATE";
                String name = (params != null && params.length > 0 && params[0] != null) ? params[0].toString() : "";
                String email = (params != null && params.length > 1 && params[1] != null) ? params[1].toString() : "";
                String role = (params != null && params.length > 2 && params[2] != null) ? params[2].toString() : "";
                details = String.format("Provisioned user '%s' (%s) with role %s", name, email, role);

            } else {
                details = String.format("Executed %s with parameters: %s", rawMethodName, Arrays.toString(params));
            }

            AuditLog log = new AuditLog();
            log.setEntityName(entityName);
            log.setAction(action);
            log.setEntityId(entityId);
            log.setPerformedBy(performedBy);
            log.setDetails(details);

            em.persist(log);

        } catch (Exception e) {
            System.err.println("Failed to write Audit Log: " + e.getMessage());
        }

        return result;
    }
}