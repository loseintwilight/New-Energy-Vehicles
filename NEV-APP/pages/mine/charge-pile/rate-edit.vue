<template>
  <view class="page" :class="{ 'page-ready': isReady }">
    <view class="glow-matrix">
      <view class="glow-row" v-for="(row, ri) in glowRows" :key="ri">
        <view class="glow-spot" v-for="(dot, ci) in row.dots" :key="ci" :style="dot.style"></view>
      </view>
    </view>
    <view class="overlay-mask"></view>

    <scroll-view scroll-y class="main-scroll" :show-scrollbar="false">
      <view class="header">
        <view class="header-bg"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">❮</text>
        </view>
        <view class="header-info">
          <text class="header-title">{{ isEdit ? '编辑费率' : '新建费率' }}</text>
          <text class="header-sub">{{ isEdit ? '修改费率方案' : '创建新费率方案' }}</text>
        </view>
        <view class="header-right" @tap="submitForm">
          <text class="submit-text">提交</text>
        </view>
      </view>

      <view class="info-section">
        <view class="section-title">
          <view class="title-line"></view>
          <text class="title-text">基本信息</text>
        </view>
        <view class="info-card">
          <view class="form-row">
            <text class="form-label">方案名称</text>
            <input class="form-input" v-model="form.name" placeholder="请输入方案名称" placeholder-class="form-placeholder" />
          </view>
          <view class="form-row">
            <text class="form-label">适用类型</text>
            <picker class="form-picker" :range="typeOptions" @change="onTypeChange">
              <text class="picker-text" :class="{ placeholder: !form.type }">{{ form.type || '请选择类型' }}</text>
              <text class="picker-arrow">❯</text>
            </picker>
          </view>
          <view class="form-row">
            <text class="form-label">默认启用</text>
            <switch class="form-switch" :checked="form.enabled" @change="onEnabledChange" color="#f59e0b" />
          </view>
        </view>
      </view>

      <view class="info-section">
        <view class="section-title">
          <view class="title-line line-green"></view>
          <text class="title-text">尖峰时段 (元/度)</text>
        </view>
        <view class="info-card">
          <view class="form-row">
            <text class="form-label">价格</text>
            <input class="form-input" v-model="form.peakPrice" placeholder="请输入尖峰价格" placeholder-class="form-placeholder" type="digit" />
          </view>
          <view class="form-row">
            <text class="form-label">时间段</text>
            <input class="form-input" v-model="form.peakTime" placeholder="如：10:00-12:00,14:00-17:00" placeholder-class="form-placeholder" />
          </view>
        </view>
      </view>

      <view class="info-section">
        <view class="section-title">
          <view class="title-line line-blue"></view>
          <text class="title-text">高峰时段 (元/度)</text>
        </view>
        <view class="info-card">
          <view class="form-row">
            <text class="form-label">价格</text>
            <input class="form-input" v-model="form.highPrice" placeholder="请输入高峰价格" placeholder-class="form-placeholder" type="digit" />
          </view>
          <view class="form-row">
            <text class="form-label">时间段</text>
            <input class="form-input" v-model="form.highTime" placeholder="如：08:00-10:00,12:00-14:00" placeholder-class="form-placeholder" />
          </view>
        </view>
      </view>

      <view class="info-section">
        <view class="section-title">
          <view class="title-line line-purple"></view>
          <text class="title-text">平段 (元/度)</text>
        </view>
        <view class="info-card">
          <view class="form-row">
            <text class="form-label">价格</text>
            <input class="form-input" v-model="form.flatPrice" placeholder="请输入平段价格" placeholder-class="form-placeholder" type="digit" />
          </view>
          <view class="form-row">
            <text class="form-label">时间段</text>
            <input class="form-input" v-model="form.flatTime" placeholder="如：07:00-08:00,19:00-21:00" placeholder-class="form-placeholder" />
          </view>
        </view>
      </view>

      <view class="info-section">
        <view class="section-title">
          <view class="title-line line-dark"></view>
          <text class="title-text">低谷时段 (元/度)</text>
        </view>
        <view class="info-card">
          <view class="form-row">
            <text class="form-label">价格</text>
            <input class="form-input" v-model="form.lowPrice" placeholder="请输入低谷价格" placeholder-class="form-placeholder" type="digit" />
          </view>
          <view class="form-row">
            <text class="form-label">时间段</text>
            <input class="form-input" v-model="form.lowTime" placeholder="如：21:00-07:00" placeholder-class="form-placeholder" />
          </view>
        </view>
      </view>

      <view class="info-section">
        <view class="section-title">
          <view class="title-line line-teal"></view>
          <text class="title-text">方案描述</text>
        </view>
        <view class="desc-card">
          <textarea class="desc-textarea" v-model="form.description" placeholder="请输入方案描述..." placeholder-class="desc-placeholder" :maxlength="300" />
          <text class="desc-count">{{ form.description.length }}/300</text>
        </view>
      </view>

      <view style="height: 120rpx;"></view>
    </scroll-view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      isReady: false,
      glowRows: [],
      isEdit: false,
      typeOptions: ['通用', '超充', '慢充', '快充'],
      form: {
        name: '',
        type: '',
        enabled: true,
        peakPrice: '',
        peakTime: '',
        highPrice: '',
        highTime: '',
        flatPrice: '',
        flatTime: '',
        lowPrice: '',
        lowTime: '',
        description: ''
      }
    }
  },
  onLoad(options) {
    if (options.rateId) {
      this.isEdit = true
      this.form = {
        name: '标准充电费率',
        type: '通用',
        enabled: true,
        peakPrice: '1.80',
        peakTime: '10:00-12:00,14:00-17:00',
        highPrice: '1.50',
        highTime: '08:00-10:00,12:00-14:00,17:00-19:00',
        flatPrice: '1.10',
        flatTime: '07:00-08:00,19:00-21:00',
        lowPrice: '0.70',
        lowTime: '21:00-07:00',
        description: '适用于普通快充桩的标准阶梯电价方案'
      }
    }
  },
  created() {
    this.buildGlowRows()
    var self = this
    setTimeout(function() { self.isReady = true }, 200)
  },
  methods: {
    buildGlowRows() {
      var rows = []
      var colors = ['#f59e0b', '#f97316', '#fb923c', '#fbbf24']
      for (var r = 0; r < 5; r++) {
        var dots = []
        var count = 3 + Math.floor(Math.random() * 4)
        for (var c = 0; c < count; c++) {
          var color = colors[Math.floor(Math.random() * colors.length)]
          dots.push({ style: 'width:' + (3 + Math.floor(Math.random() * 6)) + 'px;height:' + (3 + Math.floor(Math.random() * 6)) + 'px;background:' + color + ';animation-duration:' + (2 + Math.random() * 3) + 's;animation-delay:' + Math.random() * 2 + 's;' })
        }
        rows.push({ dots: dots })
      }
      this.glowRows = rows
    },
    goBack() { uni.navigateBack() },
    onTypeChange(e) { this.form.type = this.typeOptions[e.detail.value] },
    onEnabledChange(e) { this.form.enabled = e.detail.value },
    submitForm() {
      if (!this.form.name) { uni.showToast({ title: '请输入方案名称', icon: 'none' }); return }
      if (!this.form.type) { uni.showToast({ title: '请选择适用类型', icon: 'none' }); return }
      uni.showToast({ title: this.isEdit ? '修改成功' : '创建成功', icon: 'success' })
      setTimeout(function() { uni.navigateBack() }, 1500)
    }
  }
}
</script>

<style scoped>
.page { min-height: 100vh; background: linear-gradient(180deg, #fff7ed 0%, #fffbeb 30%, #fefce8 60%, #fff7ed 100%); opacity: 0; transition: opacity 0.5s ease; }
.page-ready { opacity: 1; }
.glow-matrix { position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 0; overflow: hidden; pointer-events: none; }
.glow-row { display: flex; justify-content: space-around; padding: 20rpx 30rpx; }
.glow-spot { border-radius: 50%; filter: blur(6px); opacity: 0; animation: glowPulse ease-in-out infinite alternate; }
@keyframes glowPulse {
  0% { opacity: 0; transform: scale(0.6); }
  50% { opacity: 0.5; }
  100% { opacity: 0; transform: scale(1.4); }
}
.overlay-mask { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: linear-gradient(180deg, rgba(255,247,237,0.3) 0%, rgba(255,251,235,0.43) 38%, rgba(254,252,232,0.55) 66%, rgba(255,247,237,0.63) 100%); z-index: 1; pointer-events: none; }
.main-scroll { position: relative; z-index: 2; }
.header { position: relative; padding: 30rpx 28rpx 24rpx; display: flex; align-items: center; }
.header-bg { position: absolute; top: -60rpx; left: -40rpx; right: -40rpx; bottom: 0; background: radial-gradient(ellipse at 20% 30%, rgba(251,146,60,0.12) 0%, transparent 60%), radial-gradient(ellipse at 80% 50%, rgba(250,204,21,0.1) 0%, transparent 55%); border-radius: 0 0 60rpx 60rpx; }
.back-btn { width: 60rpx; height: 60rpx; border-radius: 30rpx; background: rgba(255,255,255,0.75); backdrop-filter: blur(10px); display: flex; align-items: center; justify-content: center; z-index: 1; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06); }
.back-icon { font-size: 28rpx; color: #92400e; }
.btn-hover { opacity: 0.7; transform: scale(0.95); }
.header-info { flex: 1; margin-left: 20rpx; z-index: 1; }
.header-title { font-size: 36rpx; font-weight: 700; color: #451a03; display: block; }
.header-sub { font-size: 24rpx; color: #a16207; margin-top: 4rpx; display: block; }
.header-right { z-index: 1; }
.submit-text { font-size: 28rpx; color: #fff; background: linear-gradient(135deg, #f59e0b, #f97316); padding: 10rpx 24rpx; border-radius: 16rpx; font-weight: 600; }
.info-section { margin: 0 24rpx 20rpx; }
.section-title { display: flex; align-items: center; margin-bottom: 16rpx; }
.title-line { width: 6rpx; height: 32rpx; border-radius: 3rpx; background: linear-gradient(180deg, #f59e0b, #f97316); margin-right: 12rpx; }
.title-line.line-green { background: linear-gradient(180deg, #22c55e, #16a34a); }
.title-line.line-blue { background: linear-gradient(180deg, #3b82f6, #2563eb); }
.title-line.line-purple { background: linear-gradient(180deg, #a855f7, #7c3aed); }
.title-line.line-dark { background: linear-gradient(180deg, #44403c, #1c1917); }
.title-line.line-teal { background: linear-gradient(180deg, #14b8a6, #0d9488); }
.title-text { font-size: 30rpx; font-weight: 700; color: #1c1917; }
.info-card { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 24rpx; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.form-row { display: flex; align-items: center; padding: 16rpx 0; border-bottom: 1rpx solid #f5f0e8; }
.form-row:last-child { border-bottom: none; }
.form-label { width: 160rpx; font-size: 26rpx; color: #78716c; flex-shrink: 0; }
.form-input { flex: 1; font-size: 26rpx; color: #1c1917; text-align: right; }
.form-placeholder { color: #a8a29e; }
.form-picker { flex: 1; display: flex; justify-content: flex-end; align-items: center; }
.picker-text { font-size: 26rpx; color: #1c1917; }
.picker-text.placeholder { color: #a8a29e; }
.picker-arrow { font-size: 22rpx; color: #a8a29e; margin-left: 8rpx; }
.form-switch { transform: scale(0.8); }
.desc-card { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 24rpx; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.desc-textarea { width: 100%; min-height: 160rpx; font-size: 26rpx; color: #1c1917; line-height: 1.6; }
.desc-placeholder { color: #a8a29e; }
.desc-count { text-align: right; font-size: 22rpx; color: #a8a29e; margin-top: 12rpx; display: block; }
</style>