import request from '@/utils/request'

export function listChargingSettlement(query) {
  return request({
    url: '/business/chargingsettlement/list',
    method: 'get',
    params: query
  })
}

export function getChargingSettlement(settlementId) {
  return request({
    url: '/business/chargingsettlement/' + settlementId,
    method: 'get'
  })
}

export function addChargingSettlement(data) {
  return request({
    url: '/business/chargingsettlement',
    method: 'post',
    data: data
  })
}

export function updateChargingSettlement(data) {
  return request({
    url: '/business/chargingsettlement',
    method: 'put',
    data: data
  })
}

export function delChargingSettlement(settlementIds) {
  return request({
    url: '/business/chargingsettlement/' + settlementIds,
    method: 'delete'
  })
}