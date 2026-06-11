package com.ruoyi.charging.service;

import com.ruoyi.charging.domain.ChargingRatePeriod;
import java.util.List;

/**
 * 充电费率时段Service接口
 *
 * @author ruoyi
 */
public interface IChargingRatePeriodService
{
    public List<ChargingRatePeriod> selectChargingRatePeriodList(ChargingRatePeriod period);

    public ChargingRatePeriod selectChargingRatePeriodById(Long periodId);

    public List<ChargingRatePeriod> selectChargingRatePeriodListByRateId(Long rateId);

    public int insertChargingRatePeriod(ChargingRatePeriod period);

    public int updateChargingRatePeriod(ChargingRatePeriod period);

    public int deleteChargingRatePeriodByIds(Long[] periodIds);

    public int deleteChargingRatePeriodByRateId(Long rateId);
}
