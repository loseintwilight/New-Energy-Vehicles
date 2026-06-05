package com.ruoyi.vo;

import lombok.Data;
import java.util.Date;

/**
 * 充电桩VO（小程序端）
 */
@Data
public class PileVO {
    private Long pileId;
    private String pileCode;
    private String pileType;
    private Double powerKw;
    private String connectorType;
    private String pileStatus;
    private String statusText;
    private Double voltage;
    private Double current;
    private Double powerNow;
    private Date lastHeartbeat;
    private Integer sortOrder;
}