<template>
  <view class="page" :class="{ 'page-ready': isReady }">
    <!-- 背景光晕矩阵 -->
    <view class="glow-matrix">
      <view class="glow-row" v-for="(row, ri) in glowRows" :key="ri">
        <view class="glow-spot" v-for="(dot, ci) in row.dots" :key="ci" :style="dot.style"></view>
      </view>
    </view>
    <view class="overlay-mask"></view>

    <!-- 主滚动区 -->
    <scroll-view scroll-y class="main-scroll" :show-scrollbar="false">
      <!-- 顶栏 -->
      <view class="header">
        <view class="header-bg"></view>
        <view class="header-circle"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="header-info">
          <text class="header-title">{{ isEdit ? '编辑二手车' : '录入二手车' }}</text>
          <text class="header-sub">{{ isEdit ? '修改二手车信息' : '填写车辆详细信息' }}</text>
        </view>
      </view>

      <!-- 分区1：基础信息 -->
      <view class="section-block">
        <view class="title-bar">
          <view class="bar-line"></view>
          <view class="icon-wrap"><text class="bar-icon">🚗</text></view>
          <text class="bar-title">基础信息</text>
        </view>
        <view class="form-card">
          <view class="form-row">
            <text class="form-label"><text class="req">*</text>车型名称</text>
            <input class="form-input fi-glass" v-model="form.name" placeholder="请输入车型完整名称" placeholder-class="ph" />
          </view>
          <view class="form-row">
            <text class="form-label">外观颜色</text>
            <input class="form-input fi-glass" v-model="form.color" placeholder="如：极光蓝" placeholder-class="ph" />
          </view>
          <view class="form-row">
            <text class="form-label"><text class="req">*</text>售价</text>
            <view class="input-wrap iw-glass">
              <text class="input-prefix">¥</text>
              <input class="form-input input-no-border" type="digit" v-model="form.price" placeholder="0.00" placeholder-class="ph" />
            </view>
          </view>
          <view class="form-row">
            <text class="form-label">新车落地价/原价</text>
            <view class="input-wrap iw-glass">
              <text class="input-prefix">¥</text>
              <input class="form-input input-no-border" type="digit" v-model="form.originalPrice" placeholder="0.00" placeholder-class="ph" />
            </view>
          </view>
        </view>
      </view>

      <!-- 分区2：二手车专属信息 -->
      <view class="section-block">
        <view class="title-bar">
          <view class="bar-line bar-line-amber"></view>
          <view class="icon-wrap"><text class="bar-icon">📋</text></view>
          <text class="bar-title">二手车专属信息</text>
        </view>
        <view class="form-card">
          <view class="form-row">
            <text class="form-label"><text class="req">*</text>上牌年份</text>
            <picker class="form-picker" :range="yearOptions" :value="yearIndex" @change="onYearChange">
              <text class="picker-txt" :class="{ 'ph-cls': form.licenseYear === '' }">{{ form.licenseYear !== '' ? form.licenseYear + '年' : '请选择' }}</text>
              <text class="picker-arrow">▸</text>
            </picker>
          </view>
          <view class="form-row">
            <text class="form-label"><text class="req">*</text>上牌月份</text>
            <picker class="form-picker" :range="monthOptions" :value="monthIndex" @change="onMonthChange">
              <text class="picker-txt" :class="{ 'ph-cls': form.licenseMonth === '' }">{{ form.licenseMonth !== '' ? form.licenseMonth + '月' : '请选择' }}</text>
              <text class="picker-arrow">▸</text>
            </picker>
          </view>
          <view class="form-row">
            <text class="form-label">上牌城市</text>
            <input class="form-input fi-glass" v-model="form.licenseCity" placeholder="如：济南" placeholder-class="ph" />
          </view>
          <view class="form-row">
            <text class="form-label">表显里程</text>
            <view class="input-wrap iw-glass">
              <input class="form-input input-no-border" type="digit" v-model="form.mileage" placeholder="0" placeholder-class="ph" />
              <text class="input-suffix">万公里</text>
            </view>
          </view>
          <view class="form-row">
            <text class="form-label">过户次数</text>
            <view class="input-wrap iw-glass">
              <input class="form-input input-no-border" type="number" v-model="form.transferCount" placeholder="0" placeholder-class="ph" />
              <text class="input-suffix">次</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 分区3：电池检测信息 -->
      <view class="section-block">
        <view class="title-bar">
          <view class="bar-line bar-line-warm"></view>
          <view class="icon-wrap"><text class="bar-icon">🔋</text></view>
          <text class="bar-title">电池检测信息</text>
        </view>
        <view class="form-card">
          <view class="form-row form-row-col">
            <view class="slider-header">
              <text class="form-label" style="width:auto;">电池健康度 SOH</text>
              <text class="soh-value">{{ form.soh }}%</text>
            </view>
            <slider class="soh-slider" :min="50" :max="100" :step="0.5" :value="form.soh" activeColor="#f59e0b" backgroundColor="#e5e7eb" block-color="#f59e0b" block-size="20" @change="onSohChange" />
            <view class="slider-tips">
              <text class="st-txt st-low">50%</text>
              <text class="st-txt st-mid">75%</text>
              <text class="st-txt st-high">100%</text>
            </view>
          </view>
          <view class="form-row">
            <text class="form-label">电池循环次数</text>
            <view class="input-wrap iw-glass">
              <input class="form-input input-no-border" type="number" v-model="form.cycles" placeholder="0" placeholder-class="ph" />
              <text class="input-suffix">次</text>
            </view>
          </view>
          <view class="form-row form-row-col">
            <text class="form-label" style="margin-bottom:16rpx;">电池诊断评级</text>
            <view class="diag-group">
              <view
                v-for="(item, idx) in diagnosisOptions"
                :key="idx"
                class="diag-item"
                :class="{ 'diag-active': form.diagnosis === item.value }"
                @tap="selectDiagnosis(item.value)"
              >
                <text class="diag-txt">{{ item.label }}</text>
              </view>
            </view>
          </view>
          <view class="form-row form-row-col">
            <text class="form-label" style="margin-bottom:12rpx;">电池检测报告</text>
            <textarea class="form-textarea ta-glass" v-model="form.batteryReport" placeholder="可选填，记录专业检测结果..." placeholder-class="ph" :maxlength="500" auto-height />
          </view>
        </view>
      </view>

      <!-- 分区4：估价信息 -->
      <view class="section-block">
        <view class="title-bar">
          <view class="bar-line bar-line-light"></view>
          <view class="icon-wrap"><text class="bar-icon">💰</text></view>
          <text class="bar-title">估价信息</text>
        </view>
        <view class="form-card">
          <view class="form-row">
            <text class="form-label">专业估价</text>
            <view class="input-wrap iw-glass">
              <text class="input-prefix">¥</text>
              <input class="form-input input-no-border" type="digit" v-model="form.valuationPrice" placeholder="0.00" placeholder-class="ph" />
            </view>
          </view>
          <view class="form-row form-row-col">
            <text class="form-label" style="margin-bottom:12rpx;">估价说明</text>
            <textarea class="form-textarea ta-glass" v-model="form.valuationInfo" placeholder="可选填，说明估价依据..." placeholder-class="ph" :maxlength="300" auto-height />
          </view>
        </view>
      </view>

      <!-- 分区5：其他 -->
      <view class="section-block">
        <view class="title-bar">
          <view class="bar-line bar-line-soft"></view>
          <view class="icon-wrap"><text class="bar-icon">📝</text></view>
          <text class="bar-title">其他</text>
        </view>
        <view class="form-card">
          <view class="form-row form-row-col">
            <text class="form-label" style="margin-bottom:12rpx;">车辆描述</text>
            <textarea class="form-textarea ta-glass" v-model="form.desc" placeholder="详细描述车况、保养情况等..." placeholder-class="ph" :maxlength="500" auto-height />
          </view>
          <view class="form-row">
            <text class="form-label">车辆标签</text>
            <input class="form-input fi-glass" v-model="form.tags" placeholder="逗号分隔，如：一手车,原版原漆" placeholder-class="ph" />
          </view>
        </view>
      </view>

      <view style="height: 160rpx;"></view>
    </scroll-view>

    <!-- 底部操作按钮 -->
    <view class="bottom-bar">
      <view class="btn-row">
        <view class="cancel-btn" hover-class="cancel-hover" @tap="goBack">
          <text class="cancel-txt">取消</text>
        </view>
        <view class="submit-btn" hover-class="submit-hover" @tap="submitForm">
          <text class="submit-txt">{{ submitting ? '提交中...' : (isEdit ? '保存修改' : '确认录入') }}</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
var USE_MOCK = true

var yearOptions = []
for (var y = 2026; y >= 2020; y--) { yearOptions.push(y) }

var monthOptions = []
for (var m = 1; m <= 12; m++) { monthOptions.push(m) }

var diagnosisOptions = [
  { label: '优秀', value: 'excellent' },
  { label: '良好', value: 'good' },
  { label: '一般', value: 'fair' },
  { label: '较差', value: 'poor' }
]

export default {
  data: function() {
    return {
      isReady: false,
      glowRows: [],
      isEdit: false,
      usedId: '',
      submitting: false,
      yearOptions: yearOptions,
      monthOptions: monthOptions,
      diagnosisOptions: diagnosisOptions,
      form: {
        name: '',
        color: '',
        price: '',
        originalPrice: '',
        licenseYear: '',
        licenseMonth: '',
        licenseCity: '',
        mileage: '',
        transferCount: '0',
        soh: 85,
        cycles: '',
        diagnosis: '',
        batteryReport: '',
        valuationPrice: '',
        valuationInfo: '',
        desc: '',
        tags: ''
      }
    }
  },
  computed: {
    yearIndex: function() {
      var idx = this.yearOptions.indexOf(Number(this.form.licenseYear))
      return idx > -1 ? idx : 0
    },
    monthIndex: function() {
      var idx = this.monthOptions.indexOf(Number(this.form.licenseMonth))
      return idx > -1 ? idx - 1 : 0
    }
  },
  onLoad: function(options) {
    var that = this
    that.buildGlowRows()
    if (options && options.mode === 'edit' && options.usedId) {
      that.isEdit = true
      that.usedId = options.usedId
      that.loadUsedCarData(that.usedId)
    }
    setTimeout(function() { that.isReady = true }, 200)
  },
  methods: {
    buildGlowRows: function() {
      var rows = []
      var colors = ['#d97706', '#f59e0b', '#fb923c', '#fbbf24', '#fcd34d', '#fde68a']
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

    loadUsedCarData: function(usedId) {
      var self = this
      var map = {
        1: {
          name: '比亚迪海豹 EV 700km 四驱旗舰版',
          price: '168000',
          originalPrice: '228000',
          color: '极光蓝',
          licenseYear: 2024,
          licenseMonth: 6,
          licenseCity: '济南',
          mileage: '2.8',
          transferCount: '0',
          soh: 96.5,
          cycles: '128',
          diagnosis: 'excellent',
          batteryReport: '经专业设备检测，电池包各项指标正常，单体电压偏差<5mV，内阻均匀。',
          valuationPrice: '172000',
          valuationInfo: '车况优良，电池健康度高，市场行情稳定。',
          desc: '2024年6月上牌，一手车，全程4S店保养。',
          tags: '一手车,原版原漆,4S保养'
        }
      }
      var data = map[usedId]
      if (data) {
        setTimeout(function() {
          self.form.name = data.name || ''
          self.form.price = data.price || ''
          self.form.originalPrice = data.originalPrice || ''
          self.form.color = data.color || ''
          self.form.licenseYear = data.licenseYear !== undefined ? String(data.licenseYear) : ''
          self.form.licenseMonth = data.licenseMonth !== undefined ? String(data.licenseMonth) : ''
          self.form.licenseCity = data.licenseCity || ''
          self.form.mileage = data.mileage || ''
          self.form.transferCount = data.transferCount !== undefined ? String(data.transferCount) : '0'
          self.form.soh = data.soh !== undefined ? data.soh : 85
          self.form.cycles = data.cycles || ''
          self.form.diagnosis = data.diagnosis || ''
          self.form.batteryReport = data.batteryReport || ''
          self.form.valuationPrice = data.valuationPrice || ''
          self.form.valuationInfo = data.valuationInfo || ''
          self.form.desc = data.desc || ''
          self.form.tags = data.tags || ''
        }, 300)
      }
    },

    onYearChange: function(e) {
      var idx = parseInt(e.detail.value)
      if (idx >= 0 && idx < this.yearOptions.length) {
        this.form.licenseYear = String(this.yearOptions[idx])
      }
    },

    onMonthChange: function(e) {
      var idx = parseInt(e.detail.value)
      if (idx >= 0 && idx < this.monthOptions.length) {
        this.form.licenseMonth = String(this.monthOptions[idx])
      }
    },

    onSohChange: function(e) {
      this.form.soh = e.detail.value
    },

    selectDiagnosis: function(val) {
      this.form.diagnosis = val
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
      if (!this.form.licenseYear) {
        uni.showToast({ title: '请选择上牌年份', icon: 'none' }); return false
      }
      if (!this.form.licenseMonth) {
        uni.showToast({ title: '请选择上牌月份', icon: 'none' }); return false
      }
      return true
    },

    submitForm: function() {
      var self = this
      if (!self.validateForm()) return
      if (self.submitting) return
      self.submitting = true

      if (USE_MOCK) {
        setTimeout(function() {
          self.submitting = false
          uni.showToast({
            title: self.isEdit ? '保存成功' : '录入成功',
            icon: 'success',
            duration: 1500,
            complete: function() {
              setTimeout(function() { uni.navigateBack({ delta: 1 }) }, 1500)
            }
          })
        }, 600)
      } else {
        var method = self.isEdit ? 'PUT' : 'POST'
        var url = '/merchant/used-car' + (self.isEdit ? '/' + self.usedId : '')
        uni.request({
          url: url,
          method: method,
          data: self.form,
          success: function(res) {
            self.submitting = false
            if (res.data && res.data.code === 200) {
              uni.showToast({ title: self.isEdit ? '保存成功' : '录入成功', icon: 'success' })
              setTimeout(function() { uni.navigateBack({ delta: 1 }) }, 1200)
            } else {
              uni.showToast({ title: (res.data && res.data.msg) || '操作失败', icon: 'none' })
            }
          },
          fail: function() {
            self.submitting = false
            uni.showToast({ title: '网络异常，请重试', icon: 'none' })
          }
        })
      }
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
.page-ready .section-block:nth-of-type(1) { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.06s; }
.page-ready .section-block:nth-of-type(2) { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.14s; }
.page-ready .section-block:nth-of-type(3) { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.22s; }
.page-ready .section-block:nth-of-type(4) { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.30s; }
.page-ready .section-block:nth-of-type(5) { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.38s; }

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
    rgba(255, 247, 237, 0.93) 0%,
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
  background: linear-gradient(135deg, #d97706 0%, #f59e0b 35%, #fb923c 65%, #fbbf24 100%);
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
  background: linear-gradient(180deg, #d97706, #f59e0b);
  box-shadow: 0 0 12rpx rgba(217, 119, 6, 0.35);
}
.bar-line-amber { background: linear-gradient(180deg, #f59e0b, #fb923c); box-shadow: 0 0 12rpx rgba(245,158,11,0.35); }
.bar-line-warm { background: linear-gradient(180deg, #fb923c, #fbbf24); box-shadow: 0 0 12rpx rgba(251,146,60,0.35); }
.bar-line-light { background: linear-gradient(180deg, #fbbf24, #fcd34d); box-shadow: 0 0 12rpx rgba(251,191,36,0.35); }
.bar-line-soft { background: linear-gradient(180deg, #fcd34d, #fde68a); box-shadow: 0 0 12rpx rgba(252,211,77,0.35); }

.icon-wrap {
  width: 48rpx; height: 48rpx;
  border-radius: 14rpx;
  display: flex; align-items: center; justify-content: center;
  margin-right: 12rpx;
  background: linear-gradient(135deg, rgba(217, 119, 6, 0.12), rgba(245, 158, 11, 0.06));
}
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
  border: 1rpx solid rgba(217, 119, 6, 0.08);
}

.form-row {
  display: flex; align-items: center;
  padding: 18rpx 0;
  border-bottom: 1rpx solid rgba(0, 0, 0, 0.04);
}
.form-row:last-child { border-bottom: none; }
.form-row-col {
  flex-direction: column;
  align-items: stretch;
  border-bottom: none;
  padding-bottom: 10rpx;
}
.form-label {
  width: 220rpx; flex-shrink: 0;
  font-size: 26rpx; color: #78716c; font-weight: 600;
}
.req { color: #ef4444; margin-right: 4rpx; font-weight: 700; }

.fi-glass {
  flex: 1; height: 72rpx; line-height: 72rpx;
  font-size: 27rpx; color: #1c1917; text-align: right;
  background: linear-gradient(135deg, rgba(250, 250, 250, 0.75), rgba(255, 255, 255, 0.92));
  border: 1.5rpx solid rgba(0, 0, 0, 0.06);
  border-radius: 16rpx;
  padding: 0 20rpx;
  transition: border-color 0.2s ease;
}
.fi-glass:focus {
  border-color: #f59e0b;
  box-shadow: 0 0 0 3rpx rgba(245, 158, 11, 0.12);
}

.form-input {
  flex: 1; height: 72rpx; line-height: 72rpx;
  font-size: 27rpx; color: #1c1917; text-align: right;
  background: transparent;
}
.input-no-border { border: none; box-shadow: none; background: transparent; }
.ph { color: #a8a29e; font-weight: 400; }

.iw-glass {
  flex: 1; display: flex; align-items: center;
  background: linear-gradient(135deg, rgba(250, 250, 250, 0.8), rgba(255, 255, 255, 0.95));
  border: 1.5rpx solid rgba(0, 0, 0, 0.06);
  border-radius: 16rpx;
  overflow: hidden;
  transition: border-color 0.2s ease;
}
.iw-glass:focus-within {
  border-color: #f59e0b;
  box-shadow: 0 0 0 3rpx rgba(245, 158, 11, 0.12);
}
.input-prefix {
  height: 72rpx; line-height: 72rpx;
  padding: 0 14rpx 0 20rpx;
  font-size: 27rpx; color: #d97706; font-weight: 700;
  flex-shrink: 0;
}
.input-suffix {
  height: 72rpx; line-height: 72rpx;
  padding: 0 20rpx 0 10rpx;
  font-size: 24rpx; color: #a8a29e; font-weight: 500;
  flex-shrink: 0;
}

.form-picker {
  flex: 1; display: flex; align-items: center; justify-content: flex-end;
}
.picker-txt { font-size: 27rpx; color: #1c1917; }
.ph-cls { color: #a8a29e; }
.picker-arrow { font-size: 22rpx; color: #a8a29e; margin-left: 10rpx; }

/* ========== Slider滑块 ========== */
.slider-header {
  width: 100%; display: flex; justify-content: space-between; align-items: center;
  margin-bottom: 12rpx;
}
.soh-value {
  font-size: 28rpx; font-weight: 800; color: #d97706;
}
.soh-slider {
  width: 100%; margin: 8rpx 0 12rpx;
}
.slider-tips {
  display: flex; justify-content: space-between;
  padding: 0 4rpx;
}
.st-txt { font-size: 22rpx; color: #a8a29e; font-weight: 500; }

/* ========== 诊断评级分段选择器 ========== */
.diag-group {
  display: flex; gap: 14rpx; width: 100%;
}
.diag-item {
  flex: 1; height: 68rpx;
  display: flex; align-items: center; justify-content: center;
  border-radius: 14rpx;
  background: rgba(245, 245, 245, 0.85);
  border: 1.5rpx solid rgba(0, 0, 0, 0.06);
  transition: all 0.25s ease;
}
.diag-active {
  background: linear-gradient(135deg, #d97706 0%, #f59e0b 50%, #fb923c 100%);
  border-color: transparent;
  box-shadow: 0 4rpx 16rpx rgba(217, 119, 6, 0.35);
}
.diag-txt {
  font-size: 24rpx; font-weight: 700; color: #78716c;
}
.diag-active .diag-txt { color: #ffffff; }

/* ========== Textarea ========== */
.ta-glass {
  width: 100%; min-height: 140rpx;
  font-size: 26rpx; color: #1c1917; line-height: 1.6;
  background: linear-gradient(135deg, rgba(250, 250, 250, 0.75), rgba(255, 255, 255, 0.92));
  border: 1.5rpx solid rgba(0, 0, 0, 0.06);
  border-radius: 16rpx;
  padding: 18rpx 20rpx;
  box-sizing: border-box;
  transition: border-color 0.2s ease;
}
.ta-glass:focus {
  border-color: #f59e0b;
  box-shadow: 0 0 0 3rpx rgba(245, 158, 11, 0.12);
}
.form-textarea { margin: 0; }

/* ========== 底部操作栏 ========== */
.bottom-bar {
  position: fixed;
  left: 0; right: 0; bottom: 0;
  padding: 20rpx 32rpx;
  padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  box-shadow: 0 -4rpx 30rpx rgba(0, 0, 0, 0.08), 0 0 40rpx rgba(217, 119, 6, 0.08);
  border-top: 1rpx solid rgba(217, 119, 6, 0.1);
  z-index: 100;
}
.btn-row {
  display: flex; gap: 20rpx;
}
.cancel-btn {
  flex: 0 0 180rpx; height: 92rpx;
  display: flex; align-items: center; justify-content: center;
  background: rgba(156, 163, 175, 0.15);
  border-radius: 46rpx;
  border: 1.5rpx solid rgba(156, 163, 175, 0.25);
  transition: all 0.2s ease;
}
.cancel-hover { transform: scale(0.97); background: rgba(156, 163, 175, 0.25); }
.cancel-txt {
  font-size: 28rpx; font-weight: 700; color: #6b7280;
}

.submit-btn {
  flex: 1; height: 92rpx;
  display: flex; align-items: center; justify-content: center;
  background: linear-gradient(135deg, #d97706 0%, #f59e0b 35%, #fb923c 65%, #fbbf24 100%);
  border-radius: 46rpx;
  box-shadow: 0 8rpx 28rpx rgba(217, 119, 6, 0.4), inset 0 1rpx 0 rgba(255, 255, 255, 0.25);
  transition: all 0.2s ease;
}
.submit-hover {
  transform: scale(0.97);
  box-shadow: 0 4rpx 16rpx rgba(217, 119, 6, 0.5), inset 0 1rpx 0 rgba(255, 255, 255, 0.25);
}
.submit-txt {
  font-size: 32rpx; font-weight: 800; color: #ffffff;
  letter-spacing: 2rpx;
  text-shadow: 0 2rpx 6rpx rgba(0, 0, 0, 0.1);
}
</style>
