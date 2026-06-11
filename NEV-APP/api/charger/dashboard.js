import request from '@/utils/request'

/** 获取工作台首页数据 */
export function getDashboardData() {
  return request({
    url: '/app/charge/dashboard',
    method: 'GET'
  })
}
