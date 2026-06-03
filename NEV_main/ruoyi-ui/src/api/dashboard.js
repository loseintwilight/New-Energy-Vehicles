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