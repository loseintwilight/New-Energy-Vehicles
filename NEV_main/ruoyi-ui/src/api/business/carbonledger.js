import request from '@/utils/request'

export function listCarbonLedger(query) {
  return request({
    url: '/business/carbonledger/list',
    method: 'get',
    params: query
  })
}

export function getCarbonLedger(ledgerId) {
  return request({
    url: '/business/carbonledger/' + ledgerId,
    method: 'get'
  })
}

export function listCarbonLedgerByUserId(userId) {
  return request({
    url: '/business/carbonledger/byUser/' + userId,
    method: 'get'
  })
}

export function addCarbonLedger(data) {
  return request({
    url: '/business/carbonledger',
    method: 'post',
    data: data
  })
}

export function updateCarbonLedger(data) {
  return request({
    url: '/business/carbonledger',
    method: 'put',
    data: data
  })
}

export function delCarbonLedger(ledgerIds) {
  return request({
    url: '/business/carbonledger/' + ledgerIds,
    method: 'delete'
  })
}