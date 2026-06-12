package com.ruoyi.vo;

import lombok.Data;

/**
 * 停止充电返回VO
 */
@Data
public class StopChargeVO {
    private String orderNo;
    private Integer duration;
    private String durationText;
    private Double energy;
    private Double chargedAmount;
    private Double electricFee;
    private Double serviceFee;
    private Double total;
}
