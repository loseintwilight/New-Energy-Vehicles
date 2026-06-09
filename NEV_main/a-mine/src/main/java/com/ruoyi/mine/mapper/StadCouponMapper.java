package com.ruoyi.mine.mapper;

import com.ruoyi.mine.domain.MineStadCoupon;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface StadCouponMapper {
    
    List<MineStadCoupon> selectStadCouponList(MineStadCoupon coupon);
    
    MineStadCoupon selectStadCouponById(Long id);
    
    int insertStadCoupon(MineStadCoupon coupon);
    
    int updateStadCoupon(MineStadCoupon coupon);
}