import request from '@/utils/request'

export function getDashboardStatistics(month, carbonMonth) {
  const params = {}
  if (month) params.month = month
  if (carbonMonth) params.carbonMonth = carbonMonth
  return request({
    url: '/dashboard/statistics',
    method: 'get',
    params
  })
}

export function getScreenData() {
  return request({
    url: '/dashboard/screen',
    method: 'get'
  })
}