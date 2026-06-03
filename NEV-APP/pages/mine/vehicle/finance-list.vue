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
          <text class="header-title">财务管理</text>
          <text class="header-sub">{{ monthLabel }} 账期</text>
        </view>
        <view class="header-right" @tap="goAdd">
          <view class="add-btn">
            <text class="add-icon">+</text>
          </view>
        </view>
      </view>

      <view class="summary-section">
        <view class="summary-card">
          <view class="summary-left">
            <text class="summary-label">本月收入</text>
            <text class="summary-value">¥ {{ summary.income }}</text>
            <text class="summary-trend up">↑ {{ summary.incomeTrend }}</text>
          </view>
          <view class="summary-right">
            <text class="summary-label">本月支出</text>
            <text class="summary-value out">¥ {{ summary.expense }}</text>
            <text class="summary-trend down">↓ {{ summary.expenseTrend }}</text>
          </view>
        </view>
        <view class="profit-row">
          <text class="profit-label">净利润</text>
          <text class="profit-value">¥ {{ summary.profit }}</text>
        </view>
      </view>

      <view class="month-picker">
        <view class="month-arrow" @tap="prevMonth">❮</view>
        <text class="month-text">{{ monthLabel }}</text>
        <view class="month-arrow" @tap="nextMonth">❯</view>
      </view>

      <view class="filter-tabs">
        <view class="tab-item" v-for="(tab, idx) in tabs" :key="idx" :class="{ active: activeTab === idx }" @tap="switchTab(idx)">
          <text>{{ tab }}</text>
        </view>
      </view>

      <view class="record-list">
        <view class="record-card" v-for="(item, idx) in filteredRecords" :key="idx" hover-class="card-hover" @tap="goDetail(item.id)">
          <view class="record-left">
            <view class="record-type-icon" :class="'type-' + item.type">
              <text>{{ item.type === 'income' ? '↑' : '↓' }}</text>
            </view>
          </view>
          <view class="record-center">
            <text class="record-title">{{ item.title }}</text>
            <text class="record-desc">{{ item.category }} | {{ item.date }}</text>
          </view>
          <view class="record-right">
            <text class="record-amount" :class="{ income: item.type === 'income', expense: item.type === 'expense' }">{{ item.type === 'income' ? '+' : '-' }}¥{{ item.amount }}</text>
            <text class="record-status">{{ item.status }}</text>
          </view>
        </view>

        <view v-if="filteredRecords.length === 0" class="empty-wrap">
          <view class="empty-circle">
            <text class="empty-icon">💰</text>
          </view>
          <text class="empty-text">暂无财务记录</text>
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
      activeTab: 0,
      tabs: ['全部', '收入', '支出'],
      currentMonth: 5,
      currentYear: 2025,
      summary: { income: '386,500', incomeTrend: '12.5%', expense: '152,800', expenseTrend: '5.2%', profit: '233,700' },
      records: [
        { id: 1, type: 'income', title: '比亚迪 海豹 销售款', category: '整车销售', amount: '185,800', date: '2025-06-01', status: '已到账' },
        { id: 2, type: 'income', title: '特斯拉 Model 3 定金', category: '定金收入', amount: '20,000', date: '2025-06-01', status: '已到账' },
        { id: 3, type: 'expense', title: '5月展厅租金', category: '场地成本', amount: '28,500', date: '2025-05-30', status: '已支付' },
        { id: 4, type: 'expense', title: '充电桩采购款', category: '设备采购', amount: '45,000', date: '2025-05-28', status: '已支付' },
        { id: 5, type: 'income', title: '蔚来 ET5 全款', category: '整车销售', amount: '298,000', date: '2025-05-26', status: '已到账' },
        { id: 6, type: 'expense', title: '员工5月工资', category: '人力成本', amount: '68,500', date: '2025-05-25', status: '已支付' },
        { id: 7, type: 'income', title: '充电服务费结算', category: '服务收入', amount: '36,800', date: '2025-05-20', status: '已到账' },
        { id: 8, type: 'expense', title: '广告投放费用', category: '营销支出', amount: '12,000', date: '2025-05-18', status: '已支付' }
      ]
    }
  },
  computed: {
    monthLabel() {
      return this.currentYear + '年' + this.currentMonth + '月'
    },
    filteredRecords() {
      if (this.activeTab === 0) return this.records
      var type = this.activeTab === 1 ? 'income' : 'expense'
      var self = this
      return this.records.filter(function(r) { return r.type === type })
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
      var colors = ['#10b981', '#059669', '#34d399', '#6ee7b7']
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
    goAdd() { uni.navigateTo({ url: '/pages/mine/vehicle/finance-edit' }) },
    goDetail(id) { uni.showToast({ title: '记录详情 #' + id, icon: 'none', duration: 1500 }) },
    switchTab(idx) { this.activeTab = idx },
    prevMonth() { if (this.currentMonth === 1) { this.currentMonth = 12; this.currentYear-- } else { this.currentMonth-- } },
    nextMonth() { if (this.currentMonth === 12) { this.currentMonth = 1; this.currentYear++ } else { this.currentMonth++ } }
  }
}
</script>

<style scoped>
.page { min-height: 100vh; background: linear-gradient(180deg, #ecfdf5 0%, #f0fdf4 30%, #faf5ff 60%, #ecfdf5 100%); opacity: 0; transition: opacity 0.5s ease; }
.page-ready { opacity: 1; }
.glow-matrix { position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 0; overflow: hidden; pointer-events: none; }
.glow-row { display: flex; justify-content: space-around; padding: 20rpx 30rpx; }
.glow-spot { border-radius: 50%; filter: blur(6px); opacity: 0; animation: glowPulse ease-in-out infinite alternate; }
@keyframes glowPulse { 0% { opacity: 0; transform: scale(0.6); } 50% { opacity: 0.5; } 100% { opacity: 0; transform: scale(1.4); } }
.overlay-mask { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: linear-gradient(180deg, rgba(236,253,245,0.35) 0%, rgba(240,253,244,0.45) 38%, rgba(250,245,255,0.55) 66%, rgba(236,253,245,0.65) 100%); z-index: 1; pointer-events: none; }
.main-scroll { position: relative; z-index: 2; }

.header { position: relative; padding: 30rpx 28rpx 24rpx; display: flex; align-items: center; }
.header-bg { position: absolute; top: -60rpx; left: -40rpx; right: -40rpx; bottom: 0; background: radial-gradient(ellipse at 20% 30%, rgba(16,185,129,0.1) 0%, transparent 60%), radial-gradient(ellipse at 80% 50%, rgba(52,211,153,0.08) 0%, transparent 55%); border-radius: 0 0 60rpx 60rpx; }
.back-btn { width: 60rpx; height: 60rpx; border-radius: 30rpx; background: rgba(255,255,255,0.75); backdrop-filter: blur(10px); display: flex; align-items: center; justify-content: center; z-index: 1; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06); }
.back-icon { font-size: 28rpx; color: #065f46; }
.header-info { flex: 1; margin-left: 20rpx; z-index: 1; }
.header-title { font-size: 36rpx; font-weight: 700; color: #022c22; display: block; }
.header-sub { font-size: 24rpx; color: #059669; margin-top: 4rpx; display: block; }
.header-right { z-index: 1; }
.add-btn { width: 60rpx; height: 60rpx; border-radius: 30rpx; background: linear-gradient(135deg, #10b981, #059669); display: flex; align-items: center; justify-content: center; box-shadow: 0 4rpx 16rpx rgba(16,185,129,0.35); }
.add-icon { font-size: 32rpx; color: #fff; }

.summary-section { padding: 0 28rpx 20rpx; }
.summary-card { background: rgba(255,255,255,0.8); backdrop-filter: blur(10px); border-radius: 24rpx; padding: 28rpx; display: flex; box-shadow: 0 2rpx 20rpx rgba(0,0,0,0.04); }
.summary-left { flex: 1; }
.summary-right { flex: 1; border-left: 1rpx solid rgba(0,0,0,0.06); padding-left: 24rpx; }
.summary-label { font-size: 24rpx; color: #9ca3af; display: block; }
.summary-value { font-size: 40rpx; font-weight: 700; color: #059669; margin: 4rpx 0; display: block; }
.summary-value.out { color: #ef4444; }
.summary-trend { font-size: 22rpx; display: block; }
.summary-trend.up { color: #10b981; }
.summary-trend.down { color: #f59e0b; }
.profit-row { display: flex; justify-content: space-between; align-items: center; margin-top: 16rpx; padding: 16rpx 28rpx; background: linear-gradient(135deg, rgba(16,185,129,0.1), rgba(5,150,105,0.08)); border-radius: 16rpx; }
.profit-label { font-size: 26rpx; color: #065f46; }
.profit-value { font-size: 36rpx; font-weight: 700; color: #059669; }

.month-picker { display: flex; align-items: center; justify-content: center; padding: 0 28rpx 16rpx; }
.month-arrow { width: 56rpx; height: 56rpx; border-radius: 28rpx; background: rgba(255,255,255,0.7); display: flex; align-items: center; justify-content: center; font-size: 24rpx; color: #059669; }
.month-text { font-size: 30rpx; font-weight: 600; color: #065f46; margin: 0 32rpx; }

.filter-tabs { display: flex; padding: 0 28rpx 16rpx; gap: 12rpx; }
.tab-item { padding: 12rpx 28rpx; border-radius: 30rpx; font-size: 26rpx; color: #6b7280; background: rgba(255,255,255,0.7); transition: all 0.3s; }
.tab-item.active { background: linear-gradient(135deg, #10b981, #059669); color: #fff; box-shadow: 0 4rpx 12rpx rgba(16,185,129,0.3); }

.record-list { padding: 0 28rpx; }
.record-card { background: rgba(255,255,255,0.8); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 24rpx; margin-bottom: 16rpx; display: flex; align-items: center; box-shadow: 0 2rpx 16rpx rgba(0,0,0,0.04); }
.card-hover { transform: scale(0.98); }
.record-left { margin-right: 20rpx; }
.record-type-icon { width: 56rpx; height: 56rpx; border-radius: 16rpx; display: flex; align-items: center; justify-content: center; font-size: 28rpx; font-weight: 700; }
.type-income { background: rgba(16,185,129,0.12); color: #059669; }
.type-expense { background: rgba(239,68,68,0.12); color: #ef4444; }
.record-center { flex: 1; }
.record-title { font-size: 28rpx; font-weight: 500; color: #1f2937; display: block; }
.record-desc { font-size: 24rpx; color: #9ca3af; margin-top: 4rpx; display: block; }
.record-right { text-align: right; }
.record-amount { font-size: 28rpx; font-weight: 600; display: block; }
.record-amount.income { color: #059669; }
.record-amount.expense { color: #ef4444; }
.record-status { font-size: 22rpx; color: #9ca3af; margin-top: 4rpx; display: block; }

.empty-wrap { display: flex; flex-direction: column; align-items: center; padding: 80rpx 0; }
.empty-circle { width: 120rpx; height: 120rpx; border-radius: 60rpx; background: rgba(255,255,255,0.6); display: flex; align-items: center; justify-content: center; margin-bottom: 20rpx; }
.empty-icon { font-size: 48rpx; }
.empty-text { font-size: 28rpx; color: #9ca3af; }

.bottom-safe { height: 40rpx; }
</style>