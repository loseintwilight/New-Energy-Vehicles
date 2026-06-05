package com.ruoyi.newcar.service.impl;

import com.ruoyi.newcar.domain.FinancePlan;
import com.ruoyi.newcar.mapper.FinancePlanMapper;
import com.ruoyi.newcar.service.FinancePlanService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FinancePlanServiceImpl implements FinancePlanService {

    @Autowired
    private FinancePlanMapper financePlanMapper;

    @Override
    public List<FinancePlan> selectByVehicleId(Long vehicleId) {
        return financePlanMapper.selectByVehicleId(vehicleId);
    }
}