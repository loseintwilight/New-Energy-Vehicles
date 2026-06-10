import store from '@/store'
import config from '@/config'
import { getToken } from '@/utils/auth'
import errorCode from '@/utils/errorCode'
import { toast, showConfirm, tansParams } from '@/utils/common'

let timeout = 10000
const baseUrl = config.baseUrl

const request = config => {
  // 是否需要设置 token
  const isToken = (config.headers || {}).isToken === false
  config.header = config.header || {}
  if (getToken() && !isToken) {
    config.header['Authorization'] = 'Bearer ' + getToken()
  }
  // 默认 content-type 为 JSON
  if (!config.header['Content-Type']) {
    config.header['Content-Type'] = 'application/json'
  }
  // get请求映射params参数
  if (config.params) {
    let url = config.url + '?' + tansParams(config.params)
    url = url.slice(0, -1)
    config.url = url
  }
  return new Promise((resolve, reject) => {
    uni.request({
        method: config.method || 'get',
        timeout: config.timeout ||  timeout,
        url: config.baseUrl || baseUrl + config.url,
        data: config.data,
        header: config.header,
        dataType: 'json'
      }).then(response => {
        let [error, res] = response
        if (error) {
          reject(error)
          return
        }
        if (!res || !res.data) {
          reject('响应数据为空')
          return
        }
        // 如果后端返回的不是JSON对象（如错误HTML），直接reject
        if (typeof res.data === 'string') {
          reject('后端服务异常，返回非JSON数据')
          return
        }
        const code = res.data.code || 200
        const msg = errorCode[code] || res.data.msg || errorCode['default']
        // 成功状态码: 200(标准RuoYi) 和 1(自定义R.success())
        const successCodes = [200, 1]
        if (code === 401) {
          showConfirm('登录状态已过期，您可以继续留在该页面，或者重新登录?').then(res => {
            if (res.confirm) {
              store.dispatch('LogOut').then(res => {
                uni.reLaunch({ url: '/pages/login' })
              })
            }
          })
          reject('无效的会话，或者会话已过期，请重新登录。')
        } else if (code === 500) {
          toast(msg)
          reject('500')
        } else if (!successCodes.includes(code)) {
          toast(msg)
          reject(code)
        }
        resolve(res.data)
      })
      .catch(error => {
        let { message } = error
        if (message === 'Network Error') {
          message = '后端接口连接异常'
        } else if (message.includes('timeout')) {
          message = '系统接口请求超时'
        } else if (message.includes('Request failed with status code')) {
          message = '系统接口' + message.slice(-3) + '异常'
        }
        toast(message)
        reject(error)
      })
  })
}

export default request
