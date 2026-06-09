import request from '@/utils/request'

// 查询客户列表
export function getCustomerList(params) {
  return request({ url: '/app/charge/customer/list', method: 'GET', params: params })
}

// 查询客户详情
export function getCustomerDetail(customerId) {
  return request({ url: '/app/charge/customer/' + customerId, method: 'GET' })
}

// 新增客户
export function addCustomer(data) {
  return request({ url: '/app/charge/customer', method: 'POST', data: data })
}

// 修改客户
export function updateCustomer(data) {
  return request({ url: '/app/charge/customer', method: 'PUT', data: data })
}

// 删除客户
export function deleteCustomer(customerIds) {
  return request({ url: '/app/charge/customer/' + customerIds, method: 'DELETE' })
}
