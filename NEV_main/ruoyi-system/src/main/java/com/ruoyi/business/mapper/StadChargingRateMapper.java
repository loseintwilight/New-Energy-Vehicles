package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.StadChargingRate;

public interface StadChargingRateMapper {
    StadChargingRate selectStadChargingRateById(Long rateId);
    List<StadChargingRate> selectStadChargingRateList(StadChargingRate rate);
    List<StadChargingRate> selectStadChargingRateByStationId(Long stationId);
    int insertStadChargingRate(StadChargingRate rate);
    int updateStadChargingRate(StadChargingRate rate);
    int deleteStadChargingRateById(Long rateId);
    int deleteStadChargingRateByIds(Long[] rateIds);
}