<template>
  <view class="page-container">
    <!-- 页面内容 -->
    <view class="content">
      <!-- 有车辆时显示 -->
      <view class="car-list" v-if="cars.length > 0">
        <view 
          v-for="car in carsWithClass" 
          :key="car.id" 
          class="car-card"
          :class="{ active: car.isDefault }"
          @click="handleSelectCar(car)"
        >
          <!-- 卡片背景装饰 -->
          <view class="card-bg-decoration">
            <view class="bg-circle"></view>
          </view>
          
          <!-- 车辆头部 -->
          <view class="car-header">
            <view class="car-brand-section">
              <view class="car-brand-logo">
                <image src="/static/images/index/car.png" class="brand-logo-img" mode="aspectFit" />
              </view>
              <view class="car-info">
                <text class="car-brand">{{ car.brand }}</text>
                <text class="car-model">{{ car.model }}</text>
              </view>
            </view>
            <view class="default-badge" v-if="car.isDefault">
              <text class="badge-text">当前</text>
            </view>
          </view>

          <!-- 车辆图片 -->
          <view class="car-image-section">
            <view class="car-image-wrapper">
              <image class="car-image" :src="car.image" mode="aspectFill"></image>
            </view>
            <!-- 车牌 -->
            <view class="plate-wrapper">
              <text class="plate-prefix">粤</text>
              <text class="plate-number">{{ car.plate }}</text>
            </view>
          </view>

          <!-- 车辆信息卡片 -->
          <view class="car-info-card">
            <view class="info-grid">
              <view class="info-item">
                <view class="info-icon mileage-icon">
                  <text style="font-size: 28rpx;">路</text>
                </view>
                <view class="info-content">
                  <text class="info-label">表显里程</text>
                  <text class="info-value">{{ car.mileage }} km</text>
                </view>
              </view>
              <view class="info-divider"></view>
              <view class="info-item">
                <view class="info-icon battery-icon" :class="car.batteryClass">
                  <text style="font-size: 28rpx;">⚡</text>
                </view>
                <view class="info-content">
                  <text class="info-label">电池健康</text>
                  <text class="info-value" :class="car.batteryClass">{{ car.batteryHealth }}%</text>
                </view>
              </view>
            </view>
            <view class="purchase-row">
              <text class="purchase-label">购车日期</text>
              <text class="purchase-value">{{ car.purchaseDate }}</text>
            </view>
          </view>

          <!-- 底部操作 -->
          <view class="car-footer">
            <text class="vin-text">VIN: {{ car.vin }}</text>
            <view class="action-buttons">
              <view class="action-btn edit-btn" @click.stop="handleEdit(car)">
                <uni-icons type="compose" size="18" color="#3c96f3"></uni-icons>
                <text>编辑</text>
              </view>
              <view class="action-btn default-btn" v-if="!car.isDefault" @click.stop="handleSetDefault(car)">
                <uni-icons type="star" size="18" color="#f59e0b"></uni-icons>
                <text>默认</text>
              </view>
              <view class="action-btn delete-btn" @click.stop="handleDelete(car)">
                <uni-icons type="trash" size="18" color="#ef4444"></uni-icons>
              </view>
            </view>
          </view>
        </view>

        <!-- 添加车辆卡片 -->
        <view class="add-car-card" @click="handleAddCar">
          <view class="add-icon-wrapper">
            <view class="add-icon-circle">
              <uni-icons type="plus" size="36" color="#fff"></uni-icons>
            </view>
          </view>
          <text class="add-title">添加车辆</text>
          <text class="add-desc">绑定您的新能源汽车</text>
        </view>
      </view>

      <!-- 空状态 -->
      <view class="empty-state" v-else>
        <view class="empty-illustration">
          <view class="empty-circle">
            <image src="/static/images/index/car.png" class="empty-car-img" mode="aspectFit" />
          </view>
        </view>
        <text class="empty-title">暂无绑定车辆</text>
        <text class="empty-desc">添加您的爱车，享受更便捷的充电、维保等服务</text>
        <view class="empty-action" @click="handleAddCar">
          <uni-icons type="plus" size="20" color="#fff"></uni-icons>
          <text>添加第一辆车</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
import { getVehicleList, deleteVehicle, setDefaultVehicle } from '@/api/vehicle'

export default {
  data() {
    return {
      cars: [],
      loading: false
    }
  },
  computed: {
    carsWithClass() {
      return this.cars.map(car => {
        let cls = 'battery-good'
        if (car.batteryHealth < 85) {
          cls = 'battery-warn'
        }
        if (car.batteryHealth < 70) {
          cls = 'battery-bad'
        }
        return { ...car, batteryClass: cls }
      })
    }
  },
  onLoad() {
    this.loadVehicles()
  },
  onShow() {
    this.loadVehicles()
  },
  methods: {
    async loadVehicles() {
      this.loading = true
      try {
        const res = await getVehicleList()
        this.cars = (res.rows || res.list || res || []).map(car => this.formatVehicle(car))
      } catch (e) {
        console.error('加载车辆列表失败', e)
      } finally {
        this.loading = false
      }
    },
    formatVehicle(car) {
      return {
        id: car.id || car.vehicleId,
        brand: car.brand || '未知品牌',
        model: car.model || car.carModel || '未知车型',
        plate: car.plate || car.licensePlate || 'A12345',
        image: car.image || car.carImage || '/static/images/imgs/zhanshi.jpg',
        mileage: car.mileage || 0,
        batteryHealth: car.batteryHealth || car.battery || 100,
        vin: car.vin || '*****************',
        purchaseDate: car.purchaseDate || car.buyDate || '2024-01-01',
        isDefault: car.isDefault === 1 || car.isDefault === true
      }
    },
    handleSelectCar(car) {
      uni.showToast({ title: '切换到车辆：' + car.plate, icon: 'none' })
    },
    async handleSetDefault(car) {
      try {
        await setDefaultVehicle(car.id)
        this.cars.forEach(c => (c.isDefault = false))
        car.isDefault = true
        uni.showToast({ title: '已设为默认车辆', icon: 'success' })
      } catch (e) {
        uni.showToast({ title: '设置失败', icon: 'none' })
      }
    },
    handleEdit(car) {
      this.$tab.navigateTo('/pages/mine/myCar/edit?id=' + car.id)
    },
    async handleDelete(car) {
      uni.showModal({
        title: '删除车辆',
        content: '确定要删除车辆 ' + car.plate + ' 吗？',
        success: async (res) => {
          if (res.confirm) {
            try {
              await deleteVehicle(car.id)
              const idx = this.cars.indexOf(car)
              if (idx !== -1) {
                const wasDefault = car.isDefault
                this.cars.splice(idx, 1)
                if (wasDefault && this.cars.length > 0) {
                  this.cars[0].isDefault = true
                }
              }
              uni.showToast({ title: '已删除', icon: 'success' })
            } catch (e) {
              uni.showToast({ title: '删除失败', icon: 'none' })
            }
          }
        }
      })
    },
    handleAddCar() {
      this.$tab.navigateTo('/pages/mine/myCar/add')
    }
  }
}
</script>

<style lang="scss" scoped>
page {
  background: linear-gradient(180deg, #f8fafc 0%, #f1f5f9 100%);
  min-height: 100vh;
}

.content {
  padding: 24rpx 30rpx 40rpx;
}

.car-list {
  display: flex;
  flex-direction: column;
  gap: 24rpx;
}

/* 车辆卡片 */
.car-card {
  position: relative;
  background-color: #fff;
  border-radius: 28rpx;
  padding: 32rpx;
  overflow: hidden;
  box-shadow: 0 4rpx 24rpx rgba(0, 0, 0, 0.06);
  border: 3rpx solid transparent;
  transition: all 0.3s ease;
}

.car-card.active {
  border-color: #3c96f3;
  box-shadow: 0 8rpx 32rpx rgba(60, 150, 243, 0.18);
}

.card-bg-decoration {
  position: absolute;
  top: -60rpx;
  right: -60rpx;
  width: 160rpx;
  height: 160rpx;
  pointer-events: none;
}

.bg-circle {
  width: 100%;
  height: 100%;
  border-radius: 50%;
  background: linear-gradient(135deg, rgba(60, 150, 243, 0.08) 0%, rgba(139, 92, 246, 0.06) 100%);
}

/* 车辆头部 */
.car-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24rpx;
  position: relative;
  z-index: 1;
}

.car-brand-section {
  display: flex;
  align-items: center;
  gap: 16rpx;
}

.car-brand-logo {
  width: 64rpx;
  height: 64rpx;
  border-radius: 16rpx;
  background: linear-gradient(135deg, #e0f2fe 0%, #dbeafe 100%);
  display: flex;
  align-items: center;
  justify-content: center;
}

.brand-logo-img {
  width: 36rpx;
  height: 36rpx;
}

.car-info {
  display: flex;
  flex-direction: column;
  gap: 4rpx;
}

.car-brand {
  font-size: 32rpx;
  font-weight: 700;
  color: #1e293b;
  line-height: 1.2;
}

.car-model {
  font-size: 24rpx;
  color: #64748b;
}

.default-badge {
  padding: 8rpx 20rpx;
  background: linear-gradient(135deg, #3c96f3 0%, #2563eb 100%);
  border-radius: 24rpx;
  box-shadow: 0 4rpx 12rpx rgba(60, 150, 243, 0.3);
}

.badge-text {
  font-size: 20rpx;
  font-weight: 600;
  color: #fff;
}

/* 车辆图片区域 */
.car-image-section {
  position: relative;
  margin-bottom: 24rpx;
}

.car-image-wrapper {
  width: 100%;
  height: 240rpx;
  border-radius: 20rpx;
  overflow: hidden;
  background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%);
}

.car-image {
  width: 100%;
  height: 100%;
}

.plate-wrapper {
  position: absolute;
  bottom: 16rpx;
  right: 16rpx;
  display: flex;
  align-items: center;
  background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
  padding: 10rpx 24rpx;
  border-radius: 8rpx;
  box-shadow: 0 4rpx 16rpx rgba(37, 99, 235, 0.4);
  border: 2rpx solid #1d4ed8;
}

.plate-prefix {
  font-size: 24rpx;
  font-weight: 700;
  color: #fff;
  padding-right: 8rpx;
  border-right: 2rpx solid rgba(255, 255, 255, 0.4);
}

.plate-number {
  font-size: 28rpx;
  font-weight: 700;
  color: #fff;
  letter-spacing: 3rpx;
  padding-left: 8rpx;
}

/* 信息卡片 */
.car-info-card {
  background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
  border-radius: 20rpx;
  padding: 24rpx;
  margin-bottom: 20rpx;
}

.info-grid {
  display: flex;
  align-items: center;
  margin-bottom: 16rpx;
}

.info-item {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 16rpx;
}

.info-icon {
  width: 48rpx;
  height: 48rpx;
  border-radius: 12rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.mileage-icon {
  background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%);
  color: #4f46e5;
}

.battery-icon {
  background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
  color: #059669;
}

.battery-icon.battery-warn {
  background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
  color: #d97706;
}

.battery-icon.battery-bad {
  background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
  color: #dc2626;
}

.info-content {
  display: flex;
  flex-direction: column;
  gap: 4rpx;
}

.info-label {
  font-size: 22rpx;
  color: #94a3b8;
}

.info-value {
  font-size: 28rpx;
  font-weight: 600;
  color: #1e293b;
}

.info-value.battery-good {
  color: #059669;
}

.info-value.battery-warn {
  color: #d97706;
}

.info-value.battery-bad {
  color: #dc2626;
}

.info-divider {
  width: 1rpx;
  height: 40rpx;
  background-color: #e2e8f0;
  margin: 0 24rpx;
}

.purchase-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 16rpx;
  border-top: 1rpx dashed #cbd5e1;
}

.purchase-label {
  font-size: 22rpx;
  color: #94a3b8;
}

.purchase-value {
  font-size: 24rpx;
  font-weight: 500;
  color: #475569;
}

/* 底部操作 */
.car-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 20rpx;
  border-top: 1rpx solid #f1f5f9;
}

.vin-text {
  font-size: 20rpx;
  color: #cbd5e1;
}

.action-buttons {
  display: flex;
  align-items: center;
  gap: 16rpx;
}

.action-btn {
  display: flex;
  align-items: center;
  gap: 6rpx;
  padding: 10rpx 20rpx;
  border-radius: 16rpx;
  font-size: 22rpx;
  transition: all 0.2s ease;
}

.edit-btn {
  background-color: #eff6ff;
  color: #3c96f3;
}

.default-btn {
  background-color: #fffbeb;
  color: #f59e0b;
}

.delete-btn {
  width: 60rpx;
  height: 60rpx;
  padding: 0;
  justify-content: center;
  background-color: #fef2f2;
  border-radius: 50%;
}

/* 添加车辆卡片 */
.add-car-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 48rpx;
  background: linear-gradient(135deg, #fff 0%, #f8fafc 100%);
  border-radius: 28rpx;
  border: 3rpx dashed #cbd5e1;
  transition: all 0.3s ease;
}

.add-icon-wrapper {
  margin-bottom: 16rpx;
}

.add-icon-circle {
  width: 80rpx;
  height: 80rpx;
  border-radius: 50%;
  background: linear-gradient(135deg, #3c96f3 0%, #2563eb 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 6rpx 20rpx rgba(60, 150, 243, 0.35);
}

.add-title {
  font-size: 30rpx;
  font-weight: 600;
  color: #1e293b;
  margin-bottom: 8rpx;
}

.add-desc {
  font-size: 24rpx;
  color: #94a3b8;
}

/* 空状态 */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 120rpx;
}

.empty-illustration {
  margin-bottom: 40rpx;
}

.empty-circle {
  width: 240rpx;
  height: 240rpx;
  border-radius: 50%;
  background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%);
  display: flex;
  align-items: center;
  justify-content: center;
}

.empty-car-img {
  width: 100rpx;
  height: 100rpx;
  opacity: 0.6;
}

.empty-title {
  font-size: 32rpx;
  font-weight: 600;
  color: #1e293b;
  margin-bottom: 12rpx;
}

.empty-desc {
  font-size: 24rpx;
  color: #94a3b8;
  text-align: center;
  line-height: 1.6;
  margin-bottom: 40rpx;
  padding: 0 40rpx;
}

.empty-action {
  display: flex;
  align-items: center;
  gap: 10rpx;
  padding: 24rpx 60rpx;
  background: linear-gradient(135deg, #3c96f3 0%, #2563eb 100%);
  color: #fff;
  font-size: 28rpx;
  font-weight: 600;
  border-radius: 50rpx;
  box-shadow: 0 8rpx 24rpx rgba(60, 150, 243, 0.4);
}
</style>
