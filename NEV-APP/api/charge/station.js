import request from '@/utils/request'

// ===== 充电站接口 =====

/** 1.1 获取充电站列表（分页，带距离排序） */
export function getStationList(params) {
  return request({
    url: '/app/charge/station/list',
    method: 'GET',
    params
  })
}

/** 1.2 获取充电站详情 */
export function getStationDetail(stationId) {
  return request({
    url: '/app/charge/station/detail/' + stationId,
    method: 'GET'
  })
}

/** 1.3 搜索充电站 */
export function searchStations(params) {
  return request({
    url: '/app/charge/station/search',
    method: 'GET',
    params
  })
}

/** 1.4 搜索建议 */
export function getSuggestions(keyword) {
  return request({
    url: '/app/charge/station/suggest',
    method: 'GET',
    params: { keyword }
  })
}

/** 1.5 热门搜索 */
export function getHotSearches() {
  return request({
    url: '/app/charge/station/hot',
    method: 'GET'
  })
}

/** 1.6 收藏/取消收藏 */
export function toggleFavorite(stationId) {
  return request({
    url: '/app/charge/station/favorite',
    method: 'POST',
    data: { stationId }
  })
}

/** 1.7 查询收藏状态 */
export function getFavoriteStatus(stationId) {
  return request({
    url: '/app/charge/station/favorite/status',
    method: 'GET',
    params: { stationId }
  })
}

// ===== 充电桩接口 =====

/** 2.1 获取充电桩列表 */
export function getPileList(stationId) {
  return request({
    url: '/app/charge/pile/list',
    method: 'GET',
    params: { stationId }
  })
}

// ===== 订单接口 =====

/** 3.1 获取订单列表 */
export function getOrderList(params) {
  return request({
    url: '/app/charge/order/list',
    method: 'GET',
    params
  })
}

/** 3.2 开始充电 */
export function startCharge(data) {
  return request({
    url: '/app/charge/order/start',
    method: 'POST',
    data
  })
}

/** 3.3 获取充电状态 */
export function getChargeStatus(orderId) {
  return request({
    url: '/app/charge/order/status/' + orderId,
    method: 'GET'
  })
}

/** 3.4 停止充电 */
export function stopCharge(data) {
  return request({
    url: '/app/charge/order/stop',
    method: 'POST',
    data
  })
}

/** 3.5 支付订单 */
export function payOrder(data) {
  return request({
    url: '/app/charge/order/pay',
    method: 'POST',
    data
  })
}

/** 3.6 取消订单 */
export function cancelOrder(data) {
  return request({
    url: '/app/charge/order/cancel',
    method: 'POST',
    data
  })
}

// ===== 城市接口 =====

/** 4.1 获取城市列表 */
export function getCityList() {
  return request({
    url: '/app/charge/city/list',
    method: 'GET'
  })
}