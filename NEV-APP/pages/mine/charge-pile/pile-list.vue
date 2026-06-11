<template>
  <view class="page" :class="{ 'page-ready': isReady }">
    <!-- 背景光晕矩阵（暖色琥珀系） -->
    <view class="glow-matrix">
      <view class="glow-row" v-for="(row, ri) in glowRows" :key="ri">
        <view class="glow-spot" v-for="(dot, ci) in row.dots" :key="ci" :style="dot.style"></view>
      </view>
    </view>
    <view class="overlay-mask"></view>

    <!-- 主滚动区 -->
    <scroll-view scroll-y class="main-scroll" :show-scrollbar="false">
      <!-- 顶栏：琥珀渐变 -->
      <view class="header">
        <view class="header-bg"></view>
        <view class="header-circle"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="header-info">
          <text class="header-title">{{ stationName || '充电桩管理' }}</text>
          <view class="stat-row">
            <text class="st-tag">共{{ totalCount }}桩</text>
            <text class="st-tag st-avail">空闲{{ availableCount }}</text>
            <text class="st-tag st-charging">充电中{{ chargingCount }}</text>
          </view>
        </view>
        <view class="header-right" @tap="goAdd">
          <view class="add-btn">
            <text class="add-icon">＋</text>
            <text class="add-text">新增</text>
          </view>
        </view>
      </view>

      <!-- 搜索框 -->
      <view class="search-bar">
        <text class="search-icon">🔍</text>
        <input class="search-input" v-model="searchKey" placeholder="搜索桩编号" placeholder-class="search-placeholder" @input="onSearch" />
      </view>

      <!-- 筛选区 - 充电类型 -->
      <scroll-view scroll-x class="filter-section" :show-scrollbar="false">
        <view class="filter-inner">
          <view v-for="(item, index) in typeOptions" :key="index" class="f-chip" :class="{ active: filterType === item.value }" @tap="onTypeChange(item.value)">
            <text class="fc-text">{{ item.label }}</text>
          </view>
        </view>
      </scroll-view>

      <!-- 筛选区 - 状态 -->
      <scroll-view scroll-x class="filter-section" :show-scrollbar="false">
        <view class="filter-inner">
          <view v-for="(item, index) in statusOptions" :key="index" class="f-chip" :class="{ active: filterStatus === item.value }" @tap="onStatusChange(item.value)">
            <text class="fc-text">{{ item.label }}</text>
          </view>
        </view>
      </scroll-view>

      <!-- 站点信息条（从站点详情进入时显示） -->
      <view class="station-banner" v-if="stationName">
        <view class="sb-dot"></view>
        <text class="sb-text">当前站点：<text class="sb-name">{{ stationName }}</text></text>
      </view>

      <!-- 加载状态 -->
      <view v-if="loading && filteredPiles.length === 0" class="loading-box">
        <view class="loading-spinner"></view>
        <text class="loading-text">加载中...</text>
      </view>

      <!-- 空状态 -->
      <view v-else-if="filteredPiles.length === 0 && !loading" class="empty-box">
        <view class="empty-icon-wrap">
          <text class="empty-icon">🔌</text>
        </view>
        <text class="empty-main">暂无充电桩数据</text>
        <text class="empty-sub">点击右上角新增第一个充电桩</text>
      </view>

      <!-- 充电桩卡片列表 -->
      <view class="pile-list">
        <view
          class="pile-card"
          v-for="(item, index) in filteredPiles"
          :key="item.pileId"
          hover-class="card-hover"
          :hover-stay-time="120"
          @tap="goDetail(item)"
          :style="{ animationDelay: (index * 0.06) + 's' }"
        >
          <!-- 左侧彩色状态条 -->
          <view class="pc-bar" :class="'bar-status-' + item.pileStatus"></view>
          <!-- 颜色蔓延层 -->
          <view class="pc-spread" :class="'spread-status-' + item.pileStatus"></view>
          <!-- 卡片主体 -->
          <view class="pc-body">
            <!-- 顶部：编码 + 类型 + 状态 -->
            <view class="pc-top">
              <view class="pc-left">
                <text class="pc-code">{{ item.pileCode }}</text>
                <text class="type-badge tb-dc" v-if="item.pileType === 'dc'">DC快充</text>
                <text class="type-badge tb-ac" v-else>AC慢充</text>
              </view>
              <view class="status-badge" :class="'sb-' + item.pileStatus">
                <view class="sb-dot" :class="{ 'dot-blink': item.pileStatus === '1' }"></view>
                <text class="sb-text">{{ getPileStatusLabel(item.pileStatus) }}</text>
              </view>
            </view>

            <!-- 功率大字 + 接口类型 -->
            <view class="pc-power-row">
              <view class="power-block">
                <text class="power-num" :class="item.pileType === 'dc' ? 'power-dc' : 'power-ac'">{{ item.powerKw }}</text>
                <text class="power-unit">kW</text>
              </view>
              <view class="connector-tag">
                <text class="conn-text">{{ item.connectorType }}</text>
              </view>
            </view>

            <!-- 充电中实时数据 -->
            <view v-if="item.pileStatus === '1'" class="live-data">
              <view class="live-cell">
                <text class="live-lbl">订单号</text>
                <text class="live-val">{{ shortOrderNo(item.currentOrderNo) }}</text>
              </view>
              <view class="live-divider"></view>
              <view class="live-cell">
                <text class="live-lbl">用户</text>
                <text class="live-val">{{ item.currentUserName || '--' }}</text>
              </view>
            </view>

            <!-- 底部：今日数据 -->
            <view class="pc-bottom">
              <view class="bottom-meta">
                <text class="bm-lbl">总充电量</text>
                <text class="bm-val">{{ item.energyTotal }}kWh</text>
              </view>
              <view class="bottom-meta">
                <text class="bm-lbl">排序</text>
                <text class="bm-val">#{{ item.sortOrder }}</text>
              </view>
              <view class="bottom-arrow">
                <text class="arrow-icon">›</text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <view style="height: 120rpx;"></view>
    </scroll-view>
  </view>
</template>

<script>
import { getPileList, deletePile } from '@/api/charger/pile.js'

export default {
  data: function() {
    return {
      isReady: false,
      stationId: '',
      stationName: '',
      loading: false,
      searchKey: '',
      filterType: '',
      filterStatus: '',
      totalCount: 0,
      availableCount: 0,
      chargingCount: 0,
      glowRows: [],
      typeOptions: [
        { label: '全部', value: '' },
        { label: 'DC快充', value: 'dc' },
        { label: 'AC慢充', value: 'ac' }
      ],
      /* 状态筛选（与stad_charging_pile.pile_status对齐：0=空闲 1=充电中 2=离线 3=故障） */
      statusOptions: [
        { label: '全部', value: '' },
        { label: '空闲', value: '0' },
        { label: '充电中', value: '1' },
        { label: '离线', value: '2' },
        { label: '故障', value: '3' }
      ],
      /* 充电桩数据（从接口加载） */
      pileList: []
    }
  },
  computed: {
    filteredPiles: function() {
      var self = this
      var list = self.pileList
      if (self.filterType) {
        list = list.filter(function(p) { return p.pileType === self.filterType })
      }
      if (self.filterStatus !== '' && self.filterStatus !== null) {
        list = list.filter(function(p) { return p.pileStatus === self.filterStatus })
      }
      if (self.searchKey) {
        var key = self.searchKey.toLowerCase()
        list = list.filter(function(p) { return (p.pileCode || '').toLowerCase().indexOf(key) !== -1 })
      }
      return list
    }
  },
  onLoad: function(options) {
    this.stationId = options.stationId || ''
    this.stationName = options.stationName || ''
    this.buildGlowRows()
    this.loadPiles()
    this.calcStats()
    var that = this
    setTimeout(function() { that.isReady = true }, 200)
  },
  methods: {
    /* ---------- 数据加载 ---------- */
    loadPiles: function() {
      var self = this
      self.loading = true
      getPileList({
        pileCode: self.searchKey || '',
        stationId: self.stationId || '',
        pileStatus: self.filterStatus || '',
        pageSize: 100
      }).then(function(res) {
        self.loading = false
        if (res.code === 200) {
          self.pileList = res.rows || []
          self.calcStats()
        } else {
          uni.showToast({ title: res.msg || '加载失败', icon: 'none' })
        }
      }).catch(function(err) {
        self.loading = false
        uni.showToast({ title: '网络异常', icon: 'none' })
      })
    },

    buildGlowRows: function() {
      var rows = []
      var colors = ['#f59e0b', '#f97316', '#fb923c', '#fbbf24', '#fcd34d', '#fde68a']
      for (var r = 0; r < 7; r++) {
        var dots = []
        var count = 4 + Math.floor(Math.random() * 3)
        for (var c = 0; c < count; c++) {
          var color = colors[Math.floor(Math.random() * colors.length)]
          var size = 60 + Math.floor(Math.random() * 70)
          var dur = 2.5 + Math.random() * 2.5
          var delay = Math.random() * 2.5
          var alpha = 0.08 + Math.random() * 0.18
          dots.push({
            style: 'width:' + size + 'rpx;height:' + size + 'rpx;background:radial-gradient(circle,' + color + ',' + color + '00);opacity:' + alpha.toFixed(2) + ';animation-duration:' + dur.toFixed(1) + 's;animation-delay:' + delay.toFixed(1) + 's;'
          })
        }
        rows.push({ dots: dots })
      }
      this.glowRows = rows
    },

    calcStats: function() {
      this.totalCount = this.pileList.length
      this.availableCount = 0
      this.chargingCount = 0
      for (var i = 0; i < this.pileList.length; i++) {
        if (this.pileList[i].pileStatus === '0') {
          this.availableCount++
        } else if (this.pileList[i].pileStatus === '1') {
          this.chargingCount++
        }
      }
    },

    onSearch: function() {},
    onTypeChange: function(val) { this.filterType = val },
    onStatusChange: function(val) { this.filterStatus = val; this.loadPiles() },

    shortOrderNo: function(no) {
      if (!no) return '--'
      return no.length > 12 ? no.substring(0, 9) + '...' : no
    },

    getPileStatusLabel: function(status) {
      var map = { '0': '空闲', '1': '充电中', '2': '离线', '3': '故障' }
      return map[status] || '未知'
    },

    goBack: function() {
      uni.navigateBack({ delta: 1 })
    },

    goAdd: function() {
      uni.navigateTo({ url: '/pages/mine/charge-pile/pile-add?stationId=' + (this.stationId || '') })
    },

    goDetail: function(item) {
      uni.navigateTo({ url: '/pages/mine/charge-pile/pile-detail?pileId=' + item.pileId })
    },

    doDeletePile: function(pileId, code) {
      var self = this
      uni.showModal({
        title: '确认删除',
        content: '确定要删除充电桩「' + code + '」吗？删除后不可恢复。',
        confirmColor: '#ef4444',
        success: function(res) {
          if (res.confirm) {
            deletePile(pileId).then(function(res) {
              if (res.code === 200) {
                self.pileList = self.pileList.filter(function(p) { return p.pileId !== pileId })
                self.calcStats()
                uni.showToast({ title: '已删除', icon: 'success' })
              } else {
                uni.showToast({ title: res.msg || '删除失败', icon: 'none' })
              }
            }).catch(function() {
              uni.showToast({ title: '网络异常', icon: 'none' })
            })
          }
        }
      })
    }
  }
}
</script>

<style scoped>
/* ========== 页面容器 ========== */
.page {
  min-height: 100vh;
  background: linear-gradient(180deg, #fff7ed 0%, #fffbeb 30%, #fefce8 60%, #fffbeb 100%);
  position: relative;
  overflow-x: hidden;
}

.page-ready .pile-card {
  animation: cardSlideIn 0.5s cubic-bezier(0.22, 1, 0.36, 1) both;
}

@keyframes cardSlideIn {
  from { opacity: 0; transform: translateY(36rpx) scale(0.96); }
  to { opacity: 1; transform: translateY(0) scale(1); }
}

/* ========== 背景光晕矩阵 ========== */
.glow-matrix {
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  z-index: 0;
  overflow: hidden;
  pointer-events: none;
}

.glow-row {
  display: flex;
  justify-content: space-around;
  align-items: center;
  padding: 24rpx 20rpx;
}

.glow-spot {
  border-radius: 50%;
  flex-shrink: 0;
  animation: glowPulse ease-in-out infinite alternate;
}

@keyframes glowPulse {
  0% { opacity: 0.15; transform: scale(0.85); }
  50% { opacity: 0.6; transform: scale(1.25); }
  100% { opacity: 0.15; transform: scale(0.85); }
}

.overlay-mask {
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  background: linear-gradient(180deg,
    rgba(255, 247, 237, 0.92) 0%,
    rgba(255, 251, 235, 0.95) 35%,
    rgba(254, 252, 232, 0.96) 65%,
    rgba(255, 251, 235, 0.97) 100%
  );
  pointer-events: none;
  z-index: 1;
}

.main-scroll {
  position: relative;
  z-index: 2;
  height: 100vh;
}

/* ========== 顶栏：琥珀渐变 ========== */
.header {
  position: relative;
  padding: 28rpx 28rpx 24rpx;
  display: flex;
  align-items: center;
  overflow: hidden;
}

.header-bg {
  position: absolute;
  top: -80rpx; left: -40rpx; right: -40rpx; bottom: -20rpx;
  background: linear-gradient(135deg, #f59e0b 0%, #f97316 35%, #fb923c 65%, #fdba74 100%);
  border-radius: 0 0 60rpx 60rpx;
}

.header-circle {
  position: absolute;
  top: -50rpx; right: -30rpx;
  width: 300rpx; height: 300rpx;
  border-radius: 50%;
  background: radial-gradient(circle, rgba(255, 255, 255, 0.15) 0%, transparent 70%);
  pointer-events: none;
}

.back-btn {
  width: 64rpx; height: 64rpx;
  border-radius: 32rpx;
  background: rgba(255, 255, 255, 0.3);
  backdrop-filter: blur(12px);
  display: flex; align-items: center; justify-content: center;
  z-index: 2;
  box-shadow: 0 4rpx 14rpx rgba(0, 0, 0, 0.1);
  transition: all 0.2s ease;
}
.btn-hover { transform: scale(0.9); background: rgba(255, 255, 255, 0.45); }

.back-icon { font-size: 36rpx; color: #ffffff; font-weight: 300; }

.header-info {
  flex: 1; margin-left: 20rpx; z-index: 2;
  display: flex; flex-direction: column;
}

.header-title {
  font-size: 38rpx; font-weight: 800; color: #ffffff;
  letter-spacing: 1rpx;
  text-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.1);
}

.stat-row {
  display: flex; flex-direction: row; align-items: center;
  margin-top: 8rpx;
}

.st-tag {
  font-size: 20rpx; color: rgba(255, 255, 255, 0.82);
  margin-right: 12rpx; padding: 4rpx 12rpx;
  background: rgba(255, 255, 255, 0.16);
  border-radius: 16rpx; font-weight: 500; backdrop-filter: blur(4px);
}
.st-avail { color: rgba(187, 247, 208, 0.95); background: rgba(34, 197, 94, 0.2); }
.st-charging { color: rgba(191, 219, 254, 0.95); background: rgba(37, 99, 235, 0.2); }

.header-right { z-index: 2; }

.add-btn {
  display: flex; align-items: center; gap: 6rpx;
  padding: 10rpx 22rpx; border-radius: 20rpx;
  background: linear-gradient(135deg, #f59e0b, #fb923c);
  box-shadow: 0 4rpx 14rpx rgba(245, 158, 11, 0.3);
}
.add-icon { font-size: 30rpx; color: #ffffff; font-weight: 700; }
.add-text { font-size: 24rpx; color: #ffffff; font-weight: 600; }

/* ========== 搜索栏 ========== */
.search-bar {
  margin: 20rpx 24rpx 16rpx;
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(10px);
  border-radius: 20rpx; padding: 16rpx 22rpx;
  display: flex; align-items: center;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.04);
}
.search-icon { font-size: 28rpx; margin-right: 12rpx; }
.search-input { flex: 1; font-size: 26rpx; color: #1c1917; }
.search-placeholder { color: #a8a29e; }

/* ========== 筛选区：毛玻璃chip ========== */
.filter-section {
  padding-left: 24rpx;
  background: linear-gradient(180deg, rgba(255,251,235,0.95), rgba(255,251,235,0.88));
  white-space: nowrap; padding-bottom: 10rpx; backdrop-filter: blur(8px);
}
.filter-inner { display: inline-flex; padding: 10rpx 0 10rpx 0; }
.f-chip {
  display: inline-flex; align-items: center; justify-content: center;
  padding: 12rpx 28rpx; border-radius: 36rpx; margin-right: 14rpx;
  background: rgba(255, 255, 255, 0.72);
  backdrop-filter: blur(16px);
  transition: all 0.35s cubic-bezier(0.34, 1.56, 0.64, 1);
  border: 2px solid rgba(245, 158, 11, 0.12);
  box-shadow: 0 2rpx 12rpx rgba(245, 158, 11, 0.06);
}
.f-chip:last-child { margin-right: 24rpx; }
.f-chip.active {
  background: linear-gradient(135deg, #f59e0b, #f97316);
  box-shadow: 0 8rpx 24rpx rgba(245, 158, 11, 0.38), 0 2rpx 8rpx rgba(245, 158, 11, 0.16);
  border-color: transparent;
}
.fc-text { font-size: 24rpx; color: #4b5563; font-weight: 500; letter-spacing: 0.5rpx; }
.f-chip.active .fc-text { color: #ffffff; font-weight: 700; }

/* ========== 站点信息条 ========== */
.station-banner {
  margin: 12rpx 24rpx 16rpx;
  display: flex; align-items: center; padding: 14rpx 20rpx;
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.08), rgba(249, 115, 22, 0.04));
  border-radius: 14rpx; border: 1px solid rgba(245, 158, 11, 0.12);
}
.sb-dot { width: 12rpx; height: 12rpx; border-radius: 50%; background: #f59e0b; margin-right: 12rpx; box-shadow: 0 0 8rpx rgba(245, 158, 11, 0.4); }
.sb-text { font-size: 24rpx; color: #78716c; }
.sb-name { color: #d97706; font-weight: 700; }

/* ========== 加载状态 ========== */
.loading-box { display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 200rpx 0; }
.loading-spinner { width: 60rpx; height: 60rpx; border: 5px solid rgba(245, 158, 11, 0.15); border-top-color: #f59e0b; border-radius: 50%; animation: spin 0.8s linear infinite; margin-bottom: 20rpx; }
@keyframes spin { to { transform: rotate(360deg); } }
.loading-text { font-size: 26rpx; color: #9ca3af; }

/* ========== 空状态 ========== */
.empty-box { display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 220rpx 0 180rpx; }
.empty-icon-wrap { width: 160rpx; height: 160rpx; border-radius: 50%; background: linear-gradient(135deg, rgba(245,158,11,0.08), rgba(249,115,22,0.14)); display: flex; align-items: center; justify-content: center; margin-bottom: 32rpx; animation: emptyFloat 3.5s ease-in-out infinite; box-shadow: 0 8rpx 32rpx rgba(245, 158, 11, 0.08); }
@keyframes emptyFloat { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-16rpx); } }
.empty-icon { font-size: 60rpx; }
.empty-main { font-size: 32rpx; color: #374151; font-weight: 600; margin-bottom: 14rpx; }
.empty-sub { font-size: 25rpx; color: #9ca3af; }

/* ========== 充电桩卡片列表 ========== */
.pile-list { padding: 0 24rpx; }
.pile-card {
  position: relative; overflow: hidden; border-radius: 24rpx; margin-bottom: 20rpx;
  display: flex; flex-direction: row;
  box-shadow: 0 4rpx 20rpx rgba(245, 158, 11, 0.06), 0 1rpx 4rpx rgba(0, 0, 0, 0.03);
  transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1), box-shadow 0.3s ease;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.82), rgba(255, 255, 255, 0.96));
  backdrop-filter: blur(20rpx);
}
.card-hover { transform: scale(0.97); box-shadow: 0 2rpx 10rpx rgba(245, 158, 11, 0.08), 0 1rpx 3rpx rgba(0, 0, 0, 0.04); }

/* ====== 左侧彩色状态条 ====== */
.pc-bar { width: 5rpx; flex-shrink: 0; transition: width 0.35s cubic-bezier(0.34, 1.56, 0.64, 1), box-shadow 0.35s ease; position: relative; z-index: 3; }
.bar-status-0 { background: linear-gradient(180deg, #d97706, #f59e0b); box-shadow: 0 0 12rpx rgba(217,119,6,0.3); }
.bar-status-1 { background: linear-gradient(180deg, #f59e0b, #fb923c); box-shadow: 0 0 12rpx rgba(245,158,11,0.3); }
.bar-status-2 { background: linear-gradient(180deg, #b45309, #d97706); box-shadow: 0 0 12rpx rgba(180,83,9,0.3); }
.bar-status-3 { background: linear-gradient(180deg, #fbbf24, #fcd34d); box-shadow: 0 0 12rpx rgba(251,191,36,0.3); }
.card-hover .pc-bar { width: 7rpx; }
.card-hover .bar-status-0 { box-shadow: 0 0 24rpx rgba(217,119,6,0.55), 0 0 48rpx rgba(217,119,6,0.2); }
.card-hover .bar-status-1 { box-shadow: 0 0 24rpx rgba(245,158,11,0.55), 0 0 48rpx rgba(245,158,11,0.2); }
.card-hover .bar-status-2 { box-shadow: 0 0 24rpx rgba(180,83,9,0.55), 0 0 48rpx rgba(180,83,9,0.2); }
.card-hover .bar-status-3 { box-shadow: 0 0 24rpx rgba(251,191,36,0.55), 0 0 48rpx rgba(251,191,36,0.2); }

/* ====== 颜色蔓延层 ====== */
.pc-spread { position: absolute; top: 0; left: 0; width: 0; height: 100%; opacity: 0; border-radius: 24rpx; pointer-events: none; z-index: 2; transition: width 0.5s cubic-bezier(0.22, 1, 0.36, 1), opacity 0.4s ease; }
.spread-status-0 { background: radial-gradient(circle at left, rgba(217,119,6,0.10) 0%, rgba(217,119,6,0.04) 60%, transparent 100%); }
.spread-status-1 { background: radial-gradient(circle at left, rgba(245,158,11,0.10) 0%, rgba(245,158,11,0.04) 60%, transparent 100%); }
.spread-status-2 { background: radial-gradient(circle at left, rgba(180,83,9,0.10) 0%, rgba(180,83,9,0.04) 60%, transparent 100%); }
.spread-status-3 { background: radial-gradient(circle at left, rgba(251,191,36,0.10) 0%, rgba(251,191,36,0.04) 60%, transparent 100%); }
.card-hover .pc-spread { width: 100%; opacity: 1; }

/* ====== 卡片主体 ====== */
.pc-body { flex: 1; padding: 24rpx 24rpx 20rpx; position: relative; z-index: 4; }
.pc-top { display: flex; flex-direction: row; justify-content: space-between; align-items: flex-start; margin-bottom: 16rpx; }
.pc-left { display: flex; align-items: center; flex-wrap: wrap; flex: 1; margin-right: 12rpx; }
.pc-code { font-size: 32rpx; font-weight: 800; color: #111827; margin-right: 12rpx; letter-spacing: 0.8rpx; }
.type-badge { font-size: 20rpx; color: #fff; border-radius: 16rpx; padding: 4rpx 14rpx; font-weight: 600; }
.tb-dc { background: linear-gradient(135deg, #d97706, #f59e0b); box-shadow: 0 2rpx 8rpx rgba(217, 119, 6, 0.25); }
.tb-ac { background: linear-gradient(135deg, #f59e0b, #fb923c); box-shadow: 0 2rpx 8rpx rgba(245, 158, 11, 0.25); }

/* ====== 状态徽章 ====== */
.status-badge { display: flex; flex-direction: row; align-items: center; border-radius: 18rpx; padding: 6rpx 16rpx; font-weight: 600; white-space: nowrap; flex-shrink: 0; }
.sb-dot { width: 12rpx; height: 12rpx; border-radius: 50%; margin-right: 8rpx; flex-shrink: 0; }
.dot-blink { animation: dotBlink 1.5s ease-in-out infinite; }
@keyframes dotBlink { 0%, 100% { opacity: 1; } 50% { opacity: 0.3; } }
.sb-text { font-size: 22rpx; }
.sb-0 { background: rgba(22, 163, 74, 0.1); }
.sb-0 .sb-dot { background: #16a34a; box-shadow: 0 0 8rpx rgba(22, 163, 74, 0.5); }
.sb-0 .sb-text { color: #16a34a; }
.sb-1 { background: rgba(37, 99, 235, 0.1); }
.sb-1 .sb-dot { background: #2563eb; box-shadow: 0 0 8rpx rgba(37, 99, 235, 0.5); }
.sb-1 .sb-text { color: #2563eb; }
.sb-2 { background: rgba(239, 68, 68, 0.1); }
.sb-2 .sb-dot { background: #ef4444; box-shadow: 0 0 8rpx rgba(239, 68, 68, 0.5); animation: dotBlink 0.8s ease-in-out infinite; }
.sb-2 .sb-text { color: #ef4444; }
.sb-3 { background: rgba(156, 163, 175, 0.1); }
.sb-3 .sb-dot { background: #9ca3af; }
.sb-3 .sb-text { color: #9ca3af; }

/* ====== 功率大字行 ====== */
.pc-power-row { display: flex; flex-direction: row; align-items: baseline; justify-content: space-between; margin-bottom: 16rpx; }
.power-block { display: flex; align-items: baseline; }
.power-num { font-size: 52rpx; font-weight: 900; letter-spacing: -0.5rpx; }
.power-dc { color: #2563eb; text-shadow: 0 2rpx 8rpx rgba(37, 99, 235, 0.12); }
.power-ac { color: #16a34a; text-shadow: 0 2rpx 8rpx rgba(22, 163, 74, 0.12); }
.power-unit { font-size: 24rpx; color: #9ca3af; font-weight: 600; margin-left: 4rpx; }
.connector-tag { padding: 6rpx 18rpx; border-radius: 12rpx; background: linear-gradient(135deg, rgba(245, 158, 11, 0.08), rgba(249, 115, 22, 0.05)); border: 1px solid rgba(245, 158, 11, 0.12); }
.conn-text { font-size: 22rpx; color: #d97706; font-weight: 600; }

/* ====== 充电中实时数据 ====== */
.live-data { display: flex; flex-direction: row; align-items: center; background: linear-gradient(135deg, rgba(37, 99, 235, 0.05), rgba(59, 130, 246, 0.10)); border-radius: 14rpx; padding: 16rpx 18rpx; margin-bottom: 16rpx; border: 1px solid rgba(37, 99, 235, 0.08); }
.live-cell { flex: 1; display: flex; flex-direction: column; align-items: center; }
.live-lbl { font-size: 20rpx; color: #9ca3af; margin-bottom: 4rpx; }
.live-val { font-size: 24rpx; color: #2563eb; font-weight: 700; }
.live-divider { width: 1rpx; height: 40rpx; background: rgba(37, 99, 235, 0.18); margin: 0 12rpx; }

/* ====== 底部数据行 ====== */
.pc-bottom { display: flex; flex-direction: row; align-items: center; border-top: 1px solid rgba(245, 158, 11, 0.07); padding-top: 14rpx; margin-top: 4rpx; }
.bottom-meta { flex: 1; display: flex; flex-direction: column; }
.bm-lbl { font-size: 20rpx; color: #9ca3af; }
.bm-val { font-size: 24rpx; color: #1f2937; font-weight: 700; margin-top: 2rpx; }
.bottom-arrow { width: 48rpx; height: 48rpx; border-radius: 50%; background: linear-gradient(135deg, rgba(245, 158, 11, 0.08), rgba(249, 115, 22, 0.04)); display: flex; align-items: center; justify-content: center; margin-left: 12rpx; }
.arrow-icon { font-size: 28rpx; color: #d97706; font-weight: 700; }
</style>
