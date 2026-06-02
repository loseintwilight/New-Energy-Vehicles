package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.mapper.StadVehicleFinancePlanMapper;
import com.ruoyi.business.domain.StadVehicleFinancePlan;
import com.ruoyi.business.service.IStadVehicleFinancePlanService;

@Service
public class StadVehicleFinancePlanServiceImpl implements IStadVehicleFinancePlanService {

    @Autowired
    private StadVehicleFinancePlanMapper stadVehicleFinancePlanMapper;

    @Override
    public StadVehicleFinancePlan selectStadVehicleFinancePlanById(Long planId) {
        return stadVehicleFinancePlanMapper.selectStadVehicleFinancePlanById(planId);
    }

    @Override
    public List<StadVehicleFinancePlan> selectStadVehicleFinancePlanList(StadVehicleFinancePlan plan) {
        return stadVehicleFinancePlanMapper.selectStadVehicleFinancePlanList(plan);
    }

    @Override
    public List<StadVehicleFinancePlan> selectStadVehicleFinancePlanByVehicleId(Long vehicleId) {
        return stadVehicleFinancePlanMapper.selectStadVehicleFinancePlanByVehicleId(vehicleId);
    }

    @Override
    public int insertStadVehicleFinancePlan(StadVehicleFinancePlan plan) {
        return stadVehicleFinancePlanMapper.insertStadVehicleFinancePlan(plan);
    }

    @Override
    public int updateStadVehicleFinancePlan(StadVehicleFinancePlan plan) {
        return stadVehicleFinancePlanMapper.updateStadVehicleFinancePlan(plan);
    }

    @Override
    public int deleteStadVehicleFinancePlanByIds(Long[] planIds) {
        return stadVehicleFinancePlanMapper.deleteStadVehicleFinancePlanByIds(planIds);
    }
}