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

// 按目标类型+目标ID取消收藏
export function cancelCollectionByTarget(targetType, targetId) {
  return request({
    url: `/app/collection/target`,
    method: 'delete',
    params: { targetType, targetId }
  })
}

// 查询指定目标的收藏状态
export function getFavoriteStatus(targetType, targetId) {
  return request({
    url: '/app/collection/status',
    method: 'get',
    params: { targetType, targetId }
  })
}

// 获取收藏数量
export function getCollectionCount() {
  return request({
    url: '/app/collection/count',
    method: 'get'
  })
}
