package com.ruoyi.charging.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * 碳积分流水对象 stad_carbon_ledger
 *
 * @author ruoyi
 */
public class CarbonLedger extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 流水ID */
    private Long ledgerId;

    /** 用户ID */
    private Long userId;

    /** 记录类型（0获得 1消耗） */
    private Integer recordType;

    /** 规则ID */
    private Long ruleId;

    /** 积分变动数量 */
    private Integer points;

    /** 变动后余额 */
    private Integer balanceAfter;

    /** 来源类型（1充电订单 2签到 3兑换 4管理员操作） */
    private Integer sourceType;

    /** 来源ID */
    private Long sourceId;

    /** 备注 */
    private String remark;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    public Long getLedgerId() {
        return ledgerId;
    }

    public void setLedgerId(Long ledgerId) {
        this.ledgerId = ledgerId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Integer getRecordType() {
        return recordType;
    }

    public void setRecordType(Integer recordType) {
        this.recordType = recordType;
    }

    public Long getRuleId() {
        return ruleId;
    }

    public void setRuleId(Long ruleId) {
        this.ruleId = ruleId;
    }

    public Integer getPoints() {
        return points;
    }

    public void setPoints(Integer points) {
        this.points = points;
    }

    public Integer getBalanceAfter() {
        return balanceAfter;
    }

    public void setBalanceAfter(Integer balanceAfter) {
        this.balanceAfter = balanceAfter;
    }

    public Integer getSourceType() {
        return sourceType;
    }

    public void setSourceType(Integer sourceType) {
        this.sourceType = sourceType;
    }

    public Long getSourceId() {
        return sourceId;
    }

    public void setSourceId(Long sourceId) {
        this.sourceId = sourceId;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("ledgerId", getLedgerId())
            .append("userId", getUserId())
            .append("recordType", getRecordType())
            .append("ruleId", getRuleId())
            .append("points", getPoints())
            .append("balanceAfter", getBalanceAfter())
            .append("sourceType", getSourceType())
            .append("sourceId", getSourceId())
            .append("remark", getRemark())
            .append("createTime", getCreateTime())
            .toString();
    }
}
