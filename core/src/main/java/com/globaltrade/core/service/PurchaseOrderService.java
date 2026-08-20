package com.globaltrade.core.service;

import com.globaltrade.core.dto.PurchaseOrderDTO;
import jakarta.ejb.Remote;
import java.util.List;
import java.util.Map;

@Remote
public interface PurchaseOrderService {

    List<PurchaseOrderDTO> getAllPurchaseOrders();

    List<PurchaseOrderDTO> getPurchaseOrdersForWarehouse(Long warehouseId);

    List<PurchaseOrderDTO> getPurchaseOrdersForVendor(Long vendorId);

    PurchaseOrderDTO getPurchaseOrderDetails(Long poId);

    void createPurchaseOrder(Long warehouseId, Long vendorId, Map<Long, Integer> productQuantities);

    void updatePurchaseOrderStatus(Long poId, String statusName);

    void receivePurchaseOrderGoods(Long poId);
}
