package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.StadChargingStation;

public interface StadChargingStationMapper {
    StadChargingStation selectStadChargingStationById(Long stationId);
    List<StadChargingStation> selectStadChargingStationList(StadChargingStation station);
    int insertStadChargingStation(StadChargingStation station);
    int updateStadChargingStation(StadChargingStation station);
    int deleteStadChargingStationById(Long stationId);
    int deleteStadChargingStationByIds(Long[] stationIds);
}