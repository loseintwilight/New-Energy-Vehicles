package com.ruoyi.pojo;

import lombok.Data;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 充电站表（地图展示 动态容量）
 */
@Data
public class Station {
    private Long stationId;
    private String stationName;
    private String stationCode;
    private Long merchantId;
    private String province;
    private String city;
    private String district;
    private String address;
    private BigDecimal longitude;
    private BigDecimal latitude;
    private String geoHash;
    private String markerIconUrl;
    private String markerSize;
    private Integer totalPiles;
    private Integer availablePiles;
    private Integer occupyingPiles;
    private Date openTime;
    private Date closeTime;
    private String parkingFee;
    private String servicePhone;
    private String facilitiesInfo;
    private String images;
    private Integer isInternal;
    private String applyStatus;
    private String auditRemark;
    private Date auditTime;
    private String businessLicense;
    private String siteProof;
    private String stationStatus;
    private Date createTime;
    private Date updateTime;
}