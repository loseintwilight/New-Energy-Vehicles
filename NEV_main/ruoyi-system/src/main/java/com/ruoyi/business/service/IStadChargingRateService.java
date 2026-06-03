package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.StadChargingRate;

public interface IStadChargingRateService {
    StadChargingRate selectStadChargingRateById(Long rateId);
    List<StadChargingRate> selectStadChargingRateList(StadChargingRate rate);
    List<StadChargingRate> selectStadChargingRateByStationId(Long stationId);
    int insertStadChargingRate(StadChargingRate rate);
    int updateStadChargingRate(StadChargingRate rate);
    int deleteStadChargingRateByIds(Long[] rateIds);
}