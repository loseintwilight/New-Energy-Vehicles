package com.ruoyi.newcar.mapper;

import com.ruoyi.newcar.domain.VehicleReview;

import java.util.List;

public interface VehicleReviewMapper {
    List<VehicleReview> selectByVehicleId(Long vehicleId);
}