<template>
  <view class="page" :class="{ 'page-ready': isReady }">
    <!-- 背景光晕矩阵（琥珀橙暖色系） -->
    <view class="glow-matrix">
      <view class="glow-row" v-for="(row, ri) in glowRows" :key="ri">
        <view class="glow-spot" v-for="(dot, ci) in row.dots" :key="ci" :style="dot.style"></view>
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
          <text class="header-title">{{ isEdit ? '编辑方案' : '新增方案' }}</text>
          <text class="header-sub">{{ isEdit ? '修改金融方案信息' : '创建新的金融方案' }}</text>
        </view>
      </view>

      <!-- 基本信息（琥珀色条） -->
      <view class="form-section">
        <view class="section-title">
          <view class="title-bar bar-amber"></view>
          <text class="title-text">基本信息</text>
        </view>
        <view class="form-card">
          <view class="form-row">
            <text class="form-label">方案名称</text>
            <input
              class="form-input"
              v-model="form.planName"
              placeholder="请输入方案名称"
              placeholder-class="ph"
              maxlength="20"
            />
          </view>
          <view class="form-row row-switch">
            <text class="form-label">推荐方案</text>
            <switch
              :checked="form.isRecommended"
              color="#f59e0b"
              style="transform: scale(0.82);"
              @change="onSwitchChange"
            />
          </view>
        </view>
      </view>

      <!-- 首付设置（绿色色条） -->
      <view class="form-section">
        <view class="section-title">
          <view class="title-bar bar-green"></view>
          <text class="title-text">首付设置</text>
        </view>
        <view class="form-card">
          <view class="form-row-col">
            <view class="slider-header">
              <text class="slider-label">首付比例</text>
              <text class="slider-value">{{ (form.downRatio * 100).toFixed(0) }}%</text>
            </view>
            <slider
              :value="form.downRatio * 100"
              min="10"
              max="80"
              step="5"
              activeColor="#d97706"
              backgroundColor="#e5e7eb"
              block-size="24"
              block-color="#d97706"
              @change="onDownRatioChange"
            />
          </view>
          <view class="form-row">
            <text class="form-label">最低信用分</text>
            <input
              class="form-input"
              v-model="form.minCreditScore"
              placeholder="如：650"
              placeholder-class="ph"
              type="number"
            />
          </view>
        </view>
      </view>

      <!-- 贷款期限（蓝色色条） -->
      <view class="form-section">
        <view class="section-title">
          <view class="title-bar bar-blue"></view>
          <text class="title-text">贷款期限</text>
        </view>
        <view class="form-card">
          <view class="term-grid">
            <view
              class="term-btn"
              :class="{ active: form.months === item }"
              v-for="item in termOptions"
              :key="item"
              @tap="selectTerm(item)"
            >
              <text>{{ item }}期</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 利率设置（紫色色条） -->
      <view class="form-section">
        <view class="section-title">
          <view class="title-bar bar-purple"></view>
          <text class="title-text">利率设置</text>
        </view>
        <view class="form-card">
          <view class="form-row">
            <text class="form-label">年利率(%)</text>
            <input
              class="form-input input-rate"
              v-model="yearRateStr"
              placeholder="如：3.5"
              placeholder-class="ph"
              type="digit"
              @input="onYearRateInput"
            />
          </view>
          <view class="form-row">
            <text class="form-label">月利率</text>
            <text class="form-static">{{ monthlyRateDisplay }}</text>
          </view>
        </view>
      </view>

      <!-- 适用条件（橙色色条） -->
      <view class="form-section">
        <view class="section-title">
          <view class="title-bar bar-orange"></view>
          <text class="title-text">适用条件</text>
        </view>
        <view class="form-card">
          <view class="form-row-col">
            <textarea
              class="form-textarea"
              v-model="form.condition"
              placeholder="请输入适用条件说明（选填）"
              placeholder-class="ph"
              maxlength="100"
            />
          </view>
        </view>
      </view>

      <!-- 预览卡片 -->
      <view class="preview-section">
        <view class="preview-card">
          <view class="preview-header">
            <text class="preview-icon">📊</text>
            <text class="preview-title">月供预览（以20万车价为例）</text>
          </view>
          <view class="preview-body">
            <view class="preview-item">
              <text class="pv-label">贷款金额</text>
              <text class="pv-value">&yen;{{ previewData.loanAmount }}</text>
            </view>
            <view class="preview-divider"></view>
            <view class="preview-item highlight">
              <text class="pv-label">每月还款</text>
              <text class="pv-value pv-big">&yen;{{ previewData.monthlyPay }}</text>
            </view>
            <view class="preview-divider"></view>
            <view class="preview-item">
              <text class="pv-label">总利息</text>
              <text class="pv-value pv-warn">&yen;{{ previewData.totalInterest }}</text>
            </view>
            <view class="preview-divider"></view>
            <view class="preview-item">
              <text class="pv-label">还款总额</text>
              <text class="pv-value">&yen;{{ previewData.totalRepay }}</text>
            </view>
          </view>
        </view>
      </view>

      <view style="height: 160rpx;"></view>
    </scroll-view>

    <!-- 底部固定操作栏 -->
    <view class="bottom-bar">
      <view class="save-btn" hover-class="btn-active" @tap="submitForm">
        <text class="save-text">保存方案</text>
      </view>
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
      isEdit: false,
      editPlanId: null,
      examplePrice: 200000,
      termOptions: [12, 24, 36, 48, 60],
      yearRateStr: '',
      form: {
        planName: '',
        downRatio: 30,
        months: 36,
        yearRate: 0,
        monthlyRate: 0,
        minCreditScore: '',
        condition: '',
        isRecommended: false
      }
    }
  },
  computed: {
    monthlyRateDisplay: function() {
      if (!this.form.yearRate || this.form.yearRate === 0) return '0.0000%'
      return (this.form.yearRate / 12 * 100).toFixed(4) + '%'
    },
    previewData: function() {
      var price = this.examplePrice
      var loanAmount = price * (1 - this.form.downRatio / 100)
      var mr = this.form.yearRate / 12
      var n = this.form.months
      var monthlyPay = 0
      var totalInterest = 0

      if (mr === 0 || n === 0) {
        monthlyPay = n > 0 ? loanAmount / n : 0
        totalInterest = 0
      } else {
        var factor = Math.pow(1 + mr, n)
        monthlyPay = loanAmount * (mr * factor) / (factor - 1)
        totalInterest = monthlyPay * n - loanAmount
      }

      return {
        loanAmount: this.fmtNum(loanAmount),
        monthlyPay: this.fmtNum(monthlyPay),
        totalInterest: this.fmtNum(totalInterest),
        totalRepay: this.fmtNum(monthlyPay * n)
      }
    }
  },
  onLoad: function(options) {
    var that = this
    if (options && options.planId) {
      that.isEdit = true
      that.editPlanId = options.planId
      that.loadEditData()
    }
  },
  created: function() {
    var self = this
    setTimeout(function() { self.isReady = true }, 200)
  },
  methods: {
    loadEditData: function() {
      // Mock数据加载，实际应从接口获取
      this.form = {
        planName: '36期低息方案',
        downRatio: 25,
        months: 36,
        yearRate: 0.035,
        monthlyRate: 0.0029,
        minCreditScore: '700',
        condition: '信用分≥700，需提供收入证明',
        isRecommended: false
      }
      this.yearRateStr = (this.form.yearRate * 100).toString()
    },
    goBack: function() {
      uni.navigateBack({ delta: 1 })
    },
    onSwitchChange: function(e) {
      this.form.isRecommended = e.detail.value
    },
    onDownRatioChange: function(e) {
      this.form.downRatio = e.detail.value
    },
    selectTerm: function(val) {
      this.form.months = val
    },
    onYearRateInput: function(e) {
      var val = e.detail.value
      this.yearRateStr = val
      if (val === '' || val === undefined) {
        this.form.yearRate = 0
        return
      }
      var num = parseFloat(val)
      if (isNaN(num)) num = 0
      this.form.yearRate = num / 100
    },
    fmtNum: function(num) {
      if (num === undefined || isNaN(num)) return '0'
      return Math.round(num).toLocaleString()
    },
    validateForm: function() {
      if (!this.form.planName || this.form.planName.trim() === '') {
        uni.showToast({ title: '请输入方案名称', icon: 'none' })
        return false
      }
      var dr = this.form.downRatio
      if (dr < 10 || dr > 80) {
        uni.showToast({ title: '首付比例需在10%-80%', icon: 'none' })
        return false
      }
      var yr = this.form.yearRate
      if (yr < 0 || yr > 0.15) {
        uni.showToast({ title: '年利率需在0%-15%', icon: 'none' })
        return false
      }
      return true
    },
    submitForm: function() {
      var that = this
      if (!this.validateForm()) return
      // Mock模式模拟保存
      uni.showLoading({ title: '保存中...' })
      setTimeout(function() {
        uni.hideLoading()
        uni.showToast({
          title: that.isEdit ? '修改成功' : '新增成功',
          icon: 'success'
        })
        setTimeout(function() { uni.navigateBack({ delta: 1 }) }, 1200)
      }, 800)
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
.page-ready .form-section {
  animation: fadeSlideUp 0.45s cubic-bezier(0.34, 1.56, 0.64, 1) backwards;
}
@keyframes fadeSlideUp {
  from { opacity: 0; transform: translateY(28rpx) scale(0.97); }
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

/* ========== 表单区块通用 ========== */
.form-section {
  padding: 8rpx 28rpx 16rpx;
  animation-delay: calc(var(--sec-idx, 0) * 0.06s);
}
.section-title {
  display: flex;
  align-items: center;
  margin-bottom: 16rpx;
}
.title-bar {
  width: 6rpx;
  height: 30rpx;
  border-radius: 3rpx;
  margin-right: 14rpx;
}
.bar-amber { background: linear-gradient(180deg, #fbbf24, #f59e0b); box-shadow: 0 0 10rpx rgba(245, 158, 11, 0.35); }
.bar-green { background: linear-gradient(180deg, #d97706, #f59e0b); box-shadow: 0 0 10rpx rgba(217,119,6,0.35); }
.bar-blue { background: linear-gradient(180deg, #f59e0b, #fb923c); box-shadow: 0 0 10rpx rgba(245,158,11,0.35); }
.bar-purple { background: linear-gradient(180deg, #c084fc, #a855f7); box-shadow: 0 0 10rpx rgba(168, 85, 247, 0.35); }
.bar-orange { background: linear-gradient(180deg, #fb923c, #f97316); box-shadow: 0 0 10rpx rgba(249, 115, 22, 0.35); }
.title-text {
  font-size: 29rpx;
  font-weight: 700;
  color: #451a03;
}
.form-card {
  background: rgba(255, 255, 255, 0.82);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  border-radius: 20rpx;
  padding: 8rpx 26rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.04), inset 0 1rpx 0 rgba(255, 255, 255, 0.9);
  border: 1rpx solid rgba(255, 255, 255, 0.75);
}

/* ========== 表单行 ========== */
.form-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 22rpx 0;
  border-bottom: 1rpx solid rgba(0, 0, 0, 0.04);
}
.form-row:last-child { border-bottom: none; }
.form-row-switch { padding: 18rpx 0; }
.form-label {
  font-size: 27rpx;
  color: #44403c;
  font-weight: 600;
  white-space: nowrap;
}
.form-input {
  flex: 1;
  text-align: right;
  font-size: 27rpx;
  color: #1c1917;
  font-weight: 500;
}
.input-rate {
  font-weight: 700;
  color: #a855f7;
}
.form-static {
  font-size: 27rpx;
  color: #a855f7;
  font-weight: 600;
}
.ph { color: #d6d3d1; }

.form-row-col { padding: 18rpx 0; }

/* ========== 首付滑块 ========== */
.slider-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16rpx;
}
.slider-label {
  font-size: 27rpx;
  color: #44403c;
  font-weight: 600;
}
.slider-value {
  font-size: 32rpx;
  font-weight: 800;
  color: #d97706;
}

/* ========== 期限按钮组 ========== */
.term-grid {
  display: flex;
  gap: 14rpx;
  padding: 10rpx 0 6rpx;
}
.term-btn {
  flex: 1;
  text-align: center;
  padding: 18rpx 0;
  border-radius: 14rpx;
  background: rgba(0, 0, 0, 0.03);
  border: 2rpx solid transparent;
  transition: all 0.25s ease;
}
.term-btn text {
  font-size: 26rpx;
  color: #78716c;
  font-weight: 600;
}
.term-btn.active {
  background: linear-gradient(135deg, rgba(217, 119, 6, 0.1), rgba(245, 158, 11, 0.05));
  border-color: #d97706;
  box-shadow: 0 4rpx 14rpx rgba(217, 119, 6, 0.18);
}
.term-btn.active text {
  color: #d97706;
  font-weight: 800;
}

/* ========== 文本域 ========== */
.form-textarea {
  width: 100%;
  height: 150rpx;
  font-size: 27rpx;
  color: #1c1917;
  line-height: 1.6;
}

/* ========== 预览卡片 ========== */
.preview-section {
  padding: 8rpx 28rpx 16rpx;
}
.preview-card {
  background: rgba(255, 255, 255, 0.86);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border-radius: 22rpx;
  overflow: hidden;
  box-shadow: 0 6rpx 28rpx rgba(245, 158, 11, 0.08), inset 0 1rpx 0 rgba(255, 255, 255, 0.9);
  border: 1rpx solid rgba(245, 158, 11, 0.1);
}
.preview-header {
  display: flex;
  align-items: center;
  padding: 22rpx 26rpx;
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.07), rgba(251, 146, 60, 0.03));
  border-bottom: 1rpx solid rgba(245, 158, 11, 0.06);
}
.preview-icon { font-size: 30rpx; margin-right: 10rpx; }
.preview-title {
  font-size: 26rpx;
  color: #92400e;
  font-weight: 700;
}
.preview-body { padding: 8rpx 26rpx 20rpx; }
.preview-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16rpx 0;
}
.preview-item.highlight {
  padding: 20rpx 0;
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.06), rgba(251, 191, 36, 0.02));
  margin: 4rpx -12rpx;
  padding-left: 12rpx;
  padding-right: 12rpx;
  border-radius: 12rpx;
}
.pv-label {
  font-size: 25rpx;
  color: #78716c;
  font-weight: 500;
}
.pv-value {
  font-size: 28rpx;
  color: #292524;
  font-weight: 700;
}
.pv-big {
  font-size: 38rpx;
  font-weight: 900;
  color: #f59e0b;
  letter-spacing: 0.5rpx;
  text-shadow: 0 2rpx 8rpx rgba(245, 158, 11, 0.15);
}
.pv-warn { color: #ea580c; font-weight: 800; }
.preview-divider {
  height: 1rpx;
  background: linear-gradient(90deg, transparent, rgba(0, 0, 0, 0.06), transparent);
}

/* ========== 底部操作栏 ========== */
.bottom-bar {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 99;
  padding: 16rpx 28rpx calc(16rpx + env(safe-area-inset-bottom));
  background: rgba(255, 255, 255, 0.92);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  box-shadow: 0 -4rpx 24rpx rgba(0, 0, 0, 0.06);
}
.save-btn {
  background: linear-gradient(135deg, #f59e0b 0%, #f97316 50%, #fb923c 100%);
  border-radius: 48rpx;
  padding: 26rpx 0;
  text-align: center;
  box-shadow: 0 8rpx 32rpx rgba(245, 158, 11, 0.35), 0 2rpx 8rpx rgba(0, 0, 0, 0.05);
  transition: all 0.25s ease;
}
.btn-active {
  transform: scale(0.97);
  box-shadow: 0 4rpx 16rpx rgba(245, 158, 11, 0.25);
}
.save-text {
  font-size: 31rpx;
  color: #ffffff;
  font-weight: 800;
  letter-spacing: 2rpx;
}
</style>
