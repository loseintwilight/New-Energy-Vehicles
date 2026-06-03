<template>
  <view class="page">
    <scroll-view scroll-y class="scroll-wrap">
      <view class="hero">
        <image class="hero-img" :src="car.image" mode="aspectFill"></image>
        <view class="hero-overlay">
          <text class="hero-model">{{ car.modelName }}</text>
          <text class="hero-price">¥{{ car.guidePrice }}万起</text>
          <text class="hero-tag">{{ car.typeLabel }} · {{ car.deliveryTime }}</text>
        </view>
      </view>

      <view class="section">
        <view class="section-hd">
          <text class="section-title">外观颜色</text>
          <text class="section-sub">选择您的偏好配色</text>
        </view>
        <view class="color-grid">
          <view
            v-for="(c, i) in exteriorColors"
            :key="i"
            class="color-item"
            :class="{ on: selectedExterior === i }"
            @click="selectedExterior = i"
          >
            <view class="color-circle" :style="{ background: c.hex }"></view>
            <text class="color-name">{{ c.name }}</text>
          </view>
        </view>
      </view>

      <view class="section">
        <view class="section-hd">
          <text class="section-title">轮毂选配</text>
          <text class="section-sub">不同轮毂配置影响续航表现</text>
        </view>
        <view class="wheel-list">
          <view
            v-for="(w, i) in wheelOptions"
            :key="i"
            class="wheel-item"
            :class="{ on: selectedWheel === i }"
            @click="selectedWheel = i"
          >
            <view class="wheel-icon">
              <text class="wheel-icon-text">{{ w.icon }}</text>
            </view>
            <view class="wheel-info">
              <text class="wheel-name">{{ w.name }}</text>
              <text class="wheel-desc">{{ w.desc }}</text>
            </view>
            <text class="wheel-price">{{ w.price }}</text>
          </view>
        </view>
      </view>

      <view class="section">
        <view class="section-hd">
          <text class="section-title">交付方式</text>
        </view>
        <view class="delivery-list">
          <view
            v-for="(d, i) in deliveryOptions"
            :key="i"
            class="delivery-item"
            :class="{ on: selectedDelivery === i }"
            @click="selectedDelivery = i"
          >
            <view class="delivery-left">
              <text class="delivery-icon">{{ d.icon }}</text>
              <view>
                <text class="delivery-name">{{ d.name }}</text>
                <text class="delivery-desc">{{ d.desc }}</text>
              </view>
            </view>
            <text class="delivery-check">✓</text>
          </view>
        </view>
      </view>

      <view class="section">
        <view class="section-hd">
          <text class="section-title">金融服务</text>
        </view>
        <view class="finance-list">
          <view
            v-for="(f, i) in financePlans"
            :key="i"
            class="finance-item"
            :class="{ on: selectedFinance === i }"
            @click="selectedFinance = i"
          >
            <view class="finance-top">
              <text class="finance-name">{{ f.planName }}</text>
              <text class="finance-month" v-if="f.monthlyPayment">¥{{ f.monthlyPayment }}/月</text>
              <text class="finance-month" v-else>¥{{ f.totalPrice }}</text>
            </view>
            <text class="finance-detail">{{ f.detail }}</text>
          </view>
        </view>
      </view>

      <view class="section">
        <view class="section-hd">
          <text class="section-title">联系人信息</text>
        </view>
        <view class="contact-card">
          <view class="contact-row">
            <text class="contact-label">联系人</text>
            <input class="contact-input" v-model="contactName" placeholder="请输入姓名" />
          </view>
          <view class="contact-row">
            <text class="contact-label">联系电话</text>
            <input class="contact-input" type="text" v-model="contactPhone" placeholder="请输入手机号" maxlength="11" />
          </view>
        </view>
      </view>

      <view class="section section-last">
        <view class="section-hd">
          <text class="section-title">保险方案</text>
        </view>
        <view class="insurance-list">
          <view
            v-for="(ins, i) in insuranceOptions"
            :key="i"
            class="insurance-item"
            :class="{ on: selectedInsurance === i }"
            @click="selectedInsurance = i"
          >
            <view class="insurance-left">
              <text class="insurance-name">{{ ins.name }}</text>
              <text class="insurance-desc">{{ ins.desc }}</text>
            </view>
            <text class="insurance-price">¥{{ ins.price }}</text>
          </view>
        </view>
      </view>
    </scroll-view>

    <view class="footer">
      <view class="footer-summary">
        <text class="footer-label">预估总计</text>
        <text class="footer-total">
          <text class="footer-symbol">¥</text>
          {{ totalPrice }}<text class="footer-unit">万</text>
        </text>
      </view>
      <view class="footer-btn" @click="submitOrder">提交订单</view>
    </view>
  </view>
</template>

<script>
import { createCarOrder } from '@/api/car/car'

export default {
  data() {
    return {
      car: {},
      selectedExterior: 0,
      selectedWheel: 0,
      selectedDelivery: 0,
      selectedFinance: 0,
      selectedInsurance: 0,
      contactName: '',
      contactPhone: '',

      exteriorColors: [
        { name: '海湾蓝', hex: '#4A7DB4' },
        { name: '星环灰', hex: '#8C8C8C' },
        { name: '熔岩橙', hex: '#D4732A' },
        { name: '珍珠白', hex: '#F0F0F0' },
        { name: '橄榄绿', hex: '#5C7A4A' }
      ],
      wheelOptions: [
        { icon: '⏺', name: '19英寸钻石轮毂', desc: '续航700km', price: '标配' },
        { icon: '✧', name: '20英寸梅花轮毂', desc: '续航680km', price: '+¥0.8万' },
        { icon: '✦', name: '21英寸运动轮毂', desc: '续航650km', price: '+¥1.6万' }
      ],
      deliveryOptions: [
        { icon: '🏪', name: '门店自提', desc: '到店验车后提车，约2小时' },
        { icon: '🚛', name: '送车上门', desc: '平板车配送至指定地址，约3-5天' }
      ],
      // vehicle_finance_plan: plan_type=full(全款)/installment(分期)
      financePlans: [
        { planName: '全款支付', planType: 'full', totalPrice: 0, downPayment: 0, monthlyPayment: 0, months: 0, interestRate: 0, detail: '一次性付清，无利息' },
        { planName: '12期免息', planType: 'installment', totalPrice: 0, downPayment: 0, monthlyPayment: 0, months: 12, interestRate: 0, detail: '首付50%，12期0利率' },
        { planName: '36期低息', planType: 'installment', totalPrice: 0, downPayment: 0, monthlyPayment: 0, months: 36, interestRate: 2.5, detail: '首付30%，年化费率2.5%' },
        { planName: '60期超长', planType: 'installment', totalPrice: 0, downPayment: 0, monthlyPayment: 0, months: 60, interestRate: 3.2, detail: '首付15%，年化费率3.2%' }
      ],
      insuranceOptions: [
        { name: '基础保障', desc: '交强险+三者200万', price: 5800 },
        { name: '全面保障', desc: '交强险+三者300万+车损险', price: 9800 },
        { name: '尊享保障', desc: '交强险+三者500万+车损险+划痕险', price: 13800 }
      ]
    }
  },

  computed: {
    totalPrice() {
      let base = this.car.guidePrice || 0
      if (this.selectedWheel === 1) base += 0.8
      if (this.selectedWheel === 2) base += 1.6
      if (this.selectedInsurance >= 0) {
        const price = this.insuranceOptions[this.selectedInsurance].price
        base += price / 10000
      }
      return base.toFixed(2)
    }
  },

  onLoad(options) {
    if (options.car) {
      this.car = JSON.parse(decodeURIComponent(options.car))
      const p = this.car.guidePrice || 0
      this.financePlans[0].totalPrice = p
      this.financePlans[1].monthlyPayment = Math.round(p * 10000 * 0.5 / 12)
      this.financePlans[1].downPayment = Math.round(p * 0.5 * 100) / 100
      this.financePlans[1].totalPrice = p
      this.financePlans[2].monthlyPayment = Math.round(p * 10000 * 0.7 * 1.08 / 36)
      this.financePlans[2].downPayment = Math.round(p * 0.3 * 100) / 100
      this.financePlans[2].totalPrice = Math.round(p * 1.08 * 100) / 100
      this.financePlans[3].monthlyPayment = Math.round(p * 10000 * 0.85 * 1.12 / 60)
      this.financePlans[3].downPayment = Math.round(p * 0.15 * 100) / 100
      this.financePlans[3].totalPrice = Math.round(p * 1.12 * 100) / 100
    } else {
      this.car = {
        vehicleId: 'N001',
        modelName: '小米SU7 后驱 标准版',
        guidePrice: 21.59,
        image: '/static/images/car-placeholder.png',
        typeLabel: '全新现车',
        deliveryTime: '7天内提车',
        color: '海湾蓝',
        exteriorHex: '#4A7DB4',
        interiorColor: '极夜黑',
        interiorHex: '#1a1a1a',
        wheel: '19英寸钻石轮毂',
        rangeKm: 700
      }
      const p = this.car.guidePrice || 0
      this.financePlans[0].totalPrice = p
      this.financePlans[1].monthlyPayment = Math.round(p * 10000 * 0.5 / 12)
      this.financePlans[1].downPayment = Math.round(p * 0.5 * 100) / 100
      this.financePlans[1].totalPrice = p
      this.financePlans[2].monthlyPayment = Math.round(p * 10000 * 0.7 * 1.08 / 36)
      this.financePlans[2].downPayment = Math.round(p * 0.3 * 100) / 100
      this.financePlans[2].totalPrice = Math.round(p * 1.08 * 100) / 100
      this.financePlans[3].monthlyPayment = Math.round(p * 10000 * 0.85 * 1.12 / 60)
      this.financePlans[3].downPayment = Math.round(p * 0.15 * 100) / 100
      this.financePlans[3].totalPrice = Math.round(p * 1.12 * 100) / 100
    }
  },

  methods: {
    submitOrder() {
      if (!this.contactName) {
        uni.showToast({ title: '请输入联系人', icon: 'none' })
        return
      }
      if (!this.contactPhone || this.contactPhone.length !== 11) {
        uni.showToast({ title: '请输入正确手机号', icon: 'none' })
        return
      }
      const selectedPlan = this.financePlans[this.selectedFinance]
      const data = {
        orderType: 'purchase',
        vehicleId: this.car.vehicleId,
        vehiclePrice: this.car.guidePrice,
        totalAmount: this.totalPrice,
        contactName: this.contactName,
        contactPhone: this.contactPhone,
        paymentMethod: selectedPlan.planType,
        insuranceInfo: JSON.stringify(this.insuranceOptions[this.selectedInsurance])
      }
      uni.showModal({
        title: '确认订购',
        content: `订购车型：${this.car.modelName}\n预估总价：¥${this.totalPrice}万`,
        success: (res) => {
          if (res.confirm) {
            uni.showLoading({ title: '提交中' })
            createCarOrder(data).then(() => {
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
  padding-bottom: 140rpx;
}
.hero {
  position: relative;
  width: 100%;
  height: 500rpx;
  background: #1a1a2e;
}
.hero-img {
  width: 100%;
  height: 100%;
  opacity: 0.75;
}
.hero-overlay {
  position: absolute;
  bottom: 30rpx;
  left: 30rpx;
  right: 30rpx;
}
.hero-model {
  display: block;
  font-size: 40rpx;
  font-weight: 700;
  color: #fff;
}
.hero-price {
  display: block;
  font-size: 52rpx;
  font-weight: 800;
  color: #fff;
  margin-top: 6rpx;
}
.hero-tag {
  display: block;
  font-size: 24rpx;
  color: rgba(255,255,255,0.7);
  margin-top: 8rpx;
}
.section {
  margin: 20rpx 24rpx;
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
.section-sub {
  font-size: 24rpx;
  color: #999;
  margin-top: 4rpx;
}
.color-grid {
  display: flex;
  gap: 16rpx;
  flex-wrap: wrap;
}
.color-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: calc(20% - 16rpx);
  padding: 12rpx 0;
  border-radius: 12rpx;
  border: 2rpx solid transparent;
}
.color-item.on {
  border-color: #3072f6;
  background: #f0f6ff;
}
.color-circle {
  width: 56rpx;
  height: 56rpx;
  border-radius: 50%;
  border: 2rpx solid rgba(0,0,0,0.08);
}
.color-name {
  font-size: 22rpx;
  color: #666;
  margin-top: 8rpx;
  text-align: center;
}
.wheel-list {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}
.wheel-item {
  display: flex;
  align-items: center;
  padding: 20rpx;
  border-radius: 14rpx;
  border: 2rpx solid #eee;
}
.wheel-item.on {
  border-color: #3072f6;
  background: #f0f6ff;
}
.wheel-icon {
  width: 72rpx;
  height: 72rpx;
  border-radius: 50%;
  background: #f0f2f5;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 20rpx;
}
.wheel-icon-text {
  font-size: 36rpx;
}
.wheel-info {
  flex: 1;
}
.wheel-name {
  display: block;
  font-size: 26rpx;
  font-weight: 600;
  color: #1a1a1a;
}
.wheel-desc {
  display: block;
  font-size: 22rpx;
  color: #999;
  margin-top: 4rpx;
}
.wheel-price {
  font-size: 26rpx;
  font-weight: 600;
  color: #3072f6;
}
.delivery-list {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}
.delivery-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24rpx 20rpx;
  border-radius: 14rpx;
  border: 2rpx solid #eee;
}
.delivery-item.on {
  border-color: #3072f6;
  background: #f0f6ff;
}
.delivery-left {
  display: flex;
  align-items: center;
  gap: 16rpx;
}
.delivery-icon {
  font-size: 40rpx;
}
.delivery-name {
  display: block;
  font-size: 28rpx;
  font-weight: 600;
  color: #1a1a1a;
}
.delivery-desc {
  display: block;
  font-size: 22rpx;
  color: #999;
  margin-top: 4rpx;
}
.delivery-check {
  font-size: 32rpx;
  color: #3072f6;
  font-weight: 700;
}
.finance-list {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}
.finance-item {
  padding: 20rpx;
  border-radius: 14rpx;
  border: 2rpx solid #eee;
}
.finance-item.on {
  border-color: #3072f6;
  background: #f0f6ff;
}
.finance-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.finance-name {
  font-size: 28rpx;
  font-weight: 600;
  color: #1a1a1a;
}
.finance-month {
  font-size: 30rpx;
  font-weight: 700;
  color: #3072f6;
}
.finance-detail {
  display: block;
  font-size: 22rpx;
  color: #999;
  margin-top: 6rpx;
}
.insurance-list {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}
.insurance-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx;
  border-radius: 14rpx;
  border: 2rpx solid #eee;
}
.insurance-item.on {
  border-color: #3072f6;
  background: #f0f6ff;
}
.insurance-left {
  flex: 1;
}
.insurance-name {
  display: block;
  font-size: 28rpx;
  font-weight: 600;
  color: #1a1a1a;
}
.insurance-desc {
  display: block;
  font-size: 22rpx;
  color: #999;
  margin-top: 4rpx;
}
.insurance-price {
  font-size: 28rpx;
  font-weight: 700;
  color: #3072f6;
}
.footer {
  display: flex;
  align-items: center;
  padding: 20rpx 30rpx;
  background: #fff;
  border-top: 1rpx solid #eee;
  gap: 20rpx;
}
.footer-summary {
  flex: 1;
}
.footer-label {
  display: block;
  font-size: 22rpx;
  color: #999;
}
.footer-total {
  font-size: 40rpx;
  font-weight: 800;
  color: #3072f6;
}
.footer-symbol {
  font-size: 24rpx;
}
.footer-unit {
  font-size: 24rpx;
}
.footer-btn {
  padding: 22rpx 60rpx;
  border-radius: 12rpx;
  font-size: 30rpx;
  font-weight: 700;
  color: #fff;
  background: linear-gradient(135deg, #3072f6, #1a5cdb);
}
</style>