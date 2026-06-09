package com.ruoyi.service.impl;

import com.ruoyi.domain.Vehicle;
import com.ruoyi.mapper.VehicleMapper;
import com.ruoyi.service.VehicleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Description: 车辆管理
 * @Author: 刘文丽
 * @CreateTime: 2026-06-05 21:17
 */
@Service
public class VehicleServiceImpl implements VehicleService {

    @Autowired
    private VehicleMapper vehicleMapper;

    @Override
    public Vehicle selectVehicleById(Long vehicleId) {
        return vehicleMapper.selectVehicleById(vehicleId);
    }

    @Override
    public Vehicle selectVehicleDetailById(Long vehicleId) {
        return vehicleMapper.selectVehicleDetailById(vehicleId);
    }

    @Override
    public List<Vehicle> selectVehicleList(Vehicle vehicle) {
        return vehicleMapper.selectVehicleList(vehicle);
    }

    @Override
    public int insertVehicle(Vehicle vehicle) {
        return vehicleMapper.insertVehicle(vehicle);
    }

    @Override
    public int updateVehicle(Vehicle vehicle) {
        return vehicleMapper.updateVehicle(vehicle);
    }

    @Override
    public int deleteVehicleByIds(Long[] vehicleIds) {
        int total = 0;
        for (Long id : vehicleIds) {
            total += vehicleMapper.deleteVehicleById(id);
        }
        return total;
    }

    @Override
    public int insertVehicleSpec(Vehicle.VehicleSpec spec) {
        return vehicleMapper.insertVehicleSpec(spec);
    }

    @Override
    public Object getDashboardStats() {
        return vehicleMapper.selectDashboardStats();
    }

    @Override
    public Object getVehicleSales(Long vehicleId) {
        return vehicleMapper.selectVehicleSales(vehicleId);

    }

    @Override
    public Vehicle selectVehicleBatteryDiagnosis(Long vehicleId) {
        return vehicleMapper.selectVehicleBatteryDiagnosis(vehicleId);
    }



}
