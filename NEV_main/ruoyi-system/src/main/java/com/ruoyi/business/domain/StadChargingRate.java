package com.ruoyi.business.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;
import java.util.Date;

public class StadChargingRate extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long rateId;
    private Long stationId;
    private String rateName;
    private String pileType;
    private Integer isActive;
    private Date effectiveFrom;
    private Date effectiveTo;
    private String description;
    private Integer sortOrder;

    public Long getRateId() { return rateId; }
    public void setRateId(Long rateId) { this.rateId = rateId; }
    public Long getStationId() { return stationId; }
    public void setStationId(Long stationId) { this.stationId = stationId; }
    public String getRateName() { return rateName; }
    public void setRateName(String rateName) { this.rateName = rateName; }
    public String getPileType() { return pileType; }
    public void setPileType(String pileType) { this.pileType = pileType; }
    public Integer getIsActive() { return isActive; }
    public void setIsActive(Integer isActive) { this.isActive = isActive; }
    public Date getEffectiveFrom() { return effectiveFrom; }
    public void setEffectiveFrom(Date effectiveFrom) { this.effectiveFrom = effectiveFrom; }
    public Date getEffectiveTo() { return effectiveTo; }
    public void setEffectiveTo(Date effectiveTo) { this.effectiveTo = effectiveTo; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("rateId", getRateId()).append("stationId", getStationId())
                .append("rateName", getRateName()).append("isActive", getIsActive()).toString();
    }
}