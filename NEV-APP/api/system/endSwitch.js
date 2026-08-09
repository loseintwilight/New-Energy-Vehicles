import request from '@/utils/request'

// 查询当前用户的所有商户身份（查 stad_merchant 表）
// 返回该用户所有 merchant 记录（每个 merchant_type 一条），含审核状态
export function getMerchantIdentity() {
  return request({
    url: '/app/user/merchant/identity',
    method: 'get'
  })
}

// 提交端切换申请（提交给PC管理端审核）
// 按 userId + endType 独立申请，互不干扰
export function submitEndSwitchApply(data) {
  return request({
    url: '/app/user/end-switch/apply',
    method: 'post',
    data: data
  })
}

// 取消端切换申请（按端类型）
export function cancelEndSwitchApply(data) {
  return request({
    url: '/app/user/end-switch/cancel',
    method: 'post',
    data: data
  })
}

// 查询端切换申请审核状态（按端类型）
export function getEndSwitchStatus(endType) {
  return request({
    url: '/app/user/end-switch/status',
    method: 'get',
    params: { endType: endType }
  })
}