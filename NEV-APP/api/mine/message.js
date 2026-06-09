// 消息API - 暂时禁用，返回模拟数据

// 获取消息列表
export function getMessageList(params) {
  return Promise.resolve({
    code: 200,
    msg: 'success',
    data: {
      list: [],
      total: 0
    }
  })
}

// 获取未读消息数量
export function getUnreadCount() {
  return Promise.resolve({
    code: 200,
    msg: 'success',
    data: 0
  })
}

// 标记消息已读
export function markAsRead(id) {
  return Promise.resolve({
    code: 200,
    msg: 'success'
  })
}

// 标记所有消息已读
export function markAllAsRead() {
  return Promise.resolve({
    code: 200,
    msg: 'success'
  })
}

// 删除消息
export function deleteMessage(id) {
  return Promise.resolve({
    code: 200,
    msg: 'success'
  })
}