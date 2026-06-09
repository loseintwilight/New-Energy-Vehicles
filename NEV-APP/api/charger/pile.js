import request from '@/utils/request'

// 获取充电桩列表
export function getPileList(params) {
  return request({
    url: '/app/charge/pile/list',
    method: 'GET',
    params: params
  })
}

// 获取充电桩详情
export function getPileDetail(pileId) {
  return request({
    url: '/app/charge/pile/' + pileId,
    method: 'GET'
  })
}

// 根据站点ID查询充电桩列表
export function getPilesByStation(stationId) {
  return request({
    url: '/app/charge/pile/listByStation/' + stationId,
    method: 'GET'
  })
}

// 新增充电桩
export function addPile(data) {
  return request({
    url: '/app/charge/pile',
    method: 'POST',
    data: data
  })
}

// 修改充电桩
export function updatePile(data) {
  return request({
    url: '/app/charge/pile',
    method: 'PUT',
    data: data
  })
}

// 删除充电桩
export function deletePile(pileIds) {
  return request({
    url: '/app/charge/pile/' + pileIds,
    method: 'DELETE'
  })
}
