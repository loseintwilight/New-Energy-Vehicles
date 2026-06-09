package com.ruoyi.domain;

import lombok.Data;

import java.math.BigDecimal;

/**
 * @Classname MaintainShop
 * @Description
 * @Date 2026/6/8 19:53
 * @Created by 高合吴彦祖鹏哥
 */
@Data
public class MaintainShop {
    private Long shopId;
    private String shopName;
    private Long merchantId;
    private String province;
    private String city;
    private String district;
    private String address;
    private BigDecimal longitude;
    private BigDecimal latitude;
    private String contactName;
    private String contactPhone;
    private String servicesInfo;
    private BigDecimal rating;
    private String description;
    private Integer status;

    private String merchantName;
}