package com.ruoyi.business.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;
import java.math.BigDecimal;
import java.util.Date;

public class StadChargingOrder extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long orderId;
    private String orderNo;
    private Long userId;
    private Long stationId;
    private Long pileId;
    private String pileCode;
    private Long rateId;
    private Long ratePeriodId;
    private Date startTime;
    private Date endTime;
    private Integer duration;
    private BigDecimal startSoc;
    private BigDecimal endSoc;
    private BigDecimal totalEnergy;
    private BigDecimal energyPrice;
    private BigDecimal servicePrice;
    private BigDecimal discountAmount;
    private BigDecimal totalAmount;
    private String rateDetail;
    private String orderStatus;
    private String payStatus;
    private String paymentMethod;
    private String transactionId;
    private Integer carbonEarned;

    private String stationName;
    private String nickName;
    private String contactName;
    private String contactPhone;

    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }

    public String getOrderNo() { return orderNo; }
    public void setOrderNo(String orderNo) { this.orderNo = orderNo; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public Long getStationId() { return stationId; }
    public void setStationId(Long stationId) { this.stationId = stationId; }

    public Long getPileId() { return pileId; }
    public void setPileId(Long pileId) { this.pileId = pileId; }

    public String getPileCode() { return pileCode; }
    public void setPileCode(String pileCode) { this.pileCode = pileCode; }

    public Long getRateId() { return rateId; }
    public void setRateId(Long rateId) { this.rateId = rateId; }

    public Long getRatePeriodId() { return ratePeriodId; }
    public void setRatePeriodId(Long ratePeriodId) { this.ratePeriodId = ratePeriodId; }

    public Date getStartTime() { return startTime; }
    public void setStartTime(Date startTime) { this.startTime = startTime; }

    public Date getEndTime() { return endTime; }
    public void setEndTime(Date endTime) { this.endTime = endTime; }

    public Integer getDuration() { return duration; }
    public void setDuration(Integer duration) { this.duration = duration; }

    public BigDecimal getStartSoc() { return startSoc; }
    public void setStartSoc(BigDecimal startSoc) { this.startSoc = startSoc; }

    public BigDecimal getEndSoc() { return endSoc; }
    public void setEndSoc(BigDecimal endSoc) { this.endSoc = endSoc; }

    public BigDecimal getTotalEnergy() { return totalEnergy; }
    public void setTotalEnergy(BigDecimal totalEnergy) { this.totalEnergy = totalEnergy; }

    public BigDecimal getEnergyPrice() { return energyPrice; }
    public void setEnergyPrice(BigDecimal energyPrice) { this.energyPrice = energyPrice; }

    public BigDecimal getServicePrice() { return servicePrice; }
    public void setServicePrice(BigDecimal servicePrice) { this.servicePrice = servicePrice; }

    public BigDecimal getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(BigDecimal discountAmount) { this.discountAmount = discountAmount; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

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

    public String getStationName() { return stationName; }
    public void setStationName(String stationName) { this.stationName = stationName; }

    public String getNickName() { return nickName; }
    public void setNickName(String nickName) { this.nickName = nickName; }

    public String getContactName() { return contactName; }
    public void setContactName(String contactName) { this.contactName = contactName; }

    public String getContactPhone() { return contactPhone; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("orderId", getOrderId())
                .append("orderNo", getOrderNo())
                .append("userId", getUserId())
                .append("totalEnergy", getTotalEnergy())
                .append("totalAmount", getTotalAmount())
                .append("orderStatus", getOrderStatus())
                .append("payStatus", getPayStatus())
                .append("createTime", getCreateTime())
                .toString();
    }
}