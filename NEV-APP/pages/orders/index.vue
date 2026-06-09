<template>
  <view class="page-container">
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
      @scrolltolower="loadMore"
      refresher-enabled
      :refresher-triggered="refreshing"
      @refresherrefresh="onRefresh"
    >
      <view class="order-list" v-if="filteredOrders.length > 0">
        <view v-for="order in filteredOrders" :key="order.id" class="order-card">
          <!-- 卡片头部 -->
          <view class="order-header">
            <view class="shop-info">
              <view class="shop-icon">
                <uni-icons type="shop" size="20" color="#666"></uni-icons>
              </view>
              <text class="order-shop">{{ order.shopName }}</text>
            </view>
            <view class="order-status" :class="'status-' + order.status">
              <view class="status-dot"></view>
              <text>{{ order.statusText }}</text>
            </view>
          </view>

          <!-- 商品信息 -->
          <view class="order-body" @click="handleOrderDetail(order)">
            <view class="goods-image-wrap">
              <image class="order-image" :src="order.image" mode="aspectFill"></image>
              <view class="goods-count-badge" v-if="order.count > 1">×{{ order.count }}</view>
            </view>
            <view class="order-info">
              <text class="order-title">{{ order.title }}</text>
              <text class="order-desc" v-if="order.desc">{{ order.desc }}</text>
              <view class="order-meta">
                <text class="order-date">
                  <uni-icons type="calendar" size="14" color="#bbb"></uni-icons>
                  {{ order.createTime }}
                </text>
              </view>
            </view>
            <view class="order-price">
              <text class="price-symbol">¥</text>
              <text class="price-num">{{ order.price }}</text>
            </view>
          </view>

          <!-- 卡片底部 -->
          <view class="order-footer">
            <view class="order-total-wrap">
              <text class="total-label">共{{ order.count }}件 合计</text>
              <view class="total-value">
                <text class="total-symbol">¥</text>
                <text class="total-price">{{ order.total }}</text>
              </view>
            </view>
            <view class="order-actions">
              <view v-if="order.status === 'unpaid'" class="action-btn primary" @click="handlePay(order)">
                <uni-icons type="wallet" size="16" color="#fff"></uni-icons>
                <text>立即支付</text>
              </view>
              <view v-if="order.status === 'unpaid'" class="action-btn" @click="handleCancel(order)">
                <text>取消订单</text>
              </view>
              <view v-if="order.status === 'pending'" class="action-btn primary" @click="handleContact(order)">
                <uni-icons type="phone" size="16" color="#fff"></uni-icons>
                <text>联系商家</text>
              </view>
              <view v-if="order.status === 'completed'" class="action-btn" @click="handleComment(order)">
                <uni-icons type="star" size="16" color="#666"></uni-icons>
                <text>评价</text>
              </view>
              <view v-if="order.status === 'completed'" class="action-btn primary" @click="handleRebuy(order)">
                <text>再次购买</text>
              </view>
              <view v-if="order.status === 'cancelled' || order.status === 'completed'" class="action-btn danger" @click="handleDelete(order)">
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
          <uni-icons type="list" size="64" color="#ccc"></uni-icons>
        </view>
        <text class="empty-title">暂无相关订单</text>
        <text class="empty-desc">快去选购心仪的商品吧</text>
        <view class="empty-btn" @click="goHome">去逛逛</view>
      </view>

      <!-- 加载更多 -->
      <view class="load-more" v-if="filteredOrders.length > 0">
        <text class="load-text">{{ loadText }}</text>
      </view>
    </scroll-view>
  </view>
</template>

<script>
import { getOrderList, cancelOrder, deleteOrder } from '@/api/order'

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
      orders: [],
      loading: false,
      refreshing: false,
      hasMore: true,
      page: 1
    }
  },
  computed: {
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
  onLoad(options) {
    if (options.tab) {
      this.activeTab = options.tab
    }
    this.loadOrders()
  },
  onShow() {
    this.loadOrders()
  },
  methods: {
    goHome() {
      uni.switchTab({ url: '/pages/index' })
    },
    switchTab(value) {
      this.activeTab = value
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
        const res = await getOrderList({ 
          status: this.activeTab === 'all' ? undefined : this.activeTab,
          pageNum: this.page
        })
        const data = res.data || res
        let list = []
        if (data.rows || Array.isArray(data)) {
          list = (data.rows || data).map(order => this.formatOrder(order))
        } else if (data.list || Array.isArray(data)) {
          list = (data.list || data).map(order => this.formatOrder(order))
        }
        
        if (append) {
          this.orders = [...this.orders, ...list]
        } else {
          this.orders = list
        }
        
        this.hasMore = list.length >= 10
      } catch (e) {
        console.error('加载订单列表失败', e)
        if (!append) this.orders = []
      } finally {
        this.loading = false
      }
    },
    formatOrder(order) {
      const statusMap = {
        0: 'unpaid',
        1: 'pending',
        2: 'completed',
        3: 'cancelled'
      }
      const statusTextMap = {
        unpaid: '待支付',
        pending: '待服务',
        completed: '已完成',
        cancelled: '已取消'
      }
      return {
        id: order.id || order.orderId,
        shopName: order.shopName || order.merchantName || '官方店铺',
        status: statusMap[order.status] || order.status || 'pending',
        statusText: statusTextMap[statusMap[order.status]] || order.statusText || '处理中',
        image: order.image || order.goodsImage || '/static/images/service/service_header1.png',
        title: order.title || order.goodsName || '商品',
        desc: order.desc || order.goodsDesc || '',
        createTime: order.createTime || order.createTimeStr || '',
        price: order.price || order.unitPrice || 0,
        count: order.count || order.quantity || 1,
        total: order.total || order.totalAmount || 0
      }
    },
    syncOrderStatus() {
      const app = getApp()
      if (app && app.globalData) {
        app.globalData.orderStatus = {
          unpaid: this.orders.filter(o => o.status === 'unpaid').length,
          pending: this.orders.filter(o => o.status === 'pending').length,
          completed: this.orders.filter(o => o.status === 'completed').length,
          cancelled: this.orders.filter(o => o.status === 'cancelled').length
        }
      }
    },
    handleOrderDetail(order) {
      uni.navigateTo({ url: `/pages/mine/orders/detail?id=${order.id}` })
    },
    async handlePay(order) {
      uni.showModal({
        title: '确认支付',
        content: '确认支付 ¥' + order.total + '？',
        success: async (res) => {
          if (res.confirm) {
            uni.showToast({ title: '支付功能开发中', icon: 'none' })
          }
        }
      })
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
              this.syncOrderStatus()
              uni.showToast({ title: '订单已取消', icon: 'success' })
            } catch (e) {
              uni.showToast({ title: '取消失败', icon: 'none' })
            }
          }
        }
      })
    },
    handleContact(order) {
      uni.navigateTo({ 
        url: `/pages/mine/contact/index?orderId=${order.id}&shopName=${encodeURIComponent(order.shopName)}` 
      })
    },
    handleComment(order) {
      uni.showToast({ title: '评价功能开发中', icon: 'none' })
    },
    handleRebuy(order) {
      uni.showToast({ title: '已加入购物车', icon: 'success' })
    },
    async handleDelete(order) {
      uni.showModal({
        title: '删除订单',
        content: '确定要删除该订单吗？删除后将无法恢复。',
        success: async (res) => {
          if (res.confirm) {
            try {
              await deleteOrder(order.id)
              const index = this.orders.findIndex(o => o.id === order.id)
              if (index > -1) {
                this.orders.splice(index, 1)
                this.syncOrderStatus()
              }
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

<style lang="scss" scoped>
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

.tab-scroll {
  white-space: nowrap;
}

.tab-inner {
  display: inline-flex;
  padding: 0 20rpx;
}

.tab-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 16rpx 32rpx;
  position: relative;
}

.tab-text {
  font-size: 28rpx;
  color: #666;
  transition: all 0.3s;
}

.tab-item.active .tab-text {
  color: #2563eb;
  font-weight: 600;
}

.tab-line {
  position: absolute;
  bottom: 0;
  width: 32rpx;
  height: 6rpx;
  background: linear-gradient(90deg, #2563eb 0%, #3b82f6 100%);
  border-radius: 3rpx;
}

.order-scroll {
  height: calc(100vh - 180rpx);
}

.order-list {
  padding: 20rpx 24rpx;
}

.order-card {
  background-color: #fff;
  border-radius: 20rpx;
  margin-bottom: 24rpx;
  overflow: hidden;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.04);
}

.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 24rpx 24rpx 16rpx;
  background: linear-gradient(180deg, #fafafa 0%, #fff 100%);
}

.shop-info {
  display: flex;
  align-items: center;
  gap: 8rpx;
}

.shop-icon {
  width: 40rpx;
  height: 40rpx;
  background-color: #f0f0f0;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.order-shop {
  font-size: 26rpx;
  color: #333;
  font-weight: 500;
}

.order-status {
  display: flex;
  align-items: center;
  gap: 8rpx;
  font-size: 24rpx;
  padding: 8rpx 20rpx;
  border-radius: 24rpx;
}

.status-dot {
  width: 8rpx;
  height: 8rpx;
  border-radius: 50%;
}

.status-unpaid {
  color: #ff6b35;
  background-color: #fff5f0;
  .status-dot { background-color: #ff6b35; }
}

.status-pending {
  color: #2563eb;
  background-color: #eff6ff;
  .status-dot { background-color: #2563eb; }
}

.status-completed {
  color: #10b981;
  background-color: #ecfdf5;
  .status-dot { background-color: #10b981; }
}

.status-cancelled {
  color: #9ca3af;
  background-color: #f5f5f5;
  .status-dot { background-color: #9ca3af; }
}

.order-body {
  display: flex;
  padding: 20rpx 24rpx;
  gap: 20rpx;
}

.goods-image-wrap {
  position: relative;
  flex-shrink: 0;
}

.order-image {
  width: 160rpx;
  height: 160rpx;
  border-radius: 16rpx;
}

.goods-count-badge {
  position: absolute;
  right: -8rpx;
  bottom: -8rpx;
  background-color: #ff4757;
  color: #fff;
  font-size: 20rpx;
  padding: 4rpx 12rpx;
  border-radius: 16rpx;
}

.order-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  min-width: 0;
}

.order-title {
  font-size: 28rpx;
  font-weight: 500;
  color: #333;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.order-desc {
  font-size: 24rpx;
  color: #999;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  margin-top: 8rpx;
}

.order-meta {
  margin-top: 12rpx;
}

.order-date {
  font-size: 22rpx;
  color: #bbb;
  display: flex;
  align-items: center;
  gap: 6rpx;
}

.order-price {
  display: flex;
  align-items: baseline;
  flex-shrink: 0;
}

.price-symbol {
  font-size: 24rpx;
  color: #333;
  font-weight: 500;
}

.price-num {
  font-size: 32rpx;
  color: #333;
  font-weight: 600;
}

.order-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx 24rpx;
  border-top: 1rpx solid #f5f5f5;
  background-color: #fafafa;
}

.order-total-wrap {
  display: flex;
  flex-direction: column;
  gap: 4rpx;
}

.total-label {
  font-size: 22rpx;
  color: #999;
}

.total-value {
  display: flex;
  align-items: baseline;
}

.total-symbol {
  font-size: 24rpx;
  color: #ff4757;
  font-weight: 500;
}

.total-price {
  font-size: 32rpx;
  font-weight: 700;
  color: #ff4757;
}

.order-actions {
  display: flex;
  gap: 16rpx;
}

.action-btn {
  display: flex;
  align-items: center;
  gap: 6rpx;
  padding: 14rpx 24rpx;
  font-size: 24rpx;
  color: #666;
  background-color: #fff;
  border: 1rpx solid #e5e5e5;
  border-radius: 32rpx;
  transition: all 0.3s;
}

.action-btn:active {
  transform: scale(0.96);
}

.action-btn.primary {
  color: #fff;
  background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
  border: none;
  box-shadow: 0 4rpx 12rpx rgba(37, 99, 235, 0.3);
}

.action-btn.danger {
  color: #ff4757;
  border-color: #ff4757;
  background-color: #fff;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 120rpx 40rpx;
}

.empty-icon-wrap {
  position: relative;
  width: 160rpx;
  height: 160rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.empty-icon-bg {
  position: absolute;
  width: 120rpx;
  height: 120rpx;
  background-color: #f5f5f5;
  border-radius: 50%;
}

.empty-title {
  font-size: 30rpx;
  color: #666;
  font-weight: 500;
  margin-top: 32rpx;
}

.empty-desc {
  font-size: 26rpx;
  color: #999;
  margin-top: 12rpx;
}

.empty-btn {
  margin-top: 40rpx;
  padding: 20rpx 60rpx;
  background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
  color: #fff;
  border-radius: 40rpx;
  font-size: 28rpx;
  box-shadow: 0 4rpx 16rpx rgba(37, 99, 235, 0.3);
}

.load-more {
  padding: 30rpx;
  text-align: center;
}

.load-text {
  font-size: 24rpx;
  color: #999;
}
</style>