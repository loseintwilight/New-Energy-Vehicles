package com.ruoyi.domain;

import lombok.Data;

import java.util.Date;

/**
 * @Description: 数据
 * @Author: 刘文丽
 * @CreateTime: 2026-06-04 18:47
 */

@Data
public class VehicleReviews {
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
    private String nickName;
    private String vehicleName;
}