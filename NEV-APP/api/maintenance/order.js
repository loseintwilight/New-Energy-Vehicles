import request from '@/utils/request'

// 获取订单列表
export function listOrder(params) {
  return request({
    url: '/maintenance/order/list',
    method: 'get',
    params
  })
}

// 获取订单详情（含门店名称等关联信息）
export function getOrderDetail(orderId) {
  return request({
    url: '/maintenance/order/detail',
    method: 'get',
    params: { order_id: orderId }
  })
}

// 获取订单统计（顶部概览数字）
export function getOrderStats() {
  return request({
    url: '/maintenance/order/stats',
    method: 'get'
  })
}

// 提交维保预约订单
export function createOrder(data) {
  return request({
    url: '/maintenance/order/create',
    method: 'post',
    data
  })
}

// 取消维保订单
export function cancelOrder(data) {
  return request({
    url: '/maintenance/order/cancel',
    method: 'post',
    data
  })
}

// 修改维保订单
export function updateOrder(data) {
  return request({
    url: '/maintenance/order/update',
    method: 'post',
    data
  })
}

// 获取评价列表
export function listReview(params) {
  return request({
    url: '/maintenance/order/reviews',
    method: 'get',
    params
  })
}

// 获取维保可用车辆列表（调用维保模块独立接口，返回 R.ok 格式）
export function listMaintenanceVehicle(params) {
  return request({
    url: '/maintenance/vehicle/list',
    method: 'get',
    params
  })
}