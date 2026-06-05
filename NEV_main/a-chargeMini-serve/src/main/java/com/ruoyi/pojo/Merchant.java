package com.ruoyi.pojo;

import lombok.Data;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 商户表
 */
@Data
public class Merchant {
    private Long merchantId;
    private Long userId;
    private String merchantName;
    private String merchantType;
    private String contactName;
    private String contactPhone;
    private String province;
    private String city;
    private String address;
    private Date openTime;
    private Date closeTime;
    private String businessLicense;
    private String legalPerson;
    private String idCard;
    private String status;
    private String auditRemark;
    private Date auditTime;
    private BigDecimal totalIncome;
    private BigDecimal settledAmount;
    private BigDecimal pendingAmount;
    private BigDecimal withdrawnAmount;
    private String bankName;
    private String bankAccount;
    private Date createTime;
    private Date updateTime;
}