package com.ruoyi.newcar.mapper;

import com.ruoyi.newcar.domain.FinancePlan;

import java.util.List;

public interface FinancePlanMapper {
    List<FinancePlan> selectByVehicleId(Long vehicleId);
}