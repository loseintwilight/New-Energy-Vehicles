package com.ruoyi.mapper;

import com.ruoyi.business.domain.StadChargingStation;
import com.ruoyi.vo.CityVO;
import com.ruoyi.vo.PileVO;
import com.ruoyi.vo.RateVO;
import com.ruoyi.vo.StationVO;
import com.ruoyi.vo.SuggestionVO;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface StationMapper {

    /** 分页查询充电站列表（带距离计算） */
    List<StationVO> selectStationListWithDistance(@Param("lat") Double lat, @Param("lng") Double lng,
                                                  @Param("offset") Integer offset, @Param("limit") Integer limit,
                                                  @Param("orderByColumn") String orderByColumn,
                                                  @Param("isAsc") String isAsc, @Param("filter") String filter);

    /** 查询充电站总数 */
    Long selectStationCount(@Param("filter") String filter);

    /** 搜索充电站 */
    List<StationVO> searchStations(@Param("keyword") String keyword, @Param("lat") Double lat,
                                   @Param("lng") Double lng,
                                   @Param("offset") Integer offset, @Param("limit") Integer limit);

    /** 搜索充电站总数 */
    Long searchStationCount(@Param("keyword") String keyword);

    /** 搜索建议 */
    List<SuggestionVO> selectSuggestions(@Param("keyword") String keyword);

    /** 获取所有可用城市（去重） */
    List<CityVO> selectCityList();

    /** 获取充电站基本详情 */
    StadChargingStation selectStationById(@Param("stationId") Long stationId);

    /** 获取充电站关联费率 */
    List<RateVO> selectRatesByStationId(@Param("stationId") Long stationId);

    /** 获取热门搜索 */
    List<SuggestionVO> selectHotSearches();

    /** 根据实际pile_status重新计算站点的可用/占用桩数并更新 */
    int syncStationPileCounts(@Param("stationId") Long stationId);
}