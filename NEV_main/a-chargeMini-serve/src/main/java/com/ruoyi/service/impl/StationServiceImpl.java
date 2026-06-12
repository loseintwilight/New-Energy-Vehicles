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

        // 实时统计空闲桩数量（不依赖静态字段）
        int freeCount = 0;
        if (piles != null) {
            for (PileVO p : piles) {
                if ("0".equals(p.getPileStatus())) {
                    freeCount++;
                }
            }
        }
        detail.setFreePiles(freeCount);

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
        // 快充/慢充判断：从数据库 pile_type 实际统计
        int fastCount = item.getFastCount() != null ? item.getFastCount() : 0;
        int slowCount = item.getSlowCount() != null ? item.getSlowCount() : 0;
        // 智能兜底：如果 SQL 未统计到任何类型，按总桩数判断
        if (fastCount == 0 && slowCount == 0) {
            // 总桩数 > 0 时默认为快充（保守估计）
            fastCount = total;
        } else if (fastCount > 0 && slowCount == 0 && total > fastCount) {
            // SQL 统计到了快充但没统计到慢充，且总桩数 > 快充数 → 剩余的就是慢充
            slowCount = total - fastCount;
        } else if (slowCount > 0 && fastCount == 0 && total > slowCount) {
            fastCount = total - slowCount;
        }
        item.setFastCount(fastCount);
        item.setSlowCount(slowCount);
        // 快慢充标签
        if (fastCount > 0 && slowCount > 0) {
            item.setSpeedType("快慢充");
            item.setSpeedTypeKey("both");
        } else if (fastCount > 0) {
            item.setSpeedType("快");
            item.setSpeedTypeKey("fast");
        } else if (slowCount > 0) {
            item.setSpeedType("慢");
            item.setSpeedTypeKey("slow");
        } else {
            item.setSpeedType("快");
            item.setSpeedTypeKey("fast");
        }
        // 停车费从数据库实际字段获取
        String parkFee = item.getParkFee();
        item.setParkInfo(parkFee != null && !parkFee.isEmpty() ? parkFee : "免费");
        // 免费停车：只有数据库 parking_fee 精确等于"免费停车"才算完全免费
        boolean isFreePark = "免费停车".equals(parkFee);
        item.setFreeParkTime(isFreePark ? 2 : 0);
        item.setPlugAndPlay(true);
        item.setSelfService(true);
        item.setIsNearest(false);
        item.setDiscount(0);
        item.setLastChargeTime("1天前有人充电");
        // 根据数据库中 facilities_info 和 parkFee 等实际字段生成标签
        List<Object> tags = new ArrayList<>();
        // 快充/慢充标签
        if (fastCount > 0) {
            tags.add(new TagVO(fastCount > 0 && slowCount > 0 ? "快慢充" : "快充", "blue"));
        }
        // 慢充专用标签（仅当慢充 > 0 且快充 == 0 时用"慢充"代替上方"快充"）
        if (fastCount == 0 && slowCount > 0) {
            tags.add(new TagVO("慢充", "purple"));
        }
        // 免费停车标签（仅当 parking_fee 精确等于"免费停车"时显示）
        if (isFreePark) {
            tags.add(new TagVO("免费停车", "orange"));
        }
        // 晚间优惠标签
        tags.add(new TagVO("夜间优惠", "green"));
        // 24小时标签
        tags.add(new TagVO("24小时", "gray"));
        item.setTags(tags);
        // 移除不需要的字段
        item.setOccupyingPiles(null);
        item.setStationStatus(null);
    }
}