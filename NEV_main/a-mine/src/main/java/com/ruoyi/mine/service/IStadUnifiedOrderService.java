package com.ruoyi.mine.service;

import java.util.List;
import java.util.Map;
import com.ruoyi.mine.domain.MineStadUnifiedOrder;

public interface IStadUnifiedOrderService {
    public MineStadUnifiedOrder selectStadUnifiedOrderById(Long orderId);
    public List<MineStadUnifiedOrder> selectStadUnifiedOrderList(MineStadUnifiedOrder order);
    public int insertStadUnifiedOrder(MineStadUnifiedOrder order);
    public int updateStadUnifiedOrder(MineStadUnifiedOrder order);
    public int deleteStadUnifiedOrderById(Long orderId);
    public int deleteStadUnifiedOrderByIds(Long[] orderIds);
    public Map<String, Object> getOrderStatusCount(Long userId);
}
