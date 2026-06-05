package com.ruoyi.vo;

import lombok.Data;

/**
 * 费率时段VO
 */
@Data
public class RateVO {
    private Long rateId;
    private String rateName;
    private String pileType;
    private Long periodId;
    private String periodName;
    private String startTime;
    private String endTime;
    private Double electricPrice;
    private Double servicePrice;
    private Double totalPrice;
}