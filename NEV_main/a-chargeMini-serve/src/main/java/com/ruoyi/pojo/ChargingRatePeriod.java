package com.ruoyi.pojo;

import lombok.Data;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 充电费率时段表（峰谷平时段）
 */
@Data
public class ChargingRatePeriod {
    private Long periodId;
    private Long rateId;
    private String periodName;
    private Date startTime;
    private Date endTime;
    private BigDecimal energyPrice;
    private BigDecimal serviceFee;
    private BigDecimal totalPrice;
    private BigDecimal discountRate;
    private Integer sortOrder;
    private Date createTime;
}