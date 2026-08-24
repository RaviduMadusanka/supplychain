package com.globaltrade.ejb.timer;

import com.globaltrade.core.entity.InventoryAlert;
import com.globaltrade.core.entity.InventoryItem;
import com.globaltrade.core.entity.InventoryStock;
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
import java.util.Collections;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class InventoryAlertTimerBeanTest {

    @Mock
    private EntityManager em;

    @Mock
    private TypedQuery<InventoryStock> stockQuery;

    @Mock
    private TypedQuery<InventoryAlert> alertQuery;

    @InjectMocks
    private InventoryAlertTimerBean timerBean;

    @BeforeEach
    void setUp() throws Exception {
        Field emField = InventoryAlertTimerBean.class.getDeclaredField("em");
        emField.setAccessible(true);
        emField.set(timerBean, em);
    }

    @Test
    @DisplayName("Timer should trigger automated InventoryAlert when stock falls below reorder level")
    void testLowStockAlertTriggered() {
        InventoryItem item = new InventoryItem();
        item.setId(5L);
        item.setSku("SKU-9901");
        item.setName("Critical Hydraulic Valve");
        item.setReorderLevel(50);

        Warehouse wh = new Warehouse();
        wh.setId(1L);
        wh.setName("Singapore Regional Hub");

        InventoryStock lowStock = new InventoryStock();
        lowStock.setId(10L);
        lowStock.setItem(item);
        lowStock.setWarehouse(wh);
        lowStock.setStockQty(12); // Low stock (12 <= 50)

        when(em.createQuery(contains("InventoryStock"), eq(InventoryStock.class))).thenReturn(stockQuery);
        when(stockQuery.getResultList()).thenReturn(Collections.singletonList(lowStock));

        when(em.createQuery(contains("InventoryAlert"), eq(InventoryAlert.class))).thenReturn(alertQuery);
        when(alertQuery.setParameter(anyString(), any())).thenReturn(alertQuery);
        when(alertQuery.getResultList()).thenReturn(Collections.emptyList()); // No previous unresolved alert

        // Execute scheduled timer logic
        timerBean.checkLowStockLevels();

        // Verify that an InventoryAlert was created and persisted
        verify(em, atLeastOnce()).persist(any(InventoryAlert.class));
    }
}