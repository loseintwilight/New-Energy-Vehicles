import request from '@/utils/request'

export function listMShop(query) {
  return request({
    url: '/business/maintenance/shop/list',
    method: 'get',
    params: query
  })
}

export function getMShop(shopId) {
  return request({
    url: '/business/maintenance/shop/' + shopId,
    method: 'get'
  })
}

export function addMShop(data) {
  return request({
    url: '/business/maintenance/shop',
    method: 'post',
    data: data
  })
}

export function updateMShop(data) {
  return request({
    url: '/business/maintenance/shop',
    method: 'put',
    data: data
  })
}

export function delMShop(shopIds) {
  return request({
    url: '/business/maintenance/shop/' + shopIds,
    method: 'delete'
  })
}