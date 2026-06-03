import request from '@/utils/request'

// ==================== vehicle 车辆核心 ====================

export function getCarList(params) {
  return request({
    url: '/car/list',
    method: 'get',
    params
  })
}

export function getCarDetail(vehicleId) {
  return request({
    url: '/car/detail',
    method: 'get',
    params: { vehicleId }
  })
}

// ==================== vehicle_spec 车辆配置 ====================

export function getVehicleSpec(vehicleId) {
  return request({
    url: '/car/spec',
    method: 'get',
    params: { vehicleId }
  })
}

// ==================== vehicle_finance_plan 金融方案 ====================

export function getFinancePlans(params) {
  return request({
    url: '/car/finance/plans',
    method: 'get',
    params
  })
}

// ==================== unified_order（购车 purchase） ====================

export function createCarOrder(data) {
  return request({
    url: '/car/order/create',
    method: 'post',
    data
  })
}

export function getCarOrderList(params) {
  return request({
    url: '/car/order/list',
    method: 'get',
    params
  })
}

export function getCarOrderDetail(orderId) {
  return request({
    url: '/car/order/detail',
    method: 'get',
    params: { orderId }
  })
}

// vehicle_used 二手车 

export function getUsedCarList(params) {
  return request({
    url: '/car/used/list',
    method: 'get',
    params
  })
}

export function getUsedCarDetail(vehicleId) {
  return request({
    url: '/car/used/detail',
    method: 'get',
    params: { vehicleId }
  })
}

export function getInspectionReport(vehicleId) {
  return request({
    url: '/car/used/inspection',
    method: 'get',
    params: { vehicleId }
  })
}

// unified_order（二手车 purchase / test_drive）

export function createUsedCarOrder(data) {
  return request({
    url: '/car/used/order/create',
    method: 'post',
    data
  })
}

// 以旧换新 trade_in 

export function getTradeInEvaluation(data) {
  return request({
    url: '/car/tradein/evaluate',
    method: 'post',
    data
  })
}

export function createTradeInOrder(data) {
  return request({
    url: '/car/tradein/order/create',
    method: 'post',
    data
  })
}

export function getTradeInRecordList(params) {
  return request({
    url: '/car/tradein/record/list',
    method: 'get',
    params
  })
}

//我的车辆 

export function getMyCars() {
  return request({
    url: '/car/my/list',
    method: 'get'
  })
}

// 公共接口 

export function getDeliveryOptions() {
  return request({
    url: '/car/delivery/options',
    method: 'get'
  })
}

export function getInsuranceOptions() {
  return request({
    url: '/car/insurance/options',
    method: 'get'
  })
}

export function getStoreList() {
  return request({
    url: '/car/store/list',
    method: 'get'
  })
}

export function getCityList() {
  return request({
    url: '/car/city/list',
    method: 'get'
  })
}

// vehicle_review 评价 

export function getVehicleReviews(vehicleId) {
  return request({
    url: '/car/review/list',
    method: 'get',
    params: { vehicleId }
  })
}