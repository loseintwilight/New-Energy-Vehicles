import request from '@/utils/request'

// 获取优惠券列表
export function getCouponList(params) {
  return request({
    url: '/app/coupon/list',
    method: 'get',
    params
  })
}

// 获取用户优惠券列表
export function getUserCoupons(params) {
  return request({
    url: '/app/coupon/my',
    method: 'get',
    params
  })
}

// 领取优惠券
export function receiveCoupon(couponId) {
  return request({
    url: `/app/coupon/receive/${couponId}`,
    method: 'post'
  })
}

// 获取优惠券数量
export function getCouponCount() {
  return request({
    url: '/app/coupon/count',
    method: 'get'
  })
}

// 使用优惠券
export function useCoupon(couponId, data) {
  return request({
    url: `/app/coupon/use/${couponId}`,
    method: 'post',
    data
  })
}