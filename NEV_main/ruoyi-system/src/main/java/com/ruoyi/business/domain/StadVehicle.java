package com.ruoyi.business.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;
import java.math.BigDecimal;

public class StadVehicle extends BaseEntity {
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
    private String merchantName;
    private StadVehicleSpec vehicleSpec;
    private java.util.List<StadVehicleFinancePlan> financePlans;

    public Long getVehicleId() { return vehicleId; }
    public void setVehicleId(Long vehicleId) { this.vehicleId = vehicleId; }

    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }

    public String getModelName() { return modelName; }
    public void setModelName(String modelName) { this.modelName = modelName; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public BigDecimal getGuidePrice() { return guidePrice; }
    public void setGuidePrice(BigDecimal guidePrice) { this.guidePrice = guidePrice; }

    public BigDecimal getOriginalPrice() { return originalPrice; }
    public void setOriginalPrice(BigDecimal originalPrice) { this.originalPrice = originalPrice; }

    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }

    public Integer getStock() { return stock; }
    public void setStock(Integer stock) { this.stock = stock; }

    public Long getMerchantId() { return merchantId; }
    public void setMerchantId(Long merchantId) { this.merchantId = merchantId; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getTags() { return tags; }
    public void setTags(String tags) { this.tags = tags; }

    public Integer getViewCount() { return viewCount; }
    public void setViewCount(Integer viewCount) { this.viewCount = viewCount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getMerchantName() { return merchantName; }
    public void setMerchantName(String merchantName) { this.merchantName = merchantName; }

    public StadVehicleSpec getVehicleSpec() { return vehicleSpec; }
    public void setVehicleSpec(StadVehicleSpec vehicleSpec) { this.vehicleSpec = vehicleSpec; }

    public java.util.List<StadVehicleFinancePlan> getFinancePlans() { return financePlans; }
    public void setFinancePlans(java.util.List<StadVehicleFinancePlan> financePlans) { this.financePlans = financePlans; }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("vehicleId", getVehicleId())
                .append("vehicleType", getVehicleType())
                .append("modelName", getModelName())
                .append("title", getTitle())
                .append("guidePrice", getGuidePrice())
                .append("originalPrice", getOriginalPrice())
                .append("color", getColor())
                .append("stock", getStock())
                .append("merchantId", getMerchantId())
                .append("description", getDescription())
                .append("tags", getTags())
                .append("viewCount", getViewCount())
                .append("status", getStatus())
                .append("createTime", getCreateTime())
                .append("updateTime", getUpdateTime())
                .toString();
    }
}