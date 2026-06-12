package com.ruoyi.mine.vo;

import java.math.BigDecimal;
import java.util.List;

/**
 * 收藏列表 VO
 * 统一展示三种类型收藏（车辆/充电站/文章）
 */
public class FavoriteListVO {

    /** 收藏记录ID */
    private Long id;

    /** 收藏类型: car/charge/text */
    private String type;

    /** 创建时间 */
    private String createTime;

    /** 目标对象ID（vehicleId / stationId / articleId） */
    private Long targetId;

    // ===== 车辆收藏特有字段 =====
    private String model;
    private String brand;
    private Integer range;
    private BigDecimal battery;
    private BigDecimal price;
    private String image;

    // ===== 充电站收藏特有字段 =====
    private String stationName;
    private String distance;
    private String address;
    private List<String> tags;

    // ===== 文章收藏特有字段 =====
    private String title;
    private String desc;
    private String source;
    private String time;

    // ===== Getters & Setters =====

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getCreateTime() { return createTime; }
    public void setCreateTime(String createTime) { this.createTime = createTime; }

    public Long getTargetId() { return targetId; }
    public void setTargetId(Long targetId) { this.targetId = targetId; }

    // vehicle
    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }

    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }

    public Integer getRange() { return range; }
    public void setRange(Integer range) { this.range = range; }

    public BigDecimal getBattery() { return battery; }
    public void setBattery(BigDecimal battery) { this.battery = battery; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    // station
    public String getStationName() { return stationName; }
    public void setStationName(String stationName) { this.stationName = stationName; }

    public String getDistance() { return distance; }
    public void setDistance(String distance) { this.distance = distance; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public List<String> getTags() { return tags; }
    public void setTags(List<String> tags) { this.tags = tags; }

    // article
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDesc() { return desc; }
    public void setDesc(String desc) { this.desc = desc; }

    public String getSource() { return source; }
    public void setSource(String source) { this.source = source; }

    public String getTime() { return time; }
    public void setTime(String time) { this.time = time; }
}