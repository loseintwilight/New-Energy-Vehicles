package com.ruoyi.mine.service;

import com.ruoyi.mine.domain.MineStadCoupon;

import java.util.List;

public interface IStadCouponService {
    
    List<MineStadCoupon> selectStadCouponList(MineStadCoupon coupon);
    
    MineStadCoupon selectStadCouponById(Long id);
    
    int insertStadCoupon(MineStadCoupon coupon);
    
    int updateStadCoupon(MineStadCoupon coupon);
}