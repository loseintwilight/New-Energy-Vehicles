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
import { getCouponList, receiveCoupon } from '@/api/coupon'

export default {
  data() {
    return {
      activeTab: 'all',
      tabs: [
        { label: '可使用', value: 'all' },
        { label: '已使用', value: 'used' },
        { label: '已过期', value: 'expired' }
      ],
      coupons: [],
      loading: false
    }
  },
  computed: {
    filteredCoupons() {
      if (this.activeTab === 'all') return this.coupons.filter(c => c.status === 'available')
      return this.coupons.filter(c => c.status === this.activeTab)
    }
  },
  onLoad() {
    this.loadCoupons()
  },
  methods: {
    async loadCoupons() {
      this.loading = true
      try {
        const res = await getCouponList()
        const data = res.data || res
        this.coupons = (data.rows || data.list || data || []).map(coupon => this.formatCoupon(coupon))
      } catch (e) {
        console.error('加载优惠券列表失败', e)
      } finally {
        this.loading = false
      }
    },
    formatCoupon(coupon) {
      const statusMap = {
        0: 'available',
        1: 'used',
        2: 'expired'
      }
      return {
        id: coupon.id || coupon.couponId,
        name: coupon.name || coupon.couponName || '',
        scope: coupon.scope || coupon.useScope || '全场通用',
        amount: coupon.amount || coupon.discount || 0,
        condition: coupon.condition || coupon.useCondition || '无门槛',
        validDate: coupon.validDate || coupon.endTime || '',
        status: statusMap[coupon.status] || coupon.status || 'available'
      }
    },
    async handleUse(coupon) {
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