package com.ruoyi.charging.domain;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 工作台 - 最近订单 VO
 */
public class DashboardOrderVO {
    private Long orderId;
    private String orderNo;
    private String pileCode;
    private String orderStatus;
    private Date startTime;
    private BigDecimal energy;
    private BigDecimal amount;

    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }

    public String getOrderNo() { return orderNo; }
    public void setOrderNo(String orderNo) { this.orderNo = orderNo; }

    public String getPileCode() { return pileCode; }
    public void setPileCode(String pileCode) { this.pileCode = pileCode; }

    public String getOrderStatus() { return orderStatus; }
    public void setOrderStatus(String orderStatus) { this.orderStatus = orderStatus; }

    public Date getStartTime() { return startTime; }
    public void setStartTime(Date startTime) { this.startTime = startTime; }

    public BigDecimal getEnergy() { return energy; }
    public void setEnergy(BigDecimal energy) { this.energy = energy; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }
}
