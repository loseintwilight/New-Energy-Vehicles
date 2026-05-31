import request from '@/utils/request'

export function getStationList(params) {
  return request({
    url: '/app/charge/station/list',
    method: 'GET',
    params: params
  })
}

export function getStationDetail(stationId) {
  return request({
    url: '/app/charge/station/detail/' + stationId,
    method: 'GET'
  })
}

export function getPileList(stationId) {
  return request({
    url: '/app/charge/pile/list',
    method: 'GET',
    params: { stationId }
  })
}

export function startCharge(data) {
  return request({
    url: '/app/charge/order/start',
    method: 'POST',
    data: data
  })
}

export function getChargeStatus(orderId) {
  return request({
    url: '/app/charge/order/status/' + orderId,
    method: 'GET'
  })
}

export function getOrderList(params) {
  return request({
    url: '/app/charge/order/list',
    method: 'GET',
    params: params
  })
}

export function searchStations(params) {
  return request({
    url: '/app/charge/station/search',
    method: 'GET',
    params: params
  })
}

export function payOrder(data) {
  return request({
    url: '/app/charge/order/pay',
    method: 'POST',
    data: data
  })
}

export function cancelOrder(data) {
  return request({
    url: '/app/charge/order/cancel',
    method: 'POST',
    data: data
  })
}

export function stopCharge(data) {
  return request({
    url: '/app/charge/order/stop',
    method: 'POST',
    data: data
  })
}

export function applyInvoice(data) {
  return request({
    url: '/app/charge/order/invoice',
    method: 'POST',
    data: data
  })
}