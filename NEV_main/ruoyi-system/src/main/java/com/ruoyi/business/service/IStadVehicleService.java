package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.StadVehicle;

public interface IStadVehicleService {
    StadVehicle selectStadVehicleById(Long vehicleId);
    StadVehicle selectStadVehicleDetailById(Long vehicleId);
    List<StadVehicle> selectStadVehicleList(StadVehicle vehicle);
    int insertStadVehicle(StadVehicle vehicle);
    int updateStadVehicle(StadVehicle vehicle);
    int deleteStadVehicleByIds(Long[] vehicleIds);
}