package com.ruoyi.mapper;

import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

public interface PileMapper {

    /** 根据充电站ID获取充电桩列表 */
    List<Map<String, Object>> selectPileListByStationId(@Param("stationId") Long stationId);

    /** 根据桩编号获取充电桩 */
    Map<String, Object> selectPileByPileNo(@Param("stationId") Long stationId, @Param("pileNo") String pileNo);

    /** 更新充电桩状态 */
    int updatePileStatus(@Param("pileId") Long pileId, @Param("status") String status);
}