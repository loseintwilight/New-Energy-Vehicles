<template>
  <view class="page" :class="{ 'page-ready': isReady }">
    <!-- 背景光晕 -->
    <view class="glow-matrix">
      <view class="glow-row" v-for="(row, ri) in glowRows" :key="ri">
        <view class="glow-spot" v-for="(dot, ci) in row.dots" :key="ci" :style="dot.style"></view>
      </view>
    </view>
    <view class="overlay-mask"></view>

    <!-- 主滚动区 -->
    <scroll-view scroll-y class="main-scroll" :show-scrollbar="false">
      <!-- 顶栏 -->
      <view class="header">
        <view class="header-bg"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">❮</text>
        </view>
        <view class="header-info">
          <text class="header-title">数据概览</text>
          <text class="header-sub">实时监控充电站运营数据</text>
        </view>
        <view class="header-right" @tap="refreshData">
          <text class="refresh-icon">↻</text>
        </view>
      </view>

      <!-- 时间切换 -->
      <view class="time-tabs">
        <view class="tab-item" v-for="(tab, idx) in timeTabs" :key="idx" :class="{ active: activeTab === idx }" @tap="switchTab(idx)">
          <text>{{ tab }}</text>
          <view class="tab-indicator" v-if="activeTab === idx"></view>
        </view>
      </view>

      <!-- 核心指标 -->
      <view class="kpi-section">
        <view class="kpi-card" v-for="(kpi, idx) in kpiData" :key="idx" :class="'kpi-' + idx" hover-class="kpi-hover" @tap="onKpiTap(kpi)">
          <view class="kpi-glow"></view>
          <view class="kpi-icon-wrap">
            <text class="kpi-icon">{{ kpi.icon }}</text>
          </view>
          <view class="kpi-body">
            <text class="kpi-value">{{ kpi.value }}</text>
            <text class="kpi-label">{{ kpi.label }}</text>
          </view>
          <view class="kpi-trend" :class="kpi.trendUp ? 'trend-up' : 'trend-down'">
            <text class="trend-arrow">{{ kpi.trendUp ? '▲' : '▼' }}</text>
            <text class="trend-num">{{ kpi.trend }}</text>
          </view>
        </view>
      </view>

      <!-- 营收趋势图 -->
      <view class="chart-section">
        <view class="section-title">
          <view class="title-line"></view>
          <text class="title-text">营收趋势</text>
          <text class="title-tip">单位：元</text>
        </view>
        <view class="bar-chart">
          <view class="chart-y-axis">
            <text class="y-label" v-for="lbl in yLabels" :key="lbl">{{ lbl }}</text>
          </view>
          <view class="chart-body">
            <view class="chart-grid">
              <view class="grid-line" v-for="i in 5" :key="i"></view>
            </view>
            <view class="bar-group">
              <view class="bar-item" v-for="(item, idx) in revenueTrend" :key="idx">
                <view class="bar-wrap">
                  <view class="bar-fill" :style="{ height: item.percent + '%' }">
                    <view class="bar-shine"></view>
                  </view>
                </view>
                <text class="bar-label">{{ item.label }}</text>
                <text class="bar-val">¥{{ item.value }}</text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <!-- 充电量趋势 -->
      <view class="chart-section">
        <view class="section-title">
          <view class="title-line line-green"></view>
          <text class="title-text">充电量趋势</text>
          <text class="title-tip">单位：kWh</text>
        </view>
        <view class="line-chart">
          <view class="chart-y-axis">
            <text class="y-label" v-for="lbl in energyYLabels" :key="lbl">{{ lbl }}</text>
          </view>
          <view class="chart-body">
            <view class="chart-grid">
              <view class="grid-line" v-for="i in 5" :key="i"></view>
            </view>
            <view class="line-area">
              <svg class="line-svg" viewBox="0 0 300 160" preserveAspectRatio="none">
                <defs>
                  <linearGradient id="energyGrad" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0%" stop-color="rgba(34,197,94,0.35)"></stop>
                    <stop offset="100%" stop-color="rgba(34,197,94,0.02)"></stop>
                  </linearGradient>
                </defs>
                <polygon :points="energyAreaPoints" fill="url(#energyGrad)"></polygon>
                <polyline :points="energyLinePoints" fill="none" stroke="#22c55e" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"></polyline>
              </svg>
            </view>
            <view class="line-labels">
              <text class="line-label" v-for="(item, idx) in energyTrend" :key="idx">{{ item.label }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 站点排行 -->
      <view class="section-block">
        <view class="section-title">
          <view class="title-line line-orange"></view>
          <text class="title-text">站点营收排行</text>
          <view class="bar-more" @tap="goStationList">
            <text class="bar-more-text">全部</text>
            <text class="bar-more-icon">❯</text>
          </view>
        </view>
        <view class="rank-list">
          <view class="rank-item" v-for="(item, idx) in stationRank" :key="idx" hover-class="rank-hover" @tap="goStationDetail(item.id)">
            <view class="rank-badge" :class="'rank-' + (idx + 1)">
              <text v-if="idx < 3" class="rank-medal">{{ ['🥇','🥈','🥉'][idx] }}</text>
              <text v-else class="rank-num">{{ idx + 1 }}</text>
            </view>
            <view class="rank-info">
              <text class="rank-name">{{ item.name }}</text>
              <view class="rank-bar-wrap">
                <view class="rank-bar-fill" :style="{ width: item.percent + '%' }"></view>
              </view>
            </view>
            <view class="rank-right">
              <text class="rank-income">¥{{ item.income }}</text>
              <text class="rank-growth" :class="item.growth > 0 ? 'up' : 'down'">{{ item.growth > 0 ? '+' : '' }}{{ item.growth }}%</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 时段分布 -->
      <view class="section-block">
        <view class="section-title">
          <view class="title-line line-purple"></view>
          <text class="title-text">充电时段分布</text>
          <text class="title-tip">近7天</text>
        </view>
        <view class="time-dist">
          <view class="dist-item" v-for="(item, idx) in timeDistribution" :key="idx">
            <view class="dist-bar-container">
              <view class="dist-bar" :style="{ height: item.percent + '%' }">
                <view class="dist-bar-inner"></view>
              </view>
            </view>
            <text class="dist-label">{{ item.label }}</text>
            <text class="dist-val">{{ item.count }}次</text>
          </view>
        </view>
      </view>

      <!-- 用户分析 -->
      <view class="section-block">
        <view class="section-title">
          <view class="title-line line-blue"></view>
          <text class="title-text">用户分析</text>
        </view>
        <view class="user-stats">
          <view class="user-card" v-for="(item, idx) in userStats" :key="idx">
            <text class="user-card-val">{{ item.value }}</text>
            <text class="user-card-label">{{ item.label }}</text>
            <text class="user-card-sub">{{ item.sub }}</text>
          </view>
        </view>
      </view>

      <!-- 底部占位 -->
      <view style="height: 120rpx;"></view>
    </scroll-view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      isReady: false,
      scrollTop: 0,
      activeTab: 0,
      timeTabs: ['今日', '本周', '本月'],
      glowRows: [],
      yLabels: ['2000', '1500', '1000', '500', '0'],
      energyYLabels: ['400', '300', '200', '100', '0'],
      kpiData: [
        { icon: '¥', value: '¥1,280.00', label: '今日营收', trend: '12.5%', trendUp: true },
        { icon: '⚡', value: '256.8', label: '充电量(kWh)', trend: '8.2%', trendUp: true },
        { icon: '📋', value: '42', label: '充电订单', trend: '5.1%', trendUp: true },
        { icon: '👤', value: '38', label: '活跃用户', trend: '3.2%', trendUp: false }
      ],
      revenueTrend: [
        { label: '05-28', value: '980', percent: 53 },
        { label: '05-29', value: '1,250', percent: 68 },
        { label: '05-30', value: '1,560', percent: 85 },
        { label: '05-31', value: '1,130', percent: 62 },
        { label: '06-01', value: '1,820', percent: 100 },
        { label: '06-02', value: '1,450', percent: 79 },
        { label: '06-03', value: '1,280', percent: 70 }
      ],
      energyTrend: [
        { label: '05-28', value: 185, percent: 55 },
        { label: '05-29', value: 242, percent: 72 },
        { label: '05-30', value: 310, percent: 92 },
        { label: '05-31', value: 220, percent: 65 },
        { label: '06-01', value: 336, percent: 100 },
        { label: '06-02', value: 268, percent: 80 },
        { label: '06-03', value: 256, percent: 76 }
      ],
      stationRank: [
        { id: 1, name: '济南高新区充电站', income: '9,320', growth: 8.3, percent: 100 },
        { id: 2, name: '济南历下区旗舰站', income: '7,850', growth: 5.6, percent: 84 },
        { id: 3, name: '济南市中区超充站', income: '6,420', growth: -2.1, percent: 69 },
        { id: 4, name: '济南天桥区充电站', income: '4,980', growth: 12.8, percent: 53 },
        { id: 5, name: '济南槐荫区充电站', income: '3,650', growth: 3.4, percent: 39 }
      ],
      timeDistribution: [
        { label: '00-04', count: 28, percent: 12 },
        { label: '04-08', count: 52, percent: 22 },
        { label: '08-12', count: 145, percent: 62 },
        { label: '12-16', count: 168, percent: 72 },
        { label: '16-20', count: 235, percent: 100 },
        { label: '20-24', count: 112, percent: 48 }
      ],
      userStats: [
        { value: '186', label: '总用户数', sub: '较上月+12' },
        { value: '42%', label: '复购率', sub: '较上月+3.5%' },
        { value: '35min', label: '平均充电时长', sub: '较上月-2min' },
        { value: '¥32.5', label: '客单价', sub: '较上月+1.8' }
      ]
    }
  },
  computed: {
    energyLinePoints() {
      var pts = this.energyTrend
      var maxP = pts.length > 0 ? Math.max.apply(null, pts.map(function(p) { return p.percent })) : 100
      if (maxP === 0) maxP = 100
      var w = 300, h = 160, pad = 10
      var stepX = pts.length > 1 ? (w - pad * 2) / (pts.length - 1) : 0
      return pts.map(function(p, i) {
        var x = pad + i * stepX
        var y = h - pad - (p.percent / maxP) * (h - pad * 2)
        return x + ',' + y
      }).join(' ')
    },
    energyAreaPoints() {
      var pts = this.energyTrend
      var maxP = pts.length > 0 ? Math.max.apply(null, pts.map(function(p) { return p.percent })) : 100
      if (maxP === 0) maxP = 100
      var w = 300, h = 160, pad = 10
      var stepX = pts.length > 1 ? (w - pad * 2) / (pts.length - 1) : 0
      var linePts = pts.map(function(p, i) {
        var x = pad + i * stepX
        var y = h - pad - (p.percent / maxP) * (h - pad * 2)
        return x + ',' + y
      }).join(' ')
      return linePts + ' ' + (w - pad) + ',' + (h - pad) + ' ' + pad + ',' + (h - pad)
    }
  },
  created() {
    this.buildGlowRows()
    var self = this
    setTimeout(function() { self.isReady = true }, 200)
  },
  methods: {
    buildGlowRows() {
      var rows = []
      var colors = ['#f59e0b', '#f97316', '#fb923c', '#fbbf24', '#fcd34d', '#fde68a']
      for (var r = 0; r < 8; r++) {
        var dots = []
        var count = 6 + Math.floor(Math.random() * 5)
        for (var c = 0; c < count; c++) {
          var color = colors[Math.floor(Math.random() * colors.length)]
          var size = 4 + Math.floor(Math.random() * 10)
          var dur = 2.5 + Math.random() * 3
          var delay = Math.random() * 2
          dots.push({
            style: 'width:' + size + 'px;height:' + size + 'px;background:' + color + ';animation-duration:' + dur + 's;animation-delay:' + delay + 's;'
          })
        }
        rows.push({ dots: dots })
      }
      this.glowRows = rows
    },
    switchTab(idx) {
      this.activeTab = idx
      this.loadTabData()
    },
    loadTabData() {
      var self = this
      if (self.activeTab === 0) {
        self.kpiData = [
          { icon: '¥', value: '¥1,280.00', label: '今日营收', trend: '12.5%', trendUp: true },
          { icon: '⚡', value: '256.8', label: '充电量(kWh)', trend: '8.2%', trendUp: true },
          { icon: '📋', value: '42', label: '充电订单', trend: '5.1%', trendUp: true },
          { icon: '👤', value: '38', label: '活跃用户', trend: '3.2%', trendUp: false }
        ]
      } else if (self.activeTab === 1) {
        self.kpiData = [
          { icon: '¥', value: '¥8,960.00', label: '本周营收', trend: '15.8%', trendUp: true },
          { icon: '⚡', value: '1,798.6', label: '充电量(kWh)', trend: '11.3%', trendUp: true },
          { icon: '📋', value: '286', label: '充电订单', trend: '7.6%', trendUp: true },
          { icon: '👤', value: '156', label: '活跃用户', trend: '2.1%', trendUp: true }
        ]
      } else {
        self.kpiData = [
          { icon: '¥', value: '¥46,690.70', label: '本月营收', trend: '22.4%', trendUp: true },
          { icon: '⚡', value: '8,524.3', label: '充电量(kWh)', trend: '18.6%', trendUp: true },
          { icon: '📋', value: '1,024', label: '充电订单', trend: '12.9%', trendUp: true },
          { icon: '👤', value: '580', label: '活跃用户', trend: '8.5%', trendUp: true }
        ]
      }
    },
    goBack() { uni.navigateBack() },
    refreshData() {
      uni.showLoading({ title: '刷新中' })
      var self = this
      setTimeout(function() {
        uni.hideLoading()
        uni.showToast({ title: '数据已更新', icon: 'success', duration: 1500 })
      }, 800)
    },
    onKpiTap(kpi) {
      uni.showToast({ title: kpi.label + '详情', icon: 'none', duration: 1500 })
    },
    goStationList() { uni.navigateTo({ url: '/pages/mine/charge-pile/station-list' }) },
    goStationDetail(id) { uni.navigateTo({ url: '/pages/mine/charge-pile/station-detail?stationId=' + id }) }
  }
}
</script>

<style scoped>
/* ========== 页面容器 ========== */
.page {
  min-height: 100vh;
  background: linear-gradient(180deg, #fff7ed 0%, #fffbeb 30%, #fefce8 60%, #fef9ef 100%);
  position: relative;
  overflow-x: hidden;
}

/* ========== 滚动区域 ========== */
.main-scroll {
  position: relative;
  z-index: 1;
  height: 100vh;
}

/* ========== 背景光晕 ========== */
.glow-matrix {
  position: fixed; top: 0; left: 0; right: 0; bottom: 0;
  pointer-events: none; z-index: 0; overflow: hidden;
  display: flex; flex-direction: column;
}
.glow-row {
  display: flex; justify-content: space-around; align-items: center;
  padding: 22rpx 12rpx; gap: 20rpx;
}
.glow-spot {
  border-radius: 50%; flex-shrink: 0;
  animation: glowPulse ease-in-out infinite;
  will-change: opacity, transform;
}
@keyframes glowPulse {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.5; transform: scale(0.9); }
}
.overlay-mask {
  position: fixed; top: 0; left: 0; right: 0; bottom: 0;
  pointer-events: none; z-index: 0;
  background: radial-gradient(ellipse at 50% 0%, rgba(255,255,255,0) 0%, rgba(255,251,235,0.3) 60%, rgba(254,249,239,0.5) 100%);
}

/* ========== 入场动画 ========== */
.page-ready .kpi-card { animation: slideUp 0.6s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; }
.page-ready .chart-section { animation: slideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; }
.page-ready .section-block { animation: slideUp 0.6s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; }
.page-ready .kpi-card:nth-child(1) { animation-delay: 0.05s; }
.page-ready .kpi-card:nth-child(2) { animation-delay: 0.12s; }
.page-ready .kpi-card:nth-child(3) { animation-delay: 0.19s; }
.page-ready .kpi-card:nth-child(4) { animation-delay: 0.26s; }
.page-ready .chart-section:nth-of-type(1) { animation-delay: 0.32s; }
.page-ready .chart-section:nth-of-type(2) { animation-delay: 0.38s; }
.page-ready .section-block:nth-of-type(1) { animation-delay: 0.44s; }
.page-ready .section-block:nth-of-type(2) { animation-delay: 0.50s; }
.page-ready .section-block:nth-of-type(3) { animation-delay: 0.56s; }

@keyframes slideUp {
  from { opacity: 0; transform: translateY(40rpx) scale(0.94); }
  to { opacity: 1; transform: translateY(0) scale(1); }
}

/* ========== 顶栏 ========== */
.header {
  position: relative; display: flex; align-items: center;
  padding: 28rpx 24rpx 20rpx; z-index: 2;
}
.header-bg {
  position: absolute; top: 0; left: 0; right: 0; bottom: 0;
  background: linear-gradient(180deg, rgba(251,146,60,0.12) 0%, rgba(255,255,255,0) 100%);
  border-radius: 0 0 40rpx 40rpx;
}
.back-btn {
  width: 64rpx; height: 64rpx; border-radius: 50%;
  background: rgba(255,255,255,0.85); display: flex;
  align-items: center; justify-content: center; z-index: 1;
  box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06);
}
.back-icon { font-size: 32rpx; color: #f97316; font-weight: bold; }
.header-info { flex: 1; margin-left: 20rpx; z-index: 1; }
.header-title { font-size: 36rpx; font-weight: 700; color: #1f2937; display: block; }
.header-sub { font-size: 22rpx; color: #9ca3af; margin-top: 4rpx; display: block; }
.header-right { z-index: 1; }
.refresh-icon {
  font-size: 36rpx; color: #f97316; width: 64rpx; height: 64rpx;
  display: flex; align-items: center; justify-content: center;
  background: rgba(255,255,255,0.85); border-radius: 50%;
  box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06);
}

/* ========== 时间切换 ========== */
.time-tabs {
  display: flex; align-items: center; justify-content: center;
  margin: 10rpx 24rpx 20rpx; background: rgba(255,255,255,0.7);
  border-radius: 36rpx; padding: 6rpx;
  backdrop-filter: blur(10px);
  box-shadow: 0 2rpx 16rpx rgba(0,0,0,0.04);
}
.tab-item {
  flex: 1; text-align: center; padding: 14rpx 0;
  font-size: 26rpx; color: #9ca3af; position: relative;
  border-radius: 30rpx; transition: all 0.3s;
}
.tab-item.active {
  color: #fff; background: linear-gradient(135deg, #f97316, #f59e0b);
  font-weight: 600; box-shadow: 0 4rpx 16rpx rgba(249,115,22,0.3);
}
.tab-indicator { display: none; }

/* ========== 核心指标 ========== */
.kpi-section {
  display: flex; flex-wrap: wrap; gap: 16rpx;
  padding: 0 24rpx; margin-bottom: 24rpx;
}
.kpi-card {
  width: calc(50% - 8rpx); background: #fff; border-radius: 20rpx;
  padding: 24rpx; position: relative; overflow: hidden;
  box-shadow: 0 2rpx 20rpx rgba(0,0,0,0.04);
  transition: transform 0.2s;
}
.kpi-hover { transform: translateY(-4rpx); }
.kpi-glow {
  position: absolute; top: -20rpx; right: -20rpx;
  width: 100rpx; height: 100rpx; border-radius: 50%;
  opacity: 0.12;
}
.kpi-0 .kpi-glow { background: #f97316; }
.kpi-1 .kpi-glow { background: #22c55e; }
.kpi-2 .kpi-glow { background: #3b82f6; }
.kpi-3 .kpi-glow { background: #8b5cf6; }
.kpi-icon-wrap {
  width: 48rpx; height: 48rpx; border-radius: 14rpx;
  display: flex; align-items: center; justify-content: center; margin-bottom: 16rpx;
}
.kpi-0 .kpi-icon-wrap { background: rgba(249,115,22,0.12); }
.kpi-1 .kpi-icon-wrap { background: rgba(34,197,94,0.12); }
.kpi-2 .kpi-icon-wrap { background: rgba(59,130,246,0.12); }
.kpi-3 .kpi-icon-wrap { background: rgba(139,92,246,0.12); }
.kpi-0 .kpi-icon { color: #f97316; }
.kpi-1 .kpi-icon { color: #22c55e; }
.kpi-2 .kpi-icon { color: #3b82f6; }
.kpi-3 .kpi-icon { color: #8b5cf6; }
.kpi-icon { font-size: 28rpx; font-weight: bold; }
.kpi-body { position: relative; z-index: 1; }
.kpi-value { font-size: 36rpx; font-weight: 700; color: #1f2937; display: block; }
.kpi-label { font-size: 22rpx; color: #9ca3af; margin-top: 4rpx; display: block; }
.kpi-trend { position: absolute; bottom: 24rpx; right: 24rpx; display: flex; align-items: center; gap: 4rpx; }
.trend-arrow { font-size: 18rpx; }
.trend-num { font-size: 22rpx; font-weight: 600; }
.trend-up { color: #22c55e; }
.trend-down { color: #ef4444; }

/* ========== 图表区块 ========== */
.chart-section {
  margin: 0 24rpx 24rpx; background: #fff; border-radius: 20rpx;
  padding: 24rpx; box-shadow: 0 2rpx 20rpx rgba(0,0,0,0.04);
}
.section-block {
  margin: 0 24rpx 24rpx; background: #fff; border-radius: 20rpx;
  padding: 24rpx; box-shadow: 0 2rpx 20rpx rgba(0,0,0,0.04);
}
.section-title {
  display: flex; align-items: center; gap: 12rpx; margin-bottom: 24rpx;
}
.title-line {
  width: 6rpx; height: 28rpx; border-radius: 3rpx;
  background: linear-gradient(180deg, #f97316, #fbbf24);
}
.title-line.line-green { background: linear-gradient(180deg, #22c55e, #86efac); }
.title-line.line-orange { background: linear-gradient(180deg, #f97316, #fb923c); }
.title-line.line-purple { background: linear-gradient(180deg, #8b5cf6, #c4b5fd); }
.title-line.line-blue { background: linear-gradient(180deg, #3b82f6, #93c5fd); }
.title-text { font-size: 28rpx; font-weight: 700; color: #1f2937; }
.title-tip { font-size: 20rpx; color: #cbd5e1; margin-left: auto; }
.bar-more { display: flex; align-items: center; gap: 4rpx; margin-left: auto; }
.bar-more-text { font-size: 22rpx; color: #f97316; }
.bar-more-icon { font-size: 22rpx; color: #f97316; }

/* ========== 柱状图 ========== */
.bar-chart { display: flex; gap: 12rpx; min-height: 320rpx; }
.chart-y-axis { display: flex; flex-direction: column; justify-content: space-between; padding: 0 0 36rpx; min-width: 60rpx; }
.y-label { font-size: 18rpx; color: #cbd5e1; text-align: right; }
.chart-body { flex: 1; position: relative; }
.chart-grid { position: absolute; top: 0; left: 0; right: 0; bottom: 36rpx; display: flex; flex-direction: column; justify-content: space-between; }
.grid-line { height: 1rpx; background: #f3f4f6; }
.bar-group { display: flex; align-items: flex-end; justify-content: space-around; height: 100%; padding-bottom: 36rpx; position: relative; z-index: 1; }
.bar-item { display: flex; flex-direction: column; align-items: center; gap: 8rpx; }
.bar-wrap { width: 40rpx; height: 220rpx; background: #f9fafb; border-radius: 8rpx 8rpx 0 0; display: flex; align-items: flex-end; overflow: hidden; }
.bar-fill {
  width: 100%; border-radius: 8rpx 8rpx 0 0; position: relative;
  background: linear-gradient(180deg, #f97316 0%, #fbbf24 100%);
  transition: height 0.8s cubic-bezier(0.34, 1.56, 0.64, 1);
  min-height: 4rpx;
}
.bar-shine {
  position: absolute; top: 4rpx; left: 50%; transform: translateX(-50%);
  width: 20rpx; height: 4rpx; border-radius: 2rpx;
  background: rgba(255,255,255,0.5);
}
.bar-label { font-size: 18rpx; color: #9ca3af; }
.bar-val { font-size: 16rpx; color: #f97316; font-weight: 600; }

/* ========== 折线图 ========== */
.line-chart { display: flex; gap: 12rpx; min-height: 280rpx; }
.line-area { position: absolute; top: 0; left: 0; right: 0; bottom: 36rpx; }
.line-svg { width: 100%; height: 100%; }
.line-labels { position: absolute; bottom: 0; left: 0; right: 0; display: flex; justify-content: space-around; padding: 0 8rpx; }
.line-label { font-size: 18rpx; color: #9ca3af; }

/* ========== 排行列表 ========== */
.rank-list { display: flex; flex-direction: column; gap: 16rpx; }
.rank-item {
  display: flex; align-items: center; gap: 16rpx;
  padding: 16rpx; border-radius: 16rpx; background: #fafafa;
  transition: background 0.2s;
}
.rank-hover { background: #fff7ed; }
.rank-badge {
  width: 48rpx; height: 48rpx; border-radius: 12rpx;
  display: flex; align-items: center; justify-content: center;
  font-size: 24rpx; flex-shrink: 0;
}
.rank-1 { background: #fef3c7; }
.rank-2 { background: #e5e7eb; }
.rank-3 { background: #fed7aa; }
.rank-badge:not(.rank-1):not(.rank-2):not(.rank-3) { background: #f3f4f6; }
.rank-medal { font-size: 28rpx; }
.rank-num { font-size: 24rpx; color: #9ca3af; font-weight: 700; }
.rank-info { flex: 1; min-width: 0; }
.rank-name { font-size: 26rpx; color: #1f2937; font-weight: 600; display: block; margin-bottom: 8rpx; }
.rank-bar-wrap { height: 6rpx; background: #f3f4f6; border-radius: 3rpx; overflow: hidden; }
.rank-bar-fill { height: 100%; background: linear-gradient(90deg, #f97316, #fbbf24); border-radius: 3rpx; transition: width 0.6s; }
.rank-right { text-align: right; flex-shrink: 0; }
.rank-income { font-size: 28rpx; font-weight: 700; color: #1f2937; display: block; }
.rank-growth { font-size: 20rpx; }
.rank-growth.up { color: #22c55e; }
.rank-growth.down { color: #ef4444; }

/* ========== 时段分布 ========== */
.time-dist {
  display: flex; justify-content: space-around; align-items: flex-end;
  height: 240rpx; gap: 12rpx;
}
.dist-item { display: flex; flex-direction: column; align-items: center; gap: 8rpx; flex: 1; }
.dist-bar-container { width: 44rpx; height: 160rpx; background: #f9fafb; border-radius: 8rpx 8rpx 0 0; display: flex; align-items: flex-end; overflow: hidden; }
.dist-bar {
  width: 100%; border-radius: 8rpx 8rpx 0 0; transition: height 0.6s;
  background: linear-gradient(180deg, #8b5cf6, #c4b5fd);
}
.dist-bar-inner { width: 100%; height: 100%; }
.dist-label { font-size: 18rpx; color: #9ca3af; }
.dist-val { font-size: 16rpx; color: #8b5cf6; font-weight: 600; }

/* ========== 用户分析 ========== */
.user-stats { display: flex; flex-wrap: wrap; gap: 16rpx; }
.user-card {
  width: calc(50% - 8rpx); background: #fafafa; border-radius: 16rpx;
  padding: 24rpx; text-align: center;
}
.user-card-val { font-size: 40rpx; font-weight: 700; color: #1f2937; display: block; }
.user-card-label { font-size: 22rpx; color: #9ca3af; display: block; margin-top: 6rpx; }
.user-card-sub { font-size: 20rpx; color: #22c55e; display: block; margin-top: 4rpx; }

/* ========== 按钮交互 ========== */
.btn-hover { opacity: 0.7; }
</style>