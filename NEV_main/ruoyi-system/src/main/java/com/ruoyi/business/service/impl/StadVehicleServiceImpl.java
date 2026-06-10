package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.business.mapper.StadVehicleMapper;
import com.ruoyi.business.mapper.StadVehicleSpecMapper;
import com.ruoyi.business.domain.StadVehicle;
import com.ruoyi.business.domain.StadVehicleSpec;
import com.ruoyi.business.service.IStadVehicleService;

@Service
public class StadVehicleServiceImpl implements IStadVehicleService {

    @Autowired
    private StadVehicleMapper stadVehicleMapper;

    @Autowired
    private StadVehicleSpecMapper stadVehicleSpecMapper;

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
    @Transactional
    public int insertStadVehicle(StadVehicle vehicle) {
        int rows = stadVehicleMapper.insertStadVehicle(vehicle);
        // 同时保存车辆规格
        saveVehicleSpec(vehicle);
        return rows;
    }

    @Override
    @Transactional
    public int updateStadVehicle(StadVehicle vehicle) {
        int rows = stadVehicleMapper.updateStadVehicle(vehicle);
        // 同时保存车辆规格
        saveVehicleSpec(vehicle);
        return rows;
    }

    @Override
    public int deleteStadVehicleByIds(Long[] vehicleIds) {
        return stadVehicleMapper.deleteStadVehicleByIds(vehicleIds);
    }

    /**
     * 保存车辆规格（新增或更新）
     */
    private void saveVehicleSpec(StadVehicle vehicle) {
        if (vehicle.getRangeKm() != null || vehicle.getBatteryCapacity() != null
                || vehicle.getChargeTimeFast() != null || vehicle.getChargeTimeSlow() != null
                || vehicle.getModelYear() != null) {
            List<StadVehicleSpec> existingSpecs = stadVehicleSpecMapper.selectStadVehicleSpecByVehicleId(vehicle.getVehicleId());
            StadVehicleSpec spec;
            if (existingSpecs != null && !existingSpecs.isEmpty()) {
                spec = existingSpecs.get(0);
            } else {
                spec = new StadVehicleSpec();
                spec.setVehicleId(vehicle.getVehicleId());
            }
            spec.setRangeKm(vehicle.getRangeKm());
            spec.setBatteryCapacity(vehicle.getBatteryCapacity());
            spec.setChargeTimeFast(vehicle.getChargeTimeFast());
            spec.setChargeTimeSlow(vehicle.getChargeTimeSlow());
            spec.setModelYear(vehicle.getModelYear());

            if (existingSpecs != null && !existingSpecs.isEmpty()) {
                stadVehicleSpecMapper.updateStadVehicleSpec(spec);
            } else {
                stadVehicleSpecMapper.insertStadVehicleSpec(spec);
            }
        }
    }
}