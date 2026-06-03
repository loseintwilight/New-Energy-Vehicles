package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.StadChargingOrder;

public interface IStadChargingOrderService {
    StadChargingOrder selectStadChargingOrderById(Long orderId);
    List<StadChargingOrder> selectStadChargingOrderList(StadChargingOrder order);
    int insertStadChargingOrder(StadChargingOrder order);
    int updateStadChargingOrder(StadChargingOrder order);
    int deleteStadChargingOrderByIds(Long[] orderIds);
}