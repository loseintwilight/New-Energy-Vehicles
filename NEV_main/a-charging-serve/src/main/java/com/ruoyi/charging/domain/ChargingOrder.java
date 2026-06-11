package com.ruoyi.charging.domain;

import java.util.Date;

/**
 * 充电订单表 stad_charging_order
 *
 * @author ruoyi
 */
public class ChargingOrder
{
    private static final long serialVersionUID = 1L;

    private Long orderId;
    private String orderNo;
    private Long userId;
    private Long stationId;
    /** 站点名称（关联查询，非数据库字段） */
    private String stationName;
    private Long pileId;
    private String pileCode;
    private Long rateId;
    private Long ratePeriodId;
    private java.util.Date startTime;
    private java.util.Date endTime;
    private Integer duration;
    private java.math.BigDecimal startSoc;
    private java.math.BigDecimal endSoc;
    private java.math.BigDecimal totalEnergy;
    private java.math.BigDecimal energyPrice;
    private java.math.BigDecimal servicePrice;
    private java.math.BigDecimal discountAmount;
    private java.math.BigDecimal totalAmount;
    private String rateDetail;
    private String orderStatus;
    private String payStatus;
    private String paymentMethod;
    private String transactionId;
    private Integer carbonEarned;
    /** 创建时间 */
    private Date createTime;
    /** 更新时间 */
    private Date updateTime;

    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }

    public String getOrderNo() { return orderNo; }
    public void setOrderNo(String orderNo) { this.orderNo = orderNo; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public Long getStationId() { return stationId; }
    public void setStationId(Long stationId) { this.stationId = stationId; }

    public String getStationName() { return stationName; }
    public void setStationName(String stationName) { this.stationName = stationName; }

    public Long getPileId() { return pileId; }
    public void setPileId(Long pileId) { this.pileId = pileId; }

    public String getPileCode() { return pileCode; }
    public void setPileCode(String pileCode) { this.pileCode = pileCode; }

    public Long getRateId() { return rateId; }
    public void setRateId(Long rateId) { this.rateId = rateId; }

    public Long getRatePeriodId() { return ratePeriodId; }
    public void setRatePeriodId(Long ratePeriodId) { this.ratePeriodId = ratePeriodId; }

    public java.util.Date getStartTime() { return startTime; }
    public void setStartTime(java.util.Date startTime) { this.startTime = startTime; }

    public java.util.Date getEndTime() { return endTime; }
    public void setEndTime(java.util.Date endTime) { this.endTime = endTime; }

    public Integer getDuration() { return duration; }
    public void setDuration(Integer duration) { this.duration = duration; }

    public java.math.BigDecimal getStartSoc() { return startSoc; }
    public void setStartSoc(java.math.BigDecimal startSoc) { this.startSoc = startSoc; }

    public java.math.BigDecimal getEndSoc() { return endSoc; }
    public void setEndSoc(java.math.BigDecimal endSoc) { this.endSoc = endSoc; }

    public java.math.BigDecimal getTotalEnergy() { return totalEnergy; }
    public void setTotalEnergy(java.math.BigDecimal totalEnergy) { this.totalEnergy = totalEnergy; }

    public java.math.BigDecimal getEnergyPrice() { return energyPrice; }
    public void setEnergyPrice(java.math.BigDecimal energyPrice) { this.energyPrice = energyPrice; }

    public java.math.BigDecimal getServicePrice() { return servicePrice; }
    public void setServicePrice(java.math.BigDecimal servicePrice) { this.servicePrice = servicePrice; }

    public java.math.BigDecimal getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(java.math.BigDecimal discountAmount) { this.discountAmount = discountAmount; }

    public java.math.BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(java.math.BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public String getRateDetail() { return rateDetail; }
    public void setRateDetail(String rateDetail) { this.rateDetail = rateDetail; }

    public String getOrderStatus() { return orderStatus; }
    public void setOrderStatus(String orderStatus) { this.orderStatus = orderStatus; }

    public String getPayStatus() { return payStatus; }
    public void setPayStatus(String payStatus) { this.payStatus = payStatus; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }

    public Integer getCarbonEarned() { return carbonEarned; }
    public void setCarbonEarned(Integer carbonEarned) { this.carbonEarned = carbonEarned; }

    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }

    public Date getUpdateTime() { return updateTime; }
    public void setUpdateTime(Date updateTime) { this.updateTime = updateTime; }
}
