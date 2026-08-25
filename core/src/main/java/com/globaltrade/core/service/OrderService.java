package com.globaltrade.core.service;

import com.globaltrade.core.dto.OrderDTO;
import com.globaltrade.core.entity.Customer;
import com.globaltrade.core.entity.Order;
import jakarta.ejb.Local;
import java.util.List;
import java.util.Map;

@Local
public interface OrderService {
    Order createOrderWithBMT(Long customerId, Long vendorId, Map<Long, Integer> itemsWithQuantities, Long warehouseId) throws Exception;
    List<OrderDTO> getAllOrders();
    List<OrderDTO> getOrdersByCustomerUserId(Long userId);
    OrderDTO getOrderDetails(Long orderId);
    OrderDTO getOrderByCode(String code);
    OrderDTO createCustomerOrder(Long userId, Map<Long, Integer> productQuantities, String destinationAddress, Long countryId) throws Exception;
    Customer getOrCreateCustomerForUser(Long userId) throws Exception;
    void startProcessingOrder(Long orderId);
    void createShipmentForOrder(Long orderId, Long originWarehouseId, String carrierName, String destination, int deliveryDays);
    void completeOrder(Long orderId);
}