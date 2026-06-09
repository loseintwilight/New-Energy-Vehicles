import request from '@/utils/request'

// 获取预约列表
export function getReservationList(params) {
  return request({
    url: '/app/reservation/list',
    method: 'get',
    params
  })
}

// 获取预约详情
export function getReservationDetail(id) {
  return request({
    url: `/app/reservation/${id}`,
    method: 'get'
  })
}

// 取消预约
export function cancelReservation(id) {
  return request({
    url: `/app/reservation/cancel/${id}`,
    method: 'put'
  })
}

// 创建预约
export function createReservation(data) {
  return request({
    url: '/app/reservation',
    method: 'post',
    data
  })
}
