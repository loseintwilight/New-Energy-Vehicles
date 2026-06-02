import request from '@/utils/request'

export function listVehicleSpec(query) {
  return request({
    url: '/business/vehiclespec/list',
    method: 'get',
    params: query
  })
}

export function getVehicleSpec(specId) {
  return request({
    url: '/business/vehiclespec/' + specId,
    method: 'get'
  })
}

export function listVehicleSpecByVehicleId(vehicleId) {
  return request({
    url: '/business/vehiclespec/byVehicle/' + vehicleId,
    method: 'get'
  })
}

export function addVehicleSpec(data) {
  return request({
    url: '/business/vehiclespec',
    method: 'post',
    data: data
  })
}

export function updateVehicleSpec(data) {
  return request({
    url: '/business/vehiclespec',
    method: 'put',
    data: data
  })
}

export function delVehicleSpec(specIds) {
  return request({
    url: '/business/vehiclespec/' + specIds,
    method: 'delete'
  })
}