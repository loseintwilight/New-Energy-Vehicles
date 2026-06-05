package com.ruoyi.newcar.service;

import com.ruoyi.newcar.domain.FinancePlan;

import java.util.List;

public interface FinancePlanService {
    List<FinancePlan> selectByVehicleId(Long vehicleId);
}