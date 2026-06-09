<template>
  <view class="page-container">
    <scroll-view scroll-y class="content-scroll" v-if="detail">
      <view class="status-bar" :class="detail.orderStatus === '1' ? 'completed' : 'ongoing'">
        <view class="status-bg"></view>
        <view class="status-content">
          <view class="status-icon">
            <uni-icons type="info" size="44" color="#fff"></uni-icons>
          </view>
          <view class="status-info">
            <text class="status-text">{{ detail.orderStatus === '1' ? '充电完成' : '充电中' }}</text>
            <text class="order-no">订单号：{{ detail.orderNo || '--' }}</text>
          </view>
        </view>
      </view>

      <view class="info-card">
        <view class="card-header">
          <view class="header-icon">
            <uni-icons type="info" size="28" color="#3c96f3"></uni-icons>
          </view>
          <text class="card-title">充电站信息</text>
          <view class="contact-link" @click="handleContact">
            <uni-icons type="phone" size="18" color="#3c96f3"></uni-icons>
            <text>联系商家</text>
          </view>
        </view>
        <view class="card-body">
          <view class="info-item">
            <text class="info-label">充电站</text>
            <text class="info-value">{{ detail.stationName || '--' }}</text>
          </view>
          <view class="info-item">
            <text class="info-label">充电桩</text>
            <text class="info-value">{{ detail.pileCode || '--' }}</text>
          </view>
        </view>
      </view>

      <view class="info-card">
        <view class="card-header">
          <view class="header-icon">
            <uni-icons type="location" size="28" color="#3c96f3"></uni-icons>
          </view>
          <text class="card-title">充电信息</text>
        </view>
        <view class="card-body">
          <view class="info-row">
            <view class="info-item">
              <text class="info-label">开始时间</text>
              <text class="info-value">{{ detail.startTime || '--' }}</text>
            </view>
            <view class="info-item">
              <text class="info-label">结束时间</text>
              <text class="info-value">{{ detail.endTime && detail.endTime !== '--' ? detail.endTime : '充电中...' }}</text>
            </view>
          </view>
          <view class="info-row">
            <view class="info-item">
              <text class="info-label">充电时长</text>
              <text class="info-value highlight">{{ detail.durationText || '--' }}</text>
            </view>
            <view class="info-item">
              <text class="info-label">充电电量</text>
              <text class="info-value highlight">{{ formatNumber(detail.totalEnergy) }} kWh</text>
            </view>
          </view>
          <view class="info-item" v-if="detail.startSoc || detail.endSoc">
            <text class="info-label">电量变化</text>
            <text class="info-value">{{ formatNumber(detail.startSoc) }}% → {{ formatNumber(detail.endSoc) }}%</text>
          </view>
          <view class="info-item">
            <text class="info-label">获得碳积分</text>
            <text class="info-value carbon">{{ detail.carbonEarned || 0 }} 积分</text>
          </view>
        </view>
      </view>

      <view class="info-card price-card">
        <view class="card-header">
          <view class="header-icon">
            <uni-icons type="info" size="28" color="#ff9800"></uni-icons>
          </view>
          <text class="card-title">费用明细</text>
        </view>
        <view class="card-body">
          <view class="price-row">
            <text class="price-label">电费</text>
            <text class="price-value">¥{{ formatNumber(detail.energyPrice) }}</text>
          </view>
          <view class="price-row">
            <text class="price-label">服务费</text>
            <text class="price-value">¥{{ formatNumber(detail.servicePrice) }}</text>
          </view>
          <view class="price-row">
            <text class="price-label">优惠金额</text>
            <text class="price-value discount">-¥{{ formatNumber(detail.discountAmount) }}</text>
          </view>
          <view class="price-row total">
            <text class="price-label">实付金额</text>
            <text class="price-value">¥{{ formatNumber(detail.totalAmount) }}</text>
          </view>
        </view>
      </view>

      <view class="info-card" v-if="detail.orderStatus === '1' || detail.payStatus">
        <view class="card-header">
          <view class="header-icon">
            <uni-icons type="info" size="28" color="#2ecc71"></uni-icons>
          </view>
          <text class="card-title">支付状态</text>
        </view>
        <view class="card-body">
          <view class="info-item">
            <text class="info-label">支付状态</text>
            <text class="info-value" :class="detail.payStatus === '1' ? 'paid' : 'unpaid'">
              {{ detail.payStatus === '1' ? '已支付' : '待支付' }}
            </text>
          </view>
          <view class="info-item" v-if="detail.paymentMethod">
            <text class="info-label">支付方式</text>
            <text class="info-value">{{ getPaymentMethod(detail.paymentMethod) }}</text>
          </view>
          <view class="info-item" v-if="detail.transactionId">
            <text class="info-label">交易流水号</text>
            <text class="info-value">{{ detail.transactionId || '--' }}</text>
          </view>
        </view>
      </view>

      <view class="btn-area">
        <view v-if="detail.orderStatus === '0'" class="btn btn-danger" @click="handleStop">
          停止充电
        </view>
        <view v-if="detail.orderStatus === '1' && detail.payStatus === '0'" class="btn btn-primary" @click="handlePay">
          立即支付
        </view>
        <view v-if="detail.orderStatus === '1'" class="btn btn-secondary" @click="handleInvoice">
          申请发票
        </view>
        <view class="btn btn-outline" @click="handleContact">
          <uni-icons type="phone" size="20" color="#3c96f3"></uni-icons>
          <text>联系商家</text>
        </view>
      </view>
      
      <view class="bottom-space"></view>
    </scroll-view>

    <view class="loading-container" v-else>
      <view class="loading">
        <uni-icons type="info" size="44" color="#3c96f3"></uni-icons>
        <text class="loading-text">加载中...</text>
      </view>
    </view>
  </view>
</template>

<script>
import { getChargingDetail } from '@/api/charging'

export default {
  data() {
    return {
      detail: null,
      orderId: null
    }
  },
  onLoad(options) {
    this.orderId = options.id
    this.loadDetail()
  },
  methods: {
    async loadDetail() {
      try {
        const res = await getChargingDetail(this.orderId)
        if (res && (res.code === 200 || res.code === 0)) {
          this.detail = res.data || res
        } else {
          uni.showToast({ title: '加载失败', icon: 'none' })
        }
      } catch (e) {
        console.error('加载详情失败', e)
        uni.showToast({ title: '加载失败', icon: 'none' })
      }
    },
    formatNumber(num) {
      if (num === null || num === undefined) return '0'
      return typeof num === 'number' ? num.toFixed(2) : String(num)
    },
    getPaymentMethod(method) {
      if (!method) return '--'
      const methods = {
        'alipay': '支付宝',
        'wechat': '微信支付',
        'wechatpay': '微信支付',
        'card': '银行卡',
        'wallet': '钱包',
        'bank': '银行卡'
      }
      return methods[method.toLowerCase()] || method
    },
    handleStop() {
      uni.showModal({
        title: '确认停止',
        content: '确定要停止充电吗？',
        success: (res) => {
          if (res.confirm) {
            uni.showToast({ title: '已停止充电', icon: 'success' })
            setTimeout(() => {
              this.loadDetail()
            }, 1500)
          }
        }
      })
    },
    handlePay() {
      uni.showToast({ title: '支付功能开发中', icon: 'none' })
    },
    handleInvoice() {
      uni.showToast({ title: '发票申请已提交', icon: 'success' })
    },
    handleContact() {
      uni.navigateTo({ 
        url: `/pages/mine/contact/index?orderId=${this.orderId || ''}&type=charging` 
      })
    }
  }
}
</script>

<style lang="scss" scoped>
page {
  background-color: #f2f7fe;
  min-height: 100vh;
}

.page-container {
  min-height: 100vh;
}

.content-scroll {
  height: 100vh;
  padding: 0 30rpx;
}

.loading-container {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100vh;
}

.loading {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.loading-text {
  font-size: 28rpx;
  color: #999;
  margin-top: 20rpx;
}

.status-bar {
  position: relative;
  margin-top: 20rpx;
  border-radius: 20rpx;
  overflow: hidden;
  box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.1);
  margin-bottom: 24rpx;
}

.status-bg {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
}

.status-bar.completed .status-bg {
  background: linear-gradient(135deg, #2ecc71 0%, #27ae60 50%, #1da654 100%);
}

.status-bar.ongoing .status-bg {
  background: linear-gradient(135deg, #3c96f3 0%, #5a87ff 50%, #7c6dff 100%);
}

.status-content {
  position: relative;
  z-index: 1;
  display: flex;
  align-items: center;
  padding: 36rpx 32rpx;
}

.status-icon {
  width: 80rpx;
  height: 80rpx;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.25);
  margin-right: 20rpx;
}

.status-info {
  display: flex;
  flex-direction: column;
}

.status-text {
  font-size: 32rpx;
  font-weight: 700;
  color: #fff;
}

.order-no {
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.8);
  margin-top: 8rpx;
}

.info-card {
  background: #fff;
  border-radius: 20rpx;
  margin-bottom: 20rpx;
  overflow: hidden;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.04);
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 28rpx 28rpx 20rpx;
  border-bottom: 1rpx solid #f0f0f0;
}

.header-left {
  display: flex;
  align-items: center;
}

.header-icon {
  width: 48rpx;
  height: 48rpx;
  background: rgba(60, 150, 243, 0.1);
  border-radius: 12rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 16rpx;
}

.card-title {
  font-size: 30rpx;
  font-weight: 700;
  color: #1a1a1a;
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
    color: #3c96f3;
  }
}

.card-body {
  padding: 20rpx 28rpx 28rpx;
}

.info-row {
  display: flex;
  gap: 20rpx;
}

.info-item {
  flex: 1;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16rpx 0;
  
  &:not(:last-child) {
    border-bottom: 1rpx solid #f8fafc;
  }
}

.info-label {
  font-size: 26rpx;
  color: #888;
}

.info-value {
  font-size: 26rpx;
  font-weight: 500;
  color: #333;
  
  &.highlight {
    color: #3c96f3;
    font-weight: 600;
  }
  
  &.carbon {
    color: #2ecc71;
  }
  
  &.paid {
    color: #2ecc71;
  }
  
  &.unpaid {
    color: #ff4757;
  }
}

.price-card {
  .card-header .header-icon {
    background: rgba(255, 152, 0, 0.1);
  }
}

.price-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 18rpx 0;
  
  &:not(:last-child) {
    border-bottom: 1rpx solid #f8fafc;
  }
  
  &.total {
    padding-top: 24rpx;
    margin-top: 8rpx;
    border-top: 1rpx dashed #e8e8e8;
    border-bottom: none;
    
    .price-label {
      font-size: 28rpx;
      color: #333;
      font-weight: 600;
    }
    
    .price-value {
      font-size: 36rpx;
      color: #ff4757;
      font-weight: 800;
    }
  }
}

.price-label {
  font-size: 26rpx;
  color: #888;
}

.price-value {
  font-size: 26rpx;
  font-weight: 500;
  color: #333;
  
  &.discount {
    color: #2ecc71;
  }
}

.btn-area {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
  margin-top: 20rpx;
  margin-bottom: 40rpx;
}

.btn {
  height: 88rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 44rpx;
  font-size: 30rpx;
  font-weight: 600;
  transition: all 0.3s ease;
}

.btn:active {
  transform: scale(0.98);
  opacity: 0.9;
}

.btn-primary {
  background: linear-gradient(135deg, #3c96f3 0%, #5a87ff 100%);
  color: #fff;
  box-shadow: 0 6rpx 20rpx rgba(60, 150, 243, 0.3);
}

.btn-danger {
  background: linear-gradient(135deg, #ff4757 0%, #ff6b81 100%);
  color: #fff;
  box-shadow: 0 6rpx 20rpx rgba(255, 71, 87, 0.3);
}

.btn-secondary {
  background: #f0f2f5;
  color: #666;
}

.btn-outline {
  background: transparent;
  color: #3c96f3;
  border: 2rpx solid #3c96f3;
  gap: 10rpx;
}

.bottom-space {
  height: 40rpx;
}
</style>
