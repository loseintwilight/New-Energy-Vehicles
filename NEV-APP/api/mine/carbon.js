import request from '@/utils/request'

// 获取碳积分概览
export function getCarbonOverview() {
  return request({
    url: '/app/carbon/overview',
    method: 'get'
  })
}

// 获取碳积分获取方式
export function getCarbonEarnWays() {
  return request({
    url: '/app/carbon/ways',
    method: 'get'
  })
}

// 获取碳积分记录列表
export function getCarbonRecords(params) {
  return request({
    url: '/app/carbon/records',
    method: 'get',
    params
  })
}

// 碳积分兑换
export function exchangePoints(data) {
  return request({
    url: '/app/carbon/exchange',
    method: 'post',
    data
  })
}

// 获取兑换商品列表
export function getExchangeProducts() {
  return request({
    url: '/app/carbon/products',
    method: 'get'
  })
}

// 碳积分签到
export function doCheckIn() {
  return request({
    url: '/app/carbon/checkin',
    method: 'post'
  })
}
