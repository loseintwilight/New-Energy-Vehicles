package com.ruoyi.web.controller.chargeMini;

import com.ruoyi.charging.domain.AppMerchant;
import com.ruoyi.charging.service.IAppMerchantService;
import com.ruoyi.charging.service.IChargingStationService;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.service.StationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 充电站接口（小程序 + 商户端）
 */
@RestController
@RequestMapping("/app/charge-mini/station")
public class StationController {

    @Autowired
    private StationService stationService;

    @Autowired
    private IChargingStationService chargingStationService;

    @Autowired
    private IAppMerchantService appMerchantService;

    /**
     * 1.1 获取充电站列表（分页，带距离排序）
     */
    @GetMapping("/list")
    public AjaxResult list(@RequestParam Double lat, @RequestParam Double lng,
                           @RequestParam(defaultValue = "1") Integer pageNum,
                           @RequestParam(defaultValue = "10") Integer pageSize,
                           @RequestParam(required = false) String orderByColumn,
                           @RequestParam(required = false) String isAsc,
                           @RequestParam(required = false) String filter) {
        return stationService.getStationList(lat, lng, pageNum, pageSize, orderByColumn, isAsc, filter);
    }

    /**
     * 1.2 获取充电站详情
     */
    @GetMapping("/detail/{stationId}")
    public AjaxResult detail(@PathVariable Long stationId) {
        return stationService.getStationDetail(stationId);
    }

    /**
     * 1.3 搜索充电站
     */
    @GetMapping("/search")
    public AjaxResult search(@RequestParam String keyword,
                             @RequestParam Double lat, @RequestParam Double lng,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        return stationService.searchStations(keyword, lat, lng, pageNum, pageSize);
    }

    /**
     * 1.3 搜索建议
     */
    @GetMapping("/suggest")
    public AjaxResult suggest(@RequestParam String keyword) {
        return stationService.getSuggestions(keyword);
    }

    /**
     * 商户端 - 获取当前商户的充电站列表（含今日统计数据，用于工作台首页）
     */
    @GetMapping("/merchant/list")
    public AjaxResult merchantList() {
        Long userId = SecurityUtils.getUserId();
        AppMerchant merchant = appMerchantService.selectAppMerchantByUserId(userId);
        if (merchant == null) {
            return AjaxResult.error("商户信息不存在");
        }
        return AjaxResult.success(chargingStationService.selectChargingStationListByMerchantId(merchant.getMerchantId()));
    }

    /**
     * 1.3 热门搜索
     */
    @GetMapping("/hot")
    public AjaxResult hot() {
        return stationService.getHotSearches();
    }

    /**
     * 收藏/取消收藏充电站
     */
    @PostMapping("/favorite")
    public AjaxResult favorite(@RequestParam Long stationId) {
        Long userId = SecurityUtils.getUserId();
        return stationService.toggleFavorite(userId, stationId);
    }

    /**
     * 查询收藏状态
     */
    @GetMapping("/favorite/status")
    public AjaxResult favoriteStatus(@RequestParam Long stationId) {
        Long userId = SecurityUtils.getUserId();
        return stationService.getFavoriteStatus(userId, stationId);
    }
}