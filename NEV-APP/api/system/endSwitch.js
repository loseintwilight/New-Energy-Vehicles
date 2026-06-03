import request from '@/utils/request'

// 查询当前用户的商户身份（查 stad_merchant 表）
// 后端逻辑: SELECT * FROM stad_merchant WHERE user_id = ? AND merchant_type = 'maintenance' AND status = '1'
export function getMerchantIdentity() {
  return request({
    url: '/app/user/merchant/identity',
    method: 'get'
  })
}

// 提交端切换申请（提交给PC管理端审核）
// 表单数据映射到 stad_merchant 表字段：merchant_name, merchant_type, contact_name, contact_phone, province, city, address
export function submitEndSwitchApply(data) {
  return request({
    url: '/app/user/end-switch/apply',
    method: 'post',
    data: data
  })
}

// 取消端切换申请
export function cancelEndSwitchApply() {
  return request({
    url: '/app/user/end-switch/cancel',
    method: 'post'
  })
}

// 查询端切换申请状态
export function getEndSwitchStatus() {
  return request({
    url: '/app/user/end-switch/status',
    method: 'get'
  })
}