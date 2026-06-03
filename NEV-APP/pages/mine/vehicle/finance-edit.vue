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
          <text class="header-title">{{ isEdit ? '编辑记录' : '新增记录' }}</text>
          <text class="header-sub">{{ isEdit ? '修改财务记录信息' : '录入新的财务记录' }}</text>
        </view>
        <view class="header-right" @tap="submitForm">
          <text class="submit-text">保存</text>
        </view>
      </view>

      <view class="info-section">
        <view class="section-title">
          <view class="title-line"></view>
          <text class="title-text">基本信息</text>
        </view>
        <view class="info-card">
          <view class="form-row">
            <text class="form-label">记录类型</text>
            <view class="type-switch">
              <view class="type-option" :class="{ active: form.type === 'income' }" @tap="form.type = 'income'">
                <text>收入</text>
              </view>
              <view class="type-option" :class="{ active: form.type === 'expense' }" @tap="form.type = 'expense'">
                <text>支出</text>
              </view>
            </view>
          </view>
          <view class="form-row">
            <text class="form-label">金额(元)</text>
            <input class="form-input" v-model="form.amount" placeholder="请输入金额" placeholder-class="form-placeholder" type="digit" />
          </view>
          <view class="form-row">
            <text class="form-label">标题</text>
            <input class="form-input" v-model="form.title" placeholder="请输入记录标题" placeholder-class="form-placeholder" />
          </view>
          <view class="form-row">
            <text class="form-label">分类</text>
            <picker class="form-picker" :range="categoryOptions" @change="onCategoryChange">
              <text class="picker-text" :class="{ placeholder: !form.category }">{{ form.category || '请选择分类' }}</text>
              <text class="picker-arrow">❯</text>
            </picker>
          </view>
          <view class="form-row">
            <text class="form-label">日期</text>
            <picker class="form-picker" mode="date" :value="form.date" @change="onDateChange">
              <text class="picker-text">{{ form.date || '请选择日期' }}</text>
              <text class="picker-arrow">❯</text>
            </picker>
          </view>
        </view>
      </view>

      <view class="info-section">
        <view class="section-title">
          <view class="title-line line-green"></view>
          <text class="title-text">备注信息</text>
        </view>
        <view class="info-card">
          <view class="form-row-col">
            <textarea class="form-textarea" v-model="form.remark" placeholder="请输入备注信息（选填）" placeholder-class="form-placeholder" />
          </view>
        </view>
      </view>

      <view class="submit-section">
        <view class="submit-btn" @tap="submitForm">
          <text class="submit-btn-text">{{ isEdit ? '保存修改' : '确认新增' }}</text>
        </view>
      </view>

      <view class="bottom-safe"></view>
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
      incomeCategories: ['整车销售', '定金收入', '服务收入', '售后收入', '其他收入'],
      expenseCategories: ['场地成本', '设备采购', '人力成本', '营销支出', '运营支出', '其他支出'],
      form: {
        type: 'income',
        amount: '',
        title: '',
        category: '',
        date: '',
        remark: ''
      }
    }
  },
  computed: {
    categoryOptions() {
      return this.form.type === 'income' ? this.incomeCategories : this.expenseCategories
    }
  },
  onLoad(options) {
    if (options.id) {
      this.isEdit = true
      this.form = {
        type: 'income',
        amount: '185800',
        title: '比亚迪 海豹 销售款',
        category: '整车销售',
        date: '2025-06-01',
        remark: '客户全款购车，已开具发票'
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
      var colors = ['#10b981', '#059669', '#34d399', '#6ee7b7']
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
    onCategoryChange(e) {
      this.form.category = this.categoryOptions[e.detail.value]
    },
    onDateChange(e) { this.form.date = e.detail.value },
    submitForm() {
      if (!this.form.amount) { uni.showToast({ title: '请输入金额', icon: 'none' }); return }
      if (!this.form.title) { uni.showToast({ title: '请输入标题', icon: 'none' }); return }
      if (!this.form.category) { uni.showToast({ title: '请选择分类', icon: 'none' }); return }
      uni.showToast({ title: this.isEdit ? '修改成功' : '新增成功', icon: 'success' })
      setTimeout(function() { uni.navigateBack() }, 1500)
    }
  }
}
</script>

<style scoped>
.page { min-height: 100vh; background: linear-gradient(180deg, #ecfdf5 0%, #f0fdf4 30%, #faf5ff 60%, #ecfdf5 100%); opacity: 0; transition: opacity 0.5s ease; }
.page-ready { opacity: 1; }
.glow-matrix { position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 0; overflow: hidden; pointer-events: none; }
.glow-row { display: flex; justify-content: space-around; padding: 20rpx 30rpx; }
.glow-spot { border-radius: 50%; filter: blur(6px); opacity: 0; animation: glowPulse ease-in-out infinite alternate; }
@keyframes glowPulse { 0% { opacity: 0; transform: scale(0.6); } 50% { opacity: 0.5; } 100% { opacity: 0; transform: scale(1.4); } }
.overlay-mask { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: linear-gradient(180deg, rgba(236,253,245,0.35) 0%, rgba(240,253,244,0.45) 38%, rgba(250,245,255,0.55) 66%, rgba(236,253,245,0.65) 100%); z-index: 1; pointer-events: none; }
.main-scroll { position: relative; z-index: 2; }

.header { position: relative; padding: 30rpx 28rpx 24rpx; display: flex; align-items: center; }
.header-bg { position: absolute; top: -60rpx; left: -40rpx; right: -40rpx; bottom: 0; background: radial-gradient(ellipse at 20% 30%, rgba(16,185,129,0.1) 0%, transparent 60%), radial-gradient(ellipse at 80% 50%, rgba(52,211,153,0.08) 0%, transparent 55%); border-radius: 0 0 60rpx 60rpx; }
.back-btn { width: 60rpx; height: 60rpx; border-radius: 30rpx; background: rgba(255,255,255,0.75); backdrop-filter: blur(10px); display: flex; align-items: center; justify-content: center; z-index: 1; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06); }
.back-icon { font-size: 28rpx; color: #065f46; }
.header-info { flex: 1; margin-left: 20rpx; z-index: 1; }
.header-title { font-size: 36rpx; font-weight: 700; color: #022c22; display: block; }
.header-sub { font-size: 24rpx; color: #059669; margin-top: 4rpx; display: block; }
.header-right { z-index: 1; }
.submit-text { font-size: 28rpx; color: #059669; font-weight: 600; }

.info-section { padding: 0 28rpx 16rpx; }
.section-title { display: flex; align-items: center; margin-bottom: 16rpx; }
.title-line { width: 6rpx; height: 28rpx; background: linear-gradient(180deg, #10b981, #059669); border-radius: 3rpx; margin-right: 12rpx; }
.title-line.line-green { background: linear-gradient(180deg, #34d399, #10b981); }
.title-text { font-size: 28rpx; font-weight: 600; color: #065f46; }
.info-card { background: rgba(255,255,255,0.8); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 8rpx 24rpx; box-shadow: 0 2rpx 16rpx rgba(0,0,0,0.04); }

.form-row { display: flex; align-items: center; justify-content: space-between; padding: 20rpx 0; border-bottom: 1rpx solid rgba(0,0,0,0.04); }
.form-row:last-child { border-bottom: none; }
.form-label { font-size: 28rpx; color: #374151; width: 160rpx; }
.form-input { flex: 1; text-align: right; font-size: 28rpx; color: #1f2937; }
.form-placeholder { color: #d1d5db; }
.form-picker { flex: 1; display: flex; align-items: center; justify-content: flex-end; }
.picker-text { font-size: 28rpx; color: #1f2937; }
.picker-text.placeholder { color: #d1d5db; }
.picker-arrow { font-size: 22rpx; color: #9ca3af; margin-left: 12rpx; }

.type-switch { display: flex; background: rgba(0,0,0,0.04); border-radius: 12rpx; padding: 4rpx; }
.type-option { padding: 10rpx 32rpx; border-radius: 10rpx; font-size: 26rpx; color: #9ca3af; transition: all 0.3s; }
.type-option.active { background: #fff; color: #059669; font-weight: 600; box-shadow: 0 2rpx 8rpx rgba(0,0,0,0.08); }

.form-row-col { padding: 20rpx 0; }
.form-textarea { width: 100%; height: 160rpx; font-size: 28rpx; color: #1f2937; }

.submit-section { padding: 24rpx 28rpx; }
.submit-btn { background: linear-gradient(135deg, #10b981, #059669); border-radius: 20rpx; padding: 24rpx; text-align: center; box-shadow: 0 4rpx 20rpx rgba(16,185,129,0.3); }
.submit-btn:active { transform: scale(0.97); }
.submit-btn-text { font-size: 30rpx; font-weight: 600; color: #fff; }

.bottom-safe { height: 40rpx; }
</style>