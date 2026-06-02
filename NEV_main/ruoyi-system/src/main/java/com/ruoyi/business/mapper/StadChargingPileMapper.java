package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.StadChargingPile;

public interface StadChargingPileMapper {
    StadChargingPile selectStadChargingPileById(Long pileId);
    List<StadChargingPile> selectStadChargingPileList(StadChargingPile pile);
    List<StadChargingPile> selectStadChargingPileByStationId(Long stationId);
    int insertStadChargingPile(StadChargingPile pile);
    int updateStadChargingPile(StadChargingPile pile);
    int deleteStadChargingPileById(Long pileId);
    int deleteStadChargingPileByIds(Long[] pileIds);
}