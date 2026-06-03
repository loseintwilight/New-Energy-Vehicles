package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.mapper.StadVehicleMapper;
import com.ruoyi.business.domain.StadVehicle;
import com.ruoyi.business.service.IStadVehicleService;

@Service
public class StadVehicleServiceImpl implements IStadVehicleService {

    @Autowired
    private StadVehicleMapper stadVehicleMapper;

    @Override
    public StadVehicle selectStadVehicleById(Long vehicleId) {
        return stadVehicleMapper.selectStadVehicleById(vehicleId);
    }

    @Override
    public StadVehicle selectStadVehicleDetailById(Long vehicleId) {
        return stadVehicleMapper.selectStadVehicleDetailById(vehicleId);
    }

    @Override
    public List<StadVehicle> selectStadVehicleList(StadVehicle vehicle) {
        return stadVehicleMapper.selectStadVehicleList(vehicle);
    }

    @Override
    public int insertStadVehicle(StadVehicle vehicle) {
        return stadVehicleMapper.insertStadVehicle(vehicle);
    }

    @Override
    public int updateStadVehicle(StadVehicle vehicle) {
        return stadVehicleMapper.updateStadVehicle(vehicle);
    }

    @Override
    public int deleteStadVehicleByIds(Long[] vehicleIds) {
        return stadVehicleMapper.deleteStadVehicleByIds(vehicleIds);
    }
}