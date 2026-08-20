package com.globaltrade.core.service;

import com.globaltrade.core.dto.OrderDTO;
import com.globaltrade.core.entity.Order;
import jakarta.ejb.Local;
import java.util.List;
import java.util.Map;

@Local
public interface OrderService {
    Order createOrderWithBMT(Long customerId, Long vendorId, Map<Long, Integer> itemsWithQuantities, Long warehouseId) throws Exception;
    
    List<OrderDTO> getAllOrders();
    OrderDTO getOrderDetails(Long orderId);
    void startProcessingOrder(Long orderId);
    void createShipmentForOrder(Long orderId, Long originWarehouseId, String carrierName, String destination, int deliveryDays);
    void completeOrder(Long orderId);
}
