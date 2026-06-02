package com.ruoyi.business.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;
import java.math.BigDecimal;
import java.util.Date;

public class StadChargingStation extends BaseEntity {
    private static final long serialVersionUID = 1L;

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
    private String merchantName;

    public Long getStationId() { return stationId; }
    public void setStationId(Long stationId) { this.stationId = stationId; }

    public String getStationName() { return stationName; }
    public void setStationName(String stationName) { this.stationName = stationName; }

    public String getStationCode() { return stationCode; }
    public void setStationCode(String stationCode) { this.stationCode = stationCode; }

    public Long getMerchantId() { return merchantId; }
    public void setMerchantId(Long merchantId) { this.merchantId = merchantId; }

    public String getProvince() { return province; }
    public void setProvince(String province) { this.province = province; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public BigDecimal getLongitude() { return longitude; }
    public void setLongitude(BigDecimal longitude) { this.longitude = longitude; }

    public BigDecimal getLatitude() { return latitude; }
    public void setLatitude(BigDecimal latitude) { this.latitude = latitude; }

    public String getGeoHash() { return geoHash; }
    public void setGeoHash(String geoHash) { this.geoHash = geoHash; }

    public String getMarkerIconUrl() { return markerIconUrl; }
    public void setMarkerIconUrl(String markerIconUrl) { this.markerIconUrl = markerIconUrl; }

    public String getMarkerSize() { return markerSize; }
    public void setMarkerSize(String markerSize) { this.markerSize = markerSize; }

    public Integer getTotalPiles() { return totalPiles; }
    public void setTotalPiles(Integer totalPiles) { this.totalPiles = totalPiles; }

    public Integer getAvailablePiles() { return availablePiles; }
    public void setAvailablePiles(Integer availablePiles) { this.availablePiles = availablePiles; }

    public Integer getOccupyingPiles() { return occupyingPiles; }
    public void setOccupyingPiles(Integer occupyingPiles) { this.occupyingPiles = occupyingPiles; }

    public Date getOpenTime() { return openTime; }
    public void setOpenTime(Date openTime) { this.openTime = openTime; }

    public Date getCloseTime() { return closeTime; }
    public void setCloseTime(Date closeTime) { this.closeTime = closeTime; }

    public String getParkingFee() { return parkingFee; }
    public void setParkingFee(String parkingFee) { this.parkingFee = parkingFee; }

    public String getServicePhone() { return servicePhone; }
    public void setServicePhone(String servicePhone) { this.servicePhone = servicePhone; }

    public String getFacilitiesInfo() { return facilitiesInfo; }
    public void setFacilitiesInfo(String facilitiesInfo) { this.facilitiesInfo = facilitiesInfo; }

    public String getImages() { return images; }
    public void setImages(String images) { this.images = images; }

    public Integer getIsInternal() { return isInternal; }
    public void setIsInternal(Integer isInternal) { this.isInternal = isInternal; }

    public String getApplyStatus() { return applyStatus; }
    public void setApplyStatus(String applyStatus) { this.applyStatus = applyStatus; }

    public String getAuditRemark() { return auditRemark; }
    public void setAuditRemark(String auditRemark) { this.auditRemark = auditRemark; }

    public Date getAuditTime() { return auditTime; }
    public void setAuditTime(Date auditTime) { this.auditTime = auditTime; }

    public String getBusinessLicense() { return businessLicense; }
    public void setBusinessLicense(String businessLicense) { this.businessLicense = businessLicense; }

    public String getSiteProof() { return siteProof; }
    public void setSiteProof(String siteProof) { this.siteProof = siteProof; }

    public String getStationStatus() { return stationStatus; }
    public void setStationStatus(String stationStatus) { this.stationStatus = stationStatus; }

    public String getMerchantName() { return merchantName; }
    public void setMerchantName(String merchantName) { this.merchantName = merchantName; }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("stationId", getStationId())
                .append("stationName", getStationName())
                .append("stationCode", getStationCode())
                .append("city", getCity())
                .append("address", getAddress())
                .append("totalPiles", getTotalPiles())
                .append("stationStatus", getStationStatus())
                .append("createTime", getCreateTime())
                .toString();
    }
}