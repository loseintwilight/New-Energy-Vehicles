package com.ruoyi.mapper;

import com.ruoyi.business.domain.StadMaintenanceOrder;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface MaintenanceOrderMapper {

    Map<String, Object> selectDashboardStats();

    List<Map<String, Object>> selectStatusDist();

    List<Map<String, Object>> selectMonthlyTrend(@Param("year") Integer year);

    List<StadMaintenanceOrder> selectRecentReviews(@Param("limit") Integer limit);

    Map<String, Object> selectOrderStats();

    List<StadMaintenanceOrder> selectStadMaintenanceOrderReviewList(StadMaintenanceOrder order);
}