package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.StadChargingRatePeriod;

public interface IStadChargingRatePeriodService {
    StadChargingRatePeriod selectStadChargingRatePeriodById(Long periodId);
    List<StadChargingRatePeriod> selectStadChargingRatePeriodList(StadChargingRatePeriod period);
    List<StadChargingRatePeriod> selectStadChargingRatePeriodByRateId(Long rateId);
    int insertStadChargingRatePeriod(StadChargingRatePeriod period);
    int updateStadChargingRatePeriod(StadChargingRatePeriod period);
    int deleteStadChargingRatePeriodByIds(Long[] periodIds);
}