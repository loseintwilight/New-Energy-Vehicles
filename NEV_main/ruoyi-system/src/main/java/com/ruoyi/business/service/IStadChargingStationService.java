package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.StadChargingStation;

public interface IStadChargingStationService {
    StadChargingStation selectStadChargingStationById(Long stationId);
    List<StadChargingStation> selectStadChargingStationList(StadChargingStation station);
    int insertStadChargingStation(StadChargingStation station);
    int updateStadChargingStation(StadChargingStation station);
    int deleteStadChargingStationByIds(Long[] stationIds);
}