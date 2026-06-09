package com.ruoyi.web.controller.maintain;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.R;
import com.ruoyi.service.MaintenanceOrderService;
import com.ruoyi.service.MaintenanceShopService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Calendar;

@RestController
@RequestMapping("/maintenance/dashboard")
public class MaintainDashboardController extends BaseController {

    @Autowired
    private MaintenanceOrderService maintenanceOrderService;

    @Autowired
    private MaintenanceShopService maintenanceShopService;

    @GetMapping("/stats")
    public R stats() {
        return R.ok(maintenanceOrderService.selectDashboardStats());
    }

    @GetMapping("/statusDist")
    public R statusDist() {
        return R.ok(maintenanceOrderService.selectStatusDist());
    }

    @GetMapping("/monthlyTrend")
    public R monthlyTrend(Integer year) {
        if (year == null) {
            year = Calendar.getInstance().get(Calendar.YEAR);
        }
        return R.ok(maintenanceOrderService.selectMonthlyTrend(year));
    }

    @GetMapping("/shopRanking")
    public R shopRanking() {
        return R.ok(maintenanceShopService.selectShopRanking());
    }

    @GetMapping("/recentReviews")
    public R recentReviews(Integer limit) {
        return R.ok(maintenanceOrderService.selectRecentReviews(limit));
    }
}