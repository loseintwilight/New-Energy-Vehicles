import request from '@/utils/request'

export function listUnifiedOrder(query) {
  return request({
    url: '/business/unified/order/list',
    method: 'get',
    params: query
  })
}

export function getUnifiedOrder(orderId) {
  return request({
    url: '/business/unified/order/' + orderId,
    method: 'get'
  })
}

export function addUnifiedOrder(data) {
  return request({
    url: '/business/unified/order',
    method: 'post',
    data: data
  })
}

export function updateUnifiedOrder(data) {
  return request({
    url: '/business/unified/order',
    method: 'put',
    data: data
  })
}

export function delUnifiedOrder(orderIds) {
  return request({
    url: '/business/unified/order/' + orderIds,
    method: 'delete'
  })
}