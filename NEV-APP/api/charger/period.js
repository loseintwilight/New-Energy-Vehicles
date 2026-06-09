import request from '@/utils/request'

// 获取费率时段列表
export function getPeriodList(params) {
  return request({
    url: '/app/charge/rate/period/list',
    method: 'GET',
    params: params
  })
}

// 获取费率时段详情
export function getPeriodDetail(periodId) {
  return request({
    url: '/app/charge/rate/period/' + periodId,
    method: 'GET'
  })
}

// 根据费率ID查询时段列表
export function getPeriodsByRate(rateId) {
  return request({
    url: '/app/charge/rate/period/rate/' + rateId,
    method: 'GET'
  })
}

// 新增费率时段
export function addPeriod(data) {
  return request({
    url: '/app/charge/rate/period',
    method: 'POST',
    data: data
  })
}

// 修改费率时段
export function updatePeriod(data) {
  return request({
    url: '/app/charge/rate/period',
    method: 'PUT',
    data: data
  })
}

// 删除费率时段
export function deletePeriod(periodIds) {
  return request({
    url: '/app/charge/rate/period/' + periodIds,
    method: 'DELETE'
  })
}

// 根据费率ID删除所有关联时段
export function deletePeriodsByRate(rateId) {
  return request({
    url: '/app/charge/rate/period/rate/' + rateId,
    method: 'DELETE'
  })
}
