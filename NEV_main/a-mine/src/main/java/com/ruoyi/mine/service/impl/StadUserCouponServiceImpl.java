package com.ruoyi.mine.service.impl;

import com.ruoyi.mine.domain.MineStadCoupon;
import com.ruoyi.mine.domain.MineStadUserCoupon;
import com.ruoyi.mine.mapper.StadCouponMapper;
import com.ruoyi.mine.mapper.StadUserCouponMapper;
import com.ruoyi.mine.service.IStadUserCouponService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class StadUserCouponServiceImpl implements IStadUserCouponService {

    @Autowired
    private StadUserCouponMapper userCouponMapper;

    @Autowired
    private StadCouponMapper couponMapper;

    @Override
    public List<MineStadUserCoupon> selectStadUserCouponList(MineStadUserCoupon userCoupon) {
        return userCouponMapper.selectStadUserCouponList(userCoupon);
    }

    @Override
    public MineStadUserCoupon selectStadUserCouponById(Long id) {
        return userCouponMapper.selectStadUserCouponById(id);
    }

    @Override
    public int insertStadUserCoupon(MineStadUserCoupon userCoupon) {
        return userCouponMapper.insertStadUserCoupon(userCoupon);
    }

    @Override
    public int updateStadUserCoupon(MineStadUserCoupon userCoupon) {
        return userCouponMapper.updateStadUserCoupon(userCoupon);
    }

    @Override
    public int countReceived(Long userId, Long couponId) {
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("couponId", couponId);
        return userCouponMapper.countByUserIdAndCouponId(userId, couponId);
    }

    @Override
    @Transactional
    public int receiveCoupon(Long userId, Long couponId) {
        MineStadCoupon coupon = couponMapper.selectStadCouponById(couponId);
        if (coupon == null || coupon.getStatus() != 1) {
            throw new RuntimeException("优惠券不存在或已下架");
        }
        
        int receivedCount = countReceived(userId, couponId);
        if (receivedCount >= coupon.getPerUserLimit()) {
            throw new RuntimeException("已达到领取上限");
        }

        MineStadUserCoupon userCoupon = new MineStadUserCoupon();
        userCoupon.setUserId(userId);
        userCoupon.setCouponId(couponId);
        userCoupon.setStatus(1);
        userCoupon.setCreateTime(new Date());
        return userCouponMapper.insertStadUserCoupon(userCoupon);
    }

    @Override
    @Transactional
    public int useCoupon(Long userId, Long couponId, Long orderId) {
        MineStadUserCoupon userCoupon = new MineStadUserCoupon();
        userCoupon.setUserId(userId);
        userCoupon.setCouponId(couponId);
        userCoupon.setStatus(1);
        
        List<MineStadUserCoupon> list = userCouponMapper.selectStadUserCouponList(userCoupon);
        if (list.isEmpty()) {
            throw new RuntimeException("未找到可用优惠券");
        }

        MineStadUserCoupon target = list.get(0);
        target.setStatus(2);
        target.setUseTime(new Date());
        target.setOrderId(orderId);
        return userCouponMapper.updateStadUserCoupon(target);
    }
}