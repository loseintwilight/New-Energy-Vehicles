package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.mapper.StadChargingRateMapper;
import com.ruoyi.business.domain.StadChargingRate;
import com.ruoyi.business.service.IStadChargingRateService;

@Service
public class StadChargingRateServiceImpl implements IStadChargingRateService {

    @Autowired
    private StadChargingRateMapper stadChargingRateMapper;

    @Override
    public StadChargingRate selectStadChargingRateById(Long rateId) {
        return stadChargingRateMapper.selectStadChargingRateById(rateId);
    }

    @Override
    public List<StadChargingRate> selectStadChargingRateList(StadChargingRate rate) {
        return stadChargingRateMapper.selectStadChargingRateList(rate);
    }

    @Override
    public List<StadChargingRate> selectStadChargingRateByStationId(Long stationId) {
        return stadChargingRateMapper.selectStadChargingRateByStationId(stationId);
    }

    @Override
    public int insertStadChargingRate(StadChargingRate rate) {
        return stadChargingRateMapper.insertStadChargingRate(rate);
    }

    @Override
    public int updateStadChargingRate(StadChargingRate rate) {
        return stadChargingRateMapper.updateStadChargingRate(rate);
    }

    @Override
    public int deleteStadChargingRateByIds(Long[] rateIds) {
        return stadChargingRateMapper.deleteStadChargingRateByIds(rateIds);
    }
}