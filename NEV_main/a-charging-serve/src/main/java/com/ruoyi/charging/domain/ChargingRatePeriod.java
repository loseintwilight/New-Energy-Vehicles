package com.ruoyi.charging.domain;

import java.util.Date;

/**
 * 充电费率时段表 stad_charging_rate_period
 *
 * @author ruoyi
 */
public class ChargingRatePeriod
{
    private static final long serialVersionUID = 1L;

    private Long periodId;
    private Long rateId;
    private String periodName;
    private String startTime;
    private String endTime;
    private java.math.BigDecimal energyPrice;
    private java.math.BigDecimal serviceFee;
    private java.math.BigDecimal totalPrice;
    private String priceType;
    private java.math.BigDecimal discountRate;
    private Integer sortOrder;
    /** 创建时间 */
    private Date createTime;
    /** 更新时间 */
    private Date updateTime;

    public Long getPeriodId() { return periodId; }
    public void setPeriodId(Long periodId) { this.periodId = periodId; }

    public Long getRateId() { return rateId; }
    public void setRateId(Long rateId) { this.rateId = rateId; }

    public String getPeriodName() { return periodName; }
    public void setPeriodName(String periodName) { this.periodName = periodName; }

    public String getStartTime() { return startTime; }
    public void setStartTime(String startTime) { this.startTime = startTime; }

    public String getEndTime() { return endTime; }
    public void setEndTime(String endTime) { this.endTime = endTime; }

    public java.math.BigDecimal getEnergyPrice() { return energyPrice; }
    public void setEnergyPrice(java.math.BigDecimal energyPrice) { this.energyPrice = energyPrice; }

    public java.math.BigDecimal getServiceFee() { return serviceFee; }
    public void setServiceFee(java.math.BigDecimal serviceFee) { this.serviceFee = serviceFee; }

    public java.math.BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(java.math.BigDecimal totalPrice) { this.totalPrice = totalPrice; }

    public String getPriceType() { return priceType; }
    public void setPriceType(String priceType) { this.priceType = priceType; }

    public java.math.BigDecimal getDiscountRate() { return discountRate; }
    public void setDiscountRate(java.math.BigDecimal discountRate) { this.discountRate = discountRate; }

    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }

    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }

    public Date getUpdateTime() { return updateTime; }
    public void setUpdateTime(Date updateTime) { this.updateTime = updateTime; }
}
