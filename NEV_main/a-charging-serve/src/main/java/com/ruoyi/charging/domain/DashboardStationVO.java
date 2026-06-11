package com.ruoyi.charging.domain;

import java.math.BigDecimal;

/**
 * 工作台 - 站点运行状态 VO
 */
public class DashboardStationVO {
    private Long stationId;
    private String stationName;
    private String stationStatus;
    private Integer totalPiles;
    private Integer availablePiles;
    private BigDecimal todayIncome;
    private Integer todayOrders;
    private BigDecimal todayEnergy;

    public Long getStationId() { return stationId; }
    public void setStationId(Long stationId) { this.stationId = stationId; }

    public String getStationName() { return stationName; }
    public void setStationName(String stationName) { this.stationName = stationName; }

    public String getStationStatus() { return stationStatus; }
    public void setStationStatus(String stationStatus) { this.stationStatus = stationStatus; }

    public Integer getTotalPiles() { return totalPiles; }
    public void setTotalPiles(Integer totalPiles) { this.totalPiles = totalPiles; }

    public Integer getAvailablePiles() { return availablePiles; }
    public void setAvailablePiles(Integer availablePiles) { this.availablePiles = availablePiles; }

    public BigDecimal getTodayIncome() { return todayIncome; }
    public void setTodayIncome(BigDecimal todayIncome) { this.todayIncome = todayIncome; }

    public Integer getTodayOrders() { return todayOrders; }
    public void setTodayOrders(Integer todayOrders) { this.todayOrders = todayOrders; }

    public BigDecimal getTodayEnergy() { return todayEnergy; }
    public void setTodayEnergy(BigDecimal todayEnergy) { this.todayEnergy = todayEnergy; }
}
