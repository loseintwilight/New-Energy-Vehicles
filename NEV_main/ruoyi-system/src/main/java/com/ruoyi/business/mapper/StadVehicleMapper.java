package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.StadVehicle;

public interface StadVehicleMapper {
    StadVehicle selectStadVehicleById(Long vehicleId);
    StadVehicle selectStadVehicleDetailById(Long vehicleId);
    List<StadVehicle> selectStadVehicleList(StadVehicle vehicle);
    int insertStadVehicle(StadVehicle vehicle);
    int updateStadVehicle(StadVehicle vehicle);
    int deleteStadVehicleById(Long vehicleId);
    int deleteStadVehicleByIds(Long[] vehicleIds);
}