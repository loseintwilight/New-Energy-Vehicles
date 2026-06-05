package com.ruoyi.pojo;

import lombok.Data;
import java.util.Date;

/**
 * 碳积分流水账（来源可追溯）
 */
@Data
public class CarbonLedger {
    private Long ledgerId;
    private Long userId;
    private Integer recordType;
    private Long ruleId;
    private Integer points;
    private Integer balanceAfter;
    private Integer sourceType;
    private Long sourceId;
    private String remark;
    private Date createTime;
}