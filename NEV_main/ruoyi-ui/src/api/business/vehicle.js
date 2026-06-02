import request from '@/utils/request'

export function listVehicle(query) {
  return request({
    url: '/business/vehicle/list',
    method: 'get',
    params: query
  })
}

export function getVehicle(vehicleId) {
  return request({
    url: '/business/vehicle/' + vehicleId,
    method: 'get'
  })
}

export function addVehicle(data) {
  return request({
    url: '/business/vehicle',
    method: 'post',
    data: data
  })
}

export function updateVehicle(data) {
  return request({
    url: '/business/vehicle',
    method: 'put',
    data: data
  })
}

export function delVehicle(vehicleIds) {
  return request({
    url: '/business/vehicle/' + vehicleIds,
    method: 'delete'
  })
}