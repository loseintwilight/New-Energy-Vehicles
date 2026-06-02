package com.ruoyi.business.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;
import java.math.BigDecimal;
import java.util.Date;

public class StadChargingRatePeriod extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long periodId;
    private Long rateId;
    private String periodName;
    private Date startTime;
    private Date endTime;
    private BigDecimal energyPrice;
    private BigDecimal serviceFee;
    private BigDecimal totalPrice;
    private BigDecimal discountRate;
    private Integer sortOrder;

    public Long getPeriodId() { return periodId; }
    public void setPeriodId(Long periodId) { this.periodId = periodId; }
    public Long getRateId() { return rateId; }
    public void setRateId(Long rateId) { this.rateId = rateId; }
    public String getPeriodName() { return periodName; }
    public void setPeriodName(String periodName) { this.periodName = periodName; }
    public Date getStartTime() { return startTime; }
    public void setStartTime(Date startTime) { this.startTime = startTime; }
    public Date getEndTime() { return endTime; }
    public void setEndTime(Date endTime) { this.endTime = endTime; }
    public BigDecimal getEnergyPrice() { return energyPrice; }
    public void setEnergyPrice(BigDecimal energyPrice) { this.energyPrice = energyPrice; }
    public BigDecimal getServiceFee() { return serviceFee; }
    public void setServiceFee(BigDecimal serviceFee) { this.serviceFee = serviceFee; }
    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }
    public BigDecimal getDiscountRate() { return discountRate; }
    public void setDiscountRate(BigDecimal discountRate) { this.discountRate = discountRate; }
    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("periodId", getPeriodId()).append("rateId", getRateId())
                .append("periodName", getPeriodName()).append("totalPrice", getTotalPrice()).toString();
    }
}