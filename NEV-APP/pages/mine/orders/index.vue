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
        <view 
          v-for="order in filteredOrders" 
          :key="order.id" 
          class="order-card"
          :class="'card-' + order.bizType"
          @click="handleOrderDetail(order)"
        >
          <!-- ======== 卡片头部：类型标签 + 商家 + 状态 ======== -->
          <view class="order-header">
            <view class="header-left">
              <!-- 业务类型彩色标签 -->
              <view class="biz-type-tag" :class="'tag-' + order.bizType">
                <uni-icons :type="order.typeIcon" size="12" color="#fff"></uni-icons>
                <text>{{ order.bizTypeLabel }}</text>
              </view>
              <text class="order-shop">{{ order.shopName }}</text>
            </view>
            <view class="order-status" :class="'status-' + order.status">
              <view class="status-dot"></view>
              <text>{{ order.statusText }}</text>
            </view>
          </view>

          <!-- ======== 卡片主体 ======== -->
          <view class="order-body">
            <!-- 主内容 -->
            <view class="body-main">
              <text class="order-title">{{ order.title }}</text>
              <text class="order-desc">{{ order.desc }}</text>
              
              <!-- 类型专属信息 -->
              <view class="type-info" v-if="order.bizType === 'charging'">
                <text class="info-item" v-if="order.totalEnergy">
                  <uni-icons type="circle" size="12" color="#10b981"></uni-icons>
                  充电 {{ order.totalEnergy }} kWh
                </text>
                <text class="info-item" v-if="order.durationText">
                  <uni-icons type="clock" size="12" color="#10b981"></uni-icons>
                  时长 {{ order.durationText }}
                </text>
                <text class="info-item" v-if="order.carbonEarned > 0">
                  <uni-icons type="star" size="12" color="#10b981"></uni-icons>
                  +{{ order.carbonEarned }}碳积分
                </text>
              </view>
              <view class="type-info" v-if="order.bizType === 'maintenance'">
                <text class="info-item" v-if="order.expectDate">
                  <uni-icons type="calendar" size="12" color="#f59e0b"></uni-icons>
                  预约 {{ order.expectDate }} {{ order.expectTimeSlot === 'am' ? '上午' : '下午' }}
                </text>
                <text class="info-item" v-if="order.shopAddress">
                  <uni-icons type="location" size="12" color="#f59e0b"></uni-icons>
                  {{ order.shopAddress }}
                </text>
              </view>
              <view class="type-info" v-if="order.bizType === 'unified' && order.unifiedType !== 'trade_in'">
                <text class="info-item" v-if="order.contactName">
                  <uni-icons type="person" size="12" color="#3b82f6"></uni-icons>
                  {{ order.contactName }} {{ order.contactPhone }}
                </text>
                <text class="info-item" v-if="order.paymentMethod">
                  <uni-icons type="wallet" size="12" color="#3b82f6"></uni-icons>
                  {{ order.paymentMethod }}
                </text>
              </view>
              <!-- 以旧换新专属信息 -->
              <view class="type-info tradein-info" v-if="order.bizType === 'unified' && order.unifiedType === 'trade_in'">
                <text class="info-item" v-if="order.oldVehicleBrand || order.oldVehicleModel">
                  <uni-icons type="loop" size="12" color="#8b5cf6"></uni-icons>
                  旧车 {{ order.oldVehicleBrand }} {{ order.oldVehicleModel }}
                  <text v-if="order.oldVehicleYear"> · {{ order.oldVehicleYear }}年</text>
                  <text v-if="order.oldVehicleMileage"> · {{ order.oldVehicleMileage }}万公里</text>
                </text>
                <text class="info-item" v-if="order.newVehicleModel">
                  <uni-icons type="cart" size="12" color="#3b82f6"></uni-icons>
                  换新 {{ order.newVehicleModel }}
                </text>
              </view>
            </view>

            <!-- 价格 -->
            <view class="body-price">
              <text class="price-symbol">¥</text>
              <text class="price-num">{{ formatPrice(order.totalAmount) }}</text>
            </view>
          </view>

          <!-- ======== 卡片底部：时间 + 操作按钮 ======== -->
          <view class="order-footer">
            <text class="order-date">
              <uni-icons type="calendar" size="14" color="#bbb"></uni-icons>
              {{ order.createTime }}
            </text>
            <view class="order-actions">
              <view v-if="order.status === 'pending_confirm'" class="action-btn" @click.stop="handleCancel(order)">
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
    // 返回列表页时刷新数据，但不清空列表避免闪烁
    this.page = 1
    this.hasMore = true
    this.loadOrders()
  },
  methods: {
    formatPrice(val) {
      const n = parseFloat(val) || 0
      return n.toFixed(2)
    },
    goHome() {
      uni.switchTab({ url: '/pages/index' })
    },
    switchTab(value) {
      this.activeTab = value
      this.page = 1
      this.hasMore = true
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
          // 前端状态key → 后端数字状态
          const beStatusMap = { pending_confirm: '0', confirmed: '1', in_service: '2', completed: '3', cancelled: '4' }
          params.status = beStatusMap[this.activeTab] || this.activeTab
        }
        const res = await getOrderList(params)
        const data = res.data || res
        let list = []
        if (data.rows) {
          list = data.rows.map(order => this.formatOrder(order))
        } else if (Array.isArray(data)) {
          list = data.map(order => this.formatOrder(order))
        } else if (data.list) {
          list = data.list.map(order => this.formatOrder(order))
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
    /** 后端 OrderListVO → 前端卡片数据 */
    formatOrder(order) {
      // 类型图标映射
      const typeIconMap = {
        charging: 'circle',
        maintenance: 'tools',
        unified: 'cart',
        default: 'list'
      }
      // 后端数字状态(0-4) → 前端状态key
      const statusMap = { '0': 'pending_confirm', '1': 'confirmed', '2': 'in_service', '3': 'completed', '4': 'cancelled' }
      const status = statusMap[order.status] || order.status || 'pending_confirm'

      return {
        id: order.orderId || order.id,
        orderNo: order.orderNo || '',
        bizType: order.bizType || 'unified',
        bizTypeLabel: order.bizTypeLabel || '订单',
        typeIcon: typeIconMap[order.bizType] || typeIconMap.default,
        status: status,
        statusText: order.statusText || '处理中',
        shopName: order.shopName || '官方店铺',
        title: order.title || '订单',
        desc: order.desc || '',
        totalAmount: order.totalAmount || 0,
        paidAmount: order.paidAmount || 0,
        createTime: order.createTime || '',
        // 充电订单字段
        totalEnergy: order.totalEnergy,
        durationText: order.durationText,
        carbonEarned: order.carbonEarned,
        startTime: order.startTime,
        endTime: order.endTime,
        // 维保订单字段
        expectDate: order.expectDate,
        expectTimeSlot: order.expectTimeSlot,
        shopAddress: order.shopAddress,
        serviceItem: order.serviceItem,
        // 统一订单字段
        contactName: order.contactName,
        contactPhone: order.contactPhone,
        paymentMethod: order.paymentMethod,
        unifiedType: order.unifiedType,
        // 以旧换新字段
        oldVehicleBrand: order.oldVehicleBrand || '',
        oldVehicleModel: order.oldVehicleModel || '',
        oldVehicleYear: order.oldVehicleYear || '',
        oldVehicleMileage: order.oldVehicleMileage || '',
        newVehicleModel: order.newVehicleModel || '',
        vehiclePrice: order.vehiclePrice || 0,
        oldValuation: order.oldValuation || 0,
        newVehiclePrice: order.newVehiclePrice || 0,
        subsidyAmount: order.subsidyAmount || 0
      }
    },
    handleOrderDetail(order) {
      uni.navigateTo({ url: `/pages/mine/orders/detail?id=${order.id}&bizType=${order.bizType}` })
    },
    async handlePay(order) {
      uni.showModal({
        title: '确认支付',
        content: '确认支付 ¥' + (order.totalAmount || 0) + '？',
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

// ==================== 顶部标签栏 ====================
.tab-bar {
  background-color: #fff;
  padding: 10rpx 0;
  position: sticky;
  top: 0;
  z-index: 10;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.03);
}

.tab-scroll { white-space: nowrap; }

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

// ==================== 列表容器 ====================
.order-scroll {
  height: 100vh;
}

.order-list {
  padding: 20rpx 24rpx 40rpx;
}

// ==================== 订单卡片 ====================
.order-card {
  background-color: #fff;
  border-radius: 20rpx;
  margin-bottom: 24rpx;
  overflow: hidden;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.04);
  position: relative;
}

// 不同类型卡片左侧彩色装饰条
.order-card::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  width: 6rpx;
  height: 100%;
  border-radius: 3rpx 0 0 3rpx;
}

.card-charging::before  { background: linear-gradient(180deg, #10b981, #34d399); }
.card-maintenance::before { background: linear-gradient(180deg, #f59e0b, #fbbf24); }
.card-unified::before   { background: linear-gradient(180deg, #3b82f6, #60a5fa); }

// ==================== 卡片头部 ====================
.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 24rpx 24rpx 16rpx;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 12rpx;
  flex: 1;
  min-width: 0;
}

// ==================== 业务类型彩色标签 ====================
.biz-type-tag {
  display: flex;
  align-items: center;
  gap: 4rpx;
  padding: 4rpx 14rpx;
  border-radius: 20rpx;
  font-size: 20rpx;
  font-weight: 500;
  color: #fff;
  flex-shrink: 0;
}

.tag-charging    { background: linear-gradient(135deg, #10b981, #34d399); }
.tag-maintenance { background: linear-gradient(135deg, #f59e0b, #fbbf24); }
.tag-unified {
  background: linear-gradient(135deg, #3b82f6, #60a5fa);
  // 子类型不同颜色在卡片内处理
}

.order-shop {
  font-size: 26rpx;
  color: #333;
  font-weight: 500;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

// ==================== 状态小标签 ====================
.order-status {
  display: flex;
  align-items: center;
  gap: 6rpx;
  padding: 6rpx 18rpx;
  border-radius: 24rpx;
  font-size: 22rpx;
  font-weight: 500;
  flex-shrink: 0;
  color: #fff;
}

.status-dot {
  width: 10rpx;
  height: 10rpx;
  border-radius: 50%;
  background-color: rgba(255,255,255,0.9);
}

.status-pending_confirm {
  background: linear-gradient(135deg, #ff6b35, #f7931e);
}
.status-confirmed {
  background: linear-gradient(135deg, #2563eb, #3b82f6);
}
.status-in_service {
  background: linear-gradient(135deg, #00bcd4, #26c6da);
}
.status-completed {
  background: linear-gradient(135deg, #10b981, #34d399);
}
.status-cancelled {
  background: linear-gradient(135deg, #9ca3af, #b0b8c4);
}

// ==================== 卡片主体 ====================
.order-body {
  display: flex;
  padding: 0 24rpx 16rpx;
  gap: 20rpx;
}

.body-main {
  flex: 1;
  min-width: 0;
}

.order-title {
  font-size: 28rpx;
  font-weight: 500;
  color: #333;
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.order-desc {
  font-size: 24rpx;
  color: #999;
  margin-top: 4rpx;
}

// 类型专属信息区
.type-info {
  display: flex;
  flex-wrap: wrap;
  gap: 12rpx;
  margin-top: 12rpx;
}

.info-item {
  font-size: 22rpx;
  color: #888;
  display: flex;
  align-items: center;
  gap: 4rpx;
  background-color: #f8f9fa;
  padding: 4rpx 12rpx;
  border-radius: 12rpx;
}

.body-price {
  display: flex;
  align-items: baseline;
  flex-shrink: 0;
  padding-top: 4rpx;
}

.price-symbol {
  font-size: 24rpx;
  color: #ff4757;
  font-weight: 500;
}

.price-num {
  font-size: 32rpx;
  color: #ff4757;
  font-weight: 700;
}

// ==================== 卡片底部 ====================
.order-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16rpx 24rpx;
  border-top: 1rpx solid #f5f5f5;
  background-color: #fafafa;
}

.order-date {
  font-size: 22rpx;
  color: #bbb;
  display: flex;
  align-items: center;
  gap: 6rpx;
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

.action-btn:active { transform: scale(0.96); }

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

// ==================== 空状态 ====================
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