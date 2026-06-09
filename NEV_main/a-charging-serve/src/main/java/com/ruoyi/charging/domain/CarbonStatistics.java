package com.ruoyi.charging.domain;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * 碳排放统计对象 stad_carbon_statistics
 *
 * @author ruoyi
 */
public class CarbonStatistics extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 统计ID */
    private Long statId;

    /** 统计日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date statDate;

    /** 城市 */
    private String city;

    /** 区县 */
    private String district;

    /** 总充电站数 */
    private Integer totalChargeStations;

    /** 总充电桩数 */
    private Integer totalChargePiles;

    /** 总充电订单数 */
    private Integer totalChargeOrders;

    /** 总充电量(度) */
    private BigDecimal totalEnergy;

    /** 碳减排量(kg) */
    private BigDecimal carbonReduction;

    /** 相当于植树数量 */
    private Integer equivalentTrees;

    /** 新能源车总数 */
    private Integer totalNevCount;

    /** 新增新能源车数 */
    private Integer newNevCount;

    /** 总发放积分 */
    private Integer totalPointsIssued;

    /** 总兑换积分 */
    private Integer totalPointsRedeemed;

    /** 统计数据(JSON) */
    private String statData;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    public Long getStatId() {
        return statId;
    }

    public void setStatId(Long statId) {
        this.statId = statId;
    }

    public Date getStatDate() {
        return statDate;
    }

    public void setStatDate(Date statDate) {
        this.statDate = statDate;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public Integer getTotalChargeStations() {
        return totalChargeStations;
    }

    public void setTotalChargeStations(Integer totalChargeStations) {
        this.totalChargeStations = totalChargeStations;
    }

    public Integer getTotalChargePiles() {
        return totalChargePiles;
    }

    public void setTotalChargePiles(Integer totalChargePiles) {
        this.totalChargePiles = totalChargePiles;
    }

    public Integer getTotalChargeOrders() {
        return totalChargeOrders;
    }

    public void setTotalChargeOrders(Integer totalChargeOrders) {
        this.totalChargeOrders = totalChargeOrders;
    }

    public BigDecimal getTotalEnergy() {
        return totalEnergy;
    }

    public void setTotalEnergy(BigDecimal totalEnergy) {
        this.totalEnergy = totalEnergy;
    }

    public BigDecimal getCarbonReduction() {
        return carbonReduction;
    }

    public void setCarbonReduction(BigDecimal carbonReduction) {
        this.carbonReduction = carbonReduction;
    }

    public Integer getEquivalentTrees() {
        return equivalentTrees;
    }

    public void setEquivalentTrees(Integer equivalentTrees) {
        this.equivalentTrees = equivalentTrees;
    }

    public Integer getTotalNevCount() {
        return totalNevCount;
    }

    public void setTotalNevCount(Integer totalNevCount) {
        this.totalNevCount = totalNevCount;
    }

    public Integer getNewNevCount() {
        return newNevCount;
    }

    public void setNewNevCount(Integer newNevCount) {
        this.newNevCount = newNevCount;
    }

    public Integer getTotalPointsIssued() {
        return totalPointsIssued;
    }

    public void setTotalPointsIssued(Integer totalPointsIssued) {
        this.totalPointsIssued = totalPointsIssued;
    }

    public Integer getTotalPointsRedeemed() {
        return totalPointsRedeemed;
    }

    public void setTotalPointsRedeemed(Integer totalPointsRedeemed) {
        this.totalPointsRedeemed = totalPointsRedeemed;
    }

    public String getStatData() {
        return statData;
    }

    public void setStatData(String statData) {
        this.statData = statData;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("statId", getStatId())
            .append("statDate", getStatDate())
            .append("city", getCity())
            .append("district", getDistrict())
            .append("totalChargeStations", getTotalChargeStations())
            .append("totalChargePiles", getTotalChargePiles())
            .append("totalChargeOrders", getTotalChargeOrders())
            .append("totalEnergy", getTotalEnergy())
            .append("carbonReduction", getCarbonReduction())
            .append("equivalentTrees", getEquivalentTrees())
            .append("totalNevCount", getTotalNevCount())
            .append("newNevCount", getNewNevCount())
            .append("totalPointsIssued", getTotalPointsIssued())
            .append("totalPointsRedeemed", getTotalPointsRedeemed())
            .append("statData", getStatData())
            .append("createTime", getCreateTime())
            .toString();
    }
}
