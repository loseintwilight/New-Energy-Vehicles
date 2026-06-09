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
      <!-- 顶栏（琥珀渐变） -->
      <view class="header">
        <view class="header-bg"></view>
        <view class="header-circle"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="header-info">
          <text class="header-title">{{ isEdit ? '编辑车辆' : '新增车辆' }}</text>
          <text class="header-sub">{{ isEdit ? '修改车辆信息' : '录入新车信息' }}</text>
        </view>
      </view>

      <!-- 基本信息卡（琥珀色条） -->
      <view class="section-block sb-amber">
        <view class="title-bar">
          <view class="bar-line"></view>
          <view class="icon-wrap iw-amber"><text class="bar-icon">📋</text></view>
          <text class="bar-title">基本信息</text>
        </view>
        <view class="form-card fc-orange">
          <view class="form-row">
            <text class="form-label"><text class="req">*</text>车型名称</text>
            <input class="form-input" v-model="form.name" placeholder="请输入车型完整名称" placeholder-class="ph" />
          </view>
          <view class="form-row">
            <text class="form-label"><text class="req">*</text>品牌</text>
            <input class="form-input" v-model="form.brand" placeholder="如：比亚迪、特斯拉、蔚来" placeholder-class="ph" />
          </view>
          <view class="form-row">
            <text class="form-label">年款</text>
            <input class="form-input" v-model="form.year" placeholder="如：2026款" placeholder-class="ph" />
          </view>
          <view class="form-row">
            <text class="form-label"><text class="req">*</text>状态</text>
            <picker class="form-picker" :range="statusOptions" range-key="label" :value="statusIndex" @change="onStatusChange">
              <text class="picker-txt" :class="{ 'ph-cls': !form.status }">{{ statusLabel || '请选择状态' }}</text>
              <text class="picker-arrow">▸</text>
            </picker>
          </view>
        </view>
      </view>

      <!-- 价格信息卡（绿色色条） -->
      <view class="section-block sb-green">
        <view class="title-bar">
          <view class="bar-line bar-line-green"></view>
          <view class="icon-wrap iw-green"><text class="bar-icon">💰</text></view>
          <text class="bar-title">价格信息</text>
        </view>
        <view class="form-card fc-green">
          <view class="form-row">
            <text class="form-label"><text class="req">*</text>售价(元)</text>
            <view class="input-wrap">
              <text class="input-prefix">¥</text>
              <input class="form-input input-no-border" type="digit" v-model="form.price" placeholder="0.00" placeholder-class="ph" />
            </view>
          </view>
          <view class="form-row">
            <text class="form-label">原价(元)</text>
            <view class="input-wrap">
              <text class="input-prefix">¥</text>
              <input class="form-input input-no-border" type="digit" v-model="form.originalPrice" placeholder="0.00" placeholder-class="ph" />
            </view>
          </view>
        </view>
      </view>

      <!-- 规格参数卡（蓝色色条） -->
      <view class="section-block sb-blue">
        <view class="title-bar">
          <view class="bar-line bar-line-blue"></view>
          <view class="icon-wrap iw-blue"><text class="bar-icon">⚙️</text></view>
          <text class="bar-title">规格参数</text>
        </view>
        <view class="spec-grid">
          <view class="spec-form-item">
            <text class="sf-label">续航(km)</text>
            <input class="sf-input" type="digit" v-model="form.range" placeholder="0" placeholder-class="ph" />
          </view>
          <view class="spec-form-item">
            <text class="sf-label">电池(kWh)</text>
            <input class="sf-input" type="digit" v-model="form.batteryCapacity" placeholder="0" placeholder-class="ph" />
          </view>
          <view class="spec-form-item">
            <text class="sf-label">快充时间</text>
            <input class="sf-input" v-model="form.fastChargeTime" placeholder="如：28分钟" placeholder-class="ph" />
          </view>
        </view>
      </view>

      <!-- 车身颜色卡（紫色色条） -->
      <view class="section-block sb-purple">
        <view class="title-bar">
          <view class="bar-line bar-line-purple"></view>
          <view class="icon-wrap iw-purple"><text class="bar-icon">🎨</text></view>
          <text class="bar-title">车身颜色</text>
        </view>
        <view class="color-card">
          <view class="color-tag-list">
            <view
              v-for="(c, idx) in colorOptions"
              :key="idx"
              class="color-tag"
              :class="{ 'ct-active': isColorSelected(c.name) }"
              @tap="toggleColor(c)"
            >
              <view class="ct-dot" :style="{ background: c.value }"></view>
              <text class="ct-name">{{ c.name }}</text>
            </view>
          </view>
          <view v-if="form.colors.length === 0" class="color-empty-hint">
            <text>点击选择车身颜色（可多选）</text>
          </view>
        </view>
      </view>

      <!-- 详细描述入口卡（橙色色条） -->
      <view class="section-block sb-orange">
        <view class="title-bar">
          <view class="bar-line bar-line-orange"></view>
          <view class="icon-wrap iw-orange"><text class="bar-icon">📝</text></view>
          <text class="bar-title">详细描述</text>
        </view>
        <view class="desc-entry" hover-class="desc-entry-hover" @tap="goDescEdit">
          <view class="de-left">
            <text class="de-icon">✏️</text>
            <text class="de-text">{{ form.description ? '已填写描述，点击编辑' : '暂无描述，点击添加详细介绍' }}</text>
          </view>
          <text class="de-arrow">→</text>
        </view>
      </view>

      <view style="height: 140rpx;"></view>
    </scroll-view>

    <!-- 底部保存按钮 -->
    <view class="bottom-bar">
      <view class="save-btn" hover-class="save-hover" @tap="submitForm">
        <text class="save-text">{{ submitting ? '保存中...' : '保存' }}</text>
      </view>
    </view>
  </view>
</template>

<script>
import { getVehicle, addVehicle, updateVehicle } from '@/api/vehicle/vehicle'

var colorOptions = [
  { name: '北极白', value: '#F5F5F5' },
  { name: '迷雾灰', value: '#6B7280' },
  { name: '海洋蓝', value: '#1E40AF' },
  { name: '热情红', value: '#DC2626' },
  { name: '星空黑', value: '#1F2937' },
  { name: '翡翠绿', value: '#059669' }
]

export default {
  data: function() {
    return {
      isReady: false,
      glowRows: [],
      isEdit: false,
      vehicleId: '',
      submitting: false,
      statusOptions: [
        { label: '待审核', value: '0' },
        { label: '在售', value: '1' },
        { label: '已卖', value: '2' },
        { label: '下架', value: '3' }
      ],
      colorOptions: colorOptions,
      /* 表单字段（对齐stad_vehicle + stad_vehicle_spec表） */
      form: {
        name: '',            // stad_vehicle.model_name
        brand: '',           // 品牌名称 → 提交到 description 字段
        year: '',             // stad_vehicle_spec.model_year
        status: '1',          // stad_vehicle.status (默认在售)
        price: '',            // stad_vehicle.guide_price
        originalPrice: '',    // stad_vehicle.original_price
        range: '',            // stad_vehicle_spec.range_km
        batteryCapacity: '',  // stad_vehicle_spec.battery_capacity
        fastChargeTime: '',   // stad_vehicle_spec.charge_time_fast
        colors: [],           // stad_vehicle.color
        description: ''       // stad_vehicle.description
      }
    }
  },
  computed: {
    statusIndex: function() {
      for (var i = 0; i < this.statusOptions.length; i++) {
        if (this.statusOptions[i].value === this.form.status) return i
      }
      return -1
    },
    statusLabel: function() {
      for (var i = 0; i < this.statusOptions.length; i++) {
        if (this.statusOptions[i].value === this.form.status) return this.statusOptions[i].label
      }
      return ''
    }
  },
  onLoad: function(options) {
    var that = this
    that.buildGlowRows()
    if (options && options.editMode === '1' && options.vehicleId) {
      that.isEdit = true
      that.vehicleId = options.vehicleId
      that.loadVehicleData()
    }
    setTimeout(function() { that.isReady = true }, 200)
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

    loadVehicleData: function() {
      var self = this
      getVehicle(self.vehicleId).then(function(res) {
        if (res.code === 1 && res.data) {
          self.fillFormData(res.data)
        } else {
          uni.showToast({ title: res.msg || '获取数据失败', icon: 'none' })
        }
      }).catch(function() {
        uni.showToast({ title: '获取数据失败', icon: 'none' })
      })
    },

    fillFormData: function(data) {
      if (!data) return
      var spec = data.vehicleSpec || {}
      this.form.name = data.modelName || data.title || ''
      this.form.year = spec.modelYear || ''
      this.form.status = String(data.status || '1')
      this.form.price = data.guidePrice !== undefined ? String(data.guidePrice) : ''
      this.form.originalPrice = data.originalPrice !== undefined ? String(data.originalPrice) : ''
      this.form.range = spec.rangeKm !== undefined ? String(spec.rangeKm) : ''
      this.form.batteryCapacity = spec.batteryCapacity !== undefined ? String(spec.batteryCapacity) : ''
      this.form.fastChargeTime = spec.chargeTimeFast || ''
      this.form.colors = data.color ? [data.color] : []
      this.form.description = data.description || ''
    },

    onStatusChange: function(e) {
      var idx = parseInt(e.detail.value)
      if (idx >= 0 && idx < this.statusOptions.length) {
        this.form.status = this.statusOptions[idx].value
      }
    },

    isColorSelected: function(name) {
      return this.form.colors.indexOf(name) > -1
    },

    toggleColor: function(c) {
      var idx = this.form.colors.indexOf(c.name)
      if (idx > -1) {
        this.form.colors.splice(idx, 1)
      } else {
        this.form.colors.push(c.name)
      }
    },

    goDescEdit: function() {
      uni.navigateTo({
        url: '/pages/mine/vehicle/vehicle-desc-edit?vehicleId=' + (this.vehicleId || '') + '&currentDesc=' + encodeURIComponent(this.form.description || '')
      })
    },

    goBack: function() {
      uni.navigateBack({ delta: 1 })
    },

    validateForm: function() {
      if (!this.form.name || !this.form.name.trim()) {
        uni.showToast({ title: '请输入车型名称', icon: 'none' }); return false
      }
      if (!this.form.price || !this.form.price.trim()) {
        uni.showToast({ title: '请输入售价', icon: 'none' }); return false
      }
      var p = parseFloat(this.form.price)
      if (isNaN(p) || p <= 0) {
        uni.showToast({ title: '售价必须大于0', icon: 'none' }); return false
      }
      return true
    },

    submitForm: function() {
      var self = this
      if (!self.validateForm()) return
      if (self.submitting) return
      self.submitting = true

      /* 组装提交数据 */
      var postData = {
        vehicleType: 'new',
        modelName: self.form.name,
        description: self.form.brand,  // 品牌写入 description 字段
        status: self.form.status,
        guidePrice: parseFloat(self.form.price),
        originalPrice: self.form.originalPrice ? parseFloat(self.form.originalPrice) : null,
        color: self.form.colors.length > 0 ? self.form.colors[0] : '',
        description: self.form.description,
        vehicleSpec: {
          rangeKm: self.form.range ? parseInt(self.form.range) : null,
          batteryCapacity: self.form.batteryCapacity ? parseFloat(self.form.batteryCapacity) : null,
          chargeTimeFast: self.form.fastChargeTime || null,
          modelYear: self.form.year || null
        }
      }

      var apiCall
      if (self.isEdit) {
        postData.vehicleId = self.vehicleId
        if (postData.vehicleSpec) postData.vehicleSpec.vehicleId = self.vehicleId
        apiCall = updateVehicle(postData)
      } else {
        apiCall = addVehicle(postData)
      }

      apiCall.then(function(res) {
        self.submitting = false
        if (res.code === 1) {
          uni.showToast({ title: self.isEdit ? '修改成功' : '添加成功', icon: 'success' })
          setTimeout(function() { uni.navigateBack({ delta: 1 }) }, 1200)
        } else {
          uni.showToast({ title: res.msg || '操作失败', icon: 'none' })
        }
      }).catch(function() {
        self.submitting = false
        uni.showToast({ title: '网络异常，请重试', icon: 'none' })
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
.page-ready .section-block:nth-of-type(1) { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.08s; }
.page-ready .section-block:nth-of-type(2) { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.16s; }
.page-ready .section-block:nth-of-type(3) { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.24s; }
.page-ready .section-block:nth-of-type(4) { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.32s; }
.page-ready .section-block:nth-of-type(5) { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.40s; }

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
  0% { opacity: 0.12; transform: scale(0.85); }
  50% { opacity: 0.55; }
  100% { opacity: 0.12; transform: scale(1.25); }
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

/* ========== 顶栏 ========== */
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
.header-sub {
  font-size: 24rpx; color: rgba(255, 255, 255, 0.88);
  margin-top: 6rpx; font-weight: 500;
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
  display: flex; flex-direction: row;
  align-items: center;
  margin-bottom: 18rpx;
}
.bar-line {
  width: 7rpx; height: 32rpx;
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
  width: 48rpx; height: 48rpx;
  border-radius: 14rpx;
  display: flex; align-items: center; justify-content: center;
  margin-right: 12rpx;
}
.iw-amber { background: linear-gradient(135deg, rgba(245, 158, 11, 0.15), rgba(251, 146, 60, 0.08)); }
.iw-green { background: linear-gradient(135deg, rgba(217,119,6,0.15), rgba(245,158,11,0.08)); }
.iw-blue { background: linear-gradient(135deg, rgba(245,158,11,0.15), rgba(251,146,60,0.08)); }
.iw-purple { background: linear-gradient(135deg, rgba(251,146,60,0.15), rgba(251,191,36,0.08)); }
.iw-orange { background: linear-gradient(135deg, rgba(249, 115, 22, 0.15), rgba(234, 88, 12, 0.08)); }
.bar-icon { font-size: 26rpx; }
.bar-title {
  font-size: 30rpx; font-weight: 800; color: #1c1917;
  flex: 1; letter-spacing: 0.5rpx;
}

/* ========== 表单卡片 ========== */
.form-card {
  background: linear-gradient(135deg, rgba(254, 251, 236, 0.98), rgba(255, 255, 255, 1));
  border-radius: 18rpx;
  padding: 4rpx 18rpx;
  border: 1rpx solid rgba(245, 158, 11, 0.08);
}
.fc-green {
  background: linear-gradient(135deg, rgba(240, 253, 244, 0.98), rgba(255, 255, 255, 1));
  border-color: rgba(34, 197, 94, 0.08);
}

.form-row {
  display: flex; align-items: center;
  padding: 18rpx 0;
  border-bottom: 1rpx solid rgba(0, 0, 0, 0.04);
}
.form-row:last-child { border-bottom: none; }
.form-label {
  width: 180rpx; flex-shrink: 0;
  font-size: 26rpx; color: #78716c; font-weight: 600;
}
.req { color: #ef4444; margin-right: 4rpx; font-weight: 700; }

.form-input {
  flex: 1; height: 72rpx; line-height: 72rpx;
  font-size: 27rpx; color: #1c1917; text-align: right;
  background: transparent;
}
.input-no-border { border: none; box-shadow: none; background: transparent; }
.ph { color: #a8a29e; font-weight: 400; }

.input-wrap {
  flex: 1; display: flex; align-items: center;
  background: linear-gradient(135deg, rgba(250, 250, 250, 0.85), rgba(255, 255, 255, 0.95));
  border: 1.5rpx solid rgba(0, 0, 0, 0.06);
  border-radius: 14rpx;
  overflow: hidden;
}
.input-prefix {
  height: 72rpx; line-height: 72rpx;
  padding: 0 14rpx 0 20rpx;
  font-size: 27rpx; color: #d97706; font-weight: 700;
  flex-shrink: 0;
}

.form-picker {
  flex: 1; display: flex; align-items: center; justify-content: flex-end;
}
.picker-txt { font-size: 27rpx; color: #1c1917; }
.ph-cls { color: #a8a29e; }
.picker-arrow { font-size: 22rpx; color: #a8a29e; margin-left: 10rpx; }

/* ========== 规格网格 ========== */
.spec-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12rpx;
}
.spec-form-item {
  background: linear-gradient(135deg, rgba(238, 242, 255, 0.98), rgba(255, 255, 255, 1));
  border-radius: 14rpx;
  padding: 14rpx 12rpx;
  display: flex; flex-direction: column;
  border: 1rpx solid rgba(59, 130, 246, 0.06);
}
.sf-label {
  font-size: 22rpx; color: #475569; font-weight: 600;
  margin-bottom: 8rpx;
}
.sf-input {
  font-size: 26rpx; color: #1c1917; font-weight: 500;
  height: 64rpx; line-height: 64rpx;
}

/* ========== 颜色选择 ========== */
.color-card {
  background: linear-gradient(135deg, rgba(250, 245, 255, 0.98), rgba(255, 255, 255, 1));
  border-radius: 18rpx;
  padding: 18rpx 20rpx;
  border: 1rpx solid rgba(168, 85, 247, 0.08);
}
.color-tag-list {
  display: flex; flex-wrap: wrap; gap: 16rpx;
}
.color-tag {
  display: flex; align-items: center; gap: 10rpx;
  padding: 12rpx 22rpx;
  border-radius: 32rpx;
  background: rgba(245, 245, 245, 0.8);
  border: 2rpx solid transparent;
  transition: all 0.2s ease;
}
.ct-active {
  background: linear-gradient(135deg, rgba(168, 85, 247, 0.12), rgba(147, 51, 234, 0.06));
  border-color: rgba(168, 85, 247, 0.35);
  box-shadow: 0 2rpx 12rpx rgba(168, 85, 247, 0.15);
}
.ct-dot {
  width: 26rpx; height: 26rpx;
  border-radius: 50%;
  border: 2rpx solid rgba(0, 0, 0, 0.08);
  box-shadow: 0 2rpx 6rpx rgba(0, 0, 0, 0.08);
}
.ct-name {
  font-size: 24rpx; color: #78716c; font-weight: 600;
}
.ct-active .ct-name { color: #d97706; font-weight: 700; }
.color-empty-hint {
  display: flex; align-items: center; justify-content: center;
  padding: 20rpx;
  border: 2rpx dashed rgba(168, 85, 247, 0.15);
  border-radius: 14rpx;
}
.color-empty-hint text {
  font-size: 24rpx; color: #a8a29e;
}

/* ========== 描述入口 ========== */
.desc-entry {
  display: flex; align-items: center; justify-content: space-between;
  padding: 28rpx 24rpx;
  background: linear-gradient(135deg, rgba(255, 247, 237, 0.98), rgba(255, 255, 255, 1));
  border-radius: 18rpx;
  border: 1rpx solid rgba(249, 115, 22, 0.08);
  transition: all 0.2s ease;
}
.desc-entry-hover {
  transform: scale(0.98);
  box-shadow: 0 4rpx 16rpx rgba(249, 115, 22, 0.12);
}
.de-left { display: flex; align-items: center; gap: 14rpx; flex: 1; }
.de-icon { font-size: 32rpx; }
.de-text {
  font-size: 26rpx; color: #78716c; font-weight: 500;
}
.de-arrow {
  font-size: 32rpx; color: #f97316; font-weight: 700;
  flex-shrink: 0;
}

/* ========== 底部按钮栏 ========== */
.bottom-bar {
  position: fixed;
  left: 0; right: 0; bottom: 0;
  padding: 20rpx 32rpx;
  padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  box-shadow: 0 -4rpx 30rpx rgba(0, 0, 0, 0.08), 0 0 40rpx rgba(245, 158, 11, 0.08);
  border-top: 1rpx solid rgba(245, 158, 11, 0.1);
  z-index: 100;
}
.save-btn {
  width: 100%; height: 92rpx;
  display: flex; align-items: center; justify-content: center;
  background: linear-gradient(135deg, #f59e0b 0%, #f97316 40%, #fb923c 70%, #fdba74 100%);
  border-radius: 46rpx;
  box-shadow: 0 8rpx 28rpx rgba(245, 158, 11, 0.4), inset 0 1rpx 0 rgba(255, 255, 255, 0.25);
  transition: all 0.2s ease;
}
.save-hover {
  transform: scale(0.97);
  box-shadow: 0 4rpx 16rpx rgba(245, 158, 11, 0.5), inset 0 1rpx 0 rgba(255, 255, 255, 0.25);
}
.save-text {
  font-size: 32rpx; font-weight: 800; color: #ffffff;
  letter-spacing: 2rpx;
  text-shadow: 0 2rpx 6rpx rgba(0, 0, 0, 0.1);
}
</style>
