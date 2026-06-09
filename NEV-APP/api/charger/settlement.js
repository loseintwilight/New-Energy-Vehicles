import request from '@/utils/request'

// 获取结算列表
export function getSettlementList(params) {
  return request({
    url: '/business/chargingsettlement/list',
    method: 'GET',
    params: params
  })
}

// 获取结算详情
export function getSettlementDetail(settlementId) {
  return request({
    url: '/business/chargingsettlement/' + settlementId,
    method: 'GET'
  })
}

// 根据商户ID查询结算列表
export function getSettlementsByMerchant(merchantId) {
  return request({
    url: '/business/chargingsettlement/merchant/' + merchantId,
    method: 'GET'
  })
}

// 新增结算记录
export function addSettlement(data) {
  return request({
    url: '/business/chargingsettlement',
    method: 'POST',
    data: data
  })
}

// 修改结算记录
export function updateSettlement(data) {
  return request({
    url: '/business/chargingsettlement',
    method: 'PUT',
    data: data
  })
}

// 删除结算记录
export function deleteSettlement(settlementIds) {
  return request({
    url: '/business/chargingsettlement/' + settlementIds,
    method: 'DELETE'
  })
}
