import request from '@/utils/request'

// 获取钱包信息
export function getWalletInfo() {
  return request({
    url: '/app/wallet/info',
    method: 'get'
  })
}

// 钱包充值
export function recharge(data) {
  return request({
    url: '/app/wallet/recharge',
    method: 'post',
    data
  })
}

// 提现
export function withdraw(data) {
  return request({
    url: '/app/wallet/withdraw',
    method: 'post',
    data
  })
}