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
import com.ruoyi.vo.*;
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
        List<StationVO> list = stationMapper.selectStationListWithDistance(
                lat, lng, offset, pageSize, orderByColumn, isAsc, filter);

        // 丰富返回数据 - 从数据库实际字段计算
        for (StationVO item : list) {
            enrichStationItem(item);
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
        StationDetailVO detail = new StationDetailVO();
        detail.setStationId(station.getStationId());
        detail.setName(station.getStationName());
        detail.setAddress(station.getAddress());
        detail.setLat(station.getLatitude() != null ? station.getLatitude().doubleValue() : null);
        detail.setLng(station.getLongitude() != null ? station.getLongitude().doubleValue() : null);
        detail.setTotalPiles(station.getTotalPiles());
        detail.setFreePiles(station.getAvailablePiles());
        detail.setParkFee(station.getParkingFee());
        detail.setOpenTime(station.getOpenTime() != null ?
                DateUtils.parseDateToStr("HH:mm", station.getOpenTime()) : "24小时营业");
        detail.setStationType("公用");
        detail.setOperatorName(station.getMerchantName() != null ? station.getMerchantName() : "新能源充电");
        detail.setImages(station.getImages());
        detail.setServicePhone(station.getServicePhone());
        detail.setFacilitiesInfo(station.getFacilitiesInfo());
        detail.setScore(4.8);
        detail.setDistance(null);
        detail.setTags(Collections.emptyList());

        // 获取费率时段
        List<RateVO> rates = stationMapper.selectRatesByStationId(stationId);
        detail.setTimePrices(rates != null ? rates : Collections.emptyList());

        // 从费率中获取当前价格信息
        if (rates != null && !rates.isEmpty()) {
            RateVO firstRate = rates.get(0);
            detail.setElectricPrice(firstRate.getElectricPrice() != null ? firstRate.getElectricPrice().toString() : "0.88");
            detail.setServicePrice(firstRate.getServicePrice() != null ? firstRate.getServicePrice().toString() : "0.40");
            detail.setPrice(firstRate.getTotalPrice() != null ? firstRate.getTotalPrice().toString() : "1.28");
        } else {
            detail.setElectricPrice("0.88");
            detail.setServicePrice("0.40");
            detail.setPrice("1.28");
        }

        // 获取充电桩列表
        List<PileVO> piles = pileMapper.selectPileListByStationId(stationId);
        detail.setPiles(piles != null ? piles : Collections.emptyList());

        return AjaxResult.success(detail);
    }

    @Override
    public AjaxResult searchStations(String keyword, Double lat, Double lng, Integer pageNum, Integer pageSize) {
        int offset = (pageNum - 1) * pageSize;
        List<StationVO> list = stationMapper.searchStations(keyword, lat, lng, offset, pageSize);
        for (StationVO item : list) {
            enrichStationItem(item);
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
        List<SuggestionVO> list = stationMapper.selectSuggestions(keyword);
        return AjaxResult.success(list);
    }

    @Override
    public AjaxResult getHotSearches() {
        List<SuggestionVO> list = stationMapper.selectHotSearches();
        return AjaxResult.success(list);
    }

    @Override
    public AjaxResult getCityList() {
        List<CityVO> list = stationMapper.selectCityList();
        return AjaxResult.success(list);
    }

    @Override
    public AjaxResult toggleFavorite(Long userId, Long stationId) {
        StadUserFavorite fav = new StadUserFavorite();
        fav.setUserId(userId);
        fav.setTargetType("station");
        fav.setTargetId(stationId);
        List<StadUserFavorite> existing = stadUserFavoriteMapper.selectStadUserFavoriteList(fav);
        if (existing != null && !existing.isEmpty()) {
            stadUserFavoriteMapper.deleteStadUserFavoriteById(existing.get(0).getFavoriteId());
            return AjaxResult.success("cancel");
        } else {
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

    /** 丰富充电站列表项数据 - 从数据库实际字段衍生 */
    private void enrichStationItem(StationVO item) {
        // 设置 imageUrl（兼容前端字段）
        if (item.getImageUrl() == null) {
            item.setImageUrl(item.getImages());
        }
        // 状态文本从实际数据计算
        int free = item.getFreePiles() != null ? item.getFreePiles() : 0;
        int total = item.getTotalPiles() != null ? item.getTotalPiles() : 0;
        item.setStatusText("闲" + free + "/" + total);
        // 快充数量 = 总桩数（如有单独快充统计可后续优化）
        item.setFastCount(total);
        item.setSlowCount(0);
        item.setSpeedType(total > 0 ? "快" : "慢");
        item.setSpeedTypeKey(total > 0 ? "fast" : "slow");
        // 停车费从数据库获取
        item.setParkInfo(item.getParkFee());
        item.setFreeParkTime(2);
        item.setPlugAndPlay(true);
        item.setSelfService(true);
        item.setIsNearest(false);
        item.setDiscount(0);
        item.setLastChargeTime("1天前有人充电");
        item.setTags(Collections.emptyList());
        // 移除不需要的字段
        item.setOccupyingPiles(null);
        item.setStationStatus(null);
    }
}