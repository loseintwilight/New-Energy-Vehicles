package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.StadVehicleFinancePlan;

public interface StadVehicleFinancePlanMapper {
    StadVehicleFinancePlan selectStadVehicleFinancePlanById(Long planId);
    List<StadVehicleFinancePlan> selectStadVehicleFinancePlanList(StadVehicleFinancePlan plan);
    int insertStadVehicleFinancePlan(StadVehicleFinancePlan plan);
    int updateStadVehicleFinancePlan(StadVehicleFinancePlan plan);
    int deleteStadVehicleFinancePlanById(Long planId);
    int deleteStadVehicleFinancePlanByIds(Long[] planIds);
    List<StadVehicleFinancePlan> selectStadVehicleFinancePlanByVehicleId(Long vehicleId);
}