package com.ruoyi.mapper;

import com.ruoyi.business.domain.StadChargingStation;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

public interface StationMapper {

    /** 分页查询充电站列表（带距离计算） */
    List<Map<String, Object>> selectStationListWithDistance(@Param("lat") Double lat, @Param("lng") Double lng,
                                                           @Param("offset") Integer offset, @Param("limit") Integer limit,
                                                           @Param("orderByColumn") String orderByColumn,
                                                           @Param("isAsc") String isAsc, @Param("filter") String filter);

    /** 查询充电站总数 */
    Long selectStationCount(@Param("filter") String filter);

    /** 搜索充电站 */
    List<Map<String, Object>> searchStations(@Param("keyword") String keyword, @Param("lat") Double lat,
                                            @Param("lng") Double lng,
                                            @Param("offset") Integer offset, @Param("limit") Integer limit);

    /** 搜索充电站总数 */
    Long searchStationCount(@Param("keyword") String keyword);

    /** 搜索建议 */
    List<Map<String, Object>> selectSuggestions(@Param("keyword") String keyword);

    /** 获取所有可用城市（去重） */
    List<Map<String, Object>> selectCityList();

    /** 获取充电站基本详情 */
    StadChargingStation selectStationById(@Param("stationId") Long stationId);

    /** 获取充电站关联费率 */
    List<Map<String, Object>> selectRatesByStationId(@Param("stationId") Long stationId);

    /** 获取热门搜索（按搜索次数） */
    List<Map<String, Object>> selectHotSearches();
}