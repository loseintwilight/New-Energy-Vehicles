package com.ruoyi.charging.mapper;

import com.ruoyi.charging.domain.ChargingRatePeriod;
import java.util.List;

/**
 * 充电费率时段Mapper接口
 * 
 * @author ruoyi
 */
public interface ChargingRatePeriodMapper 
{
    public ChargingRatePeriod selectChargingRatePeriodById(Long periodId);

    public List<ChargingRatePeriod> selectChargingRatePeriodList(ChargingRatePeriod period);

    public List<ChargingRatePeriod> selectChargingRatePeriodListByRateId(Long rateId);

    public int insertChargingRatePeriod(ChargingRatePeriod period);

    public int updateChargingRatePeriod(ChargingRatePeriod period);

    public int deleteChargingRatePeriodById(Long periodId);

    public int deleteChargingRatePeriodByRateId(Long rateId);
}
