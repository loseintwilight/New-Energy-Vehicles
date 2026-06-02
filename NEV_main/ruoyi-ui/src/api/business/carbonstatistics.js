import request from '@/utils/request'

export function listCarbonStatistics(query) {
  return request({
    url: '/business/carbonstatistics/list',
    method: 'get',
    params: query
  })
}

export function getCarbonStatistics(statId) {
  return request({
    url: '/business/carbonstatistics/' + statId,
    method: 'get'
  })
}

export function addCarbonStatistics(data) {
  return request({
    url: '/business/carbonstatistics',
    method: 'post',
    data: data
  })
}

export function updateCarbonStatistics(data) {
  return request({
    url: '/business/carbonstatistics',
    method: 'put',
    data: data
  })
}

export function delCarbonStatistics(statIds) {
  return request({
    url: '/business/carbonstatistics/' + statIds,
    method: 'delete'
  })
}