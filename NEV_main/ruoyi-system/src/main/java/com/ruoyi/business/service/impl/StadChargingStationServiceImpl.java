package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.mapper.StadChargingStationMapper;
import com.ruoyi.business.domain.StadChargingStation;
import com.ruoyi.business.service.IStadChargingStationService;

@Service
public class StadChargingStationServiceImpl implements IStadChargingStationService {

    @Autowired
    private StadChargingStationMapper stadChargingStationMapper;

    @Override
    public StadChargingStation selectStadChargingStationById(Long stationId) {
        return stadChargingStationMapper.selectStadChargingStationById(stationId);
    }

    @Override
    public List<StadChargingStation> selectStadChargingStationList(StadChargingStation station) {
        return stadChargingStationMapper.selectStadChargingStationList(station);
    }

    @Override
    public int insertStadChargingStation(StadChargingStation station) {
        return stadChargingStationMapper.insertStadChargingStation(station);
    }

    @Override
    public int updateStadChargingStation(StadChargingStation station) {
        return stadChargingStationMapper.updateStadChargingStation(station);
    }

    @Override
    public int deleteStadChargingStationByIds(Long[] stationIds) {
        return stadChargingStationMapper.deleteStadChargingStationByIds(stationIds);
    }
}