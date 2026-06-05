package com.ruoyi.pojo;

import lombok.Data;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 充电订单表（含费率时段记录）
 */
@Data
public class Order {
    private Long orderId;
    private String orderNo;
    private Long userId;
    private Long stationId;
    private Long pileId;
    private String pileCode;
    private Long rateId;
    private Long ratePeriodId;
    private Date startTime;
    private Date endTime;
    private Integer duration;
    private BigDecimal startSoc;
    private BigDecimal endSoc;
    private BigDecimal totalEnergy;
    private BigDecimal energyPrice;
    private BigDecimal servicePrice;
    private BigDecimal discountAmount;
    private BigDecimal totalAmount;
    private String rateDetail;
    private String orderStatus;
    private String payStatus;
    private String paymentMethod;
    private String transactionId;
    private Integer carbonEarned;
    private Date createTime;
    private Date updateTime;
}