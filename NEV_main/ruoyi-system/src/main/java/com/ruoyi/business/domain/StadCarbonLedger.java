package com.ruoyi.business.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;

public class StadCarbonLedger extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long ledgerId;
    private Long userId;
    private Integer recordType;
    private Long ruleId;
    private Integer points;
    private Integer balanceAfter;
    private Integer sourceType;
    private Long sourceId;
    private String remark;

    public Long getLedgerId() { return ledgerId; }
    public void setLedgerId(Long ledgerId) { this.ledgerId = ledgerId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public Integer getRecordType() { return recordType; }
    public void setRecordType(Integer recordType) { this.recordType = recordType; }
    public Long getRuleId() { return ruleId; }
    public void setRuleId(Long ruleId) { this.ruleId = ruleId; }
    public Integer getPoints() { return points; }
    public void setPoints(Integer points) { this.points = points; }
    public Integer getBalanceAfter() { return balanceAfter; }
    public void setBalanceAfter(Integer balanceAfter) { this.balanceAfter = balanceAfter; }
    public Integer getSourceType() { return sourceType; }
    public void setSourceType(Integer sourceType) { this.sourceType = sourceType; }
    public Long getSourceId() { return sourceId; }
    public void setSourceId(Long sourceId) { this.sourceId = sourceId; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("ledgerId", getLedgerId()).append("userId", getUserId())
                .append("recordType", getRecordType()).append("points", getPoints())
                .append("balanceAfter", getBalanceAfter()).append("sourceType", getSourceType())
                .append("createTime", getCreateTime()).toString();
    }
}