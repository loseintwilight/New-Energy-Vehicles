package com.ruoyi.charging.service;

import java.util.List;
import com.ruoyi.charging.domain.ChargingOrder;

/**
 * 充电订单Service接口
 *
 * @author ruoyi
 */
public interface IChargingOrderService
{
    /**
     * 查询充电订单
     */
    public ChargingOrder selectChargingOrderById(Long orderId);

    /**
     * 根据订单号查询充电订单
     */
    public ChargingOrder selectChargingOrderByOrderNo(String orderNo);

    /**
     * 查询充电订单列表
     */
    public List<ChargingOrder> selectChargingOrderList(ChargingOrder order);

    /**
     * 新增充电订单
     */
    public int insertChargingOrder(ChargingOrder order);

    /**
     * 修改充电订单
     */
    public int updateChargingOrder(ChargingOrder order);

    /**
     * 批量删除充电订单
     */
    public int deleteChargingOrderByIds(Long[] orderIds);

    /**
     * 删除充电订单信息
     */
    public int deleteChargingOrderById(Long orderId);
}
