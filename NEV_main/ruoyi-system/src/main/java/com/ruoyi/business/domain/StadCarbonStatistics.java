package com.ruoyi.business.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;
import java.math.BigDecimal;
import java.util.Date;

public class StadCarbonStatistics extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long statId;
    private Date statDate;
    private String city;
    private String district;
    private Long totalChargeStations;
    private Long totalChargePiles;
    private Long totalChargeOrders;
    private BigDecimal totalEnergy;
    private BigDecimal carbonReduction;
    private Long equivalentTrees;
    private Long totalNevCount;
    private Long newNevCount;
    private Long totalPointsIssued;
    private Long totalPointsRedeemed;
    private String statData;

    public Long getStatId() { return statId; }
    public void setStatId(Long statId) { this.statId = statId; }
    public Date getStatDate() { return statDate; }
    public void setStatDate(Date statDate) { this.statDate = statDate; }
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }
    public Long getTotalChargeStations() { return totalChargeStations; }
    public void setTotalChargeStations(Long totalChargeStations) { this.totalChargeStations = totalChargeStations; }
    public Long getTotalChargePiles() { return totalChargePiles; }
    public void setTotalChargePiles(Long totalChargePiles) { this.totalChargePiles = totalChargePiles; }
    public Long getTotalChargeOrders() { return totalChargeOrders; }
    public void setTotalChargeOrders(Long totalChargeOrders) { this.totalChargeOrders = totalChargeOrders; }
    public BigDecimal getTotalEnergy() { return totalEnergy; }
    public void setTotalEnergy(BigDecimal totalEnergy) { this.totalEnergy = totalEnergy; }
    public BigDecimal getCarbonReduction() { return carbonReduction; }
    public void setCarbonReduction(BigDecimal carbonReduction) { this.carbonReduction = carbonReduction; }
    public Long getEquivalentTrees() { return equivalentTrees; }
    public void setEquivalentTrees(Long equivalentTrees) { this.equivalentTrees = equivalentTrees; }
    public Long getTotalNevCount() { return totalNevCount; }
    public void setTotalNevCount(Long totalNevCount) { this.totalNevCount = totalNevCount; }
    public Long getNewNevCount() { return newNevCount; }
    public void setNewNevCount(Long newNevCount) { this.newNevCount = newNevCount; }
    public Long getTotalPointsIssued() { return totalPointsIssued; }
    public void setTotalPointsIssued(Long totalPointsIssued) { this.totalPointsIssued = totalPointsIssued; }
    public Long getTotalPointsRedeemed() { return totalPointsRedeemed; }
    public void setTotalPointsRedeemed(Long totalPointsRedeemed) { this.totalPointsRedeemed = totalPointsRedeemed; }
    public String getStatData() { return statData; }
    public void setStatData(String statData) { this.statData = statData; }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("statId", getStatId()).append("statDate", getStatDate())
                .append("city", getCity()).append("district", getDistrict())
                .append("totalEnergy", getTotalEnergy()).append("carbonReduction", getCarbonReduction())
                .append("totalNevCount", getTotalNevCount()).toString();
    }
}