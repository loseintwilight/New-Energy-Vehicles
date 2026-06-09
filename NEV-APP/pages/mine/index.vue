<template>
  <view class="mine-container">
    <!-- 顶部用户信息区域 -->
    <view class="user-header">
      <view class="header-bg"></view>
      <view class="user-info">
        <view class="avatar-section">
          <view v-if="!avatar" class="avatar-wrapper" @click="handleToAvatar">
            <uni-icons type="user" size="48" color="#fff"></uni-icons>
          </view>
          <image v-else @click="handleToAvatar" :src="avatar" class="avatar-image" mode="aspectFill"></image>
          <view v-if="!name" @click="handleToLogin" class="login-btn">
            <text>登录</text>
          </view>
          <view v-else class="user-detail">
            <view class="user-name">{{ name }}</view>
            <view class="user-phone">{{ phone }}</view>
          </view>
        </view>
        <view @click="handleToInfo" class="edit-btn">
          <uni-icons type="compose" size="22" color="#fff"></uni-icons>
        </view>
      </view>
      
      <!-- 碳积分模块 -->
      <view class="carbon-section" v-if="name" @click="handleToCarbon">
        <view class="carbon-icon-wrapper">
          <uni-icons type="tree" size="40" color="#fff"></uni-icons>
        </view>
        <view class="carbon-content">
          <view class="carbon-title">碳积分</view>
          <view class="carbon-value">{{ carbonPoints }} <text class="carbon-unit">积分</text></view>
          <view class="carbon-desc">累计减少 {{ carbonReduction }} kg CO₂</view>
        </view>
        <view class="carbon-arrow">
          <uni-icons type="forward" size="24" color="#fff"></uni-icons>
        </view>
      </view>
      
      <!-- 用户数据统计 -->
      <view class="stats-row" v-if="name">
        <view class="stat-item" @click="handleToOrders">
          <view class="stat-icon">
            <uni-icons type="list" size="28" color="#3c96f3"></uni-icons>
          </view>
          <view class="stat-value">{{ orderCount }}</view>
          <view class="stat-label">我的订单</view>
        </view>
        <view class="stat-divider"></view>
        <view class="stat-item" @click="handleToFavorites">
          <view class="stat-icon">
            <uni-icons type="heart" size="28" color="#e74c3c"></uni-icons>
          </view>
          <view class="stat-value">{{ favoriteCount }}</view>
          <view class="stat-label">我的收藏</view>
        </view>
        <view class="stat-divider"></view>
        <view class="stat-item" @click="handleToCoupons">
          <view class="stat-icon">
            <uni-icons type="star" size="28" color="#f39c12"></uni-icons>
          </view>
          <view class="stat-value">{{ couponCount }}</view>
          <view class="stat-label">优惠券</view>
        </view>
        <view class="stat-divider"></view>
        <view class="stat-item" @click="handleToWallet">
          <view class="stat-icon">
            <uni-icons type="wallet" size="28" color="#27ae60"></uni-icons>
          </view>
          <view class="stat-value">{{ walletBalance }}</view>
          <view class="stat-label">钱包</view>
        </view>
      </view>
    </view>

    <!-- 快捷功能入口 -->
    <view class="quick-actions">
      <view class="action-grid">
        <view class="action-item" @click="handleToMyCar">
          <view class="action-icon-box bg-gradient-blue">
            <uni-icons type="location" size="44" color="#fff"></uni-icons>
          </view>
          <text class="action-text">我的车辆</text>
        </view>
        <view class="action-item" @click="handleToCharging">
          <view class="action-icon-box bg-gradient-green">
            <uni-icons type="star" size="44" color="#fff"></uni-icons>
          </view>
          <text class="action-text">充电记录</text>
        </view>
        <view class="action-item" @click="handleToReservation">
          <view class="action-icon-box bg-gradient-orange">
            <uni-icons type="calendar" size="44" color="#fff"></uni-icons>
          </view>
          <text class="action-text">预约记录</text>
        </view>
        <view class="action-item" @click="handleToMessages">
          <view class="action-icon-box bg-gradient-purple">
            <uni-icons type="info" size="44" color="#fff"></uni-icons>
          </view>
          <view class="badge" v-if="messageCount > 0">{{ messageCount }}</view>
          <text class="action-text">消息通知</text>
        </view>
        <view class="action-item" @click="handleToService">
          <view class="action-icon-box bg-gradient-pink">
            <uni-icons type="phone" size="44" color="#fff"></uni-icons>
          </view>
          <text class="action-text">在线客服</text>
        </view>
        <view class="action-item" @click="handleToSetting">
          <view class="action-icon-box bg-gradient-cyan">
            <uni-icons type="gear" size="44" color="#fff"></uni-icons>
          </view>
          <text class="action-text">应用设置</text>
        </view>
      </view>
    </view>

    <!-- 端切换模块 -->
    <view class="switch-section">
      <view class="switch-card" @click="handleToSwitch">
        <view class="switch-icon-wrapper">
          <uni-icons type="refresh" size="40" color="#3c96f3"></uni-icons>
        </view>
        <view class="switch-content">
          <view class="switch-title">端切换</view>
          <view class="switch-desc">切换到维修保护端或充电桩端</view>
        </view>
        <view class="switch-arrow">
          <uni-icons type="forward" size="24" color="#ccc"></uni-icons>
        </view>
      </view>
      
    </view>

    <!-- 订单状态 -->
    <view class="order-section" v-if="name">
      <view class="section-header">
        <text class="section-title">我的订单</text>
        <view class="section-more" @click="handleToOrders">
          <text>全部订单</text>
          <uni-icons type="forward" size="20" color="#999"></uni-icons>
        </view>
      </view>
      <view class="order-status">
        <view class="status-item" @click="handleToOrderStatus('unpaid')">
          <view class="status-icon-box bg-orange">
            <uni-icons type="star" size="32" color="#ff9800"></uni-icons>
          </view>
          <text class="status-text">待支付</text>
          <view class="status-badge" v-if="orderStatus.unpaid > 0">{{ orderStatus.unpaid }}</view>
        </view>
        <view class="status-item" @click="handleToOrderStatus('pending')">
          <view class="status-icon-box bg-blue">
            <uni-icons type="circle" size="32" color="#2196f3"></uni-icons>
          </view>
          <text class="status-text">待服务</text>
          <view class="status-badge" v-if="orderStatus.pending > 0">{{ orderStatus.pending }}</view>
        </view>
        <view class="status-item" @click="handleToOrderStatus('completed')">
          <view class="status-icon-box bg-green">
            <uni-icons type="checkmarkempty" size="32" color="#4caf50"></uni-icons>
          </view>
          <text class="status-text">已完成</text>
        </view>
        <view class="status-item" @click="handleToOrderStatus('cancelled')">
          <view class="status-icon-box bg-gray">
            <uni-icons type="close" size="32" color="#9e9e9e"></uni-icons>
          </view>
          <text class="status-text">已取消</text>
        </view>
      </view>
    </view>

    <!-- 功能菜单列表 -->
    <view class="menu-section">
      <view class="menu-list">
        <view class="menu-item" @click="handleToEditInfo">
          <view class="menu-icon-wrapper">
            <uni-icons type="compose" size="28" color="#3c96f3"></uni-icons>
          </view>
          <text class="menu-text">编辑资料</text>
          <uni-icons type="forward" size="22" color="#ccc"></uni-icons>
        </view>
        <view class="menu-item" @click="handleToPwd">
          <view class="menu-icon-wrapper">
            <uni-icons type="info" size="28" color="#3c96f3"></uni-icons>
          </view>
          <text class="menu-text">修改密码</text>
          <uni-icons type="forward" size="22" color="#ccc"></uni-icons>
        </view>
        <view class="menu-item" @click="handleToHelp">
          <view class="menu-icon-wrapper">
            <uni-icons type="info" size="28" color="#3c96f3"></uni-icons>
          </view>
          <text class="menu-text">常见问题</text>
          <uni-icons type="forward" size="22" color="#ccc"></uni-icons>
        </view>
        <view class="menu-item" @click="handleToAbout">
          <view class="menu-icon-wrapper">
            <uni-icons type="info" size="28" color="#3c96f3"></uni-icons>
          </view>
          <text class="menu-text">关于我们</text>
          <uni-icons type="forward" size="22" color="#ccc"></uni-icons>
        </view>
        <view class="menu-item" @click="handleToSetting">
          <view class="menu-icon-wrapper">
            <uni-icons type="gear" size="28" color="#3c96f3"></uni-icons>
          </view>
          <text class="menu-text">应用设置</text>
          <uni-icons type="forward" size="22" color="#ccc"></uni-icons>
        </view>
      </view>
    </view>

    <!-- 退出登录 -->
    <view class="logout-section" v-if="name">
      <button @click="handleLogout" class="logout-btn">退出登录</button>
    </view>
  </view>
</template>
  

<script>
  export default {
    data() {
      return {
        name: this.$store.state.user.name || '',
        phone: this.$store.state.user.phonenumber || '',
        avatar: this.$store.state.user.avatar || '',
        orderCount: 12,
        favoriteCount: 8,
        couponCount: 3,
        walletBalance: '¥50.00',
        messageCount: 2,
        carbonPoints: 2680,
        carbonReduction: 134,
        orderStatus: {
          unpaid: 1,
          pending: 1,
          completed: 2,
          cancelled: 1
        }
      }
    },
    onLoad() {
      this.syncFromGlobalData()
    },
    onShow() {
      this.syncFromGlobalData()
      // 从 Vuex 同步用户信息（编辑后返回即时刷新）
      this.name = this.$store.state.user.name || ''
      this.phone = this.$store.state.user.phonenumber || ''
      this.avatar = this.$store.state.user.avatar || ''
    },
    methods: {
      syncFromGlobalData() {
        const app = getApp()
        if (app.globalData.messageCount !== undefined) {
          this.messageCount = app.globalData.messageCount
        }
        if (app.globalData.orderStatus) {
          this.orderStatus = app.globalData.orderStatus
        }
      },
      handleToLogin() {
        this.$tab.reLaunch('/pages/login')
      },
      handleToInfo() {
        this.$tab.navigateTo('/pages/mine/info/index')
      },
      handleToEditInfo() {
        this.$tab.navigateTo('/pages/mine/info/edit')
      },
      handleToAvatar() {
        this.$tab.navigateTo('/pages/mine/avatar/index')
      },
      handleToPwd() {
        this.$tab.navigateTo('/pages/mine/pwd/index')
      },
      handleToSetting() {
        this.$tab.navigateTo('/pages/mine/setting/index')
      },
      handleToSwitch() {
        this.$tab.navigateTo('/pages/mine/switch/index')
      },
      handleToCarbon() {
        this.$tab.navigateTo('/pages/mine/carbon/index')
      },
      handleToHelp() {
        this.$tab.navigateTo('/pages/mine/help/index')
      },
      handleToAbout() {
        this.$tab.navigateTo('/pages/mine/about/index')
      },
      handleToMyCar() {
        this.$tab.navigateTo('/pages/mine/myCar/index')
      },
      handleToCharging() {
        this.$tab.navigateTo('/pages/mine/charging/index')
      },
      handleToReservation() {
        this.$tab.navigateTo('/pages/mine/reservation/index')
      },
      handleToMessages() {
        this.$tab.navigateTo('/pages/mine/messages/index')
      },
      handleToService() {
        this.$tab.navigateTo('/pages/mine/customer/index')
      },
      handleToFeedback() {
        this.$tab.navigateTo('/pages/mine/feedback/index')
      },
      handleToOrders() {
        this.$tab.navigateTo('/pages/mine/orders/index')
      },
      handleToFavorites() {
        this.$tab.navigateTo('/pages/mine/favorites/index')
      },
      handleToCoupons() {
        this.$tab.navigateTo('/pages/mine/coupons/index')
      },
      handleToWallet() {
        this.$tab.navigateTo('/pages/mine/wallet/index')
      },
      handleToOrderStatus(status) {
        this.$tab.navigateTo('/pages/mine/orders/index?tab=' + status)
      },
      handleLogout() {
        this.$modal.confirm('确定退出登录吗？').then(() => {
          this.$store.dispatch('LogOut').then(() => {
            this.$tab.reLaunch('/pages/login')
          })
        })
      },
      switchToUser() {
        this.$store.commit('SET_CURRENT_END', 'user')
      }
    }
  }
</script>

<style lang="scss" scoped>
  page {
    background-color: #f5f6f7;
    min-height: 100vh;
  }

  .mine-container {
    width: 100%;
    min-height: 100vh;
    padding-bottom: 120rpx;
  }

  /* 用户头部区域 */
  .user-header {
    position: relative;
    padding: 60rpx 30rpx 40rpx;
  }

  .header-bg {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 480rpx;
    background: linear-gradient(135deg, #3c96f3 0%, #6b7bff 100%);
  }

  .user-info {
    position: relative;
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    z-index: 1;
  }

  .avatar-section {
    display: flex;
    align-items: center;
  }

  .avatar-wrapper {
    width: 120rpx;
    height: 120rpx;
    border-radius: 50%;
    background-color: rgba(255, 255, 255, 0.9);
    display: flex;
    justify-content: center;
    align-items: center;
    border: 4rpx solid rgba(255, 255, 255, 0.5);
  }

  .avatar-icon {
    font-size: 56rpx;
    color: #3c96f3;
  }

  .avatar-image {
    width: 120rpx;
    height: 120rpx;
    border-radius: 50%;
    border: 4rpx solid rgba(255, 255, 255, 0.5);
  }

  .login-btn {
    margin-left: 24rpx;
    padding: 16rpx 32rpx;
    background-color: rgba(255, 255, 255, 0.9);
    border-radius: 40rpx;
    font-size: 28rpx;
    color: #3c96f3;
    font-weight: 500;
  }

  .user-detail {
    margin-left: 24rpx;
  }

  .user-name {
    font-size: 34rpx;
    font-weight: 600;
    color: #fff;
    margin-bottom: 8rpx;
  }

  .user-phone {
    font-size: 24rpx;
    color: rgba(255, 255, 255, 0.8);
  }

  .edit-btn {
    width: 60rpx;
    height: 60rpx;
    background-color: rgba(255, 255, 255, 0.2);
    border-radius: 50%;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 28rpx;
    color: #fff;
  }

  /* 数据统计 */
  .stats-row {
    position: relative;
    display: flex;
    justify-content: space-around;
    background-color: #fff;
    margin-top: 24rpx;
    padding: 30rpx 0;
    border-radius: 16rpx;
    box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
    z-index: 1;
  }

  .stat-item {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
  }

  .stat-icon {
    width: 56rpx;
    height: 56rpx;
    background-color: #e6f0ff;
    border-radius: 50%;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-bottom: 12rpx;
  }

  .stat-icon .iconfont {
    font-size: 28rpx;
    color: #3c96f3;
  }

  .stat-value {
    font-size: 32rpx;
    font-weight: 600;
    color: #333;
    margin-bottom: 8rpx;
  }

  .stat-label {
    font-size: 22rpx;
    color: #999;
  }

  .stat-divider {
    width: 1rpx;
    background-color: #f0f0f0;
  }

  /* 快捷功能入口 */
  .quick-actions {
    padding: 20rpx 30rpx;
  }

  .action-grid {
    display: flex;
    flex-wrap: wrap;
    background-color: #fff;
    padding: 30rpx 0;
    border-radius: 16rpx;
    box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
  }

  .action-item {
    width: 33.33%;
    display: flex;
    flex-direction: column;
    align-items: center;
    position: relative;
    padding: 20rpx 0;
  }

  .action-icon-box {
    width: 96rpx;
    height: 96rpx;
    border-radius: 24rpx;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-bottom: 16rpx;
  }

  .bg-gradient-blue {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  }

  .bg-gradient-green {
    background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
  }

  .bg-gradient-orange {
    background: linear-gradient(135deg, #fc4a1a 0%, #f7b733 100%);
  }

  .bg-gradient-purple {
    background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
  }

  .bg-gradient-pink {
    background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
  }

  .bg-gradient-cyan {
    background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  }

  .action-icon-box .iconfont {
    font-size: 44rpx;
    color: #fff;
  }

  .action-text {
    font-size: 24rpx;
    color: #666;
  }

  .badge {
    position: absolute;
    top: 8rpx;
    right: 50%;
    transform: translateX(36rpx);
    min-width: 32rpx;
    height: 32rpx;
    background-color: #ff4757;
    border-radius: 16rpx;
    font-size: 20rpx;
    color: #fff;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 0 8rpx;
  }

  /* 订单区域 */
  .order-section {
    margin: 20rpx 30rpx;
    background-color: #fff;
    border-radius: 16rpx;
    padding: 24rpx;
    box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
  }

  .section-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24rpx;
  }

  .section-title {
    font-size: 30rpx;
    font-weight: 600;
    color: #333;
  }

  .section-more {
    display: flex;
    align-items: center;
    font-size: 24rpx;
    color: #999;
  }

  .section-more .iconfont {
    font-size: 24rpx;
    margin-left: 8rpx;
  }

  .order-status {
    display: flex;
    justify-content: space-around;
  }

  .status-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    position: relative;
  }

  .status-icon-box {
    width: 72rpx;
    height: 72rpx;
    border-radius: 50%;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-bottom: 12rpx;
  }

  .status-icon-box.bg-orange {
    background-color: #fff3e0;
  }

  .status-icon-box.bg-orange .iconfont {
    color: #ff9800;
  }

  .status-icon-box.bg-blue {
    background-color: #e3f2fd;
  }

  .status-icon-box.bg-blue .iconfont {
    color: #2196f3;
  }

  .status-icon-box.bg-green {
    background-color: #e8f5e9;
  }

  .status-icon-box.bg-green .iconfont {
    color: #4caf50;
  }

  .status-icon-box.bg-gray {
    background-color: #f5f5f5;
  }

  .status-icon-box.bg-gray .iconfont {
    color: #9e9e9e;
  }

  .status-icon-box .iconfont {
    font-size: 32rpx;
  }

  .status-text {
    font-size: 22rpx;
    color: #666;
  }

  .status-badge {
    position: absolute;
    top: -8rpx;
    right: -8rpx;
    min-width: 32rpx;
    height: 32rpx;
    background-color: #ff4757;
    border-radius: 16rpx;
    font-size: 20rpx;
    color: #fff;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 0 8rpx;
  }

  /* 碳积分模块 */
  .carbon-section {
    position: relative;
    z-index: 1;
    display: flex;
    align-items: center;
    margin-top: 24rpx;
    background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%);
    border-radius: 16rpx;
    padding: 24rpx;
    box-shadow: 0 4rpx 20rpx rgba(46, 204, 113, 0.3);
  }

  .carbon-icon-wrapper {
    width: 72rpx;
    height: 72rpx;
    background-color: rgba(255, 255, 255, 0.2);
    border-radius: 16rpx;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-right: 20rpx;
  }

  .carbon-content {
    flex: 1;
  }

  .carbon-title {
    font-size: 26rpx;
    color: rgba(255, 255, 255, 0.8);
    margin-bottom: 8rpx;
  }

  .carbon-value {
    font-size: 36rpx;
    font-weight: 700;
    color: #fff;
  }

  .carbon-unit {
    font-size: 24rpx;
    font-weight: 400;
    color: rgba(255, 255, 255, 0.9);
    margin-left: 8rpx;
  }

  .carbon-desc {
    font-size: 22rpx;
    color: rgba(255, 255, 255, 0.7);
    margin-top: 4rpx;
  }

  .carbon-arrow {
    width: 48rpx;
    height: 48rpx;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  /* 端切换模块 */
  .switch-section {
    margin: 20rpx 30rpx;
  }

  .switch-card {
    display: flex;
    align-items: center;
    background: linear-gradient(135deg, #3c96f3 0%, #6b7bff 100%);
    border-radius: 16rpx;
    padding: 30rpx;
    box-shadow: 0 4rpx 20rpx rgba(60, 150, 243, 0.3);
  }

  .switch-icon-wrapper {
    width: 72rpx;
    height: 72rpx;
    background-color: rgba(255, 255, 255, 0.2);
    border-radius: 16rpx;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-right: 20rpx;
  }

  .switch-content {
    flex: 1;
  }

  .switch-title {
    font-size: 30rpx;
    font-weight: 600;
    color: #fff;
    margin-bottom: 8rpx;
  }

  .switch-desc {
    font-size: 24rpx;
    color: rgba(255, 255, 255, 0.8);
  }

  .switch-arrow {
    width: 48rpx;
    height: 48rpx;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  /* 菜单列表 */
  .menu-section {
    margin: 20rpx 30rpx;
    background-color: #fff;
    border-radius: 16rpx;
    overflow: hidden;
    box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
  }

  .menu-list {
    padding: 10rpx 0;
  }

  .menu-item {
    display: flex;
    align-items: center;
    padding: 30rpx;
    border-bottom: 1rpx solid #f0f0f0;
  }

  .menu-item:last-child {
    border-bottom: none;
  }

  .menu-icon-wrapper {
    width: 64rpx;
    height: 64rpx;
    background-color: #f5f6f7;
    border-radius: 16rpx;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-right: 24rpx;
  }

  .menu-icon {
    font-size: 32rpx;
    color: #3c96f3;
  }

  .menu-text {
    flex: 1;
    font-size: 28rpx;
    color: #333;
  }

  .menu-arrow {
    font-size: 24rpx;
    color: #ccc;
  }

  /* 退出登录 */
  .logout-section {
    padding: 40rpx 30rpx;
  }

  .logout-btn {
    width: 100%;
    height: 88rpx;
    background-color: #fff;
    border: 2rpx solid #e0e0e0;
    border-radius: 44rpx;
    font-size: 30rpx;
    color: #666;
  }

  .logout-btn::after {
    border: none;
  }


</style>