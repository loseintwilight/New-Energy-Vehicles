package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.StadChargingOrder;

public interface StadChargingOrderMapper {
    StadChargingOrder selectStadChargingOrderById(Long orderId);
    List<StadChargingOrder> selectStadChargingOrderList(StadChargingOrder order);
    int insertStadChargingOrder(StadChargingOrder order);
    int updateStadChargingOrder(StadChargingOrder order);
    int deleteStadChargingOrderById(Long orderId);
    int deleteStadChargingOrderByIds(Long[] orderIds);
}