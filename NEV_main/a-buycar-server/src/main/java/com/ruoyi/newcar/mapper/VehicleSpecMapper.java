package com.ruoyi.newcar.mapper;

import com.ruoyi.newcar.domain.VehicleSpec;

import java.util.List;

public interface VehicleSpecMapper {
    VehicleSpec selectByVehicleId(Long vehicleId);

    List<VehicleSpec> selectListByVehicleId(Long vehicleId);
}