import request from '@/utils/request'

// ==================== 车辆管理（含库存） ====================

export function listVehicle(query) {
  return request({
    url: '/merchant/vehicle/list',
    method: 'get',
    params: query
  })
}

export function getVehicle(vehicleId) {
  return request({
    url: '/merchant/vehicle/' + vehicleId,
    method: 'get'
  })
}

export function addVehicle(data) {
  return request({
    url: '/merchant/vehicle',
    method: 'post',
    data: data
  })
}

export function updateVehicle(data) {
  return request({
    url: '/merchant/vehicle',
    method: 'put',
    data: data
  })
}

export function delVehicle(vehicleId) {
  return request({
    url: '/merchant/vehicle/' + vehicleId,
    method: 'delete'
  })
}

export function getVehicleSales(vehicleId) {
  return request({
    url: '/merchant/vehicle/' + vehicleId + '/sales',
    method: 'get'
  })
}


// ==================== 价格管理 ====================

export function listPrice(query) {
  return request({
    url: '/business/price/list',
    method: 'get',
    params: query
  })
}

export function getPrice(vehicleId) {
  return request({
    url: '/business/price/' + vehicleId,
    method: 'get'
  })
}

export function updatePrice(data) {
  return request({
    url: '/business/price',
    method: 'put',
    data: data
  })
}


// ==================== 订单管理 ====================

export function listOrder(query) {
  return request({
    url: '/business/vehicle/order/list',
    method: 'get',
    params: query,
    silent: true
  })
}

export function getOrder(orderId) {
  return request({
    url: '/business/vehicle/order/' + orderId,
    method: 'get'
  })
}


// ==================== 评价管理 ====================

export function listReview(query) {
  return request({
    url: '/business/review/list',
    method: 'get',
    params: query
  })
}

export function getReview(reviewId) {
  return request({
    url: '/business/review/' + reviewId,
    method: 'get'
  })
}


// ==================== 仪表盘 ====================

export function getDashboard() {
  return request({
    url: '/merchant/vehicle/dashboard',
    method: 'get',
    silent: true
  })
}


// ==================== 电池诊断 ====================

export function getBatteryDiagnosis(vehicleId) {
  return request({
    url: '/merchant/vehicle/' + vehicleId + '/battery',
    method: 'get'
  })
}


// ==================== 二手车管理 ====================

export function listUsedCar(query) {
  return request({
    url: '/car/used/list',
    method: 'get',
    params: query
  })
}

export function getUsedCarDetail(usedId) {
  return request({
    url: '/car/used/detail',
    method: 'get',
    params: { id: usedId }
  })
}