package com.ruoyi.vo;

import lombok.Data;
import java.util.Date;
import java.util.List;

/**
 * 充电站列表VO（小程序端，含距离计算）
 */
@Data
public class StationVO {
    private Long stationId;
    private String name;
    private String address;
    private Double lat;
    private Double lng;
    private Integer totalPiles;
    private Integer freePiles;
    private Integer occupyingPiles;
    private String parkFee;
    private Date openTime;
    private Date closeTime;
    private String images;
    private String imageUrl;
    private Double distance;
    private String facilitiesInfo;
    private String stationStatus;

    /** 以下为 Service 层 enrich 补充的字段 */
    private String score;
    private String speedType;
    private String speedTypeKey;
    private String statusText;
    private String lastChargeTime;
    private Boolean plugAndPlay;
    private Boolean selfService;
    private Boolean isNearest;
    private Integer discount;
    private Integer freeParkTime;
    private String parkInfo;
    private String price;
    private String electricPrice;
    private String servicePrice;
    private Integer fastCount;
    private Integer slowCount;
    private List<Object> tags;
}