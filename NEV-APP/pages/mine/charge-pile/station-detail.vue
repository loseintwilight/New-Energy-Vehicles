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
          <text class="header-title">站点详情</text>
          <text class="header-sub">{{ station.name }}</text>
        </view>
        <view class="header-right" @tap="goEdit">
          <text class="edit-text">编辑</text>
        </view>
      </view>

      <view class="hero-section">
        <view class="hero-bg"></view>
        <view class="hero-map">
          <text class="hero-icon">🏪</text>
          <text class="hero-addr">{{ station.address }}</text>
        </view>
        <view class="hero-badge" :class="'badge-' + station.statusType">{{ station.statusText }}</view>
      </view>

      <view class="info-section">
        <view class="section-title">
          <view class="title-line"></view>
          <text class="title-text">基本信息</text>
        </view>
        <view class="info-card">
          <view class="info-row">
            <text class="info-label">站点名称</text>
            <text class="info-value">{{ station.name }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">详细地址</text>
            <text class="info-value">{{ station.address }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">营业时间</text>
            <text class="info-value">{{ station.openTime }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">联系电话</text>
            <text class="info-value">{{ station.phone }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">停车位</text>
            <text class="info-value">{{ station.parking }} 个</text>
          </view>
        </view>
      </view>

      <view class="info-section">
        <view class="section-title">
          <view class="title-line line-green"></view>
          <text class="title-text">运营数据</text>
        </view>
        <view class="data-grid">
          <view class="data-item">
            <text class="data-val">{{ station.pileCount }}</text>
            <text class="data-label">充电桩数</text>
          </view>
          <view class="data-item">
            <text class="data-val">{{ station.busyCount }}</text>
            <text class="data-label">使用中</text>
          </view>
          <view class="data-item">
            <text class="data-val">{{ station.todayOrders }}</text>
            <text class="data-label">今日订单</text>
          </view>
          <view class="data-item">
            <text class="data-val highlight">¥{{ station.todayRevenue }}</text>
            <text class="data-label">今日营收</text>
          </view>
        </view>
      </view>

      <view class="info-section">
        <view class="section-title">
          <view class="title-line line-blue"></view>
          <text class="title-text">充电桩列表</text>
        </view>
        <view class="pile-mini-list">
          <view class="pile-mini" v-for="(pile, idx) in station.piles" :key="idx">
            <view class="pile-mini-left">
              <text class="pile-mini-name">{{ pile.name }}</text>
              <text class="pile-mini-type">{{ pile.type }}</text>
            </view>
            <view class="pile-mini-right">
              <text class="pile-mini-power">{{ pile.power }}</text>
              <text class="pile-mini-status" :class="'ps-' + pile.statusType">{{ pile.status }}</text>
            </view>
          </view>
        </view>
      </view>

      <view class="action-btns">
        <view class="action-btn btn-warn" @tap="goPileList">
          <text>管理充电桩</text>
        </view>
        <view class="action-btn btn-danger" @tap="deleteStation">
          <text>删除站点</text>
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
      station: {
        id: 1,
        name: '济南高新区充电站',
        address: '济南市高新区舜华路2000号',
        openTime: '00:00 - 24:00',
        phone: '0531-8888-6666',
        parking: '24',
        statusText: '运营中',
        statusType: 'active',
        pileCount: '12',
        busyCount: '8',
        todayOrders: '86',
        todayRevenue: '1,280',
        piles: [
          { name: '1号快充桩', type: '直流快充', power: '120kW', status: '使用中', statusType: 'busy' },
          { name: '2号快充桩', type: '直流快充', power: '120kW', status: '空闲', statusType: 'idle' },
          { name: '3号超充桩', type: '直流超充', power: '250kW', status: '使用中', statusType: 'busy' },
          { name: '4号慢充桩', type: '交流慢充', power: '7kW', status: '故障', statusType: 'error' },
          { name: '5号快充桩', type: '直流快充', power: '120kW', status: '使用中', statusType: 'busy' }
        ]
      }
    }
  },
  onLoad(options) {
    if (options.stationId) { console.log('站点ID:', options.stationId) }
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
    goEdit() { uni.navigateTo({ url: '/pages/mine/charge-pile/station-add?stationId=' + this.station.id }) },
    goPileList() { uni.navigateTo({ url: '/pages/mine/charge-pile/pile-list' }) },
    deleteStation() {
      uni.showModal({
        title: '确认删除',
        content: '确定要删除该站点吗？此操作不可撤销。',
        success: function(res) {
          if (res.confirm) {
            uni.showToast({ title: '已删除', icon: 'success' })
            setTimeout(function() { uni.navigateBack() }, 1500)
          }
        }
      })
    }
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
.header-sub { font-size: 24rpx; color: #a16207; margin-top: 4rpx; display: block; }
.header-right { z-index: 1; }
.edit-text { font-size: 28rpx; color: #f59e0b; font-weight: 600; }
.hero-section { margin: 0 24rpx 20rpx; background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 24rpx; padding: 40rpx 24rpx; position: relative; overflow: hidden; box-shadow: 0 4rpx 20rpx rgba(0,0,0,0.04); }
.hero-bg { position: absolute; top: -40rpx; right: -40rpx; width: 160rpx; height: 160rpx; border-radius: 80rpx; background: radial-gradient(circle, rgba(245,158,11,0.15) 0%, transparent 70%); }
.hero-map { display: flex; align-items: center; }
.hero-icon { font-size: 48rpx; margin-right: 16rpx; }
.hero-addr { font-size: 26rpx; color: #57534e; flex: 1; }
.hero-badge { position: absolute; top: 20rpx; right: 20rpx; font-size: 20rpx; padding: 6rpx 16rpx; border-radius: 12rpx; }
.badge-active { background: #dcfce7; color: #16a34a; }
.badge-maintain { background: #fef3c7; color: #b45309; }
.badge-closed { background: #fee2e2; color: #dc2626; }
.info-section { margin: 0 24rpx 20rpx; }
.section-title { display: flex; align-items: center; margin-bottom: 16rpx; }
.title-line { width: 6rpx; height: 32rpx; border-radius: 3rpx; background: linear-gradient(180deg, #f59e0b, #f97316); margin-right: 12rpx; }
.title-line.line-green { background: linear-gradient(180deg, #22c55e, #16a34a); }
.title-line.line-blue { background: linear-gradient(180deg, #3b82f6, #2563eb); }
.title-text { font-size: 30rpx; font-weight: 700; color: #1c1917; }
.info-card { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 24rpx; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.info-row { display: flex; justify-content: space-between; align-items: center; padding: 14rpx 0; border-bottom: 1rpx solid #f5f0e8; }
.info-row:last-child { border-bottom: none; }
.info-label { font-size: 26rpx; color: #78716c; }
.info-value { font-size: 26rpx; color: #1c1917; font-weight: 600; }
.data-grid { display: flex; background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 24rpx 12rpx; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.data-item { flex: 1; text-align: center; }
.data-val { font-size: 32rpx; font-weight: 700; color: #1c1917; display: block; }
.data-val.highlight { color: #f59e0b; }
.data-label { font-size: 22rpx; color: #a8a29e; margin-top: 6rpx; display: block; }
.pile-mini-list { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 16rpx 24rpx; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.pile-mini { display: flex; justify-content: space-between; align-items: center; padding: 18rpx 0; border-bottom: 1rpx solid #f5f0e8; }
.pile-mini:last-child { border-bottom: none; }
.pile-mini-left { flex: 1; }
.pile-mini-name { font-size: 26rpx; font-weight: 600; color: #1c1917; display: block; }
.pile-mini-type { font-size: 22rpx; color: #a8a29e; margin-top: 4rpx; display: block; }
.pile-mini-right { text-align: right; }
.pile-mini-power { font-size: 24rpx; color: #f59e0b; font-weight: 600; display: block; }
.pile-mini-status { font-size: 20rpx; padding: 2rpx 10rpx; border-radius: 8rpx; display: inline-block; margin-top: 4rpx; }
.ps-idle { background: #dcfce7; color: #16a34a; }
.ps-busy { background: #fef3c7; color: #b45309; }
.ps-error { background: #fee2e2; color: #dc2626; }
.action-btns { display: flex; gap: 16rpx; padding: 0 24rpx; }
.action-btn { flex: 1; padding: 24rpx; border-radius: 16rpx; text-align: center; font-size: 28rpx; font-weight: 600; }
.btn-warn { background: linear-gradient(135deg, #fef3c7, #fde68a); color: #92400e; }
.btn-danger { background: linear-gradient(135deg, #fee2e2, #fecaca); color: #dc2626; }
</style>