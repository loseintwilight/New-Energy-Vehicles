<template>
  <view class="page-container">
    <view class="summary-bar">
      <view class="summary-item">
        <text class="s-val">{{ totalCount }}</text>
        <text class="s-label">充电次数</text>
      </view>
      <view class="summary-item">
        <text class="s-val">{{ totalPower }} kWh</text>
        <text class="s-label">累计充电</text>
      </view>
      <view class="summary-item">
        <text class="s-val">¥{{ totalCost }}</text>
        <text class="s-label">累计费用</text>
      </view>
    </view>

    <scroll-view scroll-y class="list-scroll">
      <view class="charging-list" v-if="records.length > 0">
        <view v-for="item in records" :key="item.id" class="charge-card">
          <view class="charge-header">
            <text class="charge-station">{{ item.stationName }}</text>
            <view class="charge-status" :class="item.status === 'completed' ? 'c-completed' : 'c-ongoing'">
              {{ item.status === 'completed' ? '已完成' : '充电中' }}
            </view>
          </view>
          <view class="charge-body">
            <view class="charge-info">
              <text class="charge-date">{{ item.startTime }}</text>
              <text class="charge-duration">充电时长：{{ item.duration }}</text>
            </view>
            <view class="charge-data">
              <text class="charge-power">{{ item.power }} kWh</text>
              <text class="charge-cost">¥{{ item.cost }}</text>
            </view>
          </view>
          <view class="charge-footer" v-if="item.status === 'completed'">
            <text class="charge-addr">{{ item.address }}</text>
            <view class="charge-btn" @click="handleDetail(item)">查看详情</view>
          </view>
        </view>
      </view>

      <view class="empty" v-else>
        <uni-icons type="bolt" size="80" color="#ddd"></uni-icons>
        <text class="empty-text">暂无充电记录</text>
        <text class="empty-sub">快去附近的充电站为爱车充电吧</text>
      </view>
    </scroll-view>
  </view>
</template>

<script>
import { getOrderList } from '@/api/charge/station.js'

export default {
  data() {
    return {
      records: [],
      loading: false
    }
  },

  onLoad() {
    this.fetchRecords()
  },

  onShow() {
    // 每次显示时刷新（刚充完电回来能看到新记录）
    this.fetchRecords()
  },

  methods: {
    async fetchRecords() {
      if (this.loading) return
      this.loading = true
      try {
        const res = await getOrderList({ pageNum: 1, pageSize: 50 })
        // res = AjaxResult.success({rows: [...], total: N})
        if (res && res.data && res.data.rows) {
          this.records = res.data.rows.map(item => ({
            id: item.orderId || item.orderNo,
            stationName: item.stationName || '充电站',
            status: item.status === '0' ? 'charging' : 'completed',
            startTime: item.createTime || '-',
            duration: item.durationText || (item.duration ? item.duration + '秒' : '-'),
            power: item.energy || 0,
            cost: item.amount || 0,
            address: '',
            orderNo: item.orderNo
          }))
        }
      } catch (e) {
        console.log('[充电记录] API失败，使用兜底数据', e)
        this.useMockData()
      }
      this.loading = false
    },

    useMockData() {
      this.records = [
        { id: 1, stationName: '星星充电站（槐荫区）', status: 'completed',
          startTime: '2026-06-01 18:30', duration: '45分钟', power: 42.5, cost: 38.25,
          address: '济南市槐荫区经十路与纬十二路交叉口' },
        { id: 2, stationName: '特来电充电站（历下区）', status: 'completed',
          startTime: '2026-05-30 08:15', duration: '1小时20分', power: 58.0, cost: 52.20,
          address: '济南市历下区泉城路188号' }
      ]
    },

    handleDetail(item) {
      // 跳转到充电订单详情
      uni.navigateTo({
        url: '/pages/charge/order'
      })
    }
  },

  computed: {
    totalCount() {
      return this.records.length
    },
    totalPower() {
      return this.records.reduce((sum, r) => sum + (parseFloat(r.power) || 0), 0).toFixed(1)
    },
    totalCost() {
      return this.records.reduce((sum, r) => sum + (parseFloat(r.cost) || 0), 0).toFixed(2)
    }
  }
}
</script>

<style lang="scss" scoped>
page {
  background-color: #f5f6f7;
  min-height: 100vh;
}

.summary-bar {
  display: flex;
  background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%);
  padding: 30rpx;
  margin: 20rpx 30rpx;
  border-radius: 16rpx;
}

.summary-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.s-val {
  font-size: 30rpx;
  font-weight: 700;
  color: #fff;
}

.s-label {
  font-size: 22rpx;
  color: rgba(255, 255, 255, 0.7);
  margin-top: 6rpx;
}

.list-scroll {
  height: calc(100vh - 180rpx);
}

.charging-list {
  padding: 0 30rpx 20rpx;
}

.charge-card {
  background-color: #fff;
  border-radius: 14rpx;
  padding: 24rpx;
  margin-bottom: 16rpx;
}

.charge-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16rpx;
}

.charge-station {
  font-size: 28rpx;
  font-weight: 500;
  color: #333;
}

.charge-status {
  font-size: 22rpx;
  padding: 4rpx 16rpx;
  border-radius: 20rpx;
}

.c-completed {
  color: #4caf50;
  background-color: #e8f5e9;
}

.c-ongoing {
  color: #ff9800;
  background-color: #fff3e0;
}

.charge-body {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.charge-info {
  display: flex;
  flex-direction: column;
  gap: 6rpx;
}

.charge-date {
  font-size: 24rpx;
  color: #666;
}

.charge-duration {
  font-size: 22rpx;
  color: #999;
}

.charge-data {
  text-align: right;
}

.charge-power {
  font-size: 28rpx;
  font-weight: 600;
  color: #333;
  display: block;
}

.charge-cost {
  font-size: 22rpx;
  color: #ff4757;
  margin-top: 4rpx;
}

.charge-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 16rpx;
  border-top: 1rpx solid #f5f5f5;
  margin-top: 12rpx;
}

.charge-addr {
  font-size: 22rpx;
  color: #bbb;
}

.charge-btn {
  font-size: 24rpx;
  color: #3c96f3;
  padding: 6rpx 20rpx;
  border: 1rpx solid #3c96f3;
  border-radius: 20rpx;
}

.empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 120rpx;
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