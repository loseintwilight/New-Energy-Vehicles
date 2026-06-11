package com.ruoyi.charging.mapper;

import com.ruoyi.charging.domain.ChargingOrder;
import java.util.List;

/**
 * 充电订单Mapper接口
 * 
 * @author ruoyi
 */
public interface ChargingOrderMapper 
{
    public ChargingOrder selectChargingOrderById(Long orderId);

    public ChargingOrder selectChargingOrderByOrderNo(String orderNo);

    public List<ChargingOrder> selectChargingOrderList(ChargingOrder order);

    public int insertChargingOrder(ChargingOrder order);

    public int updateChargingOrder(ChargingOrder order);

    public int deleteChargingOrderById(Long orderId);
}
