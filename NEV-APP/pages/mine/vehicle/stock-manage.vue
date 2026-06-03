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
          <text class="header-title">库存管理</text>
          <text class="header-sub">共 {{ totalStock }} 台在库</text>
        </view>
        <view class="header-right" @tap="goAdd">
          <view class="add-btn">
            <text class="add-icon">+</text>
          </view>
        </view>
      </view>

      <view class="overview-section">
        <view class="overview-row">
          <view class="overview-card oc-total">
            <text class="oc-num">{{ totalStock }}</text>
            <text class="oc-label">总库存</text>
          </view>
          <view class="overview-card oc-in">
            <text class="oc-num">{{ stats.inTransit }}</text>
            <text class="oc-label">在途</text>
          </view>
          <view class="overview-card oc-low">
            <text class="oc-num">{{ stats.lowStock }}</text>
            <text class="oc-label">低库存</text>
          </view>
          <view class="overview-card oc-out">
            <text class="oc-num">{{ stats.outStock }}</text>
            <text class="oc-label">缺货</text>
          </view>
        </view>
      </view>

      <view class="search-bar">
        <view class="search-input-wrap">
          <text class="search-icon">🔍</text>
          <input class="search-input" v-model="keyword" placeholder="搜索车型..." placeholder-class="ph" />
        </view>
      </view>

      <view class="filter-tabs">
        <scroll-view scroll-x class="tab-scroll" :show-scrollbar="false">
          <view class="tab-item" v-for="(tab, idx) in tabs" :key="idx" :class="{ active: activeTab === idx }" @tap="switchTab(idx)">
            <text>{{ tab }}</text>
          </view>
        </scroll-view>
      </view>

      <view class="stock-list">
        <view class="stock-card" v-for="(item, idx) in filteredStock" :key="idx" hover-class="card-hover" @tap="goDetail(item.id)">
          <view class="card-top">
            <view class="card-img">
              <text class="card-icon">🚗</text>
            </view>
            <view class="card-info">
              <text class="card-name">{{ item.name }}</text>
              <text class="card-spec">{{ item.spec }}</text>
              <text class="card-color">{{ item.color }}</text>
            </view>
            <view class="card-stock">
              <text class="stock-num" :class="'s-' + item.status">{{ item.stock }}</text>
              <text class="stock-unit">台</text>
            </view>
          </view>
          <view class="card-bar">
            <view class="bar-segment bar-available" :style="{ flex: item.stock }"></view>
            <view class="bar-segment bar-reserved" :style="{ flex: item.reserved }"></view>
          </view>
          <view class="card-bottom">
            <text class="bottom-label">可用 {{ item.stock }} | 预留 {{ item.reserved }}</text>
            <view class="stock-tag" :class="'tag-' + item.status">{{ item.statusText }}</view>
          </view>
        </view>

        <view v-if="filteredStock.length === 0" class="empty-wrap">
          <view class="empty-circle">
            <text class="empty-icon">📦</text>
          </view>
          <text class="empty-text">暂无库存数据</text>
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
      keyword: '',
      activeTab: 0,
      tabs: ['全部', '充足', '紧张', '缺货'],
      totalStock: 86,
      stats: { inTransit: 12, lowStock: 5, outStock: 3 },
      stockList: [
        { id: 1, name: '比亚迪 海豹', spec: '2025款 冠军版', color: '亚特兰蒂斯灰', stock: 15, reserved: 3, status: 'enough', statusText: '充足' },
        { id: 2, name: '特斯拉 Model 3', spec: '焕新版 长续航', color: '星空灰', stock: 8, reserved: 2, status: 'enough', statusText: '充足' },
        { id: 3, name: '蔚来 ET5', spec: '2025款 100kWh', color: '云初黄', stock: 12, reserved: 4, status: 'enough', statusText: '充足' },
        { id: 4, name: '小鹏 G6', spec: '2025款 755超长续航', color: '星云白', stock: 20, reserved: 5, status: 'enough', statusText: '充足' },
        { id: 5, name: '理想 L7', spec: '2025款 Max', color: '绿色特别版', stock: 3, reserved: 2, status: 'low', statusText: '紧张' },
        { id: 6, name: '极氪 001', spec: '2025款 YOU版', color: '极境蓝', stock: 2, reserved: 1, status: 'low', statusText: '紧张' },
        { id: 7, name: '问界 M7', spec: '2025款 四驱旗舰', color: '鎏金黑', stock: 0, reserved: 0, status: 'out', statusText: '缺货' },
        { id: 8, name: '比亚迪 汉EV', spec: '2025款 创世版', color: '玄空黑', stock: 10, reserved: 2, status: 'enough', statusText: '充足' }
      ]
    }
  },
  computed: {
    filteredStock() {
      var self = this
      var list = this.stockList.filter(function(item) {
        var matchKw = !self.keyword || item.name.indexOf(self.keyword) >= 0
        if (self.activeTab === 1) return matchKw && item.status === 'enough'
        if (self.activeTab === 2) return matchKw && item.status === 'low'
        if (self.activeTab === 3) return matchKw && item.status === 'out'
        return matchKw
      })
      return list
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
    goAdd() { uni.showToast({ title: '新增入库', icon: 'none', duration: 1500 }) },
    switchTab(idx) { this.activeTab = idx },
    goDetail(id) { uni.navigateTo({ url: '/pages/mine/vehicle/stock-detail?id=' + id }) }
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
.add-btn { width: 60rpx; height: 60rpx; border-radius: 30rpx; background: linear-gradient(135deg, #06b6d4, #0891b2); display: flex; align-items: center; justify-content: center; box-shadow: 0 4rpx 16rpx rgba(6,182,212,0.35); }
.add-icon { font-size: 32rpx; color: #fff; }

.overview-section { padding: 0 28rpx 16rpx; }
.overview-row { display: flex; gap: 12rpx; }
.overview-card { flex: 1; background: rgba(255,255,255,0.8); border-radius: 20rpx; padding: 16rpx 12rpx; text-align: center; box-shadow: 0 2rpx 16rpx rgba(0,0,0,0.04); }
.oc-total { border-top: 4rpx solid #06b6d4; }
.oc-in { border-top: 4rpx solid #10b981; }
.oc-low { border-top: 4rpx solid #f59e0b; }
.oc-out { border-top: 4rpx solid #ef4444; }
.oc-num { font-size: 32rpx; font-weight: 700; display: block; }
.oc-total .oc-num { color: #06b6d4; }
.oc-in .oc-num { color: #10b981; }
.oc-low .oc-num { color: #f59e0b; }
.oc-out .oc-num { color: #ef4444; }
.oc-label { font-size: 22rpx; color: #6b7280; margin-top: 4rpx; display: block; }

.search-bar { padding: 0 28rpx 16rpx; }
.search-input-wrap { display: flex; align-items: center; background: rgba(255,255,255,0.8); border-radius: 20rpx; padding: 14rpx 20rpx; }
.search-icon { font-size: 26rpx; margin-right: 12rpx; }
.search-input { flex: 1; font-size: 26rpx; }
.ph { color: #d1d5db; }

.filter-tabs { padding: 0 28rpx 16rpx; }
.tab-scroll { white-space: nowrap; }
.tab-item { display: inline-block; padding: 12rpx 24rpx; margin-right: 12rpx; border-radius: 30rpx; font-size: 26rpx; color: #6b7280; background: rgba(255,255,255,0.7); transition: all 0.3s; }
.tab-item.active { background: linear-gradient(135deg, #06b6d4, #0891b2); color: #fff; box-shadow: 0 4rpx 12rpx rgba(6,182,212,0.3); }

.stock-list { padding: 0 28rpx; }
.stock-card { background: rgba(255,255,255,0.8); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 24rpx; margin-bottom: 16rpx; box-shadow: 0 2rpx 16rpx rgba(0,0,0,0.04); }
.card-hover { transform: scale(0.98); }
.card-top { display: flex; align-items: center; margin-bottom: 16rpx; }
.card-img { width: 64rpx; height: 64rpx; border-radius: 16rpx; background: rgba(6,182,212,0.1); display: flex; align-items: center; justify-content: center; margin-right: 16rpx; }
.card-icon { font-size: 32rpx; }
.card-info { flex: 1; }
.card-name { font-size: 28rpx; font-weight: 600; color: #1f2937; display: block; }
.card-spec { font-size: 24rpx; color: #9ca3af; display: block; margin-top: 2rpx; }
.card-color { font-size: 22rpx; color: #0891b2; display: block; margin-top: 2rpx; }
.card-stock { text-align: right; }
.stock-num { font-size: 36rpx; font-weight: 700; display: block; }
.s-enough { color: #10b981; }
.s-low { color: #f59e0b; }
.s-out { color: #ef4444; }
.stock-unit { font-size: 22rpx; color: #9ca3af; display: block; }

.card-bar { display: flex; height: 8rpx; border-radius: 4rpx; overflow: hidden; margin-bottom: 12rpx; }
.bar-segment { height: 100%; }
.bar-available { background: #06b6d4; }
.bar-reserved { background: #e5e7eb; }

.card-bottom { display: flex; justify-content: space-between; align-items: center; }
.bottom-label { font-size: 22rpx; color: #9ca3af; }
.stock-tag { font-size: 20rpx; padding: 4rpx 14rpx; border-radius: 12rpx; }
.tag-enough { background: rgba(16,185,129,0.1); color: #059669; }
.tag-low { background: rgba(245,158,11,0.1); color: #d97706; }
.tag-out { background: rgba(239,68,68,0.1); color: #ef4444; }

.empty-wrap { display: flex; flex-direction: column; align-items: center; padding: 80rpx 0; }
.empty-circle { width: 120rpx; height: 120rpx; border-radius: 60rpx; background: rgba(255,255,255,0.6); display: flex; align-items: center; justify-content: center; margin-bottom: 20rpx; }
.empty-icon { font-size: 48rpx; }
.empty-text { font-size: 28rpx; color: #9ca3af; }

.bottom-safe { height: 40rpx; }
</style>