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
      <!-- 琥珀橙渐变顶栏 -->
      <view class="header">
        <view class="header-bg"></view>
        <view class="header-circle"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="header-info">
          <text class="header-title">库存管理</text>
          <text class="header-sub">共 {{ totalModels }} 款车型 / {{ totalStock }} 台在库</text>
        </view>
      </view>

      <!-- 统计概览条（3个毛玻璃小卡片） -->
      <view class="overview-section">
        <view class="overview-row">
          <view class="overview-card oc-total">
            <text class="oc-num">{{ totalModels }}</text>
            <text class="oc-label">总车型数</text>
          </view>
          <view class="overview-card oc-stock">
            <text class="oc-num">{{ totalStock }}</text>
            <text class="oc-label">总库存量</text>
          </view>
          <view class="overview-card oc-warn">
            <text class="oc-num">{{ lowCount }}</text>
            <text class="oc-label">低库存预警</text>
          </view>
        </view>
      </view>

      <!-- Tab切换栏 -->
      <scroll-view scroll-x class="tab-bar" :show-scrollbar="false">
        <view class="tab-inner">
          <view v-for="(tab, idx) in tabs" :key="idx"
            class="tab-chip" :class="{ active: activeTab === idx }"
            @tap="switchTab(idx)" hover-class="chip-hover">
            <text class="tab-text">{{ tab }}</text>
          </view>
        </view>
      </scroll-view>

      <!-- 库存卡片列表 -->
      <view class="stock-area">
        <!-- 空状态 -->
        <view v-if="filteredStock.length === 0" class="empty-box">
          <view class="empty-icon-wrap">
            <text class="empty-icon">📦</text>
          </view>
          <text class="empty-main">暂无库存数据</text>
          <text class="empty-sub">尝试切换筛选条件</text>
        </view>

        <!-- 库存卡片 -->
        <view v-for="(item, idx) in filteredStock" :key="item.vehicleId"
          class="stock-card" hover-class="card-hover">
          <!-- 左侧彩色竖条 -->
          <view class="color-bar" :class="'cb-' + item.stockStatus"></view>
          <!-- 卡片主体 -->
          <view class="sc-body">
            <!-- 上：名称 + 类型标签 -->
            <view class="sc-top">
              <text class="sc-name">{{ item.name }}</text>
              <view class="type-badge" :class="'tb-' + item.type">
                <text class="tb-text">{{ item.typeLabel }}</text>
              </view>
              <view class="status-tag" :class="'st-' + item.stockStatus">
                <text class="st-text">{{ item.status }}</text>
              </view>
            </view>
            <!-- 中：库存大字 + 已售 -->
            <view class="sc-middle">
              <view class="stock-big">
                <text class="stock-number" :class="'sn-' + item.stockStatus">{{ item.stock }}</text>
                <text class="stock-unit">台</text>
              </view>
              <view class="sold-info">
                <text class="sold-label">已售</text>
                <text class="sold-num">{{ item.sold }}</text>
                <text class="sold-unit">台</text>
              </view>
            </view>
            <!-- 下：入库时间 + 操作按钮 -->
            <view class="sc-bottom">
              <text class="time-text">最近入库：{{ item.lastInTime }}</text>
              <view class="action-row">
                <view class="act-btn act-in" hover-class="act-hover" @tap.stop="doIn(item)">
                  <text class="act-text">＋入库</text>
                </view>
                <view class="act-btn act-out" hover-class="act-hover" @tap.stop="doOut(item)">
                  <text class="act-text">－出库</text>
                </view>
                <view class="act-btn act-edit" hover-class="act-hover" @tap.stop="doEdit(item)">
                  <text class="act-text">编辑</text>
                </view>
              </view>
            </view>
          </view>
        </view>
      </view>

      <view style="height: 140rpx;"></view>
    </scroll-view>

    <!-- 右下角FAB快速入库按钮 -->
    <view class="fab-btn" hover-class="fab-hover" @tap="quickIn">
      <text class="fab-icon">＋</text>
      <text class="fab-label">快速入库</text>
    </view>
  </view>
</template>

<script>
export default {
  data: function() {
    return {
      isReady: false,
      glowRows: [],
      activeTab: 0,
      tabs: ['全部', '库存充足', '库存紧张', '缺货'],

      mockStocks: [
        { vehicleId: 1, name: '比亚迪海豹 EV 700km 四驱旗舰版', type: 'ev', typeLabel: '纯电动',
          stock: 5, sold: 23, minStock: 3, lastInTime: '2026-06-01', status: '充足' },
        { vehicleId: 2, name: '特斯拉 Model Y 后驱版', type: 'ev', typeLabel: '纯电动',
          stock: 3, sold: 18, minStock: 3, lastInTime: '2026-05-30', status: '紧张' },
        { vehicleId: 3, name: '蔚来 ES6 75kWh 运动版', type: 'ev', typeLabel: '纯电动',
          stock: 2, sold: 12, minStock: 2, lastInTime: '2026-05-28', status: '紧张' },
        { vehicleId: 5, name: '比亚迪汉 DM-i 冠军版', type: 'phev', typeLabel: '插电混动',
          stock: 6, sold: 31, minStock: 3, lastInTime: '2026-06-02', status: '充足' },
        { vehicleId: 4, name: '理想 L7 Pro 增程版', type: 'erev', typeLabel: '增程式',
          stock: 4, sold: 8, minStock: 2, lastInTime: '2026-05-29', status: '充足' },
        { vehicleId: 6, name: '问界 M5 纯电版', type: 'ev', typeLabel: '纯电动',
          stock: 0, sold: 15, minStock: 2, lastInTime: '2026-05-20', status: '缺货' }
      ]
    }
  },

  computed: {
    /* 计算每辆车的库存状态码 */
    enrichedStocks: function() {
      var that = this
      return that.mockStocks.map(function(item) {
        var s = item.stock
        var code = s >= 5 ? 'ok' : (s >= 1 ? 'warn' : 'empty')
        return Object.assign({}, item, { stockStatus: code })
      })
    },

    /* 筛选后的列表 */
    filteredStock: function() {
      var that = this
      var list = that.enrichedStocks
      if (that.activeTab === 1) list = list.filter(function(i) { return i.stockStatus === 'ok' })
      if (that.activeTab === 2) list = list.filter(function(i) { return i.stockStatus === 'warn' })
      if (that.activeTab === 3) list = list.filter(function(i) { return i.stockStatus === 'empty' })
      return list
    },

    /* 统计数据 */
    totalModels: function() { return this.mockStocks.length },
    totalStock: function() {
      var sum = 0
      for (var i = 0; i < this.mockStocks.length; i++) sum += this.mockStocks[i].stock
      return sum
    },
    lowCount: function() {
      var c = 0
      for (var i = 0; i < this.mockStocks.length; i++) {
        if (this.mockStocks[i].stock < this.mockStocks[i].minStock) c++
      }
      return c
    }
  },

  created: function() {
    this.buildGlowRows()
    var that = this
    setTimeout(function() { that.isReady = true }, 200)
  },

  methods: {
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

    switchTab: function(idx) { this.activeTab = idx },

    goBack: function() { uni.navigateBack({ delta: 1 }) },

    doIn: function(item) {
      var that = this
      uni.showModal({
        title: '入库操作',
        content: '请输入「' + item.name + '」的入库数量：',
        editable: true,
        placeholderText: '请输入数量',
        success: function(res) {
          if (res.confirm && res.content) {
            var num = parseInt(res.content)
            if (!isNaN(num) && num > 0) {
              item.stock += num
              item.lastInTime = '2026-06-04'
              uni.showToast({ title: '已入库 ' + num + ' 台', icon: 'success' })
            } else {
              uni.showToast({ title: '请输入有效数量', icon: 'none' })
            }
          }
        }
      })
    },

    doOut: function(item) {
      var that = this
      if (item.stock <= 0) {
        uni.showToast({ title: '当前库存不足', icon: 'none' })
        return
      }
      uni.showModal({
        title: '出库操作',
        content: '请输入「' + item.name + '」的出库数量（当前库存 ' + item.stock + ' 台）：',
        editable: true,
        placeholderText: '请输入数量',
        success: function(res) {
          if (res.confirm && res.content) {
            var num = parseInt(res.content)
            if (!isNaN(num) && num > 0 && num <= item.stock) {
              item.stock -= num
              item.sold += num
              uni.showToast({ title: '已出库 ' + num + ' 台', icon: 'success' })
            } else {
              uni.showToast({ title: '数量无效或超出库存', icon: 'none' })
            }
          }
        }
      })
    },

    doEdit: function(item) {
      uni.showToast({ title: '编辑：' + item.name, icon: 'none' })
    },

    quickIn: function() {
      uni.showModal({
        title: '快速入库',
        content: '请选择要入库的车型或输入新增信息：',
        showCancel: true,
        confirmText: '选择车型',
        cancelText: '取消',
        success: function(res) {
          if (res.confirm) {
            uni.showToast({ title: '请从列表中选择车型入库', icon: 'none' })
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
.page-ready .stock-card {
  animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards;
}
.page-ready .stock-card:nth-child(1) { animation-delay: 0.06s; }
.page-ready .stock-card:nth-child(2) { animation-delay: 0.12s; }
.page-ready .stock-card:nth-child(3) { animation-delay: 0.18s; }
.page-ready .stock-card:nth-child(4) { animation-delay: 0.24s; }
.page-ready .stock-card:nth-child(5) { animation-delay: 0.30s; }
.page-ready .stock-card:nth-child(6) { animation-delay: 0.36s; }

@keyframes fadeSlideUp {
  from { opacity: 0; transform: translateY(30rpx) scale(0.96); }
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
  50% { opacity: 0.6; }
  100% { opacity: 0.15; transform: scale(1.25); }
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
  -webkit-backdrop-filter: blur(12px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2;
  box-shadow: 0 4rpx 14rpx rgba(0, 0, 0, 0.1);
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

/* ========== 统计概览条 ========== */
.overview-section {
  position: relative;
  z-index: 3;
  padding: 10rpx 24rpx 16rpx;
}
.overview-row {
  display: flex;
  gap: 14rpx;
}
.overview-card {
  flex: 1;
  background: rgba(255, 255, 255, 0.82);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  border-radius: 20rpx;
  padding: 18rpx 12rpx;
  text-align: center;
  box-shadow: 0 4rpx 16rpx rgba(245, 158, 11, 0.08),
    inset 0 1rpx 0 rgba(255, 255, 255, 0.9);
  border: 1rpx solid rgba(255, 255, 255, 0.75);
  border-top: 4rpx solid #f59e0b;
}
.oc-stock { border-top-color: #22c55e; }
.oc-warn { border-top-color: #ef4444; }
.oc-num {
  font-size: 34rpx;
  font-weight: 800;
  display: block;
  color: #f59e0b;
}
.oc-stock .oc-num { color: #22c55e; }
.oc-warn .oc-num { color: #ef4444; }
.oc-label {
  font-size: 21rpx;
  color: #78716c;
  margin-top: 4rpx;
  display: block;
  font-weight: 600;
}

/* ========== Tab切换栏 ========== */
.tab-bar {
  position: relative;
  z-index: 3;
  white-space: nowrap;
  padding-bottom: 8rpx;
}
.tab-inner {
  display: inline-flex;
  padding: 16rpx 24rpx;
}
.tab-chip {
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
.tab-chip.active {
  background: linear-gradient(135deg, #f59e0b, #f97316);
  box-shadow: 0 6rpx 20rpx rgba(245, 158, 11, 0.35);
  border-color: transparent;
}
.tab-text {
  font-size: 26rpx;
  color: #44403c;
  font-weight: 600;
  letter-spacing: 0.5rpx;
}
.tab-chip.active .tab-text {
  color: #ffffff;
  font-weight: 700;
}

/* ========== 库存卡片列表区域 ========== */
.stock-area {
  padding: 8rpx 24rpx 40rpx;
  position: relative;
  z-index: 2;
}

/* 空状态 */
.empty-box {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 200rpx 0 160rpx;
}
.empty-icon-wrap {
  width: 150rpx; height: 150rpx;
  border-radius: 50%;
  background: linear-gradient(135deg, rgba(245,158,11,0.12), rgba(249,115,22,0.08));
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 28rpx;
  box-shadow: 0 8rpx 32rpx rgba(245, 158, 11, 0.15);
}
.empty-icon { font-size: 60rpx; }
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

/* 库存卡片 */
.stock-card {
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(18px);
  -webkit-backdrop-filter: blur(18px);
  border-radius: 24rpx;
  margin-bottom: 22rpx;
  box-shadow: 0 8rpx 32rpx rgba(0, 0, 0, 0.06),
    0 2rpx 8rpx rgba(245, 158, 11, 0.05),
    inset 0 1rpx 0 rgba(255, 255, 255, 0.9);
  border: 1rpx solid rgba(255, 255, 255, 0.8);
  position: relative;
  overflow: hidden;
  transition: all 0.35s cubic-bezier(0.34, 1.56, 0.64, 1);
  display: flex;
  flex-direction: row;
}

/* 左侧彩色竖条 */
.color-bar {
  position: absolute;
  left: 0; top: 0; bottom: 0;
  width: 6rpx;
  border-radius: 24rpx 0 0 24rpx;
  transition: all 0.35s ease;
  z-index: 3;
}
.cb-ok {
  background: linear-gradient(180deg, #22c55e, #4ade80);
  box-shadow: 2rpx 0 14rpx rgba(34, 197, 94, 0.28);
}
.cb-warn {
  background: linear-gradient(180deg, #f59e0b, #fbbf24);
  box-shadow: 2rpx 0 14rpx rgba(245, 158, 11, 0.35);
}
.cb-empty {
  background: linear-gradient(180deg, #ef4444, #f87171);
  box-shadow: 2rpx 0 14rpx rgba(239, 68, 68, 0.35);
}

.card-hover {
  transform: scale(0.97) translateY(-2rpx)!important;
  box-shadow: 0 16rpx 48rpx rgba(0, 0, 0, 0.12)!important,
    0 8rpx 24rpx rgba(245, 158, 11, 0.1)!important;
  border-color: rgba(245, 158, 11, 0.2)!important;
}
.card-hover .color-bar {
  width: 9rpx;
}

.sc-body {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: 22rpx 22rpx 22rpx 28rpx;
  position: relative;
  z-index: 2;
}

/* 上：名称 + 类型标签 + 状态标签 */
.sc-top {
  display: flex;
  align-items: center;
  gap: 10rpx;
  flex-wrap: wrap;
  margin-bottom: 14rpx;
}
.sc-name {
  font-size: 27rpx;
  font-weight: 800;
  color: #1c1917;
  line-height: 1.3;
  letter-spacing: 0.5rpx;
}
.type-badge {
  border-radius: 10rpx;
  padding: 5rpx 14rpx;
  flex-shrink: 0;
  font-weight: 700;
}
.tb-ev {
  background: linear-gradient(135deg, rgba(34,197,94,0.12), rgba(74,222,128,0.06));
  color: #16a34a;
  border: 1rpx solid rgba(34, 197, 94, 0.2);
}
.tb-phev {
  background: linear-gradient(135deg, rgba(245,158,11,0.12), rgba(251,146,60,0.06));
  color: #d97706;
  border: 1rpx solid rgba(245, 158, 11, 0.2);
}
.tb-erev {
  background: linear-gradient(135deg, rgba(251,146,60,0.12), rgba(251,191,36,0.06));
  color: #f59e0b;
  border: 1rpx solid rgba(251, 146, 60, 0.2);
}
.tb-text { font-size: 20rpx; }

.status-tag {
  border-radius: 10rpx;
  padding: 5rpx 14rpx;
  flex-shrink: 0;
  font-weight: 700;
}
.st-ok {
  background: linear-gradient(135deg, rgba(34,197,94,0.12), rgba(74,222,128,0.06));
  color: #16a34a;
  border: 1rpx solid rgba(34, 197, 94, 0.2);
}
.st-warn {
  background: linear-gradient(135deg, rgba(245,158,11,0.12), rgba(251,191,36,0.06));
  color: #d97706;
  border: 1rpx solid rgba(245, 158, 11, 0.2);
}
.st-empty {
  background: linear-gradient(135deg, rgba(239,68,68,0.12), rgba(248,113,113,0.06));
  color: #dc2626;
  border: 1rpx solid rgba(239, 68, 68, 0.2);
}
.st-text { font-size: 20rpx; }

/* 中：库存大字 + 已售 */
.sc-middle {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  padding: 12rpx 0 14rpx;
  border-bottom: 1rpx solid rgba(0, 0, 0, 0.04);
}
.stock-big {
  display: flex;
  align-items: baseline;
}
.stock-number {
  font-size: 52rpx;
  font-weight: 800;
  letter-spacing: -1rpx;
}
.sn-ok { color: #22c55e; }
.sn-warn { color: #f59e0b; }
.sn-empty { color: #ef4444; }
.stock-unit {
  font-size: 24rpx;
  color: #a8a29e;
  margin-left: 6rpx;
  font-weight: 600;
}
.sold-info {
  display: flex;
  align-items: baseline;
  gap: 4rpx;
}
.sold-label { font-size: 22rpx; color: #a8a29e; }
.sold-num { font-size: 28rpx; color: #44403c; font-weight: 700; }
.sold-unit { font-size: 20rpx; color: #a8a29e; }

/* 下：入库时间 + 操作按钮 */
.sc-bottom {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-top: 14rpx;
}
.time-text {
  font-size: 21rpx;
  color: #a8a29e;
  font-weight: 500;
}
.action-row {
  display: flex;
  gap: 10rpx;
}
.act-btn {
  padding: 8rpx 18rpx;
  border-radius: 20rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.25s ease;
}
.act-in {
  background: linear-gradient(135deg, rgba(217,119,6,0.1), rgba(245,158,11,0.05));
  border: 1rpx solid rgba(217, 119, 6, 0.25);
}
.act-out {
  background: linear-gradient(135deg, rgba(245,158,11,0.1), rgba(251,191,36,0.05));
  border: 1rpx solid rgba(245, 158, 11, 0.25);
}
.act-edit {
  background: linear-gradient(135deg, rgba(251,146,60,0.1), rgba(251,191,36,0.05));
  border: 1rpx solid rgba(251, 146, 60, 0.25);
}
.act-hover { transform: scale(0.92); }
.act-in .act-text { color: #d97706; font-size: 21rpx; font-weight: 700; }
.act-out .act-text { color: #d97706; font-size: 21rpx; font-weight: 700; }
.act-edit .act-text { color: #f59e0b; font-size: 21rpx; font-weight: 700; }

/* ========== FAB浮动按钮 ========== */
.fab-btn {
  position: fixed;
  right: 32rpx;
  bottom: 60rpx;
  z-index: 99;
  display: flex;
  align-items: center;
  gap: 8rpx;
  padding: 20rpx 32rpx;
  border-radius: 50rpx;
  background: linear-gradient(135deg, #f59e0b, #f97316);
  box-shadow: 0 8rpx 28rpx rgba(245, 158, 11, 0.45),
    0 2rpx 8rpx rgba(245, 158, 11, 0.25);
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.fab-hover {
  transform: scale(0.95) translateY(-4rpx);
  box-shadow: 0 14rpx 40rpx rgba(245, 158, 11, 0.55),
    0 4rpx 12rpx rgba(245, 158, 11, 0.3);
}
.fab-icon {
  font-size: 32rpx;
  color: #ffffff;
  font-weight: 800;
}
.fab-label {
  font-size: 26rpx;
  color: #ffffff;
  font-weight: 700;
  letter-spacing: 1rpx;
}
</style>
