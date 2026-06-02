import request from '@/utils/request'

export function listVehicleReview(query) {
  return request({
    url: '/business/vehiclereview/list',
    method: 'get',
    params: query
  })
}

export function getVehicleReview(reviewId) {
  return request({
    url: '/business/vehiclereview/' + reviewId,
    method: 'get'
  })
}

export function listVehicleReviewByVehicleId(vehicleId) {
  return request({
    url: '/business/vehiclereview/byVehicle/' + vehicleId,
    method: 'get'
  })
}

export function addVehicleReview(data) {
  return request({
    url: '/business/vehiclereview',
    method: 'post',
    data: data
  })
}

export function updateVehicleReview(data) {
  return request({
    url: '/business/vehiclereview',
    method: 'put',
    data: data
  })
}

export function delVehicleReview(reviewIds) {
  return request({
    url: '/business/vehiclereview/' + reviewIds,
    method: 'delete'
  })
}