package com.ruoyi.mine.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.apache.ibatis.type.Alias;
import com.ruoyi.common.core.domain.BaseEntity;

@Alias("MineStadUserFavorite")
public class MineStadUserFavorite extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long favoriteId;
    private Long userId;
    private String nickName;
    private String targetType;
    private Long targetId;
    private String targetName;
    private String targetImage;
    private java.math.BigDecimal targetPrice;
    private String targetAddress;
    private String targetStatus;
    private Integer targetStock;
    private Integer targetPiles;
    private Integer targetAvailablePiles;
    private String targetVehicleType;
    
    /** 车辆续航(km) - 来自 stad_vehicle_spec */
    private Integer targetRange;
    
    /** 电池容量(kWh) - 来自 stad_vehicle_spec */
    private java.math.BigDecimal targetBattery;
    
    /** 充电站停车费说明 */
    private String targetParkingFee;
    
    /** 充电站配套设施说明 */
    private String targetFacilities;
    
    /** 充电站最低费率(元/度) */
    private java.math.BigDecimal targetStationPrice;

    public Long getFavoriteId() { return favoriteId; }
    public void setFavoriteId(Long favoriteId) { this.favoriteId = favoriteId; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getNickName() { return nickName; }
    public void setNickName(String nickName) { this.nickName = nickName; }

    public String getTargetType() { return targetType; }
    public void setTargetType(String targetType) { this.targetType = targetType; }

    public Long getTargetId() { return targetId; }
    public void setTargetId(Long targetId) { this.targetId = targetId; }

    public String getTargetName() { return targetName; }
    public void setTargetName(String targetName) { this.targetName = targetName; }

    public String getTargetImage() { return targetImage; }
    public void setTargetImage(String targetImage) { this.targetImage = targetImage; }

    public java.math.BigDecimal getTargetPrice() { return targetPrice; }
    public void setTargetPrice(java.math.BigDecimal targetPrice) { this.targetPrice = targetPrice; }

    public String getTargetAddress() { return targetAddress; }
    public void setTargetAddress(String targetAddress) { this.targetAddress = targetAddress; }

    public String getTargetStatus() { return targetStatus; }
    public void setTargetStatus(String targetStatus) { this.targetStatus = targetStatus; }

    public Integer getTargetStock() { return targetStock; }
    public void setTargetStock(Integer targetStock) { this.targetStock = targetStock; }

    public Integer getTargetPiles() { return targetPiles; }
    public void setTargetPiles(Integer targetPiles) { this.targetPiles = targetPiles; }

    public Integer getTargetAvailablePiles() { return targetAvailablePiles; }
    public void setTargetAvailablePiles(Integer targetAvailablePiles) { this.targetAvailablePiles = targetAvailablePiles; }

    public String getTargetVehicleType() { return targetVehicleType; }
    public void setTargetVehicleType(String targetVehicleType) { this.targetVehicleType = targetVehicleType; }

    public Integer getTargetRange() { return targetRange; }
    public void setTargetRange(Integer targetRange) { this.targetRange = targetRange; }

    public java.math.BigDecimal getTargetBattery() { return targetBattery; }
    public void setTargetBattery(java.math.BigDecimal targetBattery) { this.targetBattery = targetBattery; }

    public String getTargetParkingFee() { return targetParkingFee; }
    public void setTargetParkingFee(String targetParkingFee) { this.targetParkingFee = targetParkingFee; }

    public String getTargetFacilities() { return targetFacilities; }
    public void setTargetFacilities(String targetFacilities) { this.targetFacilities = targetFacilities; }

    public java.math.BigDecimal getTargetStationPrice() { return targetStationPrice; }
    public void setTargetStationPrice(java.math.BigDecimal targetStationPrice) { this.targetStationPrice = targetStationPrice; }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("favoriteId", getFavoriteId())
                .append("userId", getUserId())
                .append("targetType", getTargetType())
                .append("targetId", getTargetId())
                .append("targetName", getTargetName())
                .toString();
    }
}
