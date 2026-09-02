package com.globaltrade.ejb;

import com.globaltrade.core.dto.StockDTO;
import com.globaltrade.core.entity.InventoryItem;
import com.globaltrade.core.entity.InventoryStock;
import com.globaltrade.core.entity.Status;
import com.globaltrade.core.entity.Warehouse;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class InventoryServiceBeanTest {

    @Mock
    private EntityManager em;

    @Mock
    private TypedQuery<InventoryStock> stockQuery;

    @Mock
    private TypedQuery<Status> statusQuery;

    @InjectMocks
    private InventoryServiceBean inventoryService;

    @BeforeEach
    void setUp() throws Exception {
        Field emField = InventoryServiceBean.class.getDeclaredField("em");
        emField.setAccessible(true);
        emField.set(inventoryService, em);
    }

    @Test
    @DisplayName("Should successfully retrieve and map all warehouse inventory stock")
    void testGetAllStock() {
        InventoryItem item = new InventoryItem();
        item.setId(10L);
        item.setSku("SKU-1001");
        item.setName("Industrial Circuit Board");
        item.setReorderLevel(50);

        Warehouse wh = new Warehouse();
        wh.setId(1L);
        wh.setName("Colombo Central WH");

        Status status = new Status();
        status.setName("IN_STOCK");

        InventoryStock stock = new InventoryStock();
        stock.setId(100L);
        stock.setItem(item);
        stock.setWarehouse(wh);
        stock.setStockQty(420);
        stock.setUnitPrice(new BigDecimal("85.00"));
        stock.setStatus(status);
        stock.setLastUpdated(LocalDateTime.now());

        when(em.createQuery(anyString(), eq(InventoryStock.class))).thenReturn(stockQuery);
        when(stockQuery.getResultList()).thenReturn(Collections.singletonList(stock));

        List<StockDTO> results = inventoryService.getAllStock();

        assertNotNull(results);
        assertEquals(1, results.size());
        assertEquals("Industrial Circuit Board", results.get(0).getProductName());
        assertEquals(420, results.get(0).getStockQty());
        assertEquals("Colombo Central WH", results.get(0).getWarehouseName());
        assertEquals("IN_STOCK", results.get(0).getStatusName());
    }

    @Test
    @DisplayName("Should update stock quantity and status appropriately")
    void testQuickUpdateStock() {
        InventoryItem item = new InventoryItem();
        item.setId(1L);
        item.setReorderLevel(20);

        Warehouse wh = new Warehouse();
        wh.setId(1L);

        Status inStockStatus = new Status();
        inStockStatus.setName("IN_STOCK");

        InventoryStock mockStock = new InventoryStock();
        mockStock.setId(50L);
        mockStock.setItem(item);
        mockStock.setWarehouse(wh);
        mockStock.setStockQty(15);

        when(em.find(InventoryStock.class, 50L)).thenReturn(mockStock);
        when(em.createQuery(anyString(), eq(Status.class))).thenReturn(statusQuery);
        when(statusQuery.setParameter(eq("name"), anyString())).thenReturn(statusQuery);
        when(statusQuery.getSingleResult()).thenReturn(inStockStatus);

        inventoryService.quickUpdateStock(50L, 100);

        assertEquals(100, mockStock.getStockQty());
        verify(em, times(1)).merge(mockStock);
    }
}