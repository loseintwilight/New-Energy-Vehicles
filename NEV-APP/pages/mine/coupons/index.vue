<template>
  <view class="page-container">
    <view class="tab-bar">
      <view
        v-for="tab in tabs"
        :key="tab.value"
        class="tab-item"
        :class="{ active: activeTab === tab.value }"
        @click="activeTab = tab.value"
      >
        <text>{{ tab.label }}</text>
        <view v-if="tab.value === activeTab" class="tab-line"></view>
      </view>
    </view>

    <scroll-view scroll-y class="list-scroll">
      <view class="coupon-list" v-if="filteredCoupons.length > 0">
        <view v-for="cp in filteredCoupons" :key="cp.id" class="coupon-card" :class="cp.status === 'expired' ? 'expired' : ''">
          <view class="coupon-left">
            <text class="coupon-amount">
              <text class="cp-unit">¥</text>
              <text class="cp-num">{{ cp.amount }}</text>
            </text>
            <text class="coupon-condition">{{ cp.condition }}</text>
          </view>
          <view class="coupon-right">
            <view class="cp-info">
              <text class="cp-name">{{ cp.name }}</text>
              <text class="cp-scope">{{ cp.scope }}</text>
              <text class="cp-date">{{ cp.validDate }}</text>
            </view>
            <view class="cp-action" v-if="cp.status === 'available'" @click="handleUse(cp)">立即使用</view>
            <view class="cp-action used" v-if="cp.status === 'used'">已使用</view>
            <view class="cp-action expired" v-if="cp.status === 'expired'">已过期</view>
          </view>
        </view>
      </view>

      <view class="empty" v-else>
        <uni-icons type="ticket" size="80" color="#ddd"></uni-icons>
        <text class="empty-text">暂无优惠券</text>
        <text class="empty-sub">去商城逛逛领取优惠券吧</text>
      </view>
    </scroll-view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      activeTab: 'all',
      tabs: [
        { label: '可使用', value: 'all' },
        { label: '已使用', value: 'used' },
        { label: '已过期', value: 'expired' }
      ],
      coupons: [
        {
          id: 1, name: '保养满减券', scope: '适用于常规保养服务', amount: 50,
          condition: '满300元可用', validDate: '2026-06-30 前使用', status: 'available'
        },
        {
          id: 2, name: '空调清洗优惠券', scope: '适用于空调系统清洗', amount: 30,
          condition: '满200元可用', validDate: '2026-07-15 前使用', status: 'available'
        },
        {
          id: 3, name: '新人专享券', scope: '不限服务类型', amount: 100,
          condition: '满500元可用', validDate: '2026-08-01 前使用', status: 'available'
        },
        {
          id: 4, name: '轮胎折扣券', scope: '适用于轮胎更换服务', amount: 80,
          condition: '满1000元可用', validDate: '2026-06-10 前使用', status: 'available'
        },
        {
          id: 5, name: '电池检测券', scope: '适用于电池健康检测', amount: 20,
          condition: '无门槛', validDate: '2026-05-15 前使用', status: 'used'
        },
        {
          id: 6, name: '美容装饰券', scope: '适用于车辆美容装饰', amount: 40,
          condition: '满150元可用', validDate: '2026-04-30 前使用', status: 'expired'
        }
      ]
    }
  },
  computed: {
    filteredCoupons() {
      if (this.activeTab === 'all') return this.coupons.filter(c => c.status === 'available')
      return this.coupons.filter(c => c.status === this.activeTab)
    }
  },
  methods: {
    handleUse(coupon) {
      uni.showToast({ title: '跳转到使用优惠券页面', icon: 'none' })
    }
  }
}
</script>

<style lang="scss" scoped>
page {
  background-color: #f5f6f7;
  min-height: 100vh;
}

.tab-bar {
  display: flex;
  background-color: #fff;
  padding: 0 10rpx;
}

.tab-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 24rpx 0;
  font-size: 28rpx;
  color: #666;
  position: relative;
}

.tab-item.active {
  color: #3c96f3;
  font-weight: 600;
}

.tab-line {
  position: absolute;
  bottom: 0;
  width: 40rpx;
  height: 4rpx;
  background-color: #3c96f3;
  border-radius: 2rpx;
}

.list-scroll {
  height: calc(100vh - 88rpx);
}

.coupon-list {
  padding: 20rpx 30rpx;
}

.coupon-card {
  display: flex;
  background-color: #fff;
  border-radius: 16rpx;
  overflow: hidden;
  margin-bottom: 20rpx;
}

.coupon-card.expired {
  opacity: 0.6;
}

.coupon-left {
  width: 180rpx;
  background: linear-gradient(135deg, #ff6b6b, #ff4757);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 24rpx 0;
  flex-shrink: 0;
}

.coupon-amount {
  color: #fff;
}

.cp-unit {
  font-size: 28rpx;
}

.cp-num {
  font-size: 52rpx;
  font-weight: 700;
}

.coupon-condition {
  font-size: 20rpx;
  color: rgba(255, 255, 255, 0.8);
  margin-top: 6rpx;
}

.coupon-right {
  flex: 1;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 24rpx 24rpx 24rpx 20rpx;
}

.cp-info {
  display: flex;
  flex-direction: column;
  gap: 8rpx;
}

.cp-name {
  font-size: 28rpx;
  font-weight: 500;
  color: #333;
}

.cp-scope {
  font-size: 22rpx;
  color: #999;
}

.cp-date {
  font-size: 20rpx;
  color: #bbb;
}

.cp-action {
  padding: 10rpx 24rpx;
  font-size: 24rpx;
  color: #ff4757;
  border: 1rpx solid #ff4757;
  border-radius: 30rpx;
  flex-shrink: 0;
}

.cp-action.used {
  color: #999;
  border-color: #ddd;
}

.cp-action.expired {
  color: #bbb;
  border-color: #eee;
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
</style>