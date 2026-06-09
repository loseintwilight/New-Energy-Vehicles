package com.ruoyi.web.controller.vehicle;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ruoyi.common.core.domain.R;
import com.ruoyi.domain.VehicleReviews;
import com.ruoyi.service.VehicleReviewsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * @Description: 车辆评价模块功能
 * @Author: 刘文丽
 * @CreateTime: 2026-06-04 00:36
 */
@RestController
@RequestMapping("/business/review")
public class VehicleReviewController {
    @Autowired
    private VehicleReviewsService vehicleReviewService;

    //分页查询评论列表
    @GetMapping("/list")
    public R getReviewList(Integer rating, Long vehicleId,String keyword, Integer pageNum, Integer pageSize){
        pageNum = (pageNum == null) ? 1 : pageNum;
        pageSize = (pageSize == null) ? 10 : pageSize;
        PageHelper.startPage(pageNum,pageSize);
        List<VehicleReviews> vehicleReviews = vehicleReviewService.listReview(rating,vehicleId,keyword);
        PageInfo<VehicleReviews> vehicleReviewPageInfo = new PageInfo<>(vehicleReviews);
        return R.success(vehicleReviewPageInfo);
    }

    //评论详情
    @GetMapping("/{id}")
    public R<VehicleReviews> getReview(@PathVariable Long id) {
        VehicleReviews review = vehicleReviewService.getById(id);
        return R.success(review);
    }



}
