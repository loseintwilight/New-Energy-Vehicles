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
    <scroll-view scroll-y class="main-scroll" :show-scrollbar="false" @scrolltolower="loadMore">
      <!-- 琥珀橙渐变顶栏 -->
      <view class="header">
        <view class="header-bg"></view>
        <view class="header-circle"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="header-info">
          <text class="header-title">二手车管理</text>
          <text class="header-sub">共 {{ filteredList.length }} 辆</text>
        </view>
        <view class="header-right" @tap="goAdd">
          <view class="add-btn" hover-class="add-btn-hover">
            <text class="add-icon">＋</text>
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
            placeholder="搜索车型名称"
            placeholder-class="search-placeholder"
            @confirm="doSearch"
          />
          <text v-if="searchKey" class="search-clear" @tap="clearSearch">✕</text>
        </view>
      </view>

      <!-- 第一行筛选：电池评级 -->
      <view class="filter-row">
        <scroll-view scroll-x class="filter-scroll" :show-scrollbar="false">
          <view class="filter-inner">
            <view
              v-for="(item, index) in batteryFilterList"
              :key="index"
              class="filter-chip"
              :class="{ active: currentBattery === item.value }"
              @tap="switchBattery(item.value)"
            >
              <text class="chip-text">{{ item.label }}</text>
            </view>
          </view>
        </scroll-view>
      </view>

      <!-- 第二行筛选：状态 + 排序 -->
      <view class="sub-filter-row">
        <scroll-view scroll-x class="status-scroll" :show-scrollbar="false">
          <view class="status-inner">
            <view
              v-for="(item, index) in statusList"
              :key="index"
              class="sub-chip"
              :class="{ active: currentStatus === item.value }"
              @tap="switchStatus(item.value)"
            >
              <text class="sub-chip-text">{{ item.label }}</text>
            </view>
          </view>
        </scroll-view>
        <view class="sort-chip" @tap="cycleSort" hover-class="chip-hover">
          <text class="sort-text">{{ sortLabel }}</text>
          <text class="sort-arrow">{{ sortAsc ? '↑' : '↓' }}</text>
        </view>
      </view>

      <!-- 二手车卡片列表区域 -->
      <view class="list-area">
        <!-- 空状态 -->
        <view v-if="filteredList.length === 0 && !loadingMore" class="empty-box">
          <view class="empty-icon-wrap">
            <text class="empty-icon">🚗</text>
          </view>
          <text class="empty-main">暂无二手车数据</text>
          <text class="empty-sub">尝试切换筛选条件或添加新车辆</text>
        </view>

        <!-- 二手车卡片（分页显示） -->
        <view
          v-for="(item, index) in pagedList"
          :key="item.usedId"
          class="vehicle-card"
          hover-class="card-hover"
          @tap="goDetail(item.usedId)"
        >
          <!-- 左侧彩色条（按电池评级着色） -->
          <view class="color-bar" :class="'cb-' + item.batteryDiagnosis"></view>
          <!-- 卡片主体：左右布局 -->
          <view class="vc-body">
            <!-- 左侧缩略图占位 -->
            <view class="vc-img">
              <text class="car-emoji">🚗</text>
            </view>
            <!-- 右侧信息区 -->
            <view class="vc-info">
              <!-- 上：名称 + 状态徽章 -->
              <view class="vc-top">
                <text class="vc-name">{{ item.name }}</text>
                <view class="status-badge" :class="'sb-' + item.status">
                  <text class="sb-text">{{ getStatusLabel(item.status) }}</text>
                </view>
              </view>
              <!-- 中：二手车专属三参数行 -->
              <view class="vc-specs">
                <view class="spec-item">
                  <text class="spec-label">里程</text>
                  <text class="spec-val">{{ item.mileage }}万km</text>
                </view>
                <view class="spec-item">
                  <text class="spec-label">上牌</text>
                  <text class="spec-val">{{ item.licenseYear }}.{{ fmtMonth(item.licenseMonth) }}</text>
                </view>
                <view class="spec-item">
                  <text class="spec-label">过户</text>
                  <text class="spec-val">{{ item.transferCount }}次</text>
                </view>
              </view>
              <!-- 下：售价 + 电池SOH + 估价 -->
              <view class="vc-bottom">
                <view class="price-block">
                  <text class="price-symbol">¥</text>
                  <text class="price-num">{{ fmtPrice(item.price) }}</text>
                </view>
                <view class="vc-tags">
                  <view class="soh-tag">
                    <text class="soh-text">电池 {{ item.batterySoh }}%</text>
                  </view>
                  <view class="val-tag">
                    <text class="val-label">估价</text>
                    <text class="val-num">¥{{ fmtPrice(item.valuationPrice) }}</text>
                  </view>
                </view>
              </view>
            </view>
          </view>
        </view>

        <!-- 加载更多提示 -->
        <view class="load-more-row">
          <view v-if="loadingMore" class="loading-dots">
            <view class="dot"></view>
            <view class="dot"></view>
            <view class="dot"></view>
          </view>
          <text v-else-if="noMoreData && filteredList.length > pageSize" class="no-more-text">— 已经到底了 —</text>
        </view>
      </view>

      <view style="height: 100rpx;"></view>
    </scroll-view>
  </view>
</template>

<script>
export default {
  data: function() {
    return {
      isReady: false,
      glowRows: [],
      searchKey: '',
      currentBattery: '',
      currentStatus: '',
      sortField: '',
      sortAsc: true,
      page: 1,
      pageSize: 4,
      loadingMore: false,
      noMoreData: false,

      /* Mock二手车数据（基于stad_vehicle表 + stad_vehicle_used关联表，字段严格对齐DB） */
      mockUsedCars: [
        { usedId: 1, vehicleId: 101, name: '比亚迪海豹 EV 700km 四驱旗舰版', price: 168000, originalPrice: 228000, mileage: 2.8, licenseYear: 2024, licenseMonth: 6, licenseCity: '济南', transferCount: 0, batterySoh: 96.5, batteryCycles: 128, batteryDiagnosis: 'excellent', valuationPrice: 172000, color: '极光蓝', stock: 1, status: '1' },
        { usedId: 2, vehicleId: 102, name: '特斯拉 Model Y 后驱版', price: 195000, originalPrice: 263900, mileage: 4.2, licenseYear: 2023, licenseMonth: 11, licenseCity: '青岛', transferCount: 1, batterySoh: 92.0, batteryCycles: 215, batteryDiagnosis: 'excellent', valuationPrice: 198500, color: '珍珠白', stock: 1, status: '1' },
        { usedId: 3, vehicleId: 103, name: '蔚来 ES6 75kWh 运动版', price: 248000, originalPrice: 338000, mileage: 5.6, licenseYear: 2023, licenseMonth: 5, licenseCity: '烟台', transferCount: 0, batterySoh: 88.2, batteryCycles: 320, batteryDiagnosis: 'good', valuationPrice: 252000, color: '星灰', stock: 1, status: '1' },
        { usedId: 4, vehicleId: 104, name: '理想 L7 Pro 增程版', price: 235000, originalPrice: 319800, mileage: 7.8, licenseYear: 2022, licenseMonth: 9, licenseCity: '潍坊', transferCount: 2, batterySoh: 82.5, batteryCycles: 450, batteryDiagnosis: 'good', valuationPrice: 228000, color: '银色', stock: 1, status: '2' },
        { usedId: 5, vehicleId: 105, name: '比亚迪汉 DM-i 冠军版', price: 138000, originalPrice: 189800, mileage: 9.2, licenseYear: 2022, licenseMonth: 3, licenseCity: '临沂', transferCount: 1, batterySoh: 76.8, batteryCycles: 520, batteryDiagnosis: 'fair', valuationPrice: 135000, color: '赤帝红', stock: 1, status: '1' },
        { usedId: 6, vehicleId: 106, name: '问界 M5 纯电版', price: 158000, originalPrice: 259800, mileage: 12.5, licenseYear: 2021, licenseMonth: 8, licenseCity: '淄博', transferCount: 3, batterySoh: 68.3, batteryCycles: 680, batteryDiagnosis: 'poor', valuationPrice: 142000, color: '霜釉银', stock: 0, status: '3' }
      ],

      /* 电池评级筛选（与stad_vehicle_used.battery_diagnosis对齐） */
      batteryFilterList: [
        { label: '全部评级', value: '' },
        { label: '优秀', value: 'excellent' },
        { label: '良好', value: 'good' },
        { label: '一般', value: 'fair' },
        { label: '较差', value: 'poor' }
      ],

      /* 状态筛选（与stad_vehicle.status对齐：0=待审核 1=在售 2=已卖 3=下架） */
      statusList: [
        { label: '全部状态', value: '' },
        { label: '在售', value: '1' },
        { label: '已售', value: '2' },
        { label: '下架', value: '3' }
      ]
    }
  },

  computed: {
    /* 排序标签文字 */
    sortLabel: function() {
      var map = { '': '默认排序', 'price': this.sortAsc ? '价格升序' : '价格降序', 'mileage': this.sortAsc ? '里程升序' : '里程降序', 'age': this.sortAsc ? '车龄升序' : '车龄降序' }
      return map[this.sortField] || '默认排序'
    },

    /* 筛选 + 排序后的完整列表 */
    filteredList: function() {
      var that = this
      var list = that.mockUsedCars.slice()

      /* 关键词搜索 */
      if (that.searchKey && that.searchKey.trim() !== '') {
        var key = that.searchKey.trim().toLowerCase()
        list = list.filter(function(v) {
          return v.name.toLowerCase().indexOf(key) !== -1
        })
      }

      /* 电池评级筛选 */
      if (that.currentBattery !== '') {
        list = list.filter(function(v) { return v.batteryDiagnosis === that.currentBattery })
      }

      /* 状态筛选 */
      if (that.currentStatus !== '') {
        list = list.filter(function(v) { return v.status === that.currentStatus })
      }

      /* 排序 */
      if (that.sortField === 'price') {
        list.sort(function(a, b) { return that.sortAsc ? a.price - b.price : b.price - a.price })
      } else if (that.sortField === 'mileage') {
        list.sort(function(a, b) { return that.sortAsc ? a.mileage - b.mileage : b.mileage - a.mileage })
      } else if (that.sortField === 'age') {
        list.sort(function(a, b) {
          var ageA = a.licenseYear * 12 + a.licenseMonth
          var ageB = b.licenseYear * 12 + b.licenseMonth
          return that.sortAsc ? ageA - ageB : ageB - ageA
        })
      }

      return list
    },

    /* 分页截取的展示列表 */
    pagedList: function() {
      var that = this
      var start = 0
      var end = that.page * that.pageSize
      return that.filteredList.slice(start, end)
    }
  },

  created: function() {
    this.buildGlowRows()
    var that = this
    setTimeout(function() {
      that.isReady = true
    }, 200)
  },

  methods: {
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

    /* ---------- 搜索与筛选 ---------- */
    clearSearch: function() {
      this.searchKey = ''
    },

    doSearch: function() {
      this.page = 1
      this.noMoreData = false
    },

    switchBattery: function(value) {
      this.currentBattery = value
      this.page = 1
      this.noMoreData = false
    },

    switchStatus: function(value) {
      this.currentStatus = value
      this.page = 1
      this.noMoreData = false
    },

    /* 状态值→中文（与stad_vehicle.status对齐） */
    getStatusLabel: function(status) {
      var map = { '0': '待审核', '1': '在售', '2': '已售', '3': '下架' }
      return map[status] || '未知'
    },

    cycleSort: function() {
      var order = ['', 'price', 'price', 'mileage', 'mileage', 'age']
      var idx = order.indexOf(this.sortField)
      idx = (idx + 1) % order.length
      this.sortField = order[idx]
      if (this.sortField === 'price') {
        this.sortAsc = (idx === 1)
      } else if (this.sortField === 'mileage') {
        this.sortAsc = (idx === 3)
      } else if (this.sortField === 'age') {
        this.sortAsc = false
      } else {
        this.sortAsc = true
      }
      this.page = 1
      this.noMoreData = false
    },

    /* ---------- 分页加载 ---------- */
    loadMore: function() {
      var that = this
      if (that.loadingMore || that.noMoreData) return
      var total = that.filteredList.length
      if (that.page * that.pageSize >= total) {
        that.noMoreData = true
        return
      }
      that.loadingMore = true
      setTimeout(function() {
        that.page++
        that.loadingMore = false
        if (that.page * that.pageSize >= total) {
          that.noMoreData = true
        }
      }, 400)
    },

    /* ---------- 工具方法 ---------- */
    fmtPrice: function(val) {
      if (val === null || val === undefined) return '0'
      return Number(val).toLocaleString()
    },

    fmtMonth: function(m) {
      var s = String(m)
      return s.length === 1 ? '0' + s : s
    },

    /* ---------- 页面跳转 ---------- */
    goBack: function() {
      uni.navigateBack({ delta: 1 })
    },

    goAdd: function() {
      uni.navigateTo({ url: '/pages/mine/vehicle/used-car-add' })
    },

    goDetail: function(usedId) {
      uni.navigateTo({
        url: '/pages/mine/vehicle/used-car-detail?usedId=' + encodeURIComponent(usedId)
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
.page-ready .vehicle-card {
  animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards;
}
.page-ready .vehicle-card:nth-child(1) { animation-delay: 0.06s; }
.page-ready .vehicle-card:nth-child(2) { animation-delay: 0.12s; }
.page-ready .vehicle-card:nth-child(3) { animation-delay: 0.18s; }
.page-ready .vehicle-card:nth-child(4) { animation-delay: 0.24s; }
.page-ready .vehicle-card:nth-child(5) { animation-delay: 0.30s; }
.page-ready .vehicle-card:nth-child(6) { animation-delay: 0.36s; }

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
  width: 64rpx; height: 64rpx;
  border-radius: 32rpx;
  background: linear-gradient(135deg, #ffffff, rgba(255, 255, 255, 0.85));
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4rpx 16rpx rgba(245, 158, 11, 0.35);
  transition: all 0.2s ease;
}
.add-btn-hover {
  transform: scale(0.9);
}
.add-icon {
  font-size: 36rpx;
  color: #f59e0b;
  font-weight: 700;
}

/* ========== 搜索栏 ========== */
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
.search-clear {
  font-size: 26rpx;
  color: #999;
  padding: 8rpx;
  margin-left: 10rpx;
  flex-shrink: 0;
}

/* ========== 电池评级筛选标签栏 ========== */
.filter-row {
  position: relative;
  z-index: 3;
  white-space: nowrap;
  padding-bottom: 4rpx;
}
.filter-scroll {
  white-space: nowrap;
}
.filter-inner {
  display: inline-flex;
  padding: 14rpx 24rpx;
  gap: 12rpx;
}
.filter-chip {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 13rpx 32rpx;
  border-radius: 36rpx;
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

/* ========== 状态+排序子筛选行 ========== */
.sub-filter-row {
  display: flex;
  align-items: center;
  padding: 4rpx 24rpx 16rpx;
  gap: 16rpx;
}
.status-scroll {
  flex: 1;
  white-space: nowrap;
}
.status-inner {
  display: inline-flex;
  gap: 12rpx;
}
.sub-chip {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 10rpx 24rpx;
  border-radius: 28rpx;
  background: rgba(255, 255, 255, 0.72);
  border: 1rpx solid rgba(200, 200, 200, 0.25);
  transition: all 0.25s ease;
}
.sub-chip.active {
  background: linear-gradient(135deg, #fef3c7, #fde68a);
  border-color: rgba(245, 158, 11, 0.35);
  box-shadow: 0 2rpx 8rpx rgba(245, 158, 11, 0.15);
}
.sub-chip-text {
  font-size: 23rpx;
  color: #78716c;
  font-weight: 600;
}
.sub-chip.active .sub-chip-text {
  color: #92400e;
}
.sort-chip {
  display: flex;
  align-items: center;
  gap: 4rpx;
  padding: 10rpx 20rpx;
  border-radius: 28rpx;
  background: rgba(255, 255, 255, 0.72);
  border: 1rpx solid rgba(200, 200, 200, 0.25);
  flex-shrink: 0;
  transition: all 0.25s ease;
}
.sort-text {
  font-size: 23rpx;
  color: #78716c;
  font-weight: 600;
}
.sort-arrow {
  font-size: 22rpx;
  color: #f59e0b;
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
  width: 150rpx; height: 150rpx;
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

/* ========== 二手车卡片 ========== */
.vehicle-card {
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

/* ========== 彩色条（按电池评级着色）========== */
.color-bar {
  position: absolute;
  left: 0; top: 0; bottom: 0;
  width: 6rpx;
  border-radius: 24rpx 0 0 24rpx;
  transition: all 0.35s ease;
  z-index: 3;
}
.cb-excellent {
  background: linear-gradient(180deg, #d97706, #f59e0b);
  box-shadow: 2rpx 0 14rpx rgba(217, 119, 6, 0.28);
}
.cb-good {
  background: linear-gradient(180deg, #f59e0b, #fb923c);
  box-shadow: 2rpx 0 14rpx rgba(245, 158, 11, 0.28);
}
.cb-fair {
  background: linear-gradient(180deg, #fb923c, #fbbf24);
  box-shadow: 2rpx 0 14rpx rgba(251, 146, 60, 0.28);
}
.cb-poor {
  background: linear-gradient(180deg, #ea580c, #f97316);
  box-shadow: 2rpx 0 14rpx rgba(234, 88, 12, 0.28);
}

.card-hover {
  transform: scale(0.97) translateY(-2rpx)!important;
  box-shadow:
    0 16rpx 48rpx rgba(0, 0, 0, 0.12)!important,
    0 8rpx 24rpx rgba(245, 158, 11, 0.1)!important;
  border-color: rgba(245, 158, 11, 0.2)!important;
}
.card-hover .color-bar {
  width: 9rpx;
}

.vc-body {
  flex: 1;
  display: flex;
  flex-direction: row;
  padding: 22rpx 22rpx 22rpx 28rpx;
  position: relative;
  z-index: 2;
}

/* 左侧缩略图 */
.vc-img {
  width: 160rpx;
  height: 160rpx;
  border-radius: 18rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 20rpx;
  flex-shrink: 0;
  position: relative;
  overflow: hidden;
  background: linear-gradient(135deg, #fff7ed, #fef3c7);
}
.car-emoji {
  font-size: 56rpx;
  opacity: 0.55;
}

/* 右侧信息区 */
.vc-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  min-width: 0;
}

/* 上：名称 + 标签 */
.vc-top {
  display: flex;
  flex-direction: column;
  gap: 8rpx;
}
.vc-name {
  font-size: 28rpx;
  font-weight: 800;
  color: #1c1917;
  line-height: 1.3;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  letter-spacing: 0.5rpx;
}
/* 状态徽章（基于stad_vehicle.status） */
.status-badge {
  border-radius: 10rpx;
  padding: 5rpx 14rpx;
  flex-shrink: 0;
  font-weight: 700;
  align-self: flex-start;
}
.sb-0 {
  background: linear-gradient(135deg, rgba(245,158,11,0.12), rgba(251,191,36,0.06));
  color: #d97706;
  border: 1rpx solid rgba(245, 158, 11, 0.2);
}
.sb-1 {
  background: linear-gradient(135deg, rgba(34,197,94,0.12), rgba(74,222,128,0.06));
  color: #16a34a;
  border: 1rpx solid rgba(34, 197, 94, 0.2);
}
.sb-2 {
  background: linear-gradient(135deg, rgba(59,130,246,0.12), rgba(96,165,250,0.06));
  color: #2563eb;
  border: 1rpx solid rgba(59, 130, 246, 0.2);
}
.sb-3 {
  background: linear-gradient(135deg, rgba(156,163,175,0.12), rgba(209,213,219,0.06));
  color: #6b7280;
  border: 1rpx solid rgba(156, 163, 175, 0.2);
}
.sb-text {
  font-size: 20rpx;
}

/* 中：二手车专属三参数行 */
.vc-specs {
  display: flex;
  gap: 16rpx;
  padding: 10rpx 0;
}
.spec-item {
  display: flex;
  flex-direction: column;
  gap: 2rpx;
}
.spec-label {
  font-size: 20rpx;
  color: #a8a29e;
  font-weight: 500;
}
.spec-val {
  font-size: 23rpx;
  color: #44403c;
  font-weight: 700;
}

/* 下：售价 + 电池SOH + 估价 */
.vc-bottom {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  padding-top: 10rpx;
  border-top: 1rpx solid rgba(0, 0, 0, 0.04);
}
.price-block {
  display: flex;
  align-items: baseline;
}
.price-symbol {
  font-size: 24rpx;
  color: #f59e0b;
  font-weight: 700;
  margin-right: 2rpx;
}
.price-num {
  font-size: 36rpx;
  color: #f59e0b;
  font-weight: 800;
  letter-spacing: -0.5rpx;
}
.vc-tags {
  display: flex;
  align-items: center;
  gap: 10rpx;
}
.soh-tag {
  background: linear-gradient(135deg, rgba(245,158,11,0.1), rgba(251,191,36,0.06));
  border: 1rpx solid rgba(245, 158, 11, 0.18);
  border-radius: 8rpx;
  padding: 4rpx 12rpx;
}
.soh-text {
  font-size: 20rpx;
  color: #d97706;
  font-weight: 700;
}
.val-tag {
  display: flex;
  align-items: baseline;
  gap: 2rpx;
}
.val-label {
  font-size: 20rpx;
  color: #a8a29e;
}
.val-num {
  font-size: 22rpx;
  color: #78716c;
  font-weight: 700;
}

/* ========== 加载更多 ========== */
.load-more-row {
  text-align: center;
  padding: 32rpx 0 16rpx;
}
.loading-dots {
  display: inline-flex;
  gap: 12rpx;
  align-items: center;
}
.dot {
  width: 16rpx; height: 16rpx;
  border-radius: 50%;
  background: #f59e0b;
  animation: dotBounce 1.2s ease-in-out infinite;
}
.dot:nth-child(2) { animation-delay: 0.15s; }
.dot:nth-child(3) { animation-delay: 0.3s; }
@keyframes dotBounce {
  0%, 80%, 100% { transform: scale(0.6); opacity: 0.5; }
  40% { transform: scale(1); opacity: 1; }
}
.no-more-text {
  font-size: 24rpx;
  color: #ccc;
  letter-spacing: 2rpx;
}
</style>
