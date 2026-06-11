package com.ruoyi.charging.service.impl;

import com.ruoyi.charging.domain.ChargingRate;
import com.ruoyi.charging.mapper.ChargingRateMapper;
import com.ruoyi.charging.service.IChargingRateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

/**
 * 充电费率Service业务层处理
 *
 * @author ruoyi
 */
@Service
public class ChargingRateServiceImpl implements IChargingRateService
{
    @Autowired
    private ChargingRateMapper chargingRateMapper;

    @Override
    public List<ChargingRate> selectChargingRateList(ChargingRate rate)
    {
        return chargingRateMapper.selectChargingRateList(rate);
    }

    @Override
    public ChargingRate selectChargingRateById(Long rateId)
    {
        return chargingRateMapper.selectChargingRateById(rateId);
    }

    @Override
    public List<ChargingRate> selectChargingRateListByStationId(Long stationId)
    {
        return chargingRateMapper.selectChargingRateListByStationId(stationId);
    }

    @Override
    public int insertChargingRate(ChargingRate rate)
    {
        return chargingRateMapper.insertChargingRate(rate);
    }

    @Override
    public int updateChargingRate(ChargingRate rate)
    {
        return chargingRateMapper.updateChargingRate(rate);
    }

    @Override
    public int deleteChargingRateByIds(Long[] rateIds)
    {
        int rows = 0;
        for (Long rateId : rateIds)
        {
            rows += chargingRateMapper.deleteChargingRateById(rateId);
        }
        return rows;
    }
}
