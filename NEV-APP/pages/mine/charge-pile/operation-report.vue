<template>
  <view class="page" :class="{ 'page-ready': isReady }">
    <view class="glow-matrix">
      <view class="glow-row" v-for="(row, ri) in glowRows" :key="ri">
        <view class="glow-spot" v-for="(dot, ci) in row.dots" :key="ci" :style="dot.style"></view>
      </view>
    </view>
    <view class="overlay-mask"></view>

    <scroll-view scroll-y class="main-scroll" :show-scrollbar="false">
      <view class="header">
        <view class="header-bg"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">❮</text>
        </view>
        <view class="header-info">
          <text class="header-title">运营报告</text>
          <text class="header-date">{{ dateRange }}</text>
        </view>
        <view class="header-right" @tap="shareReport">
          <view class="share-btn">
            <text class="share-icon">↗</text>
          </view>
        </view>
      </view>

      <view class="date-picker-row">
        <picker class="date-btn" mode="date" :value="startDate" @change="onStartDateChange">
          <text class="date-btn-text">{{ startDate || '开始日期' }}</text>
        </picker>
        <text class="date-sep">至</text>
        <picker class="date-btn" mode="date" :value="endDate" @change="onEndDateChange">
          <text class="date-btn-text">{{ endDate || '结束日期' }}</text>
        </picker>
      </view>

      <view class="stats-section">
        <view class="stats-row">
          <view class="stat-card" v-for="(item, idx) in summaryData" :key="idx" :class="'sc-' + idx">
            <view class="stat-glow-bar"></view>
            <view class="stat-icon-wrap">
              <text class="stat-icon">{{ item.icon }}</text>
            </view>
            <text class="stat-value">{{ item.value }}</text>
            <text class="stat-label">{{ item.label }}</text>
            <text class="stat-trend" :class="{ up: item.trendUp, down: !item.trendUp }">{{ item.trend }}</text>
          </view>
        </view>
      </view>

      <view class="section-block">
        <view class="title-bar">
          <view class="bar-line line-green"></view>
          <text class="bar-title">站点排行 TOP5</text>
        </view>
        <view class="rank-list">
          <view class="rank-item" v-for="(item, idx) in stationRank" :key="idx">
            <view class="rank-num" :class="'rank-' + (idx + 1)">{{ idx + 1 }}</view>
            <view class="rank-info">
              <text class="rank-name">{{ item.name }}</text>
              <view class="rank-bar-bg">
                <view class="rank-bar-fill" :style="{ width: item.percent + '%' }"></view>
              </view>
            </view>
            <view class="rank-val">
              <text class="rank-rev">¥{{ item.revenue }}</text>
              <text class="rank-orders">{{ item.orders }}单</text>
            </view>
          </view>
        </view>
      </view>

      <view class="section-block">
        <view class="title-bar">
          <view class="bar-line line-blue"></view>
          <text class="bar-title">充电桩利用率</text>
        </view>
        <view class="utilization-card">
          <view class="util-header">
            <text class="util-label">当前平均利用率</text>
            <text class="util-val">{{ utilization }}%</text>
          </view>
          <view class="util-bar-bg">
            <view class="util-bar-fill" :style="{ width: utilization + '%' }"></view>
          </view>
          <view class="util-list">
            <view class="util-item" v-for="(item, idx) in utilDetails" :key="idx">
              <text class="util-name">{{ item.name }}</text>
              <text class="util-pct" :class="item.cls">{{ item.value }}%</text>
            </view>
          </view>
        </view>
      </view>

      <view class="section-block">
        <view class="title-bar">
          <view class="bar-line line-purple"></view>
          <text class="bar-title">问题与建议</text>
        </view>
        <view class="issue-list">
          <view class="issue-item" v-for="(item, idx) in issues" :key="idx" :class="'issue-' + item.level">
            <view class="issue-dot"></view>
            <view class="issue-body">
              <view class="issue-title-row">
                <text class="issue-tag" :class="'tag-' + item.level">{{ item.tag }}</text>
                <text class="issue-title">{{ item.title }}</text>
              </view>
              <text class="issue-desc">{{ item.desc }}</text>
            </view>
          </view>
        </view>
      </view>

      <view style="height: 120rpx;"></view>
    </scroll-view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      isReady: false,
      glowRows: [],
      startDate: '2025-05-26',
      endDate: '2025-06-02',
      summaryData: [
        { icon: '¥', value: '89,250', label: '总营收', trend: '+12.5%', trendUp: true },
        { icon: '⚡', value: '32,680', label: '总充电量(kWh)', trend: '+8.3%', trendUp: true },
        { icon: '📋', value: '8,760', label: '总订单数', trend: '+15.2%', trendUp: true },
        { icon: '👤', value: '4,520', label: '服务用户数', trend: '+10.1%', trendUp: true }
      ],
      stationRank: [
        { name: '济南历下区旗舰站', revenue: '28,560', orders: '1,680', percent: 100 },
        { name: '济南高新区充电站', revenue: '21,340', orders: '1,245', percent: 75 },
        { name: '济南槐荫区快充站', revenue: '15,890', orders: '986', percent: 56 },
        { name: '济南天桥区充电站', revenue: '12,450', orders: '732', percent: 44 },
        { name: '济南市中区超充站', revenue: '11,010', orders: '688', percent: 39 }
      ],
      utilization: '68.5',
      utilDetails: [
        { name: '快充桩', value: '72.3', cls: 'good' },
        { name: '超充桩', value: '81.6', cls: 'great' },
        { name: '慢充桩', value: '45.2', cls: 'warn' },
        { name: '整体平均', value: '68.5', cls: 'good' }
      ],
      issues: [
        { level: 'warn', tag: '优化', title: '市中区超充站利用率偏低', desc: '该站点本月平均利用率仅32%，建议迁移部分充电桩至需求更大的区域。' },
        { level: 'info', tag: '建议', title: '槐荫区可增加快充桩', desc: '该区域订单量持续增长，现有充电桩供不应求，建议新增2-4台快充桩。' },
        { level: 'error', tag: '故障', title: '天桥区4号充电桩频繁离线', desc: '近7天内离线3次，累计离线时长12小时，建议安排技术人员检修。' },
        { level: 'info', tag: '趋势', title: '夜间充电需求增长明显', desc: '22:00-06:00时段充电量环比增长22%，可考虑推出更优惠的夜间充电方案。' }
      ]
    }
  },
  computed: {
    dateRange() {
      return (this.startDate || '开始') + ' ~ ' + (this.endDate || '结束')
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
      var colors = ['#f59e0b', '#f97316', '#fb923c', '#fbbf24']
      for (var r = 0; r < 5; r++) {
        var dots = []
        var count = 3 + Math.floor(Math.random() * 4)
        for (var c = 0; c < count; c++) {
          var color = colors[Math.floor(Math.random() * colors.length)]
          dots.push({ style: 'width:' + (3 + Math.floor(Math.random() * 6)) + 'px;height:' + (3 + Math.floor(Math.random() * 6)) + 'px;background:' + color + ';animation-duration:' + (2 + Math.random() * 3) + 's;animation-delay:' + Math.random() * 2 + 's;' })
        }
        rows.push({ dots: dots })
      }
      this.glowRows = rows
    },
    goBack() { uni.navigateBack() },
    shareReport() { uni.showToast({ title: '分享报告', icon: 'none', duration: 1500 }) },
    onStartDateChange(e) { this.startDate = e.detail.value },
    onEndDateChange(e) { this.endDate = e.detail.value }
  }
}
</script>

<style scoped>
.page { min-height: 100vh; background: linear-gradient(180deg, #fff7ed 0%, #fffbeb 30%, #fefce8 60%, #fff7ed 100%); opacity: 0; transition: opacity 0.5s ease; }
.page-ready { opacity: 1; }
.glow-matrix { position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 0; overflow: hidden; pointer-events: none; }
.glow-row { display: flex; justify-content: space-around; padding: 20rpx 30rpx; }
.glow-spot { border-radius: 50%; filter: blur(6px); opacity: 0; animation: glowPulse ease-in-out infinite alternate; }
@keyframes glowPulse {
  0% { opacity: 0; transform: scale(0.6); }
  50% { opacity: 0.5; }
  100% { opacity: 0; transform: scale(1.4); }
}
.overlay-mask { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: linear-gradient(180deg, rgba(255,247,237,0.3) 0%, rgba(255,251,235,0.43) 38%, rgba(254,252,232,0.55) 66%, rgba(255,247,237,0.63) 100%); z-index: 1; pointer-events: none; }
.main-scroll { position: relative; z-index: 2; }
.header { position: relative; padding: 30rpx 28rpx 24rpx; display: flex; align-items: center; }
.header-bg { position: absolute; top: -60rpx; left: -40rpx; right: -40rpx; bottom: 0; background: radial-gradient(ellipse at 20% 30%, rgba(251,146,60,0.12) 0%, transparent 60%), radial-gradient(ellipse at 80% 50%, rgba(250,204,21,0.1) 0%, transparent 55%); border-radius: 0 0 60rpx 60rpx; }
.back-btn { width: 60rpx; height: 60rpx; border-radius: 30rpx; background: rgba(255,255,255,0.75); backdrop-filter: blur(10px); display: flex; align-items: center; justify-content: center; z-index: 1; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06); }
.back-icon { font-size: 28rpx; color: #92400e; }
.btn-hover { opacity: 0.7; transform: scale(0.95); }
.header-info { flex: 1; margin-left: 20rpx; z-index: 1; }
.header-title { font-size: 36rpx; font-weight: 700; color: #451a03; display: block; }
.header-date { font-size: 24rpx; color: #a16207; margin-top: 4rpx; display: block; }
.header-right { z-index: 1; }
.share-btn { width: 64rpx; height: 64rpx; border-radius: 32rpx; background: rgba(255,255,255,0.75); backdrop-filter: blur(10px); display: flex; align-items: center; justify-content: center; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06); }
.share-icon { font-size: 28rpx; color: #92400e; }
.date-picker-row { display: flex; align-items: center; justify-content: center; padding: 0 24rpx 20rpx; gap: 12rpx; }
.date-btn { padding: 14rpx 24rpx; background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 16rpx; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.04); }
.date-btn-text { font-size: 26rpx; color: #1c1917; }
.date-sep { font-size: 24rpx; color: #a8a29e; }
.stats-section { padding: 0 24rpx 20rpx; }
.stats-row { display: flex; gap: 12rpx; }
.stat-card { flex: 1; background: rgba(255,255,255,0.85); backdrop-filter: blur(12px); border-radius: 20rpx; padding: 20rpx 12rpx; position: relative; overflow: hidden; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); display: flex; flex-direction: column; align-items: center; }
.stat-glow-bar { position: absolute; top: 0; left: 20%; right: 20%; height: 3rpx; border-radius: 0 0 3rpx 3rpx; }
.sc-0 .stat-glow-bar { background: #f59e0b; }
.sc-1 .stat-glow-bar { background: #22c55e; }
.sc-2 .stat-glow-bar { background: #3b82f6; }
.sc-3 .stat-glow-bar { background: #a855f7; }
.stat-icon-wrap { width: 44rpx; height: 44rpx; border-radius: 22rpx; display: flex; align-items: center; justify-content: center; margin-bottom: 8rpx; }
.sc-0 .stat-icon-wrap { background: #fef3c7; }
.sc-1 .stat-icon-wrap { background: #dcfce7; }
.sc-2 .stat-icon-wrap { background: #dbeafe; }
.sc-3 .stat-icon-wrap { background: #f3e8ff; }
.stat-icon { font-size: 24rpx; }
.stat-value { font-size: 28rpx; font-weight: 700; color: #1c1917; }
.stat-label { font-size: 20rpx; color: #78716c; margin-top: 4rpx; }
.stat-trend { font-size: 18rpx; margin-top: 4rpx; padding: 2rpx 8rpx; border-radius: 6rpx; }
.stat-trend.up { color: #16a34a; background: #dcfce7; }
.stat-trend.down { color: #dc2626; background: #fee2e2; }
.section-block { margin: 0 24rpx 20rpx; }
.title-bar { display: flex; align-items: center; margin-bottom: 16rpx; }
.bar-line { width: 6rpx; height: 32rpx; border-radius: 3rpx; background: linear-gradient(180deg, #f59e0b, #f97316); margin-right: 12rpx; }
.bar-line.line-green { background: linear-gradient(180deg, #22c55e, #16a34a); }
.bar-line.line-blue { background: linear-gradient(180deg, #3b82f6, #2563eb); }
.bar-line.line-purple { background: linear-gradient(180deg, #a855f7, #7c3aed); }
.bar-title { font-size: 30rpx; font-weight: 700; color: #1c1917; }
.rank-list { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 20rpx 24rpx; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.rank-item { display: flex; align-items: center; padding: 14rpx 0; border-bottom: 1rpx solid #f5f0e8; }
.rank-item:last-child { border-bottom: none; }
.rank-num { width: 40rpx; height: 40rpx; border-radius: 20rpx; display: flex; align-items: center; justify-content: center; font-size: 24rpx; font-weight: 700; margin-right: 16rpx; color: #78716c; background: #f5f0e8; }
.rank-1 { background: linear-gradient(135deg, #f59e0b, #f97316); color: #fff; }
.rank-2 { background: linear-gradient(135deg, #a8a29e, #78716c); color: #fff; }
.rank-3 { background: linear-gradient(135deg, #d97706, #b45309); color: #fff; }
.rank-info { flex: 1; }
.rank-name { font-size: 26rpx; font-weight: 600; color: #1c1917; display: block; margin-bottom: 8rpx; }
.rank-bar-bg { height: 8rpx; background: #f5f0e8; border-radius: 4rpx; overflow: hidden; }
.rank-bar-fill { height: 100%; background: linear-gradient(90deg, #f59e0b, #f97316); border-radius: 4rpx; }
.rank-val { text-align: right; margin-left: 16rpx; }
.rank-rev { font-size: 26rpx; font-weight: 700; color: #f59e0b; display: block; }
.rank-orders { font-size: 20rpx; color: #a8a29e; margin-top: 2rpx; display: block; }
.utilization-card { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 24rpx; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.util-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16rpx; }
.util-label { font-size: 26rpx; color: #78716c; }
.util-val { font-size: 40rpx; font-weight: 700; color: #f59e0b; }
.util-bar-bg { height: 16rpx; background: #f5f0e8; border-radius: 8rpx; overflow: hidden; margin-bottom: 20rpx; }
.util-bar-fill { height: 100%; background: linear-gradient(90deg, #22c55e, #16a34a); border-radius: 8rpx; transition: width 1s ease; }
.util-list { display: flex; }
.util-item { flex: 1; text-align: center; }
.util-name { font-size: 22rpx; color: #78716c; display: block; margin-bottom: 6rpx; }
.util-pct { font-size: 28rpx; font-weight: 700; }
.util-pct.great { color: #16a34a; }
.util-pct.good { color: #22c55e; }
.util-pct.warn { color: #f59e0b; }
.issue-list { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 20rpx 24rpx; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.issue-item { display: flex; padding: 16rpx 0; border-bottom: 1rpx solid #f5f0e8; }
.issue-item:last-child { border-bottom: none; }
.issue-dot { width: 12rpx; height: 12rpx; border-radius: 6rpx; margin-top: 8rpx; margin-right: 16rpx; flex-shrink: 0; }
.issue-warn .issue-dot { background: #f59e0b; }
.issue-info .issue-dot { background: #3b82f6; }
.issue-error .issue-dot { background: #dc2626; }
.issue-body { flex: 1; }
.issue-title-row { display: flex; align-items: center; gap: 8rpx; margin-bottom: 6rpx; }
.issue-tag { font-size: 20rpx; padding: 2rpx 10rpx; border-radius: 6rpx; }
.tag-warn { background: #fef3c7; color: #b45309; }
.tag-info { background: #dbeafe; color: #2563eb; }
.tag-error { background: #fee2e2; color: #dc2626; }
.issue-title { font-size: 26rpx; font-weight: 600; color: #1c1917; }
.issue-desc { font-size: 22rpx; color: #78716c; line-height: 1.5; display: block; }
</style>