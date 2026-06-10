package com.ruoyi.business.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;
import java.math.BigDecimal;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

public class StadUnifiedOrder extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long orderId;
    private String orderNo;
    private String orderType;
    private Long userId;
    private Long vehicleId;
    private Long merchantId;
    private String contactName;
    private String contactPhone;
    private Long addressId;
    private BigDecimal vehiclePrice;
    private BigDecimal totalAmount;
    private BigDecimal paidAmount;
    private String paymentMethod;
    private String insuranceInfo;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date expectDate;
    private String expectTimeSlot;
    private Long oldVehicleId;
    private BigDecimal oldValuation;
    private Long newOrderId;
    private String status;
    private String cancelReason;

    private String merchantName;
    private String nickName;

    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }

    public String getOrderNo() { return orderNo; }
    public void setOrderNo(String orderNo) { this.orderNo = orderNo; }

    public String getOrderType() { return orderType; }
    public void setOrderType(String orderType) { this.orderType = orderType; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public Long getVehicleId() { return vehicleId; }
    public void setVehicleId(Long vehicleId) { this.vehicleId = vehicleId; }

    public Long getMerchantId() { return merchantId; }
    public void setMerchantId(Long merchantId) { this.merchantId = merchantId; }

    public String getContactName() { return contactName; }
    public void setContactName(String contactName) { this.contactName = contactName; }

    public String getContactPhone() { return contactPhone; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }

    public Long getAddressId() { return addressId; }
    public void setAddressId(Long addressId) { this.addressId = addressId; }

    public BigDecimal getVehiclePrice() { return vehiclePrice; }
    public void setVehiclePrice(BigDecimal vehiclePrice) { this.vehiclePrice = vehiclePrice; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public BigDecimal getPaidAmount() { return paidAmount; }
    public void setPaidAmount(BigDecimal paidAmount) { this.paidAmount = paidAmount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getInsuranceInfo() { return insuranceInfo; }
    public void setInsuranceInfo(String insuranceInfo) { this.insuranceInfo = insuranceInfo; }

    public Date getExpectDate() { return expectDate; }
    public void setExpectDate(Date expectDate) { this.expectDate = expectDate; }

    public String getExpectTimeSlot() { return expectTimeSlot; }
    public void setExpectTimeSlot(String expectTimeSlot) { this.expectTimeSlot = expectTimeSlot; }

    public Long getOldVehicleId() { return oldVehicleId; }
    public void setOldVehicleId(Long oldVehicleId) { this.oldVehicleId = oldVehicleId; }

    public BigDecimal getOldValuation() { return oldValuation; }
    public void setOldValuation(BigDecimal oldValuation) { this.oldValuation = oldValuation; }

    public Long getNewOrderId() { return newOrderId; }
    public void setNewOrderId(Long newOrderId) { this.newOrderId = newOrderId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCancelReason() { return cancelReason; }
    public void setCancelReason(String cancelReason) { this.cancelReason = cancelReason; }

    public String getMerchantName() { return merchantName; }
    public void setMerchantName(String merchantName) { this.merchantName = merchantName; }

    public String getNickName() { return nickName; }
    public void setNickName(String nickName) { this.nickName = nickName; }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("orderId", getOrderId())
                .append("orderNo", getOrderNo())
                .append("orderType", getOrderType())
                .append("totalAmount", getTotalAmount())
                .append("status", getStatus())
                .append("createTime", getCreateTime())
                .toString();
    }
}