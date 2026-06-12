import request from '@/utils/request'

// 获取订单列表
export function getOrderList(params) {
  return request({
    url: '/app/order/list',
    method: 'get',
    params
  })
}

// 获取订单详情
export function getOrderDetail(id, bizType) {
  return request({
    url: `/app/order/${id}`,
    method: 'get',
    params: { bizType }
  })
}

// 取消订单
export function cancelOrder(id) {
  return request({
    url: `/app/order/${id}/cancel`,
    method: 'put'
  })
}

// 完成订单
export function completeOrder(id) {
  return request({
    url: `/app/order/${id}/complete`,
    method: 'put'
  })
}

// 删除订单
export function deleteOrder(id) {
  return request({
    url: `/app/order/${id}`,
    method: 'delete'
  })
}

// 获取订单状态统计
export function getOrderStatusCount() {
  return request({
    url: '/app/order/status',
    method: 'get'
  })
}

// 支付订单
export function payOrder(id, bizType) {
  return request({
    url: `/app/order/${id}/pay`,
    method: 'put',
    params: { bizType }
  })
}
