<template>
  <scroll-view scroll-y class="scroll">
    <view class="car-list">
      <view
        v-for="car in filteredList"
        :key="car.vehicleId"
        class="car-card"
        @click="goOrder(car)"
      >
        <view class="card-img-wrap">
          <image class="card-img" :src="car.image" mode="aspectFill"></image>
          <view class="card-badge badge-used">{{ car.typeLabel }}</view>
        </view>
        <view class="card-body">
          <view class="card-top">
            <text class="card-model">{{ car.modelName }}</text>
            <view class="card-tag" v-if="car.tags">{{ car.tags }}</view>
          </view>
          <view class="card-info">
            <text class="card-info-item">{{ car.firstLicenseDate }}上牌</text>
            <text class="card-info-split">|</text>
            <text class="card-info-item">{{ car.mileage }}万km</text>
            <text class="card-info-split">|</text>
            <text class="card-info-item">{{ car.transferCount }}次过户</text>
          </view>
          <view class="card-config">
            <view class="config-row">
              <view class="config-item">
                <view class="color-dot" :style="{ background: car.exteriorHex }"></view>
                <text class="config-text">{{ car.color }}</text>
              </view>
              <view class="config-item">
                <view class="color-dot" :style="{ background: car.interiorHex }"></view>
                <text class="config-text">{{ car.interiorColor }}内</text>
              </view>
            </view>
            <view class="config-row">
              <text class="config-text">{{ car.wheel }}</text>
              <text class="config-split">|</text>
              <text class="config-text">{{ car.rangeKm }}km</text>
            </view>
          </view>
          <view class="card-bottom">
            <view class="card-price">
              <text class="price-symbol">¥</text>
              <text class="price-num">{{ car.guidePrice }}</text>
              <text class="price-unit">万</text>
              <text class="price-original">¥{{ car.originalPrice }}万</text>
            </view>
            <view class="card-actions">
              <text class="card-delivery">{{ car.deliveryTime }}</text>
              <view class="btn-order" @click.stop="goOrder(car)">立即订购</view>
            </view>
          </view>
        </view>
      </view>
      <view v-if="filteredList.length === 0" class="empty">
        <text class="empty-icon">🚗</text>
        <text class="empty-text">暂无符合条件的二手车</text>
      </view>
    </view>
  </scroll-view>
</template>

<script>
import { getUsedCarList, getUsedCarDetail, getInspectionReport, getVehicleSpecs, getCarReviews } from '@/api/car/car'

export default {
  props: {
    filter: { type: Object, default: () => ({ color: '', model: '', sortDir: null }) }
  },
  emits: ['go-order'],

  data() {
    return {
      carList: []
    }
  },

  created() {
    this.fetchCarList()
  },

  computed: {
    filteredList() {
      let list = [...this.carList]
      if (this.filter.color) {
        list = list.filter(car => car.color === this.filter.color)
      }
      if (this.filter.model) {
        list = list.filter(car => car.description === this.filter.model)
      }
      if (this.filter.sortDir === 'asc') list.sort((a, b) => a.guidePrice - b.guidePrice)
      else if (this.filter.sortDir === 'desc') list.sort((a, b) => b.guidePrice - a.guidePrice)
      return list
    }
  },

  methods: {
    fetchCarList() {
      getUsedCarList().then(res => {
        this.carList = (res.rows || []).map(item => ({
          vehicleId: item.vehicleId,
          modelName: item.modelName,
          title: item.title,
          guidePrice: item.guidePrice,
          originalPrice: item.originalPrice,
          color: item.color || '海湾蓝',
          tags: item.tags || '',
          mileage: item.mileage,
          transferCount: item.transferCount,
          batterySoh: item.batterySoh,
          licenseCity: item.licenseCity || '北京',
          firstLicenseDate: item.licenseYear ? (item.licenseYear + '-' + String(item.licenseMonth || 1).padStart(2, '0')) : '未知',
          image: item.image || '/static/images/car/car1.png',
          typeLabel: '官方认证二手车',
          exteriorHex: item.exteriorHex || '#4A7DB4',
          interiorColor: item.interiorColor || '极夜黑',
          interiorHex: item.interiorHex || '#1a1a1a',
          wheel: item.wheel || '19英寸钻石轮毂',
          rangeKm: item.rangeKm || 700,
          deliveryTime: item.publishTime ? '已发布' : '在售',
          inspectionLevel: 'S级',
          description: item.description || ''
        }))
      }).catch(() => {
        this.carList = []
      })
    },
    goDetail(car) {
      getUsedCarDetail(car.vehicleId).then(res => {
        const detail = res.data || {}
        const modelName = detail.modelName || car.modelName
        getVehicleSpecs(car.vehicleId).then(sres => {
          const spec = sres.data || {}
          getInspectionReport(car.vehicleId).then(ires => {
            const inspection = ires.data || {}
            let msg = `${modelName}\n`
            msg += `首次上牌：${car.firstLicenseDate}\n`
            msg += `里程：${car.mileage}万km | 过户${car.transferCount}次\n`
            if (inspection.batterySoh) msg += `电池健康：${inspection.batterySoh}%\n`
            if (spec.rangeKm) msg += `续航：${spec.rangeKm}km\n`
            if (spec.batteryCapacity) msg += `电池容量：${spec.batteryCapacity}kWh\n`
            msg += `检测评级：${detail.inspectionLevel || 'S级'}`
            uni.showModal({
              title: '二手车详情',
              content: msg,
              showCancel: false
            })
          }).catch(() => {
            uni.showToast({ title: modelName, icon: 'none' })
          })
        }).catch(() => {
          uni.showToast({ title: modelName, icon: 'none' })
        })
      }).catch(() => {
        uni.showToast({ title: car.modelName, icon: 'none' })
      })
    },
    goOrder(car) {
      const m = {
        vehicleId: car.vehicleId,
        modelName: car.modelName,
        guidePrice: car.guidePrice,
        image: car.image,
        typeLabel: car.typeLabel,
        tags: car.tags || '',
        originalPrice: car.originalPrice,
        firstLicenseDate: car.firstLicenseDate,
        mileage: car.mileage,
        transferCount: car.transferCount,
        batterySoh: car.batterySoh || 98,
        inspectionLevel: car.inspectionLevel || 'S级',
        color: car.color,
        exteriorHex: car.exteriorHex,
        interiorColor: car.interiorColor,
        interiorHex: car.interiorHex,
        wheel: car.wheel,
        rangeKm: car.rangeKm,
        deliveryTime: car.deliveryTime,
        licenseCity: car.licenseCity || '北京'
      }
      this.$emit('go-order', m)
    }
  }
}
</script>

<style lang="scss" scoped>
.scroll {
  height: 100%;
}
.car-list {
  padding: 20rpx 24rpx 40rpx;
}
.car-card {
  background: #fff;
  border-radius: 20rpx;
  overflow: hidden;
  margin-bottom: 20rpx;
  box-shadow: 0 2rpx 16rpx rgba(0, 0, 0, 0.04);
}
.card-img-wrap {
  position: relative;
  width: 100%;
  height: 340rpx;
}
.card-img {
  width: 100%;
  height: 100%;
}
.card-badge {
  position: absolute;
  top: 20rpx;
  left: 0;
  padding: 8rpx 24rpx 8rpx 20rpx;
  font-size: 22rpx;
  color: #fff;
  border-radius: 0 28rpx 28rpx 0;
}
.badge-new {
  background: linear-gradient(135deg, #3072f6, #1a4fd0);
}
.badge-used {
  background: linear-gradient(135deg, #f5a623, #e8950e);
}
.card-body {
  padding: 24rpx;
}
.card-top {
  display: flex;
  align-items: center;
  margin-bottom: 16rpx;
}
.card-model {
  font-size: 30rpx;
  font-weight: 600;
  color: #1a1a1a;
  flex: 1;
}
.card-tag {
  padding: 4rpx 16rpx;
  border-radius: 20rpx;
  font-size: 20rpx;
  color: #3072f6;
  background: #f0f6ff;
  border: 1rpx solid #3072f6;
}
.card-info {
  display: flex;
  align-items: center;
  margin-bottom: 12rpx;
}
.card-info-item {
  font-size: 22rpx;
  color: #999;
}
.card-info-split {
  margin: 0 8rpx;
  color: #ddd;
}
.card-config {
  margin-bottom: 16rpx;
}
.config-row {
  display: flex;
  align-items: center;
  margin-bottom: 8rpx;
  flex-wrap: wrap;
}
.config-item {
  display: flex;
  align-items: center;
  margin-right: 24rpx;
}
.color-dot {
  width: 18rpx;
  height: 18rpx;
  border-radius: 50%;
  margin-right: 8rpx;
  border: 1rpx solid rgba(0, 0, 0, 0.08);
}
.config-text {
  font-size: 24rpx;
  color: #666;
}
.config-split {
  margin: 0 12rpx;
  color: #ddd;
}
.card-bottom {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
}
.card-price {
  display: flex;
  align-items: baseline;
}
.price-symbol {
  font-size: 24rpx;
  color: #ff4d4f;
  font-weight: 600;
}
.price-num {
  font-size: 36rpx;
  color: #ff4d4f;
  font-weight: 700;
}
.price-unit {
  font-size: 24rpx;
  color: #ff4d4f;
}
.price-original {
  font-size: 22rpx;
  color: #bbb;
  text-decoration: line-through;
  margin-left: 10rpx;
}
.card-actions {
  display: flex;
  align-items: center;
}
.card-delivery {
  font-size: 22rpx;
  color: #999;
  margin-right: 16rpx;
}
.btn-order {
  padding: 12rpx 32rpx;
  border-radius: 30rpx;
  font-size: 26rpx;
  color: #fff;
  background: linear-gradient(135deg, #3072f6, #1a4fd0);
  font-weight: 500;
}
.empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 120rpx 0;
}
.empty-icon {
  font-size: 80rpx;
  margin-bottom: 20rpx;
}
.empty-text {
  font-size: 28rpx;
  color: #999;
}
</style>