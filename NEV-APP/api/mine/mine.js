import request from '@/utils/request'

// 获取用户信息
export function getUserInfo() {
  return request({
    url: '/app/profile/userInfo',
    method: 'get'
  })
}

// 更新用户信息
export function updateUserInfo(data) {
  return request({
    url: '/app/profile/update',
    method: 'put',
    data
  })
}

// 更新头像
export function updateAvatar(data) {
  return request({
    url: '/app/profile/avatar',
    method: 'post',
    data
  })
}

// 修改密码
export function updatePassword(data) {
  return request({
    url: '/app/profile/password',
    method: 'put',
    data
  })
}

// 获取用户统计数据
export function getUserStats() {
  return request({
    url: '/app/profile/stats',
    method: 'get'
  })
}
