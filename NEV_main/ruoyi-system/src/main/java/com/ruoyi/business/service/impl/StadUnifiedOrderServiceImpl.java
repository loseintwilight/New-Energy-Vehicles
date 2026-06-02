package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.mapper.StadUnifiedOrderMapper;
import com.ruoyi.business.domain.StadUnifiedOrder;
import com.ruoyi.business.service.IStadUnifiedOrderService;

@Service
public class StadUnifiedOrderServiceImpl implements IStadUnifiedOrderService {

    @Autowired
    private StadUnifiedOrderMapper stadUnifiedOrderMapper;

    @Override
    public StadUnifiedOrder selectStadUnifiedOrderById(Long orderId) {
        return stadUnifiedOrderMapper.selectStadUnifiedOrderById(orderId);
    }

    @Override
    public List<StadUnifiedOrder> selectStadUnifiedOrderList(StadUnifiedOrder order) {
        return stadUnifiedOrderMapper.selectStadUnifiedOrderList(order);
    }

    @Override
    public int insertStadUnifiedOrder(StadUnifiedOrder order) {
        return stadUnifiedOrderMapper.insertStadUnifiedOrder(order);
    }

    @Override
    public int updateStadUnifiedOrder(StadUnifiedOrder order) {
        return stadUnifiedOrderMapper.updateStadUnifiedOrder(order);
    }

    @Override
    public int deleteStadUnifiedOrderByIds(Long[] orderIds) {
        return stadUnifiedOrderMapper.deleteStadUnifiedOrderByIds(orderIds);
    }
}