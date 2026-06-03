import request from '@/utils/request'

export function listProfile(query) {
  return request({
    url: '/business/profile/list',
    method: 'get',
    params: query
  })
}

export function getProfile(userId) {
  return request({
    url: '/business/profile/' + userId,
    method: 'get'
  })
}

export function addProfile(data) {
  return request({
    url: '/business/profile',
    method: 'post',
    data: data
  })
}

export function updateProfile(data) {
  return request({
    url: '/business/profile',
    method: 'put',
    data: data
  })
}

export function delProfile(userIds) {
  return request({
    url: '/business/profile/' + userIds,
    method: 'delete'
  })
}