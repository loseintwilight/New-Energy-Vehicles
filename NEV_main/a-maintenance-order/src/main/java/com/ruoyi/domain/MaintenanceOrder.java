package com.ruoyi.domain;

import com.ruoyi.common.annotation.DataSource;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

/**
 * @Classname MaintenanceOrder
 * @Description
 * @Date 2026/6/8 19:50
 * @Created by 高合吴彦祖鹏哥
 */
@Data
public class MaintenanceOrder {
    private Long orderId;
    private String orderNo;
    private Long userId;
    private Long shopId;
    private Long vehicleId;
    private String serviceItem;
    private BigDecimal servicePrice;
    private BigDecimal totalAmount;
    private BigDecimal paidAmount;
    private Date expectDate;
    private String expectTimeSlot;
    private String orderStatus;
    private String cancelReason;
    private Date finishTime;
    private BigDecimal rating;
    private String commentContent;
    private String payStatus;
    private String paymentMethod;

    private String shopName;
    private String nickName;
}