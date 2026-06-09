import request from '@/utils/request'

// 提交意见反馈
export function submitFeedback(data) {
  return request({
    url: '/app/feedback',
    method: 'post',
    data
  })
}

// 获取反馈历史
export function getFeedbackList(params) {
  return request({
    url: '/app/feedback/list',
    method: 'get',
    params
  })
}

// 获取反馈详情
export function getFeedbackDetail(id) {
  return request({
    url: `/app/feedback/${id}`,
    method: 'get'
  })
}
