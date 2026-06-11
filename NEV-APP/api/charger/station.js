import request from '@/utils/request'

// 获取站点列表
export function getStationList(params) {
  return request({
    url: '/app/charge/station/list',
    method: 'GET',
    params: params
  })
}

// 获取站点详情
export function getStationDetail(stationId) {
  return request({
    url: '/app/charge/station/' + stationId,
    method: 'GET'
  })
}

// 根据商户ID查询站点列表
export function getStationsByMerchant(merchantId) {
  return request({
    url: '/app/charge/station/listByMerchant/' + merchantId,
    method: 'GET'
  })
}

// 新增站点
export function addStation(data) {
  return request({
    url: '/app/charge/station',
    method: 'POST',
    data: data
  })
}

// 修改站点
export function updateStation(data) {
  return request({
    url: '/app/charge/station',
    method: 'PUT',
    data: data
  })
}

// 删除站点
export function deleteStation(stationIds) {
  return request({
    url: '/app/charge/station/' + stationIds,
    method: 'DELETE'
  })
}

// 获取订单列表（充电端复用）
export function getOrderList(params) {
  return request({
    url: '/app/charge/order/list',
    method: 'GET',
    params: params
  })
}
