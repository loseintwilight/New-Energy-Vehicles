import request from '@/utils/request'

// 获取费率方案列表
export function getRateList(params) {
  return request({
    url: '/app/charge/rate/list',
    method: 'GET',
    params: params
  })
}

// 获取费率详情
export function getRateDetail(rateId) {
  return request({
    url: '/app/charge/rate/' + rateId,
    method: 'GET'
  })
}

// 根据站点ID查询费率列表
export function getRatesByStation(stationId) {
  return request({
    url: '/app/charge/rate/station/' + stationId,
    method: 'GET'
  })
}

// 新增费率方案
export function addRate(data) {
  return request({
    url: '/app/charge/rate',
    method: 'POST',
    data: data
  })
}

// 修改费率方案
export function updateRate(data) {
  return request({
    url: '/app/charge/rate',
    method: 'PUT',
    data: data
  })
}

// 删除费率方案
export function deleteRate(rateIds) {
  return request({
    url: '/app/charge/rate/' + rateIds,
    method: 'DELETE'
  })
}
