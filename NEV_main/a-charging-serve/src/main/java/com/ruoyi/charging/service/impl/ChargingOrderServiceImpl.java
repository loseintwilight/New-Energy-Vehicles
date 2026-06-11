package com.ruoyi.charging.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.charging.mapper.ChargingOrderMapper;
import com.ruoyi.charging.domain.ChargingOrder;
import com.ruoyi.charging.service.IChargingOrderService;

/**
 * 充电订单Service业务层处理
 *
 * @author ruoyi
 */
@Service
public class ChargingOrderServiceImpl implements IChargingOrderService
{
    @Autowired
    private ChargingOrderMapper chargingOrderMapper;

    /**
     * 查询充电订单
     */
    @Override
    public ChargingOrder selectChargingOrderById(Long orderId)
    {
        return chargingOrderMapper.selectChargingOrderById(orderId);
    }

    /**
     * 根据订单号查询充电订单
     */
    @Override
    public ChargingOrder selectChargingOrderByOrderNo(String orderNo)
    {
        return chargingOrderMapper.selectChargingOrderByOrderNo(orderNo);
    }

    /**
     * 查询充电订单列表
     */
    @Override
    public List<ChargingOrder> selectChargingOrderList(ChargingOrder order)
    {
        return chargingOrderMapper.selectChargingOrderList(order);
    }

    /**
     * 新增充电订单
     */
    @Override
    public int insertChargingOrder(ChargingOrder order)
    {
        return chargingOrderMapper.insertChargingOrder(order);
    }

    /**
     * 修改充电订单
     */
    @Override
    public int updateChargingOrder(ChargingOrder order)
    {
        return chargingOrderMapper.updateChargingOrder(order);
    }

    /**
     * 批量删除充电订单
     */
    @Override
    public int deleteChargingOrderByIds(Long[] orderIds)
    {
        int rows = 0;
        for (Long orderId : orderIds)
        {
            rows += chargingOrderMapper.deleteChargingOrderById(orderId);
        }
        return rows;
    }

    /**
     * 删除充电订单信息
     */
    @Override
    public int deleteChargingOrderById(Long orderId)
    {
        return chargingOrderMapper.deleteChargingOrderById(orderId);
    }
}
