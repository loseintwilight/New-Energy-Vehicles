<template>
  <scroll-view scroll-y class="scroll">
    <view class="car-list">
      <view
        v-for="car in filteredList"
        :key="car.vehicleId"
        class="car-card"
        @click="goDetail(car)"
      >
        <view class="card-img-wrap">
          <image class="card-img" :src="car.image" mode="aspectFill"></image>
          <view class="card-badge badge-new">{{ car.typeLabel }}</view>
        </view>
        <view class="card-body">
          <view class="card-top">
            <text class="card-model">{{ car.modelName }}</text>
            <view class="card-tag" v-if="car.tags">{{ car.tags }}</view>
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
        <text class="empty-text">暂无符合条件的现车</text>
      </view>
    </view>
  </scroll-view>
</template>

<script>
export default {
  props: {
    filter: { type: Number, default: 0 }
  },
  emits: ['go-order'],

  data() {
    return {
      carList: [
        { vehicleId: 'X220516001', modelName: '小米SU7 后驱 标准版', typeLabel: '全新现车', tags: '', image: '/static/images/car/car1.png', color: '海湾蓝', exteriorHex: '#4A7DB4', interiorColor: '极夜黑', interiorHex: '#1a1a1a', wheel: '19英寸钻石轮毂', rangeKm: 700, guidePrice: 21.59, deliveryTime: '7天内提车' },
        { vehicleId: 'X220516002', modelName: '小米SU7 后驱 标准版', typeLabel: '全新现车', tags: '', image: '/static/images/car/car2.png', color: '星环灰', exteriorHex: '#8C8C8C', interiorColor: '银河灰', interiorHex: '#5A5A5A', wheel: '20英寸梅花轮毂', rangeKm: 700, guidePrice: 21.59, deliveryTime: '7天内提车' },
        { vehicleId: 'X220516003', modelName: '小米SU7 后驱 长续航版', typeLabel: '全新现车', tags: '热销', image: '/static/images/car/car3.png', color: '橄榄绿', exteriorHex: '#5C7A4A', interiorColor: '极夜黑', interiorHex: '#1a1a1a', wheel: '20英寸锋刃轮毂', rangeKm: 830, guidePrice: 24.59, deliveryTime: '7天内提车' },
        { vehicleId: 'X220516004', modelName: '小米SU7 四驱 高性能版', typeLabel: '全新现车', tags: '', image: '/static/images/car/car1.png', color: '熔岩橙', exteriorHex: '#D4732A', interiorColor: '珊瑚红', interiorHex: '#B84C4C', wheel: '21英寸运动轮毂', rangeKm: 750, guidePrice: 29.99, deliveryTime: '7天内提车' },
        { vehicleId: 'X220516005', modelName: '小米SU7 四驱 高性能版', typeLabel: '全新现车', tags: '', image: '/static/images/car/car2.png', color: '珍珠白', exteriorHex: '#F0F0F0', interiorColor: '银河灰', interiorHex: '#5A5A5A', wheel: '21英寸双层锻造梅花轮毂', rangeKm: 750, guidePrice: 29.99, deliveryTime: '7天内提车' }
      ]
    }
  },

  computed: {
    filteredList() {
      let list = [...this.carList]
      if (this.filter === 1) list.sort((a, b) => a.guidePrice - b.guidePrice)
      else if (this.filter === 2) list.sort((a, b) => b.guidePrice - a.guidePrice)
      return list
    }
  },

  methods: {
    goDetail(car) {
      uni.showToast({ title: car.modelName, icon: 'none' })
    },
    goOrder(car) {
      const m = {
        vehicleId: car.vehicleId,
        modelName: car.modelName,
        guidePrice: car.guidePrice,
        image: car.image,
        typeLabel: car.typeLabel,
        deliveryTime: car.deliveryTime,
        color: car.color,
        exteriorHex: car.exteriorHex,
        interiorColor: car.interiorColor,
        interiorHex: car.interiorHex,
        wheel: car.wheel,
        rangeKm: car.rangeKm,
        tags: car.tags || ''
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