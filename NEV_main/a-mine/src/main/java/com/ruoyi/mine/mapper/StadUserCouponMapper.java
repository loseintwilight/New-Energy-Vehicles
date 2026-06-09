package com.ruoyi.mine.mapper;

import com.ruoyi.mine.domain.MineStadUserCoupon;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface StadUserCouponMapper {
    
    List<MineStadUserCoupon> selectStadUserCouponList(MineStadUserCoupon userCoupon);
    
    MineStadUserCoupon selectStadUserCouponById(Long id);
    
    int insertStadUserCoupon(MineStadUserCoupon userCoupon);
    
    int updateStadUserCoupon(MineStadUserCoupon userCoupon);
    
    int countByUserIdAndCouponId(Long userId, Long couponId);
}