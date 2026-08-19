package com.globaltrade.core.dto;

import java.io.Serializable;

public class WarehouseDTO implements Serializable {
    private Long id;
    private String warehouseCode;
    private String name;
    private String location;
    private String countryName;
    private Integer capacity;
    private Integer currentUtilization;
    private String managerName;

    public WarehouseDTO() {}

    public WarehouseDTO(Long id, String name) {
        this.id = id;
        this.name = name;
    }

    public WarehouseDTO(Long id, String warehouseCode, String name, String location, String countryName, Integer capacity, Integer currentUtilization, String managerName) {
        this.id = id;
        this.warehouseCode = warehouseCode;
        this.name = name;
        this.location = location;
        this.countryName = countryName;
        this.capacity = capacity != null ? capacity : 0;
        this.currentUtilization = currentUtilization != null ? currentUtilization : 0;
        this.managerName = managerName;
    }

    public int getUtilizationPercentage() {
        if (capacity == null || capacity <= 0) {
            return 0;
        }
        int used = (currentUtilization != null) ? currentUtilization : 0;
        return Math.min(100, (int) Math.round(((double) used / capacity) * 100.0));
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getWarehouseCode() { return warehouseCode; }
    public void setWarehouseCode(String warehouseCode) { this.warehouseCode = warehouseCode; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public String getCountryName() { return countryName; }
    public void setCountryName(String countryName) { this.countryName = countryName; }
    public Integer getCapacity() { return capacity; }
    public void setCapacity(Integer capacity) { this.capacity = capacity; }
    public Integer getCurrentUtilization() { return currentUtilization; }
    public void setCurrentUtilization(Integer currentUtilization) { this.currentUtilization = currentUtilization; }
    public String getManagerName() { return managerName; }
    public void setManagerName(String managerName) { this.managerName = managerName; }
}
