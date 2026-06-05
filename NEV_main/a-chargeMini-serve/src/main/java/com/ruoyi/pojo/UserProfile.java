package com.ruoyi.pojo;

import lombok.Data;
import java.util.Date;

/**
 * 用户扩展表
 */
@Data
public class UserProfile {
    private Long profileId;
    private Long userId;
    private String idCard;
    private Integer totalEarned;
    private Integer totalSpent;
    private Integer balance;
    private Date updateTime;
}