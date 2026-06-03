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
          <text class="header-title">费率管理</text>
          <text class="header-sub">{{ activeCount }} 个生效中</text>
        </view>
        <view class="header-right" @tap="goAdd">
          <view class="add-btn">
            <text class="add-icon">+</text>
          </view>
        </view>
      </view>

      <view class="rate-list">
        <view class="rate-card" v-for="(item, idx) in rateList" :key="idx" hover-class="card-hover" @tap="goEdit(item.id)">
          <view class="rate-header">
            <view class="rate-name-row">
              <text class="rate-name">{{ item.name }}</text>
              <text class="rate-status" :class="'rs-' + item.statusType">{{ item.statusText }}</text>
            </view>
            <text class="rate-type-tag">{{ item.type }}</text>
          </view>
          <view class="rate-prices">
            <view class="price-block">
              <text class="price-label">尖峰</text>
              <text class="price-val">¥{{ item.peakPrice }}</text>
              <text class="price-time">{{ item.peakTime }}</text>
            </view>
            <view class="price-block">
              <text class="price-label">高峰</text>
              <text class="price-val">¥{{ item.highPrice }}</text>
              <text class="price-time">{{ item.highTime }}</text>
            </view>
            <view class="price-block">
              <text class="price-label">平段</text>
              <text class="price-val">¥{{ item.flatPrice }}</text>
              <text class="price-time">{{ item.flatTime }}</text>
            </view>
            <view class="price-block">
              <text class="price-label">低谷</text>
              <text class="price-val">¥{{ item.lowPrice }}</text>
              <text class="price-time">{{ item.lowTime }}</text>
            </view>
          </view>
          <view class="rate-footer">
            <text class="rate-desc">{{ item.description }}</text>
            <view class="rate-actions">
              <text class="rate-action" :class="{ 'action-on': item.statusType === 'active' }" @tap.stop="toggleStatus(idx)">{{ item.statusType === 'active' ? '停用' : '启用' }}</text>
              <text class="rate-action del" @tap.stop="deleteRate(idx)">删除</text>
            </view>
          </view>
        </view>
      </view>

      <view class="empty-state" v-if="rateList.length === 0">
        <text class="empty-icon">💰</text>
        <text class="empty-text">暂无费率方案</text>
        <view class="empty-btn" @tap="goAdd">
          <text>新建费率</text>
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
      rateList: [
        { id: 1, name: '标准充电费率', type: '通用', peakPrice: '1.80', peakTime: '10:00-12:00,14:00-17:00', highPrice: '1.50', highTime: '08:00-10:00,12:00-14:00,17:00-19:00', flatPrice: '1.10', flatTime: '07:00-08:00,19:00-21:00', lowPrice: '0.70', lowTime: '21:00-07:00', statusText: '生效中', statusType: 'active', description: '适用于普通快充桩的标准阶梯电价' },
        { id: 2, name: '超充专属费率', type: '超充', peakPrice: '2.20', peakTime: '10:00-12:00,14:00-17:00', highPrice: '1.80', highTime: '08:00-10:00,12:00-14:00,17:00-19:00', flatPrice: '1.30', flatTime: '07:00-08:00,19:00-21:00', lowPrice: '0.90', lowTime: '21:00-07:00', statusText: '生效中', statusType: 'active', description: '适用于250kW以上超充桩的专属费率' },
        { id: 3, name: '夜间优惠费率', type: '慢充', peakPrice: '1.50', peakTime: '10:00-12:00,14:00-17:00', highPrice: '1.20', highTime: '08:00-10:00,12:00-14:00', flatPrice: '0.90', flatTime: '07:00-08:00,17:00-21:00', lowPrice: '0.50', lowTime: '21:00-07:00', statusText: '已停用', statusType: 'inactive', description: '针对夜间充电需求设计的优惠费率方案' }
      ]
    }
  },
  computed: {
    activeCount() {
      var self = this
      return self.rateList.filter(function(r) { return r.statusType === 'active' }).length
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
    goAdd() { uni.navigateTo({ url: '/pages/mine/charge-pile/rate-edit' }) },
    goEdit(id) { uni.navigateTo({ url: '/pages/mine/charge-pile/rate-edit?rateId=' + id }) },
    toggleStatus(idx) {
      var item = this.rateList[idx]
      item.statusType = item.statusType === 'active' ? 'inactive' : 'active'
      item.statusText = item.statusType === 'active' ? '生效中' : '已停用'
      uni.showToast({ title: item.statusType === 'active' ? '已启用' : '已停用', icon: 'none', duration: 1200 })
    },
    deleteRate(idx) {
      var self = this
      uni.showModal({
        title: '确认删除',
        content: '确定要删除该费率方案吗？',
        success: function(res) {
          if (res.confirm) { self.rateList.splice(idx, 1); uni.showToast({ title: '已删除', icon: 'success' }) }
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
.add-btn { width: 64rpx; height: 64rpx; border-radius: 32rpx; background: linear-gradient(135deg, #f59e0b, #f97316); display: flex; align-items: center; justify-content: center; box-shadow: 0 4rpx 16rpx rgba(245,158,11,0.35); }
.add-icon { font-size: 36rpx; color: #fff; }
.rate-list { padding: 0 24rpx; }
.rate-card { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 24rpx; margin-bottom: 16rpx; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.card-hover { transform: scale(0.98); }
.rate-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16rpx; }
.rate-name-row { display: flex; align-items: center; gap: 12rpx; }
.rate-name { font-size: 30rpx; font-weight: 700; color: #1c1917; }
.rate-status { font-size: 20rpx; padding: 4rpx 12rpx; border-radius: 10rpx; }
.rs-active { background: #dcfce7; color: #16a34a; }
.rs-inactive { background: #fee2e2; color: #dc2626; }
.rate-type-tag { font-size: 20rpx; padding: 4rpx 14rpx; border-radius: 10rpx; background: #fef3c7; color: #92400e; }
.rate-prices { display: flex; background: #fafaf9; border-radius: 12rpx; padding: 16rpx 8rpx; margin-bottom: 16rpx; }
.price-block { flex: 1; text-align: center; border-right: 1rpx solid #e8e5e1; }
.price-block:last-child { border-right: none; }
.price-label { font-size: 20rpx; color: #a8a29e; display: block; margin-bottom: 6rpx; }
.price-val { font-size: 30rpx; font-weight: 700; color: #f59e0b; display: block; }
.price-time { font-size: 18rpx; color: #a8a29e; display: block; margin-top: 4rpx; }
.rate-footer { display: flex; justify-content: space-between; align-items: center; }
.rate-desc { font-size: 22rpx; color: #a8a29e; flex: 1; }
.rate-actions { display: flex; gap: 16rpx; }
.rate-action { font-size: 24rpx; color: #22c55e; padding: 6rpx 16rpx; border-radius: 8rpx; background: #dcfce7; }
.rate-action.action-on { color: #f59e0b; background: #fef3c7; }
.rate-action.del { color: #dc2626; background: #fee2e2; }
.empty-state { display: flex; flex-direction: column; align-items: center; padding: 100rpx 0; }
.empty-icon { font-size: 80rpx; opacity: 0.4; }
.empty-text { font-size: 28rpx; color: #a8a29e; margin-top: 16rpx; }
.empty-btn { margin-top: 24rpx; padding: 16rpx 40rpx; background: linear-gradient(135deg, #f59e0b, #f97316); border-radius: 20rpx; font-size: 26rpx; color: #fff; font-weight: 600; }
</style>