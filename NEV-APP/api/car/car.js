import request from '@/utils/request'

export function getCarList(data) {
  return request({
    url: '/car/list',
    method: 'get',
    params: data
  })
}

export function getCarDetail(id) {
  return request({
    url: '/car/detail',
    method: 'get',
    params: { id }
  })
}

export function createCarOrder(data) {
  return request({
    url: '/car/order/create',
    method: 'post',
    data
  })
}

export function getUsedCarList(data) {
  return request({
    url: '/car/used/list',
    method: 'get',
    params: data
  })
}

export function getUsedCarDetail(id) {
  return request({
    url: '/car/used/detail',
    method: 'get',
    params: { id }
  })
}

export function getInspectionReport(id) {
  return request({
    url: '/car/used/inspection',
    method: 'get',
    params: { id }
  })
}

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

export function getFinancePlans(vehicleId) {
  return request({
    url: '/car/finance/plans',
    method: 'get',
    params: { vehicleId }
  })
}

export function getVehicleSpecs(vehicleId) {
  return request({
    url: '/car/vehicle/specs',
    method: 'get',
    params: { vehicleId }
  })
}

export function getCarReviews(vehicleId) {
  return request({
    url: '/car/vehicle/reviews',
    method: 'get',
    params: { vehicleId }
  })
}

export function getCities() {
  return request({
    url: '/car/config/cities',
    method: 'get'
  })
}

export function getStores() {
  return request({
    url: '/car/config/stores',
    method: 'get'
  })
}

export function getFilterColors() {
  return request({
    url: '/car/config/colors',
    method: 'get'
  })
}

export function getFilterModels() {
  return request({
    url: '/car/config/models',
    method: 'get'
  })
}

export function sendOrderToAdmin(data) {
  return request({
    url: '/admin/car/order/receive',
    method: 'post',
    data
  })
}

export function getAdminOrderList() {
  return request({
    url: '/admin/car/order/list',
    method: 'get'
  })
}