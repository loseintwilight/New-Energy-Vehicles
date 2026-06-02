package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.StadVehicleReview;

public interface IStadVehicleReviewService {
    StadVehicleReview selectStadVehicleReviewById(Long reviewId);
    List<StadVehicleReview> selectStadVehicleReviewList(StadVehicleReview review);
    List<StadVehicleReview> selectStadVehicleReviewByVehicleId(Long vehicleId);
    int insertStadVehicleReview(StadVehicleReview review);
    int updateStadVehicleReview(StadVehicleReview review);
    int deleteStadVehicleReviewByIds(Long[] reviewIds);
}