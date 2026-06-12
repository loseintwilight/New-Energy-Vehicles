package com.ruoyi.newcar.domain;

import lombok.Data;

import java.util.Date;

@Data
public class NewCar {
    private Long vehicleId;

    private String vehicleType;

    private String modelName;

    private String title;

    private Double guidePrice;

    private Double originalPrice;

    private String color;

    private Integer stock;

    private Long merchantId;

    private String description;

    private String tags;

    private Integer viewCount;

    private String status;

    private String image;

    private Date publishTime;

    private Date createTime;

    private Date updateTime;
}