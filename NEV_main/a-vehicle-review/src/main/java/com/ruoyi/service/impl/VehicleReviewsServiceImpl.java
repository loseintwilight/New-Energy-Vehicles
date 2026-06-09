package com.ruoyi.service.impl;

import com.ruoyi.domain.VehicleReviews;
import com.ruoyi.mapper.VehicleReviewsMapper;
import com.ruoyi.service.VehicleReviewsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Description: 评价实现类
 * @Author: 刘文丽
 * @CreateTime: 2026-06-04 00:19
 */

@Service
public class VehicleReviewsServiceImpl implements VehicleReviewsService {

    @Autowired
    private VehicleReviewsMapper vehicleReviewMapper;

    @Override
    public List<VehicleReviews> listReview(Integer rating, Long vehicleId, String keyword) {
        return vehicleReviewMapper.selectReviewList(rating, vehicleId, keyword);
    }

    @Override
    public VehicleReviews getById(Long id) {
        return vehicleReviewMapper.selectReviewById(id);
    }
}
