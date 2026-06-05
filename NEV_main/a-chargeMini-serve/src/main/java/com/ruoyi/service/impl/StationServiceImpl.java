package com.ruoyi.service.impl;

import com.ruoyi.business.domain.StadChargingStation;
import com.ruoyi.business.domain.StadUserFavorite;
import com.ruoyi.business.mapper.StadChargingStationMapper;
import com.ruoyi.business.mapper.StadUserFavoriteMapper;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.mapper.PileMapper;
import com.ruoyi.mapper.StationMapper;
import com.ruoyi.service.StationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class StationServiceImpl implements StationService {

    @Autowired
    private StationMapper stationMapper;

    @Autowired
    private PileMapper pileMapper;

    @Autowired
    private StadChargingStationMapper stadChargingStationMapper;

    @Autowired
    private StadUserFavoriteMapper stadUserFavoriteMapper;

    @Override
    public AjaxResult getStationList(Double lat, Double lng, Integer pageNum, Integer pageSize,
                                     String orderByColumn, String isAsc, String filter) {
        if (lat == null || lng == null) {
            return AjaxResult.error("缺少经纬度参数");
        }
        int offset = (pageNum - 1) * pageSize;
        List<Map<String, Object>> list = stationMapper.selectStationListWithDistance(
                lat, lng, offset, pageSize, orderByColumn, isAsc, filter);

        // 丰富返回数据
        for (Map<String, Object> item : list) {
            enrichStationItem(item, lat, lng);
        }

        Long total = stationMapper.selectStationCount(filter);
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("rows", list);
        result.put("total", total);
        return AjaxResult.success(result);
    }

    @Override
    public AjaxResult getStationDetail(Long stationId) {
        StadChargingStation station = stationMapper.selectStationById(stationId);
        if (station == null) {
            return AjaxResult.error("充电站不存在");
        }
        Map<String, Object> detail = new LinkedHashMap<>();
        detail.put("stationId", station.getStationId());
        detail.put("name", station.getStationName());
        detail.put("address", station.getAddress());
        detail.put("lat", station.getLatitude());
        detail.put("lng", station.getLongitude());
        detail.put("totalPiles", station.getTotalPiles());
        detail.put("freePiles", station.getAvailablePiles());
        detail.put("parkFee", station.getParkingFee());
        detail.put("openTime", station.getOpenTime() != null ?
                DateUtils.parseDateToStr("HH:mm", station.getOpenTime()) : "24小时营业");
        detail.put("stationType", "公用");
        detail.put("operatorName", "新能源充电");
        detail.put("images", station.getImages());
        detail.put("servicePhone", station.getServicePhone());
        detail.put("facilitiesInfo", station.getFacilitiesInfo());
        detail.put("score", 4.8);
        detail.put("price", "1.28");

        // 获取费率时段
        List<Map<String, Object>> rates = stationMapper.selectRatesByStationId(stationId);
        detail.put("timePrices", rates != null ? rates : Collections.emptyList());

        // 获取充电桩列表
        List<Map<String, Object>> piles = pileMapper.selectPileListByStationId(stationId);
        detail.put("piles", piles != null ? piles : Collections.emptyList());

        return AjaxResult.success(detail);
    }

    @Override
    public AjaxResult searchStations(String keyword, Double lat, Double lng, Integer pageNum, Integer pageSize) {
        int offset = (pageNum - 1) * pageSize;
        List<Map<String, Object>> list = stationMapper.searchStations(keyword, lat, lng, offset, pageSize);
        for (Map<String, Object> item : list) {
            enrichStationItem(item, lat, lng);
        }
        Long total = stationMapper.searchStationCount(keyword);
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("rows", list);
        result.put("total", total);
        return AjaxResult.success(result);
    }

    @Override
    public AjaxResult getSuggestions(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return AjaxResult.success(Collections.emptyList());
        }
        List<Map<String, Object>> list = stationMapper.selectSuggestions(keyword);
        return AjaxResult.success(list);
    }

    @Override
    public AjaxResult getHotSearches() {
        List<Map<String, Object>> list = stationMapper.selectHotSearches();
        return AjaxResult.success(list);
    }

    @Override
    public AjaxResult getCityList() {
        List<Map<String, Object>> list = stationMapper.selectCityList();
        return AjaxResult.success(list);
    }

    @Override
    public AjaxResult toggleFavorite(Long userId, Long stationId) {
        // 检查是否已收藏
        StadUserFavorite fav = new StadUserFavorite();
        fav.setUserId(userId);
        fav.setTargetType("station");
        fav.setTargetId(stationId);
        List<StadUserFavorite> existing = stadUserFavoriteMapper.selectStadUserFavoriteList(fav);
        if (existing != null && !existing.isEmpty()) {
            // 已收藏，取消收藏
            stadUserFavoriteMapper.deleteStadUserFavoriteById(existing.get(0).getFavoriteId());
            return AjaxResult.success("cancel");
        } else {
            // 未收藏，添加收藏
            fav.setCreateTime(DateUtils.getNowDate());
            stadUserFavoriteMapper.insertStadUserFavorite(fav);
            return AjaxResult.success("favorite");
        }
    }

    @Override
    public AjaxResult getFavoriteStatus(Long userId, Long stationId) {
        StadUserFavorite fav = new StadUserFavorite();
        fav.setUserId(userId);
        fav.setTargetType("station");
        fav.setTargetId(stationId);
        List<StadUserFavorite> existing = stadUserFavoriteMapper.selectStadUserFavoriteList(fav);
        return AjaxResult.success(existing != null && !existing.isEmpty());
    }

    /** 丰富充电站列表项数据 */
    private void enrichStationItem(Map<String, Object> item, Double lat, Double lng) {
        Object distanceObj = item.get("distance");
        if (distanceObj != null) {
            item.put("distance", distanceObj.toString());
        }
        item.put("score", 4.8); // 可后续从评价表统计
        item.put("speedType", "快");
        item.put("speedTypeKey", "fast");
        item.put("statusText", "闲" + item.get("freePiles") + "/" + item.get("totalPiles"));
        item.put("lastChargeTime", "1天前有人充电");
        item.put("plugAndPlay", true);
        item.put("selfService", true);
        item.put("isNearest", false);
        item.put("discount", 0);
        item.put("freeParkTime", 2);
        item.put("parkInfo", item.get("parkFee"));
        item.put("price", "1.28");
        item.put("electricPrice", "0.88");
        item.put("servicePrice", "0.40");
        item.put("fastCount", item.get("totalPiles"));
        item.put("slowCount", 0);
        item.put("tags", Arrays.asList(
                Collections.singletonMap("text", "新人券可用"),
                Collections.singletonMap("type", "blue")
        ));
        // 移除不需要的字段
        item.remove("occupyingPiles");
        item.remove("stationStatus");
    }
}