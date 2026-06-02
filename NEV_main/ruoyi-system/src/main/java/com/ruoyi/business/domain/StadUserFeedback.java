package com.ruoyi.business.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;

public class StadUserFeedback extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long feedbackId;
    private Long userId;
    private String content;
    private String images;
    private String contact;
    private String reply;
    private String status;

    public Long getFeedbackId() { return feedbackId; }
    public void setFeedbackId(Long feedbackId) { this.feedbackId = feedbackId; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getImages() { return images; }
    public void setImages(String images) { this.images = images; }

    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }

    public String getReply() { return reply; }
    public void setReply(String reply) { this.reply = reply; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("feedbackId", getFeedbackId())
                .append("userId", getUserId())
                .append("content", getContent())
                .append("images", getImages())
                .append("contact", getContact())
                .append("reply", getReply())
                .append("status", getStatus())
                .append("createTime", getCreateTime())
                .toString();
    }
}