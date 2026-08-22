package com.globaltrade.core.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;

public class VendorPerformanceDTO implements Serializable {
    private Long id;
    private Long vendorId;
    private String vendorName;
    private LocalDate evaluationDate;
    private BigDecimal onTimeDeliveryRate;
    private BigDecimal qualityScore;
    private BigDecimal responseTimeHours;
    private BigDecimal overallRating;

    public VendorPerformanceDTO() {}

    public VendorPerformanceDTO(Long id, Long vendorId, String vendorName, LocalDate evaluationDate,
                                BigDecimal onTimeDeliveryRate, BigDecimal qualityScore,
                                BigDecimal responseTimeHours, BigDecimal overallRating) {
        this.id = id;
        this.vendorId = vendorId;
        this.vendorName = vendorName;
        this.evaluationDate = evaluationDate;
        this.onTimeDeliveryRate = onTimeDeliveryRate;
        this.qualityScore = qualityScore;
        this.responseTimeHours = responseTimeHours;
        this.overallRating = overallRating;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getVendorId() { return vendorId; }
    public void setVendorId(Long vendorId) { this.vendorId = vendorId; }
    public String getVendorName() { return vendorName; }
    public void setVendorName(String vendorName) { this.vendorName = vendorName; }
    public LocalDate getEvaluationDate() { return evaluationDate; }
    public void setEvaluationDate(LocalDate evaluationDate) { this.evaluationDate = evaluationDate; }
    public BigDecimal getOnTimeDeliveryRate() { return onTimeDeliveryRate; }
    public void setOnTimeDeliveryRate(BigDecimal onTimeDeliveryRate) { this.onTimeDeliveryRate = onTimeDeliveryRate; }
    public BigDecimal getQualityScore() { return qualityScore; }
    public void setQualityScore(BigDecimal qualityScore) { this.qualityScore = qualityScore; }
    public BigDecimal getResponseTimeHours() { return responseTimeHours; }
    public void setResponseTimeHours(BigDecimal responseTimeHours) { this.responseTimeHours = responseTimeHours; }
    public BigDecimal getOverallRating() { return overallRating; }
    public void setOverallRating(BigDecimal overallRating) { this.overallRating = overallRating; }
}