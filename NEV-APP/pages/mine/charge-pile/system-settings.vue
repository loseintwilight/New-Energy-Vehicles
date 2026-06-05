<template>
  <view class="settings-page">
    <view class="matrix-bg">
      <view class="dot-row" v-for="(row, r) in 16" :key="r">
        <view class="dot" v-for="(colVal, c) in dotCount(row)" :key="c" :style="{ animationDelay: (row * 0.08 + colVal * 0.12) + 's' }"></view>
      </view>
    </view>
    <view class="overlay-mask"></view>
    <view class="header-area">
      <view class="header-left">
        <view class="back-btn" @tap="goBack" hover-class="back-hover" :hover-stay-time="80">
          <text class="back-icon">❮</text>
        </view>
        <text class="page-title">系统设置</text>
      </view>
    </view>
    <view class="settings-container">
      <view class="settings-glass-card">
        <view
          v-for="(item, index) in settingsList"
          :key="index"
          class="setting-item"
          :class="[
            { 'setting-item-logout': item.key === 'logout' },
            { 'setting-item-last': index === settingsList.length - 1 }
          ]"
          :style="{ animationDelay: (0.1 + index * 0.08) + 's' }"
          @tap="onSettingTap(item)"
          hover-class="setting-hover"
          :hover-stay-time="100"
        >
          <view class="color-bar" :style="{ background: getBarColor(item.key) }"></view>
          <view class="color-spread" :style="{ background: getSpreadGradient(item.key) }"></view>
          <view class="setting-inner">
            <view class="setting-left">
              <view class="setting-icon" :style="{ background: getIconGradient(item.key) }">
                <text>{{ item.icon }}</text>
              </view>
              <text class="setting-name" :class="{ 'name-logout': item.key === 'logout' }">{{ item.name }}</text>
            </view>
            <view class="setting-right">
              <switch
                v-if="item.type === 'switch'"
                :checked="item.checked"
                @change="onSwitchChange($event, item)"
                color="#3b82f6"
                class="custom-switch"
              />
              <template v-else>
                <text class="setting-extra" v-if="item.extra">{{ item.extra }}</text>
                <text class="setting-arrow" :class="{ 'arrow-logout': item.key === 'logout' }">❮</text>
              </template>
            </view>
          </view>
        </view>
      </view>
    </view>
    <view class="version-info">
      <view class="version-logo">❮</view>
      <text class="version-text">V1.0.0</text>
      <text class="copyright-text">© 2026 嘉运科技 · 新能源充电桩</text>
    </view>
    <view class="bottom-spacer"></view>
  </view>
</template>

<script>
export default {
  data: function() {
    return {
      settingsList: []
    }
  },
  onLoad: function() {
    this.loadSettings()
    this.loadSavedPrefs()
  },
  methods: {
    goBack: function() {
      uni.navigateBack({ delta: 1 })
    },
    loadSettings: function() {
      var list = [
        { name: '消息通知', icon: '🔔', iconType: 'notify', type: 'switch', checked: true, key: 'notify' },
        { name: '声音振动', icon: '🔊', iconType: 'sound', type: 'switch', checked: true, key: 'sound' },
        { name: '清除缓存', icon: '🗑', iconType: 'cache', type: 'action', extra: '23.5MB', key: 'cache' },
        { name: '关于我们', icon: 'ℹ️', iconType: 'about', type: 'nav', key: 'about' },
        { name: '退出登录', icon: '🚪', iconType: 'logout', type: 'action', key: 'logout' }
      ]
      this.settingsList = list
    },
    loadSavedPrefs: function() {
      var self = this
      var keys = ['notify', 'sound']
      keys.forEach(function(key) {
        var saved = uni.getStorageSync('setting_' + key)
        if (saved !== '' && saved !== null && saved !== undefined) {
          for (var i = 0; i < self.settingsList.length; i++) {
            if (self.settingsList[i].key === key) {
              self.settingsList[i].checked = saved
              break
            }
          }
        }
      })
    },
    onSettingTap: function(item) {
      var that = this
      if (item.type === 'action') {
        if (item.key === 'cache') {
          uni.showModal({
            title: '清除缓存',
            content: '确定要清除缓存数据吗',
            success: function(res) {
              if (res.confirm) {
                uni.showToast({ title: '缓存已清除', icon: 'success', duration: 1500 })
                that.updateCacheSize('0KB')
              }
            }
          })
        } else if (item.key === 'logout') {
          uni.showModal({
            title: '退出登录',
            content: '确定要退出当前账号吗',
            success: function(res) {
              if (res.confirm) {
                uni.showToast({ title: '已退出登录', icon: 'success', duration: 1500 })
                setTimeout(function() {
                  uni.reLaunch({ url: '/pages/index/index' })
                }, 1500)
              }
            }
          })
        } else if (item.key === 'about') {
          uni.showModal({
            title: '关于我们',
            content: '新能源充电桩商户管理系统\n版本：V1.0.0\n研发：嘉运科技',
            showCancel: false,
            confirmText: '知道了'
          })
        }
      } else {
        uni.showToast({ title: '功能即将上线', icon: 'none', duration: 1500 })
      }
    },
    onSwitchChange: function(e, item) {
      item.checked = e.detail.value
      var statusText = item.checked ? '已开启' : '已关闭'
      uni.setStorageSync('setting_' + item.key, item.checked)
      if (item.key === 'sound' && item.checked) {
        uni.vibrateShort({ type: 'light' })
      }
      uni.showToast({ title: item.name + statusText, icon: 'none', duration: 1200 })
    },
    updateCacheSize: function(size) {
      for (var i = 0; i < this.settingsList.length; i++) {
        if (this.settingsList[i].key === 'cache') {
          this.settingsList[i].extra = size
          break
        }
      }
    },
    dotCount: function(row) {
      if (row <= 4) return 5
      if (row <= 8) return 4
      if (row <= 12) return 3
      return 2
    },
    getBarColor: function(key) {
      var colors = {
        notify: '#2563eb',
        sound: '#16a34a',
        cache: '#ea580c',
        about: '#0891b2',
        logout: '#ef4444'
      }
      return colors[key] || '#16a34a'
    },
    getIconGradient: function(key) {
      var gradients = {
        notify: 'linear-gradient(135deg, #2563eb, #60a5fa)',
        sound: 'linear-gradient(135deg, #16a34a, #4ade80)',
        cache: 'linear-gradient(135deg, #ea580c, #fb923c)',
        about: 'linear-gradient(135deg, #0891b2, #22d3ee)',
        logout: 'linear-gradient(135deg, #ef4444, #f87171)'
      }
      return gradients[key] || 'linear-gradient(135deg, #16a34a, #4ade80)'
    },
    getSpreadGradient: function(key) {
      var color = this.getBarColor(key)
      return 'radial-gradient(circle at left center, ' + color + '22 0%, transparent 70%)'
    },
    triggerVibrate: function() {
      var soundOn = uni.getStorageSync('setting_sound')
      if (soundOn === true || soundOn === 'true') {
        uni.vibrateShort({ type: 'light' })
      }
    },
    showNotify: function(title, icon) {
      var notifyOn = uni.getStorageSync('setting_notify')
      if (notifyOn === true || notifyOn === 'true') {
        uni.showToast({ title: title || '您有新消息', icon: icon || 'none', duration: 2000 })
      }
    }
  }
}
</script>

<style scoped>
.settings-page {
  min-height: 100vh;
  position: relative;
  overflow: hidden;
}
.matrix-bg {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 0;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  gap: 18rpx;
  padding: 40rpx;
  box-sizing: border-box;
}
.dot-row {
  display: flex;
  justify-content: center;
  gap: 18rpx;
}
.dot {
  width: 10rpx;
  height: 10rpx;
  border-radius: 50%;
  background: radial-gradient(circle at center, rgba(107, 114, 128, 0.65) 0%, rgba(107, 114, 128, 0.35) 35%, rgba(156, 163, 175, 0.2) 60%, transparent 100%);
  animation: pulse-dot 3s ease-in-out infinite;
}
@keyframes pulse-dot {
  0%, 100% { opacity: 0.25; transform: scale(1); }
  50% { opacity: 1; transform: scale(1.6); }
}
.overlay-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 1;
  background: linear-gradient(180deg,
    rgba(241, 245, 249, 0.94) 0%,
    rgba(248, 250, 252, 0.96) 30%,
    rgba(255, 255, 255, 0.97) 70%,
    rgba(250, 252, 255, 0.95) 100%
  );
  pointer-events: none;
}
.header-area {
  position: relative;
  z-index: 10;
  display: flex;
  flex-direction: row;
  align-items: center;
  padding: 56rpx 32rpx 28rpx;
  background: linear-gradient(180deg, #4b5563 0%, #6b7280 30%, #9ca3af 60%, #d1d5db 100%);
}
.header-left {
  display: flex;
  flex-direction: row;
  align-items: center;
}
.back-btn {
  width: 68rpx;
  height: 68rpx;
  line-height: 64rpx;
  text-align: center;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.28);
  backdrop-filter: blur(12px);
  margin-right: 20rpx;
  transition: transform 0.25s cubic-bezier(0.34, 1.56, 0.64, 1);
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.1);
}
.back-hover {
  transform: rotate(-12deg) scale(1.08) !important;
  background: rgba(255, 255, 255, 0.45) !important;
}
.back-icon {
  font-size: 38rpx;
  color: #ffffff;
  font-weight: 700;
  margin-left: -2rpx;
}
.page-title {
  font-size: 38rpx;
  font-weight: 800;
  color: #ffffff;
  letter-spacing: 2rpx;
  text-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.15);
}
.settings-container {
  position: relative;
  z-index: 10;
  padding: 24rpx 28rpx 0;
}
.settings-glass-card {
  background: rgba(255, 255, 255, 0.75);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-radius: 28rpx;
  box-shadow:
    0 8rpx 40rpx rgba(107, 114, 128, 0.12),
    0 2rpx 12rpx rgba(0, 0, 0, 0.04);
  overflow: hidden;
  border: 1rpx solid rgba(255, 255, 255, 0.6);
}
.setting-item {
  position: relative;
  display: flex;
  flex-direction: row;
  align-items: stretch;
  overflow: hidden;
  animation: slide-up 0.5s ease both;
  transition: transform 0.2s ease;
}
@keyframes slide-up {
  from {
    opacity: 0;
    transform: translateY(40rpx);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
.setting-item:not(.setting-item-logout):not(.setting-item-last) {
  border-bottom: 1rpx solid rgba(0, 0, 0, 0.04);
}
.setting-item-logout {
  margin-top: 16rpx;
  border-top: 1rpx solid rgba(239, 68, 68, 0.12);
}
.color-bar {
  position: absolute;
  left: 0;
  top: 12rpx;
  bottom: 12rpx;
  width: 5rpx;
  border-radius: 0 4rpx 4rpx 0;
  transition: all 0.3s ease;
  z-index: 2;
}
.color-spread {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  right: 0;
  opacity: 0;
  transition: opacity 0.35s ease;
  z-index: 1;
  pointer-events: none;
}
.setting-inner {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  padding: 30rpx 24rpx 30rpx 28rpx;
  width: 100%;
  position: relative;
  z-index: 3;
}
.setting-left {
  display: flex;
  flex-direction: row;
  align-items: center;
}
.setting-icon {
  width: 64rpx;
  height: 64rpx;
  line-height: 60rpx;
  text-align: center;
  border-radius: 18rpx;
  margin-right: 20rpx;
  flex-shrink: 0;
  font-size: 28rpx;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.12);
}
.setting-name {
  font-size: 30rpx;
  font-weight: 600;
  color: #1e293b;
  letter-spacing: 0.5rpx;
}
.name-logout {
  color: #ef4444 !important;
  font-weight: 700;
}
.setting-right {
  display: flex;
  flex-direction: row;
  align-items: center;
}
.custom-switch {
  transform: scale(0.88);
}
.setting-extra {
  font-size: 24rpx;
  color: #94a3b8;
  margin-right: 8rpx;
  font-weight: 500;
}
.setting-arrow {
  font-size: 32rpx;
  color: #cbd5e1;
  font-weight: 400;
  transition: transform 0.2s ease;
}
.arrow-logout {
  color: #fca5a5;
}
.setting-hover {
  transform: scale(0.98);
}
.setting-hover .color-bar {
  width: 7rpx;
  box-shadow: 0 0 14rpx currentColor;
}
.setting-hover .color-spread {
  opacity: 1;
}
.setting-hover .setting-arrow {
  transform: translateX(4rpx);
}
.version-info {
  position: relative;
  z-index: 10;
  text-align: center;
  padding: 52rpx 0 24rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10rpx;
}
.version-logo {
  font-size: 36rpx;
  opacity: 0.5;
  filter: grayscale(0.3);
}
.version-text {
  font-size: 24rpx;
  color: #94a3b8;
  font-weight: 500;
  letter-spacing: 2rpx;
}
.copyright-text {
  font-size: 20rpx;
  color: #cbd5e1;
  letter-spacing: 1rpx;
}
.bottom-spacer {
  height: 60rpx;
}
</style>
