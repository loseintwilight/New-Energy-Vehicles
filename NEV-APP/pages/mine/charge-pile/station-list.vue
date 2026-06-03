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
          <text class="header-title">站点管理</text>
          <text class="header-sub">共 {{ stationList.length }} 个站点</text>
        </view>
        <view class="header-right" @tap="goAdd">
          <view class="add-btn">
            <text class="add-icon">+</text>
          </view>
        </view>
      </view>

      <view class="filter-tabs">
        <view class="filter-tab" v-for="(tab, idx) in filterTabs" :key="idx" :class="{ active: activeFilter === idx }" @tap="switchFilter(idx)">
          <text>{{ tab }}</text>
        </view>
      </view>

      <view class="search-bar">
        <text class="search-icon">🔍</text>
        <input class="search-input" v-model="searchKey" placeholder="搜索站点名称或地址" placeholder-class="search-placeholder" />
      </view>

      <view class="station-list">
        <view class="station-card" v-for="(item, idx) in filteredStations" :key="idx" hover-class="card-hover" @tap="goDetail(item.id)">
          <view class="station-header-row">
            <view class="station-name-row">
              <text class="station-name">{{ item.name }}</text>
              <text class="station-status" :class="'sts-' + item.statusType">{{ item.statusText }}</text>
            </view>
            <view class="station-more">
              <text class="more-dot">···</text>
            </view>
          </view>
          <view class="station-addr">
            <text class="addr-icon">📍</text>
            <text class="addr-text">{{ item.address }}</text>
          </view>
          <view class="station-data-row">
            <view class="data-item">
              <text class="data-num">{{ item.pileCount }}</text>
              <text class="data-label">充电桩</text>
            </view>
            <view class="data-item">
              <text class="data-num">{{ item.busyCount }}</text>
              <text class="data-label">使用中</text>
            </view>
            <view class="data-item">
              <text class="data-num">{{ item.todayOrders }}</text>
              <text class="data-label">今日订单</text>
            </view>
            <view class="data-item">
              <text class="data-num highlight">¥{{ item.todayRevenue }}</text>
              <text class="data-label">今日营收</text>
            </view>
          </view>
        </view>
      </view>

      <view class="empty-state" v-if="filteredStations.length === 0">
        <text class="empty-icon">🏪</text>
        <text class="empty-text">暂无站点</text>
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
      activeFilter: 0,
      searchKey: '',
      filterTabs: ['全部', '运营中', '维护中', '已关闭'],
      stationList: [
        { id: 1, name: '济南高新区充电站', address: '高新区舜华路2000号', pileCount: '12', busyCount: '8', todayOrders: '86', todayRevenue: '1,280', statusText: '运营中', statusType: 'active' },
        { id: 2, name: '济南历下区旗舰站', address: '历下区泉城路188号', pileCount: '20', busyCount: '15', todayOrders: '210', todayRevenue: '3,560', statusText: '运营中', statusType: 'active' },
        { id: 3, name: '济南市中区超充站', address: '市中区经十路66号', pileCount: '8', busyCount: '0', todayOrders: '0', todayRevenue: '0', statusText: '维护中', statusType: 'maintain' },
        { id: 4, name: '济南天桥区充电站', address: '天桥区济洛路32号', pileCount: '6', busyCount: '3', todayOrders: '28', todayRevenue: '420', statusText: '运营中', statusType: 'active' },
        { id: 5, name: '济南槐荫区快充站', address: '槐荫区经二路128号', pileCount: '10', busyCount: '6', todayOrders: '52', todayRevenue: '890', statusText: '运营中', statusType: 'active' },
        { id: 6, name: '济南历城区充电站', address: '历城区花园路77号', pileCount: '4', busyCount: '0', todayOrders: '0', todayRevenue: '0', statusText: '已关闭', statusType: 'closed' }
      ]
    }
  },
  computed: {
    filteredStations() {
      var self = this
      var list = self.stationList
      var filters = ['all', 'active', 'maintain', 'closed']
      if (self.activeFilter !== 0) {
        list = list.filter(function(v) { return v.statusType === filters[self.activeFilter] })
      }
      if (self.searchKey) {
        var key = self.searchKey.toLowerCase()
        list = list.filter(function(v) { return v.name.toLowerCase().indexOf(key) !== -1 || v.address.toLowerCase().indexOf(key) !== -1 })
      }
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
    goAdd() { uni.navigateTo({ url: '/pages/mine/charge-pile/station-add' }) },
    switchFilter(idx) { this.activeFilter = idx },
    goDetail(id) { uni.navigateTo({ url: '/pages/mine/charge-pile/station-detail?stationId=' + id }) }
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
.filter-tabs { display: flex; padding: 0 24rpx 16rpx; gap: 12rpx; }
.filter-tab { padding: 12rpx 24rpx; border-radius: 20rpx; background: rgba(255,255,255,0.8); font-size: 24rpx; color: #78716c; }
.filter-tab.active { background: linear-gradient(135deg, #f59e0b, #f97316); color: #fff; font-weight: 600; }
.search-bar { display: flex; align-items: center; margin: 0 24rpx 20rpx; background: rgba(255,255,255,0.8); border-radius: 16rpx; padding: 16rpx 20rpx; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.04); }
.search-icon { font-size: 28rpx; margin-right: 12rpx; }
.search-input { flex: 1; font-size: 26rpx; color: #1c1917; }
.search-placeholder { color: #a8a29e; }
.station-list { padding: 0 24rpx; }
.station-card { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 24rpx; margin-bottom: 16rpx; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.card-hover { transform: scale(0.98); }
.station-header-row { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12rpx; }
.station-name-row { display: flex; align-items: center; gap: 12rpx; }
.station-name { font-size: 30rpx; font-weight: 700; color: #1c1917; }
.station-status { font-size: 20rpx; padding: 4rpx 12rpx; border-radius: 10rpx; }
.sts-active { background: #dcfce7; color: #16a34a; }
.sts-maintain { background: #fef3c7; color: #b45309; }
.sts-closed { background: #fee2e2; color: #dc2626; }
.station-more { padding: 4rpx; }
.more-dot { font-size: 28rpx; color: #a8a29e; letter-spacing: 4rpx; }
.station-addr { display: flex; align-items: center; margin-bottom: 16rpx; }
.addr-icon { font-size: 22rpx; margin-right: 6rpx; }
.addr-text { font-size: 24rpx; color: #78716c; }
.station-data-row { display: flex; border-top: 1rpx solid #f5f0e8; padding-top: 16rpx; }
.data-item { flex: 1; text-align: center; }
.data-num { font-size: 28rpx; font-weight: 700; color: #1c1917; display: block; }
.data-num.highlight { color: #f59e0b; }
.data-label { font-size: 20rpx; color: #a8a29e; margin-top: 4rpx; display: block; }
.empty-state { display: flex; flex-direction: column; align-items: center; padding: 80rpx 0; }
.empty-icon { font-size: 80rpx; opacity: 0.4; }
.empty-text { font-size: 28rpx; color: #a8a29e; margin-top: 16rpx; }
</style>