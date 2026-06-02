import request from '@/utils/request'

export function listMerchant(query) {
  return request({
    url: '/business/merchant/list',
    method: 'get',
    params: query
  })
}

export function getMerchant(merchantId) {
  return request({
    url: '/business/merchant/' + merchantId,
    method: 'get'
  })
}

export function addMerchant(data) {
  return request({
    url: '/business/merchant',
    method: 'post',
    data: data
  })
}

export function updateMerchant(data) {
  return request({
    url: '/business/merchant',
    method: 'put',
    data: data
  })
}

export function delMerchant(merchantIds) {
  return request({
    url: '/business/merchant/' + merchantIds,
    method: 'delete'
  })
}