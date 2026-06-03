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
          <text class="header-title">添加充电桩</text>
          <text class="header-sub">录入新充电桩信息</text>
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
            <text class="form-label">所属站点</text>
            <picker class="form-picker" :range="stationOptions" @change="onStationChange">
              <text class="picker-text" :class="{ placeholder: !form.station }">{{ form.station || '请选择站点' }}</text>
              <text class="picker-arrow">❯</text>
            </picker>
          </view>
          <view class="form-row">
            <text class="form-label">充电桩编号</text>
            <input class="form-input" v-model="form.code" placeholder="请输入编号" placeholder-class="form-placeholder" />
          </view>
          <view class="form-row">
            <text class="form-label">充电桩名称</text>
            <input class="form-input" v-model="form.name" placeholder="如：1号快充桩" placeholder-class="form-placeholder" />
          </view>
          <view class="form-row">
            <text class="form-label">充电类型</text>
            <picker class="form-picker" :range="typeOptions" @change="onTypeChange">
              <text class="picker-text" :class="{ placeholder: !form.type }">{{ form.type || '请选择类型' }}</text>
              <text class="picker-arrow">❯</text>
            </picker>
          </view>
          <view class="form-row">
            <text class="form-label">功率(kW)</text>
            <input class="form-input" v-model="form.power" placeholder="请输入功率" placeholder-class="form-placeholder" type="digit" />
          </view>
          <view class="form-row">
            <text class="form-label">电压(V)</text>
            <input class="form-input" v-model="form.voltage" placeholder="请输入电压" placeholder-class="form-placeholder" type="number" />
          </view>
        </view>
      </view>

      <view class="info-section">
        <view class="section-title">
          <view class="title-line line-blue"></view>
          <text class="title-text">接口信息</text>
        </view>
        <view class="info-card">
          <view class="form-row">
            <text class="form-label">接口标准</text>
            <picker class="form-picker" :range="connectorOptions" @change="onConnectorChange">
              <text class="picker-text" :class="{ placeholder: !form.connector }">{{ form.connector || '请选择' }}</text>
              <text class="picker-arrow">❯</text>
            </picker>
          </view>
          <view class="form-row">
            <text class="form-label">数量</text>
            <input class="form-input" v-model="form.connCount" placeholder="请输入接口数量" placeholder-class="form-placeholder" type="number" />
          </view>
        </view>
      </view>

      <view class="info-section">
        <view class="section-title">
          <view class="title-line line-green"></view>
          <text class="title-text">费率绑定</text>
        </view>
        <view class="info-card">
          <view class="form-row">
            <text class="form-label">费率方案</text>
            <picker class="form-picker" :range="rateOptions" @change="onRateChange">
              <text class="picker-text" :class="{ placeholder: !form.rate }">{{ form.rate || '请选择费率' }}</text>
              <text class="picker-arrow">❯</text>
            </picker>
          </view>
          <view class="form-row">
            <text class="form-label">服务费(元/度)</text>
            <input class="form-input" v-model="form.serviceFee" placeholder="请输入服务费" placeholder-class="form-placeholder" type="digit" />
          </view>
        </view>
      </view>

      <view class="info-section">
        <view class="section-title">
          <view class="title-line line-purple"></view>
          <text class="title-text">备注</text>
        </view>
        <view class="desc-card">
          <textarea class="desc-textarea" v-model="form.remark" placeholder="请输入备注信息..." placeholder-class="desc-placeholder" :maxlength="300" />
          <text class="desc-count">{{ form.remark.length }}/300</text>
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
      stationOptions: ['济南高新区充电站', '济南历下区旗舰站', '济南市中区超充站', '济南天桥区充电站', '济南槐荫区快充站'],
      typeOptions: ['直流快充', '直流超充', '交流慢充'],
      connectorOptions: ['GB/T 20234 (国标)', 'CCS Combo2 (欧标)', 'CHAdeMO (日标)', 'Tesla (美标)'],
      rateOptions: ['标准充电费率', '超充专属费率', '夜间优惠费率'],
      form: {
        station: '',
        code: '',
        name: '',
        type: '',
        power: '',
        voltage: '',
        connector: '',
        connCount: '',
        rate: '',
        serviceFee: '',
        remark: ''
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
    onStationChange(e) { this.form.station = this.stationOptions[e.detail.value] },
    onTypeChange(e) { this.form.type = this.typeOptions[e.detail.value] },
    onConnectorChange(e) { this.form.connector = this.connectorOptions[e.detail.value] },
    onRateChange(e) { this.form.rate = this.rateOptions[e.detail.value] },
    submitForm() {
      if (!this.form.station) { uni.showToast({ title: '请选择站点', icon: 'none' }); return }
      if (!this.form.name) { uni.showToast({ title: '请输入充电桩名称', icon: 'none' }); return }
      uni.showToast({ title: '添加成功', icon: 'success' })
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
.desc-card { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 24rpx; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.desc-textarea { width: 100%; min-height: 160rpx; font-size: 26rpx; color: #1c1917; line-height: 1.6; }
.desc-placeholder { color: #a8a29e; }
.desc-count { text-align: right; font-size: 22rpx; color: #a8a29e; margin-top: 12rpx; display: block; }
</style>