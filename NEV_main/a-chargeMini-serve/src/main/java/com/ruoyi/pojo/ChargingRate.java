package com.ruoyi.pojo;

import lombok.Data;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 充电费率组表（区分快慢充）
 */
@Data
public class ChargingRate {
    private Long rateId;
    private Long stationId;
    private String rateName;
    private String pileType;
    private Boolean isActive;
    private Date effectiveFrom;
    private Date effectiveTo;
    private String description;
    private Integer sortOrder;
    private Date createTime;
    private Date updateTime;
}