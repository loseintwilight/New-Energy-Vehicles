package com.ruoyi.vo;

import lombok.Data;
import java.util.List;

/**
 * 充电站详情VO（小程序端）
 */
@Data
public class StationDetailVO {
    private Long stationId;
    private String name;
    private String address;
    private Double lat;
    private Double lng;
    private Integer totalPiles;
    private Integer freePiles;
    private String parkFee;
    private String openTime;
    private String stationType;
    private String operatorName;
    private String images;
    private String servicePhone;
    private String facilitiesInfo;
    private Double score;
    private String price;
    private String electricPrice;
    private String servicePrice;
    private Double distance;
    private List<Object> tags;
    private List<RateVO> timePrices;
    private List<PileVO> piles;
}