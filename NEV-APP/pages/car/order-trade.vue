<template>
  <view class="page">
    <scroll-view scroll-y class="scroll-wrap">
      <view class="step-bar">
        <view class="step-item" :class="{ on: step >= 1 }">
          <view class="step-circle">1</view>
          <text class="step-label">旧车信息</text>
        </view>
        <view class="step-line" :class="{ on: step >= 2 }"></view>
        <view class="step-item" :class="{ on: step >= 2 }">
          <view class="step-circle">2</view>
          <text class="step-label">在线估价</text>
        </view>
        <view class="step-line" :class="{ on: step >= 3 }"></view>
        <view class="step-item" :class="{ on: step >= 3 }">
          <view class="step-circle">3</view>
          <text class="step-label">换新确认</text>
        </view>
      </view>

      <template v-if="step === 1">
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
              <text class="form-label">车牌所在地</text>
              <picker mode="selector" :range="cities" @change="onCityChange">
                <view class="form-picker">
                  <text :class="['form-picker-text', { placeholder: !oldCar.city }]">{{ oldCar.city || '请选择' }}</text>
                  <text class="arrow">></text>
                </view>
              </picker>
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
            <text class="section-title">上传车辆照片</text>
            <text class="section-sub">有助于提高估价准确性</text>
          </view>
          <view class="upload-grid">
            <view class="upload-item" v-for="(img, i) in uploadImages" :key="i">
              <image v-if="img" class="upload-preview" :src="img" mode="aspectFill"></image>
              <view v-else class="upload-placeholder" @click="uploadImage(i)">
                <text class="upload-icon">+</text>
              </view>
            </view>
          </view>
        </view>

        <view class="btn-row">
          <view class="btn-primary" @click="startEvaluation">开始估价</view>
        </view>
      </template>

      <template v-if="step === 2">
        <view class="evaluation-card">
          <view class="eval-header">
            <text class="eval-title">估价结果</text>
            <text class="eval-subtitle">{{ oldCar.brand }} {{ oldCar.model }} · {{ oldCar.year }}年</text>
          </view>
          <view class="eval-price-row">
            <text class="eval-price-symbol">¥</text>
            <text class="eval-price-num">{{ evaluationPrice }}</text>
            <text class="eval-price-unit">万</text>
          </view>
          <view class="eval-bar">
            <view class="eval-bar-fill" :style="{ width: evalPercent + '%' }"></view>
          </view>
          <view class="eval-detail">
            <view class="eval-detail-item">
              <text class="eval-detail-label">市场行情价</text>
              <text class="eval-detail-value">¥{{ evaluationPrice }}万</text>
            </view>
            <view class="eval-detail-item">
              <text class="eval-detail-label">车况调整</text>
              <text class="eval-detail-value" style="color:#34c759;">+¥{{ conditionAdjust }}万</text>
            </view>
            <view class="eval-detail-item">
              <text class="eval-detail-label">里程调整</text>
              <text class="eval-detail-value" style="color:#f5a623;">-¥{{ mileageAdjust }}万</text>
            </view>
            <view class="eval-detail-item eval-total">
              <text class="eval-detail-label">最终估价</text>
              <text class="eval-detail-value" style="color:#3072f6;font-size:32rpx;">¥{{ evaluationPrice }}万</text>
            </view>
          </view>
          <view class="eval-notice">
            <text class="eval-notice-icon">ℹ️</text>
            <text class="eval-notice-text">此估价为参考价，最终成交价以门店实车检测为准</text>
          </view>
        </view>

        <view class="section">
          <view class="section-hd">
            <text class="section-title">选择心仪新车</text>
            <text class="section-sub">置换补贴可叠加享优惠</text>
          </view>
          <view class="new-car-list" v-if="newCars.length">
            <view v-for="(nc, i) in newCars" :key="i" class="new-car-item" :class="{ on: selectedNewCar === i }" @click="selectedNewCar = i">
              <image class="new-car-img" :src="nc.image" mode="aspectFill"></image>
              <view class="new-car-info">
                <text class="new-car-name">{{ nc.modelName }}</text>
                <text class="new-car-price">¥{{ nc.guidePrice }}万</text>
              </view>
              <view class="new-car-check" v-if="selectedNewCar === i">✓</view>
            </view>
          </view>
          <view class="new-car-empty" v-else>
            <text class="empty-text">暂无新车数据</text>
          </view>
        </view>

        <view class="section">
          <view class="section-hd">
            <text class="section-title">补贴与优惠</text>
          </view>
          <view class="subsidy-card">
            <view class="subsidy-row">
              <text class="subsidy-label">置换补贴</text>
              <text class="subsidy-value">¥5,000</text>
            </view>
            <view class="subsidy-row">
              <text class="subsidy-label">新能源补贴</text>
              <text class="subsidy-value">¥3,000</text>
            </view>
            <view class="subsidy-row subsidy-total">
              <text class="subsidy-label">合计优惠</text>
              <text class="subsidy-value" style="color:#3072f6;">¥8,000</text>
            </view>
          </view>
        </view>

        <view class="btn-row">
          <view class="btn-outline" @click="step = 1">上一步</view>
          <view class="btn-primary" @click="step = 3">确认换新</view>
        </view>
      </template>

      <template v-if="step === 3">
        <view class="section">
          <view class="section-hd">
            <text class="section-title">确认换新方案</text>
          </view>
          <view class="confirm-card">
            <view class="confirm-group">
              <text class="confirm-group-title">🚗 旧车</text>
              <view class="confirm-row">
                <text class="confirm-label">车型</text>
                <text class="confirm-value">{{ oldCar.brand }} {{ oldCar.model }} {{ oldCar.year }}年</text>
              </view>
              <view class="confirm-row">
                <text class="confirm-label">里程</text>
                <text class="confirm-value">{{ oldCar.mileage }}万公里</text>
              </view>
              <view class="confirm-row">
                <text class="confirm-label">估价</text>
                <text class="confirm-value" style="color:#3072f6;font-weight:700;">¥{{ evaluationPrice }}万</text>
              </view>
            </view>
            <view class="confirm-divider"></view>
            <view class="confirm-group">
              <text class="confirm-group-title">🆕 新车</text>
              <view class="confirm-row" v-if="selectedNewCar >= 0 && newCars[selectedNewCar]">
                <text class="confirm-label">车型</text>
                <text class="confirm-value">{{ newCars[selectedNewCar].modelName }}</text>
              </view>
              <view class="confirm-row">
                <text class="confirm-label">价格</text>
                <text class="confirm-value" style="color:#3072f6;font-weight:700;">¥{{ newCarPrice }}万</text>
              </view>
              <view class="confirm-row">
                <text class="confirm-label">补贴</text>
                <text class="confirm-value" style="color:#34c759;">-¥0.8万</text>
              </view>
            </view>
            <view class="confirm-divider"></view>
            <view class="confirm-total">
              <text class="confirm-total-label">应付总额</text>
              <view class="confirm-total-price">
                <text class="confirm-total-symbol">¥</text>
                <text class="confirm-total-num">{{ finalPrice }}</text>
                <text class="confirm-total-unit">万</text>
              </view>
            </view>
          </view>
        </view>

        <view class="section">
          <view class="section-hd">
            <text class="section-title">联系人信息</text>
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
                  <text class="form-picker-text">{{ storeList[storeIndex] }}</text>
                  <text class="arrow">></text>
                </view>
              </picker>
            </view>
          </view>
        </view>

        <view class="btn-row">
          <view class="btn-outline" @click="step = 2">上一步</view>
          <view class="btn-primary" @click="submitTradeIn">提交申请</view>
        </view>
      </template>

      <view style="height:40rpx;"></view>
    </scroll-view>
  </view>
</template>

<script>
import { getTradeInEvaluation, createTradeInOrder } from '@/api/car/car'

export default {
  data() {
    return {
      step: 1,
      oldCar: {
        brand: '',
        model: '',
        year: '',
        mileage: '',
        city: '',
        condition: -1
      },
      uploadImages: ['', '', ''],
      conditions: ['良好', '一般', '较差'],
      years: Array.from({ length: 16 }, (_, i) => 2026 - i),
      cities: ['北京', '上海', '广州', '深圳', '杭州', '成都', '武汉', '南京', '重庆', '西安'],
      storeList: ['北京朝阳服务中心', '上海浦东体验店', '广州天河服务中心', '深圳南山体验店'],
      storeIndex: 0,
      evaluationPrice: '0.00',
      conditionAdjust: '0.00',
      mileageAdjust: '0.00',
      selectedNewCar: 0,
      newCars: [],
      contactName: '',
      contactPhone: ''
    }
  },

  computed: {
    evalPercent() {
      const base = 10
      const val = parseFloat(this.evaluationPrice) || 0
      return Math.min((val / base) * 100, 100)
    },
    newCarPrice() {
      if (this.selectedNewCar >= 0 && this.newCars[this.selectedNewCar]) {
        return this.newCars[this.selectedNewCar].guidePrice
      }
      return '0.00'
    },
    finalPrice() {
      const p = parseFloat(this.newCarPrice) || 0
      const e = parseFloat(this.evaluationPrice) || 0
      const subsidy = 0.8
      return Math.max(p - e - subsidy, 0).toFixed(2)
    }
  },

  onLoad(options) {
    if (options.newCars) {
      try {
        this.newCars = JSON.parse(decodeURIComponent(options.newCars))
      } catch (e) {
        this.newCars = []
      }
    }
  },

  methods: {
    onYearChange(e) {
      this.oldCar.year = this.years[e.detail.value]
    },
    onCityChange(e) {
      this.oldCar.city = this.cities[e.detail.value]
    },
    onStoreChange(e) {
      this.storeIndex = e.detail.value
    },
    uploadImage(index) {
      uni.chooseImage({
        count: 1,
        success: (res) => {
          this.$set(this.uploadImages, index, res.tempFilePaths[0])
        }
      })
    },
    startEvaluation() {
      if (!this.oldCar.brand || !this.oldCar.model || !this.oldCar.year) {
        uni.showToast({ title: '请完善旧车信息', icon: 'none' })
        return
      }
      uni.showLoading({ title: '估价中' })
      const params = {
        brand: this.oldCar.brand,
        model: this.oldCar.model,
        year: this.oldCar.year,
        mileage: this.oldCar.mileage || '0'
      }
      getTradeInEvaluation(params).then(res => {
        uni.hideLoading()
        const v = res.data || res
        this.evaluationPrice = v.valuation ? String(v.valuation) : '3.50'
        this.conditionAdjust = '0.30'
        this.mileageAdjust = '0.20'
        this.step = 2
      }).catch(() => {
        uni.hideLoading()
        this.evaluationPrice = '3.50'
        this.conditionAdjust = '0.30'
        this.mileageAdjust = '0.20'
        this.step = 2
      })
    },
    submitTradeIn() {
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
        oldValuation: this.evaluationPrice,
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
page {
  background: #f5f5f7;
}
.page {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background: #f5f5f7;
}
.scroll-wrap {
  flex: 1;
}
.step-bar {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 30rpx 40rpx 20rpx;
  background: #fff;
  margin-bottom: 20rpx;
}
.step-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8rpx;
}
.step-circle {
  width: 48rpx;
  height: 48rpx;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24rpx;
  font-weight: 700;
  color: #ccc;
  background: #f0f0f0;
  transition: all 0.3s;
}
.step-item.on .step-circle {
  color: #fff;
  background: linear-gradient(135deg, #3072f6, #1a5cdb);
}
.step-label {
  font-size: 22rpx;
  color: #ccc;
}
.step-item.on .step-label {
  color: #3072f6;
  font-weight: 600;
}
.step-line {
  width: 80rpx;
  height: 2rpx;
  background: #f0f0f0;
  margin: 0 16rpx;
  margin-bottom: 40rpx;
}
.step-line.on {
  background: #3072f6;
}
.section {
  margin: 0 24rpx 20rpx;
  background: #fff;
  border-radius: 20rpx;
  padding: 28rpx 24rpx;
}
.section-hd {
  margin-bottom: 24rpx;
}
.section-title {
  font-size: 30rpx;
  font-weight: 700;
  color: #1a1a1a;
}
.section-sub {
  font-size: 24rpx;
  color: #999;
  margin-top: 4rpx;
}
.form-card {
  display: flex;
  flex-direction: column;
  gap: 24rpx;
}
.form-row {
  display: flex;
  align-items: center;
}
.form-label {
  width: 160rpx;
  font-size: 26rpx;
  color: #666;
  flex-shrink: 0;
}
.form-input {
  flex: 1;
  padding: 16rpx 20rpx;
  font-size: 26rpx;
  background: #f8f9fb;
  border-radius: 10rpx;
  color: #1a1a1a;
}
.form-input-wrap {
  flex: 1;
  display: flex;
  align-items: center;
  background: #f8f9fb;
  border-radius: 10rpx;
  padding-right: 20rpx;
}
.form-input.flex-1 {
  padding: 16rpx 20rpx;
  font-size: 26rpx;
  background: transparent;
  flex: 1;
}
.form-unit {
  font-size: 22rpx;
  color: #999;
  flex-shrink: 0;
}
.form-picker {
  flex: 1;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16rpx 20rpx;
  background: #f8f9fb;
  border-radius: 10rpx;
}
.form-picker-text {
  font-size: 26rpx;
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
  border-radius: 8rpx;
  font-size: 24rpx;
  color: #666;
  background: #f0f0f0;
}
.condition-tag.on {
  color: #fff;
  background: #3072f6;
}
.upload-grid {
  display: flex;
  gap: 16rpx;
}
.upload-item {
  width: calc(33.33% - 12rpx);
  height: 180rpx;
  border-radius: 12rpx;
  overflow: hidden;
}
.upload-preview {
  width: 100%;
  height: 100%;
}
.upload-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f8f9fb;
  border: 2rpx dashed #ddd;
  border-radius: 12rpx;
}
.upload-icon {
  font-size: 48rpx;
  color: #ccc;
}
.evaluation-card {
  margin: 0 24rpx 20rpx;
  background: linear-gradient(135deg, #1a1a2e, #16213e);
  border-radius: 24rpx;
  padding: 36rpx 28rpx;
}
.eval-header {
  margin-bottom: 16rpx;
}
.eval-title {
  display: block;
  font-size: 28rpx;
  color: rgba(255,255,255,0.7);
}
.eval-subtitle {
  display: block;
  font-size: 24rpx;
  color: rgba(255,255,255,0.5);
  margin-top: 4rpx;
}
.eval-price-row {
  display: flex;
  align-items: baseline;
  gap: 4rpx;
}
.eval-price-symbol {
  font-size: 32rpx;
  color: #fff;
  font-weight: 700;
}
.eval-price-num {
  font-size: 64rpx;
  color: #fff;
  font-weight: 800;
}
.eval-price-unit {
  font-size: 28rpx;
  color: rgba(255,255,255,0.7);
}
.eval-bar {
  width: 100%;
  height: 6rpx;
  background: rgba(255,255,255,0.15);
  border-radius: 3rpx;
  margin: 20rpx 0;
}
.eval-bar-fill {
  height: 100%;
  background: linear-gradient(90deg, #3072f6, #00d4ff);
  border-radius: 3rpx;
  transition: width 0.5s;
}
.eval-detail {
  background: rgba(255,255,255,0.08);
  border-radius: 14rpx;
  padding: 20rpx;
}
.eval-detail-item {
  display: flex;
  justify-content: space-between;
  margin-bottom: 12rpx;
}
.eval-detail-item:last-child {
  margin-bottom: 0;
}
.eval-detail-label {
  font-size: 24rpx;
  color: rgba(255,255,255,0.6);
}
.eval-detail-value {
  font-size: 24rpx;
  color: #fff;
  font-weight: 600;
}
.eval-total {
  padding-top: 12rpx;
  border-top: 1rpx solid rgba(255,255,255,0.15);
}
.eval-notice {
  display: flex;
  align-items: center;
  gap: 8rpx;
  margin-top: 16rpx;
  padding: 12rpx 16rpx;
  background: rgba(255,255,255,0.08);
  border-radius: 10rpx;
}
.eval-notice-icon {
  font-size: 24rpx;
}
.eval-notice-text {
  font-size: 22rpx;
  color: rgba(255,255,255,0.6);
}
.new-car-list {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}
.new-car-item {
  display: flex;
  align-items: center;
  padding: 16rpx;
  border-radius: 14rpx;
  border: 2rpx solid #eee;
}
.new-car-item.on {
  border-color: #3072f6;
  background: #f0f6ff;
}
.new-car-img {
  width: 120rpx;
  height: 90rpx;
  border-radius: 10rpx;
  margin-right: 16rpx;
  background: #f0f0f0;
}
.new-car-info {
  flex: 1;
}
.new-car-name {
  display: block;
  font-size: 28rpx;
  font-weight: 600;
  color: #1a1a1a;
}
.new-car-price {
  display: block;
  font-size: 24rpx;
  color: #3072f6;
  margin-top: 4rpx;
}
.new-car-check {
  width: 40rpx;
  height: 40rpx;
  border-radius: 50%;
  background: #3072f6;
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24rpx;
  font-weight: 700;
}
.new-car-empty {
  padding: 40rpx 0;
  text-align: center;
}
.empty-text {
  font-size: 26rpx;
  color: #ccc;
}
.subsidy-card {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}
.subsidy-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.subsidy-label {
  font-size: 26rpx;
  color: #666;
}
.subsidy-value {
  font-size: 26rpx;
  font-weight: 600;
  color: #1a1a1a;
}
.subsidy-total {
  padding-top: 12rpx;
  border-top: 1rpx solid #f0f0f0;
}
.confirm-card {
  background: #f8f9fb;
  border-radius: 16rpx;
  padding: 24rpx;
}
.confirm-group {
  margin-bottom: 16rpx;
}
.confirm-group-title {
  display: block;
  font-size: 26rpx;
  font-weight: 700;
  color: #1a1a1a;
  margin-bottom: 12rpx;
}
.confirm-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8rpx;
}
.confirm-label {
  font-size: 24rpx;
  color: #999;
}
.confirm-value {
  font-size: 24rpx;
  color: #1a1a1a;
  font-weight: 500;
}
.confirm-divider {
  height: 1rpx;
  background: #eee;
  margin: 16rpx 0;
}
.confirm-total {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.confirm-total-label {
  font-size: 28rpx;
  font-weight: 700;
  color: #1a1a1a;
}
.confirm-total-price {
  display: flex;
  align-items: baseline;
  gap: 2rpx;
}
.confirm-total-symbol {
  font-size: 24rpx;
  color: #3072f6;
  font-weight: 700;
}
.confirm-total-num {
  font-size: 40rpx;
  color: #3072f6;
  font-weight: 800;
}
.confirm-total-unit {
  font-size: 24rpx;
  color: #3072f6;
}
.btn-row {
  display: flex;
  gap: 20rpx;
  padding: 0 24rpx;
  margin-top: 12rpx;
}
.btn-primary {
  flex: 1;
  padding: 22rpx 0;
  border-radius: 12rpx;
  text-align: center;
  font-size: 30rpx;
  font-weight: 700;
  color: #fff;
  background: linear-gradient(135deg, #3072f6, #1a5cdb);
}
.btn-outline {
  flex: 1;
  padding: 22rpx 0;
  border-radius: 12rpx;
  text-align: center;
  font-size: 30rpx;
  font-weight: 600;
  color: #3072f6;
  background: #fff;
  border: 2rpx solid #3072f6;
}
</style>