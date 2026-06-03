import request from '@/utils/request'

export function listGovRegistration(query) {
  return request({
    url: '/business/govregistration/list',
    method: 'get',
    params: query
  })
}

export function getGovRegistration(regId) {
  return request({
    url: '/business/govregistration/' + regId,
    method: 'get'
  })
}

export function addGovRegistration(data) {
  return request({
    url: '/business/govregistration',
    method: 'post',
    data: data
  })
}

export function updateGovRegistration(data) {
  return request({
    url: '/business/govregistration',
    method: 'put',
    data: data
  })
}

export function delGovRegistration(regIds) {
  return request({
    url: '/business/govregistration/' + regIds,
    method: 'delete'
  })
}