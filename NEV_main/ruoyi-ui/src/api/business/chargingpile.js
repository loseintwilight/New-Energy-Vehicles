import request from '@/utils/request'

export function listChargingPile(query) {
  return request({
    url: '/business/chargingpile/list',
    method: 'get',
    params: query
  })
}

export function getChargingPile(pileId) {
  return request({
    url: '/business/chargingpile/' + pileId,
    method: 'get'
  })
}

export function listChargingPileByStationId(stationId) {
  return request({
    url: '/business/chargingpile/byStation/' + stationId,
    method: 'get'
  })
}

export function addChargingPile(data) {
  return request({
    url: '/business/chargingpile',
    method: 'post',
    data: data
  })
}

export function updateChargingPile(data) {
  return request({
    url: '/business/chargingpile',
    method: 'put',
    data: data
  })
}

export function delChargingPile(pileIds) {
  return request({
    url: '/business/chargingpile/' + pileIds,
    method: 'delete'
  })
}