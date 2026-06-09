package com.ruoyi.mine.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import com.ruoyi.mine.mapper.StadChargingOrderMapper;
import com.ruoyi.mine.domain.MineStadChargingOrder;
import com.ruoyi.mine.service.IStadChargingOrderService;

@Service("mineStadChargingOrderServiceImpl")
public class StadChargingOrderServiceImpl implements IStadChargingOrderService {

    @Autowired
    @Qualifier("mineStadChargingOrderMapper")
    private StadChargingOrderMapper stadChargingOrderMapper;

    @Override
    public MineStadChargingOrder selectStadChargingOrderById(Long orderId) {
        return stadChargingOrderMapper.selectStadChargingOrderById(orderId);
    }

    @Override
    public List<MineStadChargingOrder> selectStadChargingOrderList(MineStadChargingOrder order) {
        return stadChargingOrderMapper.selectStadChargingOrderList(order);
    }

    @Override
    public int insertStadChargingOrder(MineStadChargingOrder order) {
        return stadChargingOrderMapper.insertStadChargingOrder(order);
    }

    @Override
    public int updateStadChargingOrder(MineStadChargingOrder order) {
        return stadChargingOrderMapper.updateStadChargingOrder(order);
    }

    @Override
    public int deleteStadChargingOrderById(Long orderId) {
        return stadChargingOrderMapper.deleteStadChargingOrderById(orderId);
    }

    @Override
    public int deleteStadChargingOrderByIds(Long[] orderIds) {
        return stadChargingOrderMapper.deleteStadChargingOrderByIds(orderIds);
    }
}
