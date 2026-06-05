import request from '@/utils/request'

// ===== 充电桩接口 =====

/** 获取充电桩列表 */
export function getPileList(params) {
  return request({
    url: '/business/chargingpile/list',
    method: 'GET',
    params
  })
}

/** 获取充电桩详情 */
export function getPileDetail(pileId) {
  return request({
    url: '/business/chargingpile/' + pileId,
    method: 'GET'
  })
}

/** 根据站点获取充电桩列表 */
export function getPileByStation(stationId) {
  return request({
    url: '/business/chargingpile/byStation/' + stationId,
    method: 'GET'
  })
}

/** 新增充电桩 */
export function addPile(data) {
  return request({
    url: '/business/chargingpile',
    method: 'POST',
    data
  })
}

/** 修改充电桩 */
export function updatePile(data) {
  return request({
    url: '/business/chargingpile',
    method: 'PUT',
    data
  })
}

/** 删除充电桩 */
export function deletePile(pileIds) {
  return request({
    url: '/business/chargingpile/' + pileIds,
    method: 'DELETE'
  })
}