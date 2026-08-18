package com.globaltrade.ejb.timer;

import com.globaltrade.core.entity.Shipment;
import com.globaltrade.core.entity.Vendor;
import com.globaltrade.core.entity.VendorPerformance;
import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.List;

@Singleton
public class VendorPerformanceTimerBean {

    @PersistenceContext(unitName = "SupplyChainPU")
    private EntityManager em;

    @Schedule(hour = "*", minute = "0", persistent = false)
    public void evaluateVendorPerformance() {
        System.out.println("--- Executing Timer Service: evaluateVendorPerformance ---");

        List<Vendor> vendors = em.createQuery("SELECT v FROM Vendor v WHERE v.status = 'ACTIVE'", Vendor.class).getResultList();

        for (Vendor vendor : vendors) {
            List<Shipment> deliveredShipments = em.createQuery(
                    "SELECT s FROM Shipment s WHERE s.vendor.id = :vendorId AND s.status = 'DELIVERED'", 
                    Shipment.class)
                    .setParameter("vendorId", vendor.getId())
                    .getResultList();

            if (deliveredShipments.isEmpty()) continue;

            int onTimeCount = 0;
            for (Shipment s : deliveredShipments) {
                if (s.getActualDelivery() != null && s.getEstimatedDelivery() != null) {
                    if (!s.getActualDelivery().isAfter(s.getEstimatedDelivery())) {
                        onTimeCount++;
                    }
                }
            }

            double onTimeRate = ((double) onTimeCount / deliveredShipments.size()) * 100.0;

            double qualityScore = 80.0 + (Math.random() * 20.0);

            double responseTime = 2.0 + (Math.random() * 10.0);

            double overallRating = ((onTimeRate / 100) * 2.0) + ((qualityScore / 100) * 2.0) + (1.0 - (responseTime / 24.0));
            if (overallRating > 5.0) overallRating = 5.0;

            VendorPerformance vp = new VendorPerformance();
            vp.setVendor(vendor);
            vp.setEvaluationDate(LocalDate.now());
            vp.setOnTimeDeliveryRate(BigDecimal.valueOf(onTimeRate).setScale(2, RoundingMode.HALF_UP));
            vp.setQualityScore(BigDecimal.valueOf(qualityScore).setScale(2, RoundingMode.HALF_UP));
            vp.setResponseTimeHours(BigDecimal.valueOf(responseTime).setScale(2, RoundingMode.HALF_UP));
            vp.setOverallRating(BigDecimal.valueOf(overallRating).setScale(2, RoundingMode.HALF_UP));

            em.persist(vp);

            vendor.setRating(vp.getOverallRating());
            em.merge(vendor);

            System.out.println(">>> Updated Performance for Vendor: " + vendor.getCompanyName() + " | Rating: " + vp.getOverallRating());
        }
    }
}
