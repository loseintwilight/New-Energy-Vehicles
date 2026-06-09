<template>
  <view class="page" :class="{ 'page-ready': isReady }">
    <!-- 背景光晕矩阵（琥珀橙系） -->
    <view class="glow-matrix">
      <view class="glow-row" v-for="(row, ri) in glowRows" :key="ri">
        <view class="glow-spot" v-for="(dot, ci) in row.dots" :key="ci" :style="dot.style"></view>
      </view>
    </view>
    <view class="overlay-mask"></view>

    <!-- 主滚动区 -->
    <scroll-view scroll-y class="main-scroll" :show-scrollbar="false">
      <!-- 顶栏（动态渐变背景） -->
      <view class="header">
        <view class="header-bg" :class="'bg-' + diagnosisLevel"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="header-info">
          <text class="header-title">车辆详情</text>
          <text class="header-sub">{{ car.name }}</text>
        </view>
      </view>

      <!-- 价格展示卡片 -->
      <view class="price-section">
        <view class="price-card">
          <view class="price-glow"></view>
          <view class="price-main">
            <text class="price-symbol">¥</text>
            <text class="price-num">{{ formatPrice(car.price) }}</text>
            <text v-if="car.originalPrice && car.originalPrice !== car.price" class="price-original">¥{{ formatPrice(car.originalPrice) }}</text>
          </view>
          <view class="cert-tag">
            <text>官方认证二手车</text>
          </view>
        </view>
      </view>

      <!-- 基础信息网格 -->
      <view class="section-block sb-info">
        <view class="title-bar">
          <view class="bar-line"></view>
          <view class="icon-wrap iw-amber">
            <text class="bar-icon">📋</text>
          </view>
          <text class="bar-title">基础信息</text>
        </view>
        <view class="info-grid">
          <view class="info-item">
            <text class="info-label">车型名称</text>
            <text class="info-value">{{ car.name || '-' }}</text>
          </view>
          <view class="info-item">
            <text class="info-label">外观颜色</text>
            <text class="info-value">{{ car.color || '-' }}</text>
          </view>
          <view class="info-item">
            <text class="info-label">上牌时间</text>
            <text class="info-value">{{ licenseDateText }}</text>
          </view>
          <view class="info-item">
            <text class="info-label">上牌城市</text>
            <text class="info-value">{{ car.licenseCity || '-' }}</text>
          </view>
          <view class="info-item">
            <text class="info-label">表显里程</text>
            <text class="info-value highlight">{{ car.mileage || 0 }}<text class="info-unit">万km</text></text>
          </view>
          <view class="info-item">
            <text class="info-label">过户次数</text>
            <text class="info-value">{{ car.transferCount || 0 }}<text class="info-unit">次</text></text>
          </view>
        </view>
      </view>

      <!-- 电池健康度仪表盘 -->
      <view class="section-block sb-battery">
        <view class="title-bar">
          <view class="bar-line bar-line-soh"></view>
          <view class="icon-wrap iw-soh">
            <text class="bar-icon">🔋</text>
          </view>
          <text class="bar-title">电池健康度</text>
        </view>
        <view class="soh-dashboard">
          <view class="soh-ring-wrap">
            <view class="soh-ring" :style="{ background: sohGradient }">
              <view class="soh-ring-inner">
                <text class="soh-percent" :class="'soh-color-' + sohColorLv">{{ car.batterySoh || 0 }}<text class="soh-percent-unit">%</text></text>
                <text class="soh-status-text">{{ sohStatusText }}</text>
              </view>
            </view>
          </view>
          <view class="soh-meta-row">
            <view class="soh-meta-item">
              <text class="meta-label">循环次数</text>
              <text class="meta-value">{{ car.batteryCycles || 0 }}<text class="meta-unit">次</text></text>
            </view>
            <view class="soh-meta-divider"></view>
            <view class="soh-meta-item">
              <text class="meta-label">诊断评级</text>
              <view :class="['eval-tag', 'eval-' + diagnosisLevel]">
                <text>{{ diagnosisLabel }}</text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <!-- 估价信息卡片 -->
      <view class="section-block sb-valuation">
        <view class="title-bar">
          <view class="bar-line bar-line-val"></view>
          <view class="icon-wrap iw-val">
            <text class="bar-icon">💰</text>
          </view>
          <text class="bar-title">专业估价</text>
        </view>
        <view class="valuation-card">
          <view class="val-price-row">
            <text class="val-symbol">¥</text>
            <text class="val-num">{{ formatPrice(car.valuationPrice) }}</text>
          </view>
          <text class="val-desc">{{ car.valuationInfo || '-' }}</text>
        </view>
      </view>

      <!-- 车辆描述区域 -->
      <view class="section-block sb-desc">
        <view class="title-bar">
          <view class="bar-line bar-line-desc"></view>
          <view class="icon-wrap iw-desc">
            <text class="bar-icon">📝</text>
          </view>
          <text class="bar-title">车辆描述</text>
        </view>
        <view class="desc-card">
          <text class="desc-text">{{ car.description || '暂无描述' }}</text>
          <view v-if="car.tags && car.tags.length > 0" class="tag-cloud">
            <view class="tag-item" v-for="(tag, idx) in car.tags" :key="idx">
              <text>{{ tag }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 底部操作区 -->
      <view class="action-section">
        <view class="action-card act-edit" hover-class="act-hover" @tap="goEditCar">
          <view class="act-color-bar"></view>
          <text class="act-icon">✏️</text>
          <text class="act-name">编辑车辆</text>
          <text class="act-desc">修改车辆信息</text>
        </view>
        <view class="action-card act-toggle" hover-class="act-hover" @tap="toggleStatus">
          <view class="act-color-bar"></view>
          <text class="act-icon">{{ car.status === '1' ? '⏸' : '▶' }}</text>
          <text class="act-name">{{ car.status === '1' ? '下架' : '上架' }}</text>
          <text class="act-desc">{{ car.status === '1' ? '暂停销售' : '恢复销售' }}</text>
        </view>
        <view class="action-card act-delete" hover-class="act-hover" @tap="confirmDelete">
          <view class="act-color-bar"></view>
          <text class="act-icon">🗑</text>
          <text class="act-name">删除车辆</text>
          <text class="act-desc">永久删除此车源</text>
        </view>
      </view>

      <view style="height: 120rpx;"></view>
    </scroll-view>
  </view>
</template>

<script>
var USE_MOCK = false

import request from '@/utils/request'
import { getUsedCarDetail } from '@/api/vehicle/vehicle'

function mockGetUsedCarDetail(usedId) {
  var mockDataMap = {
    1: {
      usedId: 1,
      vehicleId: 101,
      name: '比亚迪海豹 EV 700km 四驱旗舰版',
      price: 168000,
      originalPrice: 228000,
      mileage: 2.8,
      licenseYear: 2024,
      licenseMonth: 6,
      licenseCity: '济南',
      transferCount: 0,
      batterySoh: 96.5,
      batteryCycles: 128,
      batteryDiagnosis: 'excellent',
      valuationPrice: 172000,
      valuationInfo: '车况优良，电池健康度96.5%，仅行驶2.8万公里，原版原漆，无事故无水泡。',
      color: '极光蓝',
      stock: 1,
      status: '1',
      description: '2024年6月上牌，一手车，全程4S店保养。配备热泵空调、丹拿音响、HUD抬头显示等高端配置。',
      tags: ['一手车', '原版原漆', '4S保养', '无事故'],
      viewCount: 256
    },
    2: {
      usedId: 2,
      vehicleId: 102,
      name: '特斯拉 Model Y 长续航全轮驱动版',
      price: 228000,
      originalPrice: 299900,
      mileage: 4.2,
      licenseYear: 2023,
      licenseMonth: 11,
      licenseCity: '青岛',
      transferCount: 1,
      batterySoh: 92.8,
      batteryCycles: 215,
      batteryDiagnosis: 'excellent',
      valuationPrice: 235000,
      valuationInfo: '车况良好，电池健康度92.8%，行驶4.2万公里，有过一次过户记录，整体保养到位。',
      color: '珍珠白',
      stock: 1,
      status: '1',
      description: '2023年11月上牌，原车主因换购新车出售。Autopilot基础版已开通，内饰整洁如新。',
      tags: ['过户一次', '原版原漆', 'AP开通', '内饰新净'],
      viewCount: 189
    },
    3: {
      usedId: 3,
      vehicleId: 103,
      name: '蔚来 ES6 75kWh 运动版',
      price: 195000,
      originalPrice: 338000,
      mileage: 6.5,
      licenseYear: 2023,
      licenseMonth: 3,
      licenseCity: '北京',
      transferCount: 2,
      batterySoh: 85.3,
      batteryCycles: 320,
      batteryDiagnosis: 'good',
      valuationPrice: 188000,
      valuationInfo: '电池健康度85.3%处于良好水平，行驶里程较多但维护规范，适合性价比需求客户。',
      color: '星空蓝',
      stock: 1,
      status: '1',
      description: '2023年3月上牌，NOMI智能助手标配，BaaS电池租用方案可灵活选择。外观有轻微使用痕迹。',
      tags: ['NOMI标配', 'BaaS可选', '轻微划痕', '性价比高'],
      viewCount: 342
    }
  }
  var data = mockDataMap[usedId]
  if (!data) { data = mockDataMap[1] }
  return { code: 200, msg: '操作成功', data: data }
}

export default {
  data: function() {
    return {
      isReady: false,
      glowRows: [],
      usedId: '',
      car: null,
      loading: true
    }
  },
  onLoad: function(options) {
    var that = this
    if (options && options.usedId) {
      that.usedId = options.usedId
      that.loadDetail()
    }
    that.buildGlowRows()
    setTimeout(function() { that.isReady = true }, 200)
  },
  onShow: function() {
    if (this.usedId) { this.loadDetail() }
  },
  computed: {
    diagnosisLevel: function() {
      if (!this.car) return 'poor'
      return this.car.batteryDiagnosis || 'poor'
    },
    sohColorLv: function() {
      if (!this.car || !this.car.batterySoh) return 'warn'
      var s = Number(this.car.batterySoh)
      if (s >= 90) return 'excellent'
      if (s >= 80) return 'good'
      if (s >= 70) return 'fair'
      return 'warn'
    },
    sohStatusText: function() {
      if (!this.car || !this.car.batterySoh) return '-'
      var s = Number(this.car.batterySoh)
      if (s >= 90) return '健康'
      if (s >= 80) return '良好'
      if (s >= 70) return '一般'
      return '较差'
    },
    sohGradient: function() {
      if (!this.car || !this.car.batterySoh) return ''
      var s = Number(this.car.batterySoh)
      var deg = Math.round(s * 3.6)
      var color = '#22c55e'
      if (s >= 90) color = '#16a34a'
      else if (s >= 80) color = '#f59e0b'
      else if (s >= 70) color = '#f97316'
      else color = '#ef4444'
      return 'conic-gradient(' + color + ' ' + deg + 'deg, #e5e7eb 0deg)'
    },
    diagnosisLabel: function() {
      var map = { excellent: '优秀', good: '良好', fair: '一般', poor: '较差' }
      return map[this.diagnosisLevel] || '未知'
    },
    licenseDateText: function() {
      if (!this.car) return '-'
      var y = this.car.licenseYear || ''
      var m = this.car.licenseMonth || ''
      if (!y) return '-'
      return y + '年' + (m ? m + '月' : '')
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
        var res = mockGetUsedCarDetail(self.usedId)
        setTimeout(function() { self.handleRes(res) }, 300)
      } else {
        getUsedCarDetail(self.usedId).then(function(res) {
          self.handleRes(res)
        }).catch(function(err) {
          self.loading = false
          uni.showToast({ title: '获取数据失败', icon: 'none' })
        })
      }
    },

    handleRes: function(res) {
      var self = this
      self.loading = false
      if (res.code === 200 && res.data) {
        var v = res.data
        self.car = {
          usedId: v.usedId || v.vehicleId,
          vehicleId: v.vehicleId,
          name: v.modelName || v.title || '-',
          price: v.guidePrice || 0,
          originalPrice: v.originalPrice || 0,
          mileage: v.mileage || 0,
          licenseYear: v.licenseYear || '',
          licenseMonth: v.licenseMonth || '',
          licenseCity: v.licenseCity || '',
          transferCount: v.transferCount || 0,
          batterySoh: v.batterySoh || 0,
          batteryCycles: v.batteryCycles || 0,
          batteryDiagnosis: v.batteryDiagnosis || 'poor',
          valuationPrice: v.valuationPrice || 0,
          valuationInfo: v.valuationInfo || '-',
          color: v.color || '-',
          stock: v.stock || 0,
          status: String(v.status || '0'),
          description: v.description || '',
          tags: v.tags ? String(v.tags).split(',').filter(Boolean) : [],
          viewCount: v.viewCount || 0
        }
      } else if (res.code === 1 && res.data) {
        var v = res.data
        self.car = {
          usedId: v.usedId || v.vehicleId,
          vehicleId: v.vehicleId,
          name: v.modelName || v.title || '-',
          price: v.guidePrice || 0,
          originalPrice: v.originalPrice || 0,
          mileage: v.mileage || 0,
          licenseYear: v.licenseYear || '',
          licenseMonth: v.licenseMonth || '',
          licenseCity: v.licenseCity || '',
          transferCount: v.transferCount || 0,
          batterySoh: v.batterySoh || 0,
          batteryCycles: v.batteryCycles || 0,
          batteryDiagnosis: v.batteryDiagnosis || 'poor',
          valuationPrice: v.valuationPrice || 0,
          valuationInfo: v.valuationInfo || '-',
          color: v.color || '-',
          stock: v.stock || 0,
          status: String(v.status || '0'),
          description: v.description || '',
          tags: v.tags ? String(v.tags).split(',').filter(Boolean) : [],
          viewCount: v.viewCount || 0
        }
      }
    },

    formatPrice: function(price) {
      if (!price) return '0'
      return Number(price).toLocaleString('zh-CN')
    },

    goBack: function() {
      uni.navigateBack({ delta: 1 })
    },

    goEditCar: function() {
      uni.navigateTo({
        url: '/pages/mine/vehicle/used-car-add?usedId=' + this.usedId + '&mode=edit'
      })
    },

    toggleStatus: function() {
      var that = this
      var newStatus = that.car.status === '1' ? '0' : '1'
      uni.showModal({
        title: '提示',
        content: newStatus === '1' ? '确定要上架该车辆吗？' : '确定要下架该车辆吗？',
        confirmColor: '#d97706',
        success: function(res) {
          if (res.confirm) {
            that.car.status = newStatus
            uni.showToast({ title: newStatus === '1' ? '已上架' : '已下架', icon: 'success' })
          }
        }
      })
    },

    confirmDelete: function() {
      var that = this
      uni.showModal({
        title: '删除确认',
        content: '确定要删除该二手车吗？删除后数据无法恢复！',
        confirmColor: '#ea580c',
        success: function(res) {
          if (res.confirm) {
            uni.showToast({ title: '已删除', icon: 'success' })
            setTimeout(function() { uni.navigateBack({ delta: 1 }) }, 1500)
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

/* ========== 入场动画 ========== */
.page-ready .price-section { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.05s; }
.page-ready .section-block:nth-of-type(1) { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.12s; }
.page-ready .section-block:nth-of-type(2) { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.19s; }
.page-ready .section-block:nth-of-type(3) { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.26s; }
.page-ready .section-block:nth-of-type(4) { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.33s; }
.page-ready .action-section { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.40s; }

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

/* ========== 顶栏（动态渐变背景） ========== */
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
  border-radius: 0 0 60rpx 60rpx;
}
.bg-excellent { background: linear-gradient(135deg, #d97706 0%, #b45309 35%, #92400e 65%, #78350f 100%); }
.bg-good { background: linear-gradient(135deg, #f59e0b 0%, #f97316 35%, #fb923c 65%, #fdba74 100%); }
.bg-fair { background: linear-gradient(135deg, #fb923c 0%, #fdba74 35%, #fed7aa 65%, #fde68a 100%); }
.bg-poor { background: linear-gradient(135deg, #ea580c 0%, #dc2626 35%, #ef4444 65%, #f87171 100%); }

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

/* ========== 价格展示卡片 ========== */
.price-section {
  margin: 0 24rpx 20rpx;
}
.price-card {
  background: linear-gradient(135deg, #f59e0b 0%, #f97316 40%, #fb923c 70%, #fdba74 100%);
  border-radius: 28rpx;
  padding: 32rpx 28rpx;
  position: relative;
  overflow: hidden;
  box-shadow:
    0 12rpx 40rpx rgba(245, 158, 11, 0.35),
    inset 0 1rpx 0 rgba(255, 255, 255, 0.25);
}
.price-glow {
  position: absolute;
  top: -50rpx;
  right: -50rpx;
  width: 180rpx;
  height: 180rpx;
  border-radius: 50%;
  background: radial-gradient(circle, rgba(255, 255, 255, 0.18) 0%, transparent 70%);
  pointer-events: none;
}
.price-main {
  display: flex;
  align-items: baseline;
  gap: 10rpx;
  position: relative;
  z-index: 1;
}
.price-symbol {
  font-size: 32rpx;
  font-weight: 700;
  color: #ffffff;
}
.price-num {
  font-size: 56rpx;
  font-weight: 900;
  color: #ffffff;
  letter-spacing: -1rpx;
}
.price-original {
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.7);
  text-decoration: line-through;
}
.cert-tag {
  display: inline-flex;
  margin-top: 18rpx;
  padding: 8rpx 24rpx;
  border-radius: 14rpx;
  background: rgba(255, 255, 255, 0.22);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
  position: relative;
  z-index: 1;
}
.cert-tag text {
  font-size: 23rpx;
  font-weight: 700;
  color: #ffffff;
  letter-spacing: 1rpx;
}

/* ========== 区块通用 ========== */
.section-block {
  margin: 0 24rpx 20rpx;
  background: rgba(255, 255, 255, 0.82);
  backdrop-filter: blur(18px);
  -webkit-backdrop-filter: blur(18px);
  border-radius: 26rpx;
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
.bar-line-soh { background: linear-gradient(180deg, #16a34a, #22c55e); box-shadow: 0 0 12rpx rgba(22,163,74,0.35); }
.bar-line-val { background: linear-gradient(180deg, #d97706, #f59e0b); box-shadow: 0 0 12rpx rgba(217,119,6,0.35); }
.bar-line-desc { background: linear-gradient(180deg, #fb923c, #fbbf24); box-shadow: 0 0 12rpx rgba(251,146,60,0.35); }

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
.iw-soh { background: linear-gradient(135deg, rgba(22, 163, 74, 0.15), rgba(34, 197, 94, 0.08)); }
.iw-val { background: linear-gradient(135deg, rgba(217, 119, 6, 0.15), rgba(245, 158, 11, 0.08)); }
.iw-desc { background: linear-gradient(135deg, rgba(251, 146, 60, 0.15), rgba(251, 191, 36, 0.08)); }

.bar-icon { font-size: 26rpx; }
.bar-title {
  font-size: 30rpx;
  font-weight: 800;
  color: #1c1917;
  flex: 1;
  letter-spacing: 0.5rpx;
}

/* ========== 基础信息网格 ========== */
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

/* ========== 电池SOH仪表盘 ========== */
.soh-dashboard {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 16rpx 0;
}
.soh-ring-wrap {
  margin-bottom: 24rpx;
}
.soh-ring {
  width: 220rpx;
  height: 220rpx;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 8rpx 30rpx rgba(0, 0, 0, 0.08);
}
.soh-ring-inner {
  width: 170rpx;
  height: 170rpx;
  border-radius: 50%;
  background: #ffffff;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  box-shadow: inset 0 2rpx 10rpx rgba(0, 0, 0, 0.04);
}
.soh-percent {
  font-size: 44rpx;
  font-weight: 900;
  letter-spacing: -0.5rpx;
  line-height: 1.1;
}
.soh-percent-unit {
  font-size: 24rpx;
  font-weight: normal;
}
.soh-color-excellent { color: #16a34a; }
.soh-color-good { color: #f59e0b; }
.soh-color-fair { color: #f97316; }
.soh-color-warn { color: #ef4444; }
.soh-status-text {
  font-size: 22rpx;
  font-weight: 600;
  color: #78716c;
  margin-top: 4rpx;
}

.soh-meta-row {
  display: flex;
  align-items: center;
  width: 100%;
  background: linear-gradient(135deg, rgba(240, 253, 244, 0.98), rgba(255, 255, 255, 1));
  border-radius: 16rpx;
  padding: 18rpx 20rpx;
  border: 1rpx solid rgba(22, 163, 74, 0.08);
}
.soh-meta-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
}
.soh-meta-divider {
  width: 1rpx;
  height: 44rpx;
  background: linear-gradient(180deg, transparent, #d1d5db, transparent);
}
.meta-label {
  font-size: 21rpx;
  color: #78716c;
  font-weight: 600;
  margin-bottom: 6rpx;
}
.meta-value {
  font-size: 27rpx;
  color: #1c1917;
  font-weight: 700;
}
.meta-unit {
  font-size: 21rpx;
  font-weight: normal;
  color: #78716c;
  margin-left: 4rpx;
}
.eval-tag {
  font-size: 23rpx;
  font-weight: 800;
  padding: 6rpx 20rpx;
  border-radius: 12rpx;
}
.eval-excellent { color: #166534; background: linear-gradient(135deg, rgba(22, 163, 74, 0.15), rgba(34, 197, 94, 0.08)); }
.eval-good { color: #92400e; background: linear-gradient(135deg, rgba(245, 158, 11, 0.15), rgba(251, 146, 60, 0.08)); }
.eval-fair { color: #c2410c; background: linear-gradient(135deg, rgba(249, 115, 22, 0.15), rgba(234, 88, 12, 0.08)); }
.eval-poor { color: #dc2626; background: linear-gradient(135deg, rgba(239, 68, 68, 0.12), rgba(248, 113, 113, 0.06)); }

/* ========== 估价信息卡片 ========== */
.valuation-card {
  background: linear-gradient(135deg, rgba(254, 251, 236, 0.98), rgba(255, 255, 255, 1));
  border-radius: 18rpx;
  padding: 22rpx 20rpx;
  border: 1rpx solid rgba(245, 158, 11, 0.08);
}
.val-price-row {
  display: flex;
  align-items: baseline;
  gap: 8rpx;
  margin-bottom: 14rpx;
}
.val-symbol {
  font-size: 28rpx;
  font-weight: 700;
  color: #d97706;
}
.val-num {
  font-size: 46rpx;
  font-weight: 900;
  color: #d97706;
  letter-spacing: -0.5rpx;
}
.val-desc {
  font-size: 25rpx;
  color: #78716c;
  line-height: 1.7;
}

/* ========== 车辆描述区域 ========== */
.desc-card {
  background: linear-gradient(135deg, rgba(255, 251, 235, 0.98), rgba(255, 255, 255, 1));
  border-radius: 18rpx;
  padding: 20rpx 18rpx;
  border: 1rpx solid rgba(251, 146, 60, 0.08);
}
.desc-text {
  font-size: 26rpx;
  color: #44403c;
  line-height: 1.8;
  display: block;
  margin-bottom: 16rpx;
}
.tag-cloud {
  display: flex;
  flex-wrap: wrap;
  gap: 12rpx;
  padding-top: 14rpx;
  border-top: 1rpx solid rgba(251, 146, 60, 0.08);
}
.tag-item {
  padding: 8rpx 20rpx;
  border-radius: 12rpx;
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.1), rgba(251, 146, 60, 0.05));
  border: 1rpx solid rgba(245, 158, 11, 0.15);
}
.tag-item text {
  font-size: 23rpx;
  font-weight: 600;
  color: #b45309;
}

/* ========== 操作按钮区 ========== */
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

.act-toggle {
  background: linear-gradient(135deg, #d97706, #f59e0b, #fbbf24);
}
.act-toggle .act-color-bar { background: linear-gradient(180deg, #ffffff 0%, rgba(255,255,255,0.3) 100%); }
.act-toggle .act-icon, .act-toggle .act-name { color: #ffffff; }
.act-toggle .act-desc { color: rgba(255, 255, 255, 0.8); }

.act-delete {
  background: linear-gradient(135deg, #ea580c, #dc2626, #ef4444);
}
.act-delete .act-color-bar { background: linear-gradient(180deg, #ffffff 0%, rgba(255,255,255,0.3) 100%); }
.act-delete .act-icon, .act-delete .act-name { color: #ffffff; }
.act-delete .act-desc { color: rgba(255, 255, 255, 0.8); }

.act-hover .act-color-bar { width: 7rpx; }

.act-icon { font-size: 36rpx; margin-bottom: 10rpx; }
.act-name { font-size: 26rpx; font-weight: 800; margin-bottom: 6rpx; }
.act-desc { font-size: 20rpx; font-weight: 500; }
</style>
