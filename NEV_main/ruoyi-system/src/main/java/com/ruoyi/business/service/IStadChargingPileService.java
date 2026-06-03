package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.StadChargingPile;

public interface IStadChargingPileService {
    StadChargingPile selectStadChargingPileById(Long pileId);
    List<StadChargingPile> selectStadChargingPileList(StadChargingPile pile);
    List<StadChargingPile> selectStadChargingPileByStationId(Long stationId);
    int insertStadChargingPile(StadChargingPile pile);
    int updateStadChargingPile(StadChargingPile pile);
    int deleteStadChargingPileByIds(Long[] pileIds);
}