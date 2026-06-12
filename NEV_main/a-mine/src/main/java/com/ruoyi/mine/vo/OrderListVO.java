package com.ruoyi.mine.vo;

import java.math.BigDecimal;

/**
 * 统一订单列表 VO（覆盖统一订单/充电订单/维保订单三种类型）
 */
public class OrderListVO {

    // ==================== 公共字段 ====================
    /** 订单ID */
    private Long orderId;

    /** 订单编号 */
    private String orderNo;

    /** 订单大类: "unified" / "charging" / "maintenance" */
    private String bizType;

    /** 订单类型标签文字（前端彩色标签用） */
    private String bizTypeLabel;

    /** 归一化状态: "0"=unpaid "1"=pending "2"=completed "3"=cancelled */
    private String status;

    /** 状态文字 */
    private String statusText;

    /** 商家/门店/充电站名称 */
    private String shopName;

    /** 订单金额 */
    private BigDecimal totalAmount;

    /** 实付金额 */
    private BigDecimal paidAmount;

    /** 创建时间（已格式化 yyyy-MM-dd HH:mm:ss） */
    private String createTime;

    /** 商品标题（卡片主标题） */
    private String title;

    /** 商品描述（卡片副标题） */
    private String desc;

    // ==================== 统一订单特有 ====================
    /** purchase / test_drive / trade_in */
    private String unifiedType;

    /** 联系人 */
    private String contactName;

    /** 联系电话 */
    private String contactPhone;

    /** 车辆ID */
    private Long vehicleId;

    /** 车辆价格 */
    private BigDecimal vehiclePrice;

    /** 支付方式 */
    private String paymentMethod;

    /** 以旧换新 - 旧车估值 */
    private BigDecimal oldValuation;

    /** 以旧换新 - 旧车品牌 */
    private String oldVehicleBrand;

    /** 以旧换新 - 旧车车型 */
    private String oldVehicleModel;

    /** 以旧换新 - 旧车上牌年份 */
    private String oldVehicleYear;

    /** 以旧换新 - 旧车里程 */
    private String oldVehicleMileage;

    /** 以旧换新 - 新车车型名称 */
    private String newVehicleModel;

    /** 以旧换新 - 新车价格 */
    private BigDecimal newVehiclePrice;

    /** 以旧换新 - 补贴金额 */
    private BigDecimal subsidyAmount;

    // ==================== 充电订单特有 ====================
    /** 充电站名称 */
    private String stationName;

    /** 充电站地址 */
    private String stationAddress;

    /** 充电量(kWh) */
    private BigDecimal totalEnergy;

    /** 充电时长（秒） */
    private Integer duration;

    /** 充电时长文字 */
    private String durationText;

    /** 获得碳积分 */
    private Integer carbonEarned;

    /** 充电开始时间 */
    private String startTime;

    /** 充电结束时间 */
    private String endTime;

    // ==================== 维保订单特有 ====================
    /** 服务项目 */
    private String serviceItem;

    /** 服务价格 */
    private BigDecimal servicePrice;

    /** 期望日期 */
    private String expectDate;

    /** 期望时段 am/pm */
    private String expectTimeSlot;

    /** 门店地址 */
    private String shopAddress;

    // ==================== Getters / Setters ====================

    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }

    public String getOrderNo() { return orderNo; }
    public void setOrderNo(String orderNo) { this.orderNo = orderNo; }

    public String getBizType() { return bizType; }
    public void setBizType(String bizType) { this.bizType = bizType; }

    public String getBizTypeLabel() { return bizTypeLabel; }
    public void setBizTypeLabel(String bizTypeLabel) { this.bizTypeLabel = bizTypeLabel; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getStatusText() { return statusText; }
    public void setStatusText(String statusText) { this.statusText = statusText; }

    public String getShopName() { return shopName; }
    public void setShopName(String shopName) { this.shopName = shopName; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public BigDecimal getPaidAmount() { return paidAmount; }
    public void setPaidAmount(BigDecimal paidAmount) { this.paidAmount = paidAmount; }

    public String getCreateTime() { return createTime; }
    public void setCreateTime(String createTime) { this.createTime = createTime; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDesc() { return desc; }
    public void setDesc(String desc) { this.desc = desc; }

    public String getUnifiedType() { return unifiedType; }
    public void setUnifiedType(String unifiedType) { this.unifiedType = unifiedType; }

    public String getContactName() { return contactName; }
    public void setContactName(String contactName) { this.contactName = contactName; }

    public String getContactPhone() { return contactPhone; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }

    public Long getVehicleId() { return vehicleId; }
    public void setVehicleId(Long vehicleId) { this.vehicleId = vehicleId; }

    public BigDecimal getVehiclePrice() { return vehiclePrice; }
    public void setVehiclePrice(BigDecimal vehiclePrice) { this.vehiclePrice = vehiclePrice; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public BigDecimal getOldValuation() { return oldValuation; }
    public void setOldValuation(BigDecimal oldValuation) { this.oldValuation = oldValuation; }

    public String getOldVehicleBrand() { return oldVehicleBrand; }
    public void setOldVehicleBrand(String oldVehicleBrand) { this.oldVehicleBrand = oldVehicleBrand; }

    public String getOldVehicleModel() { return oldVehicleModel; }
    public void setOldVehicleModel(String oldVehicleModel) { this.oldVehicleModel = oldVehicleModel; }

    public String getOldVehicleYear() { return oldVehicleYear; }
    public void setOldVehicleYear(String oldVehicleYear) { this.oldVehicleYear = oldVehicleYear; }

    public String getOldVehicleMileage() { return oldVehicleMileage; }
    public void setOldVehicleMileage(String oldVehicleMileage) { this.oldVehicleMileage = oldVehicleMileage; }

    public String getNewVehicleModel() { return newVehicleModel; }
    public void setNewVehicleModel(String newVehicleModel) { this.newVehicleModel = newVehicleModel; }

    public BigDecimal getNewVehiclePrice() { return newVehiclePrice; }
    public void setNewVehiclePrice(BigDecimal newVehiclePrice) { this.newVehiclePrice = newVehiclePrice; }

    public BigDecimal getSubsidyAmount() { return subsidyAmount; }
    public void setSubsidyAmount(BigDecimal subsidyAmount) { this.subsidyAmount = subsidyAmount; }

    public String getStationName() { return stationName; }
    public void setStationName(String stationName) { this.stationName = stationName; }

    public String getStationAddress() { return stationAddress; }
    public void setStationAddress(String stationAddress) { this.stationAddress = stationAddress; }

    public BigDecimal getTotalEnergy() { return totalEnergy; }
    public void setTotalEnergy(BigDecimal totalEnergy) { this.totalEnergy = totalEnergy; }

    public Integer getDuration() { return duration; }
    public void setDuration(Integer duration) { this.duration = duration; }

    public String getDurationText() { return durationText; }
    public void setDurationText(String durationText) { this.durationText = durationText; }

    public Integer getCarbonEarned() { return carbonEarned; }
    public void setCarbonEarned(Integer carbonEarned) { this.carbonEarned = carbonEarned; }

    public String getStartTime() { return startTime; }
    public void setStartTime(String startTime) { this.startTime = startTime; }

    public String getEndTime() { return endTime; }
    public void setEndTime(String endTime) { this.endTime = endTime; }

    public String getServiceItem() { return serviceItem; }
    public void setServiceItem(String serviceItem) { this.serviceItem = serviceItem; }

    public BigDecimal getServicePrice() { return servicePrice; }
    public void setServicePrice(BigDecimal servicePrice) { this.servicePrice = servicePrice; }

    public String getExpectDate() { return expectDate; }
    public void setExpectDate(String expectDate) { this.expectDate = expectDate; }

    public String getExpectTimeSlot() { return expectTimeSlot; }
    public void setExpectTimeSlot(String expectTimeSlot) { this.expectTimeSlot = expectTimeSlot; }

    public String getShopAddress() { return shopAddress; }
    public void setShopAddress(String shopAddress) { this.shopAddress = shopAddress; }
}