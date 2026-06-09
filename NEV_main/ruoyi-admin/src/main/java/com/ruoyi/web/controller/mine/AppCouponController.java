package com.ruoyi.web.controller.mine;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.mine.domain.MineStadCoupon;
import com.ruoyi.mine.domain.MineStadUserCoupon;
import com.ruoyi.mine.service.IStadCouponService;
import com.ruoyi.mine.service.IStadUserCouponService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/app/coupon")
public class AppCouponController {

    @Autowired
    private IStadCouponService couponService;

    @Autowired
    private IStadUserCouponService userCouponService;

    @GetMapping("/list")
    public AjaxResult getCouponList() {
        MineStadCoupon coupon = new MineStadCoupon();
        coupon.setStatus(1);
        List<MineStadCoupon> list = couponService.selectStadCouponList(coupon);
        
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("total", list.size());
        
        return AjaxResult.success(result);
    }

    @GetMapping("/my")
    public AjaxResult getUserCoupons(@RequestParam(required = false) Integer status) {
        Long userId = SecurityUtils.getUserId();
        MineStadUserCoupon userCoupon = new MineStadUserCoupon();
        userCoupon.setUserId(userId);
        if (status != null) {
            userCoupon.setStatus(status);
        }
        
        List<MineStadUserCoupon> list = userCouponService.selectStadUserCouponList(userCoupon);
        
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("total", list.size());
        
        return AjaxResult.success(result);
    }

    @GetMapping("/count")
    public AjaxResult getCouponCount() {
        Long userId = SecurityUtils.getUserId();
        
        MineStadUserCoupon userCoupon = new MineStadUserCoupon();
        userCoupon.setUserId(userId);
        userCoupon.setStatus(1);
        
        List<MineStadUserCoupon> list = userCouponService.selectStadUserCouponList(userCoupon);
        
        return AjaxResult.success(list.size());
    }

    @PostMapping("/receive/{couponId}")
    public AjaxResult receiveCoupon(@PathVariable Long couponId) {
        Long userId = SecurityUtils.getUserId();
        
        try {
            userCouponService.receiveCoupon(userId, couponId);
            return AjaxResult.success("领取成功");
        } catch (RuntimeException e) {
            return AjaxResult.error(e.getMessage());
        }
    }

    @PostMapping("/use/{couponId}")
    public AjaxResult useCoupon(@PathVariable Long couponId, @RequestBody Map<String, Object> data) {
        Long userId = SecurityUtils.getUserId();
        Long orderId = data.get("orderId") != null ? Long.parseLong(data.get("orderId").toString()) : null;
        
        try {
            userCouponService.useCoupon(userId, couponId, orderId);
            return AjaxResult.success("使用成功");
        } catch (RuntimeException e) {
            return AjaxResult.error(e.getMessage());
        }
    }
}