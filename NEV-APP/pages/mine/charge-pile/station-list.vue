<template>
  <view class="page" :class="{ 'page-ready': isReady }">
    <!-- 背景光晕矩阵（暖色琥珀系） -->
    <view class="glow-matrix">
      <view class="glow-row" v-for="(row, ri) in glowRows" :key="ri">
        <view
          class="glow-spot"
          v-for="(dot, ci) in row.dots"
          :key="ci"
          :style="dot.style"
        ></view>
      </view>
    </view>
    <view class="overlay-mask"></view>

    <!-- 主滚动区 -->
    <scroll-view scroll-y class="main-scroll" :show-scrollbar="false">
      <!-- 琥珀橙渐变顶栏 -->
      <view class="header">
        <view class="header-bg"></view>
        <view class="header-circle"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="header-info">
          <text class="header-title">充电站管理</text>
          <text class="header-sub">共 {{ filteredList.length }} 个站点</text>
        </view>
        <view class="header-right" @tap="goAdd">
          <view class="add-btn">
            <text class="add-icon">＋</text>
            <text class="add-text">新增</text>
          </view>
        </view>
      </view>

      <!-- 毛玻璃搜索栏 -->
      <view class="search-wrap">
        <view class="search-bar">
          <text class="search-icon">🔍</text>
          <input
            class="search-input"
            v-model="searchKey"
            placeholder="搜索站名或编码"
            placeholder-class="search-placeholder"
            @confirm="doSearch"
          />
        </view>
      </view>

      <!-- 站点卡片列表 -->
      <view class="list-area">
        <!-- 空状态 -->
        <view v-if="filteredList.length === 0" class="empty-box">
          <view class="empty-icon-wrap">
            <text class="empty-icon">⚡</text>
          </view>
          <text class="empty-main">暂无站点数据</text>
          <text class="empty-sub">尝试切换筛选条件</text>
        </view>

        <!-- 站点卡片 -->
        <view
          v-for="(item, index) in filteredList"
          :key="index"
          class="station-card"
          hover-class="card-hover"
          @tap="goDetail(item.stationId)"
        >
          <!-- 左侧彩色状态条 -->
          <view class="color-bar" :class="'cb-' + item.stationStatus"></view>
          <!-- 卡片主体 -->
          <view class="sc-body">
            <!-- 顶部：站名 + 状态标签 -->
            <view class="sc-top">
              <text class="sc-name">{{ item.stationName }}</text>
              <view class="status-badge" :class="'sb-' + item.stationStatus">
                <view class="status-dot" v-if="item.stationStatus === '1'"></view>
                <text class="sb-text">{{ getStatusLabel(item.stationStatus) }}</text>
              </view>
            </view>
            <!-- 编码 -->
            <text class="sc-code">编码：{{ item.stationCode }}</text>
            <!-- 地址 -->
            <view class="sc-addr">
              <text class="addr-mark">📍</text>
              <text class="addr-val">{{ item.address }}</text>
            </view>
            <!-- 三栏数据 -->
            <view class="sc-stats">
              <view class="stat-cell">
                <text class="stat-num">{{ item.totalPiles }}</text>
                <text class="stat-lbl">总桩数</text>
              </view>
              <view class="stat-divider"></view>
              <view class="stat-cell">
                <text class="stat-num highlight">{{ item.availablePiles }}</text>
                <text class="stat-lbl">空闲桩</text>
              </view>
              <view class="stat-divider"></view>
              <view class="stat-cell">
                <text class="stat-num income">¥{{ fmtMoney(item.todayIncome) }}</text>
                <text class="stat-lbl">今日营收</text>
              </view>
            </view>
            <!-- 桩利用率进度条 -->
            <view class="pile-row">
              <view class="pile-progress-bg">
                <view
                  class="pile-progress-fill"
                  :style="{ width: getPilePercent(item.availablePiles, item.totalPiles) + '%' }"
                ></view>
              </view>
              <view class="pile-text">
                <text class="pile-available">{{ item.availablePiles }}空闲</text>
                <text class="pile-slash">/</text>
                <text class="pile-total">{{ item.totalPiles }}总桩</text>
                <text class="pile-rate">{{ getPilePercent(item.availablePiles, item.totalPiles) }}%</text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <view style="height: 100rpx;"></view>
    </scroll-view>
  </view>
</template>

<script>
import { getStationList, addStation, deleteStation } from '@/api/charger/station.js'

export default {
  data: function() {
    return {
      isReady: false,
      glowRows: [],
      searchKey: '',
      currentStatus: '',
      statusList: [
        { label: '全部', value: '' },
        { label: '运营中', value: '1' },
        { label: '维护中', value: '2' },
        { label: '已停用', value: '3' }
      ],
      /* 站点数据（从接口加载） */
      stationList: [],
      loading: false
    }
  },
  computed: {
    /* 筛选后的站点列表 */
    filteredList: function() {
      var that = this
      var list = that.stationList

      /* 状态筛选 */
      if (that.currentStatus !== '') {
        list = list.filter(function(item) {
          return item.stationStatus === that.currentStatus
        })
      }

      /* 关键词搜索 */
      if (that.searchKey && that.searchKey.trim() !== '') {
        var key = that.searchKey.trim().toLowerCase()
        list = list.filter(function(item) {
          return (item.stationName || '').toLowerCase().indexOf(key) !== -1 ||
                 (item.stationCode || '').toLowerCase().indexOf(key) !== -1 ||
                 (item.address || '').toLowerCase().indexOf(key) !== -1
        })
      }

      return list
    }
  },
  created: function() {
    this.buildGlowRows()
    this.loadStations()
    var that = this
    setTimeout(function() {
      that.isReady = true
    }, 200)
  },
  methods: {
    /* ---------- 数据加载 ---------- */
    loadStations: function() {
      var self = this
      self.loading = true
      getStationList({
        stationName: self.searchKey || '',
        stationStatus: self.currentStatus || '',
        pageSize: 100
      }).then(function(res) {
        self.loading = false
        if (res.code === 200) {
          self.stationList = res.rows || []
        } else {
          uni.showToast({ title: res.msg || '加载失败', icon: 'none' })
        }
      }).catch(function(err) {
        self.loading = false
        uni.showToast({ title: '网络异常', icon: 'none' })
      })
    },

    /* ---------- 初始化：构建背景光晕矩阵 ---------- */
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

    /* ---------- 搜索与筛选 ---------- */
    doSearch: function() {
      /* computed 自动响应 searchKey 变化，此处保留供确认搜索触发 */
    },

    switchStatus: function(value) {
      this.currentStatus = value
    },

    /* ---------- 工具方法 ---------- */
    getStatusLabel: function(status) {
      var map = {
        '1': '运营中',
        '2': '维护中',
        '3': '已停用'
      }
      return map[status] || '未知'
    },

    getPilePercent: function(available, total) {
      if (!total || total === 0) return 0
      return Math.round((available / total) * 100)
    },

    fmtMoney: function(val) {
      if (val === null || val === undefined) return '0.00'
      return Number(val).toFixed(2)
    },

    /* ---------- 页面跳转 ---------- */
    goBack: function() {
      uni.navigateBack({ delta: 1 })
    },

    goDetail: function(stationId) {
      uni.navigateTo({
        url: '/pages/mine/charge-pile/station-detail?stationId=' + stationId
      })
    },

    goAdd: function() {
      uni.navigateTo({ url: '/pages/mine/charge-pile/station-add' })
    },

    doDeleteStation: function(stationId, name) {
      var self = this
      uni.showModal({
        title: '确认删除',
        content: '确定要删除站点「' + name + '」吗？删除后不可恢复。',
        confirmColor: '#ef4444',
        success: function(res) {
          if (res.confirm) {
            deleteStation(stationId).then(function(res) {
              if (res.code === 200) {
                self.stationList = self.stationList.filter(function(s) { return s.stationId !== stationId })
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

/* 入场动画 */
.page-ready .station-card {
  animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards;
}
.page-ready .station-card:nth-child(1) { animation-delay: 0.06s; }
.page-ready .station-card:nth-child(2) { animation-delay: 0.12s; }
.page-ready .station-card:nth-child(3) { animation-delay: 0.18s; }
.page-ready .station-card:nth-child(4) { animation-delay: 0.24s; }
.page-ready .station-card:nth-child(5) { animation-delay: 0.30s; }
.page-ready .station-card:nth-child(6) { animation-delay: 0.36s; }

@keyframes fadeSlideUp {
  from { opacity: 0; transform: translateY(30rpx) scale(0.96); }
  to { opacity: 1; transform: translateY(0) scale(1); }
}

/* ========== 背景光晕矩阵 ========== */
.glow-matrix {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
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
  50% { opacity: 0.6; }
  100% { opacity: 0.15; transform: scale(1.25); }
}

.overlay-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
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

/* ========== 琥珀橙渐变顶栏 ========== */
.header {
  position: relative;
  padding: 28rpx 28rpx 24rpx;
  display: flex;
  align-items: center;
  overflow: hidden;
}
.header-bg {
  position: absolute;
  top: -80rpx;
  left: -40rpx;
  right: -40rpx;
  bottom: -20rpx;
  background: linear-gradient(135deg, #f59e0b 0%, #f97316 35%, #fb923c 65%, #fdba74 100%);
  border-radius: 0 0 60rpx 60rpx;
}
.header-circle {
  position: absolute;
  top: -50rpx;
  right: -30rpx;
  width: 300rpx;
  height: 300rpx;
  border-radius: 50%;
  background: radial-gradient(circle, rgba(255, 255, 255, 0.15) 0%, transparent 70%);
  pointer-events: none;
}
.back-btn {
  width: 64rpx;
  height: 64rpx;
  border-radius: 32rpx;
  background: rgba(255, 255, 255, 0.3);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2;
  box-shadow: 0 4rpx 14rpx rgba(0, 0, 0, 0.1);
  transition: all 0.2s ease;
}
.btn-hover {
  transform: scale(0.9);
  background: rgba(255, 255, 255, 0.45);
}
.back-icon {
  font-size: 36rpx;
  color: #ffffff;
  font-weight: 300;
}
.header-info {
  flex: 1;
  margin-left: 20rpx;
  z-index: 2;
  display: flex;
  flex-direction: column;
}
.header-title {
  font-size: 38rpx;
  font-weight: 800;
  color: #ffffff;
  letter-spacing: 1rpx;
  text-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.1);
}
.header-sub {
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.88);
  margin-top: 6rpx;
  font-weight: 500;
}
.header-right {
  z-index: 2;
}
.add-btn {
  display: flex;
  align-items: center;
  gap: 6rpx;
  padding: 10rpx 22rpx;
  border-radius: 20rpx;
  background: rgba(255, 255, 255, 0.28);
  box-shadow: 0 4rpx 14rpx rgba(0, 0, 0, 0.08);
}
.add-icon {
  font-size: 32rpx;
  color: #ffffff;
  font-weight: 700;
}
.add-text {
  font-size: 24rpx;
  color: #ffffff;
  font-weight: 600;
}

/* ========== 搜索栏（毛玻璃版） ========== */
.search-wrap {
  position: relative;
  z-index: 3;
  padding: 10rpx 24rpx 12rpx;
}
.search-bar {
  display: flex;
  align-items: center;
  background: rgba(255, 255, 255, 0.82);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  border-radius: 20rpx;
  padding: 18rpx 22rpx;
  box-shadow: 0 4rpx 16rpx rgba(245, 158, 11, 0.08),
    inset 0 1rpx 0 rgba(255, 255, 255, 0.9);
  border: 1rpx solid rgba(255, 255, 255, 0.75);
}
.search-icon {
  font-size: 28rpx;
  margin-right: 14rpx;
  flex-shrink: 0;
}
.search-input {
  flex: 1;
  font-size: 27rpx;
  color: #1c1917;
}
.search-placeholder {
  color: #a8a29e;
}

/* ========== 筛选标签栏 ========== */
.filter-bar {
  position: relative;
  z-index: 3;
  white-space: nowrap;
  padding-bottom: 16rpx;
}
.filter-inner {
  display: inline-flex;
  padding: 16rpx 24rpx;
}
.filter-chip {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 13rpx 32rpx;
  border-radius: 36rpx;
  margin-right: 18rpx;
  background: linear-gradient(135deg, rgba(255,255,255,0.85), rgba(255,255,255,0.98));
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  border: 2rpx solid rgba(245, 158, 11, 0.12);
  box-shadow: 0 2rpx 10rpx rgba(245, 158, 11, 0.06),
    inset 0 1rpx 0 rgba(255, 255, 255, 0.8);
}
.chip-hover {
  transform: scale(0.96);
}
.filter-chip.active {
  background: linear-gradient(135deg, #f59e0b, #f97316);
  box-shadow: 0 6rpx 20rpx rgba(245, 158, 11, 0.35);
  border-color: transparent;
}
.chip-text {
  font-size: 26rpx;
  color: #44403c;
  font-weight: 600;
  letter-spacing: 0.5rpx;
}
.filter-chip.active .chip-text {
  color: #ffffff;
  font-weight: 700;
}

/* ========== 列表区域 ========== */
.list-area {
  padding: 8rpx 24rpx 40rpx;
  position: relative;
  z-index: 2;
}

/* ========== 空状态 ========== */
.empty-box {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 200rpx 0 160rpx;
}
.empty-icon-wrap {
  width: 150rpx;
  height: 150rpx;
  border-radius: 50%;
  background: linear-gradient(135deg, rgba(245,158,11,0.12), rgba(249,115,22,0.08));
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 28rpx;
  animation: floatAnim 3s ease-in-out infinite;
  box-shadow: 0 8rpx 32rpx rgba(245, 158, 11, 0.15);
}
@keyframes floatAnim {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-12rpx); }
}
.empty-icon {
  font-size: 60rpx;
}
.empty-main {
  font-size: 30rpx;
  color: #44403c;
  font-weight: 700;
  margin-bottom: 12rpx;
}
.empty-sub {
  font-size: 24rpx;
  color: #a8a29e;
}

/* ========== 站点卡片 ========== */
.station-card {
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(18px);
  -webkit-backdrop-filter: blur(18px);
  border-radius: 24rpx;
  margin-bottom: 22rpx;
  box-shadow:
    0 8rpx 32rpx rgba(0, 0, 0, 0.06),
    0 2rpx 8rpx rgba(245, 158, 11, 0.05),
    inset 0 1rpx 0 rgba(255, 255, 255, 0.9);
  border: 1rpx solid rgba(255, 255, 255, 0.8);
  position: relative;
  overflow: hidden;
  transition: all 0.35s cubic-bezier(0.34, 1.56, 0.64, 1);
  display: flex;
  flex-direction: row;
}

/* 左侧彩色状态条 */
.color-bar {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 5rpx;
  border-radius: 24rpx 0 0 24rpx;
  transition: all 0.35s ease;
  z-index: 3;
}
.cb-1 {
  background: linear-gradient(180deg, #d97706, #f59e0b);
  box-shadow: 2rpx 0 14rpx rgba(217, 119, 6, 0.28);
}
.cb-2 {
  background: linear-gradient(180deg, #f59e0b, #fb923c);
  box-shadow: 2rpx 0 14rpx rgba(245, 158, 11, 0.28);
}
.cb-3 {
  background: linear-gradient(180deg, #fbbf24, #fcd34d);
  box-shadow: 2rpx 0 14rpx rgba(251, 191, 36, 0.28);
}

/* hover效果：微缩放+阴影加深+条带加宽 */
.card-hover {
  transform: scale(0.97) translateY(-2rpx)!important;
  box-shadow:
    0 16rpx 48rpx rgba(0, 0, 0, 0.12)!important,
    0 8rpx 24rpx rgba(245, 158, 11, 0.1)!important;
  border-color: rgba(245, 158, 11, 0.2)!important;
}
.card-hover .color-bar {
  width: 7rpx;
  box-shadow: 4rpx 0 20rpx currentColor;
}

.sc-body {
  flex: 1;
  padding: 26rpx 26rpx 22rpx 28rpx;
  position: relative;
  z-index: 2;
}

/* 顶部：站名 + 状态标签 */
.sc-top {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10rpx;
}
.sc-name {
  font-size: 31rpx;
  font-weight: 800;
  color: #1c1917;
  flex: 1;
  margin-right: 16rpx;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  letter-spacing: 0.5rpx;
}

/* 状态标签 */
.status-badge {
  border-radius: 12rpx;
  padding: 7rpx 18rpx;
  flex-shrink: 0;
  font-weight: 700;
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  display: flex;
  align-items: center;
  gap: 7rpx;
}
.status-dot {
  width: 10rpx;
  height: 10rpx;
  border-radius: 50%;
  background: #22c55e;
  box-shadow: 0 0 8rpx #22c55e;
  animation: dotPulse 2s ease-in-out infinite;
}
@keyframes dotPulse {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.5; transform: scale(0.8); }
}
.sb-1 {
  background: linear-gradient(135deg, rgba(34, 197, 94, 0.12), rgba(74, 222, 128, 0.06));
  color: #16a34a;
  border: 1rpx solid rgba(34, 197, 94, 0.2);
}
.sb-1 .sb-text { font-size: 21rpx; }
.sb-2 {
  background: linear-gradient(135deg, rgba(249, 115, 22, 0.12), rgba(251, 146, 60, 0.06));
  color: #ea580c;
  border: 1rpx solid rgba(249, 115, 22, 0.2);
}
.sb-2 .sb-text { font-size: 21rpx; }
.sb-3 {
  background: linear-gradient(135deg, rgba(156, 163, 175, 0.12), rgba(209, 213, 219, 0.06));
  color: #6b7280;
  border: 1rpx solid rgba(156, 163, 175, 0.2);
}
.sb-3 .sb-text { font-size: 21rpx; }

/* 编码 */
.sc-code {
  font-size: 23rpx;
  color: #a8a29e;
  margin-bottom: 12rpx;
  display: block;
}

/* 地址 */
.sc-addr {
  display: flex;
  flex-direction: row;
  align-items: flex-start;
  margin-bottom: 16rpx;
}
.addr-mark {
  font-size: 23rpx;
  margin-right: 7rpx;
  flex-shrink: 0;
  margin-top: 2rpx;
}
.addr-val {
  font-size: 24rpx;
  color: #78716c;
  line-height: 1.5;
  flex: 1;
}

/* 三栏数据 */
.sc-stats {
  display: flex;
  flex-direction: row;
  align-items: center;
  margin-bottom: 16rpx;
  background: linear-gradient(135deg, rgba(250, 252, 250, 0.95), rgba(255, 255, 255, 1));
  border-radius: 16rpx;
  padding: 14rpx 16rpx;
  border: 1rpx solid rgba(0, 0, 0, 0.03);
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.02);
}
.stat-cell {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
}
.stat-num {
  font-size: 28rpx;
  color: #1c1917;
  font-weight: 800;
}
.stat-num.highlight {
  color: #16a34a;
  font-size: 32rpx;
}
.stat-num.income {
  color: #f59e0b;
  font-size: 26rpx;
}
.stat-lbl {
  font-size: 20rpx;
  color: #a8a29e;
  margin-top: 4rpx;
  font-weight: 500;
}
.stat-divider {
  width: 1rpx;
  height: 42rpx;
  background: linear-gradient(180deg, transparent, #d6d3d1, transparent);
  margin: 0 10rpx;
}

/* 桩利用率进度条 */
.pile-row {
  display: flex;
  flex-direction: column;
  gap: 8rpx;
}
.pile-progress-bg {
  width: 100%;
  height: 10rpx;
  background: rgba(0, 0, 0, 0.04);
  border-radius: 5rpx;
  overflow: hidden;
}
.pile-progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #22c55e, #4ade80, #86efac);
  border-radius: 5rpx;
  transition: width 0.8s cubic-bezier(0.34, 1.56, 0.64, 1);
  box-shadow: 0 0 10rpx rgba(34, 197, 94, 0.3);
  position: relative;
}
/* 绿色流光动画 */
.pile-progress-fill::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.45), transparent);
  animation: progressShine 2.2s ease-in-out infinite;
}
@keyframes progressShine {
  0% { transform: translateX(-100%); }
  100% { transform: translateX(100%); }
}
.pile-text {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
}
.pile-available {
  font-size: 23rpx;
  color: #16a34a;
  font-weight: 800;
}
.pile-slash {
  font-size: 21rpx;
  color: #cccccc;
  margin: 0 5rpx;
}
.pile-total {
  font-size: 21rpx;
  color: #a8a29e;
  font-weight: 600;
}
.pile-rate {
  font-size: 21rpx;
  color: #f59e0b;
  font-weight: 700;
}
</style>
