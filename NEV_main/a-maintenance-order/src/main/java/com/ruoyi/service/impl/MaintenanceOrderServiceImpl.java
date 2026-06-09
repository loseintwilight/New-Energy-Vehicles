package com.ruoyi.service.impl;
import com.ruoyi.business.domain.StadMaintenanceOrder;
import com.ruoyi.mapper.MaintenanceOrderMapper;
import com.ruoyi.service.MaintenanceOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @Classname MaintenanceOrderServiceImpl
 * @Description
 * @Date 2026/6/8 16:24
 * @Created by 高合吴彦祖鹏哥
 */
@Service
public class MaintenanceOrderServiceImpl implements MaintenanceOrderService {

    @Autowired
    private MaintenanceOrderMapper maintenanceOrderMapper;

    @Override
    public Map<String, Object> selectDashboardStats() {
        return maintenanceOrderMapper.selectDashboardStats();
    }

    @Override
    public List<Map<String, Object>> selectStatusDist() {
        return maintenanceOrderMapper.selectStatusDist();
    }

    @Override
    public List<Map<String, Object>> selectMonthlyTrend(Integer year) {
        return maintenanceOrderMapper.selectMonthlyTrend(year);
    }

    @Override
    public List<StadMaintenanceOrder> selectRecentReviews(Integer limit) {
        return maintenanceOrderMapper.selectRecentReviews(limit);
    }

    @Override
    public Map<String, Object> selectOrderStats() {
        return maintenanceOrderMapper.selectOrderStats();
    }

    @Override
    public List<StadMaintenanceOrder> selectStadMaintenanceOrderReviewList(StadMaintenanceOrder order) {
        return maintenanceOrderMapper.selectStadMaintenanceOrderReviewList(order);
    }
}