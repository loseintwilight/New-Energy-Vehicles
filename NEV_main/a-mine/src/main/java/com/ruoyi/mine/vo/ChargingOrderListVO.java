package com.ruoyi.mine.vo;

import com.ruoyi.common.core.domain.BaseEntity;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 充电记录列表返回VO
 */
public class ChargingOrderListVO extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 订单ID */
    private Long orderId;

    /** 订单编号 */
    private String orderNo;

    /** 充电站名称 */
    private String stationName;

    /** 充电站地址 */
    private String address;

    /** 开始时间 */
    private Date startTime;

    /** 结束时间 */
    private Date endTime;

    /** 充电时长(秒) */
    private Integer duration;

    /** 充电时长文字描述 */
    private String durationText;

    /** 充电量(kWh) */
    private BigDecimal totalEnergy;

    /** 电费 */
    private BigDecimal energyPrice;

    /** 服务费 */
    private BigDecimal servicePrice;

    /** 总金额 */
    private BigDecimal totalAmount;

    /** 订单状态 0=充电中 1=已完成 2=已取消 */
    private String orderStatus;

    /** 支付状态 0=未支付 1=已支付 */
    private String payStatus;

    /** 支付方式 */
    private String paymentMethod;

    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }

    public String getOrderNo() { return orderNo; }
    public void setOrderNo(String orderNo) { this.orderNo = orderNo; }

    public String getStationName() { return stationName; }
    public void setStationName(String stationName) { this.stationName = stationName; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public Date getStartTime() { return startTime; }
    public void setStartTime(Date startTime) { this.startTime = startTime; }

    public Date getEndTime() { return endTime; }
    public void setEndTime(Date endTime) { this.endTime = endTime; }

    public Integer getDuration() { return duration; }
    public void setDuration(Integer duration) { this.duration = duration; }

    public String getDurationText() { return durationText; }
    public void setDurationText(String durationText) { this.durationText = durationText; }

    public BigDecimal getTotalEnergy() { return totalEnergy; }
    public void setTotalEnergy(BigDecimal totalEnergy) { this.totalEnergy = totalEnergy; }

    public BigDecimal getEnergyPrice() { return energyPrice; }
    public void setEnergyPrice(BigDecimal energyPrice) { this.energyPrice = energyPrice; }

    public BigDecimal getServicePrice() { return servicePrice; }
    public void setServicePrice(BigDecimal servicePrice) { this.servicePrice = servicePrice; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public String getOrderStatus() { return orderStatus; }
    public void setOrderStatus(String orderStatus) { this.orderStatus = orderStatus; }

    public String getPayStatus() { return payStatus; }
    public void setPayStatus(String payStatus) { this.payStatus = payStatus; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
}