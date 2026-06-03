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
      reservations: [
        {
          id: 1, shopName: '济南鑫维保-经十西路店', serviceName: '常规保养服务',
          reserveDate: '2026-06-05', reserveTime: '09:00-11:00',
          address: '济南市槐荫区经十西路288号', price: 299, status: 'upcoming', statusText: '即将开始'
        },
        {
          id: 2, shopName: '旗舰维保中心', serviceName: '电池健康度检测',
          reserveDate: '2026-06-08', reserveTime: '14:00-15:00',
          address: '济南市历下区经十路100号', price: 99, status: 'upcoming', statusText: '即将开始'
        },
        {
          id: 3, shopName: '济南鑫维保-工业北路店', serviceName: '空调系统清洗',
          reserveDate: '2026-05-25', reserveTime: '10:00-11:30',
          address: '济南市历城区工业北路168号', price: 268, status: 'done', statusText: '已完成'
        },
        {
          id: 4, shopName: '新城服务站', serviceName: '钣金喷漆',
          reserveDate: '2026-05-18', reserveTime: '08:30-17:00',
          address: '济南市天桥区无影山路56号', price: 350, status: 'done', statusText: '已完成'
        },
        {
          id: 5, shopName: '济南鑫维保-经十西路店', serviceName: '美容装饰',
          reserveDate: '2026-05-10', reserveTime: '13:00-15:00',
          address: '济南市槐荫区经十西路288号', price: 128, status: 'cancelled', statusText: '已取消'
        }
      ]
    }
  },
  computed: {
    filteredReservations() {
      if (this.activeTab === 'all') return this.reservations
      return this.reservations.filter(r => r.status === this.activeTab)
    }
  },
  methods: {
    handleCancel(item) {
      uni.showModal({
        title: '取消预约',
        content: '确定要取消该预约吗？',
        success: (res) => {
          if (res.confirm) {
            item.status = 'cancelled'
            item.statusText = '已取消'
            uni.showToast({ title: '预约已取消', icon: 'success' })
          }
        }
      })
    },
    handleContact(item) {
      uni.showToast({ title: '正在联系 ' + item.shopName, icon: 'none' })
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