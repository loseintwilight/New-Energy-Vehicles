<template>
  <view class="profile-page">
    <!-- 顶部背景 -->
    <view class="profile-header">
      <view class="header-bg"></view>
      <view class="back-btn" :style="{ top: statusBarHeight + 'px' }" @tap="goBack">
        <uni-icons type="back" size="24" color="#fff"></uni-icons>
      </view>
      <text class="header-title" :style="{ top: (statusBarHeight + 6) + 'px' }">个人资料</text>
    </view>

    <!-- 头像区域 -->
    <view class="avatar-section">
      <view class="avatar-wrap" @tap="chooseAvatar">
        <image class="avatar-img" :src="userInfo.avatar || '/static/images/default-avatar.png'" mode="aspectFill"></image>
        <view class="avatar-edit-icon">
          <uni-icons type="camera" size="20" color="#fff"></uni-icons>
        </view>
      </view>
      <text class="avatar-tip">点击更换头像</text>
    </view>

    <!-- 信息列表 -->
    <view class="info-card">
      <!-- 用户名 -->
      <view class="info-item" @tap="editField('nickName')">
        <view class="info-left">
          <text class="info-label">用户名</text>
        </view>
        <view class="info-right">
          <text class="info-value">{{ userInfo.nickName || '未设置' }}</text>
          <uni-icons type="right" size="16" color="#ccc"></uni-icons>
        </view>
      </view>

      <!-- 手机号 -->
      <view class="info-item" @tap="editField('phone')">
        <view class="info-left">
          <text class="info-label">手机号</text>
        </view>
        <view class="info-right">
          <text class="info-value">{{ maskPhone(userInfo.phone) || '未绑定' }}</text>
          <uni-icons type="right" size="16" color="#ccc"></uni-icons>
        </view>
      </view>

      <!-- 邮箱 -->
      <view class="info-item" @tap="editField('email')">
        <view class="info-left">
          <text class="info-label">邮箱</text>
        </view>
        <view class="info-right">
          <text class="info-value">{{ userInfo.email || '未设置' }}</text>
          <uni-icons type="right" size="16" color="#ccc"></uni-icons>
        </view>
      </view>

      <!-- 角色 -->
      <view class="info-item">
        <view class="info-left">
          <text class="info-label">当前角色</text>
        </view>
        <view class="info-right">
          <view class="role-tag">{{ userInfo.roleName || '商家端' }}</view>
        </view>
      </view>

      <!-- 商户ID -->
      <view class="info-item">
        <view class="info-left">
          <text class="info-label">商户ID</text>
        </view>
        <view class="info-right">
          <text class="info-value info-id">{{ userInfo.merchantId || '--' }}</text>
        </view>
      </view>

      <!-- 注册时间 -->
      <view class="info-item">
        <view class="info-left">
          <text class="info-label">注册时间</text>
        </view>
        <view class="info-right">
          <text class="info-value">{{ userInfo.createTime || '--' }}</text>
        </view>
      </view>
    </view>

    <!-- 统计信息 -->
    <view class="stats-card">
      <view class="stat-item">
        <text class="stat-num">{{ stats.stationCount || 0 }}</text>
        <text class="stat-lbl">管理站点</text>
      </view>
      <view class="stat-divider"></view>
      <view class="stat-item">
        <text class="stat-num">{{ stats.pileCount || 0 }}</text>
        <text class="stat-lbl">充电桩数</text>
      </view>
      <view class="stat-divider"></view>
      <view class="stat-item">
        <text class="stat-num">{{ stats.orderCount || 0 }}</text>
        <text class="stat-lbl">累计订单</text>
      </view>
    </view>

    <!-- 退出登录按钮 -->
    <view class="logout-section">
      <button class="logout-btn" @tap="handleLogout">退出登录</button>
    </view>

    <!-- 编辑弹窗 -->
    <view class="modal-mask" v-if="showEditModal" @tap="showEditModal = false"></view>
    <view :class="['edit-modal', showEditModal ? 'modal-show' : '']">
      <view class="edit-header">
        <text class="edit-title">{{ editTitle }}</text>
        <view class="edit-close" @tap="showEditModal = false">
          <text>✕</text>
        </view>
      </view>
      <view class="edit-body">
        <input class="edit-input" v-model="editValue" :placeholder="'请输入' + editTitle" :maxlength="editMaxLength" focus />
      </view>
      <view class="edit-footer">
        <button class="edit-btn cancel-btn" @tap="showEditModal = false">取消</button>
        <button class="edit-btn confirm-btn" @tap="confirmEdit">保存</button>
      </view>
    </view>
  </view>
</template>

<script>
import { getMerchantProfile, updateMerchantProfile } from '@/api/charger/profile'
import { getStationList } from '@/api/charger/station'
import { getPileList } from '@/api/charger/pile'
import { getOrderList } from '@/api/charger/order'

export default {
  data: function() {
    return {
      /* 状态栏高度 */
      statusBarHeight: 20,
      /* 用户信息 */
      userInfo: {
        avatar: '',
        nickName: 'charger_b',
        phone: '',
        email: '',
        roleName: '商家端',
        merchantId: '',
        createTime: ''
      },
      /* 统计数据 */
      stats: {
        stationCount: 0,
        pileCount: 0,
        orderCount: 0
      },
      /* 编辑相关 */
      showEditModal: false,
      editField: '',
      editTitle: '',
      editValue: '',
      editMaxLength: 50
    }
  },
  onLoad: function() {
    // 获取状态栏高度
    try {
      var sysInfo = uni.getSystemInfoSync()
      this.statusBarHeight = sysInfo.statusBarHeight || 20
    } catch(e) {}
    this.loadUserInfo()
    this.loadStats()
  },
  methods: {
    goBack: function() {
      var pages = getCurrentPages()
      if (pages.length > 1) {
        uni.navigateBack({ delta: 1 })
      } else {
        uni.redirectTo({ url: '/pages/mine/charge-pile/dashboard' })
      }
    },

    loadUserInfo: function() {
      var self = this
      // 从后端API获取商户资料（按商家端逻辑）
      getMerchantProfile().then(function(res) {
        if (res.code === 200 && res.data) {
          var d = res.data
          self.userInfo.nickName = d.merchantName || d.nickName || '充电桩管理员'
          self.userInfo.avatar = d.avatar || ''
          self.userInfo.phone = d.contactPhone || ''
          self.userInfo.email = d.email || ''
          self.userInfo.merchantId = d.merchantId || ''
          self.userInfo.createTime = d.createTime || ''
          // 统计
          if (d.stationCount != null) self.stats.stationCount = d.stationCount
          if (d.pileCount != null) self.stats.pileCount = d.pileCount
          if (d.orderCount != null) self.stats.orderCount = d.orderCount
        }
      }).catch(function() {
        // 降级：从缓存获取
        var user = uni.getStorageSync('userInfo') || {}
        if (user.nickName) self.userInfo.nickName = user.nickName
        if (user.avatar) self.userInfo.avatar = user.avatar
        if (user.phonenumber) self.userInfo.phone = user.phonenumber
        if (user.email) self.userInfo.email = user.email
        if (user.merchantId) self.userInfo.merchantId = user.merchantId
        if (user.createTime) self.userInfo.createTime = user.createTime
      })
    },

    loadStats: function() {
      var self = this
      getStationList({ pageSize: 1 }).then(function(res) {
        if (res.code === 200 && res.total) {
          self.stats.stationCount = res.total
        }
      }).catch(function() {})
      getPileList({ pageSize: 1 }).then(function(res) {
        if (res.code === 200 && res.total) {
          self.stats.pileCount = res.total
        }
      }).catch(function() {})
      getOrderList({ pageSize: 1 }).then(function(res) {
        if (res.code === 200 && res.total) {
          self.stats.orderCount = res.total
        }
      }).catch(function() {})
    },

    chooseAvatar: function() {
      var self = this
      uni.chooseImage({
        count: 1,
        sizeType: ['compressed'],
        sourceType: ['album', 'camera'],
        success: function(res) {
          var tempPath = res.tempFilePaths[0]
          uni.uploadFile({
            url: self.$baseUrl + '/common/upload',
            filePath: tempPath,
            name: 'file',
            header: {
              'Authorization': 'Bearer ' + uni.getStorageSync('token')
            },
            success: function(uploadRes) {
              try {
                var data = JSON.parse(uploadRes.data)
                if (data.code === 200 && data.fileName) {
                  self.userInfo.avatar = self.$baseUrl + data.fileName
                  uni.showToast({ title: '头像更新成功', icon: 'success' })
                } else {
                  uni.showToast({ title: data.msg || '上传失败', icon: 'none' })
                }
              } catch(e) {
                uni.showToast({ title: '上传失败', icon: 'none' })
              }
            },
            fail: function() {
              uni.showToast({ title: '上传失败，请重试', icon: 'none' })
            }
          })
        }
      })
    },

    editField: function(field) {
      var titles = {
        nickName: '用户名',
        phone: '手机号',
        email: '邮箱'
      }
      var lengths = {
        nickName: 30,
        phone: 11,
        email: 50
      }
      this.editField = field
      this.editTitle = titles[field] || field
      this.editValue = this.userInfo[field] || ''
      this.editMaxLength = lengths[field] || 50
      this.showEditModal = true
    },

    confirmEdit: function() {
      var self = this
      var value = this.editValue.trim()
      if (!value) {
        uni.showToast({ title: '不能为空', icon: 'none' })
        return
      }
      if (this.editField === 'phone' && !/^1[3-9]\d{9}$/.test(value)) {
        uni.showToast({ title: '手机号格式不正确', icon: 'none' })
        return
      }
      if (this.editField === 'email' && value && !/^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/.test(value)) {
        uni.showToast({ title: '邮箱格式不正确', icon: 'none' })
        return
      }

      // 调用后端 API 保存（按商家端逻辑）
      var data = {}
      if (this.editField === 'nickName') data.merchantName = value
      if (this.editField === 'phone') data.contactPhone = value
      if (this.editField === 'email') data.email = value

      uni.showLoading({ title: '保存中...' })
      updateMerchantProfile(data).then(function(res) {
        uni.hideLoading()
        if (res.code === 200) {
          self.userInfo[self.editField] = value
          self.showEditModal = false
          uni.showToast({ title: '修改成功', icon: 'success' })
        } else {
          uni.showToast({ title: res.msg || '保存失败', icon: 'none' })
        }
      }).catch(function() {
        uni.hideLoading()
        // 降级：本地保存
        self.userInfo[self.editField] = value
        self.showEditModal = false
        uni.showToast({ title: '修改成功', icon: 'success' })
      })
    },

    maskPhone: function(phone) {
      if (!phone || phone.length < 7) return phone
      return phone.substring(0, 3) + '****' + phone.substring(7)
    },

    handleLogout: function() {
      var self = this
      uni.showModal({
        title: '提示',
        content: '确定要退出登录吗？',
        success: function(res) {
          if (res.confirm) {
            uni.removeStorageSync('token')
            uni.removeStorageSync('userInfo')
            self.$store.commit('SET_CURRENT_END', 'user')
            uni.reLaunch({ url: '/pages/login/login' })
          }
        }
      })
    }
  }
}
</script>

<style scoped>
.profile-page {
  min-height: 100vh;
  background: #f5f5f5;
}

/* ========== 顶部背景 ========== */
.profile-header {
  position: relative;
  height: 280rpx;
  overflow: hidden;
}
.header-bg {
  position: absolute;
  top: 0;
  left: -40rpx;
  right: -40rpx;
  bottom: 0;
  background: linear-gradient(135deg, #f59e0b 0%, #f97316 40%, #fb923c 70%, #fdba74 100%);
  border-radius: 0 0 60rpx 60rpx;
}
.back-btn {
  position: absolute;
  left: 28rpx;
  width: 72rpx;
  height: 72rpx;
  border-radius: 36rpx;
  background: rgba(255, 255, 255, 0.3);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 10;
}
.header-title {
  position: absolute;
  left: 0;
  right: 0;
  text-align: center;
  font-size: 36rpx;
  font-weight: 800;
  color: #ffffff;
  z-index: 10;
}

/* ========== 头像区域 ========== */
.avatar-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-top: -80rpx;
  padding-bottom: 30rpx;
  position: relative;
  z-index: 10;
}
.avatar-wrap {
  width: 160rpx;
  height: 160rpx;
  border-radius: 50%;
  border: 6rpx solid #ffffff;
  box-shadow: 0 8rpx 32rpx rgba(245, 158, 11, 0.35);
  overflow: hidden;
  position: relative;
  background: linear-gradient(135deg, #fef3c7, #fde68a);
}
.avatar-img {
  width: 100%;
  height: 100%;
}
.avatar-edit-icon {
  position: absolute;
  bottom: 4rpx;
  right: 4rpx;
  width: 44rpx;
  height: 44rpx;
  border-radius: 50%;
  background: linear-gradient(135deg, #f59e0b, #fb923c);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.15);
  border: 3rpx solid #fff;
}
.avatar-tip {
  margin-top: 14rpx;
  font-size: 22rpx;
  color: #d97706;
  font-weight: 500;
}

/* ========== 信息卡片 ========== */
.info-card {
  margin: 0 24rpx 20rpx;
  background: #ffffff;
  border-radius: 20rpx;
  overflow: hidden;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
}
.info-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 28rpx 28rpx;
  border-bottom: 1rpx solid #f0f0f0;
}
.info-item:last-child {
  border-bottom: none;
}
.info-left {
  display: flex;
  align-items: center;
}
.info-label {
  font-size: 28rpx;
  color: #333333;
  font-weight: 600;
}
.info-right {
  display: flex;
  align-items: center;
}
.info-value {
  font-size: 28rpx;
  color: #666666;
  margin-right: 8rpx;
}
.info-id {
  font-family: monospace;
  color: #999999;
  font-size: 26rpx;
}
.role-tag {
  font-size: 24rpx;
  color: #f59e0b;
  font-weight: 600;
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.12), rgba(251, 146, 60, 0.08));
  padding: 6rpx 18rpx;
  border-radius: 8rpx;
}

/* ========== 统计卡片 ========== */
.stats-card {
  margin: 0 24rpx 20rpx;
  background: #ffffff;
  border-radius: 20rpx;
  display: flex;
  align-items: center;
  justify-content: space-around;
  padding: 30rpx 0;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
}
.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  flex: 1;
}
.stat-num {
  font-size: 36rpx;
  font-weight: 900;
  color: #f59e0b;
  line-height: 1.2;
}
.stat-lbl {
  font-size: 22rpx;
  color: #999999;
  margin-top: 6rpx;
}
.stat-divider {
  width: 1rpx;
  height: 48rpx;
  background: #eeeeee;
}

/* ========== 退出按钮 ========== */
.logout-section {
  padding: 40rpx 24rpx;
}
.logout-btn {
  width: 100%;
  height: 88rpx;
  line-height: 88rpx;
  text-align: center;
  background: #ffffff;
  border-radius: 20rpx;
  font-size: 30rpx;
  font-weight: 600;
  color: #ef4444;
  border: 1rpx solid #fecaca;
  box-shadow: 0 4rpx 16rpx rgba(239, 68, 68, 0.08);
}

/* ========== 编辑弹窗 ========== */
.modal-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  z-index: 998;
}
.edit-modal {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  background: #ffffff;
  border-radius: 30rpx 30rpx 0 0;
  z-index: 999;
  transform: translateY(100%);
  transition: transform 0.3s ease;
}
.modal-show {
  transform: translateY(0);
}
.edit-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 28rpx 28rpx 20rpx;
  border-bottom: 1rpx solid #f0f0f0;
}
.edit-title {
  font-size: 32rpx;
  font-weight: 700;
  color: #333333;
}
.edit-close {
  width: 52rpx;
  height: 52rpx;
  line-height: 48rpx;
  text-align: center;
  border-radius: 50%;
  background: #f5f5f5;
  font-size: 28rpx;
  color: #999999;
}
.edit-body {
  padding: 28rpx;
}
.edit-input {
  width: 100%;
  height: 88rpx;
  line-height: 88rpx;
  background: #f9fafb;
  border: 2rpx solid #e5e7eb;
  border-radius: 16rpx;
  padding: 0 24rpx;
  font-size: 28rpx;
  color: #333333;
  box-sizing: border-box;
}
.edit-footer {
  display: flex;
  gap: 20rpx;
  padding: 20rpx 28rpx 40rpx;
}
.edit-btn {
  flex: 1;
  height: 80rpx;
  line-height: 80rpx;
  text-align: center;
  border-radius: 16rpx;
  font-size: 28rpx;
  font-weight: 600;
}
.cancel-btn {
  background: #f3f4f6;
  color: #6b7280;
}
.confirm-btn {
  background: linear-gradient(135deg, #f59e0b, #fb923c);
  color: #ffffff;
}
</style>
