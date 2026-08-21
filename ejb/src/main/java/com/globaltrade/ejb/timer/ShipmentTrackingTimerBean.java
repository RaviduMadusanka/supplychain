package com.globaltrade.ejb.timer;

import com.globaltrade.core.entity.Shipment;
import com.globaltrade.core.entity.ShipmentStatus;
import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.time.LocalDateTime;
import java.util.List;
import java.util.logging.Logger;

@Singleton
@Startup
public class ShipmentTrackingTimerBean {

    private static final Logger LOGGER = Logger.getLogger(ShipmentTrackingTimerBean.class.getName());

    @PersistenceContext(unitName = "SupplyChainPU")
    private EntityManager em;

    @Schedule(minute = "*/30", hour = "*", persistent = false)
    public void trackActiveShipments() {
        LOGGER.info("--- Executing Timer Service: trackActiveShipments ---");

        try {
            List<Shipment> activeShipments = em.createQuery(
                    "SELECT s FROM Shipment s WHERE s.shipmentStatus.name != 'DELIVERED' AND s.shipmentStatus.name != 'CANCELLED'", 
                    Shipment.class)
                    .getResultList();

            LocalDateTime now = LocalDateTime.now();
            int updatedCount = 0;

            for (Shipment s : activeShipments) {
                // If estimated delivery date is in the past, or if we trigger it, update delivery
                if (s.getEstimatedDelivery() == null || s.getEstimatedDelivery().isBefore(now)) {
                    s.setActualDelivery(now);

                    ShipmentStatus deliveredStatus = getOrCreateShipmentStatus("DELIVERED", "Shipment successfully received at destination");
                    s.setShipmentStatus(deliveredStatus);
                    em.merge(s);
                    updatedCount++;
                    LOGGER.info(">>> Auto-updated Shipment " + s.getShipmentCode() + " to DELIVERED status.");
                }
            }

            LOGGER.info("Shipment Tracking Complete. Processed: " + activeShipments.size() + ", Delivered: " + updatedCount);
        } catch (Exception e) {
            LOGGER.severe("Error during shipment tracking timer execution: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private ShipmentStatus getOrCreateShipmentStatus(String name, String desc) {
        List<ShipmentStatus> list = em.createQuery("SELECT st FROM ShipmentStatus st WHERE st.name = :name", ShipmentStatus.class)
                .setParameter("name", name)
                .getResultList();
        if (!list.isEmpty()) {
            return list.get(0);
        }
        ShipmentStatus status = new ShipmentStatus();
        status.setName(name);
        status.setDescription(desc);
        em.persist(status);
        return status;
    }
}