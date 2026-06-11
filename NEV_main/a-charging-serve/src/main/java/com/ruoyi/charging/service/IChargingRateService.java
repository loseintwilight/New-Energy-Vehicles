package com.ruoyi.charging.service;

import com.ruoyi.charging.domain.ChargingRate;
import java.util.List;

/**
 * 充电费率Service接口
 *
 * @author ruoyi
 */
public interface IChargingRateService
{
    public List<ChargingRate> selectChargingRateList(ChargingRate rate);

    public ChargingRate selectChargingRateById(Long rateId);

    public List<ChargingRate> selectChargingRateListByStationId(Long stationId);

    public int insertChargingRate(ChargingRate rate);

    public int updateChargingRate(ChargingRate rate);

    public int deleteChargingRateByIds(Long[] rateIds);
}
