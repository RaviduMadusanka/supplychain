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
            List<Shipment> inTransitShipments = em.createQuery(
                    "SELECT s FROM Shipment s WHERE s.shipmentStatus.name = 'IN_TRANSIT' OR s.shipmentStatus.name = 'DISPATCHED'", 
                    Shipment.class)
                    .getResultList();

            LocalDateTime now = LocalDateTime.now();

            for (Shipment s : inTransitShipments) {
                // If estimated delivery time has passed, auto-complete or check delay
                if (s.getEstimatedDelivery() != null && s.getEstimatedDelivery().isBefore(now)) {
                    s.setActualDelivery(now);
                    
                    try {
                        ShipmentStatus deliveredStatus = em.createQuery(
                                "SELECT st FROM ShipmentStatus st WHERE st.name = 'DELIVERED'", ShipmentStatus.class)
                                .getSingleResult();
                        s.setShipmentStatus(deliveredStatus);
                        em.merge(s);
                        LOGGER.info(">>> Auto-updated Shipment " + s.getShipmentCode() + " to DELIVERED status.");
                    } catch (Exception ex) {
                        LOGGER.warning("Could not find DELIVERED status: " + ex.getMessage());
                    }
                }
            }
        } catch (Exception e) {
            LOGGER.severe("Error during shipment tracking timer execution: " + e.getMessage());
        }
    }
}