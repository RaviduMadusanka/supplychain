package com.globaltrade.core.service;

import com.globaltrade.core.entity.Order;
import jakarta.ejb.Local;
import java.util.Map;

@Local
public interface OrderService {
    Order createOrderWithBMT(Long customerId, Long vendorId, Map<Long, Integer> itemsWithQuantities, Long warehouseId) throws Exception;
}
