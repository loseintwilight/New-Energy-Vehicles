package com.ruoyi.charging.domain;

import java.util.Date;

/**
 * 充电结算表 stad_charging_settlement
 *
 * @author ruoyi
 */
public class ChargingSettlement
{
    private static final long serialVersionUID = 1L;

    private Long settlementId;
    private Long merchantId;
    private java.util.Date settleDate;
    private Integer totalOrders;
    private java.math.BigDecimal totalEnergy;
    private java.math.BigDecimal totalAmount;
    private java.math.BigDecimal platformCommission;
    private java.math.BigDecimal settleAmount;
    private String status;
    private java.util.Date settleTime;
    private String withdrawNo;
    private java.math.BigDecimal withdrawAmount;
    private String withdrawStatus;
    private java.util.Date withdrawTime;
    /** 创建时间 */
    private Date createTime;
    /** 更新时间 */
    private Date updateTime;

    public Long getSettlementId() { return settlementId; }
    public void setSettlementId(Long settlementId) { this.settlementId = settlementId; }

    public Long getMerchantId() { return merchantId; }
    public void setMerchantId(Long merchantId) { this.merchantId = merchantId; }

    public java.util.Date getSettleDate() { return settleDate; }
    public void setSettleDate(java.util.Date settleDate) { this.settleDate = settleDate; }

    public Integer getTotalOrders() { return totalOrders; }
    public void setTotalOrders(Integer totalOrders) { this.totalOrders = totalOrders; }

    public java.math.BigDecimal getTotalEnergy() { return totalEnergy; }
    public void setTotalEnergy(java.math.BigDecimal totalEnergy) { this.totalEnergy = totalEnergy; }

    public java.math.BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(java.math.BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public java.math.BigDecimal getPlatformCommission() { return platformCommission; }
    public void setPlatformCommission(java.math.BigDecimal platformCommission) { this.platformCommission = platformCommission; }

    public java.math.BigDecimal getSettleAmount() { return settleAmount; }
    public void setSettleAmount(java.math.BigDecimal settleAmount) { this.settleAmount = settleAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public java.util.Date getSettleTime() { return settleTime; }
    public void setSettleTime(java.util.Date settleTime) { this.settleTime = settleTime; }

    public String getWithdrawNo() { return withdrawNo; }
    public void setWithdrawNo(String withdrawNo) { this.withdrawNo = withdrawNo; }

    public java.math.BigDecimal getWithdrawAmount() { return withdrawAmount; }
    public void setWithdrawAmount(java.math.BigDecimal withdrawAmount) { this.withdrawAmount = withdrawAmount; }

    public String getWithdrawStatus() { return withdrawStatus; }
    public void setWithdrawStatus(String withdrawStatus) { this.withdrawStatus = withdrawStatus; }

    public java.util.Date getWithdrawTime() { return withdrawTime; }
    public void setWithdrawTime(java.util.Date withdrawTime) { this.withdrawTime = withdrawTime; }

    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }

    public Date getUpdateTime() { return updateTime; }
    public void setUpdateTime(Date updateTime) { this.updateTime = updateTime; }
}
