import request from '@/utils/request'

export function listVehicleUsed(query) {
  return request({
    url: '/business/vehicleused/list',
    method: 'get',
    params: query
  })
}

export function getVehicleUsed(usedId) {
  return request({
    url: '/business/vehicleused/' + usedId,
    method: 'get'
  })
}

export function getVehicleUsedByVehicleId(vehicleId) {
  return request({
    url: '/business/vehicleused/byVehicle/' + vehicleId,
    method: 'get'
  })
}

export function addVehicleUsed(data) {
  return request({
    url: '/business/vehicleused',
    method: 'post',
    data: data
  })
}

export function updateVehicleUsed(data) {
  return request({
    url: '/business/vehicleused',
    method: 'put',
    data: data
  })
}

export function delVehicleUsed(usedIds) {
  return request({
    url: '/business/vehicleused/' + usedIds,
    method: 'delete'
  })
}