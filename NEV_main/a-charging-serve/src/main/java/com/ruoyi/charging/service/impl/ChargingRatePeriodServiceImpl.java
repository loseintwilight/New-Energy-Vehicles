package com.ruoyi.charging.service.impl;

import com.ruoyi.charging.domain.ChargingRatePeriod;
import com.ruoyi.charging.mapper.ChargingRatePeriodMapper;
import com.ruoyi.charging.service.IChargingRatePeriodService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

/**
 * 充电费率时段Service业务层处理
 *
 * @author ruoyi
 */
@Service
public class ChargingRatePeriodServiceImpl implements IChargingRatePeriodService
{
    @Autowired
    private ChargingRatePeriodMapper chargingRatePeriodMapper;

    @Override
    public List<ChargingRatePeriod> selectChargingRatePeriodList(ChargingRatePeriod period)
    {
        return chargingRatePeriodMapper.selectChargingRatePeriodList(period);
    }

    @Override
    public ChargingRatePeriod selectChargingRatePeriodById(Long periodId)
    {
        return chargingRatePeriodMapper.selectChargingRatePeriodById(periodId);
    }

    @Override
    public List<ChargingRatePeriod> selectChargingRatePeriodListByRateId(Long rateId)
    {
        return chargingRatePeriodMapper.selectChargingRatePeriodListByRateId(rateId);
    }

    @Override
    public int insertChargingRatePeriod(ChargingRatePeriod period)
    {
        return chargingRatePeriodMapper.insertChargingRatePeriod(period);
    }

    @Override
    public int updateChargingRatePeriod(ChargingRatePeriod period)
    {
        return chargingRatePeriodMapper.updateChargingRatePeriod(period);
    }

    @Override
    public int deleteChargingRatePeriodByIds(Long[] periodIds)
    {
        int rows = 0;
        for (Long periodId : periodIds)
        {
            rows += chargingRatePeriodMapper.deleteChargingRatePeriodById(periodId);
        }
        return rows;
    }

    @Override
    public int deleteChargingRatePeriodByRateId(Long rateId)
    {
        return chargingRatePeriodMapper.deleteChargingRatePeriodByRateId(rateId);
    }
}
