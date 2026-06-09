import request from '@/utils/request'

// 获取充电记录列表
export function getChargingRecords(params) {
  return request({
    url: '/app/charging/order/list',
    method: 'get',
    params
  })
}

// 获取充电记录详情
export function getChargingDetail(id) {
  return request({
    url: '/app/charging/order/detail/' + id,
    method: 'get'
  })
}

// 获取充电统计数据（总次数、总电量、总金额）
export function getChargingStatistics() {
  return request({
    url: '/app/charging/statistics',
    method: 'get'
  })
}