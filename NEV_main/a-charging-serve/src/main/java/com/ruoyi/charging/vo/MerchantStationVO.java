package com.ruoyi.charging.vo;

import lombok.Data;
import java.math.BigDecimal;

/**
 * 商户充电站工作台VO - 含今日统计数据
 */
@Data
public class MerchantStationVO {
    private Long stationId;
    private String stationName;
    private String stationCode;
    private String address;
    private String stationStatus;
    private BigDecimal todayIncome;
    private Integer todayOrders;
    private BigDecimal todayEnergy;
    private Integer totalPiles;
    private Integer availablePiles;
}
