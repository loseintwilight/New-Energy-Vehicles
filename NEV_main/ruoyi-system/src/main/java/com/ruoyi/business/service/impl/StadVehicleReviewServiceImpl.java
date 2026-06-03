package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.mapper.StadVehicleReviewMapper;
import com.ruoyi.business.domain.StadVehicleReview;
import com.ruoyi.business.service.IStadVehicleReviewService;

@Service
public class StadVehicleReviewServiceImpl implements IStadVehicleReviewService {

    @Autowired
    private StadVehicleReviewMapper stadVehicleReviewMapper;

    @Override
    public StadVehicleReview selectStadVehicleReviewById(Long reviewId) {
        return stadVehicleReviewMapper.selectStadVehicleReviewById(reviewId);
    }

    @Override
    public List<StadVehicleReview> selectStadVehicleReviewList(StadVehicleReview review) {
        return stadVehicleReviewMapper.selectStadVehicleReviewList(review);
    }

    @Override
    public List<StadVehicleReview> selectStadVehicleReviewByVehicleId(Long vehicleId) {
        return stadVehicleReviewMapper.selectStadVehicleReviewByVehicleId(vehicleId);
    }

    @Override
    public int insertStadVehicleReview(StadVehicleReview review) {
        return stadVehicleReviewMapper.insertStadVehicleReview(review);
    }

    @Override
    public int updateStadVehicleReview(StadVehicleReview review) {
        return stadVehicleReviewMapper.updateStadVehicleReview(review);
    }

    @Override
    public int deleteStadVehicleReviewByIds(Long[] reviewIds) {
        return stadVehicleReviewMapper.deleteStadVehicleReviewByIds(reviewIds);
    }
}