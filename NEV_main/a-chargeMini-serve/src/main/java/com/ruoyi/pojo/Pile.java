package com.ruoyi.pojo;

import lombok.Data;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 充电桩表（独立状态监控 实时心跳）
 */
@Data
public class Pile {
    private Long pileId;
    private Long stationId;
    private String pileCode;
    private String pileType;
    private String accessType;
    private BigDecimal powerKw;
    private String connectorType;
    private String pileStatus;
    private String currentOrderNo;
    private String currentUserName;
    private Date currentStartTime;
    private Date lastHeartbeat;
    private BigDecimal voltage;
    private BigDecimal currentA;
    private BigDecimal powerNow;
    private BigDecimal energyTotal;
    private Integer sortOrder;
    private Date createTime;
    private Date updateTime;
}