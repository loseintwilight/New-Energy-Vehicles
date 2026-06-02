import request from '@/utils/request'

export function listOrder(query) {
  return request({
    url: '/business/order/list',
    method: 'get',
    params: query
  })
}

export function getOrder(orderId) {
  return request({
    url: '/business/order/' + orderId,
    method: 'get'
  })
}

export function addOrder(data) {
  return request({
    url: '/business/order',
    method: 'post',
    data: data
  })
}

export function updateOrder(data) {
  return request({
    url: '/business/order',
    method: 'put',
    data: data
  })
}

export function delOrder(orderIds) {
  return request({
    url: '/business/order/' + orderIds,
    method: 'delete'
  })
}