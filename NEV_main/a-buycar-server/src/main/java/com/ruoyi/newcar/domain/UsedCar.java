package com.ruoyi.newcar.domain;

import lombok.Data;

import java.util.Date;

@Data
public class UsedCar {
    private Long usedId;

    private Long vehicleId;

    private Integer licenseYear;

    private Integer licenseMonth;

    private String licenseCity;

    private Double mileage;

    private Integer transferCount;

    private Double batterySoh;

    private Integer batteryCycles;

    private String batteryDiagnosis;

    private String batteryReport;

    private Double valuationPrice;

    private String valuationInfo;

    private Date createTime;
}