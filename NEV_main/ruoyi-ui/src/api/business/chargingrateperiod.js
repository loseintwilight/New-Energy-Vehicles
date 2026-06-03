import request from '@/utils/request'

export function listChargingRatePeriod(query) {
  return request({
    url: '/business/chargingrateperiod/list',
    method: 'get',
    params: query
  })
}

export function getChargingRatePeriod(periodId) {
  return request({
    url: '/business/chargingrateperiod/' + periodId,
    method: 'get'
  })
}

export function listChargingRatePeriodByRateId(rateId) {
  return request({
    url: '/business/chargingrateperiod/byRate/' + rateId,
    method: 'get'
  })
}

export function addChargingRatePeriod(data) {
  return request({
    url: '/business/chargingrateperiod',
    method: 'post',
    data: data
  })
}

export function updateChargingRatePeriod(data) {
  return request({
    url: '/business/chargingrateperiod',
    method: 'put',
    data: data
  })
}

export function delChargingRatePeriod(periodIds) {
  return request({
    url: '/business/chargingrateperiod/' + periodIds,
    method: 'delete'
  })
}