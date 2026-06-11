package com.ruoyi.charging.mapper;

import com.ruoyi.charging.domain.ChargingRate;
import java.util.List;

/**
 * 充电费率Mapper接口
 * 
 * @author ruoyi
 */
public interface ChargingRateMapper 
{
    public ChargingRate selectChargingRateById(Long rateId);

    public List<ChargingRate> selectChargingRateList(ChargingRate rate);

    public List<ChargingRate> selectChargingRateListByStationId(Long stationId);

    public int insertChargingRate(ChargingRate rate);

    public int updateChargingRate(ChargingRate rate);

    public int deleteChargingRateById(Long rateId);
}
