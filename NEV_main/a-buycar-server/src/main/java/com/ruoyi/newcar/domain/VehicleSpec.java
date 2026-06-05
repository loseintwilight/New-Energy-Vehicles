package com.ruoyi.newcar.domain;

import lombok.Data;

import java.util.Date;

@Data
public class VehicleSpec {
    private Long specId;

    private Long vehicleId;

    private Integer rangeKm;

    private Double batteryCapacity;

    private Double chargeTimeFast;

    private Double chargeTimeSlow;

    private Integer modelYear;

    private Date createTime;
}