package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.StadVehicleFinancePlan;

public interface IStadVehicleFinancePlanService {
    StadVehicleFinancePlan selectStadVehicleFinancePlanById(Long planId);
    List<StadVehicleFinancePlan> selectStadVehicleFinancePlanList(StadVehicleFinancePlan plan);
    List<StadVehicleFinancePlan> selectStadVehicleFinancePlanByVehicleId(Long vehicleId);
    int insertStadVehicleFinancePlan(StadVehicleFinancePlan plan);
    int updateStadVehicleFinancePlan(StadVehicleFinancePlan plan);
    int deleteStadVehicleFinancePlanByIds(Long[] planIds);
}