package com.ruoyi.service;

import com.ruoyi.business.domain.StadMaintenanceOrder;

import java.util.List;
import java.util.Map;

public interface MaintenanceOrderService {

    Map<String, Object> selectDashboardStats();

    List<Map<String, Object>> selectStatusDist();

    List<Map<String, Object>> selectMonthlyTrend(Integer year);

    List<StadMaintenanceOrder> selectRecentReviews(Integer limit);

    Map<String, Object> selectOrderStats();

    List<StadMaintenanceOrder> selectStadMaintenanceOrderReviewList(StadMaintenanceOrder order);
}
