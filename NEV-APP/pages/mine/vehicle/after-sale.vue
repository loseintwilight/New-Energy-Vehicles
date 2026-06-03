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
          <text class="header-title">售后管理</text>
          <text class="header-sub">共 {{ totalCount }} 个工单</text>
        </view>
        <view class="header-right" @tap="createOrder">
          <view class="add-btn">
            <text class="add-icon">+</text>
          </view>
        </view>
      </view>

      <view class="stats-section">
        <view class="stats-row">
          <view class="stat-card stat-pending" @tap="switchTab(0)">
            <text class="stat-num">{{ stats.pending }}</text>
            <text class="stat-label">待处理</text>
          </view>
          <view class="stat-card stat-processing" @tap="switchTab(1)">
            <text class="stat-num">{{ stats.processing }}</text>
            <text class="stat-label">处理中</text>
          </view>
          <view class="stat-card stat-done" @tap="switchTab(2)">
            <text class="stat-num">{{ stats.done }}</text>
            <text class="stat-label">已完成</text>
          </view>
          <view class="stat-card stat-closed" @tap="switchTab(3)">
            <text class="stat-num">{{ stats.closed }}</text>
            <text class="stat-label">已关闭</text>
          </view>
        </view>
      </view>

      <view class="filter-tabs">
        <scroll-view scroll-x class="tab-scroll" :show-scrollbar="false">
          <view class="tab-item" v-for="(tab, idx) in tabs" :key="idx" :class="{ active: activeTab === idx }" @tap="switchTab(idx)">
            <text>{{ tab }}</text>
          </view>
        </scroll-view>
      </view>

      <view class="order-list">
        <view class="order-card" v-for="(item, idx) in filteredOrders" :key="idx" hover-class="card-hover" @tap="goDetail(item.id)">
          <view class="order-header">
            <view class="order-tag" :class="'tag-' + item.statusType">{{ item.statusText }}</view>
            <text class="order-id">#{{ item.id }}</text>
          </view>
          <view class="order-body">
            <view class="order-row">
              <text class="order-label">车辆</text>
              <text class="order-value">{{ item.vehicle }}</text>
            </view>
            <view class="order-row">
              <text class="order-label">客户</text>
              <text class="order-value">{{ item.customer }}</text>
            </view>
            <view class="order-row">
              <text class="order-label">问题类型</text>
              <text class="order-value">{{ item.issueType }}</text>
            </view>
            <view class="order-row">
              <text class="order-label">创建时间</text>
              <text class="order-value">{{ item.createTime }}</text>
            </view>
          </view>
          <view class="order-footer">
            <text class="order-desc" v-if="item.desc">{{ item.desc }}</text>
            <view class="order-arrow">❯</view>
          </view>
        </view>

        <view v-if="filteredOrders.length === 0" class="empty-wrap">
          <view class="empty-circle">
            <text class="empty-icon">🔧</text>
          </view>
          <text class="empty-text">暂无工单</text>
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
      tabs: ['全部', '待处理', '处理中', '已完成', '已关闭'],
      stats: { pending: 5, processing: 12, done: 48, closed: 23 },
      orders: [
        { id: 'AS20250601001', vehicle: '比亚迪 海豹 2025款', customer: '张先生', issueType: '充电故障', statusText: '处理中', statusType: 'processing', createTime: '2025-06-01 14:30', desc: '车辆无法正常充电，仪表盘显示充电系统故障' },
        { id: 'AS20250601002', vehicle: '特斯拉 Model 3', customer: '李女士', issueType: '电池续航', statusText: '待处理', statusType: 'pending', createTime: '2025-06-01 10:15', desc: '续航里程明显下降，满电仅能行驶200km' },
        { id: 'AS20250531001', vehicle: '蔚来 ET5', customer: '王先生', issueType: '系统升级', statusText: '已完成', statusType: 'done', createTime: '2025-05-31 16:00', desc: '车机系统OTA升级失败，需要手动刷写' },
        { id: 'AS20250531002', vehicle: '小鹏 G6', customer: '赵女士', issueType: '异响排查', statusText: '已关闭', statusType: 'closed', createTime: '2025-05-31 09:20', desc: '行驶中底盘有异响，已排除故障' },
        { id: 'AS20250530001', vehicle: '理想 L7', customer: '陈先生', issueType: '空调故障', statusText: '处理中', statusType: 'processing', createTime: '2025-05-30 11:45', desc: '空调制冷效果差，出风口温度偏高' },
        { id: 'AS20250530002', vehicle: '比亚迪 汉EV', customer: '刘女士', issueType: '屏幕黑屏', statusText: '已完成', statusType: 'done', createTime: '2025-05-30 08:30', desc: '中控屏幕偶发黑屏，重启后恢复正常' },
        { id: 'AS20250529001', vehicle: '极氪 001', customer: '周先生', issueType: '刹车异响', statusText: '处理中', statusType: 'processing', createTime: '2025-05-29 15:10', desc: '低速刹车时有尖锐异响' },
        { id: 'AS20250529002', vehicle: '问界 M7', customer: '吴女士', issueType: '充电接口', statusText: '待处理', statusType: 'pending', createTime: '2025-05-29 13:00', desc: '快充接口接触不良，充电频繁中断' }
      ]
    }
  },
  computed: {
    totalCount() { return this.orders.length },
    filteredOrders() {
      if (this.activeTab === 0) return this.orders
      var map = { 1: 'pending', 2: 'processing', 3: 'done', 4: 'closed' }
      var status = map[this.activeTab]
      var self = this
      return this.orders.filter(function(o) { return o.statusType === status })
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
      var colors = ['#3b82f6', '#6366f1', '#8b5cf6', '#a78bfa']
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
    switchTab(idx) { this.activeTab = idx },
    createOrder() { uni.showToast({ title: '创建工单', icon: 'none', duration: 1500 }) },
    goDetail(id) { uni.showToast({ title: '工单详情 #' + id, icon: 'none', duration: 1500 }) }
  }
}
</script>

<style scoped>
.page { min-height: 100vh; background: linear-gradient(180deg, #eff6ff 0%, #f5f3ff 30%, #faf5ff 60%, #eff6ff 100%); opacity: 0; transition: opacity 0.5s ease; }
.page-ready { opacity: 1; }
.glow-matrix { position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 0; overflow: hidden; pointer-events: none; }
.glow-row { display: flex; justify-content: space-around; padding: 20rpx 30rpx; }
.glow-spot { border-radius: 50%; filter: blur(6px); opacity: 0; animation: glowPulse ease-in-out infinite alternate; }
@keyframes glowPulse { 0% { opacity: 0; transform: scale(0.6); } 50% { opacity: 0.5; } 100% { opacity: 0; transform: scale(1.4); } }
.overlay-mask { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: linear-gradient(180deg, rgba(239,246,255,0.35) 0%, rgba(245,243,255,0.45) 38%, rgba(250,245,255,0.55) 66%, rgba(239,246,255,0.65) 100%); z-index: 1; pointer-events: none; }
.main-scroll { position: relative; z-index: 2; }

.header { position: relative; padding: 30rpx 28rpx 24rpx; display: flex; align-items: center; }
.header-bg { position: absolute; top: -60rpx; left: -40rpx; right: -40rpx; bottom: 0; background: radial-gradient(ellipse at 20% 30%, rgba(99,102,241,0.1) 0%, transparent 60%), radial-gradient(ellipse at 80% 50%, rgba(139,92,246,0.08) 0%, transparent 55%); border-radius: 0 0 60rpx 60rpx; }
.back-btn { width: 60rpx; height: 60rpx; border-radius: 30rpx; background: rgba(255,255,255,0.75); backdrop-filter: blur(10px); display: flex; align-items: center; justify-content: center; z-index: 1; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06); }
.back-icon { font-size: 28rpx; color: #4338ca; }
.header-info { flex: 1; margin-left: 20rpx; z-index: 1; }
.header-title { font-size: 36rpx; font-weight: 700; color: #1e1b4b; display: block; }
.header-sub { font-size: 24rpx; color: #6366f1; margin-top: 4rpx; display: block; }
.header-right { z-index: 1; }
.add-btn { width: 60rpx; height: 60rpx; border-radius: 30rpx; background: linear-gradient(135deg, #6366f1, #8b5cf6); display: flex; align-items: center; justify-content: center; box-shadow: 0 4rpx 16rpx rgba(99,102,241,0.35); }
.add-icon { font-size: 32rpx; color: #fff; }

.stats-section { padding: 0 28rpx 16rpx; }
.stats-row { display: flex; gap: 12rpx; }
.stat-card { flex: 1; background: rgba(255,255,255,0.8); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 20rpx 12rpx; text-align: center; box-shadow: 0 2rpx 16rpx rgba(0,0,0,0.04); }
.stat-card:active { transform: scale(0.96); }
.stat-pending { border-top: 4rpx solid #f59e0b; }
.stat-processing { border-top: 4rpx solid #3b82f6; }
.stat-done { border-top: 4rpx solid #10b981; }
.stat-closed { border-top: 4rpx solid #6b7280; }
.stat-num { font-size: 36rpx; font-weight: 700; display: block; }
.stat-pending .stat-num { color: #f59e0b; }
.stat-processing .stat-num { color: #3b82f6; }
.stat-done .stat-num { color: #10b981; }
.stat-closed .stat-num { color: #6b7280; }
.stat-label { font-size: 22rpx; color: #6b7280; margin-top: 4rpx; display: block; }

.filter-tabs { padding: 0 28rpx 16rpx; }
.tab-scroll { white-space: nowrap; }
.tab-item { display: inline-block; padding: 12rpx 28rpx; margin-right: 12rpx; border-radius: 30rpx; font-size: 26rpx; color: #6b7280; background: rgba(255,255,255,0.7); transition: all 0.3s; }
.tab-item.active { background: linear-gradient(135deg, #6366f1, #8b5cf6); color: #fff; box-shadow: 0 4rpx 12rpx rgba(99,102,241,0.3); }

.order-list { padding: 0 28rpx; }
.order-card { background: rgba(255,255,255,0.8); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 24rpx; margin-bottom: 16rpx; box-shadow: 0 2rpx 16rpx rgba(0,0,0,0.04); }
.card-hover { transform: scale(0.98); }
.order-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16rpx; }
.order-tag { font-size: 22rpx; padding: 4rpx 16rpx; border-radius: 20rpx; }
.tag-pending { background: #fef3c7; color: #d97706; }
.tag-processing { background: #dbeafe; color: #2563eb; }
.tag-done { background: #d1fae5; color: #059669; }
.tag-closed { background: #f3f4f6; color: #6b7280; }
.order-id { font-size: 24rpx; color: #9ca3af; }
.order-body { }
.order-row { display: flex; justify-content: space-between; padding: 8rpx 0; }
.order-label { font-size: 26rpx; color: #9ca3af; }
.order-value { font-size: 26rpx; color: #1f2937; }
.order-footer { display: flex; justify-content: space-between; align-items: center; margin-top: 12rpx; padding-top: 12rpx; border-top: 1rpx solid rgba(0,0,0,0.05); }
.order-desc { font-size: 24rpx; color: #9ca3af; flex: 1; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.order-arrow { font-size: 24rpx; color: #c4b5fd; }

.empty-wrap { display: flex; flex-direction: column; align-items: center; padding: 80rpx 0; }
.empty-circle { width: 120rpx; height: 120rpx; border-radius: 60rpx; background: rgba(255,255,255,0.6); display: flex; align-items: center; justify-content: center; margin-bottom: 20rpx; }
.empty-icon { font-size: 48rpx; }
.empty-text { font-size: 28rpx; color: #9ca3af; }

.bottom-safe { height: 40rpx; }
</style>