import request from '@/utils/request'

export function listStation(query) {
  return request({
    url: '/business/station/list',
    method: 'get',
    params: query
  })
}

export function getStation(stationId) {
  return request({
    url: '/business/station/' + stationId,
    method: 'get'
  })
}

export function addStation(data) {
  return request({
    url: '/business/station',
    method: 'post',
    data: data
  })
}

export function updateStation(data) {
  return request({
    url: '/business/station',
    method: 'put',
    data: data
  })
}

export function delStation(stationIds) {
  return request({
    url: '/business/station/' + stationIds,
    method: 'delete'
  })
}