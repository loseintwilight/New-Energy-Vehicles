package com.ruoyi.vo;

import lombok.Data;

/**
 * 开始充电返回VO
 */
@Data
public class StartChargeVO {
    private String orderNo;
    private Double electricPrice;
    private Double servicePrice;
    private Double totalPrice;
}
