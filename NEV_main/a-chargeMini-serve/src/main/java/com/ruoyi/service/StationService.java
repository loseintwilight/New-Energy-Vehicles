package com.ruoyi.service;

import com.ruoyi.common.core.domain.AjaxResult;

import java.util.List;
import java.util.Map;

public interface StationService {

    /** 分页获取充电站列表 */
    AjaxResult getStationList(Double lat, Double lng, Integer pageNum, Integer pageSize,
                              String orderByColumn, String isAsc, String filter);

    /** 获取充电站详情 */
    AjaxResult getStationDetail(Long stationId);

    /** 搜索充电站 */
    AjaxResult searchStations(String keyword, Double lat, Double lng, Integer pageNum, Integer pageSize);

    /** 搜索建议 */
    AjaxResult getSuggestions(String keyword);

    /** 热门搜索 */
    AjaxResult getHotSearches();

    /** 获取城市列表 */
    AjaxResult getCityList();

    /** 收藏/取消收藏 */
    AjaxResult toggleFavorite(Long userId, Long stationId);

    /** 查询收藏状态 */
    AjaxResult getFavoriteStatus(Long userId, Long stationId);
}