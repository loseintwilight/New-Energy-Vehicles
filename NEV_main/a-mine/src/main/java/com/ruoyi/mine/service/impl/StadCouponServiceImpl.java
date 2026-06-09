package com.ruoyi.mine.service.impl;

import com.ruoyi.mine.domain.MineStadCoupon;
import com.ruoyi.mine.mapper.StadCouponMapper;
import com.ruoyi.mine.service.IStadCouponService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StadCouponServiceImpl implements IStadCouponService {

    @Autowired
    private StadCouponMapper couponMapper;

    @Override
    public List<MineStadCoupon> selectStadCouponList(MineStadCoupon coupon) {
        return couponMapper.selectStadCouponList(coupon);
    }

    @Override
    public MineStadCoupon selectStadCouponById(Long id) {
        return couponMapper.selectStadCouponById(id);
    }

    @Override
    public int insertStadCoupon(MineStadCoupon coupon) {
        return couponMapper.insertStadCoupon(coupon);
    }

    @Override
    public int updateStadCoupon(MineStadCoupon coupon) {
        return couponMapper.updateStadCoupon(coupon);
    }
}