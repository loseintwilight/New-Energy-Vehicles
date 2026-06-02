import request from '@/utils/request'

export function listFeedback(query) {
  return request({
    url: '/business/feedback/list',
    method: 'get',
    params: query
  })
}

export function getFeedback(feedbackId) {
  return request({
    url: '/business/feedback/' + feedbackId,
    method: 'get'
  })
}

export function addFeedback(data) {
  return request({
    url: '/business/feedback',
    method: 'post',
    data: data
  })
}

export function updateFeedback(data) {
  return request({
    url: '/business/feedback',
    method: 'put',
    data: data
  })
}

export function delFeedback(feedbackIds) {
  return request({
    url: '/business/feedback/' + feedbackIds,
    method: 'delete'
  })
}