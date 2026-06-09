import request from '@/utils/request'

// 获取用户车辆列表
export function getVehicleList() {
  return request({
    url: '/business/vehicle/list',
    method: 'get'
  })
}

// 获取车辆详情
export function getVehicleDetail(id) {
  return request({
    url: `/business/vehicle/${id}`,
    method: 'get'
  })
}

// 添加车辆
export function addVehicle(data) {
  return request({
    url: '/business/vehicle',
    method: 'post',
    data
  })
}

// 更新车辆信息
export function updateVehicle(id, data) {
  return request({
    url: `/business/vehicle/${id}`,
    method: 'put',
    data
  })
}

// 删除车辆
export function deleteVehicle(id) {
  return request({
    url: `/business/vehicle/${id}`,
    method: 'delete'
  })
}

// 设为默认车辆
export function setDefaultVehicle(id) {
  return request({
    url: `/business/vehicle/${id}/default`,
    method: 'put'
  })
}
