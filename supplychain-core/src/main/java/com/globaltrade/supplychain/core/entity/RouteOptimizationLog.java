package com.globaltrade.supplychain.core.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "route_optimization_log")
public class RouteOptimizationLog implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "shipment_id")
    private Shipment shipment;

    @Column(name = "old_route", columnDefinition = "TEXT")
    private String oldRoute;

    @Column(name = "optimized_route", columnDefinition = "TEXT")
    private String optimizedRoute;

    @Column(name = "distance_saved_km", precision = 10, scale = 2)
    private BigDecimal distanceSavedKm;

    @Column(name = "calculated_at")
    private LocalDateTime calculatedAt;

    @PrePersist
    protected void onCreate() {
        calculatedAt = LocalDateTime.now();
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Shipment getShipment() { return shipment; }
    public void setShipment(Shipment shipment) { this.shipment = shipment; }
    public String getOldRoute() { return oldRoute; }
    public void setOldRoute(String oldRoute) { this.oldRoute = oldRoute; }
    public String getOptimizedRoute() { return optimizedRoute; }
    public void setOptimizedRoute(String optimizedRoute) { this.optimizedRoute = optimizedRoute; }
    public BigDecimal getDistanceSavedKm() { return distanceSavedKm; }
    public void setDistanceSavedKm(BigDecimal distanceSavedKm) { this.distanceSavedKm = distanceSavedKm; }
    public LocalDateTime getCalculatedAt() { return calculatedAt; }
    public void setCalculatedAt(LocalDateTime calculatedAt) { this.calculatedAt = calculatedAt; }
}
