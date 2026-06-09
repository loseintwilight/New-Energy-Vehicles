package com.ruoyi.business.service;

import java.util.List;
import java.util.Map;
import com.ruoyi.business.domain.StadMaintenanceOrder;

public interface IStadMaintenanceOrderService {
    StadMaintenanceOrder selectStadMaintenanceOrderById(Long orderId);
    List<StadMaintenanceOrder> selectStadMaintenanceOrderList(StadMaintenanceOrder order);
    int insertStadMaintenanceOrder(StadMaintenanceOrder order);
    int updateStadMaintenanceOrder(StadMaintenanceOrder order);
    int deleteStadMaintenanceOrderByIds(Long[] orderIds);

    // 小程序预约相关
    List<Map<String, Object>> getFormattedReservationList(Long userId, StadMaintenanceOrder query);
    Map<String, Object> getFormattedReservationDetail(Long orderId);
    boolean cancelReservation(Long orderId);
    boolean createReservation(Long userId, Map<String, Object> data);
}