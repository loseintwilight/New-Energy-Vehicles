<template>
  <view class="page-container">
    <view class="stats-bar">
      <view class="stats-bg"></view>
      <view class="stats-content">
        <view class="stat-item">
          <text class="stat-value">{{ statistics.count || 0 }}</text>
          <text class="stat-label">充电次数</text>
        </view>
        <view class="stat-divider"></view>
        <view class="stat-item">
          <text class="stat-value">{{ formatNumber(statistics.totalEnergy) }} <span class="unit">kWh</span></text>
          <text class="stat-label">累计充电</text>
        </view>
        <view class="stat-divider"></view>
        <view class="stat-item">
          <text class="stat-value"><span class="prefix">¥</span>{{ formatNumber(statistics.totalAmount) }}</text>
          <text class="stat-label">累计费用</text>
        </view>
      </view>
    </view>

    <scroll-view scroll-y class="list-scroll" @scrolltolower="loadMore">
      <view v-if="records.length === 0" class="empty-state">
        <view class="empty-icon">
          <uni-icons type="info" size="80" color="#e0e0e0"></uni-icons>
        </view>
        <text class="empty-title">暂无充电记录</text>
        <text class="empty-desc">快去充电吧</text>
      </view>

      <view v-for="item in records" :key="item.id" class="charge-card" @click="handleDetail(item)">
        <view class="card-bg"></view>
        <view class="card-content">
          <view class="charge-header">
            <view class="station-info">
              <text class="charge-station">{{ item.stationName || '--' }}</text>
              <text class="charge-time">{{ item.startTime || '--' }}</text>
            </view>
            <view class="charge-status" :class="item.status === 'completed' ? 'c-completed' : item.status === 'pending_payment' ? 'c-pending' : 'c-ongoing'">
              {{ item.status === 'completed' ? '已完成' : item.status === 'pending_payment' ? '待付款' : '充电中' }}
            </view>
          </view>
          
          <view class="charge-body">
            <view class="charge-data-row">
              <view class="data-item">
                <text class="data-label">充电时长</text>
                <text class="data-value">{{ item.duration || '--' }}</text>
              </view>
              <view class="data-item">
                <text class="data-label">充电量</text>
                <text class="data-value">{{ formatNumber(item.power) }} kWh</text>
              </view>
              <view class="data-item">
                <text class="data-label">费用</text>
                <text class="data-value price">¥{{ formatNumber(item.cost) }}</text>
              </view>
            </view>
            
            <view class="payment-status" v-if="item.payStatus">
              <text class="status-text">支付状态：</text>
              <text class="status-value" :class="item.payStatus === '1' ? 'paid' : 'unpaid'">
                {{ item.payStatus === '1' ? '已支付' : '待支付' }}
              </text>
            </view>
          </view>
        </view>
        <view class="card-arrow">
          <uni-icons type="forward" size="20" color="#ccc"></uni-icons>
        </view>
      </view>

      <view v-if="loading" class="loading-more">
        <uni-icons type="info" size="24" color="#999"></uni-icons>
        <text class="loading-text">加载中...</text>
      </view>

      <view v-if="!loading && hasMore" class="load-more" @click="loadMore">
        <text class="load-text">点击加载更多</text>
      </view>

      <view v-if="!loading && !hasMore && records.length > 0" class="no-more">
        <text class="no-more-text">— 已加载全部记录 —</text>
      </view>
      
      <view class="bottom-space"></view>
    </scroll-view>
  </view>
</template>

<script>
import { getChargingRecords, getChargingStatistics } from '@/api/mine/charging'

export default {
  data() {
    return {
      records: [],
      statistics: {
        count: 0,
        totalEnergy: 0,
        totalAmount: 0
      },
      pageNum: 1,
      pageSize: 10,
      loading: false,
      hasMore: true
    }
  },
  onLoad() {
    this.loadRecords()
  },
  methods: {
    async loadRecords(isLoadMore = false) {
      if (this.loading) return

      this.loading = true
      try {
        const [listRes, statsRes] = await Promise.all([
          getChargingRecords({
            pageNum: this.pageNum,
            pageSize: this.pageSize
          }),
          isLoadMore ? null : getChargingStatistics()
        ])

        if (listRes && (listRes.code === 200 || listRes.code === 0)) {
          const data = listRes.data || listRes
          const list = data.rows || []

          if (isLoadMore) {
            this.records = [...this.records, ...list.map(item => this.formatRecord(item))]
          } else {
            this.records = list.map(item => this.formatRecord(item))
            // 统计信息从独立接口获取
            if (statsRes && (statsRes.code === 200 || statsRes.code === 0)) {
              const statsData = statsRes.data || statsRes
              this.statistics = {
                count: statsData.count || data.total || 0,
                totalEnergy: statsData.totalEnergy || 0,
                totalAmount: statsData.totalAmount || 0
              }
            }
          }

          this.hasMore = list.length >= this.pageSize
          this.pageNum++
        }
      } catch (e) {
        console.error('加载充电记录失败', e)
        uni.showToast({ title: '加载失败', icon: 'none' })
      } finally {
        this.loading = false
      }
    },
    formatRecord(item) {
      // item 字段来自后端 ChargingOrderListVO
      let status = 'ongoing'
      if (item.orderStatus === '1' || item.orderStatus === 1) {
        // 已完成但未支付 → 待付款
        if (item.payStatus === '0') status = 'pending_payment'
        else status = 'completed'
      } else if (item.orderStatus === '2' || item.orderStatus === 2) status = 'cancelled'

      return {
        id: item.orderId || item.id,
        stationName: item.stationName || '',
        status: status,
        startTime: item.startTime || item.createTime || '',
        endTime: item.endTime || '',
        duration: item.durationText || '--',
        power: item.totalEnergy || 0,
        cost: item.totalAmount || 0,
        address: item.address || '',
        paymentMethod: item.paymentMethod || '',
        payStatus: item.payStatus || ''
      }
    },
    formatNumber(num) {
      if (num === null || num === undefined) return '0'
      return typeof num === 'number' ? num.toFixed(2) : String(num)
    },
    loadMore() {
      if (this.hasMore && !this.loading) {
        this.loadRecords(true)
      }
    },
    handleDetail(item) {
      uni.navigateTo({
        url: '/pages/mine/orders/detail?id=' + item.id + '&bizType=charging'
      })
    }
  }
}
</script>

<style lang="scss" scoped>
page {
  background-color: #f2f7fe;
  min-height: 100vh;
}

.page-container {
  min-height: 100vh;
}

.stats-bar {
  position: relative;
  margin: 20rpx 30rpx;
  border-radius: 20rpx;
  overflow: hidden;
  box-shadow: 0 8rpx 24rpx rgba(60, 150, 243, 0.15);
}

.stats-bg {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, #3c96f3 0%, #5a87ff 50%, #7c6dff 100%);
}

.stats-content {
  position: relative;
  z-index: 1;
  display: flex;
  align-items: center;
  justify-content: space-around;
  padding: 36rpx 24rpx;
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  flex: 1;
}

.stat-value {
  font-size: 40rpx;
  font-weight: 800;
  color: #fff;
  line-height: 1.2;
  
  .prefix {
    font-size: 32rpx;
    font-weight: 600;
  }
  
  .unit {
    font-size: 24rpx;
    font-weight: 400;
    opacity: 0.8;
    margin-left: 4rpx;
  }
}

.stat-label {
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.8);
  margin-top: 8rpx;
}

.stat-divider {
  width: 1rpx;
  height: 60rpx;
  background-color: rgba(255, 255, 255, 0.25);
}

.list-scroll {
  height: calc(100vh - 320rpx);
  padding: 0 30rpx;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 120rpx 40rpx;
}

.empty-icon {
  width: 140rpx;
  height: 140rpx;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.9);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 24rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
}

.empty-title {
  font-size: 30rpx;
  font-weight: 600;
  color: #333;
  margin-bottom: 8rpx;
}

.empty-desc {
  font-size: 24rpx;
  color: #999;
}

.charge-card {
  position: relative;
  background: #fff;
  border-radius: 20rpx;
  margin-bottom: 20rpx;
  overflow: hidden;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.04);
  display: flex;
  align-items: stretch;
  transition: all 0.3s ease;
}

.charge-card:active {
  transform: scale(0.98);
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06);
}

.card-bg {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 120rpx;
  background: linear-gradient(135deg, rgba(60, 150, 243, 0.06) 0%, rgba(124, 109, 255, 0.04) 100%);
}

.card-content {
  position: relative;
  z-index: 1;
  flex: 1;
  padding: 28rpx;
}

.charge-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 20rpx;
}

.station-info {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.charge-station {
  font-size: 30rpx;
  font-weight: 700;
  color: #1a1a1a;
  line-height: 1.4;
  margin-bottom: 6rpx;
}

.charge-time {
  font-size: 24rpx;
  color: #888;
}

.charge-status {
  font-size: 22rpx;
  padding: 8rpx 20rpx;
  border-radius: 24rpx;
  font-weight: 500;
  flex-shrink: 0;
}

.charge-status.c-completed {
  background: linear-gradient(135deg, #e8f5e9 0%, #c8f2ce 100%);
  color: #2ecc71;
}

.charge-status.c-pending {
  background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
  color: #ff6b35;
}

.charge-status.c-ongoing {
  background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
  color: #1976d2;
}

.charge-body {
  display: flex;
  flex-direction: column;
}

.charge-data-row {
  display: flex;
  gap: 20rpx;
  margin-bottom: 16rpx;
}

.data-item {
  flex: 1;
  background: #f8fafc;
  border-radius: 12rpx;
  padding: 16rpx 12rpx;
  text-align: center;
}

.data-label {
  font-size: 22rpx;
  color: #888;
  display: block;
  margin-bottom: 6rpx;
}

.data-value {
  font-size: 26rpx;
  font-weight: 600;
  color: #333;
  
  &.price {
    color: #ff4757;
    font-size: 28rpx;
  }
}

.payment-status {
  display: flex;
  align-items: center;
  padding-top: 16rpx;
  border-top: 1rpx solid #f0f0f0;
}

.status-text {
  font-size: 22rpx;
  color: #888;
}

.status-value {
  font-size: 22rpx;
  font-weight: 500;
  color: #333;
  margin-left: 6rpx;
}

.status-value.paid {
  color: #2ecc71;
}

.status-value.unpaid {
  color: #ff4757;
}

.card-arrow {
  width: 60rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  padding-right: 24rpx;
}

.loading-more {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 30rpx 20rpx;
}

.loading-text {
  font-size: 26rpx;
  color: #999;
  margin-left: 10rpx;
}

.load-more {
  text-align: center;
  padding: 30rpx 20rpx;
}

.load-text {
  font-size: 26rpx;
  color: #3c96f3;
}

.no-more {
  text-align: center;
  padding: 30rpx 20rpx;
}

.no-more-text {
  font-size: 24rpx;
  color: #ccc;
}

.bottom-space {
  height: 60rpx;
}
</style>
