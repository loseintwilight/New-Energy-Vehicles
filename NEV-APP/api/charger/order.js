import request from '@/utils/request'

// 获取订单列表
export function getOrderList(params) {
  return request({
    url: '/app/charge/order/list',
    method: 'GET',
    params: params
  })
}

// 获取订单详情
export function getOrderDetail(orderId) {
  return request({
    url: '/app/charge/order/' + orderId,
    method: 'GET'
  })
}

// 根据订单号查询订单
export function getOrderByNo(orderNo) {
  return request({
    url: '/app/charge/order/orderNo/' + orderNo,
    method: 'GET'
  })
}

// 新增订单
export function addOrder(data) {
  return request({
    url: '/app/charge/order',
    method: 'POST',
    data: data
  })
}

// 修改订单
export function updateOrder(data) {
  return request({
    url: '/app/charge/order',
    method: 'PUT',
    data: data
  })
}

// 删除订单
export function deleteOrder(orderIds) {
  return request({
    url: '/app/charge/order/' + orderIds,
    method: 'DELETE'
  })
}
