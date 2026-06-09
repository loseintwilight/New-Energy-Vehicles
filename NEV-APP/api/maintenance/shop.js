import request from '@/utils/request'

// 获取门店列表
export function listShop(params) {
  return request({
    url: '/maintenance/shop/list',
    method: 'get',
    params
  })
}

// 获取门店详情
export function getShop(shopId) {
  return request({
    url: '/maintenance/shop/detail',
    method: 'get',
    params: { shop_id: shopId }
  })
}

// 创建门店
export function createShop(data) {
  return request({
    url: '/maintenance/shop/create',
    method: 'post',
    data
  })
}

// 更新门店
export function updateShop(data) {
  return request({
    url: '/maintenance/shop/update',
    method: 'put',
    data
  })
}

// 删除门店
export function deleteShop(shopId) {
  return request({
    url: '/maintenance/shop/delete',
    method: 'delete',
    params: { shop_id: shopId }
  })
}