package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.StadUnifiedOrder;

public interface IStadUnifiedOrderService {
    StadUnifiedOrder selectStadUnifiedOrderById(Long orderId);
    List<StadUnifiedOrder> selectStadUnifiedOrderList(StadUnifiedOrder order);
    int insertStadUnifiedOrder(StadUnifiedOrder order);
    int updateStadUnifiedOrder(StadUnifiedOrder order);
    int deleteStadUnifiedOrderByIds(Long[] orderIds);
}