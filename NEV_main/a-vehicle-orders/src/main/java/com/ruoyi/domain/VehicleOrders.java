package com.ruoyi.domain;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;

import java.math.BigDecimal;
import java.util.Date;

/**
 * @Description: 订单管理
 * @Author: 刘文丽
 * @CreateTime: 2026-06-05 09:53
 */

@Data
public class VehicleOrders extends BaseEntity {
    private Long orderId;
    private String orderNo;
    private String orderType;
    private Long userId;
    private Long vehicleId;
    private Long merchantId;
    private String contactName;
    private String contactPhone;
    private Long addressId;
    private BigDecimal vehiclePrice;
    private BigDecimal totalAmount;
    private BigDecimal paidAmount;
    private String paymentMethod;
    private String insuranceInfo;
    private Date expectDate;
    private String expectTimeSlot;
    private Long oldVehicleId;
    private BigDecimal oldValuation;
    private Long newOrderId;
    private String status;
    private String cancelReason;
    private String vehicleName;
//    旧车信息(来自stad_vehicle)
    private String oldCarBrand;
    private String oldLicenseYear;
    private String oldLicenseMonth;
    private Long oldMileage;
}
