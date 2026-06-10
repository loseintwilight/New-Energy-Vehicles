package com.ruoyi.business.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

public class StadGovNevRegistration extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long regId;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date statDate;
    private String city;
    private String district;
    private Long newRegistrations;
    private Long totalVehicles;
    private Long evCount;
    private Long phevCount;
    private Long fcevCount;
    private String dataSource;

    public Long getRegId() { return regId; }
    public void setRegId(Long regId) { this.regId = regId; }
    public Date getStatDate() { return statDate; }
    public void setStatDate(Date statDate) { this.statDate = statDate; }
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }
    public Long getNewRegistrations() { return newRegistrations; }
    public void setNewRegistrations(Long newRegistrations) { this.newRegistrations = newRegistrations; }
    public Long getTotalVehicles() { return totalVehicles; }
    public void setTotalVehicles(Long totalVehicles) { this.totalVehicles = totalVehicles; }
    public Long getEvCount() { return evCount; }
    public void setEvCount(Long evCount) { this.evCount = evCount; }
    public Long getPhevCount() { return phevCount; }
    public void setPhevCount(Long phevCount) { this.phevCount = phevCount; }
    public Long getFcevCount() { return fcevCount; }
    public void setFcevCount(Long fcevCount) { this.fcevCount = fcevCount; }
    public String getDataSource() { return dataSource; }
    public void setDataSource(String dataSource) { this.dataSource = dataSource; }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("regId", getRegId()).append("statDate", getStatDate())
                .append("city", getCity()).append("newRegistrations", getNewRegistrations())
                .append("totalVehicles", getTotalVehicles()).toString();
    }
}