package com.ruoyi.charging.controller;

import com.ruoyi.charging.domain.AppMerchant;
import com.ruoyi.charging.domain.DashboardOrderVO;
import com.ruoyi.charging.domain.DashboardStationVO;
import com.ruoyi.charging.domain.DashboardVO;
import com.ruoyi.charging.mapper.ChargingStationMapper;
import com.ruoyi.charging.service.IAppMerchantService;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 充电桩工作台首页 Controller（使用 VO 替代 Map 传参）
 */
@RestController
@RequestMapping("/app/charge/dashboard")
public class AppDashboardController {

    @Autowired
    private ChargingStationMapper chargingStationMapper;

    @Autowired
    private IAppMerchantService appMerchantService;

    /**
     * 获取工作台首页数据
     */
    @GetMapping
    public AjaxResult dashboard() {
        // 获取当前商户
        Long userId = SecurityUtils.getUserId();
        AppMerchant merchant = appMerchantService.selectAppMerchantByUserId(userId);
        if (merchant == null) {
            return AjaxResult.error("商户信息不存在");
        }
        Long merchantId = merchant.getMerchantId();

        // 今日汇总统计
        DashboardVO stats = chargingStationMapper.selectDashboardTodayStats(merchantId);
        if (stats == null) {
            stats = new DashboardVO();
        }

        // 各站统计
        List<DashboardStationVO> stations = chargingStationMapper.selectDashboardStations(merchantId);
        stats.setStations(stations);

        // 汇总桩数
        int totalPiles = 0;
        int availablePiles = 0;
        for (DashboardStationVO s : stations) {
            totalPiles += (s.getTotalPiles() != null ? s.getTotalPiles() : 0);
            availablePiles += (s.getAvailablePiles() != null ? s.getAvailablePiles() : 0);
        }
        stats.setTotalPiles(totalPiles);
        stats.setAvailablePiles(availablePiles);

        // 最近订单
        List<DashboardOrderVO> recentOrders = chargingStationMapper.selectDashboardRecentOrders(merchantId, 10);
        stats.setRecentOrders(recentOrders);

        // 商户信息
        stats.setMerchantId(merchant.getMerchantId());
        stats.setMerchantName(merchant.getMerchantName());

        return AjaxResult.success(stats);
    }
}
