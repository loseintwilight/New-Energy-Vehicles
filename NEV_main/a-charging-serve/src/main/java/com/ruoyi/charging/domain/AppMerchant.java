package com.ruoyi.charging.domain;

import java.util.Date;

/**
 * 商户表 stad_merchant
 *
 * @author ruoyi
 */
public class AppMerchant
{
    private static final long serialVersionUID = 1L;

    private Long merchantId;
    private Long userId;
    private String merchantName;
    private String merchantType;
    private String contactName;
    private String contactPhone;
    private String province;
    private String city;
    private String address;
    private String openTime;
    private String closeTime;
    private String businessLicense;
    private String legalPerson;
    private String idCard;
    private String status;
    private String auditRemark;
    private Date auditTime;
    private java.math.BigDecimal totalIncome;
    private java.math.BigDecimal settledAmount;
    private java.math.BigDecimal pendingAmount;
    private java.math.BigDecimal withdrawnAmount;
    private String bankName;
    private String bankAccount;
    /** 创建时间 */
    private Date createTime;
    /** 更新时间 */
    private Date updateTime;

    public Long getMerchantId() { return merchantId; }
    public void setMerchantId(Long merchantId) { this.merchantId = merchantId; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getMerchantName() { return merchantName; }
    public void setMerchantName(String merchantName) { this.merchantName = merchantName; }

    public String getMerchantType() { return merchantType; }
    public void setMerchantType(String merchantType) { this.merchantType = merchantType; }

    public String getContactName() { return contactName; }
    public void setContactName(String contactName) { this.contactName = contactName; }

    public String getContactPhone() { return contactPhone; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }

    public String getProvince() { return province; }
    public void setProvince(String province) { this.province = province; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getOpenTime() { return openTime; }
    public void setOpenTime(String openTime) { this.openTime = openTime; }

    public String getCloseTime() { return closeTime; }
    public void setCloseTime(String closeTime) { this.closeTime = closeTime; }

    public String getBusinessLicense() { return businessLicense; }
    public void setBusinessLicense(String businessLicense) { this.businessLicense = businessLicense; }

    public String getLegalPerson() { return legalPerson; }
    public void setLegalPerson(String legalPerson) { this.legalPerson = legalPerson; }

    public String getIdCard() { return idCard; }
    public void setIdCard(String idCard) { this.idCard = idCard; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAuditRemark() { return auditRemark; }
    public void setAuditRemark(String auditRemark) { this.auditRemark = auditRemark; }

    public java.util.Date getAuditTime() { return auditTime; }
    public void setAuditTime(java.util.Date auditTime) { this.auditTime = auditTime; }

    public java.math.BigDecimal getTotalIncome() { return totalIncome; }
    public void setTotalIncome(java.math.BigDecimal totalIncome) { this.totalIncome = totalIncome; }

    public java.math.BigDecimal getSettledAmount() { return settledAmount; }
    public void setSettledAmount(java.math.BigDecimal settledAmount) { this.settledAmount = settledAmount; }

    public java.math.BigDecimal getPendingAmount() { return pendingAmount; }
    public void setPendingAmount(java.math.BigDecimal pendingAmount) { this.pendingAmount = pendingAmount; }

    public java.math.BigDecimal getWithdrawnAmount() { return withdrawnAmount; }
    public void setWithdrawnAmount(java.math.BigDecimal withdrawnAmount) { this.withdrawnAmount = withdrawnAmount; }

    public String getBankName() { return bankName; }
    public void setBankName(String bankName) { this.bankName = bankName; }

    public String getBankAccount() { return bankAccount; }
    public void setBankAccount(String bankAccount) { this.bankAccount = bankAccount; }

    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }

    public Date getUpdateTime() { return updateTime; }
    public void setUpdateTime(Date updateTime) { this.updateTime = updateTime; }
}
