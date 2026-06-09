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
      <view class="header" :class="'header-' + order.status">
        <view class="header-bg" :class="'hbg-' + order.status"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="header-info">
          <text class="header-title">订单详情</text>
          <view :class="['status-mini', 'sm-' + order.status]">
            <view class="sm-dot" v-if="order.status === '0' || order.status === '1'"></view>
            <text>{{ statusText }}</text>
          </view>
        </view>
      </view>

      <!-- Hero区域 - 金额大卡 -->
      <view class="hero-section" :class="'hero-' + order.status">
        <view class="hero-glow" :class="'hg-' + order.status"></view>
        <view class="hero-status-row">
          <view :class="['hero-badge', 'hb-' + order.status]">
            <view class="badge-dot" v-if="order.status === '0' || order.status === '1'"></view>
            <text>{{ statusText }}</text>
          </view>
        </view>
        <view class="hero-amount-wrap">
          <text class="amount-symbol">¥</text>
          <text class="amount-number">{{ formatAmount(order.totalAmount) }}</text>
        </view>
        <view class="hero-vehicle-name">
          <text>{{ order.vehicleName }}</text>
        </view>
        <view class="hero-meta-row">
          <text class="meta-order-no">{{ shortOrderNo }}</text>
        </view>
        <view class="hero-time-row">
          <text class="time-icon">🕐</text>
          <text class="time-text">{{ order.createTime }}</text>
        </view>
      </view>

      <!-- 车辆信息（琥珀色条） -->
      <view class="section-block sb-amber slide-up-1">
        <view class="title-bar">
          <view class="bar-line bar-line-amber"></view>
          <view class="icon-wrap iw-amber">
            <text class="bar-icon">🚗</text>
          </view>
          <text class="bar-title">车辆信息</text>
        </view>
        <view class="info-card">
          <view class="info-row">
            <text class="info-label">车辆名称</text>
            <text class="info-value vehicle-val">{{ order.vehicleName }}</text>
          </view>
        </view>
      </view>

      <!-- 客户信息（蓝色色条） -->
      <view class="section-block sb-blue slide-up-2">
        <view class="title-bar">
          <view class="bar-line bar-line-blue"></view>
          <view class="icon-wrap iw-blue">
            <text class="bar-icon">👤</text>
          </view>
          <text class="bar-title">客户信息</text>
        </view>
        <view class="info-card">
          <view class="info-row">
            <text class="info-label">客户姓名</text>
            <text class="info-value name-val">{{ order.customerName }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">手机号码</text>
            <text class="info-value phone-val">{{ order.customerPhone }}</text>
          </view>
        </view>
      </view>

      <!-- 支付信息（紫色色条） -->
      <view class="section-block sb-purple slide-up-4">
        <view class="title-bar">
          <view class="bar-line bar-line-purple"></view>
          <view class="icon-wrap iw-purple">
            <text class="bar-icon">💳</text>
          </view>
          <text class="bar-title">支付信息</text>
        </view>
        <view class="info-card">
          <view class="fee-item">
            <text class="fee-label">应付总额</text>
            <text class="fee-value total-fee">¥{{ formatAmount(order.totalAmount) }}</text>
          </view>
          <view class="fee-divider"></view>
          <view class="fee-item">
            <text class="fee-label">已付金额</text>
            <text class="fee-value paid-fee">¥{{ formatAmount(order.paidAmount) }}</text>
          </view>
          <view class="fee-item">
            <text class="fee-label">尾款金额</text>
            <text class="fee-value remain-fee">¥{{ formatAmount(order.remainingAmount) }}</text>
          </view>
          <view class="fee-divider fee-divider-bold"></view>
          <view class="fee-item">
            <text class="fee-label">支付方式</text>
            <text class="fee-value method-val">{{ order.paymentMethod }}</text>
          </view>
        </view>
      </view>

      <!-- 时间线（橙色色条） -->
      <view class="section-block sb-orange slide-up-5">
        <view class="title-bar">
          <view class="bar-line bar-line-orange"></view>
          <view class="icon-wrap iw-orange">
            <text class="bar-icon">📋</text>
          </view>
          <text class="bar-title">订单进度</text>
        </view>
        <view class="timeline-card">
          <view class="timeline-node" v-for="(node, idx) in timelineNodes" :key="idx" :class="{ 'node-active': node.active, 'node-done': node.done }">
            <view class="node-left">
              <view class="node-dot-wrap">
                <view class="node-dot" :class="{ 'dot-pulse': node.active }"></view>
                <view v-if="idx < timelineNodes.length - 1" class="node-line" :class="{ 'line-active': node.done || node.active }"></view>
              </view>
            </view>
            <view class="node-right">
              <text class="node-title">{{ node.title }}</text>
              <text class="node-time" v-if="node.time">{{ node.time }}</text>
              <text class="node-time node-wait" v-else>等待中...</text>
            </view>
          </view>
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
        <view class="action-card act-car" hover-class="act-hover" @tap="goVehicleDetail">
          <view class="act-color-bar ac-car-bar"></view>
          <text class="act-icon">🚗</text>
          <text class="act-name">查看车辆</text>
          <text class="act-desc">查看该车辆详情</text>
        </view>
      </view>

      <view style="height: 120rpx;"></view>
    </scroll-view>
  </view>
</template>

<script>
import { getOrder } from '@/api/vehicle/vehicle'

export default {
  data: function() {
    return {
      isReady: false,
      glowRows: [],
      orderId: '',
      order: {
        orderId: '',
        orderNo: '',
        vehicleId: '',
        vehicleName: '-',
        customerName: '-',
        customerPhone: '-',
        totalAmount: 0,
        paidAmount: 0,
        remainingAmount: 0,
        paymentMethod: '-',
        status: '0',
        createTime: '-'
      },
      colorMap: {
        '星空蓝': '#1e40af',
        '星云紫': '#7c3aed',
        '极光绿': '#059669',
        '曙光白': '#f5f5f4',
        '曜石黑': '#18181b'
      }
    }
  },
  computed: {
    statusText: function() {
      var map = { '0': '待付款', '1': '待交付', '2': '已完成', '3': '已取消' }
      return map[this.order.status] || '未知'
    },
    shortOrderNo: function() {
      if (!this.order.orderNo) return '-'
      var no = this.order.orderNo
      if (no.length > 12) {
        return no.substring(0, 8) + '...' + no.substring(no.length - 4)
      }
      return no
    },
    timelineNodes: function() {
      var o = this.order
      var status = o.status || '0'
      var nodes = [
        { title: '下单', time: o.createTime, done: true, active: false },
        { title: '付款', time: status !== '0' ? o.createTime : '', done: ['1','2','3'].indexOf(status) >= 0, active: status === '0' },
        { title: '审核', time: status === '2' ? o.createTime : '', done: status === '2', active: status === '1' },
        { title: '交付', time: status === '2' ? o.createTime : '', done: false, active: false }
      ]
      return nodes
    }
  },
  created: function() {
    this.buildGlowRows()
    var that = this
    setTimeout(function() { that.isReady = true }, 200)
  },
  onLoad: function(options) {
    var that = this
    if (options && options.orderId) {
      that.orderId = options.orderId
      // 从后端加载订单详情
      getOrder(options.orderId).then(function(res) {
        if (res.code === 1 && res.data) {
          var o = res.data
          that.order = {
            orderId: o.orderId,
            orderNo: o.orderNo || '',
            vehicleId: o.vehicleId,
            vehicleName: o.vehicleName || '-',
            customerName: o.contactName || '-',
            customerPhone: o.contactPhone || '-',
            totalAmount: o.totalAmount || 0,
            paidAmount: o.paidAmount || 0,
            remainingAmount: (o.totalAmount || 0) - (o.paidAmount || 0),
            paymentMethod: o.paymentMethod || '-',
            status: o.status || '0',
            createTime: o.createTime || '-'
          }
        }
      }).catch(function() {
        console.log('获取订单详情失败')
      })
    }
  },
  methods: {
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
      return Number(amount).toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 })
    },
    goBack: function() {
      uni.navigateBack({
        fail: function() {
          uni.navigateBack({ delta: 1 })
        }
      })
    },
    goVehicleDetail: function() {
      if (this.order && this.order.vehicleId) {
        uni.navigateTo({
          url: '/pages/mine/vehicle/vehicle-detail?vehicleId=' + this.order.vehicleId
        })
      } else {
        uni.showToast({ title: '车辆信息缺失', icon: 'none' })
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
.hbg-0 { background: linear-gradient(135deg, #f59e0b 0%, #f97316 35%, #fb923c 65%, #fdba74 100%); }
.hbg-1 { background: linear-gradient(135deg, #d97706 0%, #f59e0b 35%, #fb923c 65%, #fbbf24 100%); }
.hbg-2 { background: linear-gradient(135deg, #f59e0b 0%, #fb923c 35%, #fcd34d 65%, #fde68a 100%); }
.hbg-3 { background: linear-gradient(135deg, #6b7280 0%, #9ca3af 35%, #d1d5db 65%, #e5e7eb 100%); }

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
.btn-hover { transform: scale(0.9); background: rgba(255, 255, 255, 0.45); }
.back-icon { font-size: 36rpx; color: #ffffff; font-weight: 300; }

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

/* 状态徽章 */
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
.sm-2 { background: rgba(255, 255, 255, 0.22); color: #ffffff; border: 1rpx solid rgba(255, 255, 255, 0.35); }
.sm-3 { background: rgba(255, 255, 255, 0.18); color: #6b7280; border: 1rpx solid rgba(107, 114, 128, 0.4); }

/* ========== Hero区域 - 金额大卡 ========== */
.hero-section {
  margin: 0 24rpx 20rpx;
  border-radius: 28rpx;
  padding: 32rpx 28rpx 28rpx;
  position: relative;
  overflow: hidden;
  box-shadow: inset 0 1rpx 0 rgba(255, 255, 255, 0.25);
}
.hero-0 { background: linear-gradient(135deg, #f59e0b 0%, #f97316 40%, #fb923c 70%, #fdba74 100%); box-shadow: 0 12rpx 40rpx rgba(245, 158, 11, 0.35), inset 0 1rpx 0 rgba(255, 255, 255, 0.25); }
.hero-1 { background: linear-gradient(135deg, #d97706 0%, #f59e0b 40%, #fb923c 70%, #fbbf24 100%); box-shadow: 0 12rpx 40rpx rgba(217,119,6,0.35), inset 0 1rpx 0 rgba(255, 255, 255, 0.25); }
.hero-2 { background: linear-gradient(135deg, #f59e0b 0%, #fb923c 40%, #fcd34d 70%, #fde68a 100%); box-shadow: 0 12rpx 40rpx rgba(245,158,11,0.35), inset 0 1rpx 0 rgba(255, 255, 255, 0.25); }
.hero-3 { background: linear-gradient(135deg, #6b7280 0%, #9ca3af 40%, #d1d5db 70%, #e5e7eb 100%); box-shadow: 0 12rpx 40rpx rgba(107, 114, 128, 0.35), inset 0 1rpx 0 rgba(255, 255, 255, 0.25); }

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
.hg-2 { background: radial-gradient(circle, rgba(255, 255, 255, 0.15) 0%, transparent 70%); }
.hg-3 { background: radial-gradient(circle, rgba(255, 255, 255, 0.12) 0%, transparent 70%); }

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
.hb-2 { background: rgba(255, 255, 255, 0.22); color: #ffffff; border: 1rpx solid rgba(255, 255, 255, 0.35); }
.hb-3 { background: rgba(255, 255, 255, 0.18); color: #6b7280; border: 1rpx solid rgba(107, 114, 128, 0.4); }

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

.hero-vehicle-name {
  text-align: center;
  margin-bottom: 12rpx;
  position: relative;
  z-index: 1;
}
.hero-vehicle-name text {
  font-size: 28rpx;
  color: rgba(255, 255, 255, 0.92);
  font-weight: 600;
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
.time-text { font-size: 24rpx; color: rgba(255, 255, 255, 0.8); font-weight: 500; }

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
.bar-line-amber { background: linear-gradient(180deg, #f59e0b, #ea580c); box-shadow: 0 0 12rpx rgba(245, 158, 11, 0.35); }
.bar-line-blue { background: linear-gradient(180deg, #f59e0b, #fb923c); box-shadow: 0 0 12rpx rgba(245,158,11,0.35); }
.bar-line-green { background: linear-gradient(180deg, #d97706, #f59e0b); box-shadow: 0 0 12rpx rgba(217,119,6,0.35); }
.bar-line-purple { background: linear-gradient(180deg, #fb923c, #fbbf24); box-shadow: 0 0 12rpx rgba(251,146,60,0.35); }
.bar-line-orange { background: linear-gradient(180deg, #f97316, #ea580c); box-shadow: 0 0 12rpx rgba(249, 115, 22, 0.35); }

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
.iw-blue { background: linear-gradient(135deg, rgba(59, 130, 246, 0.15), rgba(37, 99, 235, 0.08)); }
.iw-green { background: linear-gradient(135deg, rgba(34, 197, 94, 0.15), rgba(22, 163, 74, 0.08)); }
.iw-purple { background: linear-gradient(135deg, rgba(147, 51, 234, 0.15), rgba(124, 58, 237, 0.08)); }
.iw-orange { background: linear-gradient(135deg, rgba(249, 115, 22, 0.15), rgba(234, 88, 12, 0.08)); }

.bar-icon { font-size: 26rpx; }
.bar-title { font-size: 30rpx; font-weight: 800; color: #1c1917; flex: 1; letter-spacing: 0.5rpx; }

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
.info-label { font-size: 25rpx; color: #a16207; font-weight: 600; flex-shrink: 0; }
.info-value { font-size: 26rpx; color: #1c1917; font-weight: 600; text-align: right; }
.info-value.vehicle-val { color: #ea580c; font-weight: 800; font-size: 27rpx; }
.info-value.config-val { color: #78716c; font-size: 25rpx; }
.info-value.name-val { color: #d97706; font-weight: 700; }
.info-value.phone-val { font-family: monospace; letter-spacing: 1rpx; }
.info-value.idcard-val { font-family: monospace; letter-spacing: 0.5rpx; font-size: 24rpx; }
.info-value.plan-val { color: #f59e0b; font-weight: 700; }
.info-value.monthly-val { color: #f59e0b; font-weight: 800; font-size: 28rpx; }

.color-wrap { display: flex; align-items: center; gap: 10rpx; }
.color-dot { width: 28rpx; height: 28rpx; border-radius: 50%; border: 2rpx solid rgba(0, 0, 0, 0.08); }
.color-name { font-size: 26rpx; color: #1c1917; font-weight: 600; }

/* ========== 支付费用 ========== */
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
.fee-label { font-size: 26rpx; color: #78716c; font-weight: 500; }
.fee-value { font-size: 28rpx; color: #1c1917; font-weight: 600; }
.fee-value.total-fee { font-size: 32rpx; font-weight: 900; color: #f59e0b; }
.fee-value.paid-fee { color: #16a34a; font-weight: 700; }
.fee-value.remain-fee { color: #d97706; font-weight: 700; }
.fee-value.method-val { color: #64748b; font-size: 26rpx; }

/* ========== 时间线 ========== */
.timeline-card { padding: 4rpx 8rpx; }
.timeline-node {
  display: flex;
  flex-direction: row;
  padding: 16rpx 0;
  position: relative;
}
.node-left {
  width: 48rpx;
  flex-shrink: 0;
  display: flex;
  justify-content: center;
}
.node-dot-wrap { position: relative; display: flex; align-items: center; justify-content: center; }
.node-dot {
  width: 22rpx;
  height: 22rpx;
  border-radius: 50%;
  background: #d1d5db;
  border: 3rpx solid #ffffff;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}
.node-dot.dot-pulse {
  background: #f59e0b;
  box-shadow: 0 0 12rpx rgba(245, 158, 11, 0.5);
  animation: badgePulse 2s ease-in-out infinite;
}
.node-line {
  position: absolute;
  top: 28rpx;
  left: 50%;
  width: 2rpx;
  height: 52rpx;
  background: #e5e7eb;
  transform: translateX(-50%);
}
.node-line.line-active { background: linear-gradient(180deg, #f59e0b, #fcd34d); }

.node-right { flex: 1; padding-left: 16rpx; }
.node-title { font-size: 27rpx; font-weight: 700; color: #9ca3af; display: block; }
.node-done .node-title { color: #1c1917; }
.node-active .node-title { color: #f59e0b; }
.node-time { font-size: 23rpx; color: #9ca3af; margin-top: 4rpx; display: block; }
.node-done .node-time { color: #78716c; }
.node-active .node-time { color: #d97706; }
.node-wait { color: #6b7280; font-style: italic; }

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
.act-hover { transform: scale(0.95)!important; box-shadow: 0 12rpx 32rpx rgba(0, 0, 0, 0.12)!important; }
.act-color-bar {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 5rpx;
  border-radius: 22rpx 0 0 22rpx;
  transition: all 0.3s ease;
}

.act-back { background: linear-gradient(135deg, #9ca3af, #6b7280, #4b5563); }
.ac-back-bar { background: linear-gradient(180deg, #ffffff 0%, rgba(255,255,255,0.3) 100%); }
.act-back .act-icon, .act-back .act-name { color: #ffffff; }
.act-back .act-desc { color: rgba(255, 255, 255, 0.8); }

.act-car { background: linear-gradient(135deg, #f59e0b, #f97316, #ea580c); }
.ac-car-bar { background: linear-gradient(180deg, #ffffff 0%, rgba(255,255,255,0.3) 100%); }
.act-car .act-icon, .act-car .act-name { color: #ffffff; }
.act-car .act-desc { color: rgba(255, 255, 255, 0.88); }

.act-hover .act-color-bar { width: 7rpx; }

.act-icon { font-size: 36rpx; margin-bottom: 10rpx; }
.act-name { font-size: 26rpx; font-weight: 800; margin-bottom: 6rpx; }
.act-desc { font-size: 20rpx; font-weight: 500; }
</style>
