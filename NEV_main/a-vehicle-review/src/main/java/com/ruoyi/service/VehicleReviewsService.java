package com.ruoyi.service;

import com.ruoyi.domain.VehicleReviews;

import java.util.List;


public interface VehicleReviewsService {

    List<VehicleReviews> listReview(Integer rating, Long vehicleId, String keyword);

    VehicleReviews getById(Long id);
}
