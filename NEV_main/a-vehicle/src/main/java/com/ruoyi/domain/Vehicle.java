package com.ruoyi.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;
import lombok.Data;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * @Description: 车辆管理
 * @Author: 刘文丽
 * @CreateTime: 2026-06-05 21:17
 */
@Data
public class Vehicle extends BaseEntity {
    private static final long serialVersionUID = 1L;
    private Long vehicleId;
    private String vehicleType;
    private String modelName;
    private String title;
    private BigDecimal guidePrice;
    private BigDecimal originalPrice;
    private String color;
    private Integer stock;
    private Long merchantId;
    private String description;
    private String tags;
    private Integer viewCount;
    private String status;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date publishTime;
    private String merchantName;
    private VehicleSpec vehicleSpec;

//    二手车信息（关联 stad_vehicle_used 表）
    private Long usedId;
    private BigDecimal mileage;
    private Integer licenseYear;
    private Integer licenseMonth;
    private String licenseCity;
    private Integer transferCount;
    private BigDecimal batterySoh;
    private Integer batteryCycles;
    private String batteryDiagnosis;

//    车辆规格信息（关联 stad_vehicle_spec 表，列表查询直接返回）
    private Integer rangeKm;
    private BigDecimal batteryCapacity;
    private BigDecimal chargeTimeFast;

//    车辆规格信息（对应stad_vehicle_spec表）
    @Data
    public static class VehicleSpec {
        private Long specId;
        private Long vehicleId;
        private Integer rangeKm;
        private BigDecimal batteryCapacity;
        private BigDecimal chargeTimeFast;
        private BigDecimal chargeTimeSlow;
        private Integer modelYear;
    }
}
