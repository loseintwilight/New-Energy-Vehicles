package com.ruoyi.mapper;

import com.ruoyi.domain.VehicleReviews;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface VehicleReviewsMapper {

    List<VehicleReviews> selectReviewList(@Param("rating") Integer rating, @Param("vehicleId") Long vehicleId, @Param("keyword") String keyword);

    VehicleReviews selectReviewById(@Param("reviewId") Long reviewId);
}
