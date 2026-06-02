package com.ruoyi.business.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;
import java.math.BigDecimal;
import java.util.Date;

public class StadChargingSettlement extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long settlementId;
    private Long merchantId;
    private Date settleDate;
    private Integer totalOrders;
    private BigDecimal totalEnergy;
    private BigDecimal totalAmount;
    private BigDecimal platformCommission;
    private BigDecimal settleAmount;
    private String status;
    private Date settleTime;
    private String withdrawNo;
    private BigDecimal withdrawAmount;
    private String withdrawStatus;
    private Date withdrawTime;

    public Long getSettlementId() { return settlementId; }
    public void setSettlementId(Long settlementId) { this.settlementId = settlementId; }
    public Long getMerchantId() { return merchantId; }
    public void setMerchantId(Long merchantId) { this.merchantId = merchantId; }
    public Date getSettleDate() { return settleDate; }
    public void setSettleDate(Date settleDate) { this.settleDate = settleDate; }
    public Integer getTotalOrders() { return totalOrders; }
    public void setTotalOrders(Integer totalOrders) { this.totalOrders = totalOrders; }
    public BigDecimal getTotalEnergy() { return totalEnergy; }
    public void setTotalEnergy(BigDecimal totalEnergy) { this.totalEnergy = totalEnergy; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public BigDecimal getPlatformCommission() { return platformCommission; }
    public void setPlatformCommission(BigDecimal platformCommission) { this.platformCommission = platformCommission; }
    public BigDecimal getSettleAmount() { return settleAmount; }
    public void setSettleAmount(BigDecimal settleAmount) { this.settleAmount = settleAmount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Date getSettleTime() { return settleTime; }
    public void setSettleTime(Date settleTime) { this.settleTime = settleTime; }
    public String getWithdrawNo() { return withdrawNo; }
    public void setWithdrawNo(String withdrawNo) { this.withdrawNo = withdrawNo; }
    public BigDecimal getWithdrawAmount() { return withdrawAmount; }
    public void setWithdrawAmount(BigDecimal withdrawAmount) { this.withdrawAmount = withdrawAmount; }
    public String getWithdrawStatus() { return withdrawStatus; }
    public void setWithdrawStatus(String withdrawStatus) { this.withdrawStatus = withdrawStatus; }
    public Date getWithdrawTime() { return withdrawTime; }
    public void setWithdrawTime(Date withdrawTime) { this.withdrawTime = withdrawTime; }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("settlementId", getSettlementId()).append("merchantId", getMerchantId())
                .append("settleDate", getSettleDate()).append("settleAmount", getSettleAmount())
                .append("status", getStatus()).toString();
    }
}