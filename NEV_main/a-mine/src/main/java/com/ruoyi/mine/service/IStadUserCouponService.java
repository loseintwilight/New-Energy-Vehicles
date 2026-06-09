package com.ruoyi.mine.service;

import com.ruoyi.mine.domain.MineStadUserCoupon;

import java.util.List;

public interface IStadUserCouponService {
    
    List<MineStadUserCoupon> selectStadUserCouponList(MineStadUserCoupon userCoupon);
    
    MineStadUserCoupon selectStadUserCouponById(Long id);
    
    int insertStadUserCoupon(MineStadUserCoupon userCoupon);
    
    int updateStadUserCoupon(MineStadUserCoupon userCoupon);
    
    int receiveCoupon(Long userId, Long couponId);
    
    int useCoupon(Long userId, Long couponId, Long orderId);
    
    int countReceived(Long userId, Long couponId);
}