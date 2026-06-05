package com.ruoyi.pojo;

import lombok.Data;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 充电结算表（含提现）
 */
@Data
public class ChargingSettlement {
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
    private Date createTime;
}