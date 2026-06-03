package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.StadUnifiedOrder;

public interface StadUnifiedOrderMapper {
    StadUnifiedOrder selectStadUnifiedOrderById(Long orderId);
    List<StadUnifiedOrder> selectStadUnifiedOrderList(StadUnifiedOrder order);
    int insertStadUnifiedOrder(StadUnifiedOrder order);
    int updateStadUnifiedOrder(StadUnifiedOrder order);
    int deleteStadUnifiedOrderById(Long orderId);
    int deleteStadUnifiedOrderByIds(Long[] orderIds);
}