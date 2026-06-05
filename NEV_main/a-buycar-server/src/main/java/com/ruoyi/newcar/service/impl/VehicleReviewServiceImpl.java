package com.ruoyi.newcar.service.impl;

import com.ruoyi.newcar.domain.VehicleReview;
import com.ruoyi.newcar.mapper.VehicleReviewMapper;
import com.ruoyi.newcar.service.VehicleReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class VehicleReviewServiceImpl implements VehicleReviewService {

    @Autowired
    private VehicleReviewMapper vehicleReviewMapper;

    @Override
    public List<VehicleReview> selectByVehicleId(Long vehicleId) {
        return vehicleReviewMapper.selectByVehicleId(vehicleId);
    }
}