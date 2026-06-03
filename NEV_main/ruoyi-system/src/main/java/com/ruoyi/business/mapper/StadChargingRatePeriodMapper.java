package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.StadChargingRatePeriod;

public interface StadChargingRatePeriodMapper {
    StadChargingRatePeriod selectStadChargingRatePeriodById(Long periodId);
    List<StadChargingRatePeriod> selectStadChargingRatePeriodList(StadChargingRatePeriod period);
    List<StadChargingRatePeriod> selectStadChargingRatePeriodByRateId(Long rateId);
    int insertStadChargingRatePeriod(StadChargingRatePeriod period);
    int updateStadChargingRatePeriod(StadChargingRatePeriod period);
    int deleteStadChargingRatePeriodById(Long periodId);
    int deleteStadChargingRatePeriodByIds(Long[] periodIds);
}