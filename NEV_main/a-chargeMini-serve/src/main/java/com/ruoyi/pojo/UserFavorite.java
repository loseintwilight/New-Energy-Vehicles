package com.ruoyi.pojo;

import lombok.Data;
import java.util.Date;

/**
 * 用户收藏表
 */
@Data
public class UserFavorite {
    private Long favoriteId;
    private Long userId;
    private String targetType;
    private Long targetId;
    private Date createTime;
}