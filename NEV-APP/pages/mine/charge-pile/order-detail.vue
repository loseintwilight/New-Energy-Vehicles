<template>
  <view class="page" :class="{ 'page-ready': isReady }">
    <!-- 背景光晕矩阵（暖色琥珀系） -->
    <view class="glow-matrix">
      <view class="glow-row" v-for="(row, ri) in glowRows" :key="ri">
        <view class="glow-spot" v-for="(dot, ci) in row.dots" :key="ci" :style="dot.style"></view>
      </view>
    </view>
    <view class="overlay-mask"></view>

    <!-- 主滚动区 -->
    <scroll-view scroll-y class="main-scroll" :show-scrollbar="false">
      <!-- 顶栏（根据订单状态显示不同颜色） -->
      <view class="header" :class="'header-' + order.orderStatus">
        <view class="header-bg" :class="'hbg-' + order.orderStatus"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="header-info">
          <text class="header-title">订单详情</text>
          <view :class="['status-mini', 'sm-' + order.orderStatus]">
            <view class="sm-dot" v-if="order.orderStatus === '0'"></view>
            <text>{{ statusText }}</text>
          </view>
        </view>
      </view>

      <!-- Hero区域 - 金额大卡 -->
      <view class="hero-section" :class="'hero-' + order.orderStatus">
        <view class="hero-glow" :class="'hg-' + order.orderStatus"></view>
        <view class="hero-status-row">
          <view :class="['hero-badge', 'hb-' + order.orderStatus]">
            <view class="badge-dot" v-if="order.orderStatus === '0'"></view>
            <text>{{ statusText }}</text>
          </view>
        </view>
        <view class="hero-amount-wrap">
          <text class="amount-symbol">¥</text>
          <text class="amount-number">{{ formatAmount(order.totalAmount) }}</text>
        </view>
        <view class="hero-meta-row">
          <text class="meta-order-no">{{ shortOrderNo }}</text>
        </view>
        <view class="hero-time-row">
          <text class="time-icon">🕐</text>
          <text class="time-text">{{ order.createTime }}</text>
        </view>
      </view>

      <!-- 充电信息（蓝色色条） -->
      <view class="section-block sb-blue slide-up-1">
        <view class="title-bar">
          <view class="bar-line bar-line-blue"></view>
          <view class="icon-wrap iw-blue">
            <text class="bar-icon">🔌</text>
          </view>
          <text class="bar-title">充电信息</text>
        </view>
        <view class="info-card">
          <view class="info-row">
            <text class="info-label">桩编码</text>
            <text class="info-value code-val">{{ order.pileCode }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">站点名称</text>
            <text class="info-value">{{ order.stationName }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">接口类型</text>
            <view class="connector-wrap">
              <text class="connector-icon">{{ connectorIcon }}</text>
              <text class="connector-name">{{ order.connectorType }}</text>
            </view>
          </view>
          <view class="info-row">
            <text class="info-label">充电功率</text>
            <text class="info-value power-val">{{ order.powerKw }} kW</text>
          </view>
        </view>
      </view>

      <!-- 时间信息（绿色色条） -->
      <view class="section-block sb-green slide-up-2">
        <view class="title-bar">
          <view class="bar-line bar-line-green"></view>
          <view class="icon-wrap iw-green">
            <text class="bar-icon">⏱️</text>
          </view>
          <text class="bar-title">时间信息</text>
        </view>
        <view class="info-card">
          <view class="info-row">
            <text class="info-label">开始充电</text>
            <text class="info-value">{{ order.startTime }}</text>
          </view>
          <view class="info-row" v-if="order.orderStatus !== '0'">
            <text class="info-label">结束充电</text>
            <text class="info-value">{{ order.endTime }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">充电时长</text>
            <text class="info-value duration-highlight">{{ durationText }}</text>
          </view>
        </view>
      </view>

      <!-- 电量费用（琥珀色条） -->
      <view class="section-block sb-amber slide-up-3">
        <view class="title-bar">
          <view class="bar-line"></view>
          <view class="icon-wrap iw-amber">
            <text class="bar-icon">💰</text>
          </view>
          <text class="bar-title">电量费用</text>
        </view>
        <view class="info-card">
          <view class="info-row">
            <text class="info-label">充电电量</text>
            <text class="info-value energy-highlight">{{ order.totalEnergy || 0 }} kWh</text>
          </view>
          <view class="fee-divider"></view>
          <view class="fee-item">
            <text class="fee-label">电费</text>
            <text class="fee-value">&yen;{{ formatAmount(order.electricFee) }}</text>
          </view>
          <view class="fee-item">
            <text class="fee-label">服务费</text>
            <text class="fee-value">&yen;{{ formatAmount(order.serviceFee) }}</text>
          </view>
          <view class="fee-divider fee-divider-bold"></view>
          <view class="fee-total">
            <text class="total-label">合计金额</text>
            <text class="total-value">&yen;{{ formatAmount(order.totalAmount) }}</text>
          </view>
        </view>
        <view class="rate-note-card" v-if="order.rateName">
          <text class="rate-note-icon">📊</text>
          <text class="rate-note-text">费率说明：{{ order.rateName }}</text>
        </view>
      </view>

      <!-- 用户信息（紫色色条） -->
      <view class="section-block sb-purple slide-up-4">
        <view class="title-bar">
          <view class="bar-line bar-line-purple"></view>
          <view class="icon-wrap iw-purple">
            <text class="bar-icon">👤</text>
          </view>
          <text class="bar-title">用户信息</text>
        </view>
        <view class="info-card">
          <view class="info-row">
            <text class="info-label">用户名</text>
            <text class="info-value">{{ order.userName }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">手机号</text>
            <text class="info-value phone-val">{{ order.userPhone }}</text>
          </view>
        </view>
      </view>

      <!-- 取消原因（红色色条，仅已取消时显示） -->
      <view v-if="order.orderStatus === '2'" class="section-block sb-red slide-up-5">
        <view class="title-bar">
          <view class="bar-line bar-line-red"></view>
          <view class="icon-wrap iw-red">
            <text class="bar-icon">❌</text>
          </view>
          <text class="bar-title">取消原因</text>
        </view>
        <view class="cancel-content-card">
          <text class="cancel-text">{{ order.cancelReason || '用户主动取消订单' }}</text>
        </view>
      </view>

      <!-- 操作按钮区 -->
      <view class="action-section slide-up-6">
        <view class="action-card act-back" hover-class="act-hover" @tap="goBack">
          <view class="act-color-bar ac-back-bar"></view>
          <text class="act-icon">←</text>
          <text class="act-name">返回列表</text>
          <text class="act-desc">回到订单列表页</text>
        </view>
        <view class="action-card act-pile" hover-class="act-hover" @tap="goPileDetail">
          <view class="act-color-bar ac-pile-bar"></view>
          <text class="act-icon">🔌</text>
          <text class="act-name">查看充电桩</text>
          <text class="act-desc">查看该充电桩详情</text>
        </view>
      </view>

      <view style="height: 120rpx;"></view>
    </scroll-view>
  </view>
</template>

<script>
import { getOrderDetail } from '@/api/charger/order.js'

export default {
  data: function() {
    return {
      isReady: false,
      glowRows: [],
      orderId: '',
      order: {
        orderId: '',
        orderNo: '',
        pileId: '',
        pileCode: '',
        stationId: '',
        stationName: '',
        connectorType: '',
        powerKw: 0,
        userId: '',
        userName: '',
        userPhone: '',
        startTime: '',
        endTime: '',
        totalEnergy: 0,
        electricFee: 0,
        serviceFee: 0,
        totalAmount: 0,
        rateName: '',
        orderStatus: '1',
        createTime: ''
      }
    }
  },
  computed: {
    statusText: function() {
      if (!this.order) return ''
      var map = { '0': '充电中', '1': '已完成', '2': '已取消' }
      return map[this.order.orderStatus] || '未知'
    },
    durationText: function() {
      if (!this.order || !this.order.startTime || this.order.orderStatus === '0') return '--'
      var start = new Date(this.order.startTime.replace(/-/g, '/'))
      var end = this.order.endTime ? new Date(this.order.endTime.replace(/-/g, '/')) : new Date()
      var diffMin = Math.floor((end - start) / 1000 / 60)
      if (diffMin < 0) diffMin = 0
      if (diffMin >= 60) {
        return Math.floor(diffMin / 60) + '小时' + (diffMin % 60) + '分钟'
      }
      return diffMin + '分钟'
    },
    shortOrderNo: function() {
      if (!this.order || !this.order.orderNo) return '-'
      var no = this.order.orderNo
      if (no.length > 12) {
        return no.substring(0, 8) + '...' + no.substring(no.length - 4)
      }
      return no
    },
    connectorIcon: function() {
      if (!this.order) return '🔌'
      var icons = { 'GB/T': '🔌', 'CCS': '⚡', 'Type2': '🔋' }
      return icons[this.order.connectorType] || '🔌'
    }
  },
  created: function() {
    this.buildGlowRows()
    var that = this
    setTimeout(function() {
      that.isReady = true
    }, 200)
  },
  onLoad: function(options) {
    if (options && options.orderId) {
      this.orderId = options.orderId
      this.loadOrderData(options.orderId)
    }
  },
  methods: {
    loadOrderData: function(orderId) {
      var self = this
      getOrderDetail(orderId).then(function(res) {
        if (res.code === 200 && res.data) {
          var d = res.data
          self.order = {
            orderId: d.orderId || '',
            orderNo: d.orderNo || '',
            pileId: d.pileId || '',
            pileCode: d.pileCode || '',
            stationId: d.stationId || '',
            stationName: d.stationName || '未知站点',
            connectorType: d.connectorType || '',
            powerKw: d.powerKw || 0,
            userId: d.userId || '',
            userName: d.userName || '--',
            userPhone: d.userPhone || '',
            startTime: d.startTime || '',
            endTime: d.endTime || '',
            totalEnergy: d.totalEnergy || 0,
            electricFee: d.electricFee || 0,
            serviceFee: d.serviceFee || 0,
            totalAmount: d.totalAmount || 0,
            rateName: d.rateName || '',
            orderStatus: d.orderStatus || '1',
            createTime: d.createTime || ''
          }
        } else {
          uni.showToast({ title: res.msg || '加载失败', icon: 'none' })
        }
      }).catch(function() {
        uni.showToast({ title: '网络异常', icon: 'none' })
      })
    },
    buildGlowRows: function() {
      var rows = []
      var colors = ['#f59e0b', '#f97316', '#fb923c', '#fbbf24', '#fcd34d', '#fde68a']
      for (var r = 0; r < 8; r++) {
        var dots = []
        var count = 3 + Math.floor(Math.random() * 3)
        for (var c = 0; c < count; c++) {
          var color = colors[Math.floor(Math.random() * colors.length)]
          var size = 60 + Math.floor(Math.random() * 80)
          var dur = 2.5 + Math.random() * 2.5
          var delay = Math.random() * 2.5
          var alpha = 0.06 + Math.random() * 0.16
          dots.push({
            style: 'width:' + size + 'rpx;height:' + size + 'rpx;background:radial-gradient(circle,' + color + ',' + color + '00);opacity:' + alpha.toFixed(2) + ';animation-duration:' + dur.toFixed(1) + 's;animation-delay:' + delay.toFixed(1) + 's;'
          })
        }
        rows.push({ dots: dots })
      }
      this.glowRows = rows
    },
    formatAmount: function(amount) {
      if (amount === null || amount === undefined) return '0.00'
      return Number(amount).toFixed(2)
    },
    goBack: function() {
      uni.navigateBack({
        fail: function() {
          uni.navigateBack({ delta: 1 })
        }
      })
    },
    goPileDetail: function() {
      if (this.order && this.order.pileId) {
        uni.navigateTo({
          url: '/pages/mine/charge-pile/pile-detail?pileId=' + this.order.pileId
        })
      } else {
        uni.showToast({ title: '充电桩信息缺失', icon: 'none' })
      }
    }
  }
}
</script>

<style scoped>
/* ========== 页面容器 ========== */
.page {
  min-height: 100vh;
  background: linear-gradient(180deg, #fff7ed 0%, #fffbeb 30%, #fefce8 60%, #fffbeb 100%);
  position: relative;
  overflow-x: hidden;
}

/* ========== 入场动画 ========== */
.page-ready .hero-section { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.05s; }
.page-ready .slide-up-1 { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.12s; }
.page-ready .slide-up-2 { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.19s; }
.page-ready .slide-up-3 { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.26s; }
.page-ready .slide-up-4 { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.33s; }
.page-ready .slide-up-5 { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.4s; }
.page-ready .slide-up-6 { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.47s; }

@keyframes fadeSlideUp {
  from { opacity: 0; transform: translateY(30rpx) scale(0.96); }
  to { opacity: 1; transform: translateY(0) scale(1); }
}

/* ========== 背景光晕矩阵 ========== */
.glow-matrix {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 0;
  overflow: hidden;
  pointer-events: none;
}
.glow-row {
  display: flex;
  justify-content: space-around;
  align-items: center;
  padding: 24rpx 20rpx;
}
.glow-spot {
  border-radius: 50%;
  flex-shrink: 0;
  animation: glowPulse ease-in-out infinite alternate;
}
@keyframes glowPulse {
  0% { opacity: 0.12; transform: scale(0.85); }
  50% { opacity: 0.55; }
  100% { opacity: 0.12; transform: scale(1.25); }
}

.overlay-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(180deg,
    rgba(255, 247, 237, 0.92) 0%,
       rgba(255, 251, 235, 0.95) 35%,
       rgba(254, 252, 232, 0.96) 65%,
       rgba(255, 251, 235, 0.97) 100%
  );
  pointer-events: none;
  z-index: 1;
}

.main-scroll {
  position: relative;
  z-index: 2;
  height: 100vh;
}

/* ========== 顶栏（动态颜色） ========== */
.header {
  position: relative;
  padding: 28rpx 28rpx 24rpx;
  display: flex;
  align-items: center;
  overflow: hidden;
}
.header-bg {
  position: absolute;
  top: -80rpx;
  left: -40rpx;
  right: -40rpx;
  bottom: -20rpx;
  border-radius: 0 0 60rpx 60rpx;
}
.hbg-0 {
  background: linear-gradient(135deg, #d97706 0%, #f59e0b 35%, #fb923c 65%, #fbbf24 100%);
}
.hbg-1 {
  background: linear-gradient(135deg, #f59e0b 0%, #fb923c 35%, #fcd34d 65%, #fde68a 100%);
}
.hbg-2 {
  background: linear-gradient(135deg, #6b7280 0%, #9ca3af 35%, #d1d5db 65%, #e5e7eb 100%);
}

.back-btn {
  width: 64rpx;
  height: 64rpx;
  border-radius: 32rpx;
  background: rgba(255, 255, 255, 0.3);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2;
  box-shadow: 0 4rpx 14rpx rgba(0, 0, 0, 0.1);
  transition: all 0.2s ease;
}
.btn-hover {
  transform: scale(0.9);
  background: rgba(255, 255, 255, 0.45);
}
.back-icon {
  font-size: 36rpx;
  color: #ffffff;
  font-weight: 300;
}
.header-info {
  flex: 1;
  margin-left: 20rpx;
  z-index: 2;
  display: flex;
  flex-direction: row;
  align-items: center;
}
.header-title {
  font-size: 38rpx;
  font-weight: 800;
  color: #ffffff;
  letter-spacing: 1rpx;
  text-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.1);
}

/* 顶栏状态徽章 */
.status-mini {
  border-radius: 14rpx;
  padding: 8rpx 18rpx;
  font-size: 22rpx;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 8rpx;
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  z-index: 2;
  margin-left: 16rpx;
}
.sm-dot {
  width: 10rpx;
  height: 10rpx;
  border-radius: 50%;
  background: #ffffff;
  box-shadow: 0 0 8rpx #ffffff;
  animation: badgePulse 2s ease-in-out infinite;
}
@keyframes badgePulse {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.5; transform: scale(0.85); }
}
.sm-0 { background: rgba(255, 255, 255, 0.22); color: #ffffff; border: 1rpx solid rgba(255, 255, 255, 0.35); }
.sm-1 { background: rgba(255, 255, 255, 0.22); color: #ffffff; border: 1rpx solid rgba(255, 255, 255, 0.35); }
.sm-2 { background: rgba(255, 255, 255, 0.18); color: #6b7280; border: 1rpx solid rgba(107, 114, 128, 0.4); }

/* ========== Hero区域 - 金额大卡 ========== */
.hero-section {
  margin: 0 24rpx 20rpx;
  border-radius: 28rpx;
  padding: 32rpx 28rpx 28rpx;
  position: relative;
  overflow: hidden;
  box-shadow: inset 0 1rpx 0 rgba(255, 255, 255, 0.25);
}
.hero-0 {
  background: linear-gradient(135deg, #d97706 0%, #f59e0b 35%, #fb923c 65%, #fbbf24 100%);
  box-shadow: 0 12rpx 40rpx rgba(217, 119, 6, 0.35), inset 0 1rpx 0 rgba(255, 255, 255, 0.25);
}
.hero-1 {
  background: linear-gradient(135deg, #f59e0b 0%, #fb923c 35%, #fcd34d 65%, #fde68a 100%);
  box-shadow: 0 12rpx 40rpx rgba(245, 158, 11, 0.35), inset 0 1rpx 0 rgba(255, 255, 255, 0.25);
}
.hero-2 {
  background: linear-gradient(135deg, #6b7280 0%, #9ca3af 40%, #d1d5db 70%, #e5e7eb 100%);
  box-shadow: 0 12rpx 40rpx rgba(107, 114, 128, 0.35), inset 0 1rpx 0 rgba(255, 255, 255, 0.25);
}
.hero-glow {
  position: absolute;
  top: -60rpx;
  right: -60rpx;
  width: 200rpx;
  height: 200rpx;
  border-radius: 50%;
  pointer-events: none;
}
.hg-0 { background: radial-gradient(circle, rgba(255, 255, 255, 0.18) 0%, transparent 70%); }
.hg-1 { background: radial-gradient(circle, rgba(255, 255, 255, 0.15) 0%, transparent 70%); }
.hg-2 { background: radial-gradient(circle, rgba(255, 255, 255, 0.12) 0%, transparent 70%); }

.hero-status-row {
  display: flex;
  justify-content: center;
  margin-bottom: 20rpx;
  position: relative;
  z-index: 1;
}
.hero-badge {
  border-radius: 14rpx;
  padding: 8rpx 24rpx;
  font-size: 26rpx;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 10rpx;
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
}
.badge-dot {
  width: 12rpx;
  height: 12rpx;
  border-radius: 50%;
  background: #ffffff;
  box-shadow: 0 0 8rpx #ffffff;
  animation: badgePulse 2s ease-in-out infinite;
}
.hb-0 { background: rgba(255, 255, 255, 0.22); color: #ffffff; border: 1rpx solid rgba(255, 255, 255, 0.35); }
.hb-1 { background: rgba(255, 255, 255, 0.22); color: #ffffff; border: 1rpx solid rgba(255, 255, 255, 0.35); }
.hb-2 { background: rgba(255, 255, 255, 0.18); color: #6b7280; border: 1rpx solid rgba(107, 114, 128, 0.4); }

.hero-amount-wrap {
  display: flex;
  align-items: baseline;
  justify-content: center;
  margin-bottom: 16rpx;
  position: relative;
  z-index: 1;
}
.amount-symbol {
  font-size: 40rpx;
  font-weight: 700;
  color: rgba(255, 255, 255, 0.9);
  margin-right: 6rpx;
}
.amount-number {
  font-size: 80rpx;
  font-weight: 900;
  color: #ffffff;
  line-height: 1;
  text-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.12);
}

.hero-meta-row {
  display: flex;
  justify-content: center;
  margin-bottom: 12rpx;
  position: relative;
  z-index: 1;
}
.meta-order-no {
  font-size: 24rpx;
  font-family: "Courier New", Consolas, monospace;
  color: rgba(255, 255, 255, 0.78);
  letter-spacing: 1rpx;
}

.hero-time-row {
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  z-index: 1;
}
.time-icon { font-size: 24rpx; margin-right: 8rpx; }
.time-text {
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.8);
  font-weight: 500;
}

/* ========== 区块通用 ========== */
.section-block {
  margin: 0 24rpx 20rpx;
  background: rgba(255, 255, 255, 0.82);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border-radius: 24rpx;
  padding: 24rpx 22rpx;
  box-shadow: 0 6rpx 28rpx rgba(0, 0, 0, 0.05), inset 0 1rpx 0 rgba(255, 255, 255, 0.9);
  border: 1rpx solid rgba(255, 255, 255, 0.8);
  position: relative;
  z-index: 2;
  overflow: hidden;
}

.title-bar {
  display: flex;
  flex-direction: row;
  align-items: center;
  margin-bottom: 18rpx;
}
.bar-line {
  width: 7rpx;
  height: 32rpx;
  border-radius: 4rpx;
  margin-right: 12rpx;
  background: linear-gradient(180deg, #f59e0b, #f97316);
  box-shadow: 0 0 12rpx rgba(245, 158, 11, 0.35);
}
.bar-line-green { background: linear-gradient(180deg, #d97706, #f59e0b); box-shadow: 0 0 12rpx rgba(217,119,6,0.35); }
.bar-line-blue { background: linear-gradient(180deg, #f59e0b, #fb923c); box-shadow: 0 0 12rpx rgba(245,158,11,0.35); }
.bar-line-purple { background: linear-gradient(180deg, #fb923c, #fbbf24); box-shadow: 0 0 12rpx rgba(251,146,60,0.35); }
.bar-line-red { background: linear-gradient(180deg, #b45309, #d97706); box-shadow: 0 0 12rpx rgba(180,83,9,0.35); }

.icon-wrap {
  width: 48rpx;
  height: 48rpx;
  border-radius: 14rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 12rpx;
}
.iw-amber { background: linear-gradient(135deg, rgba(245, 158, 11, 0.15), rgba(251, 146, 60, 0.08)); }
.iw-green { background: linear-gradient(135deg, rgba(34, 197, 94, 0.15), rgba(22, 163, 74, 0.08)); }
.iw-blue { background: linear-gradient(135deg, rgba(59, 130, 246, 0.15), rgba(37, 99, 235, 0.08)); }
.iw-purple { background: linear-gradient(135deg, rgba(147, 51, 234, 0.15), rgba(124, 58, 237, 0.08)); }
.iw-red { background: linear-gradient(135deg, rgba(239, 68, 68, 0.15), rgba(220, 38, 38, 0.08)); }

.bar-icon { font-size: 26rpx; }
.bar-title {
  font-size: 30rpx;
  font-weight: 800;
  color: #1c1917;
  flex: 1;
  letter-spacing: 0.5rpx;
}

/* ========== 信息卡片 ========== */
.info-card {
  background: linear-gradient(135deg, rgba(254, 251, 236, 0.98), rgba(255, 255, 255, 1));
  border-radius: 18rpx;
  padding: 6rpx 22rpx;
  border: 1rpx solid rgba(245, 158, 11, 0.08);
}
.info-row {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  padding: 14rpx 0;
  border-bottom: 1rpx solid rgba(245, 158, 11, 0.06);
}
.info-row:last-child { border-bottom: none; }
.info-label {
  font-size: 25rpx;
  color: #a16207;
  font-weight: 600;
  flex-shrink: 0;
}
.info-value {
  font-size: 26rpx;
  color: #1c1917;
  font-weight: 600;
  text-align: right;
}
.info-value.code-val {
  font-family: monospace;
  letter-spacing: 0.5rpx;
  color: #d97706;
  font-weight: 700;
}
.info-value.power-val {
  color: #ea580c;
  font-weight: 700;
}
.info-value.duration-highlight {
  color: #f59e0b;
  font-weight: 800;
}
.info-value.energy-highlight {
  color: #f59e0b;
  font-weight: 800;
  font-size: 28rpx;
}
.info-value.phone-val {
  font-family: monospace;
  letter-spacing: 1rpx;
}

.connector-wrap {
  display: flex;
  align-items: center;
  gap: 8rpx;
}
.connector-icon { font-size: 28rpx; }
.connector-name {
  font-size: 26rpx;
  color: #1c1917;
  font-weight: 600;
}

/* ========== 费用明细 ========== */
.fee-divider {
  height: 1rpx;
  background: linear-gradient(to right, transparent, rgba(245, 158, 11, 0.15) 20%, rgba(245, 158, 11, 0.15) 80%, transparent);
  margin: 8rpx 0;
}
.fee-divider-bold {
  height: 2rpx;
  background: linear-gradient(to right, transparent, #f59e0b 15%, #f59e0b 85%, transparent);
  margin: 16rpx 0 8rpx;
}
.fee-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12rpx 0;
}
.fee-label {
  font-size: 26rpx;
  color: #78716c;
  font-weight: 500;
}
.fee-value {
  font-size: 28rpx;
  color: #1c1917;
  font-weight: 600;
}
.fee-total {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  padding-top: 12rpx;
}
.total-label {
  font-size: 28rpx;
  color: #a16207;
  font-weight: 700;
}
.total-value {
  font-size: 40rpx;
  font-weight: 900;
  color: #f59e0b;
}

/* 费率说明卡片 */
.rate-note-card {
  margin-top: 14rpx;
  padding: 14rpx 18rpx;
  background: linear-gradient(135deg, rgba(254, 243, 199, 0.95), rgba(254, 252, 232, 0.98));
  border-radius: 14rpx;
  border-left: 5rpx solid #f59e0b;
  display: flex;
  align-items: center;
  gap: 10rpx;
}
.rate-note-icon { font-size: 24rpx; flex-shrink: 0; }
.rate-note-text {
  font-size: 23rpx;
  color: #92400e;
  font-weight: 500;
  line-height: 1.4;
}

/* ========== 取消原因卡片 ========== */
.cancel-content-card {
  background: linear-gradient(135deg, rgba(254, 242, 242, 0.98), rgba(255, 255, 255, 1));
  border-radius: 18rpx;
  padding: 20rpx 22rpx;
  border: 1rpx solid rgba(239, 68, 68, 0.1);
}
.cancel-text {
  font-size: 26rpx;
  color: #991b1b;
  font-weight: 500;
  line-height: 1.5;
}

/* ========== 操作按钮区 ========== */
.action-section {
  display: flex;
  gap: 16rpx;
  padding: 0 24rpx;
  position: relative;
  z-index: 2;
}
.action-card {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 28rpx 16rpx;
  border-radius: 22rpx;
  position: relative;
  overflow: hidden;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  box-shadow: 0 6rpx 24rpx rgba(0, 0, 0, 0.06);
}
.act-hover {
  transform: scale(0.95)!important;
  box-shadow: 0 12rpx 32rpx rgba(0, 0, 0, 0.12)!important;
}
.act-color-bar {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 5rpx;
  border-radius: 22rpx 0 0 22rpx;
  transition: all 0.3s ease;
}

/* 返回列表（灰色系） */
.act-back {
  background: linear-gradient(135deg, #9ca3af, #6b7280, #4b5563);
}
.ac-back-bar { background: linear-gradient(180deg, #ffffff 0%, rgba(255,255,255,0.3) 100%); }
.act-back .act-icon, .act-back .act-name { color: #ffffff; }
.act-back .act-desc { color: rgba(255, 255, 255, 0.8); }

/* 查看充电桩（琥珀系） */
.act-pile {
  background: linear-gradient(135deg, #f59e0b, #f97316, #ea580c);
}
.ac-pile-bar { background: linear-gradient(180deg, #ffffff 0%, rgba(255,255,255,0.3) 100%); }
.act-pile .act-icon, .act-pile .act-name { color: #ffffff; }
.act-pile .act-desc { color: rgba(255, 255, 255, 0.88); }

.act-hover .act-color-bar { width: 7rpx; }

.act-icon { font-size: 36rpx; margin-bottom: 10rpx; }
.act-name { font-size: 26rpx; font-weight: 800; margin-bottom: 6rpx; }
.act-desc { font-size: 20rpx; font-weight: 500; }
</style>
