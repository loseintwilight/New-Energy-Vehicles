<template>
  <view class="page" :class="{ 'page-ready': isReady }">
    <!-- 背景装饰 -->
    <view class="glow-matrix">
      <view class="glow-row" v-for="(row, ri) in glowRows" :key="ri">
        <view class="glow-spot" v-for="(dot, ci) in row.dots" :key="ci" :style="dot.style"></view>
      </view>
    </view>
    <view class="overlay-mask"></view>

    <scroll-view scroll-y class="main-scroll" :show-scrollbar="false">
      <!-- 顶栏 -->
      <view class="header">
        <view class="header-bg"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">❮</text>
        </view>
        <view class="header-info">
          <text class="header-title">订单管理</text>
          <text class="header-sub">共 {{ orderList.length }} 笔订单</text>
        </view>
      </view>

      <!-- 订单统计 -->
      <view class="stats-section">
        <view class="stats-row">
          <view class="stat-card stat-all" @tap="switchTab('all')">
            <text class="stat-num">{{ orderList.length }}</text>
            <text class="stat-label">全部</text>
          </view>
          <view class="stat-card stat-pending" @tap="switchTab('pending_payment')">
            <text class="stat-num">{{ statsCount('pending_payment') }}</text>
            <text class="stat-label">待付款</text>
          </view>
          <view class="stat-card stat-paid" @tap="switchTab('paid')">
            <text class="stat-num">{{ statsCount('paid') }}</text>
            <text class="stat-label">已付款</text>
          </view>
          <view class="stat-card stat-done" @tap="switchTab('completed')">
            <text class="stat-num">{{ statsCount('completed') }}</text>
            <text class="stat-label">已完成</text>
          </view>
        </view>
      </view>

      <!-- 筛选标签 -->
      <view class="filter-tabs">
        <scroll-view scroll-x class="tab-scroll" :show-scrollbar="false">
          <view class="tab-item" v-for="(tab, idx) in tabs" :key="idx" :class="{ active: currentTab === tab.value }" @tap="switchTab(tab.value)">
            <text>{{ tab.label }}</text>
          </view>
        </scroll-view>
      </view>

      <!-- 订单列表 -->
      <view class="order-list">
        <view class="order-card" v-for="(item, idx) in filteredList" :key="idx" hover-class="card-hover" @tap="goDetail(item.id)">
          <view class="card-header">
            <text class="order-no">{{ item.order_no }}</text>
            <view class="type-tag" :class="'type-' + item.type">
              <text>{{ typeMap[item.type] }}</text>
            </view>
          </view>
          <view class="card-body">
            <view class="info-row">
              <text class="info-icon">👤</text>
              <text class="info-text">{{ item.contact_name }} · {{ item.contact_phone }}</text>
            </view>
            <view class="info-row">
              <text class="info-icon">🚗</text>
              <text class="info-text car-name">{{ item.car_name }}</text>
            </view>
            <view class="price-row">
              <text class="price-label">订单金额</text>
              <text class="price-value" v-if="item.amount > 0">¥{{ item.amount.toLocaleString('zh-CN') }}</text>
              <text class="price-value zero" v-else>免费</text>
            </view>
          </view>
          <view class="card-footer">
            <text class="time-text">{{ item.create_time }}</text>
            <view class="status-tag" :class="'status-' + item.status">
              <text>{{ statusMap[item.status] }}</text>
            </view>
          </view>
        </view>

        <view v-if="filteredList.length === 0" class="empty-wrap">
          <view class="empty-circle">
            <text class="empty-icon">📋</text>
          </view>
          <text class="empty-text">暂无订单</text>
        </view>
      </view>

      <view class="bottom-safe"></view>
    </scroll-view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      isReady: false,
      glowRows: [],
      currentTab: 'all',
      tabs: [
        { label: '全部', value: 'all' },
        { label: '购车订单', value: 'purchase' },
        { label: '试驾预约', value: 'test_drive' },
        { label: '以旧换新', value: 'trade_in' }
      ],
      typeMap: {
        purchase: '购车订单',
        test_drive: '试驾预约',
        trade_in: '以旧换新'
      },
      statusMap: {
        pending_payment: '待付款',
        paid: '已付款',
        completed: '已完成',
        cancelled: '已取消'
      },
      orderList: [
        { id: 'ORD20260601001', order_no: 'NEV2026060100001', type: 'purchase', contact_name: '张先生', contact_phone: '138****1234', car_name: '特斯拉 Model Y 长续航版', amount: 299900, status: 'paid', create_time: '2026-06-01 10:23:15' },
        { id: 'ORD20260601002', order_no: 'NEV2026060100002', type: 'test_drive', contact_name: '李女士', contact_phone: '139****5678', car_name: '比亚迪 汉EV 冠军版', amount: 0, status: 'pending_payment', create_time: '2026-06-01 09:45:30' },
        { id: 'ORD20260601003', order_no: 'NEV2026060100003', type: 'trade_in', contact_name: '王先生', contact_phone: '137****9012', car_name: '蔚来 ET5 75kWh', amount: 328000, status: 'completed', create_time: '2026-05-31 16:08:42' },
        { id: 'ORD20260601004', order_no: 'NEV2026060100004', type: 'purchase', contact_name: '赵女士', contact_phone: '136****3456', car_name: '小鹏 P7i 702 Max', amount: 289900, status: 'pending_payment', create_time: '2026-05-31 14:22:18' },
        { id: 'ORD20260601005', order_no: 'NEV2026060100005', type: 'test_drive', contact_name: '孙先生', contact_phone: '135****7890', car_name: '理想 L7 Pro', amount: 0, status: 'completed', create_time: '2026-05-30 11:33:55' },
        { id: 'ORD20260601006', order_no: 'NEV2026060100006', type: 'purchase', contact_name: '周先生', contact_phone: '134****2345', car_name: '极氪 001 YOU版', amount: 389000, status: 'cancelled', create_time: '2026-05-30 09:17:33' },
        { id: 'ORD20260601007', order_no: 'NEV2026060100007', type: 'trade_in', contact_name: '吴先生', contact_phone: '133****6789', car_name: '问界 M7 Plus', amount: 319800, status: 'paid', create_time: '2026-05-29 15:44:20' },
        { id: 'ORD20260601008', order_no: 'NEV2026060100008', type: 'purchase', contact_name: '郑先生', contact_phone: '132****0123', car_name: '智己 LS7 90kWh', amount: 358800, status: 'pending_payment', create_time: '2026-05-29 10:05:48' }
      ]
    }
  },
  computed: {
    filteredList() {
      if (this.currentTab === 'all') return this.orderList
      return this.orderList.filter(function(item) { return item.type === this.currentTab }.bind(this))
    }
  },
  onLoad() {
    var that = this
    this.buildGlowRows()
    setTimeout(function() { that.isReady = true }, 100)
  },
  methods: {
    buildGlowRows() {
      var rows = []
      var colors = ['#16a34a', '#22c55e', '#4ade80', '#86efac']
      for (var r = 0; r < 5; r++) {
        var dots = []
        var count = 3 + Math.floor(Math.random() * 4)
        for (var c = 0; c < count; c++) {
          var color = colors[Math.floor(Math.random() * colors.length)]
          dots.push({ style: 'width:' + (3 + Math.random() * 6) + 'px;height:' + (3 + Math.random() * 6) + 'px;background:' + color + ';animation-duration:' + (2 + Math.random() * 3) + 's;animation-delay:' + (Math.random() * 2) + 's;' })
        }
        rows.push({ dots: dots })
      }
      this.glowRows = rows
    },
    goBack() { uni.navigateBack() },
    switchTab(value) { this.currentTab = value },
    statsCount(status) {
      return this.orderList.filter(function(item) { return item.status === status }).length
    },
    goDetail(orderId) {
      uni.navigateTo({ url: '/pages/mine/vehicle/vehicle-order-detail?orderId=' + orderId })
    }
  }
}
</script>

<style scoped>
/* ========== 页面容器 ========== */
.page {
  min-height: 100vh;
  background: linear-gradient(180deg, #ecfdf5 0%, #f0fdf4 30%, #f7fee7 60%, #fefefe 100%);
  position: relative;
  overflow: hidden;
  opacity: 0;
}
.page-ready {
  opacity: 1;
}
.page-ready .order-card {
  animation: slideUp 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) backwards;
}
.page-ready .order-card:nth-child(1) { animation-delay: 0.05s; }
.page-ready .order-card:nth-child(2) { animation-delay: 0.1s; }
.page-ready .order-card:nth-child(3) { animation-delay: 0.15s; }
.page-ready .order-card:nth-child(4) { animation-delay: 0.2s; }
.page-ready .order-card:nth-child(5) { animation-delay: 0.25s; }
.page-ready .order-card:nth-child(6) { animation-delay: 0.3s; }
.page-ready .order-card:nth-child(7) { animation-delay: 0.35s; }
.page-ready .order-card:nth-child(8) { animation-delay: 0.4s; }

@keyframes slideUp {
  from { opacity: 0; transform: translateY(30rpx); }
  to { opacity: 1; transform: translateY(0); }
}

/* ========== 背景光晕 ========== */
.glow-matrix {
  position: fixed; top: 0; left: 0; right: 0; bottom: 0;
  pointer-events: none; z-index: 0; overflow: hidden;
  display: flex; flex-direction: column;
}
.glow-row {
  display: flex; justify-content: space-around;
  align-items: center; padding: 20rpx 12rpx; gap: 16rpx;
}
.glow-spot {
  border-radius: 50%; flex-shrink: 0;
  animation: glowPulse ease-in-out infinite;
}
@keyframes glowPulse {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.5; transform: scale(0.9); }
}
.overlay-mask {
  position: fixed; top: 0; left: 0; right: 0; bottom: 0;
  background: linear-gradient(180deg, rgba(240,253,244,0.88) 0%, rgba(236,253,245,0.9) 30%, rgba(248,250,252,0.93) 70%, rgba(255,255,255,0.96) 100%);
  z-index: 1; pointer-events: none;
}

/* ========== 顶栏 ========== */
.header {
  height: 160rpx; padding: 0 28rpx; display: flex; align-items: center;
  position: relative; z-index: 10;
}
.header-bg {
  position: absolute; top: 0; left: 0; right: 0; bottom: 0;
  background: linear-gradient(135deg, #16a34a 0%, #22c55e 40%, #4ade80 70%, #86efac 100%);
  border-radius: 0 0 32rpx 32rpx;
}
.header-bg::after {
  content: ''; position: absolute; bottom: -16rpx; left: 0; right: 0;
  height: 32rpx;
  background: linear-gradient(180deg, #16a34a, transparent);
  border-radius: 0 0 32rpx 32rpx; filter: blur(10rpx); opacity: 0.3;
}
.back-btn {
  width: 64rpx; height: 64rpx; border-radius: 50%;
  background: rgba(255,255,255,0.22);
  display: flex; align-items: center; justify-content: center;
  margin-right: 20rpx; z-index: 1; transition: all 0.12s ease;
}
.btn-hover { transform: scale(0.92); background: rgba(255,255,255,0.4); }
.back-icon { color: #fff; font-size: 36rpx; font-weight: 300; }
.header-info { flex: 1; z-index: 1; }
.header-title { font-size: 36rpx; font-weight: 700; color: #fff; display: block; }
.header-sub { font-size: 24rpx; color: rgba(255,255,255,0.8); margin-top: 4rpx; }

/* ========== 统计卡片 ========== */
.stats-section { position: relative; z-index: 2; padding: 24rpx 28rpx 0; }
.stats-row { display: flex; gap: 16rpx; }
.stat-card {
  flex: 1; background: #fff; border-radius: 20rpx;
  padding: 24rpx 0; text-align: center;
  box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.04);
}
.stat-num { font-size: 36rpx; font-weight: 700; display: block; color: #1a1a2e; }
.stat-label { font-size: 22rpx; color: #888; margin-top: 4rpx; display: block; }

/* ========== 筛选标签 ========== */
.filter-tabs { position: relative; z-index: 2; padding: 20rpx 28rpx; }
.tab-scroll { white-space: nowrap; }
.tab-item {
  display: inline-block; padding: 12rpx 28rpx; border-radius: 28rpx;
  font-size: 26rpx; color: #666; background: #fff;
  margin-right: 16rpx; box-shadow: 0 2rpx 8rpx rgba(0,0,0,0.04);
  transition: all 0.2s;
}
.tab-item.active {
  background: linear-gradient(135deg, #16a34a, #22c55e);
  color: #fff; font-weight: 600;
}

/* ========== 订单列表 ========== */
.order-list { position: relative; z-index: 2; padding: 0 28rpx; }
.order-card {
  background: #fff; border-radius: 20rpx; padding: 28rpx;
  margin-bottom: 20rpx; box-shadow: 0 2rpx 16rpx rgba(0,0,0,0.04);
  transition: all 0.2s;
}
.card-hover { transform: scale(0.98); box-shadow: 0 4rpx 20rpx rgba(0,0,0,0.08); }

.card-header {
  display: flex; justify-content: space-between; align-items: center;
  margin-bottom: 20rpx;
}
.order-no { font-size: 26rpx; color: #888; font-family: monospace; }
.type-tag {
  padding: 6rpx 16rpx; border-radius: 12rpx; font-size: 22rpx; font-weight: 500;
  background: #eff6ff; color: #3b82f6;
}
.type-tag.type-test_drive { background: #fef3c7; color: #d97706; }
.type-tag.type-trade_in { background: #ede9fe; color: #7c3aed; }

.card-body { margin-bottom: 20rpx; }
.info-row { display: flex; align-items: center; margin-bottom: 12rpx; }
.info-icon { font-size: 26rpx; margin-right: 12rpx; }
.info-text { font-size: 26rpx; color: #444; flex: 1; }
.car-name { color: #16a34a; font-weight: 500; }
.price-row { display: flex; justify-content: space-between; align-items: center; padding-top: 16rpx; border-top: 1rpx solid #f0f0f0; }
.price-label { font-size: 24rpx; color: #aaa; }
.price-value { font-size: 32rpx; font-weight: 700; color: #e53e3e; }
.price-value.zero { font-size: 28rpx; font-weight: 500; color: #888; }

.card-footer { display: flex; justify-content: space-between; align-items: center; }
.time-text { font-size: 22rpx; color: #bbb; }
.status-tag {
  padding: 8rpx 18rpx; border-radius: 16rpx; font-size: 22rpx; font-weight: 500;
  background: #f0fdf4; color: #16a34a;
}
.status-tag.status-pending_payment { background: #fef3c7; color: #d97706; }
.status-tag.status-completed { background: #eff6ff; color: #3b82f6; }
.status-tag.status-cancelled { background: #f1f5f9; color: #94a3b8; }

/* ========== 空状态 ========== */
.empty-wrap { text-align: center; padding: 120rpx 0; }
.empty-circle {
  width: 140rpx; height: 140rpx; border-radius: 50%;
  background: #f1f5f9; margin: 0 auto 24rpx;
  display: flex; align-items: center; justify-content: center;
}
.empty-icon { font-size: 52rpx; }
.empty-text { font-size: 28rpx; color: #aaa; }

/* ========== 底部安全区 ========== */
.bottom-safe { height: 40rpx; }

.main-scroll { height: calc(100vh - 0px); position: relative; z-index: 2; }
</style>