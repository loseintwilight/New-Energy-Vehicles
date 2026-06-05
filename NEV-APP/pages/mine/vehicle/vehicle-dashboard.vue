<template>
  <view class="page" :class="{ 'page-ready': isReady }">
    <!-- 背景光晕矩阵（琥珀暖色系） -->
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
      <!-- ① 顶栏（与charge-pile dashboard视觉对齐） -->
      <view class="header">
        <view class="header-bg"></view>
        <view class="header-circle"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="header-info">
          <text class="header-title">车辆管理</text>
          <text class="header-sub">{{ merchantName }}</text>
        </view>
        <view class="header-merchant" v-if="merchantName">
          <view class="merchant-avatar-vehicle">
            <text class="merchant-avatar-text-v">{{ merchantName.substring(0, 1) }}</text>
          </view>
          <text class="merchant-name-text-v">{{ merchantName }}</text>
        </view>
        <view class="header-right" @tap="showMoreModal = true">
          <view class="more-badge">
            <text class="more-icon">☰</text>
          </view>
        </view>
      </view>

      <!-- ② 4栏统计卡 -->
      <view class="stats-section">
        <view class="stats-row">
          <view
            class="stat-card"
            v-for="(item, idx) in statsData"
            :key="idx"
            :class="'stat-' + idx"
            hover-class="stat-hover"
            @tap="onStatTap(idx)"
          >
            <view class="stat-glow-bar"></view>
            <view class="stat-icon-wrap">
              <text class="stat-icon-text">{{ item.icon }}</text>
            </view>
            <text class="stat-value">{{ item.value }}</text>
            <text class="stat-label">{{ item.label }}</text>
          </view>
        </view>
      </view>

      <!-- ③ 快捷管理 - 4大功能卡 + 更多 -->
      <view class="section-block">
        <view class="title-bar">
          <view class="bar-line"></view>
          <text class="bar-title">快捷管理</text>
          <view class="title-badge">4</view>
        </view>
        <view class="quick-list">
          <view class="quick-row" v-for="(row, ri) in quickMainRows" :key="ri">
            <view
              class="quick-main-card"
              v-for="(item, ci) in row"
              :key="ci"
              :class="'qmc-' + item.colorIdx"
              hover-class="qmc-hover"
              @tap="goPage(item.path)"
            >
              <view class="qmc-left">
                <view class="qmc-icon-wrap">
                  <text class="qmc-icon">{{ item.icon }}</text>
                </view>
              </view>
              <view class="qmc-body">
                <text class="qmc-name">{{ item.name }}</text>
                <text class="qmc-desc">{{ item.desc }}</text>
              </view>
              <view class="qmc-arrow">
                <text class="qmc-arrow-icon">›</text>
              </view>
            </view>
          </view>
          <view class="quick-more-card" hover-class="qmc-hover" @tap="showMoreModal = true">
            <view class="qmc-left qmc-more-left">
              <view class="qmc-icon-wrap qmc-more-icon-wrap">
                <text class="qmc-icon qmc-plus">+</text>
              </view>
            </view>
            <view class="qmc-body">
              <text class="qmc-name qmc-more-name">更多管理</text>
              <text class="qmc-desc qmc-more-desc">{{ moreMenuList.length }}项功能 · 金融方案 · 客户评价 · 价格管理</text>
            </view>
            <view class="qmc-arrow">
              <text class="qmc-arrow-icon">›</text>
            </view>
          </view>
        </view>
      </view>

      <!-- ④ 最近订单 -->
      <view class="section-block">
        <view class="title-bar">
          <view class="bar-line bar-line-orange"></view>
          <text class="bar-title">最近订单</text>
          <view class="bar-more" @tap="goOrderList">
            <text class="bar-more-text">更多</text>
            <text class="bar-more-icon">›</text>
          </view>
        </view>
        <view class="order-list">
          <view
            class="order-card"
            v-for="(od, idx) in recentOrders"
            :key="idx"
            hover-class="order-hover"
            @tap="goOrderDetail(od.orderId)"
          >
            <view class="order-left-bar"></view>
            <view class="order-body">
              <view class="order-top">
                <view class="order-no">
                  <text class="order-no-text">{{ od.orderId.substring(0, 14) }}...</text>
                </view>
                <view :class="['order-status', 'os-' + od.status]">
                  <text>{{ od.statusText }}</text>
                </view>
              </view>
              <view class="order-mid">
                <text class="order-car">🚗 {{ od.vehicleName }}</text>
                <text class="order-customer">👤 {{ od.customerName }}</text>
                <text class="order-time">🕐 {{ od.time }}</text>
              </view>
              <view class="order-bottom">
                <text class="amount-lbl">成交金额</text>
                <text class="amount-val">¥{{ formatMoney(od.amount) }}</text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <!-- ⑤ 库存预警（已移入库存管理入口，此处不再单独展示） -->
      <!-- <view class="section-block" v-if="stockWarnings.length > 0">
        <view class="title-bar">
          <view class="bar-line bar-line-warn"></view>
          <text class="bar-title">库存预警</text>
          <view class="warn-badge">{{ stockWarnings.length }}</view>
        </view>
        <view class="warn-list">
          <view
            class="warn-card"
            v-for="(sw, idx) in stockWarnings"
            :key="idx"
            hover-class="warn-hover"
            @tap="goStockManage"
          >
            <view class="warn-left-bar"></view>
            <view class="warn-body">
              <view class="warn-top">
                <text class="warn-car-name">{{ sw.vehicleName }}</text>
                <view class="warn-tag">
                  <text class="warn-tag-text">库存不足</text>
                </view>
              </view>
              <view class="warn-info">
                <text class="warn-current">当前库存: <text class="warn-num" :class="sw.stock === 0 ? 'num-zero' : ''">{{ sw.stock }}</text></text>
                <text class="warn-min">最低要求: {{ sw.minStock }}</text>
              </view>
            </view>
            <text class="warn-arrow">›</text>
          </view>
        </view>
      <!-- </view> -->

      <view style="height: 100rpx;"></view>
    </scroll-view>

    <!-- 更多管理弹窗 -->
    <view class="modal-mask" v-if="showMoreModal" @tap="showMoreModal = false"></view>
    <view :class="['modal-panel', showMoreModal ? 'modal-show' : '']">
      <view class="modal-handle"></view>
      <view class="modal-header">
        <text class="modal-title">更多管理</text>
        <view class="modal-close" @tap="showMoreModal = false">
          <text>✕</text>
        </view>
      </view>
      <scroll-view scroll-y class="modal-scroll">
        <view class="menu-list">
          <view
            class="menu-item"
            v-for="(item, idx) in moreMenuList"
            :key="idx"
            :class="'menu-' + (idx % 5)"
            hover-class="menu-hover"
            @tap="onMenuTap(item)"
          >
            <view class="menu-color-bar"></view>
            <view class="menu-icon-wrap">
              <text class="menu-icon" :class="'mi-' + (idx % 5)">{{ item.icon }}</text>
            </view>
            <view class="menu-info">
              <text class="menu-name">{{ item.name }}</text>
              <text class="menu-desc">{{ item.desc }}</text>
            </view>
            <text class="menu-arrow">›</text>
          </view>
        </view>
      </scroll-view>
    </view>
  </view>
</template>

<script>
export default {
  data: function() {
    return {
      isReady: false,
      merchantName: '',
      glowRows: [],
      showMoreModal: false,
      /* 4栏统计卡数据（与vehicle-list mockVehicles保持一致：6辆车） */
      statsData: [
        { icon: '🚗', value: '6', label: '车辆总数' },
        { icon: '📋', value: '3', label: '今日订单' },
        { icon: '¥', value: '15.86万', label: '今日营收(元)' },
        { icon: '⭐', value: '4.8', label: '平均好评率' }
      ],
      /* 4大功能卡片（2×2布局） */
      quickMain: [
        { icon: '🚗', name: '车辆列表', desc: '6辆车 · 在售管理', colorIdx: 0, path: '/pages/mine/vehicle/vehicle-list' },
        { icon: '📋', name: '订单中心', desc: '3笔订单 · 实时跟踪', colorIdx: 1, path: '/pages/mine/vehicle/vehicle-order-list' },
        { icon: '📦', name: '库存管理', desc: '2项预警 · 补货提醒', colorIdx: 2, path: '/pages/mine/vehicle/stock-manage' },
        { icon: '🔧', name: '价格管理', desc: '6辆车 · 折扣策略', colorIdx: 3, path: '/pages/mine/vehicle/price-manage' }
      ],
      /* 最近订单 */
      recentOrders: [],
      /* 库存预警 */
      stockWarnings: [],
      /* 更多管理菜单（弹窗内展示） */
      moreMenuList: [
        { icon: '➕', name: '新增车辆', desc: '添加新车型到库', path: '/pages/mine/vehicle/vehicle-add' },
        { icon: '💰', name: '价格管理', desc: '设置车辆售价策略', path: '/pages/mine/vehicle/price-manage' },
        { icon: '🏦', name: '金融方案', desc: '分期付款方案管理', path: '/pages/mine/vehicle/finance-list' },
        { icon: '⭐', name: '客户评价', desc: '用户评价与回复', path: '/pages/mine/vehicle/review-list' },
        { icon: '🔁', name: '二手车管理', desc: '电池检测 · 估价 · 认证车', path: '/pages/mine/vehicle/used-car-list' },
        { icon: '◆', name: '商户资料', desc: '企业信息 · 资质认证', path: '/pages/mine/charge-pile/merchant-info' },
        { icon: '○', name: '系统设置', desc: '通知 · 安全 · 关于', path: '/pages/mine/charge-pile/system-settings' }
        /* 注：商户资料和系统设置为全局共享页面，暂放在charge-pile目录下 */
      ]
    }
  },
  created: function() {
    this.buildGlowRows()
    this.loadMerchantInfo()
    this.loadDashboardData()
    var that = this
    setTimeout(function() {
      that.isReady = true
    }, 200)
  },
  computed: {
    quickMainRows: function() {
      var list = this.quickMain || []
      return [
        [list[0], list[1]],
        [list[2], list[3]]
      ]
    }
  },
  methods: {
    goPage: function(url) {
      if (!url) return
      uni.navigateTo({ url: url })
    },
    /* ---------- 初始化 ---------- */
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

    loadMerchantInfo: function() {
      try {
        var userInfo = uni.getStorageSync('userInfo') || {}
        this.merchantName = userInfo.merchantName || '新能源车行'
      } catch (e) {
        this.merchantName = '新能源车行'
      }
    },

    /* ---------- 数据加载 ---------- */
    loadDashboardData: function() {
      this.loadRecentOrders()
      this.loadStockWarnings()
    },

    loadRecentOrders: function() {
      var USE_MOCK = true
      if (USE_MOCK) {
        this.recentOrders = [
          { orderId: 'VO20260531000001', vehicleName: '比亚迪海豹 EV 700km 四驱旗舰版', customerName: '张**', amount: 228000, status: '1', statusText: '已完成', time: '10:30' },
          { orderId: 'VO20260530000005', vehicleName: '特斯拉 Model Y 后驱版', customerName: '李**', amount: 263900, status: '0', statusText: '待交付', time: '16:20' },
          { orderId: 'VO20260529000003', vehicleName: '蔚来 ES6 75kWh 运动版', customerName: '王**', amount: 338000, status: '1', statusText: '已完成', time: '09:15' }
        ]
      }
    },

    loadStockWarnings: function() {
      var USE_MOCK = true
      if (USE_MOCK) {
        this.stockWarnings = [
          { vehicleName: '比亚迪汉EV 冠军版 605km', stock: 1, minStock: 3 },
          { vehicleName: '小鹏P7i 702 Max', stock: 0, minStock: 2 }
        ]
      }
    },

    /* ---------- 工具方法 ---------- */
    formatMoney: function(amount) {
      if (amount === null || amount === undefined) return '0.00'
      return Number(amount).toLocaleString('zh-CN')
    },

    /* ---------- 页面跳转 ---------- */
    goBack: function() {
      uni.navigateBack({ delta: 1 })
    },

    onStatTap: function(idx) {
      var urls = [
        '/pages/mine/vehicle/vehicle-list',
        '/pages/mine/vehicle/vehicle-order-list',
        '/pages/mine/vehicle/finance-list',
        '/pages/mine/vehicle/stock-manage'
      ]
      if (urls[idx]) {
        uni.navigateTo({ url: urls[idx] })
      }
    },

    goOrderList: function() {
      uni.navigateTo({ url: '/pages/mine/vehicle/vehicle-order-list' })
    },

    goOrderDetail: function(orderId) {
      if (!orderId) return
      uni.navigateTo({ url: '/pages/mine/vehicle/vehicle-order-detail?orderId=' + orderId })
    },

    goStockManage: function() {
      uni.navigateTo({ url: '/pages/mine/vehicle/stock-manage' })
    },

    onMenuTap: function(item) {
      this.showMoreModal = false
      if (!item.path) {
        this.$store.commit('SET_CURRENT_END', 'user')
        this.$tab.switchTab('/pages/mine/index')
        return
      }
      uni.navigateTo({ url: item.path })
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
.page-ready .stat-card { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; }
.page-ready .quick-main-card { animation: fadeSlideUp 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; }
.page-ready .quick-more-card { animation: fadeSlideUp 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; }
.page-ready .order-card { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; }
.page-ready .quick-main-card { animation: fadeSlideUp 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; }
.page-ready .quick-more-card { animation: fadeSlideUp 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; }
.page-ready .order-card { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; }

.page-ready .stat-card:nth-child(1) { animation-delay: 0.05s; }
.page-ready .stat-card:nth-child(2) { animation-delay: 0.1s; }
.page-ready .stat-card:nth-child(3) { animation-delay: 0.15s; }
.page-ready .stat-card:nth-child(4) { animation-delay: 0.2s; }
.page-ready .quick-main-card:nth-child(1) { animation-delay: 0.22s; }
.page-ready .quick-main-card:nth-child(2) { animation-delay: 0.26s; }
.page-ready .quick-main-card:nth-child(3) { animation-delay: 0.30s; }
.page-ready .quick-main-card:nth-child(4) { animation-delay: 0.34s; }
.page-ready .quick-more-card { animation-delay: 0.38s; }
.page-ready .order-card:nth-child(1) { animation-delay: 0.56s; }
.page-ready .order-card:nth-child(2) { animation-delay: 0.62s; }
.page-ready .order-card:nth-child(3) { animation-delay: 0.68s; }

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

/* ========== ① 顶栏 ========== */
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
.more-badge {
  width: 64rpx;
  height: 64rpx;
  border-radius: 18rpx;
  background: rgba(255, 255, 255, 0.28);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4rpx 14rpx rgba(0, 0, 0, 0.08);
}
.more-icon {
  font-size: 32rpx;
  color: #ffffff;
  font-weight: 700;
}

/* 商家信息 */
.header-merchant {
  display: flex;
  align-items: center;
  z-index: 2;
  margin-left: 16rpx;
  gap: 12rpx;
}
.merchant-avatar-vehicle {
  width: 52rpx;
  height: 52rpx;
  border-radius: 50%;
  background: rgba(0, 0, 0, 0.18);
  display: flex;
  align-items: center;
  justify-content: center;
  border: 2rpx solid rgba(0, 0, 0, 0.3);
}
.merchant-avatar-text-v {
  font-size: 24rpx;
  font-weight: 800;
  color: #1c1917;
}
.merchant-name-text-v {
  font-size: 26rpx;
  font-weight: 700;
  color: #1c1917;
  max-width: 200rpx;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* ========== ② 4栏统计卡 ========== */
.stats-section {
  padding: 24rpx 24rpx 16rpx;
  position: relative;
  z-index: 2;
}
.stats-row {
  display: flex;
  flex-direction: row;
  gap: 14rpx;
}
.stat-card {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 22rpx 8rpx 18rpx;
  border-radius: 22rpx;
  position: relative;
  overflow: hidden;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  box-shadow: 0 6rpx 24rpx rgba(0, 0, 0, 0.07), inset 0 1rpx 0 rgba(255, 255, 255, 0.3);
}
.stat-hover {
  transform: scale(0.95) translateY(-4rpx);
  box-shadow: 0 14rpx 36rpx rgba(0, 0, 0, 0.13);
}
.stat-glow-bar {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 5rpx;
  box-shadow: 0 0 16rpx currentColor;
  opacity: 0.65;
}
/* 统计卡渐变色 - 统一琥珀橙色系（深→中→浅→淡） */
.stat-0 { background: linear-gradient(145deg, #d97706 0%, #f59e0b 50%, #fb923c 100%); }
.stat-1 { background: linear-gradient(145deg, #f59e0b 0%, #fb923c 50%, #fbbf24 100%); }
.stat-2 { background: linear-gradient(145deg, #d97706 0%, #f59e0b 50%, #fb923c 100%); }
.stat-3 { background: linear-gradient(145deg, #f59e0b 0%, #fb923c 50%, #fbbf24 100%); }
/* 发光条颜色 */
.stat-0 .stat-glow-bar { background: linear-gradient(180deg, #fff 0%, rgba(255,255,255,0.3) 100%); color: #d97706; }
.stat-1 .stat-glow-bar { background: linear-gradient(180deg, #fff 0%, rgba(255,255,255,0.3) 100%); color: #f59e0b; }
.stat-2 .stat-glow-bar { background: linear-gradient(180deg, #fff 0%, rgba(255,255,255,0.3) 100%); color: #fbbf24; }
.stat-3 .stat-glow-bar { background: linear-gradient(180deg, #fff 0%, rgba(255,255,255,0.3) 100%); color: #d97706; }

.stat-icon-wrap {
  width: 64rpx;
  height: 64rpx;
  border-radius: 18rpx;
  background: rgba(255, 255, 255, 0.28);
  margin-bottom: 10rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.1);
}
.stat-icon-text {
  font-size: 34rpx;
  font-weight: 900;
  color: #ffffff;
}
.stat-value {
  font-size: 30rpx;
  font-weight: 900;
  color: #ffffff;
  letter-spacing: 0.5rpx;
  text-shadow: 0 2rpx 6rpx rgba(0, 0, 0, 0.1);
}
.stat-label {
  font-size: 20rpx;
  color: rgba(255, 255, 255, 0.88);
  font-weight: 600;
  margin-top: 4rpx;
}

/* ========== 区块通用 ========== */
.section-block {
  margin: 0 24rpx 20rpx;
  background: rgba(255, 255, 255, 0.82);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border-radius: 24rpx;
  padding: 24rpx 22rpx;
  box-shadow: 0 6rpx 28rpx rgba(0, 0, 0, 0.05), inset 0 1rpx 0 rgba(255, 255, 255, 0.9);
  border: 1rpx solid rgba(255, 255, 255, 0.8);
  position: relative;
  z-index: 2;
}
.title-bar {
  display: flex;
  flex-direction: row;
  align-items: center;
  margin-bottom: 20rpx;
}
.bar-line {
  width: 7rpx;
  height: 32rpx;
  border-radius: 4rpx;
  margin-right: 12rpx;
  background: linear-gradient(180deg, #f59e0b, #f97316);
  box-shadow: 0 0 12rpx rgba(245, 158, 11, 0.35);
}
.bar-line-orange { background: linear-gradient(180deg, #d97706, #f59e0b); box-shadow: 0 0 12rpx rgba(217,119,6,0.35); }
.bar-line-warn { background: linear-gradient(180deg, #fb923c, #f97316); box-shadow: 0 0 12rpx rgba(251,146,60,0.35); }
.bar-title {
  font-size: 30rpx;
  font-weight: 800;
  color: #1c1917;
  flex: 1;
  letter-spacing: 0.5rpx;
}
.title-badge {
  min-width: 34rpx;
  height: 34rpx;
  line-height: 34rpx;
  text-align: center;
  background: linear-gradient(135deg, #f59e0b, #f97316);
  color: #fff;
  font-size: 20rpx;
  font-weight: 800;
  border-radius: 10rpx;
  padding: 0 8rpx;
  margin-left: 10rpx;
}
.warn-badge {
  min-width: 34rpx;
  height: 34rpx;
  line-height: 34rpx;
  text-align: center;
  background: linear-gradient(135deg, #f97316, #ea580c);
  color: #fff;
  font-size: 20rpx;
  font-weight: 800;
  border-radius: 10rpx;
  padding: 0 8rpx;
  margin-left: 10rpx;
}
.bar-more {
  display: flex;
  align-items: center;
  padding: 6rpx 12rpx;
  border-radius: 12rpx;
}
.bar-more-text {
  font-size: 24rpx;
  color: #d97706;
  font-weight: 600;
}
.bar-more-icon {
  font-size: 26rpx;
  color: #d97706;
  font-weight: 700;
  margin-left: 2rpx;
}

/* ========== ③ 快捷管理 - 4大卡片 + 更多 ========== */
.quick-list {
  display: flex;
  flex-direction: column;
  gap: 14rpx;
}
.quick-row {
  display: flex;
  gap: 14rpx;
}
.quick-main-card {
  flex: 1;
  display: flex;
  align-items: center;
  background: rgba(255, 255, 255, 0.88);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border-radius: 20rpx;
  padding: 24rpx 20rpx;
  position: relative;
  overflow: hidden;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.05);
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  border-left: 5rpx solid transparent;
}
.qmc-hover {
  transform: scale(0.97) translateY(-2rpx);
  box-shadow: 0 10rpx 30rpx rgba(0, 0, 0, 0.1);
}
/* 统一琥珀橙色系（深→中→浅→淡，不再花花绿绿） */
.qmc-0 { border-left-color: #d97706; }
.qmc-1 { border-left-color: #f59e0b; }
.qmc-2 { border-left-color: #fb923c; }
.qmc-3 { border-left-color: #fbbf24; }
.qmc-hover.qmc-0 { border-left-color: #b45309; box-shadow: 0 10rpx 30rpx rgba(217,119,6,0.25); }
.qmc-hover.qmc-1 { border-left-color: #d97706; box-shadow: 0 10rpx 30rpx rgba(245,158,11,0.25); }
.qmc-hover.qmc-2 { border-left-color: #f59e0b; box-shadow: 0 10rpx 30rpx rgba(251,146,60,0.25); }
.qmc-hover.qmc-3 { border-left-color: #f97316; box-shadow: 0 10rpx 30rpx rgba(251,191,36,0.25); }

.qmc-left { margin-right: 18rpx; flex-shrink: 0; }
.qmc-icon-wrap {
  width: 72rpx; height: 72rpx; border-radius: 18rpx;
  display: flex; align-items: center; justify-content: center;
}
.qmc-0 .qmc-icon-wrap { background: linear-gradient(135deg, #fef3c7, #fde68a); }
.qmc-1 .qmc-icon-wrap { background: linear-gradient(135deg, #ffedd5, #fed7aa); }
.qmc-2 .qmc-icon-wrap { background: linear-gradient(135deg, #fffbeb, #fef9c3); }
.qmc-3 .qmc-icon-wrap { background: linear-gradient(135deg, #fffffe, #fefce8); }
.qmc-icon { font-size: 36rpx; line-height: 1; }
.qmc-body { flex: 1; display: flex; flex-direction: column; min-width: 0; }
.qmc-name { font-size: 28rpx; font-weight: 700; color: #1c1917; line-height: 1.3; }
.qmc-desc { font-size: 21rpx; color: #a8a29e; margin-top: 4rpx; line-height: 1.3; }
.qmc-arrow { margin-left: 12rpx; flex-shrink: 0; display: flex; align-items: center; }
.qmc-arrow-icon { font-size: 32rpx; color: #d6d3d1; font-weight: 300; }

/* 更多管理入口卡 */
.quick-more-card {
  display: flex; align-items: center;
  background: linear-gradient(135deg, rgba(255,255,255,0.92), rgba(250,250,250,0.95));
  backdrop-filter: blur(16px); -webkit-backdrop-filter: blur(16px);
  border-radius: 20rpx; padding: 24rpx 20rpx;
  position: relative; overflow: hidden;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.04);
  transition: all 0.3s ease;
  border: 1.5rpx dashed #d6d3d1;
  border-left: 5rpx solid #f59e0b;
}
.qmc-more-left .qmc-icon-wrap { width: 64rpx; height: 64rpx; border-radius: 50%; background: linear-gradient(135deg, #fef3c7, #fde68a); }
.qmc-plus { font-size: 32rpx; color: #d97706; font-weight: 700; }
.qmc-more-name { color: #6b7280; }
.qmc-more-desc { color: #b0abaa; }

/* ========== ④ 最近订单 ========== */
.order-list {
  display: flex;
  flex-direction: column;
  gap: 14rpx;
}
.order-card {
  background: rgba(255, 255, 255, 0.88);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  border-radius: 20rpx;
  padding: 20rpx 22rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.04), inset 0 1rpx 0 rgba(255, 255, 255, 0.9);
  border: 1rpx solid rgba(255, 255, 255, 0.8);
  position: relative;
  overflow: hidden;
  transition: all 0.3s ease;
}
.order-hover {
  transform: scale(0.98) translateY(-2rpx);
  box-shadow: 0 10rpx 30rpx rgba(0, 0, 0, 0.09);
  border-color: rgba(249, 115, 22, 0.2);
}
.order-left-bar {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 5rpx;
  background: linear-gradient(180deg, #f97316, #fb923c);
  border-radius: 20rpx 0 0 20rpx;
  box-shadow: 2rpx 0 12rpx rgba(249, 115, 22, 0.2);
  transition: all 0.3s ease;
}
.order-hover .order-left-bar {
  width: 7rpx;
  box-shadow: 4rpx 0 20rpx rgba(249, 115, 22, 0.35);
}
.order-body {
  position: relative;
  z-index: 1;
}
.order-top {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12rpx;
}
.order-no {
  display: flex;
  align-items: center;
}
.order-no-text {
  font-size: 23rpx;
  font-weight: 800;
  color: #292524;
  font-family: monospace;
  letter-spacing: 0.5rpx;
}
.order-status {
  border-radius: 12rpx;
  padding: 6rpx 16rpx;
  font-size: 21rpx;
  font-weight: 700;
  display: flex;
  align-items: center;
}
.os-0 { background: linear-gradient(135deg, rgba(245, 158, 11, 0.12), rgba(251, 146, 60, 0.06)); color: #d97706; border: 1rpx solid rgba(245, 158, 11, 0.2); }
.os-1 { background: linear-gradient(135deg, rgba(34, 197, 94, 0.12), rgba(74, 222, 128, 0.06)); color: #16a34a; border: 1rpx solid rgba(34, 197, 94, 0.2); }
.os-2 { background: linear-gradient(135deg, rgba(107, 114, 128, 0.12), rgba(156, 163, 175, 0.06)); color: #6b7280; border: 1rpx solid rgba(107, 114, 128, 0.2); }

.order-mid {
  display: flex;
  flex-direction: row;
  align-items: center;
  flex-wrap: wrap;
  gap: 10rpx;
  margin-bottom: 12rpx;
}
.order-car, .order-customer, .order-time {
  font-size: 22rpx;
  color: #78716c;
  font-weight: 500;
  padding: 6rpx 12rpx;
  background: linear-gradient(135deg, rgba(250, 251, 252, 0.98), rgba(255, 255, 255, 1));
  border-radius: 10rpx;
  border: 1rpx solid rgba(0, 0, 0, 0.02);
}
.order-bottom {
  display: flex;
  flex-direction: row;
  justify-content: flex-end;
  align-items: center;
  padding-top: 12rpx;
  border-top: 1rpx dashed rgba(0, 0, 0, 0.06);
}
.amount-lbl {
  font-size: 20rpx;
  color: #a8a29e;
  font-weight: 600;
  margin-right: 8rpx;
}
.amount-val {
  font-size: 34rpx;
  font-weight: 900;
  color: #f97316;
  letter-spacing: 0.5rpx;
  text-shadow: 0 2rpx 8rpx rgba(249, 115, 22, 0.15);
}

/* ========== ⑤ 库存预警 ========== */
.warn-list {
  display: flex;
  flex-direction: column;
  gap: 14rpx;
}
.warn-card {
  background: rgba(255, 255, 255, 0.88);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  border-radius: 20rpx;
  padding: 20rpx 22rpx;
  box-shadow: 0 4rpx 20rpx rgba(249, 115, 22, 0.06), inset 0 1rpx 0 rgba(255, 255, 255, 0.9);
  border: 1rpx solid rgba(249, 115, 22, 0.12);
  position: relative;
  overflow: hidden;
  display: flex;
  align-items: center;
  transition: all 0.3s ease;
}
.warn-hover {
  transform: scale(0.98) translateY(-2rpx);
  box-shadow: 0 10rpx 30rpx rgba(249, 115, 22, 0.12);
}
.warn-left-bar {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 5rpx;
  background: linear-gradient(180deg, #f97316, #fb923c);
  border-radius: 20rpx 0 0 20rpx;
  box-shadow: 2rpx 0 12rpx rgba(249, 115, 22, 0.25);
}
.warn-body {
  flex: 1;
  padding-left: 12rpx;
}
.warn-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 8rpx;
}
.warn-car-name {
  font-size: 26rpx;
  font-weight: 800;
  color: #1c1917;
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  margin-right: 12rpx;
}
.warn-tag {
  border-radius: 10rpx;
  padding: 4rpx 12rpx;
  background: linear-gradient(135deg, rgba(249, 115, 22, 0.1), rgba(251, 146, 60, 0.05));
  border: 1rpx solid rgba(249, 115, 22, 0.2);
  flex-shrink: 0;
}
.warn-tag-text {
  font-size: 19rpx;
  font-weight: 700;
  color: #ea580c;
}
.warn-info {
  display: flex;
  align-items: center;
  gap: 16rpx;
}
.warn-current, .warn-min {
  font-size: 21rpx;
  color: #78716c;
  font-weight: 500;
}
.warn-num {
  font-size: 24rpx;
  font-weight: 900;
  color: #16a34a;
}
.num-zero {
  color: #dc2626;
}
.warn-arrow {
  font-size: 28rpx;
  color: #ccc;
  font-weight: 600;
  margin-left: 12rpx;
  flex-shrink: 0;
}

/* ========== 更多管理弹窗 ========== */
.modal-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.45);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
  z-index: 998;
  animation: maskFadeIn 0.25s ease-out;
}
@keyframes maskFadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}
.modal-panel {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(255, 255, 255, 0.97);
  backdrop-filter: blur(24px);
  -webkit-backdrop-filter: blur(24px);
  border-radius: 36rpx 36rpx 0 0;
  z-index: 999;
  transform: translateY(100%);
  transition: transform 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
  max-height: 78vh;
  box-shadow: 0 -10rpx 44rpx rgba(0, 0, 0, 0.12);
  overflow: hidden;
}
.modal-show {
  transform: translateY(0);
}
.modal-handle {
  width: 60rpx;
  height: 6rpx;
  border-radius: 3rpx;
  background: linear-gradient(90deg, #ddd, #eee, #ddd);
  margin: 16rpx auto 20rpx;
}
.modal-header {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  padding: 0 28rpx 20rpx;
  border-bottom: 1rpx solid rgba(0, 0, 0, 0.05);
}
.modal-title {
  font-size: 32rpx;
  font-weight: 900;
  color: #1c1917;
  letter-spacing: 0.5rpx;
}
.modal-close {
  width: 52rpx;
  height: 52rpx;
  line-height: 48rpx;
  text-align: center;
  border-radius: 50%;
  background: linear-gradient(135deg, #f5f5f5, #eee);
  font-size: 28rpx;
  color: #999;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.05);
}
.modal-close:active {
  transform: scale(0.92);
}
.modal-scroll {
  padding: 16rpx 24rpx 48rpx;
}
.menu-list {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}
.menu-item {
  display: flex;
  flex-direction: row;
  align-items: center;
  padding: 20rpx 16rpx;
  border-radius: 18rpx;
  background: linear-gradient(135deg, rgba(250, 252, 250, 0.98), rgba(255, 255, 255, 1));
  border: 1rpx solid rgba(0, 0, 0, 0.03);
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.02);
  position: relative;
  overflow: hidden;
  transition: all 0.3s ease;
}
.menu-hover {
  transform: scale(0.97) translateX(-4rpx);
  box-shadow: 0 6rpx 20rpx rgba(0, 0, 0, 0.07);
}
.menu-color-bar {
  position: absolute;
  left: 0;
  top: 8rpx;
  bottom: 8rpx;
  width: 5rpx;
  border-radius: 4rpx;
  transition: all 0.3s ease;
}
.menu-0 .menu-color-bar { background: linear-gradient(180deg, #f59e0b, #fb923c); color: #f59e0b; }
.menu-1 .menu-color-bar { background: linear-gradient(180deg, #f59e0b, #fb923c); color: #d97706; }
.menu-2 .menu-color-bar { background: linear-gradient(180deg, #fbbf24, #fcd34d); color: #f59e0b; }
.menu-3 .menu-color-bar { background: linear-gradient(180deg, #fbbf24, #fb923c); color: #d97706; }
.menu-4 .menu-color-bar { background: linear-gradient(180deg, #b45309, #d97706); color: #92400e; }
.menu-hover .menu-color-bar {
  width: 7rpx;
  box-shadow: 0 0 14rpx currentColor;
}
.menu-icon-wrap {
  width: 62rpx;
  height: 62rpx;
  border-radius: 16rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 16rpx;
  flex-shrink: 0;
  transition: transform 0.2s ease;
}
.menu-hover .menu-icon-wrap {
  transform: scale(1.08) rotate(-5deg);
}
.menu-0 .menu-icon-wrap { background: linear-gradient(135deg, rgba(245, 158, 11, 0.12), rgba(251, 146, 60, 0.06)); }
.menu-1 .menu-icon-wrap { background: linear-gradient(135deg, rgba(217, 119, 6, 0.12), rgba(245, 158, 11, 0.06)); }
.menu-2 .menu-icon-wrap { background: linear-gradient(135deg, rgba(251, 146, 60, 0.12), rgba(251, 191, 36, 0.06)); }
.menu-3 .menu-icon-wrap { background: linear-gradient(135deg, rgba(251, 191, 36, 0.12), rgba(252, 211, 77, 0.06)); }
.menu-4 .menu-icon-wrap { background: linear-gradient(135deg, rgba(217, 119, 6, 0.10), rgba(180, 83, 9, 0.06)); }
.menu-icon {
  font-size: 32rpx;
  font-weight: 900;
  line-height: 1;
}
.mi-0 { color: #d97706; }
.mi-1 { color: #b45309; }
.mi-2 { color: #f59e0b; }
.mi-3 { color: #d97706; }
.mi-4 { color: #92400e; }
.menu-info {
  flex: 1;
  display: flex;
  flex-direction: column;
}
.menu-name {
  font-size: 27rpx;
  font-weight: 800;
  color: #1c1917;
  letter-spacing: 0.3rpx;
}
.menu-desc {
  font-size: 22rpx;
  color: #a8a29e;
  margin-top: 3rpx;
}
.menu-arrow {
  font-size: 28rpx;
  color: #ccc;
  font-weight: 600;
  margin-left: 8rpx;
}
</style>
