<template>
  <view class="mine-container">
    <!-- 顶部用户信息区域 -->
    <view class="user-header">
      <view class="header-bg"></view>
      <view class="user-info">
        <view class="avatar-section">
          <view v-if="!avatar" class="avatar-wrapper" @click="handleToAvatar">
            <uni-icons type="user" size="56" color="#3c96f3"></uni-icons>
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
          <uni-icons type="compose" size="28" color="#fff"></uni-icons>
        </view>
      </view>

      <!-- 碳积分模块 -->
      <view class="carbon-section" v-if="name" @click="handleToCarbon">
        <view class="carbon-icon-wrapper">
          <text class="carbon-c">C</text>
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
            <uni-icons type="list" size="24" color="#3c96f3"></uni-icons>
          </view>
          <view class="stat-label">我的订单</view>
        </view>
        <view class="stat-divider"></view>
        <view class="stat-item" @click="handleToFavorites">
          <view class="stat-icon">
            <uni-icons type="heart" size="24" color="#e74c3c"></uni-icons>
          </view>
          <view class="stat-label">我的收藏</view>
        </view>
        <view class="stat-divider"></view>
        <view class="stat-item" @click="handleToCoupons">
          <view class="stat-icon">
            <uni-icons type="star" size="24" color="#f39c12"></uni-icons>
          </view>
          <view class="stat-label">优惠券</view>
        </view>
        <view class="stat-divider"></view>
        <view class="stat-item" @click="handleToWallet">
          <view class="stat-icon">
            <uni-icons type="wallet" size="24" color="#27ae60"></uni-icons>
          </view>
          <view class="stat-label">钱包</view>
        </view>
      </view>
    </view>

    <!-- 快捷功能入口 -->
    <view class="quick-actions">
      <view class="action-grid">
        <view class="action-item" @click="handleToMyCar">
          <view class="action-icon-box bg-gradient-blue">
            <uni-icons type="location" size="36" color="#fff"></uni-icons>
          </view>
          <text class="action-text">我的车辆</text>
        </view>
        <view class="action-item" @click="handleToCharging">
          <view class="action-icon-box bg-gradient-green">
            <uni-icons type="star" size="36" color="#fff"></uni-icons>
          </view>
          <text class="action-text">充电记录</text>
        </view>
        <view class="action-item" @click="handleToReservation">
          <view class="action-icon-box bg-gradient-orange">
            <uni-icons type="calendar" size="36" color="#fff"></uni-icons>
          </view>
          <text class="action-text">预约记录</text>
        </view>
        <view class="action-item" @click="handleToMessages">
          <view class="action-icon-box bg-gradient-purple">
            <uni-icons type="info" size="36" color="#fff"></uni-icons>
          </view>
          <text class="action-text">消息通知</text>
        </view>
        <view class="action-item" @click="handleToService">
          <view class="action-icon-box bg-gradient-pink">
            <uni-icons type="phone" size="36" color="#fff"></uni-icons>
          </view>
          <text class="action-text">在线客服</text>
        </view>
        <view class="action-item" @click="handleToSetting">
          <view class="action-icon-box bg-gradient-cyan">
            <uni-icons type="gear" size="36" color="#fff"></uni-icons>
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
        </view>
        <view class="status-item" @click="handleToOrderStatus('pending')">
          <view class="status-icon-box bg-blue">
            <uni-icons type="circle" size="32" color="#2196f3"></uni-icons>
          </view>
          <text class="status-text">待服务</text>
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
import { getWalletInfo } from '@/api/mine/wallet'
import { getCarbonOverview } from '@/api/mine/carbon'
import { getCollectionCount } from '@/api/mine/collection'
import { getCouponCount } from '@/api/mine/coupon'
import { getOrderStatusCount } from '@/api/mine/order'

export default {
  data() {
    return {
      name: this.$store.state.user.name || '',
      phone: this.$store.state.user.phonenumber || '',
      avatar: this.$store.state.user.avatar || '',
      carbonPoints: 0,
      carbonReduction: 0,
      // 统计数据
      collectionCount: 0,
      couponCount: 0,
      walletBalance: '0.00',
      orderStatusCount: {
        unpaid: 0,
        pending: 0,
        completed: 0,
        cancelled: 0
      }
    }
  },
  onLoad() {
    this.syncUserInfo()
    this.loadAllData()
  },
  onShow() {
    this.syncUserInfo()
    this.loadAllData()
  },
  methods: {
    syncUserInfo() {
      this.name = this.$store.state.user.name || ''
      this.phone = this.$store.state.user.phonenumber || ''
      this.avatar = this.$store.state.user.avatar || ''
    },
    async loadAllData() {
      await Promise.all([
        this.loadWalletInfo(),
        this.loadCarbonPoints(),
        this.loadCollectionCount(),
        this.loadCouponCount(),
        this.loadOrderStatusCount()
      ])
    },
    async loadWalletInfo() {
      try {
        const res = await getWalletInfo()
        if (res && (res.code === 200 || res.code === 0)) {
          const data = res.data || res
          this.walletBalance = data.balance ? data.balance.toFixed(2) : '0.00'
        }
      } catch (e) {
        console.error('加载钱包信息失败', e)
      }
    },
    async loadCarbonPoints() {
      try {
        const res = await getCarbonOverview()
        if (res && (res.code === 200 || res.code === 0)) {
          const data = res.data || res
          this.carbonPoints = data.points !== undefined && data.points !== null ? data.points : 0
          this.carbonReduction = data.totalReduction !== undefined && data.totalReduction !== null ? data.totalReduction : 0
        }
      } catch (e) {
        console.error('加载碳积分失败', e)
      }
    },
    async loadCollectionCount() {
      try {
        const res = await getCollectionCount()
        if (res && (res.code === 200 || res.code === 0)) {
          this.collectionCount = res.data || 0
        }
      } catch (e) {
        console.error('加载收藏数量失败', e)
      }
    },
    async loadCouponCount() {
      try {
        const res = await getCouponCount()
        if (res && (res.code === 200 || res.code === 0)) {
          this.couponCount = res.data || 0
        }
      } catch (e) {
        console.error('加载优惠券数量失败', e)
      }
    },
    async loadOrderStatusCount() {
      try {
        const res = await getOrderStatusCount()
        if (res && (res.code === 200 || res.code === 0)) {
          const data = res.data || {}
          this.orderStatusCount = {
            unpaid: data.unpaid || 0,
            pending: data.pending || 0,
            completed: data.completed || 0,
            cancelled: data.cancelled || 0
          }
        }
      } catch (e) {
        console.error('加载订单状态统计失败', e)
      }
    },
    // 跳转登录
    handleToLogin() {
      this.$tab.reLaunch('/pages/login')
    },
    // 跳转个人信息
    handleToInfo() {
      this.$tab.navigateTo('/pages/mine/info/index')
    },
    // 跳转编辑资料
    handleToEditInfo() {
      this.$tab.navigateTo('/pages/mine/info/edit')
    },
    // 跳转修改头像
    handleToAvatar() {
      this.$tab.navigateTo('/pages/mine/avatar/index')
    },
    // 跳转修改密码
    handleToPwd() {
      this.$tab.navigateTo('/pages/mine/pwd/index')
    },
    // 跳转设置
    handleToSetting() {
      this.$tab.navigateTo('/pages/mine/setting/index')
    },
    // 跳转端切换
    handleToSwitch() {
      this.$tab.navigateTo('/pages/mine/switch/index')
    },
    // 跳转碳积分
    handleToCarbon() {
      this.$tab.navigateTo('/pages/mine/carbon/index')
    },
    // 跳转帮助
    handleToHelp() {
      this.$tab.navigateTo('/pages/mine/help/index')
    },
    // 跳转关于
    handleToAbout() {
      this.$tab.navigateTo('/pages/mine/about/index')
    },
    // 跳转我的车辆
    handleToMyCar() {
      this.$tab.navigateTo('/pages/mine/myCar/index')
    },
    // 跳转充电记录
    handleToCharging() {
      this.$tab.navigateTo('/pages/mine/charging/index')
    },
    // 跳转预约记录
    handleToReservation() {
      this.$tab.navigateTo('/pages/mine/reservation/index')
    },
    // 跳转消息通知
    handleToMessages() {
      this.$tab.navigateTo('/pages/mine/messages/index')
    },
    // 跳转在线客服
    handleToService() {
      this.$tab.navigateTo('/pages/mine/customer/index')
    },
    // 跳转意见反馈
    handleToFeedback() {
      this.$tab.navigateTo('/pages/mine/feedback/index')
    },
    // 跳转订单页面
    handleToOrders() {
      this.$tab.navigateTo('/pages/mine/orders/index')
    },
    // 跳转收藏页面
    handleToFavorites() {
      this.$tab.navigateTo('/pages/mine/favorites/index')
    },
    // 跳转优惠券页面
    handleToCoupons() {
      this.$tab.navigateTo('/pages/mine/coupons/index')
    },
    // 跳转钱包页面
    handleToWallet() {
      this.$tab.navigateTo('/pages/mine/wallet/index')
    },
    // 按状态查看订单
    handleToOrderStatus(status) {
      this.$tab.navigateTo(`/pages/mine/orders/index?status=${status}`)
    },
    // 退出登录
    handleLogout() {
      this.$modal.confirm('确定退出登录吗？').then(() => {
        this.$store.dispatch('LogOut').then(() => {
          this.$tab.reLaunch('/pages/login')
        })
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
    margin-top: 12rpx;
    padding: 16rpx 0;
    border-radius: 12rpx;
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
    width: 48rpx;
    height: 48rpx;
    background-color: #e6f0ff;
    border-radius: 50%;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-bottom: 8rpx;
    position: relative;
  }

  .stat-value {
    font-size: 28rpx;
    font-weight: 600;
    color: #333;
    margin-bottom: 4rpx;
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
    padding: 12rpx 30rpx;
  }

  .action-grid {
    display: flex;
    flex-wrap: wrap;
    background-color: #fff;
    padding: 16rpx 0;
    border-radius: 12rpx;
    box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
  }

  .action-item {
    width: 33.33%;
    display: flex;
    flex-direction: column;
    align-items: center;
    position: relative;
    padding: 12rpx 0;
  }

  .action-icon-box {
    width: 72rpx;
    height: 72rpx;
    border-radius: 20rpx;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-bottom: 8rpx;
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

  .action-text {
    font-size: 24rpx;
    color: #666;
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
    position: relative;
  }

  .status-icon-box.bg-orange {
    background-color: #fff3e0;
  }

  .status-icon-box.bg-orange uni-icons {
    color: #ff9800;
  }

  .status-icon-box.bg-blue {
    background-color: #e3f2fd;
  }

  .status-icon-box.bg-blue uni-icons {
    color: #2196f3;
  }

  .status-icon-box.bg-green {
    background-color: #e8f5e9;
  }

  .status-icon-box.bg-green uni-icons {
    color: #4caf50;
  }

  .status-icon-box.bg-gray {
    background-color: #f5f5f5;
  }

  .status-icon-box.bg-gray uni-icons {
    color: #9e9e9e;
  }

  .status-text {
    font-size: 22rpx;
    color: #666;
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

  .carbon-c {
    font-size: 44rpx;
    font-weight: 800;
    color: #fff;
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

  .menu-text {
    flex: 1;
    font-size: 28rpx;
    color: #333;
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
