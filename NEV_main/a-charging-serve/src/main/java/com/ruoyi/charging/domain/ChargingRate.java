package com.ruoyi.charging.domain;

import java.util.Date;

/**
 * 充电费率组表 stad_charging_rate
 *
 * @author ruoyi
 */
public class ChargingRate
{
    private static final long serialVersionUID = 1L;

    private Long rateId;
    private Long stationId;
    private String rateName;
    private String pileType;
    private Integer isActive;
    private java.util.Date effectiveFrom;
    private java.util.Date effectiveTo;
    private String description;
    private Integer sortOrder;
    /** 创建时间 */
    private Date createTime;
    /** 更新时间 */
    private Date updateTIme;

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

    public java.util.Date getEffectiveFrom() { return effectiveFrom; }
    public void setEffectiveFrom(java.util.Date effectiveFrom) { this.effectiveFrom = effectiveFrom; }

    public java.util.Date getEffectiveTo() { return effectiveTo; }
    public void setEffectiveTo(java.util.Date effectiveTo) { this.effectiveTo = effectiveTo; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }

    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }

    public Date getUpdateTIme() { return updateTIme; }
    public void setUpdateTIme(Date updateTIme) { this.updateTIme = updateTIme; }
}
