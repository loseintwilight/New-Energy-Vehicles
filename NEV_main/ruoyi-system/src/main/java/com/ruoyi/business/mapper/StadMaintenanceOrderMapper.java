package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.StadMaintenanceOrder;

public interface StadMaintenanceOrderMapper {
    StadMaintenanceOrder selectStadMaintenanceOrderById(Long orderId);
    List<StadMaintenanceOrder> selectStadMaintenanceOrderList(StadMaintenanceOrder order);
    int insertStadMaintenanceOrder(StadMaintenanceOrder order);
    int updateStadMaintenanceOrder(StadMaintenanceOrder order);
    int deleteStadMaintenanceOrderById(Long orderId);
    int deleteStadMaintenanceOrderByIds(Long[] orderIds);
}