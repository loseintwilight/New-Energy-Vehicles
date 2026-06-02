package com.ruoyi.business.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;

public class StadUserAddress extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long addressId;
    private Long userId;
    private String contactName;
    private String contactPhone;
    private String province;
    private String city;
    private String district;
    private String detail;
    private Integer isDefault;

    public Long getAddressId() { return addressId; }
    public void setAddressId(Long addressId) { this.addressId = addressId; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getContactName() { return contactName; }
    public void setContactName(String contactName) { this.contactName = contactName; }

    public String getContactPhone() { return contactPhone; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }

    public String getProvince() { return province; }
    public void setProvince(String province) { this.province = province; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }

    public String getDetail() { return detail; }
    public void setDetail(String detail) { this.detail = detail; }

    public Integer getIsDefault() { return isDefault; }
    public void setIsDefault(Integer isDefault) { this.isDefault = isDefault; }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("addressId", getAddressId())
                .append("userId", getUserId())
                .append("contactName", getContactName())
                .append("contactPhone", getContactPhone())
                .append("province", getProvince())
                .append("city", getCity())
                .append("district", getDistrict())
                .append("detail", getDetail())
                .append("isDefault", getIsDefault())
                .toString();
    }
}