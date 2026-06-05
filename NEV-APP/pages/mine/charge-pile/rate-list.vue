<template>
  <view class="page" :class="{ 'page-ready': isReady }">
    <!-- 背景光晕矩阵（琥珀橙暖色系） -->
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
      <!-- 琥珀渐变顶栏 -->
      <view class="header">
        <view class="header-bg"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="header-info">
          <text class="header-title">费率管理</text>
          <text class="header-sub">{{ activeCount }} 个生效中</text>
        </view>
        <view class="header-right" @tap="goAdd">
          <view class="add-btn">
            <text class="add-icon">+</text>
            <text class="add-text">新增</text>
          </view>
        </view>
      </view>

      <!-- 站点选择器 -->
      <view class="station-selector">
        <view class="station-info" hover-class="sel-hover" @tap="showStationPicker">
          <text class="station-icon">📍</text>
          <view class="station-detail">
            <text class="station-name">{{ currentStation }}</text>
            <text class="station-hint">点击切换站点</text>
          </view>
          <text class="station-arrow">›</text>
        </view>
      </view>

      <!-- 费率卡片列表 -->
      <view class="rate-list" v-if="rateList.length > 0">
        <view
          class="rate-card"
          v-for="(item, idx) in rateList"
          :key="item.rateId"
          :class="[item.type === 'dc' ? 'card-dc' : 'card-ac', { 'card-expanded': expandedIds.indexOf(item.rateId) > -1 }]"
          :style="{ 'animation-delay': (idx * 0.08) + 's' }"
          hover-class="card-hover"
          @tap="toggleExpand(item.rateId)"
        >
          <!-- 左侧彩色竖条 -->
          <view class="left-color-bar"></view>

          <!-- 卡片主体 -->
          <view class="card-body">
            <!-- 卡片头部：名称 + 类型 + 状态 + 操作 -->
            <view class="card-header">
              <view class="header-left">
                <text class="rate-emoji">{{ item.type === 'dc' ? '⚡' : '🔌' }}</text>
                <text class="rate-name">{{ item.rateName }}</text>
                <text :class="['type-tag', item.type === 'dc' ? 'tag-dc' : 'tag-ac']">{{ item.typeLabel }}</text>
              </view>
              <view class="header-right">
                <view
                  class="action-chip chip-edit"
                  hover-class="chip-active"
                  @tap.stop="goEdit(item.rateId)"
                >
                  <text>编辑</text>
                </view>
                <view
                  :class="['action-chip', 'chip-toggle', item.status === '1' ? 'toggle-on' : 'toggle-off']"
                  hover-class="chip-active"
                  @tap.stop="toggleStatus(item.rateId)"
                >
                  <text>{{ item.status === '1' ? '停用' : '启用' }}</text>
                </view>
              </view>
            </view>

            <!-- 价格区域 -->
            <view class="price-area">
              <view class="price-row-main">
                <view class="price-item price-electric">
                  <text class="price-icon">⚡</text>
                  <text class="price-label">电费</text>
                  <text class="price-value-big">&yen;{{ fmt(item.basePrice) }}</text>
                  <text class="price-unit">元/kWh</text>
                </view>
                <view class="price-divider"></view>
                <view class="price-item price-service">
                  <text class="price-icon">🧾</text>
                  <text class="price-label">服务费</text>
                  <text class="price-value-big">&yen;{{ fmt(item.serviceFee) }}</text>
                  <text class="price-unit">元/kWh</text>
                </view>
              </view>
              <view class="total-line">
                <view class="total-left">
                  <text class="total-icon">💰</text>
                  <text class="total-label">综合单价</text>
                </view>
                <view class="total-right">
                  <text class="total-value">&yen;{{ fmt(item.totalPrice) }}</text>
                  <text class="total-unit">/kWh</text>
                </view>
              </view>
            </view>

            <!-- 时段配置（展开/内嵌） -->
            <view class="period-section" v-if="expandedIds.indexOf(item.rateId) > -1 || showAllPeriods">
              <view class="period-title-bar">
                <text class="period-title-icon">⏰</text>
                <text class="period-title-text">时段配置</text>
                <text class="period-count-badge">{{ item.periods.length }} 个时段</text>
              </view>
              <view class="period-list-inner">
                <view
                  class="period-row"
                  v-for="(p, pi) in item.periods"
                  :key="pi"
                  :class="{ 'period-odd': pi % 2 === 1 }"
                >
                  <view class="p-left">
                    <text :class="['p-emoji', p.name === '谷时' ? 'emoji-valley' : p.name === '峰时' ? 'emoji-peak' : 'emoji-flat']">{{ p.name === '谷时' ? '🌙' : p.name === '峰时' ? '☀️' : '📊' }}</text>
                    <view class="p-name-time">
                      <text class="p-name">{{ p.name }}</text>
                      <text class="p-time">{{ p.startTime }} - {{ p.endTime }}</text>
                    </view>
                  </view>
                  <view class="p-right">
                    <text class="p-total-price">&yen;{{ fmt(p.total) }}</text>
                    <text class="p-detail">电&yen;{{ fmt(p.price) }}+服&yen;{{ fmt(p.servicePrice) }}</text>
                  </view>
                </view>
              </view>
            </view>

            <!-- 展开提示 -->
            <view class="expand-hint" v-if="item.periods && item.periods.length > 0">
              <text class="expand-hint-text">{{ expandedIds.indexOf(item.rateId) > -1 ? '收起时段 ▲' : '展开时段 ▼' }}</text>
            </view>

            <!-- 底部状态条 -->
            <view class="status-bar" :class="item.status === '1' ? 'bar-enable' : 'bar-disable'">
              <view class="status-dot-pulse" v-if="item.status === '1'"></view>
              <text class="status-text">{{ item.status === '1' ? '启用中 ✓' : '已停用 ✗' }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 空状态 -->
      <view class="empty-state" v-if="rateList.length === 0">
        <text class="empty-icon">💰</text>
        <text class="empty-text">暂无费率方案</text>
        <view class="empty-btn" @tap="goAdd">
          <text>立即添加费率</text>
        </view>
      </view>

      <view style="height: 140rpx;"></view>
    </scroll-view>

    <!-- 浮动新增按钮 -->
    <view class="fab-add" hover-class="fab-hover" @tap="goAdd">
      <text class="fab-icon">+</text>
    </view>
  </view>
</template>

<script>
export default {
  data: function() {
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
    return {
      isReady: false,
      glowRows: rows,
      currentStation: '济南奥体中心充电站',
      currentStationId: 1,
      /* 站点列表（与dashboard/station-list保持一致） */
      stationList: [
        { stationId: 1, name: '济南奥体中心充电站' },
        { stationId: 2, name: '济南万达广场充电站' },
        { stationId: 4, name: '青岛万象城充电站' },
        { stationId: 7, name: '淄博万象汇充电站' },
        { stationId: 10, name: '烟台芝罘万达充电站' }
      ],
      showAllPeriods: false,
      expandedIds: [],
      /* 全量费率数据（所有站点的费率） */
      allRateList: [
        {
          rateId: 1,
          rateName: '奥体中心-快充费率',
          stationId: 1,
          stationName: '济南奥体中心充电站',
          type: 'dc',
          typeLabel: 'DC快充',
          basePrice: 0.90,
          serviceFee: 0.55,
          totalPrice: 1.45,
          status: '1',
          periods: [
            { name: '谷时', startTime: '23:00', endTime: '07:00', price: 0.35, servicePrice: 0.55, total: 0.90 },
            { name: '平时', startTime: '07:00', endTime: '09:00', price: 0.70, servicePrice: 0.55, total: 1.25 },
            { name: '峰时', startTime: '09:00', endTime: '23:00', price: 1.15, servicePrice: 0.55, total: 1.70 }
          ]
        },
        {
          rateId: 2,
          rateName: '奥体中心-慢充费率',
          stationId: 1,
          stationName: '济南奥体中心充电站',
          type: 'ac',
          typeLabel: 'AC慢充',
          basePrice: 0.60,
          serviceFee: 0.40,
          totalPrice: 1.00,
          status: '1',
          periods: [
            { name: '谷时', startTime: '23:00', endTime: '07:00', price: 0.25, servicePrice: 0.40, total: 0.65 },
            { name: '峰时', startTime: '07:00', endTime: '23:00', price: 0.55, servicePrice: 0.40, total: 0.95 }
          ]
        },
        {
          rateId: 3,
          rateName: '高新区-快充费率',
          stationId: 2,
          stationName: '济南高新区充电站',
          type: 'dc',
          typeLabel: 'DC快充',
          basePrice: 0.85,
          serviceFee: 0.50,
          totalPrice: 1.35,
          status: '0',
          periods: [
            { name: '谷时', startTime: '22:00', endTime: '06:00', price: 0.30, servicePrice: 0.50, total: 0.80 },
            { name: '平时', startTime: '06:00', endTime: '10:00', price: 0.65, servicePrice: 0.50, total: 1.15 },
            { name: '峰时', startTime: '10:00', endTime: '22:00', price: 1.05, servicePrice: 0.50, total: 1.55 }
          ]
        }
      ],
      /* 当前站点过滤后的费率列表（展示用） */
      rateList: []
    }
  },
  computed: {
    activeCount: function() {
      var self = this
      return self.rateList.filter(function(r) { return r.status === '1' }).length
    }
  },
  created: function() {
    var that = this
    /* 初始化时加载当前站点的费率 */
    that.rateList = that.allRateList.filter(function(r) { return r.stationId === that.currentStationId })
    setTimeout(function() { that.isReady = true }, 200)
  },
  methods: {
    goBack: function() {
      uni.navigateBack({ delta: 1 })
    },

    /* ---------- 站点切换 ---------- */
    showStationPicker: function() {
      var that = this
      var names = that.stationList.map(function(s) { return s.name })
      uni.showActionSheet({
        itemList: names,
        success: function(res) {
          var idx = res.tapIndex
          if (idx >= 0 && idx < that.stationList.length) {
            var st = that.stationList[idx]
            that.currentStation = st.name
            that.currentStationId = st.stationId
            /* 切换站点后重新加载该站点的费率数据 */
            that.loadRatesByStation(st.stationId)
          }
        }
      })
    },

    loadRatesByStation: function(stationId) {
      var that = this
      /* 从全量数据中按stationId过滤 */
      that.rateList = that.allRateList.filter(function(r) { return r.stationId === stationId })
      if (that.rateList.length === 0) {
        uni.showToast({ title: '该站点暂无费率配置', icon: 'none', duration: 1500 })
      }
    },
    goAdd: function() {
      uni.navigateTo({ url: '/pages/mine/charge-pile/rate-edit?stationId=' + this.currentStationId })
    },
    goEdit: function(rateId) {
      uni.navigateTo({ url: '/pages/mine/charge-pile/rate-edit?rateId=' + rateId })
    },
    toggleExpand: function(rateId) {
      var idx = this.expandedIds.indexOf(rateId)
      if (idx > -1) {
        this.expandedIds.splice(idx, 1)
      } else {
        this.expandedIds.push(rateId)
      }
    },
    toggleStatus: function(rateId) {
      var self = this
      var item = null
      for (var i = 0; i < self.rateList.length; i++) {
        if (self.rateList[i].rateId === rateId) {
          item = self.rateList[i]
          break
        }
      }
      if (!item) return
      var newStatus = item.status === '1' ? '0' : '1'
      item.status = newStatus
      uni.showToast({
        title: newStatus === '1' ? '已启用' : '已停用',
        icon: 'none',
        duration: 1200
      })
    },
    fmt: function(val) {
      if (val === undefined || val === null) return '0.00'
      return Number(val).toFixed(2)
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
.page-ready .rate-card {
  animation: fadeSlideUp 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) backwards;
}

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

/* ========== 琥珀渐变顶栏 ========== */
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
  background: rgba(255, 255, 255, 0.28);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  padding: 14rpx 26rpx;
  border-radius: 32rpx;
  box-shadow: 0 4rpx 14rpx rgba(0, 0, 0, 0.08);
}
.add-icon {
  font-size: 30rpx;
  color: #ffffff;
  font-weight: 700;
  margin-right: 6rpx;
}
.add-text {
  font-size: 24rpx;
  color: #ffffff;
  font-weight: 600;
}

/* ========== 站点选择器 ========== */
.station-selector {
  padding: 16rpx 24rpx 8rpx;
  position: relative;
  z-index: 2;
}
.station-info {
  display: flex;
  align-items: center;
  background: rgba(255, 255, 255, 0.82);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  border-radius: 18rpx;
  padding: 20rpx 24rpx;
  box-shadow: 0 4rpx 16rpx rgba(245, 158, 11, 0.08);
  border: 1rpx solid rgba(245, 158, 11, 0.1);
  transition: all 0.25s ease;
}
.sel-hover {
  transform: scale(0.98);
  box-shadow: 0 6rpx 24rpx rgba(245, 158, 11, 0.15);
}
.station-icon {
  font-size: 32rpx;
  margin-right: 14rpx;
}
.station-detail {
  flex: 1;
  display: flex;
  flex-direction: column;
}
.station-name {
  font-size: 27rpx;
  font-weight: 700;
  color: #451a03;
  letter-spacing: 0.3rpx;
}
.station-hint {
  font-size: 20rpx;
  color: #a16207;
  margin-top: 4rpx;
}
.station-arrow {
  font-size: 32rpx;
  color: #d97706;
  font-weight: 700;
}

/* ========== 费率卡片列表 ========== */
.rate-list {
  padding: 12rpx 24rpx;
}
.rate-card {
  background: rgba(255, 255, 255, 0.82);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border-radius: 24rpx;
  margin-bottom: 20rpx;
  overflow: hidden;
  position: relative;
  box-shadow: 0 6rpx 28rpx rgba(0, 0, 0, 0.05), inset 0 1rpx 0 rgba(255, 255, 255, 0.9);
  border: 1rpx solid rgba(255, 255, 255, 0.8);
  transition: all 0.3s ease;
}
.card-hover {
  transform: scale(0.985) translateY(-2rpx);
  box-shadow: 0 12rpx 36rpx rgba(0, 0, 0, 0.1);
}

/* 左侧彩色竖条 */
.left-color-bar {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 6rpx;
  border-radius: 24rpx 0 0 24rpx;
  transition: all 0.3s ease;
}
.card-dc .left-color-bar {
  background: linear-gradient(180deg, #d97706, #f59e0b, #fb923c);
  box-shadow: 2rpx 0 16rpx rgba(217, 119, 6, 0.35);
}
.card-ac .left-color-bar {
  background: linear-gradient(180deg, #f59e0b, #fb923c, #fbbf24);
  box-shadow: 2rpx 0 16rpx rgba(245, 158, 11, 0.35);
}
.card-hover .left-color-bar {
  width: 8rpx;
}
.card-expanded .left-color-bar {
  width: 8rpx;
}

.card-body {
  padding: 24rpx 22rpx 20rpx 26rpx;
  position: relative;
  z-index: 1;
}

/* ========== 卡片头部 ========== */
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 18rpx;
}
.header-left {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  flex: 1;
  min-width: 0;
}
.rate-emoji {
  font-size: 32rpx;
  margin-right: 10rpx;
}
.rate-name {
  font-size: 29rpx;
  font-weight: 800;
  color: #1c1917;
  letter-spacing: 0.5rpx;
  margin-right: 12rpx;
}
.type-tag {
  display: inline-block;
  font-size: 20rpx;
  padding: 5rpx 16rpx;
  border-radius: 14rpx;
  font-weight: 700;
  letter-spacing: 0.5rpx;
}
.tag-dc {
  color: #d97706;
  background: linear-gradient(135deg, rgba(217, 119, 6, 0.12), rgba(245, 158, 11, 0.06));
  border: 1rpx solid rgba(217, 119, 6, 0.18);
}
.tag-ac {
  color: #f59e0b;
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.12), rgba(251, 146, 60, 0.06));
  border: 1rpx solid rgba(245, 158, 11, 0.18);
}
.header-right {
  display: flex;
  align-items: center;
  margin-left: 12rpx;
  flex-shrink: 0;
}
.action-chip {
  padding: 8rpx 20rpx;
  border-radius: 20rpx;
  font-size: 22rpx;
  font-weight: 600;
  margin-left: 8rpx;
  transition: all 0.2s ease;
}
.chip-active {
  transform: scale(0.94);
}
.chip-edit {
  color: #f59e0b;
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.1), rgba(251, 146, 60, 0.05));
  border: 1rpx solid rgba(245, 158, 11, 0.15);
}
.chip-toggle {
  border: 1rpx solid transparent;
}
.toggle-on {
  color: #d97706;
  background: linear-gradient(135deg, rgba(217, 119, 6, 0.1), rgba(245, 158, 11, 0.05));
  border-color: rgba(217, 119, 6, 0.18);
}
.toggle-off {
  color: #9ca3af;
  background: linear-gradient(135deg, rgba(156, 163, 175, 0.08), rgba(209, 213, 219, 0.04));
  border-color: rgba(156, 163, 175, 0.12);
}

/* ========== 价格区域 ========== */
.price-area {
  background: linear-gradient(135deg, rgba(250, 252, 250, 0.95), rgba(255, 255, 255, 1));
  border-radius: 16rpx;
  padding: 18rpx 20rpx;
  margin-bottom: 14rpx;
  border: 1rpx solid rgba(0, 0, 0, 0.03);
}
.price-row-main {
  display: flex;
  align-items: center;
}
.price-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 8rpx 0;
}
.price-icon {
  font-size: 26rpx;
  margin-bottom: 4rpx;
}
.price-label {
  font-size: 20rpx;
  color: #a8a29e;
  font-weight: 500;
  margin-bottom: 6rpx;
}
.price-value-big {
  font-size: 36rpx;
  font-weight: 900;
  color: #f59e0b;
  letter-spacing: 0.5rpx;
  text-shadow: 0 2rpx 8rpx rgba(245, 158, 11, 0.12);
}
.price-unit {
  font-size: 18rpx;
  color: #a8a29e;
  margin-top: 2rpx;
}
.price-divider {
  width: 1rpx;
  height: 72rpx;
  background: linear-gradient(180deg, transparent, #e5e5e5, transparent);
  margin: 0 12rpx;
}
.total-line {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 14rpx;
  margin-top: 12rpx;
  border-top: 1rpx dashed rgba(245, 158, 11, 0.2);
}
.total-left {
  display: flex;
  align-items: center;
}
.total-icon {
  font-size: 26rpx;
  margin-right: 8rpx;
}
.total-label {
  font-size: 23rpx;
  color: #78716c;
  font-weight: 600;
}
.total-right {
  display: flex;
  align-items: baseline;
}
.total-value {
  font-size: 34rpx;
  font-weight: 900;
  color: #ea580c;
  letter-spacing: 0.5rpx;
  text-shadow: 0 2rpx 8rpx rgba(234, 88, 12, 0.15);
}
.total-unit {
  font-size: 20rpx;
  color: #78716c;
  margin-left: 4rpx;
  font-weight: 500;
}

/* ========== 时段配置 ========== */
.period-section {
  background: linear-gradient(135deg, rgba(255, 251, 235, 0.95), rgba(255, 255, 255, 1));
  border-radius: 16rpx;
  padding: 18rpx 18rpx 16rpx;
  margin-bottom: 14rpx;
  border: 1rpx solid rgba(245, 158, 11, 0.08);
  animation: slideDown 0.35s ease;
}
@keyframes slideDown {
  from { opacity: 0; max-height: 0; padding-top: 0; padding-bottom: 0; margin-bottom: 0; }
  to { opacity: 1; max-height: 2000rpx; padding-top: 18rpx; padding-bottom: 16rpx; margin-bottom: 14rpx; }
}
.period-title-bar {
  display: flex;
  align-items: center;
  margin-bottom: 14rpx;
  padding-left: 4rpx;
}
.period-title-icon {
  font-size: 24rpx;
  margin-right: 8rpx;
}
.period-title-text {
  font-size: 24rpx;
  font-weight: 700;
  color: #451a03;
  letter-spacing: 0.5rpx;
}
.period-count-badge {
  font-size: 18rpx;
  color: #d97706;
  background: rgba(217, 119, 6, 0.1);
  padding: 3rpx 12rpx;
  border-radius: 10rpx;
  margin-left: 10rpx;
  font-weight: 600;
}
.period-list-inner {
  display: flex;
  flex-direction: column;
}
.period-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 14rpx 16rpx;
  margin-bottom: 8rpx;
  border-radius: 12rpx;
  border-left: 4rpx solid #fed7aa;
  background: #fffbf5;
  transition: all 0.2s ease;
}
.period-row:last-child {
  margin-bottom: 0;
}
.period-row.period-odd {
  background: #ffffff;
  border-left-color: #fde68a;
}
.p-left {
  display: flex;
  align-items: center;
  flex: 1;
  min-width: 0;
}
.p-emoji {
  font-size: 28rpx;
  margin-right: 12rpx;
  flex-shrink: 0;
}
.p-name-time {
  display: flex;
  flex-direction: column;
}
.p-name {
  font-size: 25rpx;
  font-weight: 700;
  color: #1c1917;
}
.p-time {
  font-size: 19rpx;
  color: #a8a29e;
  font-family: "Courier New", Courier, monospace;
  letter-spacing: 1rpx;
  margin-top: 2rpx;
}
.p-right {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  flex-shrink: 0;
  margin-left: 16rpx;
}
.p-total-price {
  font-size: 28rpx;
  font-weight: 800;
  color: #f59e0b;
  font-family: "Courier New", Courier, monospace;
}
.p-detail {
  font-size: 18rpx;
  color: #a8a29e;
  margin-top: 2rpx;
  font-family: "Courier New", Courier, monospace;
}

/* ========== 展开提示 ========== */
.expand-hint {
  text-align: center;
  padding: 8rpx 0 4rpx;
}
.expand-hint-text {
  font-size: 21rpx;
  color: #d97706;
  font-weight: 600;
  letter-spacing: 0.5rpx;
}

/* ========== 底部状态条 ========== */
.status-bar {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 10rpx 0 2rpx;
  border-radius: 12rpx;
  gap: 8rpx;
}
.bar-enable {
  background: linear-gradient(135deg, rgba(34, 197, 94, 0.08), rgba(74, 222, 128, 0.04));
}
.bar-disable {
  background: linear-gradient(135deg, rgba(156, 163, 175, 0.08), rgba(209, 213, 219, 0.04));
}
.status-dot-pulse {
  width: 12rpx;
  height: 12rpx;
  border-radius: 50%;
  background: #d97706;
  animation: dotPulse 2s ease-in-out infinite;
  box-shadow: 0 0 8rpx #d97706;
}
@keyframes dotPulse {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.5; transform: scale(0.8); }
}
.status-text {
  font-size: 21rpx;
  font-weight: 600;
}
.bar-enable .status-text {
  color: #d97706;
}
.bar-disable .status-text {
  color: #9ca3af;
}

/* ========== 空状态 ========== */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 120rpx 40rpx;
}
.empty-icon {
  font-size: 96rpx;
  opacity: 0.35;
  animation: floatBounce 2.5s ease-in-out infinite;
}
@keyframes floatBounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-16rpx); }
}
.empty-text {
  font-size: 30rpx;
  color: #a8a29e;
  font-weight: 500;
  margin-top: 20rpx;
}
.empty-btn {
  margin-top: 32rpx;
  padding: 22rpx 56rpx;
  background: linear-gradient(135deg, #f59e0b, #f97316);
  border-radius: 44rpx;
  font-size: 28rpx;
  color: #fff;
  font-weight: 700;
  letter-spacing: 2rpx;
  box-shadow: 0 8rpx 32rpx rgba(245, 158, 11, 0.35);
  transition: all 0.25s ease;
}
.empty-btn:active {
  transform: scale(0.94);
  box-shadow: 0 10rpx 40rpx rgba(245, 158, 11, 0.45);
}

/* ========== 浮动新增按钮 ========== */
.fab-add {
  position: fixed;
  right: 32rpx;
  bottom: 60rpx;
  width: 108rpx;
  height: 108rpx;
  border-radius: 54rpx;
  background: linear-gradient(135deg, #f59e0b, #f97316);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 99;
  box-shadow: 0 8rpx 32rpx rgba(245, 158, 11, 0.4), 0 2rpx 8rpx rgba(0, 0, 0, 0.08);
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.fab-hover {
  transform: scale(1.1) rotate(90deg);
  box-shadow: 0 12rpx 44rpx rgba(245, 158, 11, 0.5), 0 4rpx 12rpx rgba(0, 0, 0, 0.1);
}
.fab-icon {
  font-size: 52rpx;
  color: #ffffff;
  font-weight: 300;
  line-height: 1;
}
</style>
