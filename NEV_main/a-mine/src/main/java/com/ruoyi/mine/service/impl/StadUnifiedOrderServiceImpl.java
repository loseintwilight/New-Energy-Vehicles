package com.ruoyi.mine.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import com.ruoyi.mine.mapper.StadUnifiedOrderMapper;
import com.ruoyi.mine.domain.MineStadUnifiedOrder;
import com.ruoyi.mine.service.IStadUnifiedOrderService;

@Service("mineStadUnifiedOrderServiceImpl")
public class StadUnifiedOrderServiceImpl implements IStadUnifiedOrderService {

    @Autowired
    @Qualifier("mineStadUnifiedOrderMapper")
    private StadUnifiedOrderMapper stadUnifiedOrderMapper;

    @Override
    public MineStadUnifiedOrder selectStadUnifiedOrderById(Long orderId) {
        return stadUnifiedOrderMapper.selectStadUnifiedOrderById(orderId);
    }

    @Override
    public List<MineStadUnifiedOrder> selectStadUnifiedOrderList(MineStadUnifiedOrder order) {
        return stadUnifiedOrderMapper.selectStadUnifiedOrderList(order);
    }

    @Override
    public int insertStadUnifiedOrder(MineStadUnifiedOrder order) {
        return stadUnifiedOrderMapper.insertStadUnifiedOrder(order);
    }

    @Override
    public int updateStadUnifiedOrder(MineStadUnifiedOrder order) {
        return stadUnifiedOrderMapper.updateStadUnifiedOrder(order);
    }

    @Override
    public int deleteStadUnifiedOrderById(Long orderId) {
        return stadUnifiedOrderMapper.deleteStadUnifiedOrderById(orderId);
    }

    @Override
    public int deleteStadUnifiedOrderByIds(Long[] orderIds) {
        return stadUnifiedOrderMapper.deleteStadUnifiedOrderByIds(orderIds);
    }

    @Override
    public Map<String, Object> getOrderStatusCount(Long userId) {
        Map<String, Object> countMap = new HashMap<>();
        MineStadUnifiedOrder query = new MineStadUnifiedOrder();
        query.setUserId(userId);
        List<MineStadUnifiedOrder> orders = stadUnifiedOrderMapper.selectStadUnifiedOrderList(query);
        
        int pending = 0;
        int processing = 0;
        int completed = 0;
        int cancelled = 0;
        
        if (orders != null) {
            for (MineStadUnifiedOrder order : orders) {
                String status = order.getStatus();
                if ("0".equals(status)) {
                    pending++;
                } else if ("1".equals(status)) {
                    processing++;
                } else if ("2".equals(status)) {
                    cancelled++;
                } else if ("3".equals(status)) {
                    completed++;
                }
            }
        }
        
        countMap.put("pending", pending);
        countMap.put("processing", processing);
        countMap.put("completed", completed);
        countMap.put("cancelled", cancelled);
        return countMap;
    }
}
