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
          <text class="header-title">库存详情</text>
          <text class="header-sub">{{ stock.name }}</text>
        </view>
        <view class="header-right" @tap="goEdit">
          <text class="edit-text">编辑</text>
        </view>
      </view>

      <view class="hero-section">
        <view class="hero-card">
          <view class="hero-img">
            <text class="hero-icon">🚗</text>
          </view>
          <view class="hero-info">
            <text class="hero-name">{{ stock.name }}</text>
            <text class="hero-spec">{{ stock.spec }}</text>
            <view class="hero-status" :class="'status-' + stock.status">
              <text>{{ stock.statusText }}</text>
            </view>
          </view>
          <view class="hero-stock">
            <text class="hero-num" :class="'s-' + stock.status">{{ stock.currentStock }}</text>
            <text class="hero-unit">台</text>
          </view>
        </view>
      </view>

      <view class="info-section">
        <view class="section-title">
          <view class="title-line"></view>
          <text class="title-text">库存信息</text>
        </view>
        <view class="info-card">
          <view class="info-row">
            <text class="info-label">当前库存</text>
            <text class="info-value">{{ stock.currentStock }} 台</text>
          </view>
          <view class="info-row">
            <text class="info-label">预留数量</text>
            <text class="info-value">{{ stock.reserved }} 台</text>
          </view>
          <view class="info-row">
            <text class="info-label">可用数量</text>
            <text class="info-value highlight">{{ stock.available }} 台</text>
          </view>
          <view class="info-row">
            <text class="info-label">在途数量</text>
            <text class="info-value">{{ stock.inTransit }} 台</text>
          </view>
          <view class="info-row">
            <text class="info-label">安全库存</text>
            <text class="info-value">{{ stock.safeStock }} 台</text>
          </view>
          <view class="info-row">
            <text class="info-label">最后更新</text>
            <text class="info-value">{{ stock.updateTime }}</text>
          </view>
        </view>
      </view>

      <view class="info-section">
        <view class="section-title">
          <view class="title-line line-green"></view>
          <text class="title-text">车辆信息</text>
        </view>
        <view class="info-card">
          <view class="info-row">
            <text class="info-label">品牌</text>
            <text class="info-value">{{ stock.brand }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">车型</text>
            <text class="info-value">{{ stock.spec }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">颜色</text>
            <text class="info-value">{{ stock.color }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">指导价</text>
            <text class="info-value">¥{{ stock.price }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">仓库位置</text>
            <text class="info-value">{{ stock.warehouse }}</text>
          </view>
        </view>
      </view>

      <view class="info-section">
        <view class="section-title">
          <view class="title-line line-blue"></view>
          <text class="title-text">出入库记录</text>
        </view>
        <view class="info-card">
          <view class="log-item" v-for="(log, idx) in stock.logs" :key="idx">
            <view class="log-left">
              <view class="log-dot" :class="'dot-' + log.type"></view>
              <view class="log-info">
                <text class="log-title">{{ log.title }}</text>
                <text class="log-time">{{ log.time }}</text>
              </view>
            </view>
            <view class="log-right">
              <text class="log-change" :class="{ in: log.type === 'in', out: log.type === 'out' }">{{ log.type === 'in' ? '+' : '-' }}{{ log.count }}</text>
            </view>
          </view>
        </view>
      </view>

      <view class="info-section">
        <view class="section-title">
          <view class="title-line line-purple"></view>
          <text class="title-text">备注</text>
        </view>
        <view class="info-card">
          <text class="remark-text">{{ stock.remark || '暂无备注' }}</text>
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
      stock: {}
    }
  },
  onLoad(options) {
    var self = this
    this.stock = {
      id: options.id || 1,
      name: '比亚迪 海豹',
      spec: '2025款 冠军版',
      brand: '比亚迪',
      color: '亚特兰蒂斯灰',
      price: '18.58万',
      warehouse: '济南高新区仓库 A区',
      currentStock: 15,
      reserved: 3,
      available: 12,
      inTransit: 5,
      safeStock: 5,
      status: 'enough',
      statusText: '充足',
      updateTime: '2025-06-01 09:30',
      remark: '热销车型，建议保持库存不低于10台。预计下周到货5台。',
      logs: [
        { type: 'in', title: '厂家到货入库', time: '2025-06-01 08:00', count: 5 },
        { type: 'out', title: '客户提车出库', time: '2025-05-31 16:30', count: 1 },
        { type: 'out', title: '客户提车出库', time: '2025-05-30 14:20', count: 1 },
        { type: 'out', title: '展厅调拨出库', time: '2025-05-29 10:00', count: 2 },
        { type: 'in', title: '厂家到货入库', time: '2025-05-28 09:00', count: 8 }
      ]
    }
    this.buildGlowRows()
    setTimeout(function() { self.isReady = true }, 200)
  },
  methods: {
    buildGlowRows() {
      var rows = []
      var colors = ['#06b6d4', '#0891b2', '#22d3ee', '#67e8f9']
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
    goEdit() { uni.showToast({ title: '编辑库存', icon: 'none', duration: 1500 }) }
  }
}
</script>

<style scoped>
.page { min-height: 100vh; background: linear-gradient(180deg, #ecfeff 0%, #f0fdfa 30%, #f0f9ff 60%, #ecfeff 100%); opacity: 0; transition: opacity 0.5s ease; }
.page-ready { opacity: 1; }
.glow-matrix { position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 0; overflow: hidden; pointer-events: none; }
.glow-row { display: flex; justify-content: space-around; padding: 20rpx 30rpx; }
.glow-spot { border-radius: 50%; filter: blur(6px); opacity: 0; animation: glowPulse ease-in-out infinite alternate; }
@keyframes glowPulse { 0% { opacity: 0; transform: scale(0.6); } 50% { opacity: 0.5; } 100% { opacity: 0; transform: scale(1.4); } }
.overlay-mask { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: linear-gradient(180deg, rgba(236,254,255,0.35) 0%, rgba(240,253,250,0.45) 38%, rgba(240,249,255,0.55) 66%, rgba(236,254,255,0.65) 100%); z-index: 1; pointer-events: none; }
.main-scroll { position: relative; z-index: 2; }

.header { position: relative; padding: 30rpx 28rpx 24rpx; display: flex; align-items: center; }
.header-bg { position: absolute; top: -60rpx; left: -40rpx; right: -40rpx; bottom: 0; background: radial-gradient(ellipse at 20% 30%, rgba(6,182,212,0.1) 0%, transparent 60%), radial-gradient(ellipse at 80% 50%, rgba(34,211,238,0.08) 0%, transparent 55%); border-radius: 0 0 60rpx 60rpx; }
.back-btn { width: 60rpx; height: 60rpx; border-radius: 30rpx; background: rgba(255,255,255,0.75); backdrop-filter: blur(10px); display: flex; align-items: center; justify-content: center; z-index: 1; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06); }
.back-icon { font-size: 28rpx; color: #155e75; }
.header-info { flex: 1; margin-left: 20rpx; z-index: 1; }
.header-title { font-size: 36rpx; font-weight: 700; color: #083344; display: block; }
.header-sub { font-size: 24rpx; color: #0891b2; margin-top: 4rpx; display: block; }
.header-right { z-index: 1; }
.edit-text { font-size: 28rpx; color: #0891b2; font-weight: 600; }

.hero-section { padding: 0 28rpx 16rpx; }
.hero-card { background: rgba(255,255,255,0.8); backdrop-filter: blur(10px); border-radius: 24rpx; padding: 28rpx; display: flex; align-items: center; box-shadow: 0 2rpx 20rpx rgba(0,0,0,0.04); }
.hero-img { width: 88rpx; height: 88rpx; border-radius: 20rpx; background: rgba(6,182,212,0.12); display: flex; align-items: center; justify-content: center; margin-right: 20rpx; }
.hero-icon { font-size: 44rpx; }
.hero-info { flex: 1; }
.hero-name { font-size: 32rpx; font-weight: 700; color: #1f2937; display: block; }
.hero-spec { font-size: 24rpx; color: #9ca3af; display: block; margin-top: 4rpx; }
.hero-status { display: inline-block; margin-top: 8rpx; padding: 4rpx 16rpx; border-radius: 12rpx; font-size: 22rpx; }
.status-enough { background: rgba(16,185,129,0.1); color: #059669; }
.status-low { background: rgba(245,158,11,0.1); color: #d97706; }
.status-out { background: rgba(239,68,68,0.1); color: #ef4444; }
.hero-stock { text-align: right; }
.hero-num { font-size: 48rpx; font-weight: 700; display: block; }
.s-enough { color: #10b981; }
.s-low { color: #f59e0b; }
.s-out { color: #ef4444; }
.hero-unit { font-size: 24rpx; color: #9ca3af; display: block; }

.info-section { padding: 0 28rpx 16rpx; }
.section-title { display: flex; align-items: center; margin-bottom: 16rpx; }
.title-line { width: 6rpx; height: 28rpx; background: linear-gradient(180deg, #06b6d4, #0891b2); border-radius: 3rpx; margin-right: 12rpx; }
.title-line.line-green { background: linear-gradient(180deg, #10b981, #059669); }
.title-line.line-blue { background: linear-gradient(180deg, #3b82f6, #2563eb); }
.title-line.line-purple { background: linear-gradient(180deg, #8b5cf6, #7c3aed); }
.title-text { font-size: 28rpx; font-weight: 600; color: #155e75; }
.info-card { background: rgba(255,255,255,0.8); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 8rpx 24rpx; box-shadow: 0 2rpx 16rpx rgba(0,0,0,0.04); }

.info-row { display: flex; justify-content: space-between; align-items: center; padding: 20rpx 0; border-bottom: 1rpx solid rgba(0,0,0,0.04); }
.info-row:last-child { border-bottom: none; }
.info-label { font-size: 26rpx; color: #9ca3af; }
.info-value { font-size: 26rpx; color: #1f2937; }
.info-value.highlight { color: #0891b2; font-weight: 600; }

.log-item { display: flex; justify-content: space-between; align-items: center; padding: 16rpx 0; border-bottom: 1rpx solid rgba(0,0,0,0.04); }
.log-item:last-child { border-bottom: none; }
.log-left { display: flex; align-items: center; flex: 1; }
.log-dot { width: 12rpx; height: 12rpx; border-radius: 6rpx; margin-right: 16rpx; }
.dot-in { background: #10b981; }
.dot-out { background: #f59e0b; }
.log-info { flex: 1; }
.log-title { font-size: 26rpx; color: #1f2937; display: block; }
.log-time { font-size: 22rpx; color: #9ca3af; margin-top: 4rpx; display: block; }
.log-right { }
.log-change { font-size: 28rpx; font-weight: 600; }
.log-change.in { color: #10b981; }
.log-change.out { color: #f59e0b; }

.remark-text { font-size: 26rpx; color: #6b7280; line-height: 1.6; }

.bottom-safe { height: 40rpx; }
</style>