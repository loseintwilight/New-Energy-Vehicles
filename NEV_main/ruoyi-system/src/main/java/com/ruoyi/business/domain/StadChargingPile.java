package com.ruoyi.business.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;
import java.math.BigDecimal;
import java.util.Date;

public class StadChargingPile extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long pileId;
    private Long stationId;
    private String pileCode;
    private String pileType;
    private String accessType;
    private BigDecimal powerKw;
    private String connectorType;
    private String pileStatus;
    private String currentOrderNo;
    private String currentUserName;
    private Date currentStartTime;
    private Date lastHeartbeat;
    private BigDecimal voltage;
    private BigDecimal currentA;
    private BigDecimal powerNow;
    private BigDecimal energyTotal;
    private Integer sortOrder;

    public Long getPileId() { return pileId; }
    public void setPileId(Long pileId) { this.pileId = pileId; }
    public Long getStationId() { return stationId; }
    public void setStationId(Long stationId) { this.stationId = stationId; }
    public String getPileCode() { return pileCode; }
    public void setPileCode(String pileCode) { this.pileCode = pileCode; }
    public String getPileType() { return pileType; }
    public void setPileType(String pileType) { this.pileType = pileType; }
    public String getAccessType() { return accessType; }
    public void setAccessType(String accessType) { this.accessType = accessType; }
    public BigDecimal getPowerKw() { return powerKw; }
    public void setPowerKw(BigDecimal powerKw) { this.powerKw = powerKw; }
    public String getConnectorType() { return connectorType; }
    public void setConnectorType(String connectorType) { this.connectorType = connectorType; }
    public String getPileStatus() { return pileStatus; }
    public void setPileStatus(String pileStatus) { this.pileStatus = pileStatus; }
    public String getCurrentOrderNo() { return currentOrderNo; }
    public void setCurrentOrderNo(String currentOrderNo) { this.currentOrderNo = currentOrderNo; }
    public String getCurrentUserName() { return currentUserName; }
    public void setCurrentUserName(String currentUserName) { this.currentUserName = currentUserName; }
    public Date getCurrentStartTime() { return currentStartTime; }
    public void setCurrentStartTime(Date currentStartTime) { this.currentStartTime = currentStartTime; }
    public Date getLastHeartbeat() { return lastHeartbeat; }
    public void setLastHeartbeat(Date lastHeartbeat) { this.lastHeartbeat = lastHeartbeat; }
    public BigDecimal getVoltage() { return voltage; }
    public void setVoltage(BigDecimal voltage) { this.voltage = voltage; }
    public BigDecimal getCurrentA() { return currentA; }
    public void setCurrentA(BigDecimal currentA) { this.currentA = currentA; }
    public BigDecimal getPowerNow() { return powerNow; }
    public void setPowerNow(BigDecimal powerNow) { this.powerNow = powerNow; }
    public BigDecimal getEnergyTotal() { return energyTotal; }
    public void setEnergyTotal(BigDecimal energyTotal) { this.energyTotal = energyTotal; }
    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("pileId", getPileId()).append("stationId", getStationId())
                .append("pileCode", getPileCode()).append("pileType", getPileType())
                .append("powerKw", getPowerKw()).append("pileStatus", getPileStatus())
                .append("lastHeartbeat", getLastHeartbeat()).toString();
    }
}