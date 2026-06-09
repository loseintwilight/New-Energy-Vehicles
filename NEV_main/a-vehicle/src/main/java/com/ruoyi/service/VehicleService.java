package com.ruoyi.service;

import com.ruoyi.domain.Vehicle;

import java.util.List;


public interface VehicleService {

    Vehicle selectVehicleById(Long vehicleId);

    Vehicle selectVehicleDetailById(Long vehicleId);

    List<Vehicle> selectVehicleList(Vehicle vehicle);

    int insertVehicle(Vehicle vehicle);

    int updateVehicle(Vehicle vehicle);

    int deleteVehicleByIds(Long[] vehicleIds);

    int insertVehicleSpec(Vehicle.VehicleSpec spec);

    Object getDashboardStats();

    Object getVehicleSales(Long vehicleId);

    Vehicle selectVehicleBatteryDiagnosis(Long vehicleId);


}
