package com.ruoyi.newcar.service.impl;

import com.ruoyi.newcar.domain.VehicleSpec;
import com.ruoyi.newcar.mapper.VehicleSpecMapper;
import com.ruoyi.newcar.service.VehicleSpecService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class VehicleSpecServiceImpl implements VehicleSpecService {

    @Autowired
    private VehicleSpecMapper vehicleSpecMapper;

    @Override
    public VehicleSpec selectByVehicleId(Long vehicleId) {
        return vehicleSpecMapper.selectByVehicleId(vehicleId);
    }
}