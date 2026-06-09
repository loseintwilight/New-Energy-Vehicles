<template>
  <view class="setting-container">
    <!-- 通知设置 -->
    <view class="setting-card">
      <view class="card-header">
        <text class="card-title">通知设置</text>
      </view>
      <view class="card-content">
        <view class="setting-item" @click="toggleNotification('push')">
          <view class="item-left">
            <uni-icons type="notification" size="26" color="#3c96f3"></uni-icons>
            <text class="item-name">推送通知</text>
          </view>
          <switch :checked="settings.pushNotification" @change="onPushChange" color="#3c96f3" />
        </view>
        <view class="setting-item" @click="toggleNotification('order')">
          <view class="item-left">
            <uni-icons type="list" size="26" color="#3c96f3"></uni-icons>
            <text class="item-name">订单通知</text>
          </view>
          <switch :checked="settings.orderNotification" @change="onOrderChange" color="#3c96f3" />
        </view>
        <view class="setting-item" @click="toggleNotification('coupon')">
          <view class="item-left">
            <uni-icons type="gift" size="26" color="#3c96f3"></uni-icons>
            <text class="item-name">优惠券通知</text>
          </view>
          <switch :checked="settings.couponNotification" @change="onCouponChange" color="#3c96f3" />
        </view>
        <view class="setting-item" @click="toggleNotification('system')">
          <view class="item-left">
            <uni-icons type="gear" size="26" color="#3c96f3"></uni-icons>
            <text class="item-name">系统通知</text>
          </view>
          <switch :checked="settings.systemNotification" @change="onSystemChange" color="#3c96f3" />
        </view>
      </view>
    </view>

    <!-- 隐私设置 -->
    <view class="setting-card">
      <view class="card-header">
        <text class="card-title">隐私设置</text>
      </view>
      <view class="card-content">
        <view class="setting-item" @click="togglePrivacy('location')">
          <view class="item-left">
            <uni-icons type="location" size="26" color="#3c96f3"></uni-icons>
            <text class="item-name">位置信息</text>
          </view>
          <switch :checked="privacy.locationEnabled" @change="onLocationChange" color="#3c96f3" />
        </view>
        <view class="setting-item" @click="togglePrivacy('camera')">
          <view class="item-left">
            <uni-icons type="camera" size="26" color="#3c96f3"></uni-icons>
            <text class="item-name">相机权限</text>
          </view>
          <switch :checked="privacy.cameraEnabled" @change="onCameraChange" color="#3c96f3" />
        </view>
        <view class="setting-item" @click="togglePrivacy('album')">
          <view class="item-left">
            <uni-icons type="image" size="26" color="#3c96f3"></uni-icons>
            <text class="item-name">相册权限</text>
          </view>
          <switch :checked="privacy.albumEnabled" @change="onAlbumChange" color="#3c96f3" />
        </view>
      </view>
    </view>

    <!-- 缓存设置 -->
    <view class="setting-card">
      <view class="card-header">
        <text class="card-title">缓存设置</text>
      </view>
      <view class="card-content">
        <view class="setting-item" @click="clearCache">
          <view class="item-left">
            <uni-icons type="trash" size="26" color="#3c96f3"></uni-icons>
            <text class="item-name">清除缓存</text>
          </view>
          <view class="item-right">
            <text class="cache-size">{{ cacheSize }}</text>
            <uni-icons type="forward" size="20" color="#ccc"></uni-icons>
          </view>
        </view>
      </view>
    </view>

    <!-- 通用设置 -->
    <view class="setting-card">
      <view class="card-header">
        <text class="card-title">通用设置</text>
      </view>
      <view class="card-content">
        <view class="setting-item" @click="handleLanguage">
          <view class="item-left">
            <uni-icons type="world" size="26" color="#3c96f3"></uni-icons>
            <text class="item-name">语言</text>
          </view>
          <view class="item-right">
            <text class="item-value">简体中文</text>
            <uni-icons type="forward" size="20" color="#ccc"></uni-icons>
          </view>
        </view>
        <view class="setting-item" @click="handleTheme">
          <view class="item-left">
            <uni-icons type="color" size="26" color="#3c96f3"></uni-icons>
            <text class="item-name">主题</text>
          </view>
          <view class="item-right">
            <text class="item-value">跟随系统</text>
            <uni-icons type="forward" size="20" color="#ccc"></uni-icons>
          </view>
        </view>
      </view>
    </view>

    <!-- 其他选项 -->
    <view class="setting-card">
      <view class="card-header">
        <text class="card-title">其他</text>
      </view>
      <view class="card-content">
        <view class="setting-item" @click="handleFeedback">
          <view class="item-left">
            <uni-icons type="chatboxes" size="26" color="#3c96f3"></uni-icons>
            <text class="item-name">意见反馈</text>
          </view>
          <uni-icons type="forward" size="20" color="#ccc"></uni-icons>
        </view>
        <view class="setting-item" @click="handleHelp">
          <view class="item-left">
            <uni-icons type="help-circle" size="26" color="#3c96f3"></uni-icons>
            <text class="item-name">帮助中心</text>
          </view>
          <uni-icons type="forward" size="20" color="#ccc"></uni-icons>
        </view>
        <view class="setting-item" @click="handleAbout">
          <view class="item-left">
            <uni-icons type="info-circle" size="26" color="#3c96f3"></uni-icons>
            <text class="item-name">关于我们</text>
          </view>
          <uni-icons type="forward" size="20" color="#ccc"></uni-icons>
        </view>
      </view>
    </view>

    <!-- 版本信息 -->
    <view class="version-section">
      <text class="version-text">新能源汽车服务平台 v1.0.0</text>
    </view>
  </view>
</template>

<script>
  export default {
    data() {
      return {
        settings: {
          pushNotification: true,
          orderNotification: true,
          couponNotification: true,
          systemNotification: true
        },
        privacy: {
          locationEnabled: true,
          cameraEnabled: true,
          albumEnabled: true
        },
        cacheSize: '12.5 MB'
      }
    },
    onLoad() {
      this.loadSettings()
    },
    methods: {
      loadSettings() {
        // 模拟加载设置
      },
      onPushChange(e) {
        this.settings.pushNotification = e.detail.value
        this.saveSettings()
      },
      onOrderChange(e) {
        this.settings.orderNotification = e.detail.value
        this.saveSettings()
      },
      onCouponChange(e) {
        this.settings.couponNotification = e.detail.value
        this.saveSettings()
      },
      onSystemChange(e) {
        this.settings.systemNotification = e.detail.value
        this.saveSettings()
      },
      onLocationChange(e) {
        this.privacy.locationEnabled = e.detail.value
        this.saveSettings()
      },
      onCameraChange(e) {
        this.privacy.cameraEnabled = e.detail.value
        this.saveSettings()
      },
      onAlbumChange(e) {
        this.privacy.albumEnabled = e.detail.value
        this.saveSettings()
      },
      toggleNotification(type) {
        // 点击区域切换开关
      },
      togglePrivacy(type) {
        // 点击区域切换开关
      },
      saveSettings() {
        // 模拟保存设置
      },
      clearCache() {
        uni.showModal({
          title: '清除缓存',
          content: '确定要清除所有缓存吗？',
          success: (res) => {
            if (res.confirm) {
              this.$modal.loading('清除中...')
              setTimeout(() => {
                this.$modal.closeLoading()
                this.cacheSize = '0 B'
                this.$modal.msgSuccess('缓存清除成功')
              }, 1000)
            }
          }
        })
      },
      handleLanguage() {
        uni.showToast({
          title: '当前已是简体中文',
          icon: 'none'
        })
      },
      handleTheme() {
        uni.showToast({
          title: '主题设置',
          icon: 'none'
        })
      },
      handleFeedback() {
        uni.navigateTo({
          url: '/pages/mine/feedback/index'
        })
      },
      handleHelp() {
        uni.navigateTo({
          url: '/pages/mine/help/index'
        })
      },
      handleAbout() {
        uni.navigateTo({
          url: '/pages/mine/about/index'
        })
      }
    }
  }
</script>

<style lang="scss" scoped>
  page {
    background-color: #f5f6f7;
    min-height: 100vh;
  }

  .setting-container {
    padding: 30rpx;
    padding-bottom: 100rpx;
  }

  .setting-card {
    background-color: #fff;
    border-radius: 16rpx;
    margin-bottom: 20rpx;
    overflow: hidden;
    box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
  }

  .card-header {
    padding: 24rpx 30rpx;
    border-bottom: 1rpx solid #f0f0f0;
  }

  .card-title {
    font-size: 28rpx;
    font-weight: 600;
    color: #333;
  }

  .card-content {
    padding: 10rpx 0;
  }

  .setting-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 26rpx 30rpx;
    border-bottom: 1rpx solid #f5f5f5;
  }

  .setting-item:last-child {
    border-bottom: none;
  }

  .item-left {
    display: flex;
    align-items: center;
  }

  .item-icon {
    font-size: 28rpx;
    color: #3c96f3;
    margin-right: 16rpx;
  }

  .item-name {
    font-size: 28rpx;
    color: #333;
  }

  .item-right {
    display: flex;
    align-items: center;
  }

  .item-value {
    font-size: 26rpx;
    color: #999;
    margin-right: 12rpx;
  }

  .cache-size {
    font-size: 26rpx;
    color: #999;
    margin-right: 12rpx;
  }

  .arrow-icon {
    font-size: 24rpx;
    color: #ccc;
  }

  /* 版本信息 */
  .version-section {
    padding: 40rpx;
    text-align: center;
  }

  .version-text {
    font-size: 24rpx;
    color: #999;
  }

  .icon-bell:before {
    content: "\e609";
  }

  .icon-ticket:before {
    content: "\e60f";
  }

  .icon-map:before {
    content: "\e63f";
  }

  .icon-trash:before {
    content: "\e612";
  }

  .icon-globe:before {
    content: "\e616";
  }

  .icon-palette:before {
    content: "\e617";
  }

  .icon-help:before {
    content: "\e618";
  }

  .icon-info:before {
    content: "\e619";
  }
</style>