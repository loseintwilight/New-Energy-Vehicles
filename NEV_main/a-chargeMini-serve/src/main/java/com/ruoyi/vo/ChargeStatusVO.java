package com.ruoyi.vo;

import lombok.Data;

/**
 * 充电状态VO（小程序端实时充电状态）
 */
@Data
public class ChargeStatusVO {
    private String orderId;
    private String status;
    private String orderNo;
    private String stationName;
    private String pileNo;
    private String chargeType;
    private java.util.Date startTime;
    private java.util.Date endTime;

    // 充电进度
    private Integer chargePercent;
    private String chargedTime;
    private String chargedEnergy;
    private String chargedAmount;
    private String electricFee;
    private String serviceFee;
    private String totalEstimate;
}
