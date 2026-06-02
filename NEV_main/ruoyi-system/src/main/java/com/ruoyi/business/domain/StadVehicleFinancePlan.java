package com.ruoyi.business.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;
import java.math.BigDecimal;

public class StadVehicleFinancePlan extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long planId;
    private Long vehicleId;
    private String planType;
    private String planName;
    private BigDecimal totalPrice;
    private BigDecimal downPayment;
    private BigDecimal monthlyPayment;
    private Integer months;
    private BigDecimal interestRate;
    private BigDecimal totalInterest;
    private BigDecimal totalPayable;
    private String provider;
    private Integer isActive;
    private Integer sortOrder;

    public Long getPlanId() { return planId; }
    public void setPlanId(Long planId) { this.planId = planId; }
    public Long getVehicleId() { return vehicleId; }
    public void setVehicleId(Long vehicleId) { this.vehicleId = vehicleId; }
    public String getPlanType() { return planType; }
    public void setPlanType(String planType) { this.planType = planType; }
    public String getPlanName() { return planName; }
    public void setPlanName(String planName) { this.planName = planName; }
    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }
    public BigDecimal getDownPayment() { return downPayment; }
    public void setDownPayment(BigDecimal downPayment) { this.downPayment = downPayment; }
    public BigDecimal getMonthlyPayment() { return monthlyPayment; }
    public void setMonthlyPayment(BigDecimal monthlyPayment) { this.monthlyPayment = monthlyPayment; }
    public Integer getMonths() { return months; }
    public void setMonths(Integer months) { this.months = months; }
    public BigDecimal getInterestRate() { return interestRate; }
    public void setInterestRate(BigDecimal interestRate) { this.interestRate = interestRate; }
    public BigDecimal getTotalInterest() { return totalInterest; }
    public void setTotalInterest(BigDecimal totalInterest) { this.totalInterest = totalInterest; }
    public BigDecimal getTotalPayable() { return totalPayable; }
    public void setTotalPayable(BigDecimal totalPayable) { this.totalPayable = totalPayable; }
    public String getProvider() { return provider; }
    public void setProvider(String provider) { this.provider = provider; }
    public Integer getIsActive() { return isActive; }
    public void setIsActive(Integer isActive) { this.isActive = isActive; }
    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("planId", getPlanId()).append("vehicleId", getVehicleId())
                .append("planType", getPlanType()).append("planName", getPlanName())
                .append("totalPrice", getTotalPrice()).append("totalPayable", getTotalPayable())
                .append("isActive", getIsActive()).toString();
    }
}