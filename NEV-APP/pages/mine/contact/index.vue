<template>
  <view class="page-container">
    <view class="navbar">
      <view class="nav-back" @click="goBack">
        <uni-icons type="forward" size="28" color="#333"></uni-icons>
      </view>
    </view>
    <scroll-view scroll-y class="content-scroll">
      <view class="merchant-card" v-if="merchantInfo">
        <view class="merchant-header">
          <image class="merchant-avatar" :src="merchantInfo.avatar || '/static/images/imgs/zhanshi.jpg'" mode="aspectFill"></image>
          <view class="merchant-info">
            <text class="merchant-name">{{ merchantInfo.name || '官方客服' }}</text>
            <text class="merchant-tag">在线服务</text>
          </view>
          <view class="status-dot status-dot-online"></view>
        </view>
      </view>

      <view class="order-action-section" v-if="orderInfo">
        <view class="section-title">订单操作</view>
        <view class="order-action-card">
          <view class="action-info">
            <view class="action-icon">
              <uni-icons type="info" size="40" color="#fff"></uni-icons>
            </view>
            <view class="action-content">
              <text class="action-title">完成订单</text>
              <text class="action-desc">确认服务已完成，标记订单为已完成状态</text>
            </view>
          </view>
          <view class="action-btn complete-order-btn" @click="handleCompleteOrder">
            <text>完成订单</text>
          </view>
        </view>
      </view>

      <view class="contact-ways">
        <view class="section-title">联系方式</view>
        
        <view class="way-item way-item-phone" @click="handleCall">
          <view class="way-icon">
            <uni-icons type="info" size="28" color="#fff"></uni-icons>
          </view>
          <view class="way-info">
            <text class="way-name">电话咨询</text>
            <text class="way-desc">{{ merchantInfo.phone || '400-123-4567' }}</text>
          </view>
          <uni-icons type="forward" size="20" color="#bbb"></uni-icons>
        </view>

        <view class="way-item way-item-chat" @click="handleChat">
          <view class="way-icon">
            <uni-icons type="list" size="28" color="#fff"></uni-icons>
          </view>
          <view class="way-info">
            <text class="way-name">在线客服</text>
            <text class="way-desc">即时咨询，专业解答</text>
          </view>
          <uni-icons type="forward" size="20" color="#bbb"></uni-icons>
        </view>

        <view class="way-item way-item-wechat" @click="handleCopyWeChat" v-if="merchantInfo.wechat">
          <view class="way-icon">
            <uni-icons type="location" size="28" color="#fff"></uni-icons>
          </view>
          <view class="way-info">
            <text class="way-name">微信联系</text>
            <text class="way-desc">{{ merchantInfo.wechat }}</text>
          </view>
          <view class="copy-tag">点击复制</view>
        </view>
      </view>

      <view class="merchant-info-section" v-if="merchantInfo">
        <view class="section-title">商家信息</view>
        
        <view class="info-row" v-if="merchantInfo.address">
          <view class="info-icon">
            <uni-icons type="info" size="20" color="#2563eb"></uni-icons>
          </view>
          <view class="info-content">
            <text class="info-label">商家地址</text>
            <text class="info-value">{{ merchantInfo.address }}</text>
          </view>
          <view class="action-btn-small" @click="handleNavigate">
            <uni-icons type="forward" size="16" color="#2563eb"></uni-icons>
          </view>
        </view>

        <view class="info-row" v-if="merchantInfo.businessHours">
          <view class="info-icon">
            <uni-icons type="info" size="20" color="#2563eb"></uni-icons>
          </view>
          <view class="info-content">
            <text class="info-label">营业时间</text>
            <text class="info-value">{{ merchantInfo.businessHours }}</text>
          </view>
        </view>

        <view class="info-row" v-if="orderId">
          <view class="info-icon">
            <uni-icons type="list" size="20" color="#2563eb"></uni-icons>
          </view>
          <view class="info-content">
            <text class="info-label">关联订单</text>
            <text class="info-value order-no">{{ orderId }}</text>
          </view>
        </view>
      </view>

      <view class="quick-questions">
        <view class="section-title">常见问题</view>
        <view class="question-list">
          <view 
            v-for="(q, idx) in questions" 
            :key="idx" 
            class="question-item"
            @click="handleQuestion(q)"
          >
            <text class="question-text">{{ q.title }}</text>
            <uni-icons type="forward" size="18" color="#bbb"></uni-icons>
          </view>
        </view>
      </view>

      <view class="bottom-tips">
        <uni-icons type="info" size="16" color="#bbb"></uni-icons>
        <text>如需紧急帮助，请优先拨打客服热线</text>
      </view>
    </scroll-view>

    <view class="bottom-bar">
      <view class="bottom-btn-secondary" @click="handleCopyWeChat" v-if="merchantInfo.wechat">
        <uni-icons type="info" size="20" color="#2563eb"></uni-icons>
        <text>复制微信号</text>
      </view>
      <view class="bottom-btn-primary" @click="handleChat">
        <uni-icons type="list" size="20" color="#fff"></uni-icons>
        <text>在线咨询</text>
      </view>
    </view>
  </view>
</template>

<script>
import { completeOrder } from '@/api/mine/order'

export default {
  data() {
    return {
      merchantInfo: {
        name: 'NEV Life 官方客服',
        phone: '400-123-4567',
        wechat: 'NEV_Life_Service',
        address: '北京市朝阳区建国路88号NEV服务中心',
        businessHours: '09:00 - 18:00（工作日）',
        avatar: '/static/images/imgs/zhanshi.jpg'
      },
      orderId: '',
      shopName: '',
      questions: [
        { title: '充电费用如何计算？', type: 'charging' },
        { title: '如何申请退款？', type: 'refund' },
        { title: '预约服务如何取消？', type: 'reservation' },
        { title: '优惠券使用说明', type: 'coupon' },
        { title: '充电桩故障报修', type: 'fault' }
      ]
    }
  },
  onLoad(options) {
    if (options.merchantId) {
      this.merchantInfo.id = options.merchantId
    }
    if (options.orderId) {
      this.orderId = options.orderId
    }
    if (options.shopName) {
      this.shopName = decodeURIComponent(options.shopName)
      if (this.shopName) {
        this.merchantInfo.name = this.shopName
      }
    }
    if (options.type) {
      this.type = options.type
    }
  },
  methods: {
    goBack() {
      uni.navigateBack()
    },
    async handleCompleteOrder() {
      if (!this.orderId) {
        uni.showToast({
          title: '订单ID不存在',
          icon: 'none'
        })
        return
      }

      uni.showModal({
        title: '确认完成订单',
        content: '确认该订单已完成服务吗？完成后订单将标记为已完成状态。',
        confirmText: '确认完成',
        success: async (res) => {
          if (res.confirm) {
            uni.showLoading({ title: '处理中...' })
            try {
              await completeOrder(this.orderId)
              uni.hideLoading()
              uni.showToast({
                title: '订单已完成',
                icon: 'success',
                duration: 2000
              })
              setTimeout(() => {
                uni.navigateBack({ delta: 1 })
              }, 2000)
            } catch (error) {
              uni.hideLoading()
              console.error('完成订单失败:', error)
              uni.showToast({
                title: '操作失败，请重试',
                icon: 'none'
              })
            }
          }
        }
      })
    },
    handleCall() {
      const phone = this.merchantInfo.phone || '400-123-4567'
      uni.makePhoneCall({
        phoneNumber: phone,
        fail: () => {
          uni.showToast({ title: '拨打电话失败', icon: 'none' })
        }
      })
    },
    handleChat() {
      uni.navigateTo({ url: '/pages/mine/customer/index' })
    },
    handleCopyWeChat() {
      const wechat = this.merchantInfo.wechat
      if (!wechat) {
        uni.showToast({ title: '暂未提供微信号', icon: 'none' })
        return
      }
      uni.setClipboardData({
        data: wechat,
        success: () => {
          uni.showToast({ title: '微信号已复制', icon: 'success' })
        }
      })
    },
    handleNavigate() {
      uni.showToast({ title: '导航功能开发中', icon: 'none' })
    },
    handleQuestion(q) {
      let text = ''
      switch (q.type) {
        case 'charging':
          text = '充电费用 = 电费 × 充电电量 + 服务费 × 充电时长，具体费率可查看站点详情页。'
          break
        case 'refund':
          text = '您可以在订单详情页申请退款，审核通过后资金将原路返回，通常1-3个工作日到账。'
          break
        case 'reservation':
          text = '在"我的-预约记录"中找到对应订单，点击取消即可。提前24小时取消可全额退款。'
          break
        case 'coupon':
          text = '优惠券在支付时自动抵扣，每个订单限用一张。注意查看使用期限和适用范围哦！'
          break
        case 'fault':
          text = '请拨打客服热线400-123-4567，我们会尽快安排工程师处理，给您带来不便敬请谅解。'
          break
      }
      uni.showModal({
        title: q.title,
        content: text,
        showCancel: false,
        confirmText: '明白了'
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
  padding: 20rpx 30rpx;
  background-color: #fff;
}

.nav-back {
  width: 60rpx;
  height: 60rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  transform: rotate(180deg);
}

.content-scroll {
  height: calc(100vh - 100rpx);
  padding: 20rpx 24rpx;
}

.merchant-card {
  background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
  border-radius: 24rpx;
  padding: 30rpx;
  margin-bottom: 20rpx;
}

.merchant-header {
  display: flex;
  align-items: center;
}

.merchant-avatar {
  width: 96rpx;
  height: 96rpx;
  border-radius: 50%;
  border: 4rpx solid rgba(255,255,255,0.3);
}

.merchant-info {
  flex: 1;
  margin-left: 20rpx;
  display: flex;
  flex-direction: column;
}

.merchant-name {
  font-size: 32rpx;
  font-weight: 600;
  color: #fff;
}

.merchant-tag {
  font-size: 22rpx;
  color: rgba(255,255,255,0.8);
  background-color: rgba(255,255,255,0.2);
  padding: 4rpx 16rpx;
  border-radius: 20rpx;
  align-self: flex-start;
  margin-top: 8rpx;
}

.status-dot {
  width: 16rpx;
  height: 16rpx;
  border-radius: 50%;
}

.status-dot-online {
  background-color: #10b981;
  box-shadow: 0 0 0 6rpx rgba(16, 185, 129, 0.3);
}

.order-action-section {
  background-color: #fff;
  border-radius: 20rpx;
  padding: 24rpx;
  margin-bottom: 20rpx;
}

.order-action-card {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: linear-gradient(135deg, #10b98115 0%, #05966915 100%);
  border: 1rpx solid #10b98130;
  border-radius: 16rpx;
  padding: 24rpx;
}

.action-info {
  display: flex;
  align-items: center;
  flex: 1;
}

.action-icon {
  width: 80rpx;
  height: 80rpx;
  border-radius: 20rpx;
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 20rpx;
}

.action-content {
  display: flex;
  flex-direction: column;
}

.action-title {
  font-size: 30rpx;
  font-weight: 600;
  color: #10b981;
}

.action-desc {
  font-size: 24rpx;
  color: #666;
  margin-top: 6rpx;
}

.complete-order-btn {
  padding: 16rpx 32rpx;
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
  color: #fff;
  border-radius: 32rpx;
  font-size: 26rpx;
  font-weight: 500;
  box-shadow: 0 4rpx 12rpx rgba(16, 185, 129, 0.25);
}

.contact-ways {
  background-color: #fff;
  border-radius: 20rpx;
  padding: 24rpx;
  margin-bottom: 20rpx;
}

.section-title {
  font-size: 28rpx;
  font-weight: 600;
  color: #333;
  margin-bottom: 20rpx;
}

.way-item {
  display: flex;
  align-items: center;
  padding: 24rpx 0;
  border-bottom: 1rpx solid #f5f5f5;
}

.way-item:last-child {
  border-bottom: none;
}

.way-icon {
  width: 72rpx;
  height: 72rpx;
  border-radius: 18rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 20rpx;
}

.way-item-phone .way-icon {
  background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
}

.way-item-chat .way-icon {
  background: linear-gradient(135deg, #10b981 0%, #34d399 100%);
}

.way-item-wechat .way-icon {
  background: linear-gradient(135deg, #07c160 0%, #06ad56 100%);
}

.way-info {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.way-name {
  font-size: 28rpx;
  font-weight: 500;
  color: #333;
}

.way-desc {
  font-size: 24rpx;
  color: #999;
  margin-top: 6rpx;
}

.copy-tag {
  font-size: 22rpx;
  color: #2563eb;
  background-color: #e8f2ff;
  padding: 6rpx 16rpx;
  border-radius: 20rpx;
}

.merchant-info-section {
  background-color: #fff;
  border-radius: 20rpx;
  padding: 24rpx;
  margin-bottom: 20rpx;
}

.info-row {
  display: flex;
  align-items: center;
  padding: 20rpx 0;
  border-bottom: 1rpx solid #f5f5f5;
}

.info-row:last-child {
  border-bottom: none;
}

.info-icon {
  width: 48rpx;
  height: 48rpx;
  background-color: #eff6ff;
  border-radius: 12rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 16rpx;
  flex-shrink: 0;
}

.info-content {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.info-label {
  font-size: 24rpx;
  color: #999;
}

.info-value {
  font-size: 26rpx;
  color: #333;
  line-height: 1.5;
  margin-top: 6rpx;
}

.order-no {
  color: #2563eb;
  font-family: monospace;
}

.action-btn-small {
  width: 56rpx;
  height: 56rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #eff6ff;
  border-radius: 12rpx;
  flex-shrink: 0;
}

.quick-questions {
  background-color: #fff;
  border-radius: 20rpx;
  padding: 24rpx;
  margin-bottom: 20rpx;
}

.question-list {
  display: flex;
  flex-direction: column;
}

.question-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20rpx 16rpx;
  background-color: #fafafa;
  border-radius: 12rpx;
  margin-bottom: 12rpx;
}

.question-item:last-child {
  margin-bottom: 0;
}

.question-text {
  font-size: 26rpx;
  color: #333;
}

.bottom-tips {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 30rpx 0;
}

.bottom-tips text {
  font-size: 24rpx;
  color: #bbb;
  margin-left: 8rpx;
}

.bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  align-items: center;
  gap: 16rpx;
  padding: 20rpx 30rpx;
  background-color: #fff;
  box-shadow: 0 -4rpx 16rpx rgba(0,0,0,0.06);
  padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
}

.bottom-btn-secondary,
.bottom-btn-primary {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10rpx;
  padding: 24rpx 32rpx;
  border-radius: 40rpx;
  font-size: 28rpx;
  font-weight: 500;
}

.bottom-btn-secondary {
  background-color: #eff6ff;
  color: #2563eb;
}

.bottom-btn-primary {
  background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
  color: #fff;
  box-shadow: 0 4rpx 12rpx rgba(37, 99, 235, 0.3);
}
</style>