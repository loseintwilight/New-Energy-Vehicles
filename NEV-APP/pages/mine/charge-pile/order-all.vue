<template>
  <view class="page" :class="{ 'page-ready': isReady }">
    <!-- 背景光晕矩阵（暖色琥珀系） -->
    <view class="glow-matrix">
      <view class="glow-row" v-for="(row, ri) in glowRows" :key="ri">
        <view
          class="glow-spot"
          v-for="(dot, ci) in row.dots"
          :key="ci"
          :style="dot.style"
        ></view>
      </view>
    </view>
    <view class="overlay-mask"></view>

    <!-- 主滚动区 -->
    <scroll-view scroll-y class="main-scroll" :show-scrollbar="false">
      <!-- 顶栏 -->
      <view class="header">
        <view class="header-bg"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="header-info">
          <text class="header-title">全部订单</text>
          <text class="header-sub">共 {{ filteredOrders.length }} 笔订单</text>
        </view>
      </view>

      <!-- 统计概览条（3个毛玻璃小卡片横排） -->
      <view class="stats-bar">
        <view class="stat-item">
          <text class="stat-val">{{ totalOrderCount }}</text>
          <text class="stat-label">全部订单</text>
        </view>
        <view class="stat-divider"></view>
        <view class="stat-item">
          <text class="stat-val">¥{{ totalRevenue }}</text>
          <text class="stat-label">总营收</text>
        </view>
        <view class="stat-divider"></view>
        <view class="stat-item">
          <text class="stat-val stat-charging">0</text>
          <text class="stat-label">充电中</text>
        </view>
      </view>

      <!-- 筛选标签栏 - 订单状态 -->
      <view class="filter-section">
        <scroll-view scroll-x class="filter-scroll-x" :show-scrollbar="false">
          <view class="filter-row">
            <view
              class="filter-chip"
              v-for="(item, idx) in statusTabs"
              :key="idx"
              :class="{ active: activeStatus === idx }"
              @tap="switchStatus(idx)"
            >
              <text>{{ item.label }}</text>
            </view>
          </view>
        </scroll-view>
      </view>

      <!-- 订单卡片列表 -->
      <view class="order-list-wrap">
        <!-- 空状态 -->
        <view class="empty-state" v-if="filteredOrders.length === 0 && !loading">
          <text class="empty-icon">📋</text>
          <text class="empty-title">暂无订单</text>
          <text class="empty-desc">试试调整筛选条件或下拉刷新</text>
        </view>

        <!-- 订单卡片 -->
        <view
          class="order-card"
          v-for="(item, idx) in filteredOrders"
          :key="item.orderId"
          :class="'card-status-' + item.orderStatus"
          :style="{ animationDelay: (idx * 0.08) + 's' }"
          hover-class="card-hover"
          :hover-stay-time="120"
          @tap="goDetail(item)"
        >
          <!-- 左侧彩色状态条 -->
          <view class="status-bar">
            <view class="pulse-ring" v-if="item.orderStatus === '0'"></view>
          </view>

          <!-- 卡片内容区 -->
          <view class="card-body">
            <!-- 上部：左右两栏 -->
            <view class="card-top-row">
              <!-- 左侧信息 -->
              <view class="card-left">
                <view class="order-no-row">
                  <text class="no-icon">#</text>
                  <text class="no-text">{{ shortOrderNo(item.orderNo) }}</text>
                </view>
                <text class="info-line">🔌 {{ item.pileCode }}</text>
                <text class="info-line">📍 站点#{{ item.stationId || '--' }}</text>
                <text class="info-line">🕐 {{ fmtTime(item.startTime) }}</text>
              </view>
              <!-- 右侧金额+状态 -->
              <view class="card-right">
                <text class="amount-big">¥{{ fmtAmount(item.totalAmount) }}</text>
                <view :class="['status-tag', 'stag-' + item.orderStatus]">
                  <view class="stag-dot" v-if="item.orderStatus === '0'"></view>
                  <text>{{ getOrderStatusLabel(item.orderStatus) }}</text>
                </view>
                <text class="energy-text" v-if="item.totalEnergy > 0">⚡ {{ item.totalEnergy }}kWh</text>
                <text class="energy-text energy-zero" v-else>⚡ -- kWh</text>
              </view>
            </view>

            <!-- 底部虚线分隔 -->
          </view>
        </view>

      </view>

      <view style="height: 100rpx;"></view>
    </scroll-view>
  </view>
</template>

<script>
import { getOrderList, exportOrders } from '@/api/charger/order.js'

export default {
  data: function() {
    return {
      isReady: false,
      glowRows: [],
      loading: false,
      activeStatus: 0,
      activeTime: 0,
      statusTabs: [
        { label: '全部', value: '' },
        { label: '充电中', value: '0' },
        { label: '已完成', value: '1' },
        { label: '已取消', value: '2' }
      ],
      timeTabs: [
        { label: '今天', value: 'today' },
        { label: '近7天', value: 'week' },
        { label: '近30天', value: 'month' }
      ],
      /* 订单数据（从接口加载） */
      orderList: []
    }
  },
  computed: {
    filteredOrders: function() {
      var self = this
      var list = self.orderList
      var d = new Date(); var today = d.getFullYear() + "-" + String(d.getMonth() + 1).padStart(2, "0") + "-" + String(d.getDate()).padStart(2, "0"); list = list.filter(function(o) {
        return self.toDateStr(o.startTime || o.createTime) === today
      })
      var statusVal = self.statusTabs[self.activeStatus].value
      if (statusVal !== '') {
        list = list.filter(function(o) { return o.orderStatus === statusVal })
      }
      return list
    },
    totalOrderCount: function() {
      return this.orderList.length
    },
    totalRevenue: function() {
      var self = this
      var sum = 0
      self.orderList.filter(function(o) { return o.orderStatus !== '2' }).forEach(function(o) { sum += (o.totalAmount || 0) })
      return sum.toFixed(2)
    },
    chargingCount: function() {
      var self = this
      return self.orderList.filter(function(o) { return o.orderStatus === '0' }).length
    }
  },
  created: function() {
    this.buildGlowRows()
    this.loadOrders()
    var that = this
    setTimeout(function() { that.isReady = true }, 200)
  },
  methods: {

    /* ---------- 数据加载 ---------- */
    loadOrders: function() {
      var self = this
      self.loading = true
      getOrderList({ pageSize: 100 }).then(function(res) {
        self.loading = false
        if (res.code === 200) {
          self.orderList = res.rows || []
        } else {
          uni.showToast({ title: res.msg || '加载失败', icon: 'none' })
        }
      }).catch(function(err) {
        self.loading = false
        uni.showToast({ title: '网络异常', icon: 'none' })
      })
    },

    buildGlowRows: function() {
      var rows = []
      var colors = ['#f59e0b', '#f97316', '#fb923c', '#fbbf24', '#fcd34d', '#fde68a']
      for (var r = 0; r < 7; r++) {
        var dots = []
        var count = 4 + Math.floor(Math.random() * 3)
        for (var c = 0; c < count; c++) {
          var color = colors[Math.floor(Math.random() * colors.length)]
          var size = 60 + Math.floor(Math.random() * 70)
          var dur = 2.5 + Math.random() * 2.5
          var delay = Math.random() * 2.5
          var alpha = 0.08 + Math.random() * 0.18
          dots.push({
            style: 'width:' + size + 'rpx;height:' + size + 'rpx;background:radial-gradient(circle,' + color + ',' + color + '00);opacity:' + alpha.toFixed(2) + ';animation-duration:' + dur.toFixed(1) + 's;animation-delay:' + delay.toFixed(1) + 's;'
          })
        }
        rows.push({ dots: dots })
      }
      this.glowRows = rows
    },
    goBack: function() {
      uni.navigateBack({ delta: 1 })
    },
    switchStatus: function(idx) {
      this.activeStatus = idx
    },
    switchTime: function(idx) {
      this.activeTime = idx
      uni.showToast({ title: this.timeTabs[idx].label + '筛选已应用', icon: 'none', duration: 1200 })
    },
    goDetail: function(item) {
      uni.navigateTo({
        url: '/pages/mine/charge-pile/order-detail?orderId=' + item.orderId
      })
    },
    shortOrderNo: function(no) {
      if (!no) return ''
      if (no.length > 14) {
        return no.substring(0, 11) + '...'
      }
      return no
    },
    fmtTime: function(timeStr) {
      if (!timeStr) return '-'
      var d = new Date(timeStr.replace(/-/g, '/'))
      if (isNaN(d.getTime())) return timeStr
      var m = d.getMonth() + 1
      var day = d.getDate()
      var h = d.getHours()
      var min = d.getMinutes()
      var mStr = m < 10 ? '0' + m : '' + m
      var dStr = day < 10 ? '0' + day : '' + day
      var hStr = h < 10 ? '0' + h : '' + h
      var minStr = min < 10 ? '0' + min : '' + min
      return mStr + '-' + dStr + ' ' + hStr + ':' + minStr
    },
    fmtAmount: function(amount) {
      if (amount === null || amount === undefined) return '0.00'
      return Number(amount).toFixed(2)
    },
    getOrderStatusLabel: function(status) {
      var map = { '0': '充电中', '1': '已完成', '2': '已取消' }
      return map[status] || '未知'
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
.page-ready .order-card {
  animation: fadeSlideUp 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) backwards;
}

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
  0% { opacity: 0.15; transform: scale(0.85); }
  50% { opacity: 0.6; }
  100% { opacity: 0.15; transform: scale(1.25); }
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

/* ========== 顶栏 ========== */
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
  background: linear-gradient(135deg, #f59e0b 0%, #f97316 35%, #fb923c 65%, #fdba74 100%);
  border-radius: 0 0 60rpx 60rpx;
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
  flex-direction: column;
}
.header-title {
  font-size: 38rpx;
  font-weight: 800;
  color: #ffffff;
  letter-spacing: 1rpx;
  text-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.1);
}
.header-sub {
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.88);
  margin-top: 6rpx;
  font-weight: 500;
}

/* ========== 统计概览条 ========== */
.stats-bar {
  margin: 0 24rpx 20rpx;
  background: rgba(255, 255, 255, 0.82);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  border-radius: 22rpx;
  padding: 24rpx 16rpx;
  display: flex;
  align-items: center;
  box-shadow: 0 6rpx 24rpx rgba(0, 0, 0, 0.05), inset 0 1rpx 0 rgba(255, 255, 255, 0.9);
  border: 1rpx solid rgba(255, 255, 255, 0.8);
  position: relative;
  z-index: 2;
}
.stat-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
}
.stat-val {
  font-size: 32rpx;
  font-weight: 800;
  color: #f59e0b;
  letter-spacing: 0.5rpx;
}
.stat-charging {
  color: #d97706;
  animation: chargingBlink 1.5s ease-in-out infinite;
}
@keyframes chargingBlink {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.45; }
}
.stat-label {
  font-size: 22rpx;
  color: #78716c;
  margin-top: 6rpx;
  font-weight: 500;
}
.stat-divider {
  width: 2rpx;
  height: 48rpx;
  background: linear-gradient(180deg, transparent, #e7e5e4, transparent);
}

/* ========== 筛选标签栏 ========== */
.filter-section {
  padding: 0 24rpx 16rpx;
  position: relative;
  z-index: 2;
}
.filter-scroll-x {
  white-space: nowrap;
  margin-bottom: 12rpx;
}
.filter-scroll-x:last-child {
  margin-bottom: 0;
}
.filter-row {
  display: inline-flex;
  gap: 14rpx;
  padding: 6rpx 0;
}
.filter-chip {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 12rpx 28rpx;
  border-radius: 32rpx;
  font-size: 24rpx;
  color: #a16207;
  background: rgba(255, 255, 255, 0.72);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border: 1rpx solid rgba(245, 158, 11, 0.15);
  font-weight: 600;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  white-space: nowrap;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.03);
}
.filter-chip.active {
  color: #ffffff;
  background: linear-gradient(135deg, #f59e0b, #f97316);
  border-color: transparent;
  box-shadow: 0 4rpx 14rpx rgba(245, 158, 11, 0.3);
  transform: scale(1.05);
}
.time-chip {
  padding: 10rpx 24rpx;
  font-size: 22rpx;
  color: #78716c;
  background: rgba(255, 255, 255, 0.55);
  border-color: rgba(0, 0, 0, 0.06);
}
.time-chip.active {
  background: linear-gradient(135deg, #fbbf24, #f59e0b);
  box-shadow: 0 3rpx 10rpx rgba(251, 191, 36, 0.25);
}

/* ========== 订单列表区域 ========== */
.order-list-wrap {
  padding: 0 24rpx;
  position: relative;
  z-index: 2;
}

/* ========== 空状态 ========== */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 160rpx 0;
}
.empty-icon {
  font-size: 96rpx;
  margin-bottom: 20rpx;
}
.empty-title {
  font-size: 32rpx;
  color: #78716c;
  font-weight: 700;
  margin-bottom: 10rpx;
}
.empty-desc {
  font-size: 26rpx;
  color: #a8a29e;
}

/* ========== 订单卡片 ========== */
.order-card {
  display: flex;
  flex-direction: row;
  border-radius: 20rpx;
  margin-bottom: 20rpx;
  overflow: hidden;
  position: relative;
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  box-shadow: 0 6rpx 28rpx rgba(0, 0, 0, 0.05), inset 0 1rpx 0 rgba(255, 255, 255, 0.9);
  border: 1rpx solid rgba(255, 255, 255, 0.8);
  transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}
.card-hover {
  transform: scale(0.98) translateY(-2rpx);
  box-shadow: 0 12rpx 36rpx rgba(0, 0, 0, 0.1);
}

/* 左侧彩色状态条 */
.status-bar {
  width: 6rpx;
  position: relative;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
}
.card-status-0 .status-bar {
  background: linear-gradient(180deg, #d97706, #f59e0b);
  box-shadow: 2rpx 0 16rpx rgba(217,119,6,0.35);
}
.card-status-1 .status-bar {
  background: linear-gradient(180deg, #f59e0b, #fb923c);
  box-shadow: 2rpx 0 16rpx rgba(245,158,11,0.3);
}
.card-status-2 .status-bar {
  background: linear-gradient(180deg, #9ca3af, #d1d5db);
  box-shadow: 2rpx 0 16rpx rgba(156, 163, 175, 0.25);
}
.card-hover .status-bar {
  width: 9rpx;
}

/* 充电中脉冲动画圆环 */
.pulse-ring {
  width: 18rpx;
  height: 18rpx;
  border-radius: 50%;
  background: #fb923c;
  box-shadow: 0 0 12rpx #f59e0b, 0 0 24rpx rgba(245, 158, 11, 0.4);
  animation: statusPulse 1.6s ease-in-out infinite;
}
@keyframes statusPulse {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.4; transform: scale(0.6); }
}

/* 卡片内容区 */
.card-body {
  flex: 1;
  padding: 22rpx 20rpx 18rpx;
  display: flex;
  flex-direction: column;
}

/* 上下布局：上部左右两栏 */
.card-top-row {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: flex-start;
}

/* 左侧信息列 */
.card-left {
  display: flex;
  flex-direction: column;
  flex: 1;
  min-width: 0;
  padding-right: 16rpx;
}
.order-no-row {
  display: flex;
  align-items: center;
  margin-bottom: 8rpx;
}
.no-icon {
  font-size: 22rpx;
  color: #f97316;
  font-weight: 900;
  margin-right: 6rpx;
}
.no-text {
  font-size: 24rpx;
  font-weight: 800;
  color: #292524;
  font-family: monospace;
  letter-spacing: 0.5rpx;
}
.info-line {
  font-size: 23rpx;
  color: #78716c;
  line-height: 1.7;
  font-weight: 500;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* 右侧金额+状态列 */
.card-right {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  flex-shrink: 0;
}
.amount-big {
  font-size: 38rpx;
  font-weight: 900;
  color: #f59e0b;
  letter-spacing: -0.5rpx;
  text-shadow: 0 2rpx 8rpx rgba(245, 158, 11, 0.15);
  margin-bottom: 8rpx;
}
.status-tag {
  border-radius: 12rpx;
  padding: 5rpx 14rpx;
  font-size: 20rpx;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 6rpx;
  margin-bottom: 8rpx;
  position: relative;
  overflow: hidden;
}
.stag-dot {
  width: 8rpx;
  height: 8rpx;
  border-radius: 50%;
  background: #f59e0b;
  animation: stagDotBlink 1.2s ease-in-out infinite;
  box-shadow: 0 0 6rpx #f59e0b;
}
@keyframes stagDotBlink {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.3; }
}
.stag-0 {
  background: linear-gradient(135deg, rgba(217,119,6,0.12), rgba(245,158,11,0.06));
  color: #d97706;
  border: 1rpx solid rgba(217,119,6,0.2);
  padding-left: 20rpx;
}
.stag-1 {
  background: linear-gradient(135deg, rgba(34, 197, 94, 0.12), rgba(74, 222, 128, 0.06));
  color: #16a34a;
  border: 1rpx solid rgba(34, 197, 94, 0.2);
}
.stag-2 {
  background: linear-gradient(135deg, rgba(107, 114, 128, 0.1), rgba(156, 163, 175, 0.05));
  color: #6b7280;
  border: 1rpx solid rgba(107, 114, 128, 0.15);
}
.energy-text {
  font-size: 21rpx;
  color: #a8a29e;
  font-weight: 600;
}
.energy-zero {
  color: #d6d3d1;
}

/* 底部虚线分隔 */
.card-dash-line {
  height: 1rpx;
  margin-top: 16rpx;
  background-image: repeating-linear-gradient(
    to right,
    rgba(0, 0, 0, 0.06) 0,
    rgba(0, 0, 0, 0.06) 12rpx,
    transparent 12rpx,
    transparent 24rpx
  );
}

/* 底部附加信息 */
.card-bottom-info {
  padding-top: 10rpx;
}
.cancel-reason {
  font-size: 21rpx;
  color: #ef4444;
  font-weight: 500;
}

</style>
