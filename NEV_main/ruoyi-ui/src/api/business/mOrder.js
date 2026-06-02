import request from '@/utils/request'

export function listMOrder(query) {
  return request({
    url: '/business/maintenance/order/list',
    method: 'get',
    params: query
  })
}

export function getMOrder(orderId) {
  return request({
    url: '/business/maintenance/order/' + orderId,
    method: 'get'
  })
}

export function addMOrder(data) {
  return request({
    url: '/business/maintenance/order',
    method: 'post',
    data: data
  })
}

export function updateMOrder(data) {
  return request({
    url: '/business/maintenance/order',
    method: 'put',
    data: data
  })
}

export function delMOrder(orderIds) {
  return request({
    url: '/business/maintenance/order/' + orderIds,
    method: 'delete'
  })
}