package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.mapper.StadMaintenanceOrderMapper;
import com.ruoyi.business.domain.StadMaintenanceOrder;
import com.ruoyi.business.service.IStadMaintenanceOrderService;

@Service
public class StadMaintenanceOrderServiceImpl implements IStadMaintenanceOrderService {

    @Autowired
    private StadMaintenanceOrderMapper stadMaintenanceOrderMapper;

    @Override
    public StadMaintenanceOrder selectStadMaintenanceOrderById(Long orderId) {
        return stadMaintenanceOrderMapper.selectStadMaintenanceOrderById(orderId);
    }

    @Override
    public List<StadMaintenanceOrder> selectStadMaintenanceOrderList(StadMaintenanceOrder order) {
        return stadMaintenanceOrderMapper.selectStadMaintenanceOrderList(order);
    }

    @Override
    public int insertStadMaintenanceOrder(StadMaintenanceOrder order) {
        return stadMaintenanceOrderMapper.insertStadMaintenanceOrder(order);
    }

    @Override
    public int updateStadMaintenanceOrder(StadMaintenanceOrder order) {
        return stadMaintenanceOrderMapper.updateStadMaintenanceOrder(order);
    }

    @Override
    public int deleteStadMaintenanceOrderByIds(Long[] orderIds) {
        return stadMaintenanceOrderMapper.deleteStadMaintenanceOrderByIds(orderIds);
    }
}