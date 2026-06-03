package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.mapper.StadChargingRatePeriodMapper;
import com.ruoyi.business.domain.StadChargingRatePeriod;
import com.ruoyi.business.service.IStadChargingRatePeriodService;

@Service
public class StadChargingRatePeriodServiceImpl implements IStadChargingRatePeriodService {

    @Autowired
    private StadChargingRatePeriodMapper stadChargingRatePeriodMapper;

    @Override
    public StadChargingRatePeriod selectStadChargingRatePeriodById(Long periodId) {
        return stadChargingRatePeriodMapper.selectStadChargingRatePeriodById(periodId);
    }

    @Override
    public List<StadChargingRatePeriod> selectStadChargingRatePeriodList(StadChargingRatePeriod period) {
        return stadChargingRatePeriodMapper.selectStadChargingRatePeriodList(period);
    }

    @Override
    public List<StadChargingRatePeriod> selectStadChargingRatePeriodByRateId(Long rateId) {
        return stadChargingRatePeriodMapper.selectStadChargingRatePeriodByRateId(rateId);
    }

    @Override
    public int insertStadChargingRatePeriod(StadChargingRatePeriod period) {
        return stadChargingRatePeriodMapper.insertStadChargingRatePeriod(period);
    }

    @Override
    public int updateStadChargingRatePeriod(StadChargingRatePeriod period) {
        return stadChargingRatePeriodMapper.updateStadChargingRatePeriod(period);
    }

    @Override
    public int deleteStadChargingRatePeriodByIds(Long[] periodIds) {
        return stadChargingRatePeriodMapper.deleteStadChargingRatePeriodByIds(periodIds);
    }
}