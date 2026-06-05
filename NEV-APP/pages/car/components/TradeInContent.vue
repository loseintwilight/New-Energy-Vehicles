<template>
  <view class="content">
    <scroll-view scroll-y class="scroll">
      <view class="hero">
        <image class="hero-bg" src="/static/images/car/以旧换新.jpg" mode="aspectFit"></image>
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
          <text class="section-title">旧车信息</text>
          <text class="section-sub">填写您要置换的车辆信息</text>
        </view>
        <view class="form-card">
          <view class="form-row">
            <text class="form-label">品牌</text>
            <input class="form-input" v-model="oldCar.brand" placeholder="如：特斯拉" />
          </view>
          <view class="form-row">
            <text class="form-label">车型</text>
            <input class="form-input" v-model="oldCar.model" placeholder="如：Model 3" />
          </view>
          <view class="form-row">
            <text class="form-label">上牌年份</text>
            <picker mode="selector" :range="years" @change="onYearChange">
              <view class="form-picker">
                <text :class="['form-picker-text', { placeholder: !oldCar.year }]">{{ oldCar.year || '请选择' }}</text>
                <text class="arrow">></text>
              </view>
            </picker>
          </view>
          <view class="form-row">
            <text class="form-label">表显里程</text>
            <view class="form-input-wrap">
              <input class="form-input flex-1" type="digit" v-model="oldCar.mileage" placeholder="请输入里程" />
              <text class="form-unit">万公里</text>
            </view>
          </view>
          <view class="form-row">
            <text class="form-label">车辆状况</text>
            <view class="condition-group">
              <view v-for="(c, i) in conditions" :key="i" class="condition-tag" :class="{ on: oldCar.condition === i }" @click="oldCar.condition = i">{{ c }}</view>
            </view>
          </view>
        </view>
      </view>

      <view class="section">
        <view class="section-hd">
          <text class="section-title">联系人信息</text>
          <text class="section-sub">提交后工作人员将尽快与您联系</text>
        </view>
        <view class="form-card">
          <view class="form-row">
            <text class="form-label">联系人</text>
            <input class="form-input" v-model="contactName" placeholder="请输入姓名" />
          </view>
          <view class="form-row">
            <text class="form-label">联系电话</text>
            <input class="form-input" type="text" v-model="contactPhone" placeholder="请输入手机号" maxlength="11" />
          </view>
          <view class="form-row">
            <text class="form-label">选择门店</text>
            <picker @change="onStoreChange" :value="storeIndex" :range="storeList">
              <view class="form-picker">
                <text class="form-picker-text">{{ storeList[storeIndex] || '请选择门店' }}</text>
                <text class="arrow">></text>
              </view>
            </picker>
          </view>
        </view>
      </view>

      <view class="section benefits-section">
        <view class="section-hd">
          <text class="section-title">置换权益</text>
          <text class="section-sub">多重保障，放心置换</text>
        </view>
        <view class="benefits-grid">
          <view class="benefit-item">
            <view class="benefit-icon benefit-icon-blue">
              <image class="benefit-icon-img" src="/static/images/car/icon/glass.png" mode="aspectFit"></image>
            </view>
            <text class="benefit-name">免费检测</text>
            <text class="benefit-desc">专业技师实车检测评估</text>
          </view>
          <view class="benefit-item">
            <view class="benefit-icon benefit-icon-green">
              <image class="benefit-icon-img" src="/static/images/car/icon/money.png" mode="aspectFit"></image>
            </view>
            <text class="benefit-name">高额补贴</text>
            <text class="benefit-desc">叠加国家+品牌双重补贴</text>
          </view>
          <view class="benefit-item">
            <view class="benefit-icon benefit-icon-orange">
              <image class="benefit-icon-img" src="/static/images/car/icon/book.png" mode="aspectFit"></image>
            </view>
            <text class="benefit-name">一站式服务</text>
            <text class="benefit-desc">评估+购车+过户全程代办</text>
          </view>
          <view class="benefit-item">
            <view class="benefit-icon benefit-icon-purple">
              <image class="benefit-icon-img" src="/static/images/car/icon/shield.png" mode="aspectFit"></image>
            </view>
            <text class="benefit-name">官方保障</text>
            <text class="benefit-desc">官方认证，价格透明无套路</text>
          </view>
        </view>
      </view>

      <view class="btn-area">
        <view class="btn-primary" @click="submitTradeIn">提交申请</view>
      </view>

      <view style="height:40rpx;"></view>
    </scroll-view>
  </view>
</template>

<script>
import { createTradeInOrder, getStores } from '@/api/car/car'

export default {
  data() {
    return {
      oldCar: {
        brand: '',
        model: '',
        year: '',
        mileage: '',
        condition: -1
      },
      conditions: ['良好', '一般', '较差'],
      years: Array.from({ length: 16 }, (_, i) => 2026 - i),
      storeList: [],
      storeIndex: 0,
      contactName: '',
      contactPhone: ''
    }
  },

  onLoad() {
    this.fetchStores()
  },

  methods: {
    fetchStores() {
      getStores().then(res => {
        this.storeList = res.data || []
      }).catch(() => {})
    },
    onYearChange(e) {
      this.oldCar.year = this.years[e.detail.value]
    },
    onStoreChange(e) {
      this.storeIndex = e.detail.value
    },
    submitTradeIn() {
      if (!this.oldCar.brand || !this.oldCar.model || !this.oldCar.year) {
        uni.showToast({ title: '请完善旧车信息', icon: 'none' })
        return
      }
      if (!this.contactName) {
        uni.showToast({ title: '请输入联系人', icon: 'none' })
        return
      }
      if (!this.contactPhone || this.contactPhone.length !== 11) {
        uni.showToast({ title: '请输入正确手机号', icon: 'none' })
        return
      }
      const data = {
        orderType: 'trade_in',
        oldVehicleBrand: this.oldCar.brand,
        oldVehicleModel: this.oldCar.model,
        oldVehicleYear: this.oldCar.year,
        contactName: this.contactName,
        contactPhone: this.contactPhone
      }
      uni.showLoading({ title: '提交中' })
      createTradeInOrder(data).then(() => {
        uni.hideLoading()
        uni.showToast({ title: '申请成功', icon: 'success' })
        setTimeout(() => uni.navigateBack(), 1500)
      }).catch(() => {
        uni.hideLoading()
        uni.showModal({
          title: '提示',
          content: '以旧换新申请已提交，工作人员将尽快与您联系',
          showCancel: false,
          success: () => uni.navigateBack()
        })
      })
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
  height: 380rpx;
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
.form-card {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
  background: #f8f9fb;
  border-radius: 16rpx;
  padding: 8rpx 20rpx;
}
.form-row {
  display: flex;
  align-items: center;
  padding: 20rpx 0;
  border-bottom: 1rpx solid #eee;
}
.form-row:last-child {
  border-bottom: none;
}
.form-label {
  width: 160rpx;
  font-size: 26rpx;
  color: #888;
  flex-shrink: 0;
  font-weight: 500;
}
.form-input {
  flex: 1;
  padding: 12rpx 0;
  font-size: 28rpx;
  background: transparent;
  border-radius: 0;
  color: #1a1a1a;
}
.form-input-wrap {
  flex: 1;
  display: flex;
  align-items: center;
  background: transparent;
  border-radius: 0;
  padding-right: 0;
}
.form-input.flex-1 {
  padding: 12rpx 0;
  font-size: 28rpx;
  background: transparent;
  flex: 1;
}
.form-unit {
  font-size: 24rpx;
  color: #999;
  flex-shrink: 0;
}
.form-picker {
  flex: 1;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12rpx 0;
  background: transparent;
  border-radius: 0;
}
.form-picker-text {
  font-size: 28rpx;
  color: #1a1a1a;
}
.form-picker-text.placeholder {
  color: #bbb;
}
.arrow {
  color: #ccc;
  font-size: 28rpx;
}
.condition-group {
  display: flex;
  gap: 12rpx;
}
.condition-tag {
  padding: 10rpx 24rpx;
  border-radius: 14rpx;
  font-size: 24rpx;
  color: #666;
  background: #f0f0f0;
  font-weight: 500;
}
.condition-tag.on {
  color: #fff;
  background: linear-gradient(135deg, #3072f6, #1a5cdb);
}
.benefit-icon-img {
  width: 36rpx;
  height: 36rpx;
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
.btn-area {
  margin: 0 24rpx 20rpx;
}
.btn-primary {
  padding: 28rpx 0;
  border-radius: 16rpx;
  text-align: center;
  font-size: 32rpx;
  font-weight: 700;
  color: #fff;
  background: linear-gradient(135deg, #3072f6, #1a5cdb);
  box-shadow: 0 4rpx 16rpx rgba(48,114,246,0.3);
}
</style>