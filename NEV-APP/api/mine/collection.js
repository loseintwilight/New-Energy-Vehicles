import request from '@/utils/request'

// 获取收藏列表
export function getCollectionList(params) {
  return request({
    url: '/app/collection/list',
    method: 'get',
    params
  })
}

// 添加收藏
export function addCollection(data) {
  return request({
    url: '/app/collection',
    method: 'post',
    data
  })
}

// 取消收藏
export function cancelCollection(id) {
  return request({
    url: `/app/collection/${id}`,
    method: 'delete'
  })
}

// 获取收藏数量
export function getCollectionCount() {
  return request({
    url: '/app/collection/count',
    method: 'get'
  })
}
