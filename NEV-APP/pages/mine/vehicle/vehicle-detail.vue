<template>
  <view class="page" :class="{ 'page-ready': isReady }">
    <!-- 背景光晕矩阵（琥珀橙系） -->
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
      <!-- 顶栏（琥珀渐变） -->
      <view class="header">
        <view class="header-bg"></view>
        <view class="header-circle"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="header-info">
          <text class="header-title">车辆详情</text>
          <text class="header-sub">{{ vehicle.name }}</text>
        </view>
        <view class="header-right" @tap="goEditVehicle">
          <text class="edit-text">编辑</text>
        </view>
      </view>

      <!-- Hero区域 - 车辆大卡片 -->
      <view class="hero-section">
        <view class="hero-glow"></view>
        <view class="hero-img-wrap">
          <image
            v-if="vehicle.images && vehicle.images.length > 0"
            :src="getImageUrl(vehicle.images[0])"
            mode="aspectFill"
            class="hero-img"
          ></image>
          <text v-else class="hero-placeholder">🚗</text>
        </view>
        <view class="hero-info">
          <view class="hero-top-row">
            <view class="hero-name-area">
              <text class="hero-name">{{ vehicle.name }}</text>
              <view class="type-tag-row">
                <view :class="['type-badge', 'tb-' + vehicle.type]">
                  <text>{{ vehicle.typeLabel }}</text>
                </view>
                <view v-if="vehicle.year" class="year-tag">
                  <text>{{ vehicle.year }}</text>
                </view>
              </view>
            </view>
            <view :class="['status-badge', 'badge-' + vehicle.status]">
              <view class="badge-dot" v-if="vehicle.status === '1'"></view>
              <text>{{ getStatusLabel(vehicle.status) }}</text>
            </view>
          </view>
          <view class="price-row">
            <text class="price-symbol">¥</text>
            <text class="price-num">{{ formatPrice(vehicle.price) }}</text>
            <text v-if="vehicle.originalPrice && vehicle.originalPrice !== vehicle.price" class="price-original">¥{{ formatPrice(vehicle.originalPrice) }}</text>
          </view>
        </view>
      </view>

      <!-- 基本信息卡（琥珀色条） -->
      <view class="section-block sb-amber">
        <view class="title-bar">
          <view class="bar-line"></view>
          <view class="icon-wrap iw-amber">
            <text class="bar-icon">📋</text>
          </view>
          <text class="bar-title">基本信息</text>
        </view>
        <view class="info-card">
          <view class="info-grid">
            <view class="info-item">
              <text class="info-label">品牌</text>
              <text class="info-value">{{ vehicle.brand || '-' }}</text>
            </view>
            <view class="info-item">
              <text class="info-label">型号</text>
              <text class="info-value">{{ vehicle.model || '-' }}</text>
            </view>
            <view class="info-item">
              <text class="info-label">续航里程</text>
              <text class="info-value highlight">{{ vehicle.range || '-' }}<text class="info-unit">km</text></text>
            </view>
            <view class="info-item">
              <text class="info-label">电池容量</text>
              <text class="info-value">{{ vehicle.batteryCapacity || '-' }}<text class="info-unit">kWh</text></text>
            </view>
            <view class="info-item">
              <text class="info-label">快充时间</text>
              <text class="info-value">{{ vehicle.fastChargeTime || '-' }}</text>
            </view>
            <view class="info-item info-item-colors">
              <text class="info-label">车身颜色</text>
              <view v-if="vehicle.colors && vehicle.colors.length > 0" class="color-list">
                <view v-for="(color, idx) in vehicle.colors" :key="idx" class="color-item">
                  <view class="color-dot" :style="{ backgroundColor: color.value }"></view>
                  <text class="color-name" :class="{ 'color-active': color.name === vehicle.selectedColor }">{{ color.name }}</text>
                </view>
              </view>
              <text v-else class="info-value">-</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 规格参数卡（蓝色色条） -->
      <view class="section-block sb-blue">
        <view class="title-bar">
          <view class="bar-line bar-line-blue"></view>
          <view class="icon-wrap iw-blue">
            <text class="bar-icon">⚙️</text>
          </view>
          <text class="bar-title">规格参数</text>
        </view>
        <view class="spec-grid">
          <view class="spec-item">
            <text class="spec-label">长×宽×高</text>
            <text class="spec-value">{{ getDimensions() }}</text>
          </view>
          <view class="spec-item">
            <text class="spec-label">轴距</text>
            <text class="spec-value">{{ vehicle.wheelbase || '-' }}<text class="spec-unit">mm</text></text>
          </view>
          <view class="spec-item">
            <text class="spec-label">整备质量</text>
            <text class="spec-value">{{ vehicle.curbWeight || '-' }}<text class="spec-unit">kg</text></text>
          </view>
          <view class="spec-item">
            <text class="spec-label">最高车速</text>
            <text class="spec-value">{{ vehicle.maxSpeed || '-' }}<text class="spec-unit">km/h</text></text>
          </view>
          <view class="spec-item">
            <text class="spec-label">电机功率</text>
            <text class="spec-value">{{ vehicle.motorPower || '-' }}<text class="spec-unit">kW</text></text>
          </view>
          <view class="spec-item">
            <text class="spec-label">最大扭矩</text>
            <text class="spec-value">{{ vehicle.torque || '-' }}<text class="spec-unit">N·m</text></text>
          </view>
        </view>
      </view>

      <!-- 电池诊断卡（绿色色条） -->
      <view class="section-block sb-green">
        <view class="title-bar">
          <view class="bar-line bar-line-green"></view>
          <view class="icon-wrap iw-green">
            <text class="bar-icon">🔋</text>
          </view>
          <text class="bar-title">电池诊断</text>
        </view>
        <view class="battery-card">
          <view class="soh-row">
            <view class="soh-left">
              <text class="soh-label">电池健康度 (SOH)</text>
              <text class="soh-value" :class="sohCls">{{ vehicle.soh || '-' }}<text class="soh-unit">%</text></text>
            </view>
            <view class="soh-right">
              <view class="status-eval" :class="'eval-' + sohLv">
                <text>{{ vehicle.batteryStatus || '-' }}</text>
              </view>
            </view>
          </view>
          <view class="progress-wrap">
            <view class="progress-bar">
              <view class="progress-fill" :style="{ width: (vehicle.soh || 0) + '%' }"></view>
            </view>
          </view>
          <view class="battery-meta">
            <view class="meta-item">
              <text class="meta-label">温度范围</text>
              <text class="meta-value">{{ vehicle.batteryTemp || '-' }}</text>
            </view>
            <view class="meta-divider"></view>
            <view class="meta-item">
              <text class="meta-label">循环次数</text>
              <text class="meta-value">{{ vehicle.cycleCount || '-' }}<text class="meta-unit">次</text></text>
            </view>
          </view>
        </view>
      </view>

      <!-- 详细描述卡（紫色色条） -->
      <view class="section-block sb-purple">
        <view class="title-bar">
          <view class="bar-line bar-line-purple"></view>
          <view class="icon-wrap iw-purple">
            <text class="bar-icon">📝</text>
          </view>
          <text class="bar-title">详细描述</text>
        </view>
        <view class="desc-card">
          <view v-if="vehicle.description" class="desc-content">
            <rich-text :nodes="getSafeDesc(vehicle.description)"></rich-text>
          </view>
          <view v-if="vehicle.description && needExpand" class="expand-row" @tap="toggleDesc">
            <text class="expand-text">{{ descExpanded ? '收起' : '展开全文' }}</text>
            <text class="expand-arrow">{{ descExpanded ? '∧' : '∨' }}</text>
          </view>
          <view v-if="!vehicle.description" class="desc-empty" @tap="goEditDesc">
            <text class="empty-hint">暂无描述，点击添加车辆详细介绍</text>
            <text class="empty-arrow">→</text>
          </view>
        </view>
      </view>

      <!-- 库存信息卡（橙色色条） -->
      <view class="section-block sb-orange">
        <view class="title-bar">
          <view class="bar-line bar-line-orange"></view>
          <view class="icon-wrap iw-orange">
            <text class="bar-icon">📦</text>
          </view>
          <text class="bar-title">库存信息</text>
        </view>
        <view class="stock-stats">
          <view class="stock-item">
            <text class="stock-num" :class="stockCls">{{ vehicle.stock || 0 }}</text>
            <text class="stock-label">当前库存</text>
          </view>
          <view class="stock-divider"></view>
          <view class="stock-item">
            <text class="stock-num">{{ vehicle.soldCount || 0 }}</text>
            <text class="stock-label">已售数量</text>
          </view>
          <view class="stock-divider"></view>
          <view class="stock-item">
            <view :class="['stock-status-tag', 'sst-' + sstType]">
              <text>{{ vehicle.stockStatus || '未知' }}</text>
            </view>
            <text class="stock-label">库存状态</text>
          </view>
        </view>
      </view>

      <!-- 操作按钮区 -->
      <view class="action-section">
        <view class="action-card act-edit" hover-class="act-hover" @tap="goEditVehicle">
          <view class="act-color-bar"></view>
          <text class="act-icon">✏️</text>
          <text class="act-name">编辑信息</text>
          <text class="act-desc">修改车辆基础信息</text>
        </view>
        <view class="action-card act-desc" hover-class="act-hover" @tap="goEditDesc">
          <view class="act-color-bar"></view>
          <text class="act-icon">📝</text>
          <text class="act-name">编辑描述</text>
          <text class="act-desc">修改车辆详细介绍</text>
        </view>
        <view class="action-card act-back" hover-class="act-hover" @tap="goBack">
          <view class="act-color-bar"></view>
          <text class="act-icon">←</text>
          <text class="act-name">返回列表</text>
          <text class="act-desc">返回车辆列表页面</text>
        </view>
      </view>

      <view style="height: 120rpx;"></view>
    </scroll-view>
  </view>
</template>

<script>
var USE_MOCK = true

function mockGetVehicleDetail(vehicleId) {
  var baseData = {
    vehicleId: vehicleId || 1,
    name: '比亚迪海豹 EV 700km 四驱旗舰版',
    brand: '比亚迪',
    model: '海豹',
    year: '2026款',
    type: 'ev',
    typeLabel: '纯电动',
    price: 228000,
    originalPrice: 249800,
    range: 700,
    batteryCapacity: 82.5,
    fastChargeTime: '28分钟',
    colors: [
      { name: '北极白', value: '#F5F5F5' },
      { name: '迷雾灰', value: '#6B7280' },
      { name: '海洋蓝', value: '#1E40AF' },
      { name: '热情红', value: '#DC2626' }
    ],
    selectedColor: '北极白',
    length: 4800,
    width: 1875,
    height: 1460,
    wheelbase: 2920,
    curbWeight: 2150,
    maxSpeed: 180,
    motorPower: 230,
    torque: 360,
    soh: 98.5,
    batteryTemp: '22~35°C',
    cycleCount: 128,
    batteryStatus: '优秀',
    description: '<p>比亚迪海豹是基于e平台3.0打造的纯电中型轿车，采用CTB电池车身一体化技术，整车扭转刚度高达40500N·m/deg。</p><p><strong>核心亮点：</strong></p><ul><li>CLTC续航里程700km，支持800V高压快充</li><li>双电机四驱系统，最大功率230kW，峰值扭矩360N·m</li><li>零百加速仅需3.8秒，最高时速180km/h</li><li>配备DiPilot智能驾驶辅助系统，支持L2+级智能驾驶</li><li>刀片电池技术，安全性行业领先</li></ul><p>该车定位中高端纯电轿跑市场，凭借出色的性能表现和智能化配置，深受年轻消费者喜爱。</p>',
    stock: 5,
    soldCount: 23,
    stockStatus: '充足',
    status: '1',
    images: ['vehicle_seal_01.jpg'],
    createTime: '2026-01-15'
  }
  return { code: 200, msg: '操作成功', data: baseData }
}

export default {
  data: function() {
    return {
      isReady: false,
      glowRows: [],
      vehicleId: '',
      vehicle: null,
      loading: true,
      descExpanded: false,
      needExpand: false
    }
  },
  onLoad: function(options) {
    var that = this
    if (options && options.vehicleId) {
      that.vehicleId = options.vehicleId
      that.loadDetail()
    }
    that.buildGlowRows()
    setTimeout(function() { that.isReady = true }, 200)
  },
  onShow: function() {
    if (this.vehicleId) { this.loadDetail() }
  },
  computed: {
    sohCls: function() {
      var s = this.vehicle ? this.vehicle.soh : 0
      if (!s) return ''
      if (s >= 95) return 'soh-excellent'
      if (s >= 80) return 'soh-good'
      if (s >= 60) return 'soh-normal'
      return 'soh-warning'
    },
    sohLv: function() {
      var s = this.vehicle ? this.vehicle.soh : 0
      if (!s) return 'normal'
      if (s >= 95) return 'excellent'
      if (s >= 80) return 'good'
      if (s >= 60) return 'normal'
      return 'warning'
    },
    stockCls: function() {
      var st = this.vehicle ? this.vehicle.stock : 0
      if (!st || st <= 1) return 'stock-low'
      if (st <= 3) return 'stock-normal'
      return 'stock-high'
    },
    sstType: function() {
      var ss = this.vehicle ? this.vehicle.stockStatus : ''
      if (!ss) return 'unknown'
      if (ss.indexOf('缺') > -1) return 'short'
      if (ss.indexOf('紧') > -1) return 'tight'
      if (ss.indexOf('足') > -1) return 'enough'
      return 'unknown'
    }
  },
  methods: {
    buildGlowRows: function() {
      var rows = []
      var colors = ['#f59e0b', '#f97316', '#fb923c', '#fbbf24', '#fcd34d', '#fde68a']
      for (var r = 0; r < 8; r++) {
        var dots = []
        var count = 3 + Math.floor(Math.random() * 3)
        for (var c = 0; c < count; c++) {
          var color = colors[Math.floor(Math.random() * colors.length)]
          var size = 60 + Math.floor(Math.random() * 80)
          var dur = 2.5 + Math.random() * 2.5
          var delay = Math.random() * 2.5
          var alpha = 0.06 + Math.random() * 0.16
          dots.push({
            style: 'width:' + size + 'rpx;height:' + size + 'rpx;background:radial-gradient(circle,' + color + ',' + color + '00);opacity:' + alpha.toFixed(2) + ';animation-duration:' + dur.toFixed(1) + 's;animation-delay:' + delay.toFixed(1) + 's;'
          })
        }
        rows.push({ dots: dots })
      }
      this.glowRows = rows
    },

    loadDetail: function() {
      var self = this
      self.loading = true
      if (USE_MOCK) {
        var res = mockGetVehicleDetail(self.vehicleId)
        setTimeout(function() { self.handleRes(res) }, 300)
      } else {
        uni.request({
          url: '/merchant/vehicle/' + self.vehicleId,
          method: 'GET',
          success: function(res) { self.handleRes(res.data) },
          fail: function(err) {
            self.loading = false
            uni.showToast({ title: '获取数据失败', icon: 'none' })
          }
        })
      }
    },

    handleRes: function(res) {
      var self = this
      self.loading = false
      if (res.code === 200 && res.data) {
        self.vehicle = res.data
        self.checkDescLength()
      }
    },

    checkDescLength: function() {
      if (!this.vehicle || !this.vehicle.description) {
        this.needExpand = false
        return
      }
      var plainText = this.stripHtmlTags(this.vehicle.description)
      this.needExpand = plainText.length > 200
    },

    stripHtmlTags: function(html) {
      if (!html) return ''
      return String(html).replace(/<[^>]+>/g, '').replace(/&nbsp;/g, ' ').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&amp;/g, '&')
    },

    getStatusLabel: function(status) {
      var map = { '0': '已停售', '1': '在售', '2': '预售' }
      return map[status] || '未知'
    },

    formatPrice: function(price) {
      if (!price) return '0'
      return Number(price).toLocaleString('zh-CN')
    },

    getImageUrl: function(img) {
      if (!img) return ''
      if (img.indexOf('http') === 0) return img
      return '/static/images/vehicle/' + img
    },

    getDimensions: function() {
      var v = this.vehicle
      if (!v.length || !v.width || !v.height) return '-'
      return v.length + '×' + v.width + '×' + v.height
    },

    getSohClass: function(soh) {
      if (!soh) return ''
      if (soh >= 95) return 'soh-excellent'
      if (soh >= 80) return 'soh-good'
      if (soh >= 60) return 'soh-normal'
      return 'soh-warning'
    },

    getSohLevel: function(soh) {
      if (!soh) return 'normal'
      if (soh >= 95) return 'excellent'
      if (soh >= 80) return 'good'
      if (soh >= 60) return 'normal'
      return 'warning'
    },

    getStockClass: function(stock) {
      if (!stock) return ''
      if (stock <= 3) return 'stock-low'
      if (stock <= 10) return 'stock-normal'
      return 'stock-high'
    },

    getStockStatusType: function(status) {
      if (!status) return 'unknown'
      var s = String(status)
      if (s.indexOf('充足') > -1 || s.indexOf('富余') > -1) return 'good'
      if (s.indexOf('紧张') > -1 || s.indexOf('较少') > -1) return 'warning'
      if (s.indexOf('缺货') > -1 || s.indexOf('无') > -1) return 'danger'
      return 'unknown'
    },

    getSafeDesc: function(desc) {
      if (!desc) return ''
      var safe = String(desc)
      safe = safe.replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '')
      safe = safe.replace(/on\w+\s*=/gi, '')
      return safe
    },

    toggleDesc: function() {
      this.descExpanded = !this.descExpanded
    },

    goBack: function() {
      uni.navigateBack({ delta: 1 })
    },

    goEditVehicle: function() {
      uni.navigateTo({
        url: '/pages/mine/vehicle/vehicle-add?editMode=1&vehicleId=' + this.vehicleId
      })
    },

    goEditDesc: function() {
      uni.navigateTo({
        url: '/pages/mine/vehicle/vehicle-desc-edit?vehicleId=' + this.vehicleId + '&currentDesc=' + encodeURIComponent(this.vehicle ? (this.vehicle.description || '') : '')
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

/* ========== 入场动画 ========== */
.page-ready .hero-section { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.05s; }
.page-ready .section-block:nth-of-type(1) { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.12s; }
.page-ready .section-block:nth-of-type(2) { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.19s; }
.page-ready .section-block:nth-of-type(3) { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.26s; }
.page-ready .section-block:nth-of-type(4) { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.33s; }
.page-ready .section-block:nth-of-type(5) { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.40s; }
.page-ready .action-section { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.47s; }

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
  0% { opacity: 0.12; transform: scale(0.85); }
  50% { opacity: 0.55; }
  100% { opacity: 0.12; transform: scale(1.25); }
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

/* ========== 顶栏（琥珀渐变） ========== */
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
.edit-text {
  font-size: 28rpx;
  color: #ffffff;
  font-weight: 600;
  padding: 10rpx 20rpx;
  border-radius: 16rpx;
  background: rgba(255, 255, 255, 0.2);
  transition: all 0.2s ease;
}

/* ========== Hero区域 ========== */
.hero-section {
  margin: 0 24rpx 20rpx;
  background: linear-gradient(135deg, #f59e0b 0%, #f97316 40%, #fb923c 70%, #fdba74 100%);
  border-radius: 28rpx;
  padding: 28rpx;
  position: relative;
  overflow: hidden;
  box-shadow:
    0 12rpx 40rpx rgba(245, 158, 11, 0.35),
    inset 0 1rpx 0 rgba(255, 255, 255, 0.25);
}
.hero-glow {
  position: absolute;
  top: -60rpx;
  right: -60rpx;
  width: 200rpx;
  height: 200rpx;
  border-radius: 50%;
  background: radial-gradient(circle, rgba(255, 255, 255, 0.18) 0%, transparent 70%);
  pointer-events: none;
}
.hero-img-wrap {
  width: 100%;
  height: 280rpx;
  border-radius: 20rpx;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.15);
  margin-bottom: 20rpx;
  position: relative;
  z-index: 1;
}
.hero-img {
  width: 100%;
  height: 100%;
}
.hero-placeholder {
  font-size: 100rpx;
  opacity: 0.5;
}
.hero-info {
  position: relative;
  z-index: 1;
}
.hero-top-row {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  margin-bottom: 16rpx;
}
.hero-name-area {
  flex: 1;
  margin-right: 16rpx;
}
.hero-name {
  font-size: 32rpx;
  font-weight: 800;
  color: #ffffff;
  letter-spacing: 0.5rpx;
  text-shadow: 0 2rpx 6rpx rgba(0, 0, 0, 0.1);
  line-height: 1.35;
  margin-bottom: 10rpx;
  display: block;
}
.type-tag-row {
  display: flex;
  gap: 10rpx;
}
.type-badge {
  font-size: 21rpx;
  font-weight: 700;
  padding: 6rpx 16rpx;
  border-radius: 10rpx;
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
}
.tb-ev { background: rgba(255, 255, 255, 0.22); color: #ffffff; }
.tb-phev { background: rgba(255, 255, 255, 0.18); color: #b45309; }
.tb-erev { background: rgba(255, 255, 255, 0.18); color: #059669; }
.year-tag {
  font-size: 21rpx;
  font-weight: 600;
  padding: 6rpx 14rpx;
  border-radius: 10rpx;
  background: rgba(255, 255, 255, 0.15);
  color: rgba(255, 255, 255, 0.9);
}

.status-badge {
  border-radius: 14rpx;
  padding: 8rpx 18rpx;
  font-size: 22rpx;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 8rpx;
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  flex-shrink: 0;
}
.badge-dot {
  width: 10rpx;
  height: 10rpx;
  border-radius: 50%;
  background: #ffffff;
  box-shadow: 0 0 8rpx #ffffff;
  animation: badgePulse 2s ease-in-out infinite;
}
@keyframes badgePulse {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.5; transform: scale(0.85); }
}
.badge-1 { background: rgba(255, 255, 255, 0.22); color: #ffffff; border: 1rpx solid rgba(255, 255, 255, 0.35); }
.badge-0 { background: rgba(255, 255, 255, 0.15); color: #dc2626; border: 1rpx solid rgba(220, 38, 38, 0.4); }
.badge-2 { background: rgba(255, 255, 255, 0.18); color: #d97706; border: 1rpx solid rgba(217,119,6,0.4); }

.price-row {
  display: flex;
  align-items: baseline;
  gap: 12rpx;
}
.price-symbol {
  font-size: 32rpx;
  font-weight: 700;
  color: #ffffff;
}
.price-num {
  font-size: 52rpx;
  font-weight: 900;
  color: #ffffff;
  letter-spacing: -1rpx;
}
.price-original {
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.7);
  text-decoration: line-through;
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
  overflow: hidden;
}

.title-bar {
  display: flex;
  flex-direction: row;
  align-items: center;
  margin-bottom: 18rpx;
}
.bar-line {
  width: 7rpx;
  height: 32rpx;
  border-radius: 4rpx;
  margin-right: 12rpx;
  background: linear-gradient(180deg, #f59e0b, #f97316);
  box-shadow: 0 0 12rpx rgba(245, 158, 11, 0.35);
}
.bar-line-green { background: linear-gradient(180deg, #d97706, #f59e0b); box-shadow: 0 0 12rpx rgba(217,119,6,0.35); }
.bar-line-blue { background: linear-gradient(180deg, #f59e0b, #fb923c); box-shadow: 0 0 12rpx rgba(245,158,11,0.35); }
.bar-line-purple { background: linear-gradient(180deg, #fb923c, #fbbf24); box-shadow: 0 0 12rpx rgba(251,146,60,0.35); }
.bar-line-orange { background: linear-gradient(180deg, #f97316, #ea580c); box-shadow: 0 0 12rpx rgba(249, 115, 22, 0.35); }

.icon-wrap {
  width: 48rpx;
  height: 48rpx;
  border-radius: 14rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 12rpx;
}
.iw-amber { background: linear-gradient(135deg, rgba(245, 158, 11, 0.15), rgba(251, 146, 60, 0.08)); }
.iw-green { background: linear-gradient(135deg, rgba(34, 197, 94, 0.15), rgba(22, 163, 74, 0.08)); }
.iw-blue { background: linear-gradient(135deg, rgba(59, 130, 246, 0.15), rgba(37, 99, 235, 0.08)); }
.iw-purple { background: linear-gradient(135deg, rgba(168, 85, 247, 0.15), rgba(147, 51, 234, 0.08)); }
.iw-orange { background: linear-gradient(135deg, rgba(249, 115, 22, 0.15), rgba(234, 88, 12, 0.08)); }

.bar-icon { font-size: 26rpx; }
.bar-title {
  font-size: 30rpx;
  font-weight: 800;
  color: #1c1917;
  flex: 1;
  letter-spacing: 0.5rpx;
}

/* ========== 基本信息卡 ========== */
.info-card {
  background: linear-gradient(135deg, rgba(254, 251, 236, 0.98), rgba(255, 255, 255, 1));
  border-radius: 18rpx;
  padding: 16rpx 18rpx;
  border: 1rpx solid rgba(245, 158, 11, 0.08);
}
.info-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12rpx;
}
.info-item {
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.9), rgba(255, 255, 255, 1));
  border-radius: 14rpx;
  padding: 16rpx 14rpx;
  display: flex;
  flex-direction: column;
}
.info-item-colors {
  grid-column: span 2;
}
.info-label {
  font-size: 23rpx;
  color: #a16207;
  font-weight: 600;
  margin-bottom: 8rpx;
}
.info-value {
  font-size: 27rpx;
  color: #1c1917;
  font-weight: 700;
}
.info-value.highlight { color: #d97706; }
.info-unit {
  font-size: 22rpx;
  font-weight: normal;
  color: #78716c;
  margin-left: 4rpx;
}

.color-list {
  display: flex;
  flex-wrap: wrap;
  gap: 16rpx;
  margin-top: 4rpx;
}
.color-item {
  display: flex;
  align-items: center;
  gap: 8rpx;
}
.color-dot {
  width: 28rpx;
  height: 28rpx;
  border-radius: 50%;
  border: 2rpx solid rgba(0, 0, 0, 0.08);
  flex-shrink: 0;
  box-shadow: 0 2rpx 6rpx rgba(0, 0, 0, 0.08);
}
.color-name {
  font-size: 23rpx;
  color: #78716c;
  font-weight: 600;
}
.color-name.color-active {
  color: #d97706;
  font-weight: 700;
}

/* ========== 规格参数卡 ========== */
.spec-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12rpx;
}
.spec-item {
  background: linear-gradient(135deg, rgba(238, 242, 255, 0.98), rgba(255, 255, 255, 1));
  border-radius: 14rpx;
  padding: 16rpx 14rpx;
  display: flex;
  flex-direction: column;
  border: 1rpx solid rgba(59, 130, 246, 0.06);
}
.spec-label {
  font-size: 23rpx;
  color: #475569;
  font-weight: 600;
  margin-bottom: 8rpx;
}
.spec-value {
  font-size: 27rpx;
  color: #1c1917;
  font-weight: 700;
}
.spec-unit {
  font-size: 22rpx;
  font-weight: normal;
  color: #78716c;
  margin-left: 4rpx;
}

/* ========== 电池诊断卡 ========== */
.battery-card {
  background: linear-gradient(135deg, rgba(240, 253, 244, 0.98), rgba(255, 255, 255, 1));
  border-radius: 18rpx;
  padding: 18rpx 20rpx;
  border: 1rpx solid rgba(34, 197, 94, 0.08);
}
.soh-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16rpx;
}
.soh-left {
  display: flex;
  flex-direction: column;
}
.soh-label {
  font-size: 23rpx;
  color: #166534;
  font-weight: 600;
  margin-bottom: 6rpx;
}
.soh-value {
  font-size: 42rpx;
  font-weight: 900;
  letter-spacing: -0.5rpx;
}
.soh-value.soh-excellent { color: #16a34a; }
.soh-value.soh-good { color: #22c55e; }
.soh-value.soh-normal { color: #eab308; }
.soh-value.soh-warning { color: #ef4444; }
.soh-unit {
  font-size: 24rpx;
  font-weight: normal;
  margin-left: 4rpx;
}
.soh-right { flex-shrink: 0; }
.status-eval {
  font-size: 23rpx;
  font-weight: 800;
  padding: 10rpx 22rpx;
  border-radius: 14rpx;
}
.eval-excellent { color: #166534; background: linear-gradient(135deg, rgba(22, 163, 74, 0.15), rgba(34, 197, 94, 0.08)); }
.eval-good { color: #15803d; background: linear-gradient(135deg, rgba(34, 197, 94, 0.12), rgba(74, 222, 128, 0.06)); }
.eval-normal { color: #a16207; background: linear-gradient(135deg, rgba(234, 179, 8, 0.15), rgba(250, 204, 21, 0.08)); }
.eval-warning { color: #dc2626; background: linear-gradient(135deg, rgba(239, 68, 68, 0.12), rgba(248, 113, 113, 0.06)); }

.progress-wrap { margin-bottom: 16rpx; }
.progress-bar {
  width: 100%;
  height: 14rpx;
  background: rgba(0, 0, 0, 0.06);
  border-radius: 7rpx;
  overflow: hidden;
}
.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #22c55e, #4ade80, #86efac);
  border-radius: 7rpx;
  transition: width 0.6s ease;
}

.battery-meta {
  display: flex;
  align-items: center;
  background: rgba(255, 255, 255, 0.7);
  border-radius: 12rpx;
  padding: 14rpx 16rpx;
}
.meta-item {
  flex: 1;
  display: flex;
  flex-direction: column;
}
.meta-label {
  font-size: 21rpx;
  color: #78716c;
  font-weight: 600;
  margin-bottom: 4rpx;
}
.meta-value {
  font-size: 25rpx;
  color: #1c1917;
  font-weight: 700;
}
.meta-unit {
  font-size: 21rpx;
  font-weight: normal;
  color: #78716c;
  margin-left: 4rpx;
}
.meta-divider {
  width: 1rpx;
  height: 40rpx;
  background: linear-gradient(180deg, transparent, #6b7280, transparent);
}

/* ========== 描述卡 ========== */
.desc-card {
  background: linear-gradient(135deg, rgba(250, 245, 255, 0.98), rgba(255, 255, 255, 1));
  border-radius: 18rpx;
  padding: 18rpx 20rpx;
  border: 1rpx solid rgba(168, 85, 247, 0.08);
}
.desc-content {
  font-size: 26rpx;
  color: #44403c;
  line-height: 1.85;
}
.expand-row {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8rpx;
  margin-top: 16rpx;
  padding: 12rpx 0;
  border-top: 1rpx solid rgba(168, 85, 247, 0.08);
}
.expand-text {
  font-size: 24rpx;
  color: #d97706;
  font-weight: 600;
}
.expand-arrow {
  font-size: 24rpx;
  color: #d97706;
  font-weight: 700;
}
.desc-empty {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 36rpx 20rpx;
  border: 2rpx dashed rgba(168, 85, 247, 0.2);
  border-radius: 14rpx;
}
.empty-hint {
  font-size: 25rpx;
  color: #a8a29e;
}
.empty-arrow {
  font-size: 30rpx;
  color: #d97706;
  font-weight: 700;
}

/* ========== 库存信息卡 ========== */
.stock-stats {
  display: flex;
  align-items: center;
  background: linear-gradient(135deg, rgba(255, 247, 237, 0.98), rgba(255, 255, 255, 1));
  border-radius: 18rpx;
  padding: 24rpx 8rpx;
  border: 1rpx solid rgba(249, 115, 22, 0.08);
}
.stock-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6rpx;
}
.stock-num {
  font-size: 36rpx;
  font-weight: 900;
  color: #1c1917;
  letter-spacing: 0.5rpx;
}
.stock-num.stock-low { color: #ef4444; }
.stock-num.stock-normal { color: #f97316; }
.stock-num.stock-high { color: #16a34a; }
.stock-label {
  font-size: 21rpx;
  color: #a8a29e;
  font-weight: 600;
}
.stock-divider {
  width: 1rpx;
  height: 52rpx;
  background: linear-gradient(180deg, transparent, #6b7280, transparent);
}
.stock-status-tag {
  font-size: 22rpx;
  font-weight: 800;
  padding: 6rpx 18rpx;
  border-radius: 10rpx;
}
.sst-good { color: #16a34a; background: linear-gradient(135deg, rgba(22, 163, 74, 0.12), rgba(34, 197, 94, 0.06)); }
.sst-warning { color: #f97316; background: linear-gradient(135deg, rgba(249, 115, 22, 0.12), rgba(234, 88, 12, 0.06)); }
.sst-danger { color: #ef4444; background: linear-gradient(135deg, rgba(239, 68, 68, 0.12), rgba(248, 113, 113, 0.06)); }
.sst-unknown { color: #78716c; background: linear-gradient(135deg, rgba(156, 163, 175, 0.12), rgba(209, 213, 219, 0.06)); }

/* ========== 快捷操作区 ========== */
.action-section {
  display: flex;
  gap: 16rpx;
  padding: 0 24rpx;
  position: relative;
  z-index: 2;
}
.action-card {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 28rpx 16rpx;
  border-radius: 22rpx;
  position: relative;
  overflow: hidden;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  box-shadow: 0 6rpx 24rpx rgba(0, 0, 0, 0.06);
}
.act-hover {
  transform: scale(0.95)!important;
  box-shadow: 0 12rpx 32rpx rgba(0, 0, 0, 0.12)!important;
}
.act-color-bar {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 5rpx;
  border-radius: 22rpx 0 0 22rpx;
  transition: all 0.3s ease;
}
.act-edit {
  background: linear-gradient(135deg, #f59e0b, #f97316, #fb923c);
}
.act-edit .act-color-bar { background: linear-gradient(180deg, #ffffff 0%, rgba(255,255,255,0.3) 100%); }
.act-edit .act-icon, .act-edit .act-name { color: #ffffff; }
.act-edit .act-desc { color: rgba(255, 255, 255, 0.8); }

.act-desc {
  background: linear-gradient(135deg, #f59e0b, #f97316, #fb923c);
}
.act-desc .act-color-bar { background: linear-gradient(180deg, #ffffff 0%, rgba(255,255,255,0.3) 100%); }
.act-desc .act-icon, .act-desc .act-name { color: #ffffff; }
.act-desc .act-desc { color: rgba(255, 255, 255, 0.8); }

.act-back {
  background: linear-gradient(135deg, #6b7280, #4b5563, #374151);
}
.act-back .act-color-bar { background: linear-gradient(180deg, #ffffff 0%, rgba(255,255,255,0.3) 100%); }
.act-back .act-icon, .act-back .act-name { color: #ffffff; }
.act-back .act-desc { color: rgba(255, 255, 255, 0.8); }

.act-hover .act-color-bar { width: 7rpx; }

.act-icon { font-size: 36rpx; margin-bottom: 10rpx; }
.act-name { font-size: 26rpx; font-weight: 800; margin-bottom: 6rpx; }
.act-desc { font-size: 20rpx; font-weight: 500; }
</style>
