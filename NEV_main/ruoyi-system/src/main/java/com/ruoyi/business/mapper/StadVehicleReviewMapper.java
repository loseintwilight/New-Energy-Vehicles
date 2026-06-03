package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.StadVehicleReview;

public interface StadVehicleReviewMapper {
    StadVehicleReview selectStadVehicleReviewById(Long reviewId);
    List<StadVehicleReview> selectStadVehicleReviewList(StadVehicleReview review);
    int insertStadVehicleReview(StadVehicleReview review);
    int updateStadVehicleReview(StadVehicleReview review);
    int deleteStadVehicleReviewById(Long reviewId);
    int deleteStadVehicleReviewByIds(Long[] reviewIds);
    List<StadVehicleReview> selectStadVehicleReviewByVehicleId(Long vehicleId);
}