import request from '@/utils/request'

export function listFinancePlan(query) {
  return request({
    url: '/business/financeplan/list',
    method: 'get',
    params: query
  })
}

export function getFinancePlan(planId) {
  return request({
    url: '/business/financeplan/' + planId,
    method: 'get'
  })
}

export function listFinancePlanByVehicleId(vehicleId) {
  return request({
    url: '/business/financeplan/byVehicle/' + vehicleId,
    method: 'get'
  })
}

export function addFinancePlan(data) {
  return request({
    url: '/business/financeplan',
    method: 'post',
    data: data
  })
}

export function updateFinancePlan(data) {
  return request({
    url: '/business/financeplan',
    method: 'put',
    data: data
  })
}

export function delFinancePlan(planIds) {
  return request({
    url: '/business/financeplan/' + planIds,
    method: 'delete'
  })
}