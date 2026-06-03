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
          <text class="header-title">价格管理</text>
          <text class="header-sub">{{ vehicleCount }} 款车型</text>
        </view>
        <view class="header-right" @tap="batchUpdate">
          <view class="batch-btn">
            <text class="batch-icon">☰</text>
          </view>
        </view>
      </view>

      <view class="search-bar">
        <view class="search-input-wrap">
          <text class="search-icon">🔍</text>
          <input class="search-input" v-model="keyword" placeholder="搜索车型名称..." placeholder-class="ph" />
        </view>
        <view class="filter-btn" @tap="showFilter = !showFilter">
          <text class="filter-icon">⚙</text>
        </view>
      </view>

      <view class="filter-row" v-if="showFilter">
        <view class="filter-chip" v-for="(brand, idx) in brands" :key="idx" :class="{ active: activeBrand === brand }" @tap="activeBrand = activeBrand === brand ? '' : brand">
          <text>{{ brand }}</text>
        </view>
      </view>

      <view class="vehicle-list">
        <view class="vehicle-card" v-for="(item, idx) in filteredVehicles" :key="idx" hover-class="card-hover" @tap="goEdit(item.id)">
          <view class="card-top">
            <view class="card-img-wrap">
              <text class="card-icon">🚗</text>
            </view>
            <view class="card-info">
              <text class="card-name">{{ item.name }}</text>
              <text class="card-version">{{ item.version }}</text>
              <text class="card-stock">库存: {{ item.stock }} 台</text>
            </view>
            <view class="card-price">
              <text class="price-current">¥{{ item.price }}</text>
              <text class="price-change" :class="{ up: item.changeType === 'up', down: item.changeType === 'down' }" v-if="item.change">
                {{ item.changeType === 'up' ? '↑' : '↓' }}{{ item.change }}
              </text>
            </view>
          </view>
          <view class="card-bottom">
            <view class="price-detail" v-for="(p, pi) in item.prices" :key="pi">
              <text class="detail-label">{{ p.label }}</text>
              <text class="detail-value">{{ p.value }}</text>
            </view>
          </view>
          <view class="card-actions">
            <view class="action-btn" @tap.stop="quickAdjust(item.id, 'up')">
              <text class="action-text up">上调</text>
            </view>
            <view class="action-btn" @tap.stop="quickAdjust(item.id, 'down')">
              <text class="action-text down">下调</text>
            </view>
            <view class="action-btn" @tap.stop="goEdit(item.id)">
              <text class="action-text edit">编辑</text>
            </view>
          </view>
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
      showFilter: false,
      activeBrand: '',
      brands: ['比亚迪', '特斯拉', '蔚来', '小鹏', '理想', '极氪', '问界'],
      vehicles: [
        {
          id: 1, name: '比亚迪 海豹', version: '2025款 冠军版', stock: 15,
          price: '18.58万', change: '0.5万', changeType: 'up',
          prices: [
            { label: '指导价', value: '18.58万' },
            { label: '优惠', value: '0.3万' },
            { label: '落地价', value: '19.8万' }
          ]
        },
        {
          id: 2, name: '特斯拉 Model 3', version: '焕新版 长续航', stock: 8,
          price: '23.59万', change: '1.2万', changeType: 'down',
          prices: [
            { label: '指导价', value: '23.59万' },
            { label: '优惠', value: '0.8万' },
            { label: '落地价', value: '24.5万' }
          ]
        },
        {
          id: 3, name: '蔚来 ET5', version: '2025款 100kWh', stock: 12,
          price: '29.80万',
          prices: [
            { label: '指导价', value: '29.80万' },
            { label: '优惠', value: '0万' },
            { label: '落地价', value: '31.2万' }
          ]
        },
        {
          id: 4, name: '小鹏 G6', version: '2025款 755超长续航', stock: 20,
          price: '20.99万', change: '0.3万', changeType: 'down',
          prices: [
            { label: '指导价', value: '20.99万' },
            { label: '优惠', value: '0.5万' },
            { label: '落地价', value: '21.8万' }
          ]
        },
        {
          id: 5, name: '理想 L7', version: '2025款 Max', stock: 6,
          price: '31.98万', change: '0.8万', changeType: 'up',
          prices: [
            { label: '指导价', value: '31.98万' },
            { label: '优惠', value: '0.2万' },
            { label: '落地价', value: '33.5万' }
          ]
        },
        {
          id: 6, name: '极氪 001', version: '2025款 YOU版', stock: 10,
          price: '32.90万',
          prices: [
            { label: '指导价', value: '32.90万' },
            { label: '优惠', value: '0.5万' },
            { label: '落地价', value: '34.2万' }
          ]
        }
      ]
    }
  },
  computed: {
    vehicleCount() { return this.vehicles.length },
    filteredVehicles() {
      var self = this
      return this.vehicles.filter(function(v) {
        var matchKeyword = !self.keyword || v.name.indexOf(self.keyword) >= 0
        var matchBrand = !self.activeBrand || v.name.indexOf(self.activeBrand) >= 0
        return matchKeyword && matchBrand
      })
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
      var colors = ['#8b5cf6', '#a78bfa', '#c4b5fd', '#ddd6fe']
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
    batchUpdate() { uni.showToast({ title: '批量调价', icon: 'none', duration: 1500 }) },
    goEdit(id) { uni.showToast({ title: '编辑价格 #' + id, icon: 'none', duration: 1500 }) },
    quickAdjust(id, type) {
      var text = type === 'up' ? '上调' : '下调'
      uni.showToast({ title: text + '价格 #' + id, icon: 'none', duration: 1500 })
    }
  }
}
</script>

<style scoped>
.page { min-height: 100vh; background: linear-gradient(180deg, #f5f3ff 0%, #faf5ff 30%, #fdf4ff 60%, #f5f3ff 100%); opacity: 0; transition: opacity 0.5s ease; }
.page-ready { opacity: 1; }
.glow-matrix { position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 0; overflow: hidden; pointer-events: none; }
.glow-row { display: flex; justify-content: space-around; padding: 20rpx 30rpx; }
.glow-spot { border-radius: 50%; filter: blur(6px); opacity: 0; animation: glowPulse ease-in-out infinite alternate; }
@keyframes glowPulse { 0% { opacity: 0; transform: scale(0.6); } 50% { opacity: 0.5; } 100% { opacity: 0; transform: scale(1.4); } }
.overlay-mask { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: linear-gradient(180deg, rgba(245,243,255,0.35) 0%, rgba(250,245,255,0.45) 38%, rgba(253,244,255,0.55) 66%, rgba(245,243,255,0.65) 100%); z-index: 1; pointer-events: none; }
.main-scroll { position: relative; z-index: 2; }

.header { position: relative; padding: 30rpx 28rpx 24rpx; display: flex; align-items: center; }
.header-bg { position: absolute; top: -60rpx; left: -40rpx; right: -40rpx; bottom: 0; background: radial-gradient(ellipse at 20% 30%, rgba(139,92,246,0.1) 0%, transparent 60%), radial-gradient(ellipse at 80% 50%, rgba(167,139,250,0.08) 0%, transparent 55%); border-radius: 0 0 60rpx 60rpx; }
.back-btn { width: 60rpx; height: 60rpx; border-radius: 30rpx; background: rgba(255,255,255,0.75); backdrop-filter: blur(10px); display: flex; align-items: center; justify-content: center; z-index: 1; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06); }
.back-icon { font-size: 28rpx; color: #6d28d9; }
.header-info { flex: 1; margin-left: 20rpx; z-index: 1; }
.header-title { font-size: 36rpx; font-weight: 700; color: #2e1065; display: block; }
.header-sub { font-size: 24rpx; color: #7c3aed; margin-top: 4rpx; display: block; }
.header-right { z-index: 1; }
.batch-btn { width: 60rpx; height: 60rpx; border-radius: 30rpx; background: linear-gradient(135deg, #8b5cf6, #7c3aed); display: flex; align-items: center; justify-content: center; box-shadow: 0 4rpx 16rpx rgba(139,92,246,0.35); }
.batch-icon { font-size: 28rpx; color: #fff; }

.search-bar { display: flex; align-items: center; padding: 0 28rpx 16rpx; gap: 16rpx; }
.search-input-wrap { flex: 1; display: flex; align-items: center; background: rgba(255,255,255,0.8); border-radius: 20rpx; padding: 14rpx 20rpx; }
.search-icon { font-size: 26rpx; margin-right: 12rpx; }
.search-input { flex: 1; font-size: 26rpx; }
.ph { color: #d1d5db; }
.filter-btn { width: 72rpx; height: 72rpx; border-radius: 20rpx; background: rgba(255,255,255,0.8); display: flex; align-items: center; justify-content: center; }
.filter-icon { font-size: 28rpx; color: #7c3aed; }

.filter-row { display: flex; flex-wrap: wrap; padding: 0 28rpx 16rpx; gap: 12rpx; }
.filter-chip { padding: 10rpx 24rpx; border-radius: 20rpx; font-size: 24rpx; color: #6b7280; background: rgba(255,255,255,0.7); transition: all 0.3s; }
.filter-chip.active { background: linear-gradient(135deg, #8b5cf6, #7c3aed); color: #fff; }

.vehicle-list { padding: 0 28rpx; }
.vehicle-card { background: rgba(255,255,255,0.8); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 24rpx; margin-bottom: 16rpx; box-shadow: 0 2rpx 16rpx rgba(0,0,0,0.04); }
.card-hover { transform: scale(0.98); }
.card-top { display: flex; align-items: center; margin-bottom: 16rpx; }
.card-img-wrap { width: 72rpx; height: 72rpx; border-radius: 16rpx; background: rgba(139,92,246,0.1); display: flex; align-items: center; justify-content: center; margin-right: 16rpx; }
.card-icon { font-size: 36rpx; }
.card-info { flex: 1; }
.card-name { font-size: 28rpx; font-weight: 600; color: #1f2937; display: block; }
.card-version { font-size: 24rpx; color: #9ca3af; display: block; margin-top: 4rpx; }
.card-stock { font-size: 22rpx; color: #8b5cf6; display: block; margin-top: 2rpx; }
.card-price { text-align: right; }
.price-current { font-size: 30rpx; font-weight: 700; color: #7c3aed; display: block; }
.price-change { font-size: 22rpx; display: block; margin-top: 4rpx; }
.price-change.up { color: #ef4444; }
.price-change.down { color: #10b981; }

.card-bottom { display: flex; padding: 16rpx 0; border-top: 1rpx solid rgba(0,0,0,0.05); border-bottom: 1rpx solid rgba(0,0,0,0.05); }
.price-detail { flex: 1; text-align: center; }
.detail-label { font-size: 22rpx; color: #9ca3af; display: block; }
.detail-value { font-size: 24rpx; color: #374151; display: block; margin-top: 4rpx; }

.card-actions { display: flex; gap: 12rpx; margin-top: 16rpx; }
.action-btn { flex: 1; padding: 12rpx; border-radius: 12rpx; text-align: center; background: rgba(0,0,0,0.03); }
.action-btn:active { transform: scale(0.95); }
.action-text { font-size: 24rpx; font-weight: 500; }
.action-text.up { color: #ef4444; }
.action-text.down { color: #10b981; }
.action-text.edit { color: #7c3aed; }

.bottom-safe { height: 40rpx; }
</style>