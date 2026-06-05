package com.ruoyi.vo;

import lombok.Data;
import java.util.Date;

/**
 * 充电订单VO（小程序端）
 */
@Data
public class OrderVO {
    private Long orderId;
    private String orderNo;
    private Long stationId;
    private String stationName;
    private String pileNo;
    private String chargeType;
    private Date startTime;
    private Date endTime;
    private Integer duration;
    private String durationText;
    private Double energy;
    private Double amount;
    private Double electricFee;
    private Double serviceFee;
    private Double discountAmount;
    private String status;
    private String statusText;
    private String payStatus;
    private Date createTime;
    private Date endTimeVal;
}