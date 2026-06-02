import request from '@/utils/request'

export function getDashboardStatistics() {
  return request({
    url: '/dashboard/statistics',
    method: 'get'
  })
}