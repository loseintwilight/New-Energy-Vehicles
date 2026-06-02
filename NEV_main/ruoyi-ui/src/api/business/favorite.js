import request from '@/utils/request'

export function listFavorite(query) {
  return request({
    url: '/business/favorite/list',
    method: 'get',
    params: query
  })
}

export function getFavorite(favoriteId) {
  return request({
    url: '/business/favorite/' + favoriteId,
    method: 'get'
  })
}

export function addFavorite(data) {
  return request({
    url: '/business/favorite',
    method: 'post',
    data: data
  })
}

export function updateFavorite(data) {
  return request({
    url: '/business/favorite',
    method: 'put',
    data: data
  })
}

export function delFavorite(favoriteIds) {
  return request({
    url: '/business/favorite/' + favoriteIds,
    method: 'delete'
  })
}