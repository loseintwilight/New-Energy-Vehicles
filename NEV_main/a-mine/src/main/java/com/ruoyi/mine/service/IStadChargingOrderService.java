package com.ruoyi.mine.service;

import java.util.List;
import com.ruoyi.mine.domain.MineStadChargingOrder;

public interface IStadChargingOrderService {
    public MineStadChargingOrder selectStadChargingOrderById(Long orderId);
    public List<MineStadChargingOrder> selectStadChargingOrderList(MineStadChargingOrder order);
    public int insertStadChargingOrder(MineStadChargingOrder order);
    public int updateStadChargingOrder(MineStadChargingOrder order);
    public int deleteStadChargingOrderById(Long orderId);
    public int deleteStadChargingOrderByIds(Long[] orderIds);
}
