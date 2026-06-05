package com.ruoyi.newcar.service;

import com.ruoyi.newcar.domain.VehicleReview;

import java.util.List;

public interface VehicleReviewService {
    List<VehicleReview> selectByVehicleId(Long vehicleId);
}