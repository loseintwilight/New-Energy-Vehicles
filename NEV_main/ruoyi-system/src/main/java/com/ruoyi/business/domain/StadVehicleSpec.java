package com.ruoyi.business.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;
import java.math.BigDecimal;

public class StadVehicleSpec extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long specId;
    private Long vehicleId;
    private String vehicleName;
    private Integer rangeKm;
    private BigDecimal batteryCapacity;
    private BigDecimal chargeTimeFast;
    private BigDecimal chargeTimeSlow;
    private Integer modelYear;

    public Long getSpecId() { return specId; }
    public void setSpecId(Long specId) { this.specId = specId; }
    public Long getVehicleId() { return vehicleId; }
    public void setVehicleId(Long vehicleId) { this.vehicleId = vehicleId; }
    public String getVehicleName() { return vehicleName; }
    public void setVehicleName(String vehicleName) { this.vehicleName = vehicleName; }
    public Integer getRangeKm() { return rangeKm; }
    public void setRangeKm(Integer rangeKm) { this.rangeKm = rangeKm; }
    public BigDecimal getBatteryCapacity() { return batteryCapacity; }
    public void setBatteryCapacity(BigDecimal batteryCapacity) { this.batteryCapacity = batteryCapacity; }
    public BigDecimal getChargeTimeFast() { return chargeTimeFast; }
    public void setChargeTimeFast(BigDecimal chargeTimeFast) { this.chargeTimeFast = chargeTimeFast; }
    public BigDecimal getChargeTimeSlow() { return chargeTimeSlow; }
    public void setChargeTimeSlow(BigDecimal chargeTimeSlow) { this.chargeTimeSlow = chargeTimeSlow; }
    public Integer getModelYear() { return modelYear; }
    public void setModelYear(Integer modelYear) { this.modelYear = modelYear; }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("specId", getSpecId()).append("vehicleId", getVehicleId())
                .append("rangeKm", getRangeKm()).append("batteryCapacity", getBatteryCapacity())
                .append("chargeTimeFast", getChargeTimeFast()).append("chargeTimeSlow", getChargeTimeSlow())
                .append("modelYear", getModelYear()).toString();
    }
}