<template>
  <view class="page-container">
    <scroll-view scroll-y class="content-scroll" v-if="order">
      <!-- ======== 订单状态卡片 ======== -->
      <view class="status-card" :class="'status-' + order.status">
        <view class="status-bg"></view>
        <view class="status-content">
          <view class="status-icon-wrap">
            <view class="status-icon">
              <uni-icons :type="statusIcon" size="36" color="#fff"></uni-icons>
            </view>
          </view>
          <view class="status-info">
            <view class="status-dot" :class="'dot-' + order.status"></view>
            <text class="status-text">{{ order.statusText }}</text>
            <text class="status-tip">{{ statusTip }}</text>
          </view>
        </view>
        <view class="order-no-wrap">
          <text class="order-no-label">订单编号</text>
          <text class="order-no-value">{{ order.orderNo || order.id }}</text>
          <view class="copy-btn" @click="copyOrderNo">
            <uni-icons type="paperclip" size="14" color="rgba(255,255,255,0.8)"></uni-icons>
          </view>
        </view>
      </view>

      <!-- ======== 进度条（已取消不显示） ======== -->
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

      <!-- ======== 商家/门店信息 ======== -->
      <view class="section">
        <view class="section-header">
          <view class="header-left">
            <view class="section-icon" :class="'icon-' + order.bizType">
              <uni-icons :type="order.bizType === 'charging' ? 'circle' : 'shop'" size="20" color="#fff"></uni-icons>
            </view>
            <text class="section-title">{{ order.bizType === 'charging' ? '充电站信息' : '商家信息' }}</text>
          </view>
          <view class="contact-link" @click="handleContact">
            <uni-icons type="phone" size="18" :color="contactColor"></uni-icons>
            <text :style="{ color: contactColor }">联系商家</text>
          </view>
        </view>
        <view class="shop-card">
          <view class="shop-avatar" :class="'avatar-' + order.bizType">
            <uni-icons :type="order.bizType === 'charging' ? 'circle' : 'shop'" size="28" color="#fff"></uni-icons>
          </view>
          <view class="shop-info">
            <text class="shop-name">{{ order.shopName }}</text>
            <text class="shop-desc" v-if="order.shopAddress">{{ order.shopAddress }}</text>
          </view>
        </view>
      </view>

      <!-- ======== 类型专属信息区 ======== -->

      <!-- 充电订单专属 -->
      <view class="section" v-if="order.bizType === 'charging'">
        <view class="section-header">
          <view class="header-left">
            <view class="section-icon icon-charging">
              <uni-icons type="circle" size="20" color="#fff"></uni-icons>
            </view>
            <text class="section-title">充电详情</text>
          </view>
        </view>
        <view class="type-detail-grid">
          <view class="detail-item">
            <text class="detail-label">充电量</text>
            <text class="detail-value charging-color">{{ order.totalEnergy || 0 }} <text class="detail-unit">kWh</text></text>
          </view>
          <view class="detail-item">
            <text class="detail-label">充电时长</text>
            <text class="detail-value">{{ order.durationText || '--' }}</text>
          </view>
          <view class="detail-item">
            <text class="detail-label">开始时间</text>
            <text class="detail-value">{{ order.startTime || '--' }}</text>
          </view>
          <view class="detail-item">
            <text class="detail-label">结束时间</text>
            <text class="detail-value">{{ order.endTime || '--' }}</text>
          </view>
          <view class="detail-item highlight" v-if="order.carbonEarned > 0">
            <text class="detail-label">获得碳积分</text>
            <text class="detail-value carbon-badge">+{{ order.carbonEarned }}</text>
          </view>
        </view>
      </view>

      <!-- 维保订单专属 -->
      <view class="section" v-if="order.bizType === 'maintenance'">
        <view class="section-header">
          <view class="header-left">
            <view class="section-icon icon-maintenance">
              <uni-icons type="tools" size="20" color="#fff"></uni-icons>
            </view>
            <text class="section-title">维保详情</text>
          </view>
        </view>
        <view class="type-detail-grid">
          <view class="detail-item full">
            <text class="detail-label">服务项目</text>
            <text class="detail-value">{{ order.serviceItem || order.title || '--' }}</text>
          </view>
          <view class="detail-item">
            <text class="detail-label">预约日期</text>
            <text class="detail-value">{{ order.expectDate || '--' }}</text>
          </view>
          <view class="detail-item">
            <text class="detail-label">预约时段</text>
            <text class="detail-value">{{ order.expectTimeSlot === 'am' ? '上午' : order.expectTimeSlot === 'pm' ? '下午' : '--' }}</text>
          </view>
          <view class="detail-item full" v-if="order.shopAddress">
            <text class="detail-label">门店地址</text>
            <text class="detail-value address">{{ order.shopAddress }}</text>
          </view>
        </view>
      </view>

      <!-- 统一订单（车辆）专属 -->
      <view class="section" v-if="order.bizType === 'unified'">
        <view class="section-header">
          <view class="header-left">
            <view class="section-icon icon-unified">
              <uni-icons type="cart" size="20" color="#fff"></uni-icons>
            </view>
            <text class="section-title">车辆信息</text>
          </view>
        </view>
        <view class="type-detail-grid">
          <view class="detail-item full">
            <text class="detail-label">订单类型</text>
            <text class="detail-value">
              <view class="sub-type-tag" :class="'sub-' + order.unifiedType">
                {{ unifiedTypeText }}
              </view>
            </text>
          </view>
          <view class="detail-item">
            <text class="detail-label">联系人</text>
            <text class="detail-value">{{ order.contactName || '--' }}</text>
          </view>
          <view class="detail-item">
            <text class="detail-label">联系电话</text>
            <text class="detail-value">{{ order.contactPhone || '--' }}</text>
          </view>
          <view class="detail-item">
            <text class="detail-label">车辆价格</text>
            <text class="detail-value">¥{{ order.vehiclePrice || order.totalAmount || 0 }}</text>
          </view>
          <view class="detail-item" v-if="order.paymentMethod">
            <text class="detail-label">支付方式</text>
            <text class="detail-value">{{ order.paymentMethod }}</text>
          </view>
        </view>
      </view>

      <!-- ======== 订单信息 ======== -->
      <view class="section">
        <view class="section-header">
          <view class="header-left">
            <view class="section-icon">
              <uni-icons type="list" size="20" color="#2563eb"></uni-icons>
            </view>
            <text class="section-title">订单信息</text>
          </view>
        </view>
        <view class="info-list">
          <view class="info-item">
            <view class="info-icon"><uni-icons type="calendar" size="16" color="#999"></uni-icons></view>
            <text class="info-label">下单时间</text>
            <text class="info-value">{{ order.createTime }}</text>
          </view>
          <view class="info-item" v-if="order.paymentMethod">
            <view class="info-icon"><uni-icons type="wallet" size="16" color="#999"></uni-icons></view>
            <text class="info-label">支付方式</text>
            <text class="info-value">{{ order.paymentMethod }}</text>
          </view>
          <view class="info-item" v-if="order.paidAmount > 0">
            <view class="info-icon"><uni-icons type="wallet" size="16" color="#999"></uni-icons></view>
            <text class="info-label">实付金额</text>
            <text class="info-value price">¥{{ order.paidAmount }}</text>
          </view>
        </view>
      </view>

      <!-- ======== 金额明细 ======== -->
      <view class="section">
        <view class="section-header">
          <view class="header-left">
            <view class="section-icon">
              <uni-icons type="medal" size="20" color="#2563eb"></uni-icons>
            </view>
            <text class="section-title">金额明细</text>
          </view>
        </view>
        <view class="amount-list">
          <view class="amount-item">
            <text class="amount-label">订单金额</text>
            <text class="amount-value">¥{{ order.totalAmount || 0 }}</text>
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
              <text class="total-num">{{ order.paidAmount || order.totalAmount || 0 }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 底部占位 -->
      <view class="bottom-space"></view>
    </scroll-view>

    <!-- ======== 底部操作栏 ======== -->
    <view class="bottom-bar" v-if="order">
      <view class="bar-left">
        <text class="total-label">实付款</text>
        <view class="total-amount">
          <text class="amount-symbol">¥</text>
          <text class="amount-num">{{ order.paidAmount || order.totalAmount || 0 }}</text>
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
import { getOrderDetail, cancelOrder, deleteOrder } from '@/api/mine/order'

/** 前端格式化充电时长：秒 → X时X分X秒 */
function formatDuration(duration, startTime, endTime) {
  let seconds = 0
  if (duration != null && duration > 0) {
    seconds = duration
  } else if (startTime && endTime) {
    const s = new Date(startTime).getTime()
    const e = new Date(endTime).getTime()
    if (e > s) seconds = Math.floor((e - s) / 1000)
  }
  if (seconds <= 0) return ''
  const h = Math.floor(seconds / 3600)
  const m = Math.floor((seconds % 3600) / 60)
  const s = seconds % 60
  let text = ''
  if (h > 0) text += h + '时'
  if (m > 0) text += m + '分'
  text += s + '秒'
  return text
}

export default {
  data() {
    return {
      orderId: '',
      bizType: 'unified',
      order: null,
      loading: false
    }
  },
  computed: {
    /** 类型图标 */
    typeIcon() {
      const map = { charging: 'circle', maintenance: 'tools', unified: 'cart' }
      return map[this.bizType] || 'list'
    },
    /** 联系按钮颜色 */
    contactColor() {
      const map = { charging: '#10b981', maintenance: '#f59e0b', unified: '#3b82f6' }
      return map[this.bizType] || '#2563eb'
    },
    /** 状态图标 */
    statusIcon() {
      const map = { unpaid: 'info', pending: 'clock', completed: 'checkmark', cancelled: 'close' }
      return map[this.order?.status] || 'info'
    },
    /** 状态提示语 */
    statusTip() {
      const map = {
        unpaid: '请尽快完成支付',
        pending: this.bizType === 'charging' ? '充电进行中' : this.bizType === 'maintenance' ? '维保服务进行中' : '商家正在为您准备',
        completed: '订单已完成',
        cancelled: '订单已取消'
      }
      return map[this.order?.status] || ''
    },
    /** 进度步骤 */
    progressSteps() {
      if (this.bizType === 'charging') return ['下单', '充电中', '已完成']
      if (this.bizType === 'maintenance') return ['预约', '服务中', '已完成']
      return ['下单', '支付', '服务', '完成']
    },
    /** 当前进度步骤索引 */
    currentStep() {
      const map = {
        charging: { unpaid: 0, pending: 1, completed: 2, cancelled: -1 },
        maintenance: { unpaid: 0, pending: 1, completed: 2, cancelled: -1 },
        unified: { unpaid: 0, pending: 2, completed: 3, cancelled: -1 }
      }
      const steps = map[this.bizType] || map.unified
      return steps[this.order?.status] ?? 0
    },
    /** 统一订单子类型文字 */
    unifiedTypeText() {
      const map = { purchase: '购车', test_drive: '试驾', trade_in: '以旧换新' }
      return map[this.order?.unifiedType] || this.order?.unifiedType || '--'
    }
  },
  onLoad(options) {
    this.orderId = options.id || options.orderId
    this.bizType = options.bizType || 'unified'
    if (this.orderId) {
      this.loadOrderDetail()
    }
  },
  methods: {
    goBack() { uni.navigateBack() },
    copyOrderNo() {
      uni.setClipboardData({
        data: String(this.order.orderNo || this.order.id),
        success: () => uni.showToast({ title: '已复制', icon: 'success' })
      })
    },
    async loadOrderDetail() {
      this.loading = true
      try {
        const res = await getOrderDetail(this.orderId, this.bizType)
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
    /** 将后端 OrderListVO 映射为前端详情数据 */
    formatOrder(order) {
      const statusMap = { 0: 'unpaid', 1: 'pending', 2: 'completed', 3: 'cancelled' }
      const statusTextMap = { unpaid: '待支付', pending: '待服务', completed: '已完成', cancelled: '已取消' }
      const typeLabelMap = { charging: '充电', maintenance: '维保', unified: '车辆' }

      const bizType = this.bizType || order.bizType || 'unified'
      const status = statusMap[order.status] || order.status || 'pending'

      return {
        // 公共字段
        id: order.id || order.orderId,
        orderNo: order.orderNo || order.orderNo || '',
        bizType,
        bizTypeLabel: typeLabelMap[bizType] || order.bizTypeLabel || '订单',
        status,
        statusText: statusTextMap[status] || order.statusText || '处理中',
        shopName: order.shopName || order.merchantName || order.stationName || '官方店铺',
        shopAddress: order.shopAddress || order.stationAddress || '',
        title: order.title || order.serviceItem || '订单',
        desc: order.desc || '',
        totalAmount: order.totalAmount || 0,
        paidAmount: order.paidAmount || 0,
        discount: order.discount || 0,
        createTime: order.createTime || '',
        paymentMethod: order.paymentMethod || '',

        // 充电订单字段
        totalEnergy: order.totalEnergy,
        durationText: order.durationText || formatDuration(order.duration, order.startTime, order.endTime),
        carbonEarned: order.carbonEarned,
        startTime: order.startTime,
        endTime: order.endTime,
        stationName: order.stationName,

        // 维保订单字段
        serviceItem: order.serviceItem,
        expectDate: order.expectDate,
        expectTimeSlot: order.expectTimeSlot,

        // 统一订单字段
        unifiedType: order.unifiedType,
        contactName: order.contactName,
        contactPhone: order.contactPhone,
        vehicleId: order.vehicleId,
        vehiclePrice: order.vehiclePrice
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
        content: '确认支付 ¥' + (this.order.paidAmount || this.order.totalAmount || 0) + '？',
        success: (res) => {
          if (res.confirm) uni.showToast({ title: '支付功能开发中', icon: 'none' })
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
    handleComment() { uni.showToast({ title: '评价功能开发中', icon: 'none' }) },
    handleRebuy() { uni.showToast({ title: '已加入购物车', icon: 'success' }) },
    async handleDelete() {
      uni.showModal({
        title: '删除订单',
        content: '确定要删除该订单吗？删除后将无法恢复。',
        success: async (res) => {
          if (res.confirm) {
            try {
              await deleteOrder(this.orderId)
              uni.showToast({ title: '删除成功', icon: 'success' })
              setTimeout(() => uni.navigateBack(), 1500)
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

// ==================== 内容区 ====================
.content-scroll {
  height: 100vh;
}

// ==================== 状态卡片 ====================
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

.status-unpaid    { background: linear-gradient(135deg, #ff6b35 0%, #f7931e 100%); }
.status-pending   { background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%); }
.status-completed { background: linear-gradient(135deg, #10b981 0%, #34d399 100%); }
.status-cancelled { background: linear-gradient(135deg, #6b7280 0%, #9ca3af 100%); }

.status-content {
  position: relative;
  display: flex;
  align-items: center;
  gap: 20rpx;
}

.status-icon-wrap { flex-shrink: 0; }

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
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 12rpx;
}

/* 状态小圆点 - 与列表页一致 */
.status-dot {
  width: 12rpx;
  height: 12rpx;
  border-radius: 50%;
  flex-shrink: 0;
}

.dot-unpaid    { background-color: #ff6b35; }
.dot-pending   { background-color: #2563eb; }
.dot-completed { background-color: #10b981; }
.dot-cancelled { background-color: #9ca3af; }

.status-text {
  font-size: 34rpx;
  font-weight: 600;
  color: #fff;
}

.status-tip {
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.8);
  margin-top: 0;
  width: 100%;
  margin-left: 24rpx;
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

// ==================== 进度条 ====================
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

// ==================== 通用 section ====================
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
  text { font-size: 24rpx; }
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

.icon-charging    { background: linear-gradient(135deg, #10b981, #34d399); }
.icon-maintenance { background: linear-gradient(135deg, #f59e0b, #fbbf24); }
.icon-unified     { background: linear-gradient(135deg, #3b82f6, #60a5fa); }

.section-title {
  font-size: 28rpx;
  font-weight: 600;
  color: #333;
}

// ==================== 商家卡片 ====================
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

.avatar-charging    { background: linear-gradient(135deg, #10b981, #34d399); }
.avatar-maintenance { background: linear-gradient(135deg, #f59e0b, #fbbf24); }
.avatar-unified     { background: linear-gradient(135deg, #3b82f6, #60a5fa); }

.shop-info { flex: 1; min-width: 0; }

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

// ==================== 类型专属详情网格 ====================
.type-detail-grid {
  display: flex;
  flex-wrap: wrap;
}

.detail-item {
  width: 50%;
  padding: 14rpx 8rpx;
}

.detail-item.full {
  width: 100%;
}

.detail-label {
  display: block;
  font-size: 24rpx;
  color: #999;
  margin-bottom: 8rpx;
}

.detail-value {
  font-size: 28rpx;
  color: #333;
  font-weight: 500;
}

.detail-value.address {
  font-size: 26rpx;
  color: #666;
  line-height: 1.5;
}

.detail-value.charging-color {
  color: #10b981;
}

.detail-unit {
  font-size: 22rpx;
  font-weight: 400;
  color: #999;
}

.detail-item.highlight {
  width: 100%;
}

.carbon-badge {
  display: inline-flex;
  align-items: center;
  padding: 4rpx 16rpx;
  background: linear-gradient(135deg, #10b981, #34d399);
  color: #fff !important;
  border-radius: 20rpx;
  font-size: 26rpx;
}

// 统一订单子类型标签
.sub-type-tag {
  display: inline-flex;
  padding: 4rpx 16rpx;
  border-radius: 16rpx;
  font-size: 24rpx;
  color: #fff;
}

.sub-purchase   { background: linear-gradient(135deg, #3b82f6, #60a5fa); }
.sub-test_drive { background: linear-gradient(135deg, #8b5cf6, #a78bfa); }
.sub-trade_in   { background: linear-gradient(135deg, #f59e0b, #fbbf24); }

// ==================== 信息列表 ====================
.info-list { padding: 0 8rpx; }

.info-item {
  display: flex;
  align-items: center;
  padding: 16rpx 0;
  border-bottom: 1rpx solid #f5f5f5;
}

.info-item:last-child { border-bottom: none; }

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

.info-value.price {
  color: #ff4757;
  font-weight: 600;
}

// ==================== 金额明细 ====================
.amount-list { padding: 0 8rpx; }

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

.amount-item.total { padding-top: 16rpx; }

.amount-label {
  font-size: 26rpx;
  color: #999;
}

.amount-value {
  font-size: 26rpx;
  color: #333;
}

.amount-value.discount { color: #10b981; }

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

.bottom-space { height: 160rpx; }

// ==================== 底部操作栏 ====================
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

// ==================== 空状态 ====================
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
  margin-top: 32rpx;
  padding: 20rpx 48rpx;
  background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
  color: #fff;
  font-size: 28rpx;
  border-radius: 48rpx;
  box-shadow: 0 4rpx 16rpx rgba(37, 99, 235, 0.3);
}
</style>