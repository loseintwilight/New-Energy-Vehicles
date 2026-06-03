<template>
  <view class="content">
    <scroll-view scroll-y class="scroll">
      <view class="hero">
        <image class="hero-bg" src="/static/images/car/car1.png" mode="aspectFill"></image>
        <view class="hero-overlay">
          <view class="hero-tag">官方置换</view>
          <text class="hero-title">以旧换新</text>
          <text class="hero-desc">旧车置换新能源，享多重补贴</text>
          <view class="hero-stats">
            <view class="hero-stat">
              <text class="hero-stat-num">¥8,000</text>
              <text class="hero-stat-label">最高补贴</text>
            </view>
            <view class="hero-stat">
              <text class="hero-stat-num">15min</text>
              <text class="hero-stat-label">快速估价</text>
            </view>
            <view class="hero-stat">
              <text class="hero-stat-num">7天</text>
              <text class="hero-stat-label">极速提车</text>
            </view>
          </view>
        </view>
      </view>

      <view class="section">
        <view class="section-hd">
          <text class="section-title">置换流程</text>
          <text class="section-sub">简单四步，轻松换新车</text>
        </view>
        <view class="process-steps">
          <view class="process-step">
            <view class="process-circle">1</view>
            <text class="process-name">在线估价</text>
            <text class="process-desc">填写车辆信息</text>
          </view>
          <view class="process-line"></view>
          <view class="process-step">
            <view class="process-circle">2</view>
            <text class="process-name">到店检测</text>
            <text class="process-desc">实车核验</text>
          </view>
          <view class="process-line"></view>
          <view class="process-step">
            <view class="process-circle">3</view>
            <text class="process-name">选购新车</text>
            <text class="process-desc">差价抵扣</text>
          </view>
          <view class="process-line"></view>
          <view class="process-step">
            <view class="process-circle">4</view>
            <text class="process-name">提车过户</text>
            <text class="process-desc">一站式办理</text>
          </view>
        </view>
      </view>

      <view class="section">
        <view class="section-hd">
          <text class="section-title">旧车估价</text>
          <text class="section-sub">填写信息，快速获取参考报价</text>
        </view>
        <view class="eval-form">
          <view class="eval-row">
            <text class="eval-label">品牌</text>
            <input class="eval-input" v-model="evalForm.brand" />
          </view>
          <view class="eval-row">
            <text class="eval-label">车型</text>
            <input class="eval-input" v-model="evalForm.model" />
          </view>
          <view class="eval-row">
            <text class="eval-label">上牌年份</text>
            <picker mode="selector" :range="yearList" @change="onYearChange">
              <view class="eval-picker">
                <text :class="['eval-picker-text', { ph: !evalForm.year }]">{{ evalForm.year || '请选择' }}</text>
                <text class="eval-arrow">▼</text>
              </view>
            </picker>
          </view>
          <view class="eval-row">
            <text class="eval-label">表显里程</text>
            <view class="eval-input-wrap">
              <input class="eval-input flex-1" type="digit" v-model="evalForm.mileage" />
              <text class="eval-unit">万公里</text>
            </view>
          </view>
        </view>
        <view class="eval-result" v-if="showEvalResult">
          <view class="eval-result-hd">
            <text class="eval-result-label">参考估价</text>
            <text class="eval-result-badge">仅供参考</text>
          </view>
          <view class="eval-result-price">
            <text class="eval-result-symbol">¥</text>
            <text class="eval-result-num">{{ evalPrice }}</text>
            <text class="eval-result-unit">万</text>
          </view>
          <view class="eval-result-bar">
            <view class="eval-result-fill" :style="{ width: evalPercent + '%' }"></view>
          </view>
          <view class="eval-result-detail">
            <view class="eval-detail-row">
              <text class="eval-detail-label">市场行情</text>
              <text class="eval-detail-val">¥{{ evalPrice }}万</text>
            </view>
            <view class="eval-detail-row">
              <text class="eval-detail-label">车况调整</text>
              <text class="eval-detail-val" style="color:#34c759;">+¥0.30万</text>
            </view>
            <view class="eval-detail-row">
              <text class="eval-detail-label">里程调整</text>
              <text class="eval-detail-val" style="color:#f5a623;">-¥0.20万</text>
            </view>
          </view>
        </view>
        <view class="eval-btn" @click="doEvaluate">
          <text>{{ showEvalResult ? '重新估价' : '立即估价' }}</text>
        </view>
      </view>

      <view class="section">
        <view class="section-hd">
          <text class="section-title">推荐换新车型</text>
          <text class="section-sub">置换补贴叠加享优惠</text>
        </view>
        <scroll-view scroll-x class="car-scroll" show-scrollbar="false">
          <view v-for="(rc, i) in recommendList" :key="rc.vehicleId" class="rc-card" @click="goTradeOrder(rc)">
            <image class="rc-img" :src="rc.image" mode="aspectFill"></image>
            <text class="rc-name">{{ rc.modelName }}</text>
            <view class="rc-price-row">
              <text class="rc-price">¥{{ rc.guidePrice }}万</text>
              <text class="rc-subsidy">补贴¥0.8万</text>
            </view>
            <view class="rc-btn">立即换新</view>
          </view>
        </scroll-view>
      </view>

      <view class="section benefits-section">
        <view class="section-hd">
          <text class="section-title">置换权益</text>
          <text class="section-sub">多重保障，放心置换</text>
        </view>
        <view class="benefits-grid">
          <view class="benefit-item">
            <view class="benefit-icon benefit-icon-blue">🔍</view>
            <text class="benefit-name">免费检测</text>
            <text class="benefit-desc">专业技师实车检测评估</text>
          </view>
          <view class="benefit-item">
            <view class="benefit-icon benefit-icon-green">💰</view>
            <text class="benefit-name">高额补贴</text>
            <text class="benefit-desc">叠加国家+品牌双重补贴</text>
          </view>
          <view class="benefit-item">
            <view class="benefit-icon benefit-icon-orange">📋</view>
            <text class="benefit-name">一站式服务</text>
            <text class="benefit-desc">评估+购车+过户全程代办</text>
          </view>
          <view class="benefit-item">
            <view class="benefit-icon benefit-icon-purple">🛡️</view>
            <text class="benefit-name">官方保障</text>
            <text class="benefit-desc">官方认证，价格透明无套路</text>
          </view>
        </view>
      </view>

      </scroll-view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      showEvalResult: false,
      evalPrice: '0.00',
      evalForm: { brand: '', model: '', year: '', mileage: '' },
      yearList: Array.from({ length: 16 }, (_, i) => 2026 - i),
      recommendList: [
        { vehicleId: 'R001', modelName: '小米SU7 后驱 长续航版', guidePrice: 24.59, image: '/static/images/car/car1.png' },
        { vehicleId: 'R002', modelName: '小米SU7 四驱 高性能版', guidePrice: 29.99, image: '/static/images/car/car2.png' },
        { vehicleId: 'R003', modelName: '小米SU7 四驱 高性能版', guidePrice: 29.99, image: '/static/images/car/car3.png' }
      ]
    }
  },
  computed: {
    evalPercent() {
      return Math.min((parseFloat(this.evalPrice) || 0) / 30 * 100, 100)
    }
  },
  methods: {
    onYearChange(e) {
      this.evalForm.year = this.yearList[e.detail.value]
    },
    doEvaluate() {
      if (!this.evalForm.brand || !this.evalForm.model || !this.evalForm.year) {
        uni.showToast({ title: '请完善车辆信息', icon: 'none' })
        return
      }
      this.evalPrice = (3 + Math.random() * 2).toFixed(1)
      this.showEvalResult = true
    },
    goTradeOrder(car) {
      uni.navigateTo({
        url: `/pages/car/order-trade?car=${encodeURIComponent(JSON.stringify(car))}&newCars=${encodeURIComponent(JSON.stringify(this.recommendList))}`
      })
    },
    handleStore() {
      uni.showToast({ title: '附近门店列表', icon: 'none' })
    }
  }
}
</script>

<style lang="scss" scoped>
.content {
  height: 100%;
  background: #f5f5f7;
}
.scroll {
  height: 100%;
}
.hero {
  position: relative;
  width: 100%;
  height: 520rpx;
  background: #1a1a2e;
}
.hero-bg {
  width: 100%;
  height: 100%;
  opacity: 0.55;
}
.hero-overlay {
  position: absolute;
  bottom: 36rpx;
  left: 32rpx;
  right: 32rpx;
}
.hero-tag {
  display: inline-block;
  padding: 4rpx 20rpx;
  border-radius: 6rpx;
  font-size: 22rpx;
  font-weight: 600;
  color: #fff;
  background: rgba(52,199,89,0.65);
  margin-bottom: 12rpx;
}
.hero-title {
  display: block;
  font-size: 52rpx;
  font-weight: 800;
  color: #fff;
}
.hero-desc {
  display: block;
  font-size: 26rpx;
  color: rgba(255,255,255,0.65);
  margin-top: 6rpx;
}
.hero-stats {
  display: flex;
  gap: 40rpx;
  margin-top: 28rpx;
}
.hero-stat { text-align: center; }
.hero-stat-num {
  display: block;
  font-size: 36rpx;
  font-weight: 700;
  color: #34c759;
}
.hero-stat-label {
  display: block;
  font-size: 22rpx;
  color: rgba(255,255,255,0.5);
  margin-top: 4rpx;
}
.section {
  margin: 20rpx 24rpx;
  padding: 32rpx 24rpx;
  background: #fff;
  border-radius: 20rpx;
}
.section-hd { margin-bottom: 24rpx; }
.section-title {
  font-size: 32rpx;
  font-weight: 700;
  color: #1a1a1a;
}
.section-sub {
  font-size: 24rpx;
  color: #999;
  margin-top: 4rpx;
}
.process-steps {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
}
.process-step {
  display: flex;
  flex-direction: column;
  align-items: center;
  flex: 1;
}
.process-circle {
  width: 56rpx;
  height: 56rpx;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 26rpx;
  font-weight: 700;
  color: #fff;
  background: linear-gradient(135deg, #34c759, #28a745);
}
.process-line {
  width: 40rpx;
  height: 2rpx;
  background: #34c759;
  margin-top: 28rpx;
  flex-shrink: 0;
}
.process-name {
  font-size: 24rpx;
  font-weight: 600;
  color: #1a1a1a;
  margin-top: 10rpx;
}
.process-desc {
  font-size: 20rpx;
  color: #999;
  margin-top: 2rpx;
}
.eval-form { display: flex; flex-direction: column; gap: 24rpx; }
.eval-row { display: flex; align-items: center; }
.eval-label {
  width: 140rpx;
  font-size: 26rpx;
  color: #666;
  flex-shrink: 0;
}
.eval-input {
  flex: 1;
  padding: 28rpx 28rpx;
  font-size: 30rpx;
  background: #f5f6f8;
  border-radius: 12rpx;
  color: #1a1a1a;
}
.eval-input-wrap {
  flex: 1;
  display: flex;
  align-items: center;
  background: #f5f6f8;
  border-radius: 12rpx;
  padding-right: 28rpx;
}
.eval-input.flex-1 {
  padding: 28rpx 28rpx;
  font-size: 30rpx;
  background: transparent;
  flex: 1;
}
.eval-unit { font-size: 24rpx; color: #999; flex-shrink: 0; }
.eval-picker {
  flex: 1;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 22rpx 24rpx;
  background: #f5f6f8;
  border-radius: 12rpx;
}
.eval-picker-text { font-size: 28rpx; color: #1a1a1a; }
.eval-picker-text.ph { color: #bbb; }
.eval-arrow { font-size: 20rpx; color: #ccc; }
.eval-result {
  margin-top: 28rpx;
  padding: 24rpx;
  background: linear-gradient(135deg, #1a1a2e, #16213e);
  border-radius: 16rpx;
}
.eval-result-hd {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12rpx;
}
.eval-result-label { font-size: 24rpx; color: rgba(255,255,255,0.55); }
.eval-result-badge {
  padding: 2rpx 12rpx;
  border-radius: 4rpx;
  font-size: 20rpx;
  color: #34c759;
  background: rgba(52,199,89,0.15);
}
.eval-result-price { display: flex; align-items: baseline; gap: 2rpx; }
.eval-result-symbol { font-size: 32rpx; color: #fff; font-weight: 700; }
.eval-result-num { font-size: 64rpx; color: #fff; font-weight: 800; }
.eval-result-unit { font-size: 28rpx; color: rgba(255,255,255,0.65); }
.eval-result-bar {
  width: 100%;
  height: 6rpx;
  background: rgba(255,255,255,0.12);
  border-radius: 3rpx;
  margin: 20rpx 0;
}
.eval-result-fill {
  height: 100%;
  background: linear-gradient(90deg, #34c759, #00d4ff);
  border-radius: 3rpx;
}
.eval-result-detail {
  background: rgba(255,255,255,0.06);
  border-radius: 12rpx;
  padding: 16rpx;
}
.eval-detail-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8rpx;
}
.eval-detail-row:last-child { margin-bottom: 0; }
.eval-detail-label { font-size: 22rpx; color: rgba(255,255,255,0.45); }
.eval-detail-val { font-size: 22rpx; color: #fff; font-weight: 600; }
.eval-btn {
  margin-top: 28rpx;
  padding: 22rpx 0;
  border-radius: 12rpx;
  text-align: center;
  font-size: 30rpx;
  font-weight: 700;
  color: #fff;
  background: linear-gradient(135deg, #34c759, #28a745);
}
.car-scroll { display: flex; white-space: nowrap; padding-bottom: 8rpx; }
.rc-card {
  display: inline-flex;
  flex-direction: column;
  width: 310rpx;
  margin-right: 20rpx;
  border-radius: 16rpx;
  overflow: hidden;
  background: #f8f9fb;
  flex-shrink: 0;
}
.rc-img { width: 100%; height: 190rpx; background: #f0f0f0; }
.rc-name {
  padding: 16rpx 16rpx 0;
  font-size: 26rpx;
  font-weight: 600;
  color: #1a1a1a;
  line-height: 1.4;
}
.rc-price-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8rpx 16rpx 0;
}
.rc-price { font-size: 28rpx; font-weight: 700; color: #3072f6; }
.rc-subsidy {
  font-size: 20rpx;
  color: #34c759;
  background: #e8f8ed;
  padding: 2rpx 10rpx;
  border-radius: 4rpx;
}
.rc-btn {
  margin: 14rpx 16rpx;
  padding: 14rpx 0;
  border-radius: 10rpx;
  text-align: center;
  font-size: 24rpx;
  font-weight: 600;
  color: #fff;
  background: linear-gradient(135deg, #34c759, #28a745);
}
.benefits-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 16rpx;
}
.benefit-item {
  width: calc(50% - 8rpx);
  padding: 24rpx 16rpx;
  background: #f8f9fb;
  border-radius: 14rpx;
  text-align: center;
}
.benefit-icon {
  width: 64rpx;
  height: 64rpx;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 12rpx;
  font-size: 32rpx;
}
.benefit-icon-blue { background: #e8f0fe; }
.benefit-icon-green { background: #e8f8ed; }
.benefit-icon-orange { background: #fef6e8; }
.benefit-icon-purple { background: #f0e8fe; }
.benefit-name {
  display: block;
  font-size: 26rpx;
  font-weight: 600;
  color: #1a1a1a;
}
.benefit-desc {
  display: block;
  font-size: 22rpx;
  color: #999;
  margin-top: 6rpx;
}
</style>