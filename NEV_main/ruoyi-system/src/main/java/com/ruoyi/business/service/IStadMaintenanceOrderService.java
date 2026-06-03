package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.StadMaintenanceOrder;

public interface IStadMaintenanceOrderService {
    StadMaintenanceOrder selectStadMaintenanceOrderById(Long orderId);
    List<StadMaintenanceOrder> selectStadMaintenanceOrderList(StadMaintenanceOrder order);
    int insertStadMaintenanceOrder(StadMaintenanceOrder order);
    int updateStadMaintenanceOrder(StadMaintenanceOrder order);
    int deleteStadMaintenanceOrderByIds(Long[] orderIds);
}