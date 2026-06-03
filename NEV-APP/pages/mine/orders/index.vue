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

    <scroll-view scroll-y class="order-scroll">
      <view class="order-list" v-if="filteredOrders.length > 0">
        <view v-for="order in filteredOrders" :key="order.id" class="order-card">
          <view class="order-header">
            <text class="order-shop">{{ order.shopName }}</text>
            <view class="order-status" :class="'status-' + order.status">
              {{ order.statusText }}
            </view>
          </view>
          <view class="order-body" @click="handleOrderDetail(order)">
            <image class="order-image" :src="order.image" mode="aspectFill"></image>
            <view class="order-info">
              <text class="order-title">{{ order.title }}</text>
              <text class="order-desc">{{ order.desc }}</text>
              <text class="order-date">{{ order.createTime }}</text>
            </view>
            <view class="order-price">
              <text class="price-num">¥{{ order.price }}</text>
              <text class="price-count">×{{ order.count }}</text>
            </view>
          </view>
          <view class="order-footer">
            <text class="order-total">合计：<text class="total-price">¥{{ order.total }}</text></text>
            <view class="order-actions">
              <view v-if="order.status === 'unpaid'" class="action-btn primary" @click="handlePay(order)">立即支付</view>
              <view v-if="order.status === 'unpaid'" class="action-btn" @click="handleCancel(order)">取消订单</view>
              <view v-if="order.status === 'pending'" class="action-btn primary" @click="handleContact(order)">联系商家</view>
              <view v-if="order.status === 'completed'" class="action-btn" @click="handleComment(order)">评价</view>
              <view v-if="order.status === 'completed'" class="action-btn primary" @click="handleRebuy(order)">再次购买</view>
            </view>
          </view>
        </view>
      </view>

      <view class="empty" v-else>
        <uni-icons type="list" size="80" color="#ddd"></uni-icons>
        <text class="empty-text">暂无相关订单</text>
        <text class="empty-sub">去看看有什么好买的吧</text>
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
        { label: '待支付', value: 'unpaid' },
        { label: '待服务', value: 'pending' },
        { label: '已完成', value: 'completed' },
        { label: '已取消', value: 'cancelled' }
      ],
      orders: [
        {
          id: 1, shopName: '济南鑫维保-经十西路店', status: 'unpaid', statusText: '待支付',
          image: '/static/images/service/service_header1.png', title: '常规保养服务', desc: '更换机油、机滤、空滤等',
          createTime: '2026-06-02 10:30', price: 299, count: 1, total: 299
        },
        {
          id: 2, shopName: '济南鑫维保-工业北路店', status: 'pending', statusText: '待服务',
          image: '/static/images/service/service_header2.png', title: '电池检测 + 空调清洗', desc: '电池健康度全面检测及空调深度清洗',
          createTime: '2026-06-01 14:20', price: 367, count: 1, total: 367
        },
        {
          id: 3, shopName: '旗舰维保中心', status: 'completed', statusText: '已完成',
          image: '/static/images/service/service_header3.png', title: '轮胎更换', desc: '四条轮胎磨损检测及更换',
          createTime: '2026-05-28 09:15', price: 2320, count: 1, total: 2320
        },
        {
          id: 4, shopName: '新城服务站', status: 'completed', statusText: '已完成',
          image: '/static/images/service/service_header1.png', title: '钣金喷漆', desc: '车身左侧划痕修复喷漆',
          createTime: '2026-05-20 16:00', price: 350, count: 1, total: 350
        },
        {
          id: 5, shopName: '济南鑫维保-经十西路店', status: 'cancelled', statusText: '已取消',
          image: '/static/images/service/service_header2.png', title: '美容装饰', desc: '车辆内外精洗美容',
          createTime: '2026-05-18 11:45', price: 128, count: 1, total: 128
        }
      ]
    }
  },
  computed: {
    filteredOrders() {
      if (this.activeTab === 'all') return this.orders
      return this.orders.filter(o => o.status === this.activeTab)
    }
  },
  onLoad(options) {
    if (options.tab) {
      this.activeTab = options.tab
    }
    this.syncOrderStatus()
  },
  methods: {
    syncOrderStatus() {
      const app = getApp()
      app.globalData.orderStatus = {
        unpaid: this.orders.filter(o => o.status === 'unpaid').length,
        pending: this.orders.filter(o => o.status === 'pending').length,
        completed: this.orders.filter(o => o.status === 'completed').length,
        cancelled: this.orders.filter(o => o.status === 'cancelled').length
      }
    },
    handleOrderDetail(order) {
      uni.showToast({ title: '查看订单详情：' + order.title, icon: 'none' })
    },
    handlePay(order) {
      uni.showModal({
        title: '确认支付',
        content: '确认支付 ¥' + order.total + '？',
        success: (res) => {
          if (res.confirm) {
            order.status = 'pending'
            order.statusText = '待服务'
            this.syncOrderStatus()
            uni.showToast({ title: '支付成功', icon: 'success' })
          }
        }
      })
    },
    handleCancel(order) {
      uni.showModal({
        title: '取消订单',
        content: '确定要取消该订单吗？',
        success: (res) => {
          if (res.confirm) {
            order.status = 'cancelled'
            order.statusText = '已取消'
            this.syncOrderStatus()
            uni.showToast({ title: '订单已取消', icon: 'success' })
          }
        }
      })
    },
    handleContact(order) {
      uni.showToast({ title: '正在联系 ' + order.shopName, icon: 'none' })
    },
    handleComment(order) {
      uni.showToast({ title: '评价功能开发中', icon: 'none' })
    },
    handleRebuy(order) {
      uni.showToast({ title: '已加入购物车', icon: 'success' })
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
  position: sticky;
  top: 0;
  z-index: 10;
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

.order-scroll {
  height: calc(100vh - 88rpx);
}

.order-list {
  padding: 20rpx 30rpx;
}

.order-card {
  background-color: #fff;
  border-radius: 16rpx;
  padding: 24rpx;
  margin-bottom: 20rpx;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.04);
}

.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 20rpx;
  border-bottom: 1rpx solid #f5f5f5;
}

.order-shop {
  font-size: 26rpx;
  color: #333;
  font-weight: 500;
}

.order-status {
  font-size: 24rpx;
  padding: 4rpx 16rpx;
  border-radius: 20rpx;
}

.status-unpaid {
  color: #ff9800;
  background-color: #fff3e0;
}

.status-pending {
  color: #2196f3;
  background-color: #e3f2fd;
}

.status-completed {
  color: #4caf50;
  background-color: #e8f5e9;
}

.status-cancelled {
  color: #9e9e9e;
  background-color: #f5f5f5;
}

.order-body {
  display: flex;
  padding: 20rpx 0;
}

.order-image {
  width: 140rpx;
  height: 140rpx;
  border-radius: 12rpx;
  flex-shrink: 0;
}

.order-info {
  flex: 1;
  margin-left: 20rpx;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.order-title {
  font-size: 28rpx;
  font-weight: 500;
  color: #333;
}

.order-desc {
  font-size: 24rpx;
  color: #999;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.order-date {
  font-size: 22rpx;
  color: #bbb;
}

.order-price {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  justify-content: space-between;
  flex-shrink: 0;
}

.price-num {
  font-size: 28rpx;
  color: #333;
  font-weight: 500;
}

.price-count {
  font-size: 22rpx;
  color: #999;
}

.order-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 20rpx;
  border-top: 1rpx solid #f5f5f5;
}

.order-total {
  font-size: 24rpx;
  color: #666;
}

.total-price {
  font-size: 30rpx;
  font-weight: 600;
  color: #ff4757;
}

.order-actions {
  display: flex;
  gap: 16rpx;
}

.action-btn {
  padding: 10rpx 28rpx;
  font-size: 24rpx;
  color: #666;
  border: 1rpx solid #ddd;
  border-radius: 30rpx;
}

.action-btn.primary {
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

.empty-sub {
  font-size: 24rpx;
  color: #bbb;
  margin-top: 8rpx;
}
</style>