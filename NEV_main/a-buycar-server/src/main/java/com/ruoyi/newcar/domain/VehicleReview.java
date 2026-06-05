package com.ruoyi.newcar.domain;

import lombok.Data;

import java.util.Date;

@Data
public class VehicleReview {
    private Long reviewId;

    private Long vehicleId;

    private Long userId;

    private Long orderId;

    private Integer rating;

    private String content;

    private String imageUrl;

    private Integer isAnonymous;

    private String status;

    private Date createTime;
}