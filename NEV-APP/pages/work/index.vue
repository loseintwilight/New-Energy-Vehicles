<template>
  <view class="work-container">
    <view class="navbar">
      <view class="nav-back" @click="handleBack">
        <uni-icons type="back" size="28" color="#333"></uni-icons>
      </view>
      <view class="nav-title">预约维保</view>
      <view class="nav-placeholder"></view>
    </view>

    <scroll-view scroll-y class="content">
      <view class="step-indicator">
        <view class="step" :class="{ active: currentStep >= 1, done: currentStep > 1 }">
          <view class="step-circle">1</view>
          <text class="step-text">选择门店</text>
        </view>
        <view class="step-line" :class="{ active: currentStep > 1 }"></view>
        <view class="step" :class="{ active: currentStep >= 2, done: currentStep > 2 }">
          <view class="step-circle">2</view>
          <text class="step-text">选择服务</text>
        </view>
        <view class="step-line" :class="{ active: currentStep > 2 }"></view>
        <view class="step" :class="{ active: currentStep >= 3 }">
          <view class="step-circle">3</view>
          <text class="step-text">确认预约</text>
        </view>
      </view>

      <view v-if="currentStep === 1" class="step-content">
        <view class="section-title">选择维保门店</view>
        <view class="shop-list">
          <view
            v-for="shop in shopList"
            :key="shop.shop_id"
            class="shop-card"
            :class="{ selected: selectedShop === shop.shop_id }"
            @click="selectedShop = shop.shop_id"
          >
            <view class="shop-header">
              <view class="shop-name-row">
                <view class="shop-radio">
                  <view class="radio-circle" :class="{ checked: selectedShop === shop.shop_id }">
                    <view v-if="selectedShop === shop.shop_id" class="radio-dot"></view>
                  </view>
                </view>
                <text class="shop-name">{{ shop.shop_name }}</text>
                <view class="shop-rating">
                  <text class="rating-star">★</text>
                  <text class="rating-value">{{ shop.rating }}</text>
                </view>
              </view>
            </view>
            <view class="shop-body">
              <view class="shop-info-row">
                <uni-icons type="location" size="20" color="#999"></uni-icons>
                <text class="shop-address">{{ shop.province }}{{ shop.city }}{{ shop.district || '' }} {{ shop.address }}</text>
              </view>
              <view class="shop-info-row">
                <uni-icons type="person" size="20" color="#999"></uni-icons>
                <text class="shop-contact">{{ shop.contact_name }} {{ shop.contact_phone }}</text>
              </view>
              <view class="shop-services">
                <text v-for="(svc, idx) in parseServices(shop.services_info)" :key="idx" class="service-tag">{{ svc }}</text>
              </view>
            </view>
          </view>
        </view>
        <view class="step-footer">
          <button class="btn-primary" :disabled="!selectedShop" @click="currentStep = 2">下一步</button>
        </view>
      </view>

      <view v-if="currentStep === 2" class="step-content">
        <view class="section-title">选择维保车辆</view>
        <view class="vehicle-list" v-if="vehicleList.length > 0">
          <view
            v-for="vehicle in vehicleList"
            :key="vehicle.vehicle_id"
            class="vehicle-card"
            :class="{ selected: selectedVehicle === vehicle.vehicle_id }"
            @click="selectedVehicle = vehicle.vehicle_id"
          >
            <view class="vehicle-radio">
              <view class="radio-circle" :class="{ checked: selectedVehicle === vehicle.vehicle_id }">
                <view v-if="selectedVehicle === vehicle.vehicle_id" class="radio-dot"></view>
              </view>
            </view>
            <view class="vehicle-info">
              <text class="vehicle-model">{{ vehicle.model_name }}</text>
              <text class="vehicle-tag">{{ vehicle.vehicle_type === 'new' ? '新车' : '二手车' }}</text>
            </view>
          </view>
        </view>
        <view class="empty-vehicle" v-else @click="handleAddVehicle">
          <uni-icons type="plusempty" size="48" color="#ccc"></uni-icons>
          <text class="empty-text">暂无车辆，点击添加</text>
        </view>

        <view class="section-title">选择服务项目</view>
        <view class="service-list">
          <view
            v-for="(svc, idx) in serviceItems"
            :key="idx"
            class="service-item"
            :class="{ selected: selectedServices.includes(idx) }"
            @click="toggleService(idx)"
          >
            <view class="service-check">
              <view class="check-box" :class="{ checked: selectedServices.includes(idx) }">
                <uni-icons v-if="selectedServices.includes(idx)" type="checkmarkempty" size="18" color="#fff"></uni-icons>
              </view>
            </view>
            <view class="service-info">
              <text class="service-name">{{ svc.name }}</text>
              <text class="service-desc">{{ svc.desc }}</text>
            </view>
            <view class="service-price">¥{{ svc.price }}</view>
          </view>
        </view>

        <view class="section-title">预约时间</view>
        <view class="date-picker-wrapper">
          <view class="picker-item" @click="showDatePicker = true">
            <text class="picker-label">期望日期</text>
            <view class="picker-value">
              <text :class="{ placeholder: !expectDate }">{{ expectDate || '请选择日期' }}</text>
              <uni-icons type="arrowdown" size="20" color="#999"></uni-icons>
            </view>
          </view>
          <view class="picker-item">
            <text class="picker-label">时间段</text>
            <view class="time-slot-group">
              <view
                class="time-slot"
                :class="{ selected: expectTimeSlot === 'am' }"
                @click="expectTimeSlot = 'am'"
              >
                <text>上午</text>
                <text class="slot-detail">08:00-12:00</text>
              </view>
              <view
                class="time-slot"
                :class="{ selected: expectTimeSlot === 'pm' }"
                @click="expectTimeSlot = 'pm'"
              >
                <text>下午</text>
                <text class="slot-detail">13:00-18:00</text>
              </view>
            </view>
          </view>
        </view>

        <view class="section-title">联系人信息</view>
        <view class="contact-form">
          <view class="form-item">
            <text class="form-label">联系人</text>
            <input class="form-input" v-model="contactName" placeholder="请输入联系人姓名" />
          </view>
          <view class="form-item">
            <text class="form-label">联系电话</text>
            <input class="form-input" v-model="contactPhone" type="number" maxlength="11" placeholder="请输入联系电话" />
          </view>
        </view>

        <view class="step-footer double">
          <button class="btn-outline" @click="currentStep = 1">上一步</button>
          <button class="btn-primary" :disabled="!canGoStep3" @click="currentStep = 3">下一步</button>
        </view>
      </view>

      <view v-if="currentStep === 3" class="step-content">
        <view class="section-title">确认预约信息</view>
        <view class="confirm-card">
          <view class="confirm-item">
            <text class="confirm-label">维保门店</text>
            <text class="confirm-value">{{ selectedShopInfo.shop_name || '-' }}</text>
          </view>
          <view class="confirm-item">
            <text class="confirm-label">门店地址</text>
            <text class="confirm-value">{{ selectedShopInfo.province }}{{ selectedShopInfo.city }} {{ selectedShopInfo.address }}</text>
          </view>
          <view class="confirm-item">
            <text class="confirm-label">维保车辆</text>
            <text class="confirm-value">{{ selectedVehicleInfo.model_name || '-' }}</text>
          </view>
          <view class="confirm-item">
            <text class="confirm-label">服务项目</text>
            <view class="confirm-services">
              <text v-for="(idx, i) in selectedServices" :key="i" class="confirm-service-tag">{{ serviceItems[idx].name }}</text>
            </view>
          </view>
          <view class="confirm-item">
            <text class="confirm-label">期望日期</text>
            <text class="confirm-value">{{ expectDate }}</text>
          </view>
          <view class="confirm-item">
            <text class="confirm-label">时间段</text>
            <text class="confirm-value">{{ expectTimeSlot === 'am' ? '上午 (08:00-12:00)' : '下午 (13:00-18:00)' }}</text>
          </view>
          <view class="confirm-item">
            <text class="confirm-label">联系人</text>
            <text class="confirm-value">{{ contactName }}</text>
          </view>
          <view class="confirm-item">
            <text class="confirm-label">联系电话</text>
            <text class="confirm-value">{{ contactPhone }}</text>
          </view>
          <view class="confirm-divider"></view>
          <view class="confirm-item total">
            <text class="confirm-label">服务总价</text>
            <text class="confirm-total-price">¥{{ totalAmount.toFixed(2) }}</text>
          </view>
        </view>

        <view class="step-footer double">
          <button class="btn-outline" @click="currentStep = 2">上一步</button>
          <button class="btn-primary" @click="handleSubmit">提交预约</button>
        </view>
      </view>

      <view class="footer-gap"></view>
    </scroll-view>

    <view class="date-mask" v-if="showDatePicker" @click="showDatePicker = false">
      <view class="date-panel" @click.stop>
        <view class="date-header">
          <text class="date-cancel" @click="showDatePicker = false">取消</text>
          <text class="date-title">选择日期</text>
          <text class="date-confirm" @click="handleConfirmDate">确定</text>
        </view>
        <picker-view class="date-picker-view" :value="datePickerValue" @change="handleDateChange" indicator-style="height: 50px;">
          <picker-view-column>
            <view v-for="y in years" :key="y" class="picker-text">{{ y }}年</view>
          </picker-view-column>
          <picker-view-column>
            <view v-for="m in months" :key="m" class="picker-text">{{ m }}月</view>
          </picker-view-column>
          <picker-view-column>
            <view v-for="d in days" :key="d" class="picker-text">{{ d }}日</view>
          </picker-view-column>
        </picker-view>
      </view>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    const now = new Date()
    const currentYear = now.getFullYear()
    const currentMonth = now.getMonth() + 1
    const currentDay = now.getDate()

    const years = []
    for (let i = currentYear; i <= currentYear + 1; i++) {
      years.push(i)
    }
    const months = []
    for (let i = 1; i <= 12; i++) {
      months.push(i)
    }

    return {
      currentStep: 1,
      selectedShop: '',
      selectedVehicle: '',
      selectedServices: [],
      expectDate: '',
      expectTimeSlot: 'am',
      contactName: '',
      contactPhone: '',
      showDatePicker: false,
      years: years,
      months: months,
      days: [],
      datePickerYear: currentYear,
      datePickerMonth: currentMonth,
      datePickerDay: currentDay,
      shopList: [
        {
          shop_id: 1,
          shop_name: '济南鑫维保-经十西路店',
          province: '山东省',
          city: '济南市',
          district: '槐荫区',
          address: '经十西路500号鑫源汽车城A区',
          contact_name: '孙经理',
          contact_phone: '13500003333',
          services_info: '常规保养、电池检测、空调维修、轮胎更换、钣金喷漆、保险理赔',
          rating: 4.5
        },
        {
          shop_id: 2,
          shop_name: '济南鑫维保-工业北路店',
          province: '山东省',
          city: '济南市',
          district: '历城区',
          address: '工业北路88号汽车产业园',
          contact_name: '刘师傅',
          contact_phone: '13400004444',
          services_info: '常规保养、电池均衡、底盘检修、空调清洗、美容装饰',
          rating: 4.2
        }
      ],
      vehicleList: [
        { vehicle_id: 1, model_name: '特斯拉 Model Y', vehicle_type: 'new' },
        { vehicle_id: 2, model_name: '比亚迪 海豹', vehicle_type: 'new' }
      ],
      serviceItems: [
        { name: '常规保养', desc: '更换机油、机滤、空滤等', price: 299 },
        { name: '电池检测', desc: '电池健康度全面检测', price: 199 },
        { name: '空调清洗', desc: '空调系统深度清洗消毒', price: 168 },
        { name: '轮胎更换', desc: '轮胎磨损检测及更换', price: 580 },
        { name: '钣金喷漆', desc: '车身划痕修复喷漆', price: 350 },
        { name: '底盘检修', desc: '底盘系统全面检查', price: 220 },
        { name: '美容装饰', desc: '车辆内外精洗美容', price: 128 },
        { name: '保险理赔', desc: '保险理赔代办服务', price: 0 }
      ]
    }
  },
  computed: {
    selectedShopInfo() {
      return this.shopList.find(s => s.shop_id === this.selectedShop) || {}
    },
    selectedVehicleInfo() {
      return this.vehicleList.find(v => v.vehicle_id === this.selectedVehicle) || {}
    },
    totalAmount() {
      return this.selectedServices.reduce((sum, idx) => {
        return sum + (this.serviceItems[idx].price || 0)
      }, 0)
    },
    canGoStep3() {
      return this.selectedVehicle && this.selectedServices.length > 0 && this.expectDate && this.expectTimeSlot && this.contactName && this.contactPhone
    },
    datePickerValue() {
      return [this.datePickerYear - this.years[0], this.datePickerMonth - 1, this.datePickerDay - 1]
    }
  },
  created() {
    this.updateDays()
    this.contactName = this.$store.state.user.name || ''
    this.contactPhone = this.$store.state.user.phonenumber || ''
  },
  methods: {
    handleBack() {
      uni.navigateBack()
    },
    parseServices(servicesInfo) {
      if (!servicesInfo) return []
      return servicesInfo.split('、').filter(s => s.trim())
    },
    toggleService(idx) {
      const pos = this.selectedServices.indexOf(idx)
      if (pos > -1) {
        this.selectedServices.splice(pos, 1)
      } else {
        this.selectedServices.push(idx)
      }
    },
    handleDateChange(e) {
      const val = e.detail.value
      this.datePickerYear = this.years[val[0]]
      this.datePickerMonth = this.months[val[1]]
      this.datePickerDay = val[2] + 1
      this.updateDays()
    },
    handleConfirmDate() {
      const month = String(this.datePickerMonth).padStart(2, '0')
      const day = String(this.datePickerDay).padStart(2, '0')
      this.expectDate = `${this.datePickerYear}-${month}-${day}`
      this.showDatePicker = false
    },
    updateDays() {
      const daysInMonth = new Date(this.datePickerYear, this.datePickerMonth, 0).getDate()
      this.days = []
      for (let i = 1; i <= daysInMonth; i++) {
        this.days.push(i)
      }
      if (this.datePickerDay > daysInMonth) {
        this.datePickerDay = daysInMonth
      }
    },
    handleAddVehicle() {
      uni.showToast({ title: '请先添加车辆信息', icon: 'none' })
    },
    handleSubmit() {
      const submitData = {
        shop_id: this.selectedShop,
        vehicle_id: this.selectedVehicle,
        service_item: this.selectedServices.map(idx => this.serviceItems[idx].name).join('、'),
        service_price: this.totalAmount,
        total_amount: this.totalAmount,
        expect_date: this.expectDate,
        expect_time_slot: this.expectTimeSlot,
        contact_name: this.contactName,
        contact_phone: this.contactPhone
      }

      uni.showLoading({ title: '提交中...' })
      setTimeout(() => {
        uni.hideLoading()
        uni.showToast({ title: '预约成功', icon: 'success' })
        setTimeout(() => {
          uni.navigateBack()
        }, 1500)
      }, 1000)
    }
  }
}
</script>

<style lang="scss" scoped>
page {
  background-color: #f5f6f7;
  min-height: 100vh;
}

.work-container {
  width: 100%;
  min-height: 100vh;
}

.navbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 88rpx;
  padding: 0 30rpx;
  background-color: #fff;
  position: sticky;
  top: 0;
  z-index: 100;
  box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.05);
}

.nav-back {
  width: 60rpx;
  height: 60rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.nav-title {
  font-size: 32rpx;
  font-weight: 600;
  color: #333;
}

.nav-placeholder {
  width: 60rpx;
}

.content {
  padding: 24rpx 30rpx;
}

.step-indicator {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 30rpx 0;
  margin-bottom: 20rpx;
}

.step {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.step-circle {
  width: 56rpx;
  height: 56rpx;
  border-radius: 50%;
  background-color: #e0e0e0;
  color: #999;
  font-size: 26rpx;
  font-weight: 600;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 8rpx;
}

.step.active .step-circle {
  background: linear-gradient(135deg, #3c96f3 0%, #6b7bff 100%);
  color: #fff;
}

.step.done .step-circle {
  background: linear-gradient(135deg, #27ae60 0%, #2ecc71 100%);
  color: #fff;
}

.step-text {
  font-size: 22rpx;
  color: #999;
}

.step.active .step-text {
  color: #3c96f3;
  font-weight: 600;
}

.step.done .step-text {
  color: #27ae60;
}

.step-line {
  width: 100rpx;
  height: 4rpx;
  background-color: #e0e0e0;
  margin: 0 10rpx 24rpx;
}

.step-line.active {
  background: linear-gradient(135deg, #27ae60 0%, #2ecc71 100%);
}

.section-title {
  font-size: 30rpx;
  font-weight: 600;
  color: #333;
  margin-bottom: 20rpx;
  margin-top: 10rpx;
}

.shop-list {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.shop-card {
  background: #fff;
  border-radius: 16rpx;
  padding: 24rpx;
  border: 2rpx solid transparent;
}

.shop-card.selected {
  border-color: #3c96f3;
  background: #f0f6ff;
}

.shop-name-row {
  display: flex;
  align-items: center;
}

.shop-radio {
  margin-right: 16rpx;
}

.radio-circle {
  width: 40rpx;
  height: 40rpx;
  border-radius: 50%;
  border: 2rpx solid #ccc;
  display: flex;
  align-items: center;
  justify-content: center;
}

.radio-circle.checked {
  border-color: #3c96f3;
  background-color: #3c96f3;
}

.radio-dot {
  width: 16rpx;
  height: 16rpx;
  border-radius: 50%;
  background-color: #fff;
}

.shop-name {
  font-size: 30rpx;
  font-weight: 600;
  color: #333;
  flex: 1;
}

.shop-rating {
  display: flex;
  align-items: center;
}

.rating-star {
  color: #f39c12;
  font-size: 24rpx;
  margin-right: 4rpx;
}

.rating-value {
  font-size: 26rpx;
  font-weight: 600;
  color: #f39c12;
}

.shop-body {
  margin-top: 16rpx;
  padding-left: 56rpx;
}

.shop-info-row {
  display: flex;
  align-items: center;
  margin-bottom: 8rpx;
}

.shop-address {
  font-size: 24rpx;
  color: #666;
  margin-left: 8rpx;
}

.shop-contact {
  font-size: 24rpx;
  color: #666;
  margin-left: 8rpx;
}

.shop-services {
  display: flex;
  flex-wrap: wrap;
  gap: 8rpx;
  margin-top: 12rpx;
}

.service-tag {
  font-size: 20rpx;
  color: #3c96f3;
  background: #e8f0fe;
  padding: 4rpx 14rpx;
  border-radius: 20rpx;
}

.step-footer {
  margin-top: 40rpx;
  padding-bottom: 40rpx;
}

.step-footer.double {
  display: flex;
  gap: 20rpx;
}

.btn-primary {
  flex: 1;
  height: 88rpx;
  background: linear-gradient(135deg, #3c96f3 0%, #6b7bff 100%);
  border-radius: 44rpx;
  color: #fff;
  font-size: 30rpx;
  font-weight: 600;
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
}

.btn-primary[disabled] {
  background: #ccc;
}

.btn-outline {
  flex: 1;
  height: 88rpx;
  background: #fff;
  border-radius: 44rpx;
  color: #3c96f3;
  font-size: 30rpx;
  font-weight: 600;
  border: 2rpx solid #3c96f3;
  display: flex;
  align-items: center;
  justify-content: center;
}

.vehicle-list {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
  margin-bottom: 30rpx;
}

.vehicle-card {
  display: flex;
  align-items: center;
  background: #fff;
  border-radius: 16rpx;
  padding: 24rpx;
  border: 2rpx solid transparent;
}

.vehicle-card.selected {
  border-color: #3c96f3;
  background: #f0f6ff;
}

.vehicle-radio {
  margin-right: 20rpx;
}

.vehicle-info {
  display: flex;
  align-items: center;
  flex: 1;
}

.vehicle-model {
  font-size: 28rpx;
  color: #333;
  flex: 1;
}

.vehicle-tag {
  font-size: 22rpx;
  color: #3c96f3;
  background: #e8f0fe;
  padding: 4rpx 14rpx;
  border-radius: 20rpx;
}

.empty-vehicle {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 40rpx;
  background: #fff;
  border-radius: 16rpx;
  margin-bottom: 30rpx;
}

.empty-text {
  font-size: 26rpx;
  color: #999;
  margin-top: 12rpx;
}

.service-list {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
  margin-bottom: 30rpx;
}

.service-item {
  display: flex;
  align-items: center;
  background: #fff;
  border-radius: 16rpx;
  padding: 24rpx;
  border: 2rpx solid transparent;
}

.service-item.selected {
  border-color: #3c96f3;
  background: #f0f6ff;
}

.service-check {
  margin-right: 20rpx;
}

.check-box {
  width: 40rpx;
  height: 40rpx;
  border-radius: 8rpx;
  border: 2rpx solid #ccc;
  display: flex;
  align-items: center;
  justify-content: center;
}

.check-box.checked {
  border-color: #3c96f3;
  background-color: #3c96f3;
}

.service-info {
  flex: 1;
}

.service-name {
  font-size: 28rpx;
  color: #333;
  font-weight: 500;
}

.service-desc {
  font-size: 22rpx;
  color: #999;
  margin-top: 4rpx;
}

.service-price {
  font-size: 28rpx;
  font-weight: 600;
  color: #e74c3c;
}

.date-picker-wrapper {
  background: #fff;
  border-radius: 16rpx;
  padding: 0 24rpx;
  margin-bottom: 30rpx;
}

.picker-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 28rpx 0;
  border-bottom: 1rpx solid #f0f0f0;
}

.picker-item:last-child {
  border-bottom: none;
}

.picker-label {
  font-size: 28rpx;
  color: #333;
}

.picker-value {
  display: flex;
  align-items: center;
}

.placeholder {
  color: #ccc;
  font-size: 26rpx;
}

.time-slot-group {
  display: flex;
  gap: 16rpx;
}

.time-slot {
  padding: 12rpx 24rpx;
  border-radius: 8rpx;
  border: 2rpx solid #e0e0e0;
  display: flex;
  flex-direction: column;
  align-items: center;
  font-size: 24rpx;
  color: #666;
}

.time-slot.selected {
  border-color: #3c96f3;
  background: #f0f6ff;
  color: #3c96f3;
}

.slot-detail {
  font-size: 20rpx;
  color: #999;
  margin-top: 4rpx;
}

.time-slot.selected .slot-detail {
  color: #3c96f3;
}

.contact-form {
  background: #fff;
  border-radius: 16rpx;
  padding: 0 24rpx;
  margin-bottom: 30rpx;
}

.form-item {
  display: flex;
  align-items: center;
  padding: 24rpx 0;
  border-bottom: 1rpx solid #f0f0f0;
}

.form-item:last-child {
  border-bottom: none;
}

.form-label {
  font-size: 28rpx;
  color: #333;
  width: 140rpx;
}

.form-input {
  flex: 1;
  height: 60rpx;
  font-size: 26rpx;
  color: #333;
}

.confirm-card {
  background: #fff;
  border-radius: 16rpx;
  padding: 24rpx;
  margin-bottom: 30rpx;
}

.confirm-item {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: 16rpx 0;
  border-bottom: 1rpx solid #f5f5f5;
}

.confirm-item:last-child {
  border-bottom: none;
}

.confirm-label {
  font-size: 26rpx;
  color: #999;
  min-width: 140rpx;
}

.confirm-value {
  font-size: 26rpx;
  color: #333;
  text-align: right;
  flex: 1;
}

.confirm-services {
  display: flex;
  flex-wrap: wrap;
  gap: 8rpx;
  justify-content: flex-end;
}

.confirm-service-tag {
  font-size: 22rpx;
  color: #3c96f3;
  background: #e8f0fe;
  padding: 4rpx 14rpx;
  border-radius: 20rpx;
}

.confirm-divider {
  height: 1rpx;
  background: #e0e0e0;
  margin: 8rpx 0;
}

.confirm-item.total {
  padding-top: 20rpx;
}

.confirm-total-price {
  font-size: 36rpx;
  font-weight: 700;
  color: #e74c3c;
}

.date-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  z-index: 200;
  display: flex;
  align-items: flex-end;
}

.date-panel {
  width: 100%;
  background: #fff;
  border-radius: 24rpx 24rpx 0 0;
  padding-bottom: env(safe-area-inset-bottom);
}

.date-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24rpx 30rpx;
  border-bottom: 1rpx solid #f0f0f0;
}

.date-cancel {
  font-size: 28rpx;
  color: #999;
}

.date-title {
  font-size: 30rpx;
  font-weight: 600;
  color: #333;
}

.date-confirm {
  font-size: 28rpx;
  color: #3c96f3;
  font-weight: 600;
}

.date-picker-view {
  width: 100%;
  height: 400rpx;
}

.picker-text {
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 30rpx;
  color: #333;
}

.footer-gap {
  height: 60rpx;
}
</style>