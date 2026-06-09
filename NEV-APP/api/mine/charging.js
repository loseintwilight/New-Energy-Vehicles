import request from '@/utils/request'

// 获取充电记录列表
export function getChargingRecords(params) {
  return request({
    url: '/app/charge/order/list',
    method: 'get',
    params
  })
}

// 获取充电记录详情
export function getChargingDetail(id) {
  return request({
    url: '/app/charge/order/status/' + id,
    method: 'get'
  })
}
