import config from '@/config'
import storage from '@/utils/storage'
import constant from '@/utils/constant'
import { isHttp, isEmpty } from "@/utils/validate"
import { login, logout, getInfo } from '@/api/login'
import { getMerchantIdentity } from '@/api/system/endSwitch'
import { getToken, setToken, removeToken } from '@/utils/auth'
import defAva from '@/static/images/profile.jpg'

const baseUrl = config.baseUrl

const user = {
  state: {
    token: getToken(),
    id: storage.get(constant.id),
    name: storage.get(constant.name),
    avatar: storage.get(constant.avatar),
    roles: storage.get(constant.roles),
    permissions: storage.get(constant.permissions),
    phonenumber: storage.get(constant.phonenumber) || '',
    currentEnd: storage.get(constant.currentEnd) || 'auto'
  },

  mutations: {
    SET_TOKEN: (state, token) => {
      state.token = token
    },
    SET_ID: (state, id) => {
      state.id = id
      storage.set(constant.id, id)
    },
    SET_NAME: (state, name) => {
      state.name = name
      storage.set(constant.name, name)
    },
    SET_AVATAR: (state, avatar) => {
      state.avatar = avatar
      storage.set(constant.avatar, avatar)
    },
    SET_ROLES: (state, roles) => {
      state.roles = roles
      storage.set(constant.roles, roles)
    },
    SET_PERMISSIONS: (state, permissions) => {
      state.permissions = permissions
      storage.set(constant.permissions, permissions)
    },
    SET_CURRENT_END: (state, currentEnd) => {
      state.currentEnd = currentEnd
      storage.set(constant.currentEnd, currentEnd)
    },
    SET_PHONENUMBER: (state, phonenumber) => {
      state.phonenumber = phonenumber
      storage.set(constant.phonenumber, phonenumber)
    }
  },

  actions: {
    // 登录
    Login({ commit }, userInfo) {
      const username = userInfo.username.trim()
      const password = userInfo.password
      const code = userInfo.code
      const uuid = userInfo.uuid
      return new Promise((resolve, reject) => {
        login(username, password, code, uuid).then(res => {
          setToken(res.token)
          commit('SET_TOKEN', res.token)
          resolve()
        }).catch(error => {
          reject(error)
        })
      })
    },

    // 获取用户信息
    GetInfo({ commit, state }) {
      return new Promise((resolve, reject) => {
        getInfo().then(res => {
          const user = res.user
		  let avatar = user.avatar || ""
		  if (!isHttp(avatar)) {
            avatar = (isEmpty(avatar)) ? defAva : baseUrl + avatar
          }
          const userid = (isEmpty(user) || isEmpty(user.userId)) ? "" : user.userId
		  const username = (isEmpty(user) || isEmpty(user.userName)) ? "" : user.userName
		  if (res.roles && res.roles.length > 0) {
            commit('SET_ROLES', res.roles)
            commit('SET_PERMISSIONS', res.permissions)
          } else {
            commit('SET_ROLES', ['ROLE_DEFAULT'])
          }
          commit('SET_ID', userid)
          commit('SET_NAME', username)
          commit('SET_AVATAR', avatar)
          commit('SET_PHONENUMBER', user.phonenumber || '')

          // 从数据库查询商户身份（替代硬编码的 endTypeMap）
          if (state.currentEnd === 'auto') {
            getMerchantIdentity().then(idRes => {
              const idData = idRes.data
              if (idData && idData.merchantType) {
                const typeMap = { 'maintenance': 'merchant', 'charger': 'charging', 'dealer': 'business' }
                commit('SET_CURRENT_END', typeMap[idData.merchantType] || 'user')
              } else {
                commit('SET_CURRENT_END', 'user')
              }
              resolve(res)
            }).catch(() => {
              commit('SET_CURRENT_END', 'user')
              resolve(res)
            })
          } else {
            resolve(res)
          }
        }).catch(error => {
          reject(error)
        })
      })
    },

    // 退出系统
    LogOut({ commit, state }) {
      return new Promise((resolve, reject) => {
        logout(state.token).then(() => {
          commit('SET_TOKEN', '')
          commit('SET_ROLES', [])
          commit('SET_PERMISSIONS', [])
          commit('SET_CURRENT_END', 'auto')
          removeToken()
          storage.clean()
          resolve()
        }).catch(error => {
          reject(error)
        })
      })
    }
  }
}

export default user
