package com.ruoyi.pojo;

import lombok.Data;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 碳排放 充电统计表（政府大屏数据）
 */
@Data
public class CarbonStatistics {
    private Long statId;
    private Date statDate;
    private String city;
    private String district;
    private Integer totalChargeStations;
    private Integer totalChargePiles;
    private Integer totalChargeOrders;
    private BigDecimal totalEnergy;
    private BigDecimal carbonReduction;
    private Integer equivalentTrees;
    private Integer totalNevCount;
    private Integer newNevCount;
    private Integer totalPointsIssued;
    private Integer totalPointsRedeemed;
    private String statData;
    private Date createTime;
}