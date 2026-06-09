<template>
  <view class="page-container">
    <!-- 顶部导航 -->
    <view class="navbar">
      <view class="nav-back" @click="goBack">
        <uni-icons type="back" size="28" color="#333"></uni-icons>
      </view>
      <view class="nav-title">订单详情</view>
      <view class="nav-placeholder"></view>
    </view>

    <scroll-view scroll-y class="content-scroll" v-if="order">
      <!-- 订单状态卡片 -->
      <view class="status-card" :class="'status-' + order.status">
        <view class="status-bg"></view>
        <view class="status-content">
          <view class="status-icon-wrap">
            <view class="status-icon">
              <uni-icons :type="statusIcon" size="36" color="#fff"></uni-icons>
            </view>
          </view>
          <view class="status-info">
            <text class="status-text">{{ order.statusText }}</text>
            <text class="status-tip">{{ statusTip }}</text>
          </view>
        </view>
        <view class="order-no-wrap">
          <text class="order-no-label">订单编号</text>
          <text class="order-no-value">{{ order.id }}</text>
          <view class="copy-btn" @click="copyOrderNo">
            <uni-icons type="paperclip" size="14" color="rgba(255,255,255,0.8)"></uni-icons>
          </view>
        </view>
      </view>

      <!-- 进度条 -->
      <view class="progress-section" v-if="order.status !== 'cancelled'">
        <view class="progress-bar">
          <view 
            v-for="(step, index) in progressSteps" 
            :key="index"
            class="progress-step"
            :class="{ active: index <= currentStep, current: index === currentStep }"
          >
            <view class="step-dot">
              <uni-icons v-if="index < currentStep" type="checkmark" size="12" color="#fff"></uni-icons>
            </view>
            <text class="step-text">{{ step }}</text>
            <view class="step-line" v-if="index < progressSteps.length - 1"></view>
          </view>
        </view>
      </view>

      <!-- 商家信息 -->
      <view class="section">
        <view class="section-header">
          <view class="header-left">
            <view class="section-icon">
              <uni-icons type="shop" size="20" color="#2563eb"></uni-icons>
            </view>
            <text class="section-title">商家信息</text>
          </view>
          <view class="contact-link" @click="handleContact">
            <uni-icons type="phone" size="18" color="#2563eb"></uni-icons>
            <text>联系商家</text>
          </view>
        </view>
        <view class="shop-card">
          <view class="shop-avatar">
            <uni-icons type="shop" size="28" color="#fff"></uni-icons>
          </view>
          <view class="shop-info">
            <text class="shop-name">{{ order.shopName }}</text>
            <text class="shop-desc" v-if="order.shopDesc">{{ order.shopDesc }}</text>
          </view>
          <view class="contact-btn" @click="handleContact">
            <uni-icons type="phone" size="18" color="#2563eb"></uni-icons>
            <text>联系</text>
          </view>
        </view>
      </view>

      <!-- 商品信息 -->
      <view class="section">
        <view class="section-header">
          <view class="section-icon">
            <uni-icons type="gift" size="20" color="#2563eb"></uni-icons>
          </view>
          <text class="section-title">商品信息</text>
        </view>
        <view class="goods-card">
          <view class="goods-image-wrap">
            <image class="goods-image" :src="order.image" mode="aspectFill"></image>
            <view class="goods-count-badge" v-if="order.count > 1">×{{ order.count }}</view>
          </view>
          <view class="goods-info">
            <text class="goods-title">{{ order.title }}</text>
            <text class="goods-desc" v-if="order.desc">{{ order.desc }}</text>
            <view class="goods-bottom">
              <view class="goods-price">
                <text class="price-symbol">¥</text>
                <text class="price-num">{{ order.price }}</text>
              </view>
              <text class="goods-count">共{{ order.count }}件</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 订单信息 -->
      <view class="section">
        <view class="section-header">
          <view class="section-icon">
            <uni-icons type="list" size="20" color="#2563eb"></uni-icons>
          </view>
          <text class="section-title">订单信息</text>
        </view>
        <view class="info-list">
          <view class="info-item">
            <view class="info-icon">
              <uni-icons type="calendar" size="16" color="#999"></uni-icons>
            </view>
            <text class="info-label">下单时间</text>
            <text class="info-value">{{ order.createTime }}</text>
          </view>
          <view class="info-item">
            <view class="info-icon">
              <uni-icons type="wallet" size="16" color="#999"></uni-icons>
            </view>
            <text class="info-label">支付方式</text>
            <text class="info-value">{{ order.payMethod || '在线支付' }}</text>
          </view>
          <view class="info-item" v-if="order.payTime">
            <view class="info-icon">
              <uni-icons type="clock" size="16" color="#999"></uni-icons>
            </view>
            <text class="info-label">支付时间</text>
            <text class="info-value">{{ order.payTime }}</text>
          </view>
          <view class="info-item" v-if="order.tradeNo">
            <view class="info-icon">
              <uni-icons type="paperclip" size="16" color="#999"></uni-icons>
            </view>
            <text class="info-label">交易单号</text>
            <text class="info-value">{{ order.tradeNo }}</text>
          </view>
        </view>
      </view>

      <!-- 金额明细 -->
      <view class="section">
        <view class="section-header">
          <view class="section-icon">
            <uni-icons type="medal" size="20" color="#2563eb"></uni-icons>
          </view>
          <text class="section-title">金额明细</text>
        </view>
        <view class="amount-list">
          <view class="amount-item">
            <text class="amount-label">商品金额</text>
            <text class="amount-value">¥{{ order.total }}</text>
          </view>
          <view class="amount-item">
            <text class="amount-label">运费</text>
            <text class="amount-value">¥{{ order.shippingFee || '0.00' }}</text>
          </view>
          <view class="amount-item" v-if="order.discount > 0">
            <text class="amount-label">优惠</text>
            <text class="amount-value discount">-¥{{ order.discount }}</text>
          </view>
          <view class="amount-divider"></view>
          <view class="amount-item total">
            <text class="amount-label">实付金额</text>
            <view class="total-value">
              <text class="total-symbol">¥</text>
              <text class="total-num">{{ order.paidAmount || order.total }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 底部占位 -->
      <view class="bottom-space"></view>
    </scroll-view>

    <!-- 底部操作栏 -->
    <view class="bottom-bar" v-if="order">
      <view class="bar-left">
        <text class="total-label">实付款</text>
        <view class="total-amount">
          <text class="amount-symbol">¥</text>
          <text class="amount-num">{{ order.paidAmount || order.total }}</text>
        </view>
      </view>
      <view class="bar-actions">
        <view v-if="order.status === 'unpaid'" class="action-btn" @click="handleCancel">取消订单</view>
        <view v-if="order.status === 'unpaid'" class="action-btn primary" @click="handlePay">
          <uni-icons type="wallet" size="16" color="#fff"></uni-icons>
          <text>立即支付</text>
        </view>
        <view v-if="order.status === 'pending'" class="action-btn primary" @click="handleContact">
          <uni-icons type="phone" size="16" color="#fff"></uni-icons>
          <text>联系商家</text>
        </view>
        <view v-if="order.status === 'completed'" class="action-btn" @click="handleComment">
          <uni-icons type="star" size="16" color="#666"></uni-icons>
          <text>评价</text>
        </view>
        <view v-if="order.status === 'completed'" class="action-btn primary" @click="handleRebuy">再次购买</view>
        <view v-if="order.status === 'cancelled' || order.status === 'completed'" class="action-btn danger" @click="handleDelete">
          <uni-icons type="trash" size="16" color="#ff4757"></uni-icons>
          <text>删除</text>
        </view>
      </view>
    </view>

    <!-- 空状态 -->
    <view class="empty-state" v-else>
      <view class="empty-icon-wrap">
        <view class="empty-icon-bg"></view>
        <uni-icons type="info" size="64" color="#ccc"></uni-icons>
      </view>
      <text class="empty-title">订单不存在</text>
      <view class="empty-btn" @click="goBack">返回列表</view>
    </view>
  </view>
</template>

<script>
import { getOrderDetail, cancelOrder, deleteOrder } from '@/api/order'

export default {
  data() {
    return {
      orderId: '',
      order: null,
      loading: false
    }
  },
  computed: {
    statusIcon() {
      const iconMap = {
        unpaid: 'info',
        pending: 'clock',
        completed: 'checkmark',
        cancelled: 'close'
      }
      return iconMap[this.order?.status] || 'info'
    },
    statusTip() {
      const tipMap = {
        unpaid: '请尽快完成支付',
        pending: '商家正在为您准备',
        completed: '订单已完成',
        cancelled: '订单已取消'
      }
      return tipMap[this.order?.status] || ''
    },
    progressSteps() {
      return ['下单', '支付', '服务', '完成']
    },
    currentStep() {
      const stepMap = {
        unpaid: 0,
        pending: 2,
        completed: 3,
        cancelled: -1
      }
      return stepMap[this.order?.status] ?? 0
    }
  },
  onLoad(options) {
    this.orderId = options.id || options.orderId
    if (this.orderId) {
      this.loadOrderDetail()
    }
  },
  methods: {
    goBack() {
      uni.navigateBack()
    },
    copyOrderNo() {
      uni.setClipboardData({
        data: String(this.order.id),
        success: () => {
          uni.showToast({ title: '已复制', icon: 'success' })
        }
      })
    },
    async loadOrderDetail() {
      this.loading = true
      try {
        const res = await getOrderDetail(this.orderId)
        const data = res.data || res
        if (data) {
          this.order = this.formatOrder(data)
        }
      } catch (e) {
        console.error('加载订单详情失败', e)
        uni.showToast({ title: '加载失败', icon: 'none' })
      } finally {
        this.loading = false
      }
    },
    formatOrder(order) {
      const statusMap = {
        0: 'unpaid',
        1: 'pending',
        2: 'completed',
        3: 'cancelled'
      }
      const statusTextMap = {
        unpaid: '待支付',
        pending: '待服务',
        completed: '已完成',
        cancelled: '已取消'
      }
      return {
        id: order.id || order.orderId,
        shopName: order.shopName || order.merchantName || '官方店铺',
        shopDesc: order.shopDesc || order.merchantDesc || '',
        status: statusMap[order.status] || order.status || 'pending',
        statusText: statusTextMap[statusMap[order.status]] || order.statusText || '处理中',
        image: order.image || order.goodsImage || '/static/images/service/service_header1.png',
        title: order.title || order.goodsName || '商品',
        desc: order.desc || order.goodsDesc || '',
        price: order.price || order.unitPrice || 0,
        count: order.count || order.quantity || 1,
        total: order.total || order.totalAmount || 0,
        shippingFee: order.shippingFee || 0,
        discount: order.discount || 0,
        paidAmount: order.paidAmount || order.total || 0,
        createTime: order.createTime || order.createTimeStr || '',
        payMethod: order.payMethod || order.paymentMethod,
        payTime: order.payTime || '',
        tradeNo: order.tradeNo || ''
      }
    },
    handleContact() {
      uni.navigateTo({ 
        url: `/pages/mine/contact/index?orderId=${this.orderId || ''}&type=order` 
      })
    },
    handlePay() {
      uni.showModal({
        title: '确认支付',
        content: '确认支付 ¥' + (this.order.paidAmount || this.order.total) + '？',
        success: (res) => {
          if (res.confirm) {
            uni.showToast({ title: '支付功能开发中', icon: 'none' })
          }
        }
      })
    },
    async handleCancel() {
      uni.showModal({
        title: '取消订单',
        content: '确定要取消该订单吗？',
        success: async (res) => {
          if (res.confirm) {
            try {
              await cancelOrder(this.orderId)
              this.order.status = 'cancelled'
              this.order.statusText = '已取消'
              uni.showToast({ title: '订单已取消', icon: 'success' })
            } catch (e) {
              uni.showToast({ title: '取消失败', icon: 'none' })
            }
          }
        }
      })
    },
    handleComment() {
      uni.showToast({ title: '评价功能开发中', icon: 'none' })
    },
    handleRebuy() {
      uni.showToast({ title: '已加入购物车', icon: 'success' })
    },
    async handleDelete() {
      uni.showModal({
        title: '删除订单',
        content: '确定要删除该订单吗？删除后将无法恢复。',
        success: async (res) => {
          if (res.confirm) {
            try {
              await deleteOrder(this.orderId)
              uni.showToast({ title: '删除成功', icon: 'success' })
              setTimeout(() => {
                uni.navigateBack()
              }, 1500)
            } catch (e) {
              uni.showToast({ title: '删除失败', icon: 'none' })
            }
          }
        }
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

.navbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20rpx 30rpx;
  background-color: #fff;
  border-bottom: 1rpx solid #f0f0f0;
}

.nav-back {
  width: 60rpx;
  height: 60rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.nav-title {
  font-size: 32rpx;
  font-weight: 600;
  color: #333;
}

.nav-placeholder {
  width: 60rpx;
}

.content-scroll {
  height: calc(100vh - 140rpx);
}

// 状态卡片
.status-card {
  position: relative;
  margin: 20rpx;
  border-radius: 20rpx;
  padding: 30rpx;
  overflow: hidden;
}

.status-bg {
  position: absolute;
  top: -50%;
  right: -30%;
  width: 300rpx;
  height: 300rpx;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
}

.status-unpaid {
  background: linear-gradient(135deg, #ff6b35 0%, #f7931e 100%);
}

.status-pending {
  background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
}

.status-completed {
  background: linear-gradient(135deg, #10b981 0%, #34d399 100%);
}

.status-cancelled {
  background: linear-gradient(135deg, #6b7280 0%, #9ca3af 100%);
}

.status-content {
  position: relative;
  display: flex;
  align-items: center;
  gap: 20rpx;
}

.status-icon-wrap {
  flex-shrink: 0;
}

.status-icon {
  width: 72rpx;
  height: 72rpx;
  background-color: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.status-info {
  flex: 1;
}

.status-text {
  font-size: 34rpx;
  font-weight: 600;
  color: #fff;
  display: block;
}

.status-tip {
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.8);
  margin-top: 6rpx;
}

.order-no-wrap {
  position: relative;
  display: flex;
  align-items: center;
  gap: 12rpx;
  margin-top: 20rpx;
  padding: 16rpx 20rpx;
  background-color: rgba(255, 255, 255, 0.15);
  border-radius: 12rpx;
}

.order-no-label {
  font-size: 22rpx;
  color: rgba(255, 255, 255, 0.7);
}

.order-no-value {
  flex: 1;
  font-size: 24rpx;
  color: #fff;
  font-weight: 500;
}

.copy-btn {
  width: 40rpx;
  height: 40rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

// 进度条
.progress-section {
  margin: 0 20rpx 20rpx;
  padding: 24rpx;
  background-color: #fff;
  border-radius: 16rpx;
}

.progress-bar {
  display: flex;
  justify-content: space-between;
}

.progress-step {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  position: relative;
}

.step-dot {
  width: 36rpx;
  height: 36rpx;
  border-radius: 50%;
  background-color: #e5e5e5;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1;
}

.progress-step.active .step-dot {
  background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
}

.progress-step.current .step-dot {
  box-shadow: 0 0 0 6rpx rgba(37, 99, 235, 0.2);
}

.step-text {
  font-size: 22rpx;
  color: #999;
  margin-top: 10rpx;
}

.progress-step.active .step-text {
  color: #2563eb;
  font-weight: 500;
}

.step-line {
  position: absolute;
  top: 18rpx;
  left: 50%;
  width: 100%;
  height: 4rpx;
  background-color: #e5e5e5;
}

.progress-step.active .step-line {
  background: linear-gradient(90deg, #2563eb 0%, #e5e5e5 100%);
}

// 通用section
.section {
  margin: 20rpx;
  background-color: #fff;
  border-radius: 16rpx;
  padding: 24rpx;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.03);
}

.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12rpx;
  margin-bottom: 20rpx;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 12rpx;
}

.contact-link {
  display: flex;
  align-items: center;
  gap: 6rpx;
  padding: 10rpx 16rpx;
  background-color: #eff6ff;
  border-radius: 20rpx;
  text {
    font-size: 24rpx;
    color: #2563eb;
  }
}

.section-icon {
  width: 40rpx;
  height: 40rpx;
  background-color: #eff6ff;
  border-radius: 10rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.section-title {
  font-size: 28rpx;
  font-weight: 600;
  color: #333;
}

// 商家卡片
.shop-card {
  display: flex;
  align-items: center;
  gap: 16rpx;
  padding: 20rpx;
  background: linear-gradient(135deg, #fafafa 0%, #fff 100%);
  border-radius: 12rpx;
}

.shop-avatar {
  width: 64rpx;
  height: 64rpx;
  background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.shop-info {
  flex: 1;
  min-width: 0;
}

.shop-name {
  font-size: 28rpx;
  font-weight: 500;
  color: #333;
}

.shop-desc {
  font-size: 24rpx;
  color: #999;
  margin-top: 4rpx;
}

.contact-btn {
  display: flex;
  align-items: center;
  gap: 6rpx;
  padding: 14rpx 24rpx;
  color: #2563eb;
  font-size: 24rpx;
  background-color: #eff6ff;
  border-radius: 32rpx;
}

// 商品卡片
.goods-card {
  display: flex;
  gap: 20rpx;
  padding: 16rpx;
  background-color: #fafafa;
  border-radius: 12rpx;
}

.goods-image-wrap {
  position: relative;
  flex-shrink: 0;
}

.goods-image {
  width: 140rpx;
  height: 140rpx;
  border-radius: 12rpx;
}

.goods-count-badge {
  position: absolute;
  right: -8rpx;
  bottom: -8rpx;
  background-color: #ff4757;
  color: #fff;
  font-size: 20rpx;
  padding: 4rpx 12rpx;
  border-radius: 16rpx;
}

.goods-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  min-width: 0;
}

.goods-title {
  font-size: 28rpx;
  font-weight: 500;
  color: #333;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.goods-desc {
  font-size: 24rpx;
  color: #999;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  margin-top: 8rpx;
}

.goods-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 12rpx;
}

.goods-price {
  display: flex;
  align-items: baseline;
}

.price-symbol {
  font-size: 24rpx;
  color: #ff4757;
  font-weight: 500;
}

.price-num {
  font-size: 32rpx;
  font-weight: 600;
  color: #ff4757;
}

.goods-count {
  font-size: 24rpx;
  color: #999;
}

// 信息列表
.info-list {
  padding: 0 8rpx;
}

.info-item {
  display: flex;
  align-items: center;
  padding: 16rpx 0;
  border-bottom: 1rpx solid #f5f5f5;
}

.info-item:last-child {
  border-bottom: none;
}

.info-icon {
  width: 36rpx;
  height: 36rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 12rpx;
}

.info-label {
  font-size: 26rpx;
  color: #999;
  width: 160rpx;
}

.info-value {
  flex: 1;
  font-size: 26rpx;
  color: #333;
  text-align: right;
}

// 金额列表
.amount-list {
  padding: 0 8rpx;
}

.amount-item {
  display: flex;
  justify-content: space-between;
  padding: 14rpx 0;
}

.amount-divider {
  height: 1rpx;
  background: linear-gradient(90deg, transparent 0%, #e5e5e5 50%, transparent 100%);
  margin: 12rpx 0;
}

.amount-item.total {
  padding-top: 16rpx;
}

.amount-label {
  font-size: 26rpx;
  color: #999;
}

.amount-value {
  font-size: 26rpx;
  color: #333;
}

.amount-value.discount {
  color: #10b981;
}

.total-value {
  display: flex;
  align-items: baseline;
}

.total-symbol {
  font-size: 26rpx;
  color: #ff4757;
  font-weight: 500;
}

.total-num {
  font-size: 36rpx;
  font-weight: 700;
  color: #ff4757;
}

.bottom-space {
  height: 160rpx;
}

// 底部操作栏
.bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20rpx 30rpx;
  background-color: #fff;
  box-shadow: 0 -4rpx 16rpx rgba(0, 0, 0, 0.06);
  padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
}

.bar-left {
  display: flex;
  flex-direction: column;
  gap: 4rpx;
}

.total-label {
  font-size: 22rpx;
  color: #999;
}

.total-amount {
  display: flex;
  align-items: baseline;
}

.amount-symbol {
  font-size: 26rpx;
  color: #ff4757;
  font-weight: 500;
}

.amount-num {
  font-size: 36rpx;
  font-weight: 700;
  color: #ff4757;
}

.bar-actions {
  display: flex;
  gap: 16rpx;
}

.action-btn {
  display: flex;
  align-items: center;
  gap: 6rpx;
  padding: 16rpx 28rpx;
  font-size: 26rpx;
  color: #666;
  background-color: #fff;
  border: 1rpx solid #e5e5e5;
  border-radius: 40rpx;
}

.action-btn.primary {
  color: #fff;
  background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
  border: none;
  box-shadow: 0 4rpx 12rpx rgba(37, 99, 235, 0.3);
}

.action-btn.danger {
  color: #ff4757;
  border-color: #ff4757;
}

// 空状态
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 160rpx 40rpx;
}

.empty-icon-wrap {
  position: relative;
  width: 160rpx;
  height: 160rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.empty-icon-bg {
  position: absolute;
  width: 120rpx;
  height: 120rpx;
  background-color: #f5f5f5;
  border-radius: 50%;
}

.empty-title {
  font-size: 30rpx;
  color: #666;
  font-weight: 500;
  margin-top: 32rpx;
}

.empty-btn {
  margin-top: 40rpx;
  padding: 20rpx 60rpx;
  background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
  color: #fff;
  border-radius: 40rpx;
  font-size: 28rpx;
  box-shadow: 0 4rpx 16rpx rgba(37, 99, 235, 0.3);
}
</style>