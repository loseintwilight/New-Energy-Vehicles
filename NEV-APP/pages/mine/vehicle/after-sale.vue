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
    <scroll-view scroll-y class="main-scroll" :show-scrollbar="false" @scrolltolower="onLoadMore" :lower-threshold="120">
      <!-- 顶栏 -->
      <view class="header">
        <view class="header-bg"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="header-info">
          <text class="header-title">售后管理</text>
          <text class="header-sub">共 {{ totalCount }} 个工单</text>
        </view>
      </view>

      <!-- 统计概览条（3个毛玻璃小卡片横排） -->
      <view class="stats-bar">
        <view class="stat-item" @tap="switchTab(1)">
          <text class="stat-val stat-total">{{ stats.total }}</text>
          <text class="stat-label">工单总数</text>
        </view>
        <view class="stat-divider"></view>
        <view class="stat-item" @tap="switchTab(2)">
          <text class="stat-val stat-processing">{{ stats.processing }}</text>
          <text class="stat-label">处理中</text>
        </view>
        <view class="stat-divider"></view>
        <view class="stat-item" @tap="switchTab(4)">
          <text class="stat-val stat-done">{{ stats.done }}</text>
          <text class="stat-label">已完成</text>
        </view>
      </view>

      <!-- 筛选标签栏 -->
      <view class="filter-section">
        <scroll-view scroll-x class="filter-scroll-x" :show-scrollbar="false">
          <view class="filter-row">
            <view
              class="filter-chip"
              v-for="(item, idx) in tabs"
              :key="idx"
              :class="{ active: activeTab === idx }"
              @tap="switchTab(idx)"
            >
              <text>{{ item.label }}</text>
            </view>
          </view>
        </scroll-view>
      </view>

      <!-- 售后工单卡片列表 -->
      <view class="ticket-list-wrap">
        <!-- 空状态 -->
        <view class="empty-state" v-if="filteredTickets.length === 0 && !loading">
          <view class="empty-circle">
            <text class="empty-icon">🔧</text>
          </view>
          <text class="empty-title">暂无售后工单</text>
          <text class="empty-desc">当前筛选条件下没有数据</text>
        </view>

        <!-- 工单卡片 -->
        <view
          class="ticket-card"
          v-for="(item, idx) in filteredTickets"
          :key="item.ticketId"
          :class="'card-status-' + item.status"
          :style="{ animationDelay: (idx * 0.08) + 's' }"
          hover-class="card-hover"
          :hover-stay-time="120"
          @tap="goDetail(item)"
        >
          <!-- 左侧彩色状态条 -->
          <view class="status-bar">
            <view class="pulse-ring" v-if="item.status === '0'"></view>
          </view>

          <!-- 卡片内容区 -->
          <view class="card-body">
            <!-- 上部：编号+类型标签 + 状态 -->
            <view class="card-top-row">
              <view class="card-left">
                <view class="ticket-no-row">
                  <text class="no-icon">#</text>
                  <text class="no-text">{{ item.ticketId }}</text>
                </view>
                <view :class="['type-tag', 'type-' + item.type]">
                  <text>{{ item.typeName }}</text>
                </view>
              </view>
              <view class="card-right">
                <view :class="['status-badge', 'sb-' + item.status]">
                  <view class="sb-dot" v-if="item.status === '0'"></view>
                  <text>{{ item.statusText }}</text>
                </view>
                <view :class="['priority-tag', 'pri-' + item.priority]">
                  <text>{{ item.priorityLabel }}</text>
                </view>
              </view>
            </view>

            <!-- 中部：车辆+客户信息 -->
            <view class="card-mid-row">
              <text class="vehicle-line">🚗 {{ item.vehicleName }}</text>
              <view class="customer-row">
                <text class="customer-name">{{ item.customerName }}</text>
                <text class="summary-text">{{ item.summary }}</text>
              </view>
            </view>

            <!-- 底部虚线分隔 -->
            <view class="card-dash-line"></view>

            <!-- 底部：提交时间 -->
            <view class="card-bottom-row">
              <text class="time-text">🕐 {{ item.submitTime }}</text>
            </view>
          </view>
        </view>

        <!-- 加载更多 -->
        <view class="load-more-wrap" v-if="filteredTickets.length > 0">
          <view class="load-more-btn" @tap="onLoadMore" hover-class="load-more-hover">
            <text class="load-more-text">{{ hasMore ? '加载更多' : '— 没有更多了 —' }}</text>
          </view>
        </view>
      </view>

      <view style="height: 100rpx;"></view>
    </scroll-view>
  </view>
</template>

<script>
export default {
  data: function() {
    return {
      isReady: false,
      glowRows: [],
      loading: false,
      hasMore: false,
      activeTab: 0,
      tabs: [
        { label: '全部', value: '' },
        { label: '待处理', value: '0' },
        { label: '处理中', value: '1' },
        { label: '已完成', value: '2' },
        { label: '已关闭', value: '3' }
      ],
      stats: { total: 0, processing: 0, done: 0 },
      mockTickets: [
        { ticketId: 'AS202605310001', type: 'repair', typeName: '维修服务',
          vehicleName: '比亚迪海豹 EV 700km 四驱旗舰版',
          customerName: '张**', summary: '空调制冷效果不佳，需要检查冷媒',
          priority: 'normal', priorityLabel: '普通',
          status: '0', statusText: '待处理', submitTime: '2026-05-31 08:30' },
        { ticketId: 'AS202605300002', type: 'return', typeName: '退换申请',
          vehicleName: '特斯拉 Model Y 后驱版',
          customerName: '李**', summary: '车辆存在异响问题，要求检测或更换',
          priority: 'urgent', priorityLabel: '紧急',
          status: '1', statusText: '处理中', submitTime: '2026-05-30 14:00' },
        { ticketId: 'AS202605290003', type: 'complaint', typeName: '投诉建议',
          vehicleName: '蔚来 ES6 75kWh 运动版',
          customerName: '王**', summary: '交付延期超过约定时间一周',
          priority: 'emergency', priorityLabel: '加急',
          status: '1', statusText: '处理中', submitTime: '2026-05-29 10:20' },
        { ticketId: 'AS202605280004', type: 'consult', typeName: '技术咨询',
          vehicleName: '理想 L7 Pro 增程版',
          customerName: '赵**', summary: '询问增程器保养周期和费用',
          priority: 'normal', priorityLabel: '普通',
          status: '2', statusText: '已完成', submitTime: '2026-05-28 16:45' },
        { ticketId: 'AS202605270005', type: 'repair', typeName: '维修服务',
          vehicleName: '比亚迪汉 DM-i 冠军版',
          customerName: '刘**', summary: '胎压监测系统误报',
          priority: 'normal', priorityLabel: '普通',
          status: '3', statusText: '已关闭', submitTime: '2026-05-27 11:00' }
      ]
    }
  },
  computed: {
    filteredTickets: function() {
      var self = this
      var list = self.mockTickets
      var val = self.tabs[self.activeTab].value
      if (val !== '') {
        list = list.filter(function(o) { return o.status === val })
      }
      return list
    },
    totalCount: function() {
      return this.mockTickets.length
    }
  },
  created: function() {
    this.buildGlowRows()
    this.calcStats()
    var that = this
    setTimeout(function() { that.isReady = true }, 200)
  },
  methods: {
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
    calcStats: function() {
      this.stats.total = this.mockTickets.length
      this.stats.processing = this.mockTickets.filter(function(o) { return o.status === '1' }).length
      this.stats.done = this.mockTickets.filter(function(o) { return o.status === '2' }).length
    },
    goBack: function() {
      uni.navigateBack({ delta: 1 })
    },
    switchTab: function(idx) {
      this.activeTab = idx
    },
    goDetail: function(item) {
      uni.showToast({ title: '查看工单 ' + item.ticketId, icon: 'none', duration: 1200 })
    },
    onLoadMore: function() {
      if (!this.hasMore) return
      uni.showToast({ title: '加载更多数据...', icon: 'none', duration: 1000 })
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
.page-ready .ticket-card {
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
.stat-item:active {
  transform: scale(0.96);
}
.stat-val {
  font-size: 36rpx;
  font-weight: 900;
  color: #f59e0b;
  letter-spacing: -0.5rpx;
}
.stat-total { color: #ea580c; }
.stat-processing { color: #2563eb; }
.stat-done { color: #16a34a; }
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

/* ========== 工单列表区域 ========== */
.ticket-list-wrap {
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
.empty-circle {
  width: 160rpx;
  height: 160rpx;
  border-radius: 80rpx;
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.08), rgba(251, 191, 36, 0.04));
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 24rpx;
}
.empty-icon {
  font-size: 64rpx;
}
.empty-title {
  font-size: 30rpx;
  color: #78716c;
  font-weight: 700;
  margin-bottom: 10rpx;
}
.empty-desc {
  font-size: 24rpx;
  color: #a8a29e;
}

/* ========== 工单卡片 ========== */
.ticket-card {
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
  background: linear-gradient(180deg, #f59e0b, #fbbf24);
  box-shadow: 2rpx 0 16rpx rgba(245, 158, 11, 0.35);
}
.card-status-1 .status-bar {
  background: linear-gradient(180deg, #2563eb, #3b82f6);
  box-shadow: 2rpx 0 16rpx rgba(37, 99, 235, 0.3);
}
.card-status-2 .status-bar {
  background: linear-gradient(180deg, #16a34a, #22c55e);
  box-shadow: 2rpx 0 16rpx rgba(22, 163, 74, 0.3);
}
.card-status-3 .status-bar {
  background: linear-gradient(180deg, #9ca3af, #d1d5db);
  box-shadow: 2rpx 0 16rpx rgba(156, 163, 175, 0.2);
}
.card-hover .status-bar {
  width: 9rpx;
}

/* 待处理橙色脉冲动画圆环 */
.pulse-ring {
  width: 18rpx;
  height: 18rpx;
  border-radius: 50%;
  background: #fbbf24;
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
  padding: 20rpx 18rpx 16rpx;
  display: flex;
  flex-direction: column;
}

/* 上部：编号+类型 | 状态+优先级 */
.card-top-row {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: flex-start;
}
.card-left {
  display: flex;
  flex-direction: column;
  flex: 1;
  min-width: 0;
  padding-right: 12rpx;
}
.ticket-no-row {
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
  font-size: 23rpx;
  font-weight: 800;
  color: #292524;
  font-family: monospace;
  letter-spacing: 0.5rpx;
}
.type-tag {
  display: inline-block;
  padding: 4rpx 14rpx;
  border-radius: 10rpx;
  font-size: 20rpx;
  font-weight: 700;
  align-self: flex-start;
}
.type-repair {
  background: rgba(239, 68, 68, 0.1);
  color: #dc2626;
  border: 1rpx solid rgba(239, 68, 68, 0.15);
}
.type-return {
  background: rgba(168, 85, 247, 0.1);
  color: #9333ea;
  border: 1rpx solid rgba(168, 85, 247, 0.15);
}
.type-complaint {
  background: rgba(245, 158, 11, 0.1);
  color: #d97706;
  border: 1rpx solid rgba(245, 158, 11, 0.15);
}
.type-consult {
  background: rgba(59, 130, 246, 0.1);
  color: #2563eb;
  border: 1rpx solid rgba(59, 130, 246, 0.15);
}

/* 右侧状态+优先级 */
.card-right {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  flex-shrink: 0;
  gap: 6rpx;
}
.status-badge {
  border-radius: 10rpx;
  padding: 5rpx 14rpx;
  font-size: 20rpx;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 6rpx;
}
.sb-dot {
  width: 8rpx;
  height: 8rpx;
  border-radius: 50%;
  background: #f59e0b;
  animation: sbDotBlink 1.2s ease-in-out infinite;
  box-shadow: 0 0 6rpx #f59e0b;
}
@keyframes sbDotBlink {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.3; }
}
.sb-0 {
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.12), rgba(251, 191, 36, 0.06));
  color: #d97706;
  border: 1rpx solid rgba(245, 158, 11, 0.2);
  padding-left: 20rpx;
}
.sb-1 {
  background: linear-gradient(135deg, rgba(37, 99, 235, 0.1), rgba(59, 130, 246, 0.05));
  color: #2563eb;
  border: 1rpx solid rgba(37, 99, 235, 0.18);
}
.sb-2 {
  background: linear-gradient(135deg, rgba(22, 163, 74, 0.1), rgba(34, 197, 94, 0.05));
  color: #16a34a;
  border: 1rpx solid rgba(22, 163, 74, 0.18);
}
.sb-3 {
  background: linear-gradient(135deg, rgba(107, 114, 128, 0.08), rgba(156, 163, 175, 0.04));
  color: #6b7280;
  border: 1rpx solid rgba(107, 114, 128, 0.12);
}
.priority-tag {
  padding: 3rpx 12rpx;
  border-radius: 8rpx;
  font-size: 18rpx;
  font-weight: 700;
}
.pri-normal {
  background: rgba(156, 163, 175, 0.1);
  color: #78716c;
  border: 1rpx solid rgba(156, 163, 175, 0.12);
}
.pri-urgent {
  background: rgba(239, 68, 68, 0.1);
  color: #dc2626;
  border: 1rpx solid rgba(239, 68, 68, 0.15);
}
.pri-emergency {
  background: rgba(220, 38, 38, 0.12);
  color: #b91c1c;
  border: 1rpx solid rgba(220, 38, 38, 0.2);
}

/* 中部：车辆+客户信息 */
.card-mid-row {
  margin-top: 14rpx;
}
.vehicle-line {
  font-size: 25rpx;
  color: #ea580c;
  font-weight: 700;
  line-height: 1.5;
  display: block;
  margin-bottom: 8rpx;
}
.customer-row {
  display: flex;
  align-items: center;
  gap: 10rpx;
}
.customer-name {
  font-size: 23rpx;
  color: #44403c;
  font-weight: 600;
  flex-shrink: 0;
}
.summary-text {
  font-size: 23rpx;
  color: #78716c;
  font-weight: 400;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  flex: 1;
}

/* 底部虚线分隔 */
.card-dash-line {
  height: 1rpx;
  margin-top: 14rpx;
  background-image: repeating-linear-gradient(
    to right,
    rgba(0, 0, 0, 0.06) 0,
    rgba(0, 0, 0, 0.06) 12rpx,
    transparent 12rpx,
    transparent 24rpx
  );
}

/* 底部时间行 */
.card-bottom-row {
  padding-top: 8rpx;
}
.time-text {
  font-size: 21rpx;
  color: #a8a29e;
  font-weight: 500;
}

/* ========== 加载更多 ========== */
.load-more-wrap {
  text-align: center;
  padding: 32rpx 0 16rpx;
}
.load-more-btn {
  display: inline-block;
  padding: 14rpx 48rpx;
  border-radius: 32rpx;
  background: rgba(255, 255, 255, 0.72);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border: 1rpx solid rgba(245, 158, 11, 0.15);
  transition: all 0.25s ease;
}
.load-more-hover {
  transform: scale(0.95);
  background: rgba(255, 255, 255, 0.9);
}
.load-more-text {
  font-size: 24rpx;
  color: #a16207;
  font-weight: 600;
}
</style>
