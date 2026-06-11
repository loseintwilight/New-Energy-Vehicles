package com.ruoyi.charging.domain;

import java.math.BigDecimal;
import java.util.List;

/**
 * 工作台首页数据 VO（替代 Map 传参）
 */
public class DashboardVO {
    /** 四栏统计 */
    private BigDecimal totalIncome;
    private BigDecimal totalEnergy;
    private Integer totalOrders;
    private Integer availablePiles;
    private Integer totalPiles;

    /** 站点运行状态 */
    private List<DashboardStationVO> stations;

    /** 最近订单 */
    private List<DashboardOrderVO> recentOrders;

    /** 商户信息 */
    private Long merchantId;
    private String merchantName;

    public BigDecimal getTotalIncome() { return totalIncome; }
    public void setTotalIncome(BigDecimal totalIncome) { this.totalIncome = totalIncome; }

    public BigDecimal getTotalEnergy() { return totalEnergy; }
    public void setTotalEnergy(BigDecimal totalEnergy) { this.totalEnergy = totalEnergy; }

    public Integer getTotalOrders() { return totalOrders; }
    public void setTotalOrders(Integer totalOrders) { this.totalOrders = totalOrders; }

    public Integer getAvailablePiles() { return availablePiles; }
    public void setAvailablePiles(Integer availablePiles) { this.availablePiles = availablePiles; }

    public Integer getTotalPiles() { return totalPiles; }
    public void setTotalPiles(Integer totalPiles) { this.totalPiles = totalPiles; }

    public List<DashboardStationVO> getStations() { return stations; }
    public void setStations(List<DashboardStationVO> stations) { this.stations = stations; }

    public List<DashboardOrderVO> getRecentOrders() { return recentOrders; }
    public void setRecentOrders(List<DashboardOrderVO> recentOrders) { this.recentOrders = recentOrders; }

    public Long getMerchantId() { return merchantId; }
    public void setMerchantId(Long merchantId) { this.merchantId = merchantId; }

    public String getMerchantName() { return merchantName; }
    public void setMerchantName(String merchantName) { this.merchantName = merchantName; }
}
