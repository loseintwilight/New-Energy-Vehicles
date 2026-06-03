<template>
  <view class="page-container">
    <view class="car-list">
      <view v-for="car in carsWithClass" :key="car.id" class="car-card" :class="{ active: car.isDefault }" @click="handleSelectCar(car)">
        <view class="car-header">
          <view class="car-brand-row">
            <text class="car-brand">{{ car.brand }}</text>
            <text class="car-model">{{ car.model }}</text>
          </view>
          <view class="default-tag" v-if="car.isDefault">默认</view>
        </view>
        <view class="car-body">
          <view class="car-image-area">
            <image class="car-image" :src="car.image" mode="aspectFill"></image>
          </view>
          <view class="car-details">
            <view class="detail-row">
              <text class="detail-label">车牌号</text>
              <text class="detail-value plate">{{ car.plate }}</text>
            </view>
            <view class="detail-row">
              <text class="detail-label">表显里程</text>
              <text class="detail-value">{{ car.mileage }} km</text>
            </view>
            <view class="detail-row">
              <text class="detail-label">电池健康度</text>
              <text class="detail-value battery" :class="car.batteryClass">{{ car.batteryHealth }}%</text>
            </view>
            <view class="detail-row">
              <text class="detail-label">购车日期</text>
              <text class="detail-value">{{ car.purchaseDate }}</text>
            </view>
          </view>
        </view>
        <view class="car-footer">
          <text class="vin-text">VIN: {{ car.vin }}</text>
          <view class="car-actions">
            <view class="car-action" @click.stop="handleEdit(car)">
              <uni-icons type="compose" size="20" color="#666"></uni-icons>
              <text>编辑</text>
            </view>
            <view class="car-action" v-if="!car.isDefault" @click.stop="handleSetDefault(car)">
              <uni-icons type="star" size="20" color="#666"></uni-icons>
              <text>设为默认</text>
            </view>
            <view class="car-action" @click.stop="handleDelete(car)">
              <uni-icons type="trash" size="20" color="#ff4757"></uni-icons>
              <text class="delete-text">删除</text>
            </view>
          </view>
        </view>
      </view>

      <view class="add-car-card" @click="handleAddCar">
        <uni-icons type="plus" size="48" color="#3c96f3"></uni-icons>
        <text class="add-text">添加车辆</text>
      </view>
    </view>

    <view class="empty" v-if="cars.length === 0">
      <uni-icons type="car" size="80" color="#ddd"></uni-icons>
      <text class="empty-text">暂无绑定车辆</text>
      <text class="empty-sub">添加您的爱车，享受更便捷的服务</text>
      <view class="add-btn" @click="handleAddCar">添加车辆</view>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      cars: [
        {
          id: 1,
          brand: '比亚迪',
          model: '海豚 2024款 荣耀版',
          plate: '鲁A·12345',
          image: '/static/images/imgs/zhanshi.jpg',
          mileage: 15800,
          batteryHealth: 97,
          vin: 'LSVAU2NG7N2****23',
          purchaseDate: '2024-03-15',
          isDefault: true
        },
        {
          id: 2,
          brand: '小鹏',
          model: 'G6 2024款 580长续航版',
          plate: '鲁A·67890',
          image: '/static/images/imgs/zhanshi.jpg',
          mileage: 28900,
          batteryHealth: 92,
          vin: 'LVSHB2NF9N5****67',
          purchaseDate: '2023-08-20',
          isDefault: false
        }
      ]
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
  methods: {
    handleSelectCar(car) {
      uni.showToast({ title: '切换到车辆：' + car.plate, icon: 'none' })
    },
    handleSetDefault(car) {
      this.cars.forEach(c => (c.isDefault = false))
      car.isDefault = true
      uni.showToast({ title: '已设为默认车辆', icon: 'success' })
    },
    handleEdit(car) {
      uni.showToast({ title: '编辑车辆信息：' + car.plate, icon: 'none' })
    },
    handleDelete(car) {
      uni.showModal({
        title: '删除车辆',
        content: '确定要删除车辆 ' + car.plate + ' 吗？',
        success: (res) => {
          if (res.confirm) {
            const idx = this.cars.indexOf(car)
            if (idx !== -1) {
              const wasDefault = car.isDefault
              this.cars.splice(idx, 1)
              if (wasDefault && this.cars.length > 0) {
                this.cars[0].isDefault = true
              }
              uni.showToast({ title: '已删除', icon: 'success' })
            }
          }
        }
      })
    },
    handleAddCar() {
      uni.showToast({ title: '添加车辆功能开发中', icon: 'none' })
    }
  }
}
</script>

<style lang="scss" scoped>
page {
  background-color: #f5f6f7;
  min-height: 100vh;
}

.car-list {
  padding: 20rpx 30rpx;
}

.car-card {
  background-color: #fff;
  border-radius: 20rpx;
  padding: 28rpx;
  margin-bottom: 20rpx;
  border: 2rpx solid transparent;
}

.car-card.active {
  border-color: #3c96f3;
}

.car-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20rpx;
}

.car-brand-row {
  display: flex;
  align-items: baseline;
  gap: 12rpx;
}

.car-brand {
  font-size: 32rpx;
  font-weight: 700;
  color: #333;
}

.car-model {
  font-size: 24rpx;
  color: #999;
}

.default-tag {
  font-size: 22rpx;
  color: #3c96f3;
  background-color: #e8f2ff;
  padding: 4rpx 16rpx;
  border-radius: 20rpx;
}

.car-body {
  display: flex;
  gap: 20rpx;
}

.car-image-area {
  width: 200rpx;
  height: 140rpx;
  border-radius: 12rpx;
  overflow: hidden;
  flex-shrink: 0;
  background-color: #f5f5f5;
}

.car-image {
  width: 100%;
  height: 100%;
}

.car-details {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.detail-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.detail-label {
  font-size: 24rpx;
  color: #999;
}

.detail-value {
  font-size: 24rpx;
  color: #333;
}

.plate {
  color: #3c96f3;
  font-weight: 600;
  font-size: 26rpx;
  letter-spacing: 2rpx;
}

.battery-good {
  color: #27ae60;
  font-weight: 600;
}

.battery-warn {
  color: #ff9800;
  font-weight: 600;
}

.battery-bad {
  color: #ff4757;
  font-weight: 600;
}

.car-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 20rpx;
  border-top: 1rpx solid #f5f5f5;
  margin-top: 16rpx;
}

.vin-text {
  font-size: 22rpx;
  color: #bbb;
}

.car-actions {
  display: flex;
  gap: 28rpx;
}

.car-action {
  display: flex;
  align-items: center;
  gap: 4rpx;
  font-size: 22rpx;
  color: #666;
}

.delete-text {
  color: #ff4757;
}

.add-car-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 180rpx;
  background-color: #fff;
  border-radius: 20rpx;
  border: 2rpx dashed #ddd;
  margin-bottom: 20rpx;
}

.add-text {
  font-size: 26rpx;
  color: #3c96f3;
  margin-top: 8rpx;
}

.empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 200rpx;
}

.empty-text {
  font-size: 28rpx;
  color: #999;
  margin-top: 20rpx;
}

.empty-sub {
  font-size: 24rpx;
  color: #bbb;
  margin-top: 8rpx;
}

.add-btn {
  margin-top: 32rpx;
  padding: 16rpx 60rpx;
  background-color: #3c96f3;
  color: #fff;
  font-size: 28rpx;
  border-radius: 40rpx;
}
</style>