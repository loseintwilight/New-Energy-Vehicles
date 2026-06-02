package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.mapper.StadChargingOrderMapper;
import com.ruoyi.business.domain.StadChargingOrder;
import com.ruoyi.business.service.IStadChargingOrderService;

@Service
public class StadChargingOrderServiceImpl implements IStadChargingOrderService {

    @Autowired
    private StadChargingOrderMapper stadChargingOrderMapper;

    @Override
    public StadChargingOrder selectStadChargingOrderById(Long orderId) {
        return stadChargingOrderMapper.selectStadChargingOrderById(orderId);
    }

    @Override
    public List<StadChargingOrder> selectStadChargingOrderList(StadChargingOrder order) {
        return stadChargingOrderMapper.selectStadChargingOrderList(order);
    }

    @Override
    public int insertStadChargingOrder(StadChargingOrder order) {
        return stadChargingOrderMapper.insertStadChargingOrder(order);
    }

    @Override
    public int updateStadChargingOrder(StadChargingOrder order) {
        return stadChargingOrderMapper.updateStadChargingOrder(order);
    }

    @Override
    public int deleteStadChargingOrderByIds(Long[] orderIds) {
        return stadChargingOrderMapper.deleteStadChargingOrderByIds(orderIds);
    }
}