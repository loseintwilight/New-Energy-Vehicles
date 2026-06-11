package com.ruoyi.charging.domain;

import java.util.Date;

/**
 * 充电桩表 stad_charging_pile
 *
 * @author ruoyi
 */
public class ChargingPile
{
    private static final long serialVersionUID = 1L;

    private Long pileId;
    private Long stationId;
    private String pileCode;
    private String pileType;
    private String accessType;
    private java.math.BigDecimal powerKw;
    private String connectorType;
    private String pileStatus;
    private String currentOrderNo;
    private String currentUserName;
    private java.util.Date currentStartTime;
    private java.util.Date lastHeartbeat;
    private java.math.BigDecimal voltage;
    private java.math.BigDecimal currentA;
    private java.math.BigDecimal powerNow;
    private java.math.BigDecimal energyTotal;
    private Integer sortOrder;
    /** 创建时间 */
    private Date createTime;
    /** 更新时间 */
    private Date updateTime;

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

    public java.math.BigDecimal getPowerKw() { return powerKw; }
    public void setPowerKw(java.math.BigDecimal powerKw) { this.powerKw = powerKw; }

    public String getConnectorType() { return connectorType; }
    public void setConnectorType(String connectorType) { this.connectorType = connectorType; }

    public String getPileStatus() { return pileStatus; }
    public void setPileStatus(String pileStatus) { this.pileStatus = pileStatus; }

    public String getCurrentOrderNo() { return currentOrderNo; }
    public void setCurrentOrderNo(String currentOrderNo) { this.currentOrderNo = currentOrderNo; }

    public String getCurrentUserName() { return currentUserName; }
    public void setCurrentUserName(String currentUserName) { this.currentUserName = currentUserName; }

    public java.util.Date getCurrentStartTime() { return currentStartTime; }
    public void setCurrentStartTime(java.util.Date currentStartTime) { this.currentStartTime = currentStartTime; }

    public java.util.Date getLastHeartbeat() { return lastHeartbeat; }
    public void setLastHeartbeat(java.util.Date lastHeartbeat) { this.lastHeartbeat = lastHeartbeat; }

    public java.math.BigDecimal getVoltage() { return voltage; }
    public void setVoltage(java.math.BigDecimal voltage) { this.voltage = voltage; }

    public java.math.BigDecimal getCurrentA() { return currentA; }
    public void setCurrentA(java.math.BigDecimal currentA) { this.currentA = currentA; }

    public java.math.BigDecimal getPowerNow() { return powerNow; }
    public void setPowerNow(java.math.BigDecimal powerNow) { this.powerNow = powerNow; }

    public java.math.BigDecimal getEnergyTotal() { return energyTotal; }
    public void setEnergyTotal(java.math.BigDecimal energyTotal) { this.energyTotal = energyTotal; }

    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }

    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }

    public Date getUpdateTime() { return updateTime; }
    public void setUpdateTime(Date updateTime) { this.updateTime = updateTime; }
}
