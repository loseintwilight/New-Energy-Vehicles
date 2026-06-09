import request from '@/utils/request'

// 获取首页概览数据
export function getDashboardStats() {
  return request({
    url: '/maintenance/dashboard/stats',
    method: 'get'
  })
}

// 获取订单状态分布
export function getStatusDist() {
  return request({
    url: '/maintenance/dashboard/statusDist',
    method: 'get'
  })
}

// 获取月度订单趋势
export function getMonthlyTrend(params) {
  return request({
    url: '/maintenance/dashboard/monthlyTrend',
    method: 'get',
    params
  })
}

// 获取门店评分排行
export function getShopRanking() {
  return request({
    url: '/maintenance/dashboard/shopRanking',
    method: 'get'
  })
}

// 获取首页最近评价
export function getRecentReviews(params) {
  return request({
    url: '/maintenance/dashboard/recentReviews',
    method: 'get',
    params
  })
}