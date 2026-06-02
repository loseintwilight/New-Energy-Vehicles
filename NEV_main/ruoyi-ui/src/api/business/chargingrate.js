import request from '@/utils/request'

export function listChargingRate(query) {
  return request({
    url: '/business/chargingrate/list',
    method: 'get',
    params: query
  })
}

export function getChargingRate(rateId) {
  return request({
    url: '/business/chargingrate/' + rateId,
    method: 'get'
  })
}

export function listChargingRateByStationId(stationId) {
  return request({
    url: '/business/chargingrate/byStation/' + stationId,
    method: 'get'
  })
}

export function addChargingRate(data) {
  return request({
    url: '/business/chargingrate',
    method: 'post',
    data: data
  })
}

export function updateChargingRate(data) {
  return request({
    url: '/business/chargingrate',
    method: 'put',
    data: data
  })
}

export function delChargingRate(rateIds) {
  return request({
    url: '/business/chargingrate/' + rateIds,
    method: 'delete'
  })
}