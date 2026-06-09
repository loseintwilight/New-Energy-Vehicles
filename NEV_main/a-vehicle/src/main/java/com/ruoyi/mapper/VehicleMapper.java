package com.ruoyi.mapper;

import com.ruoyi.domain.Vehicle;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;


@Mapper
public interface VehicleMapper {

    Vehicle selectVehicleById(Long vehicleId);

    Vehicle selectVehicleDetailById(Long vehicleId);

    List<Vehicle> selectVehicleList(Vehicle vehicle);

    int insertVehicle(Vehicle vehicle);

    int updateVehicle(Vehicle vehicle);

    int deleteVehicleById(Long vehicleId);

    int deleteVehicleByIds(Long[] vehicleIds);

    int insertVehicleSpec(Vehicle.VehicleSpec spec);

    Object selectDashboardStats();

    Object selectVehicleSales(Long vehicleId);

    Vehicle selectVehicleBatteryDiagnosis(Long vehicleId);



}
