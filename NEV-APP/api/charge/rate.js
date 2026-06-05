import request from '@/utils/request'

// ===== 充电费率接口 =====

/** 获取费率列表 */
export function getRateList(params) {
  return request({
    url: '/business/chargingrate/list',
    method: 'GET',
    params
  })
}

/** 获取费率详情 */
export function getRateDetail(rateId) {
  return request({
    url: '/business/chargingrate/' + rateId,
    method: 'GET'
  })
}

/** 根据站点获取费率列表 */
export function getRateByStation(stationId) {
  return request({
    url: '/business/chargingrate/byStation/' + stationId,
    method: 'GET'
  })
}

/** 新增费率 */
export function addRate(data) {
  return request({
    url: '/business/chargingrate',
    method: 'POST',
    data
  })
}

/** 修改费率 */
export function updateRate(data) {
  return request({
    url: '/business/chargingrate',
    method: 'PUT',
    data
  })
}

/** 删除费率 */
export function deleteRate(rateIds) {
  return request({
    url: '/business/chargingrate/' + rateIds,
    method: 'DELETE'
  })
}

// ===== 费率时段接口 =====

/** 获取时段列表 */
export function getPeriodList(params) {
  return request({
    url: '/business/chargingrateperiod/list',
    method: 'GET',
    params
  })
}

/** 获取时段详情 */
export function getPeriodDetail(periodId) {
  return request({
    url: '/business/chargingrateperiod/' + periodId,
    method: 'GET'
  })
}

/** 根据费率获取时段列表 */
export function getPeriodByRate(rateId) {
  return request({
    url: '/business/chargingrateperiod/byRate/' + rateId,
    method: 'GET'
  })
}

/** 新增时段 */
export function addPeriod(data) {
  return request({
    url: '/business/chargingrateperiod',
    method: 'POST',
    data
  })
}

/** 修改时段 */
export function updatePeriod(data) {
  return request({
    url: '/business/chargingrateperiod',
    method: 'PUT',
    data
  })
}

/** 删除时段 */
export function deletePeriod(periodIds) {
  return request({
    url: '/business/chargingrateperiod/' + periodIds,
    method: 'DELETE'
  })
}