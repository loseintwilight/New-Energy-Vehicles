package com.ruoyi.mapper;

import com.ruoyi.vo.PileVO;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface PileMapper {

    /** 根据充电站ID获取充电桩列表 */
    List<PileVO> selectPileListByStationId(@Param("stationId") Long stationId);

    /** 根据桩编号获取充电桩 */
    PileVO selectPileByPileNo(@Param("stationId") Long stationId, @Param("pileNo") String pileNo);

    /** 更新充电桩状态 */
    int updatePileStatus(@Param("pileId") Long pileId, @Param("status") String status);
}