<template>
  <view class="page-container">
    <!-- 我的车辆 -->
    <view class="vehicle-section" v-if="myVehicle">
      <view class="vehicle-card">
        <view class="vehicle-img-box">
          <image class="vehicle-img" :src="myVehicle.image" mode="aspectFill"></image>
        </view>
        <view class="vehicle-info">
          <text class="vehicle-name">{{ myVehicle.modelName }}</text>
          <text class="vehicle-desc">{{ myVehicle.plateNumber || '待上牌' }}</text>
          <view class="vehicle-tags">
            <text class="vehicle-tag">{{ myVehicle.color || '—' }}</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 标签栏 -->
    <view class="tab-bar">
      <scroll-view scroll-x class="tab-scroll">
        <view class="tab-inner">
          <view
            v-for="tab in tabs"
            :key="tab.value"
            class="tab-item"
            :class="{ active: activeTab === tab.value }"
            @click="switchTab(tab.value)"
          >
            <text class="tab-text">{{ tab.label }}</text>
            <view v-if="tab.value === activeTab" class="tab-line"></view>
          </view>
        </view>
      </scroll-view>
    </view>

    <!-- 订单列表 -->
    <scroll-view
      scroll-y
      class="order-scroll"
      :style="myVehicle ? 'height: calc(100vh - 460rpx);' : ''"
      @scrolltolower="loadMore"
      refresher-enabled
      :refresher-triggered="refreshing"
      @refresherrefresh="onRefresh"
    >
      <view class="order-list" v-if="orders.length > 0">
        <view
          v-for="order in filteredOrders"
          :key="order.id"
          class="order-card"
          @click="handleDetail(order)"
        >
          <!-- 卡片头部 -->
          <view class="order-header">
            <view class="header-left">
              <view class="biz-tag">{{ order.bizTypeLabel }}</view>
              <text class="order-shop">{{ order.shopName }}</text>
            </view>
            <view class="order-status" :class="'status-' + order.status">
              <view class="status-dot"></view>
              <text>{{ order.statusText }}</text>
            </view>
          </view>

          <!-- 卡片主体 -->
          <view class="order-body">
            <view class="body-main">
              <text class="order-title">{{ order.title }}</text>
              <text class="order-desc">{{ order.desc }}</text>
              <view class="type-info" v-if="order.contactName">
                <text class="info-item">
                  <uni-icons type="person" size="12" color="#3b82f6"></uni-icons>
                  {{ order.contactName }} {{ order.contactPhone }}
                </text>
                <text class="info-item" v-if="order.paymentMethod">
                  <uni-icons type="wallet" size="12" color="#3b82f6"></uni-icons>
                  {{ order.paymentMethod }}
                </text>
              </view>
            </view>
            <view class="body-price">
              <text class="price-symbol">¥</text>
              <text class="price-num">{{ order.totalAmount || 0 }}</text>
            </view>
          </view>

          <!-- 卡片底部 -->
          <view class="order-footer">
            <text class="order-date">{{ order.createTime }}</text>
            <view class="order-actions">
              <view v-if="order.status === 'unpaid'" class="action-btn" @click.stop="handleCancel(order)">
                <text>取消订单</text>
              </view>
              <view v-if="order.status === 'cancelled' || order.status === 'completed'" class="action-btn danger" @click.stop="handleDelete(order)">
                <uni-icons type="trash" size="16" color="#ff4757"></uni-icons>
                <text>删除</text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <!-- 空状态 -->
      <view class="empty-state" v-else>
        <view class="empty-icon-wrap">
          <view class="empty-icon-bg"></view>
          <uni-icons type="cart" size="64" color="#ccc"></uni-icons>
        </view>
        <text class="empty-title">暂无购车记录</text>
        <text class="empty-desc">快去选购心仪的车辆吧</text>
      </view>

      <view class="load-more" v-if="orders.length > 0">
        <text class="load-text">{{ loadText }}</text>
      </view>
    </scroll-view>
  </view>
</template>

<script>
import { getOrderList, cancelOrder, deleteOrder } from '@/api/mine/order'

export default {
  data() {
    return {
      activeTab: 'all',
      tabs: [
        { label: '全部', value: 'all' },
        { label: '待确认', value: 'pending_confirm' },
        { label: '已确认', value: 'confirmed' },
        { label: '服务中', value: 'in_service' },
        { label: '已完成', value: 'completed' },
        { label: '已取消', value: 'cancelled' }
      ],
      orders: [],
      loading: false,
      refreshing: false,
      hasMore: true,
      page: 1
    }
  },
  computed: {
    /** 从已完成的购车订单中提取车辆信息 */
    myVehicle() {
      const completed = this.orders.find(o => o.status === 'completed' && o.modelName)
      if (!completed) return null
      const imageMap = {
        1: '/static/images/car/main/比亚迪汉EV冠军版 .jpg',
        2: '/static/images/car/main/特斯拉Model Y.png',
        3: '/static/images/car/main/蔚来ES6.jpg',
        4: '/static/images/car/main/小鹏p7i.jpeg',
        5: '/static/images/car/main/理想L7.jpg'
      }
      return {
        modelName: completed.modelName || '',
        color: completed.color || '—',
        plateNumber: completed.plateNumber || '',
        image: imageMap[Number(completed.vehicleId)] || '/static/images/car/car1.png'
      }
    },
    filteredOrders() {
      if (this.activeTab === 'all') return this.orders
      return this.orders.filter(o => o.status === this.activeTab)
    },
    loadText() {
      if (this.loading) return '加载中...'
      if (!this.hasMore) return '没有更多了'
      return '上拉加载更多'
    }
  },
  onLoad() {
    this.loadOrders()
  },
  onShow() {
    this.page = 1
    this.hasMore = true
    if (this.orders.length === 0) this.loadOrders()
  },
  methods: {
    switchTab(value) {
      this.activeTab = value
      this.page = 1
      this.hasMore = true
      this.orders = []
      this.loadOrders()
    },
    async onRefresh() {
      this.refreshing = true
      this.page = 1
      this.hasMore = true
      await this.loadOrders()
      this.refreshing = false
    },
    async loadMore() {
      if (this.loading || !this.hasMore) return
      this.page++
      await this.loadOrders(true)
    },
    async loadOrders(append = false) {
      this.loading = true
      try {
        const params = { pageNum: this.page, pageSize: 50 }
        if (this.activeTab !== 'all') {
          params.status = this.activeTab
        }
        const res = await getOrderList(params)
        const data = res.data || res
        let list = []
        if (data.rows) {
          list = data.rows
        } else if (Array.isArray(data)) {
          list = data
        } else if (data.list) {
          list = data.list
        }

        // 只筛选购车类订单（unified）
        list = list.filter(o => o.bizType === 'unified').map(o => this.formatOrder(o))

        if (append) {
          this.orders = [...this.orders, ...list]
        } else {
          this.orders = list
        }
        this.hasMore = list.length >= 50
      } catch (e) {
        console.error('加载购车记录失败', e)
        if (!append) this.orders = []
      } finally {
        this.loading = false
      }
    },
    formatOrder(order) {
      return {
        id: order.orderId || order.id,
        orderNo: order.orderNo || '',
        bizType: order.bizType || 'unified',
        bizTypeLabel: order.bizTypeLabel || '购车',
        status: order.status || 'pending_confirm',
        statusText: order.statusText || '处理中',
        shopName: order.shopName || '官方店铺',
        title: order.title || '购车订单',
        desc: order.desc || '',
        totalAmount: order.totalAmount || 0,
        createTime: order.createTime || '',
        contactName: order.contactName,
        contactPhone: order.contactPhone,
        paymentMethod: order.paymentMethod,
        modelName: order.modelName || order.title || '',
        color: order.color || '',
        vehicleId: order.vehicleId,
        plateNumber: order.plateNumber || ''
      }
    },
    handleDetail(order) {
      uni.navigateTo({ url: `/pages/mine/orders/detail?id=${order.id}&bizType=${order.bizType}` })
    },
    async handleCancel(order) {
      uni.showModal({
        title: '取消订单',
        content: '确定要取消该订单吗？',
        success: async (res) => {
          if (res.confirm) {
            try {
              await cancelOrder(order.id)
              order.status = 'cancelled'
              order.statusText = '已取消'
              uni.showToast({ title: '订单已取消', icon: 'success' })
            } catch (e) {
              uni.showToast({ title: '取消失败', icon: 'none' })
            }
          }
        }
      })
    },
    async handleDelete(order) {
      uni.showModal({
        title: '删除订单',
        content: '确定要删除该订单吗？',
        success: async (res) => {
          if (res.confirm) {
            try {
              await deleteOrder(order.id)
              const idx = this.orders.findIndex(o => o.id === order.id)
              if (idx > -1) this.orders.splice(idx, 1)
              uni.showToast({ title: '删除成功', icon: 'success' })
            } catch (e) {
              uni.showToast({ title: '删除失败', icon: 'none' })
            }
          }
        }
      })
    }
  }
}
</script>

<style scoped>
page {
  background-color: #f5f6f7;
  min-height: 100vh;
}

.tab-bar {
  background-color: #fff;
  padding: 10rpx 0;
  position: sticky;
  top: 0;
  z-index: 10;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.03);
}
.tab-scroll { white-space: nowrap; }
.tab-inner { display: inline-flex; padding: 0 20rpx; }
.tab-item {
  display: flex; flex-direction: column; align-items: center;
  padding: 16rpx 32rpx; position: relative;
}
.tab-text { font-size: 28rpx; color: #666; transition: all 0.3s; }
.tab-item.active .tab-text { color: #2563eb; font-weight: 600; }
.tab-line {
  position: absolute; bottom: 0; width: 32rpx; height: 6rpx;
  background: linear-gradient(90deg, #2563eb 0%, #3b82f6 100%);
  border-radius: 3rpx;
}

.order-scroll {
  height: calc(100vh - 180rpx);
}
.order-list { padding: 20rpx 24rpx; }

.order-card {
  background-color: #fff; border-radius: 20rpx; margin-bottom: 24rpx;
  overflow: hidden; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04);
  position: relative;
}
.order-card::before {
  content: ''; position: absolute; left: 0; top: 0;
  width: 6rpx; height: 100%;
  background: linear-gradient(180deg, #3b82f6, #60a5fa);
  border-radius: 3rpx 0 0 3rpx;
}

.order-header {
  display: flex; justify-content: space-between; align-items: center;
  padding: 24rpx 24rpx 16rpx;
}
.header-left { display: flex; align-items: center; gap: 12rpx; flex: 1; min-width: 0; }
.biz-tag {
  padding: 4rpx 14rpx; border-radius: 20rpx; font-size: 20rpx; font-weight: 500;
  color: #fff; flex-shrink: 0;
  background: linear-gradient(135deg, #3b82f6, #60a5fa);
}
.order-shop { font-size: 26rpx; color: #333; font-weight: 500; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }

.order-status {
  display: flex; align-items: center; gap: 6rpx;
  padding: 6rpx 18rpx; border-radius: 24rpx; font-size: 22rpx; font-weight: 500;
  flex-shrink: 0; color: #fff;
}
.status-dot { width: 10rpx; height: 10rpx; border-radius: 50%; background-color: rgba(255,255,255,0.9); }
.status-pending_confirm { background: linear-gradient(135deg, #ff6b35, #f7931e); }
.status-confirmed { background: linear-gradient(135deg, #2563eb, #3b82f6); }
.status-in_service { background: linear-gradient(135deg, #00bcd4, #26c6da); }
.status-completed { background: linear-gradient(135deg, #10b981, #34d399); }
.status-cancelled { background: linear-gradient(135deg, #9ca3af, #b0b8c4); }

.order-body { display: flex; padding: 0 24rpx 16rpx; gap: 20rpx; }
.body-main { flex: 1; min-width: 0; }
.order-title { font-size: 28rpx; font-weight: 500; color: #333; display: -webkit-box; -webkit-line-clamp: 1; -webkit-box-orient: vertical; overflow: hidden; }
.order-desc { font-size: 24rpx; color: #999; margin-top: 4rpx; }
.type-info { display: flex; flex-wrap: wrap; gap: 12rpx; margin-top: 12rpx; }
.info-item {
  font-size: 22rpx; color: #888; display: flex; align-items: center; gap: 4rpx;
  background-color: #f8f9fa; padding: 4rpx 12rpx; border-radius: 12rpx;
}
.body-price { display: flex; align-items: baseline; flex-shrink: 0; padding-top: 4rpx; }
.price-symbol { font-size: 24rpx; color: #ff4757; font-weight: 500; }
.price-num { font-size: 32rpx; color: #ff4757; font-weight: 700; }

.order-footer {
  display: flex; justify-content: space-between; align-items: center;
  padding: 16rpx 24rpx; border-top: 1rpx solid #f5f5f5; background-color: #fafafa;
}
.order-date { font-size: 22rpx; color: #bbb; display: flex; align-items: center; gap: 6rpx; }
.order-actions { display: flex; gap: 16rpx; }
.action-btn {
  display: flex; align-items: center; gap: 6rpx; padding: 14rpx 24rpx;
  font-size: 24rpx; color: #666; background-color: #fff;
  border: 1rpx solid #e5e5e5; border-radius: 32rpx; transition: all 0.3s;
}
.action-btn:active { transform: scale(0.96); }
.action-btn.danger { color: #ff4757; border-color: #ff4757; background-color: #fff; }

.empty-state {
  display: flex; flex-direction: column; align-items: center;
  padding: 120rpx 40rpx;
}
.empty-icon-wrap { position: relative; width: 160rpx; height: 160rpx; display: flex; align-items: center; justify-content: center; }
.empty-icon-bg { position: absolute; width: 120rpx; height: 120rpx; background-color: #f5f5f5; border-radius: 50%; }
.empty-title { font-size: 30rpx; color: #666; font-weight: 500; margin-top: 32rpx; }
.empty-desc { font-size: 26rpx; color: #999; margin-top: 12rpx; }
.load-more { padding: 30rpx; text-align: center; }
.load-text { font-size: 24rpx; color: #999; }

/* ==================== 我的车辆卡片 ==================== */
.vehicle-section {
  padding: 20rpx 24rpx 0;
}
.vehicle-card {
  display: flex;
  background: #fff;
  border-radius: 20rpx;
  padding: 24rpx;
  box-shadow: 0 4rpx 20rpx rgba(0,0,0,0.06);
  gap: 20rpx;
  margin-bottom: 20rpx;
}
.vehicle-img-box {
  width: 180rpx;
  height: 130rpx;
  border-radius: 14rpx;
  overflow: hidden;
  flex-shrink: 0;
  background: #f5f5f5;
}
.vehicle-img {
  width: 100%;
  height: 100%;
}
.vehicle-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
}
.vehicle-name {
  font-size: 30rpx;
  font-weight: 700;
  color: #1a1a1a;
}
.vehicle-desc {
  font-size: 24rpx;
  color: #999;
  margin-top: 6rpx;
}
.vehicle-tags {
  display: flex;
  gap: 10rpx;
  margin-top: 12rpx;
}
.vehicle-tag {
  padding: 4rpx 16rpx;
  background: #f0f6ff;
  border-radius: 12rpx;
  font-size: 22rpx;
  color: #3b82f6;
}
</style>
