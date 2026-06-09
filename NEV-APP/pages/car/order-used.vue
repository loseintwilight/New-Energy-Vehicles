<template>
  <view class="page">
    <scroll-view scroll-y class="scroll-wrap">
      <view class="car-preview">
        <image class="preview-img" :src="car.image" mode="aspectFill"></image>
        <view class="preview-badge">官方认证二手车</view>
      </view>

      <view class="info-card">
        <text class="info-model">{{ car.modelName }}</text>
        <view class="info-tags">
          <view class="info-tag tag-blue">{{ car.typeLabel }}</view>
          <view class="info-tag tag-green">已检测</view>
          <view class="info-tag tag-orange" v-if="car.tags">{{ car.tags }}</view>
        </view>
        <view class="info-price-row">
          <view class="info-price">
            <text class="info-price-symbol">¥</text>
            <text class="info-price-num">{{ car.guidePrice }}</text>
            <text class="info-price-unit">万</text>
          </view>
          <view class="info-original" v-if="car.originalPrice">
            <text class="info-original-label">新车指导价</text>
            <text class="info-original-price">¥{{ car.originalPrice }}万</text>
          </view>
        </view>
      </view>

      <view class="specs-grid">
        <view class="spec-item">
          <text class="spec-value">{{ car.firstLicenseDate || '2025-03' }}</text>
          <text class="spec-label">首次上牌</text>
        </view>
        <view class="spec-item">
          <text class="spec-value">{{ car.mileage || 0.8 }}万km</text>
          <text class="spec-label">行驶里程</text>
        </view>
        <view class="spec-item">
          <text class="spec-value">{{ car.transferCount || 0 }}次</text>
          <text class="spec-label">过户次数</text>
        </view>
        <view class="spec-item">
          <text class="spec-value">{{ car.batterySoh || 98 }}%</text>
          <text class="spec-label">电池健康</text>
        </view>
      </view>

      <view class="section">
        <view class="section-hd">
          <text class="section-title">车辆详情</text>
        </view>
        <view class="detail-list">
          <view class="detail-row">
            <text class="detail-label">车辆颜色</text>
            <view class="detail-value-row">
              <view class="detail-color" :style="{ background: car.exteriorHex || '#4A7DB4' }"></view>
              <text class="detail-value">{{ car.color || '海湾蓝' }}</text>
            </view>
          </view>
          <view class="detail-row">
            <text class="detail-label">内饰颜色</text>
            <view class="detail-value-row">
              <view class="detail-color" :style="{ background: car.interiorHex || '#1a1a1a' }"></view>
              <text class="detail-value">{{ car.interiorColor || '极夜黑' }}</text>
            </view>
          </view>
          <view class="detail-row">
            <text class="detail-label">轮毂配置</text>
            <text class="detail-value">{{ car.wheel || '19英寸钻石轮毂' }}</text>
          </view>
          <view class="detail-row">
            <text class="detail-label">续航里程</text>
            <text class="detail-value">{{ car.rangeKm || 700 }}km</text>
          </view>
          <view class="detail-row">
            <text class="detail-label">检测评级</text>
            <text class="detail-value">{{ car.inspectionLevel || 'S级' }}</text>
          </view>
          <view class="detail-row">
            <text class="detail-label">所在地</text>
            <text class="detail-value">{{ car.licenseCity || '北京' }}</text>
          </view>
        </view>
      </view>

      <view class="section">
        <view class="section-hd">
          <text class="section-title">试驾预约</text>
          <text class="section-sub">预约看车试驾，我们将为您安排</text>
        </view>
        <view class="test-drive-card">
          <view class="test-drive-row">
            <view class="test-drive-icon-wrap">
              <image class="test-drive-icon" src="/static/images/car/icon/calendar.png" mode="aspectFit"></image>
            </view>
            <view class="test-drive-field">
              <text class="test-drive-field-label">预约时间</text>
              <picker mode="date" :value="visitDate" :start="defaultDate" @change="onDateChange">
                <view class="test-drive-picker">
                  <text :class="['test-drive-text', visitDate === defaultDate ? 'placeholder' : '']">{{ visitDate }}</text>
                  <text class="test-drive-arrow">›</text>
                </view>
              </picker>
            </view>
          </view>
          <view class="test-drive-divider"></view>
          <view class="test-drive-row">
            <view class="test-drive-icon-wrap">
              <image class="test-drive-icon" src="/static/images/car/icon/phone.png" mode="aspectFit"></image>
            </view>
            <view class="test-drive-field">
              <text class="test-drive-field-label">联系电话</text>
              <input class="test-drive-input" type="text" v-model="contactPhone" placeholder="请输入手机号" />
            </view>
          </view>
        </view>
      </view>

      <view class="section section-last">
        <view class="section-hd">
          <text class="section-title">延保服务</text>
        </view>
        <view class="warranty-list">
          <view
            v-for="(w, i) in warrantyOptions"
            :key="i"
            class="warranty-item"
            :class="{ on: selectedWarranty === i }"
            @click="selectedWarranty = i"
          >
            <view class="warranty-left">
              <text class="warranty-name">{{ w.name }}</text>
              <text class="warranty-desc">{{ w.desc }}</text>
            </view>
            <text class="warranty-price">¥{{ w.price }}</text>
          </view>
        </view>
      </view>
    </scroll-view>

    <view class="footer">
      <view class="footer-info">
        <text class="footer-price">¥{{ car.guidePrice }}万</text>
        <text class="footer-fee">含过户费·整备费</text>
      </view>
      <view class="footer-btn" @click="submitOrder">立即订购</view>
    </view>
  </view>
</template>

<script>
import { getUsedCarDetail, createCarOrder, sendOrderToAdmin } from '@/api/car/car'

export default {
  data() {
    return {
      car: {},
      selectedWarranty: 0,
      contactPhone: '',
      visitDate: '',
      defaultDate: '',

      warrantyOptions: [
        { name: '标准质保', desc: '1年/2万公里质保', price: 0 },
        { name: '延长质保', desc: '2年/4万公里质保', price: 8800 },
        { name: '全面保障', desc: '3年/6万公里质保+免费保养', price: 15800 }
      ]
    }
  },

  onLoad(options) {
    const today = new Date()
    const y = today.getFullYear()
    const m = String(today.getMonth() + 1).padStart(2, '0')
    const d = String(today.getDate()).padStart(2, '0')
    this.visitDate = `${y}-${m}-${d}`
    this.defaultDate = this.visitDate

    if (options.car) {
      this.car = JSON.parse(decodeURIComponent(options.car))
      if (this.car.vehicleId) {
        this.fetchCarDetail(this.car.vehicleId)
      }
    } else {
      this.car = {
        vehicleId: 'U001',
        modelName: '小米SU7 后驱 标准版',
        guidePrice: 20.51,
        image: '/static/images/car/car1.png',
        typeLabel: '官方认证二手车',
        tags: '优惠5%',
        originalPrice: 21.59,
        firstLicenseDate: '2025-03',
        mileage: 0.8,
        transferCount: 0,
        batterySoh: 98,
        licenseCity: '北京',
        inspectionLevel: 'S级',
        color: '海湾蓝',
        exteriorHex: '#4A7DB4',
        interiorColor: '极夜黑',
        interiorHex: '#1a1a1a',
        wheel: '19英寸钻石轮毂',
        rangeKm: 700,
        deliveryTime: '7天内提车'
      }
    }
  },

  methods: {
    fetchCarDetail(vehicleId) {
      uni.showLoading({ title: '加载中' })
      getUsedCarDetail(vehicleId).then(res => {
        uni.hideLoading()
        const d = res.data || {}
        if (d.vehicleId) {
          this.car = {
            ...this.car,
            vehicleId: d.vehicleId,
            modelName: d.modelName || this.car.modelName,
            guidePrice: d.guidePrice || this.car.guidePrice,
            originalPrice: d.originalPrice || this.car.originalPrice,
            color: d.color || this.car.color,
            mileage: d.mileage || this.car.mileage,
            transferCount: d.transferCount ?? this.car.transferCount,
            batterySoh: d.batterySoh || this.car.batterySoh,
            licenseCity: d.licenseCity || this.car.licenseCity,
            inspectionLevel: d.inspectionLevel || this.car.inspectionLevel
          }
        }
      }).catch(() => {
        uni.hideLoading()
      })
    },

    onDateChange(e) {
      this.visitDate = e.detail.value
    },

    submitOrder() {
      if (!this.contactPhone || this.contactPhone.length !== 11) {
        uni.showToast({ title: '请输入正确手机号', icon: 'none' })
        return
      }
      const data = {
        orderType: 'used_car',
        vehicleId: this.car.vehicleId,
        vehiclePrice: this.car.guidePrice,
        contactPhone: this.contactPhone,
        visitDate: this.visitDate,
        warrantyIndex: this.selectedWarranty
      }
      uni.showModal({
        title: '确认订购',
        content: `订购车型：${this.car.modelName}\n售价：¥${this.car.guidePrice}万`,
        success: (res) => {
          if (res.confirm) {
            uni.showLoading({ title: '提交中' })
            createCarOrder(Object.assign({}, data, { modelName: this.car.modelName })).then(() => {
              sendOrderToAdmin(Object.assign({}, data, { modelName: this.car.modelName }))
              uni.hideLoading()
              uni.showToast({ title: '订购成功', icon: 'success' })
              setTimeout(() => uni.navigateBack(), 1500)
            }).catch(() => {
              uni.hideLoading()
              uni.showModal({
                title: '提示',
                content: '订购申请已提交，等待门店联系确认',
                showCancel: false,
                success: () => uni.navigateBack()
              })
            })
          }
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
page {
  height: 100%;
  background: #f5f5f7;
}
.page {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background: #f5f5f7;
}
.scroll-wrap {
  flex: 1;
  height: 0;
}
.car-preview {
  position: relative;
  width: 100%;
  height: 440rpx;
  background: #2c3e50;
}
.preview-img {
  width: 100%;
  height: 100%;
  opacity: 0.8;
}
.preview-badge {
  position: absolute;
  bottom: 24rpx;
  left: 24rpx;
  padding: 8rpx 20rpx;
  background: linear-gradient(135deg, #f5a623, #f7b731);
  color: #fff;
  font-size: 22rpx;
  font-weight: 600;
  border-radius: 8rpx;
}
.info-card {
  margin: 20rpx 24rpx 0;
  background: #fff;
  border-radius: 20rpx;
  padding: 28rpx 24rpx;
}
.info-model {
  display: block;
  font-size: 34rpx;
  font-weight: 700;
  color: #1a1a1a;
}
.info-tags {
  display: flex;
  gap: 12rpx;
  margin-top: 16rpx;
}
.info-tag {
  padding: 4rpx 14rpx;
  border-radius: 6rpx;
  font-size: 20rpx;
  font-weight: 500;
}
.tag-blue {
  background: #e8f0fe;
  color: #1a73e8;
}
.tag-green {
  background: #e6f7e6;
  color: #2e7d32;
}
.tag-orange {
  background: #fff3e0;
  color: #e65100;
}
.info-price-row {
  display: flex;
  align-items: baseline;
  gap: 20rpx;
  margin-top: 20rpx;
}
.info-price {
  display: flex;
  align-items: baseline;
}
.info-price-symbol {
  font-size: 28rpx;
  color: #e53935;
  font-weight: 600;
}
.info-price-num {
  font-size: 48rpx;
  font-weight: 800;
  color: #e53935;
}
.info-price-unit {
  font-size: 24rpx;
  color: #e53935;
  font-weight: 600;
}
.info-original {
  display: flex;
  flex-direction: column;
}
.info-original-label {
  font-size: 20rpx;
  color: #999;
}
.info-original-price {
  font-size: 24rpx;
  color: #bbb;
  text-decoration: line-through;
}
.specs-grid {
  display: flex;
  margin: 20rpx 24rpx 0;
  background: #fff;
  border-radius: 20rpx;
  padding: 24rpx 16rpx;
}
.spec-item {
  flex: 1;
  text-align: center;
  border-right: 1rpx solid #f0f0f0;
}
.spec-item:last-child {
  border-right: none;
}
.spec-value {
  display: block;
  font-size: 28rpx;
  font-weight: 700;
  color: #1a1a1a;
}
.spec-label {
  display: block;
  font-size: 22rpx;
  color: #999;
  margin-top: 8rpx;
}
.section {
  margin: 20rpx 24rpx 0;
  background: #fff;
  border-radius: 20rpx;
  padding: 28rpx 24rpx;
}
.section-last {
  margin-bottom: 40rpx;
}
.section-hd {
  margin-bottom: 24rpx;
}
.section-title {
  font-size: 30rpx;
  font-weight: 700;
  color: #1a1a1a;
}
.detail-list {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
}
.detail-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.detail-label {
  font-size: 26rpx;
  color: #999;
}
.detail-value-row {
  display: flex;
  align-items: center;
  gap: 8rpx;
}
.detail-color {
  width: 28rpx;
  height: 28rpx;
  border-radius: 50%;
  border: 1rpx solid rgba(0,0,0,0.08);
}
.detail-value {
  font-size: 26rpx;
  color: #1a1a1a;
  font-weight: 500;
}
.test-drive-card {
  background: #f8f9fb;
  border-radius: 16rpx;
  padding: 8rpx 20rpx;
}
.test-drive-row {
  display: flex;
  align-items: center;
  padding: 20rpx 0;
}
.test-drive-icon-wrap {
  width: 56rpx;
  height: 56rpx;
  border-radius: 50%;
  background: #eef2ff;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 16rpx;
  flex-shrink: 0;
}
.test-drive-icon {
  width: 36rpx;
  height: 36rpx;
}
.test-drive-field {
  flex: 1;
}
.test-drive-field-label {
  font-size: 24rpx;
  color: #999;
  margin-bottom: 6rpx;
  display: block;
}
.test-drive-picker {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 28rpx;
  color: #1a1a1a;
}
.test-drive-input {
  font-size: 28rpx;
  color: #1a1a1a;
  padding: 0;
  background: transparent;
  display: block;
  width: 100%;
}
.test-drive-text {
  font-size: 28rpx;
  color: #1a1a1a;
}
.test-drive-text.placeholder {
  color: #bbb;
}
.test-drive-arrow {
  font-size: 36rpx;
  color: #ccc;
  font-weight: 300;
}
.test-drive-divider {
  height: 1rpx;
  background: #e8e8ed;
  margin: 0 0 0 72rpx;
}
.warranty-list {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}
.warranty-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx;
  border-radius: 14rpx;
  border: 2rpx solid #eee;
}
.warranty-item.on {
  border-color: #3072f6;
  background: #f0f6ff;
}
.warranty-left {
  flex: 1;
}
.warranty-name {
  display: block;
  font-size: 28rpx;
  font-weight: 600;
  color: #1a1a1a;
}
.warranty-desc {
  display: block;
  font-size: 22rpx;
  color: #999;
  margin-top: 4rpx;
}
.warranty-price {
  font-size: 30rpx;
  font-weight: 700;
  color: #3072f6;
}
.footer {
  display: flex;
  align-items: center;
  padding: 16rpx 30rpx;
  background: #fff;
  border-top: 1rpx solid #eee;
  gap: 16rpx;
}
.footer-info {
  flex: 1;
}
.footer-price {
  display: block;
  font-size: 40rpx;
  font-weight: 800;
  color: #e53935;
}
.footer-fee {
  display: block;
  font-size: 20rpx;
  color: #999;
  margin-top: 4rpx;
}
.footer-btn {
  padding: 22rpx 60rpx;
  border-radius: 12rpx;
  font-size: 30rpx;
  font-weight: 700;
  color: #fff;
  background: linear-gradient(135deg, #f5a623, #f7b731);
}
</style>