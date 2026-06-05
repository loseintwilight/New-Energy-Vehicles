package com.ruoyi.pojo;

import lombok.Data;
import java.util.Date;

/**
 * 用户反馈表
 */
@Data
public class UserFeedback {
    private Long feedbackId;
    private Long userId;
    private String content;
    private String images;
    private String contact;
    private String reply;
    private Date replyTime;
    private String status;
    private Date createTime;
}