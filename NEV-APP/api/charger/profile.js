import request from '@/utils/request'

/** 获取商户个人资料 */
export function getMerchantProfile() {
  return request({
    url: '/app/charge/merchant/profile',
    method: 'GET'
  })
}

/** 更新商户个人资料 */
export function updateMerchantProfile(data) {
  return request({
    url: '/app/charge/merchant/profile',
    method: 'PUT',
    data: data
  })
}
