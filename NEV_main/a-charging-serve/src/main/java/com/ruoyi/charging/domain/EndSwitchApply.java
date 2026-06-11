package com.ruoyi.charging.domain;

import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 端切换申请表 stad_end_switch_apply
 * 
 * @author ruoyi
 */
public class EndSwitchApply extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long applyId;
    private Long userId;
    private String username;
    private String endType;
    private String endName;
    private String formData;
    private String auditStatus;
    private String auditRemark;

    public Long getApplyId() { return applyId; }
    public void setApplyId(Long applyId) { this.applyId = applyId; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEndType() { return endType; }
    public void setEndType(String endType) { this.endType = endType; }

    public String getEndName() { return endName; }
    public void setEndName(String endName) { this.endName = endName; }

    public String getFormData() { return formData; }
    public void setFormData(String formData) { this.formData = formData; }

    public String getAuditStatus() { return auditStatus; }
    public void setAuditStatus(String auditStatus) { this.auditStatus = auditStatus; }

    public String getAuditRemark() { return auditRemark; }
    public void setAuditRemark(String auditRemark) { this.auditRemark = auditRemark; }
}
