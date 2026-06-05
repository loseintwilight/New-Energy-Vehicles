package com.ruoyi.newcar.mapper;

import com.ruoyi.newcar.domain.UsedCar;

import java.util.List;

public interface UsedCarMapper {
    UsedCar selectByVehicleId(Long vehicleId);
}