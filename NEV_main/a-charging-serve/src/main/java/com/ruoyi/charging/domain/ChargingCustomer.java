package com.ruoyi.charging.domain;

import java.util.Date;
import java.math.BigDecimal;

/**
 * 充电客户表 stad_charging_customer
 *
 * @author ruoyi
 */
public class ChargingCustomer
{
    private static final long serialVersionUID = 1L;

    /** 客户ID */
    private Long customerId;
    /** 客户姓名 */
    private String customerName;
    /** 手机号 */
    private String phone;
    /** 车型 */
    private String carModel;
    /** 车牌号 */
    private String carPlate;
    /** 等级（普通/VIP） */
    private String level;
    /** 累计消费金额 */
    private BigDecimal totalAmount;
    /** 订单数 */
    private Integer orderCount;
    /** 商户ID */
    private Long merchantId;
    /** 备注 */
    private String remark;
    /** 状态（0正常1停用） */
    private String status;
    /** 创建时间 */
    private Date createTime;
    /** 更新时间 */
    private Date updateTime;

    public Long getCustomerId() { return customerId; }
    public void setCustomerId(Long customerId) { this.customerId = customerId; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getCarModel() { return carModel; }
    public void setCarModel(String carModel) { this.carModel = carModel; }

    public String getCarPlate() { return carPlate; }
    public void setCarPlate(String carPlate) { this.carPlate = carPlate; }

    public String getLevel() { return level; }
    public void setLevel(String level) { this.level = level; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public Integer getOrderCount() { return orderCount; }
    public void setOrderCount(Integer orderCount) { this.orderCount = orderCount; }

    public Long getMerchantId() { return merchantId; }
    public void setMerchantId(Long merchantId) { this.merchantId = merchantId; }

    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }

    public Date getUpdateTime() { return updateTime; }
    public void setUpdateTime(Date updateTime) { this.updateTime = updateTime; }
}
