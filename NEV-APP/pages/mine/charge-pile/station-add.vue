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
          <text class="header-title">{{ isEdit ? '编辑站点' : '添加站点' }}</text>
          <text class="header-sub">{{ isEdit ? '修改站点信息' : '创建新充电站点' }}</text>
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
            <text class="form-label">站点名称</text>
            <input class="form-input" v-model="form.name" placeholder="请输入站点名称" placeholder-class="form-placeholder" />
          </view>
          <view class="form-row">
            <text class="form-label">所在区域</text>
            <picker class="form-picker" :range="areaOptions" @change="onAreaChange">
              <text class="picker-text" :class="{ placeholder: !form.area }">{{ form.area || '请选择区域' }}</text>
              <text class="picker-arrow">❯</text>
            </picker>
          </view>
          <view class="form-row">
            <text class="form-label">详细地址</text>
            <input class="form-input" v-model="form.address" placeholder="请输入详细地址" placeholder-class="form-placeholder" />
          </view>
          <view class="form-row">
            <text class="form-label">联系电话</text>
            <input class="form-input" v-model="form.phone" placeholder="请输入联系电话" placeholder-class="form-placeholder" type="number" />
          </view>
          <view class="form-row">
            <text class="form-label">营业时间</text>
            <view class="form-time-row">
              <picker class="time-picker" mode="time" :value="form.openTime" @change="onOpenTimeChange">
                <text class="picker-text" :class="{ placeholder: !form.openTime }">{{ form.openTime || '开始' }}</text>
              </picker>
              <text class="time-sep">至</text>
              <picker class="time-picker" mode="time" :value="form.closeTime" @change="onCloseTimeChange">
                <text class="picker-text" :class="{ placeholder: !form.closeTime }">{{ form.closeTime || '结束' }}</text>
              </picker>
            </view>
          </view>
          <view class="form-row">
            <text class="form-label">停车位数</text>
            <input class="form-input" v-model="form.parking" placeholder="请输入停车位数量" placeholder-class="form-placeholder" type="number" />
          </view>
        </view>
      </view>

      <view class="info-section">
        <view class="section-title">
          <view class="title-line line-blue"></view>
          <text class="title-text">设施配置</text>
        </view>
        <view class="checkbox-group">
          <view class="checkbox-item" v-for="(facility, idx) in facilities" :key="idx" :class="{ checked: facility.checked }" @tap="toggleFacility(idx)">
            <view class="check-box" :class="{ 'check-on': facility.checked }">
              <text class="check-mark" v-if="facility.checked">✓</text>
            </view>
            <text class="check-label">{{ facility.name }}</text>
          </view>
        </view>
      </view>

      <view class="info-section">
        <view class="section-title">
          <view class="title-line line-green"></view>
          <text class="title-text">站点描述</text>
        </view>
        <view class="desc-card">
          <textarea class="desc-textarea" v-model="form.description" placeholder="请输入站点描述信息..." placeholder-class="desc-placeholder" :maxlength="500" />
          <text class="desc-count">{{ form.description.length }}/500</text>
        </view>
      </view>

      <view class="info-section">
        <view class="section-title">
          <view class="title-line line-purple"></view>
          <text class="title-text">站点图片</text>
        </view>
        <view class="upload-grid">
          <view class="upload-item" v-for="(img, idx) in uploadImages" :key="idx">
            <view class="upload-img" :style="{ background: img.bg }">
              <text class="upload-img-icon">{{ img.icon }}</text>
            </view>
          </view>
          <view class="upload-item upload-add" @tap="addImage">
            <text class="upload-add-icon">+</text>
            <text class="upload-add-text">添加图片</text>
          </view>
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
      areaOptions: ['高新区', '历下区', '市中区', '天桥区', '槐荫区', '历城区', '长清区', '章丘区'],
      form: {
        name: '',
        area: '',
        address: '',
        phone: '',
        openTime: '',
        closeTime: '',
        parking: '',
        description: ''
      },
      facilities: [
        { name: '洗手间', checked: true },
        { name: '休息室', checked: true },
        { name: '便利店', checked: false },
        { name: '免费WiFi', checked: true },
        { name: '洗车服务', checked: false },
        { name: '餐饮服务', checked: false },
        { name: '24小时安保', checked: true },
        { name: '无障碍通道', checked: false }
      ],
      uploadImages: []
    }
  },
  onLoad(options) {
    if (options.stationId) {
      this.isEdit = true
      this.form = {
        name: '济南高新区充电站',
        area: '高新区',
        address: '高新舜华路2000号',
        phone: '0531-8888-6666',
        openTime: '00:00',
        closeTime: '24:00',
        parking: '24',
        description: '济南高新区充电站是集快充、超充于一体的综合充电站，配备12个充电车位，覆盖周边商圈和居民区。'
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
    onAreaChange(e) { this.form.area = this.areaOptions[e.detail.value] },
    onOpenTimeChange(e) { this.form.openTime = e.detail.value },
    onCloseTimeChange(e) { this.form.closeTime = e.detail.value },
    toggleFacility(idx) { this.facilities[idx].checked = !this.facilities[idx].checked },
    addImage() { uni.showToast({ title: '选择图片', icon: 'none', duration: 1500 }) },
    submitForm() {
      if (!this.form.name) { uni.showToast({ title: '请输入站点名称', icon: 'none' }); return }
      if (!this.form.address) { uni.showToast({ title: '请输入详细地址', icon: 'none' }); return }
      uni.showToast({ title: this.isEdit ? '修改成功' : '添加成功', icon: 'success' })
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
.form-time-row { flex: 1; display: flex; align-items: center; justify-content: flex-end; gap: 8rpx; }
.time-picker { padding: 8rpx 16rpx; background: #f5f0e8; border-radius: 10rpx; }
.time-sep { font-size: 24rpx; color: #a8a29e; }
.checkbox-group { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 20rpx 24rpx; display: flex; flex-wrap: wrap; gap: 16rpx; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.checkbox-item { display: flex; align-items: center; width: calc(50% - 8rpx); }
.check-box { width: 36rpx; height: 36rpx; border-radius: 8rpx; border: 2rpx solid #d6d3d1; display: flex; align-items: center; justify-content: center; margin-right: 10rpx; }
.check-box.check-on { background: linear-gradient(135deg, #f59e0b, #f97316); border-color: transparent; }
.check-mark { font-size: 24rpx; color: #fff; }
.check-label { font-size: 26rpx; color: #1c1917; }
.desc-card { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 24rpx; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.desc-textarea { width: 100%; min-height: 200rpx; font-size: 26rpx; color: #1c1917; line-height: 1.6; }
.desc-placeholder { color: #a8a29e; }
.desc-count { text-align: right; font-size: 22rpx; color: #a8a29e; margin-top: 12rpx; display: block; }
.upload-grid { display: flex; flex-wrap: wrap; gap: 16rpx; }
.upload-item { width: calc(33.33% - 11rpx); aspect-ratio: 1; border-radius: 16rpx; overflow: hidden; }
.upload-img { width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; }
.upload-img-icon { font-size: 48rpx; }
.upload-add { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border: 2rpx dashed #d6d3d1; display: flex; flex-direction: column; align-items: center; justify-content: center; }
.upload-add-icon { font-size: 48rpx; color: #a8a29e; }
.upload-add-text { font-size: 20rpx; color: #a8a29e; margin-top: 4rpx; }
</style>