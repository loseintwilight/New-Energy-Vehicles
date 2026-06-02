import request from '@/utils/request'

export function listAddress(query) {
  return request({
    url: '/business/address/list',
    method: 'get',
    params: query
  })
}

export function getAddress(addressId) {
  return request({
    url: '/business/address/' + addressId,
    method: 'get'
  })
}

export function addAddress(data) {
  return request({
    url: '/business/address',
    method: 'post',
    data: data
  })
}

export function updateAddress(data) {
  return request({
    url: '/business/address',
    method: 'put',
    data: data
  })
}

export function delAddress(addressIds) {
  return request({
    url: '/business/address/' + addressIds,
    method: 'delete'
  })
}