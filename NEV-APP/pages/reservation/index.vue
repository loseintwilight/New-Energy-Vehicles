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
      <view class="reservation-list" v-if="filteredReservations.length > 0">
        <view v-for="item in filteredReservations" :key="item.id" class="res-card">
          <view class="res-header">
            <view class="res-shop-row">
              <uni-icons type="shop" size="22" color="#3c96f3"></uni-icons>
              <text class="res-shop">{{ item.shopName }}</text>
            </view>
            <view class="res-status" :class="'res-' + item.status">{{ item.statusText }}</view>
          </view>
          <view class="res-body">
            <view class="res-detail">
              <text class="res-service">{{ item.serviceName }}</text>
              <text class="res-time">
                <uni-icons type="calendar" size="20" color="#999"></uni-icons>
                {{ item.reserveDate }} {{ item.reserveTime }}
              </text>
              <text class="res-address">
                <uni-icons type="location" size="20" color="#999"></uni-icons>
                {{ item.address }}
              </text>
            </view>
            <text class="res-price" v-if="item.price">¥{{ item.price }}</text>
          </view>
          <view class="res-footer" v-if="item.status === 'upcoming'">
            <view class="res-btn" @click="handleCancel(item)">取消预约</view>
            <view class="res-btn primary" @click="handleContact(item)">联系商家</view>
          </view>
        </view>
      </view>

      <view class="empty" v-else>
        <uni-icons type="calendar" size="80" color="#ddd"></uni-icons>
        <text class="empty-text">暂无预约记录</text>
      </view>
    </scroll-view>
  </view>
</template>

<script>
import { getReservationList, cancelReservation } from '@/api/reservation'

export default {
  data() {
    return {
      activeTab: 'all',
      tabs: [
        { label: '全部', value: 'all' },
        { label: '即将开始', value: 'upcoming' },
        { label: '已完成', value: 'done' },
        { label: '已取消', value: 'cancelled' }
      ],
      reservations: [],
      loading: false
    }
  },
  computed: {
    filteredReservations() {
      if (this.activeTab === 'all') return this.reservations
      return this.reservations.filter(r => r.status === this.activeTab)
    }
  },
  onLoad() {
    this.loadReservations()
  },
  onShow() {
    this.loadReservations()
  },
  methods: {
    async loadReservations() {
      this.loading = true
      try {
        const res = await getReservationList()
        // 后端返回 {rows: [...]} 或直接数组
        const data = res.data || res
        this.reservations = (data.rows || data.list || data || []).map(item => this.formatReservation(item))
      } catch (e) {
        console.error('加载预约记录失败', e)
      } finally {
        this.loading = false
      }
    },
    formatReservation(item) {
      const statusMap = {
        'upcoming': 'upcoming',
        'pending': 'upcoming',
        0: 'upcoming',
        'done': 'done',
        'completed': 'done',
        1: 'done',
        'cancelled': 'cancelled',
        2: 'cancelled'
      }
      const status = statusMap[item.status] || item.status
      const statusTextMap = {
        'upcoming': '即将开始',
        'done': '已完成',
        'cancelled': '已取消'
      }
      return {
        id: item.id || item.reservationId,
        shopName: item.shopName || item.merchantName || '',
        serviceName: item.serviceName || item.serviceType || '',
        reserveDate: item.reserveDate || item.appointmentDate || '',
        reserveTime: item.reserveTime || item.appointmentTime || '',
        address: item.address || '',
        price: item.price || item.amount || 0,
        status: status,
        statusText: statusTextMap[status] || item.statusText || status
      }
    },
    async handleCancel(item) {
      uni.showModal({
        title: '取消预约',
        content: '确定要取消该预约吗？',
        success: async (res) => {
          if (res.confirm) {
            try {
              await cancelReservation(item.id)
              item.status = 'cancelled'
              item.statusText = '已取消'
              uni.showToast({ title: '预约已取消', icon: 'success' })
            } catch (e) {
              uni.showToast({ title: '取消失败', icon: 'none' })
            }
          }
        }
      })
    },
    handleContact(item) {
      uni.navigateTo({ 
        url: `/pages/mine/contact/index?orderId=${item.id || ''}&type=reservation` 
      })
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

.reservation-list {
  padding: 20rpx 30rpx;
}

.res-card {
  background-color: #fff;
  border-radius: 14rpx;
  padding: 24rpx;
  margin-bottom: 18rpx;
}

.res-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 16rpx;
  border-bottom: 1rpx solid #f5f5f5;
}

.res-shop-row {
  display: flex;
  align-items: center;
  gap: 8rpx;
}

.res-shop {
  font-size: 26rpx;
  color: #333;
  font-weight: 500;
}

.res-status {
  font-size: 22rpx;
  padding: 4rpx 16rpx;
  border-radius: 20rpx;
}

.res-upcoming {
  color: #3c96f3;
  background-color: #e3f2fd;
}

.res-done {
  color: #4caf50;
  background-color: #e8f5e9;
}

.res-cancelled {
  color: #9e9e9e;
  background-color: #f5f5f5;
}

.res-body {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  padding: 16rpx 0;
}

.res-detail {
  display: flex;
  flex-direction: column;
  gap: 10rpx;
}

.res-service {
  font-size: 30rpx;
  font-weight: 500;
  color: #333;
}

.res-time {
  font-size: 24rpx;
  color: #666;
  display: flex;
  align-items: center;
  gap: 4rpx;
}

.res-address {
  font-size: 24rpx;
  color: #999;
  display: flex;
  align-items: center;
  gap: 4rpx;
}

.res-price {
  font-size: 32rpx;
  font-weight: 600;
  color: #ff4757;
  flex-shrink: 0;
}

.res-footer {
  display: flex;
  justify-content: flex-end;
  gap: 16rpx;
  padding-top: 16rpx;
  border-top: 1rpx solid #f5f5f5;
}

.res-btn {
  padding: 10rpx 28rpx;
  font-size: 24rpx;
  color: #666;
  border: 1rpx solid #ddd;
  border-radius: 30rpx;
}

.res-btn.primary {
  color: #fff;
  background-color: #3c96f3;
  border-color: #3c96f3;
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
</style>