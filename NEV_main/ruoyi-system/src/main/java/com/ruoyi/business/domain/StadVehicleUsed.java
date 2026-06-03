package com.ruoyi.business.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;
import java.math.BigDecimal;

public class StadVehicleUsed extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long usedId;
    private Long vehicleId;
    private String vehicleName;
    private Integer licenseYear;
    private Integer licenseMonth;
    private String licenseCity;
    private BigDecimal mileage;
    private Integer transferCount;
    private BigDecimal batterySoh;
    private Integer batteryCycles;
    private String batteryDiagnosis;
    private String batteryReport;
    private BigDecimal valuationPrice;
    private String valuationInfo;

    public Long getUsedId() { return usedId; }
    public void setUsedId(Long usedId) { this.usedId = usedId; }
    public Long getVehicleId() { return vehicleId; }
    public void setVehicleId(Long vehicleId) { this.vehicleId = vehicleId; }
    public String getVehicleName() { return vehicleName; }
    public void setVehicleName(String vehicleName) { this.vehicleName = vehicleName; }
    public Integer getLicenseYear() { return licenseYear; }
    public void setLicenseYear(Integer licenseYear) { this.licenseYear = licenseYear; }
    public Integer getLicenseMonth() { return licenseMonth; }
    public void setLicenseMonth(Integer licenseMonth) { this.licenseMonth = licenseMonth; }
    public String getLicenseCity() { return licenseCity; }
    public void setLicenseCity(String licenseCity) { this.licenseCity = licenseCity; }
    public BigDecimal getMileage() { return mileage; }
    public void setMileage(BigDecimal mileage) { this.mileage = mileage; }
    public Integer getTransferCount() { return transferCount; }
    public void setTransferCount(Integer transferCount) { this.transferCount = transferCount; }
    public BigDecimal getBatterySoh() { return batterySoh; }
    public void setBatterySoh(BigDecimal batterySoh) { this.batterySoh = batterySoh; }
    public Integer getBatteryCycles() { return batteryCycles; }
    public void setBatteryCycles(Integer batteryCycles) { this.batteryCycles = batteryCycles; }
    public String getBatteryDiagnosis() { return batteryDiagnosis; }
    public void setBatteryDiagnosis(String batteryDiagnosis) { this.batteryDiagnosis = batteryDiagnosis; }
    public String getBatteryReport() { return batteryReport; }
    public void setBatteryReport(String batteryReport) { this.batteryReport = batteryReport; }
    public BigDecimal getValuationPrice() { return valuationPrice; }
    public void setValuationPrice(BigDecimal valuationPrice) { this.valuationPrice = valuationPrice; }
    public String getValuationInfo() { return valuationInfo; }
    public void setValuationInfo(String valuationInfo) { this.valuationInfo = valuationInfo; }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("usedId", getUsedId())
                .append("vehicleId", getVehicleId()).append("licenseYear", getLicenseYear())
                .append("mileage", getMileage()).append("batterySoh", getBatterySoh())
                .append("valuationPrice", getValuationPrice()).toString();
    }
}