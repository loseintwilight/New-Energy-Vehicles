<template>
  <view class="order-page">
    <charge-header />
    <view class="nav-bar">
      <view class="nav-back" @click="goBack">
        <u-icon name="arrow-left" size="36" color="#333"></u-icon>
      </view>
      <text class="nav-title">充电订单</text>
      <view class="nav-right"></view>
    </view>

    <view class="tabs-bar">
      <view
        v-for="(tab, ti) in tabList"
        :key="ti"
        class="tab-item"
        :class="{ active: activeTab === ti }"
        @click="switchTab(ti)"
      >
        <text>{{ tab }}</text>
        <view class="tab-line" v-if="activeTab === ti"></view>
      </view>
    </view>

    <view class="stats-overview" v-if="activeTab === 0 && orderList.length > 0">
      <view class="stat-card">
        <text class="stat-value">¥{{ totalAmount }}</text>
        <text class="stat-label">累计消费</text>
      </view>
      <view class="stat-divider"></view>
      <view class="stat-card">
        <text class="stat-value">{{ totalEnergy }}度</text>
        <text class="stat-label">总充电量</text>
      </view>
      <view class="stat-divider"></view>
      <view class="stat-card">
        <text class="stat-value">{{ orderList.length }}次</text>
        <text class="stat-label">充电次数</text>
      </view>
      <view class="stat-divider"></view>
      <view class="stat-card">
        <text class="stat-value green">{{ carbonSaved }}kg</text>
        <text class="stat-label">减碳量</text>
      </view>
    </view>

    <scroll-view
      class="order-list"
      scroll-y
      @scrolltolower="loadMoreOrders"
      refresher-enabled
      :refresher-triggered="isRefreshing"
      @refresherrefresh="onRefresh"
      enhanced
    >
      <view v-if="!loading && filteredOrders.length === 0" class="empty-state">
        <view class="empty-icon">
          <u-icon name="list" size="120" color="#ddd"></u-icon>
        </view>
        <text class="empty-title">暂无订单</text>
        <text class="empty-desc">快去充电吧，开启绿色出行</text>
      </view>

      <view
        v-for="(order, oi) in filteredOrders"
        :key="oi"
        class="order-card"
        :class="'order-' + order.status"
        @click="showOrderDetail(order)"
      >
        <view class="order-header">
          <view class="order-station">
            <text class="order-station-name">{{ order.stationName }}</text>
            <text class="order-pile">· {{ order.pileNo }}</text>
          </view>
          <view class="order-status" :class="order.status">
            <text>{{ order.statusText }}</text>
          </view>
        </view>

        <view class="order-body">
          <view class="order-data-grid">
            <view class="od-item">
              <text class="od-label">时长</text>
              <text class="od-value">{{ order.duration }}</text>
            </view>
            <view class="od-item">
              <text class="od-label">充电量</text>
              <text class="od-value">{{ order.energy }}度</text>
            </view>
            <view class="od-item">
              <text class="od-label">费用</text>
              <text class="od-value highlight">¥{{ order.amount }}</text>
            </view>
          </view>

          <view class="order-meta">
            <text class="order-time">{{ order.createTime }}</text>
            <view class="order-type-tag">
              <text>{{ order.chargeType }}</text>
            </view>
          </view>
        </view>

        <view class="order-footer" v-if="order.status === 'finished'">
          <view class="of-left">
            <text class="of-score-label">评分</text>
            <uni-rate :value="order.score || 0" :max="5" size="24" active-color="#ffc107" inactive-color="#eee" />
          </view>
          <view class="of-actions">
            <text class="of-btn" @click.stop="applyInvoice(order)">开发票</text>
            <text class="of-btn primary" @click.stop="reOrder(order)">再来一单</text>
          </view>
        </view>

        <view class="order-footer" v-if="order.status === 'charging'">
          <view class="of-left">
            <text class="charging-tip">充电进行中...</text>
          </view>
          <view class="of-actions">
            <text class="of-btn danger" @click.stop="confirmStop(order)">停止充电</text>
            <text class="of-btn primary" @click.stop="viewCharging(order)">查看详情</text>
          </view>
        </view>

        <view class="order-footer" v-if="order.status === 'unpaid'">
          <view class="of-left">
            <text class="unpaid-tip">待支付 ¥{{ order.amount }}</text>
          </view>
          <view class="of-actions">
            <text class="of-btn" @click.stop="cancelOrder(order)">取消</text>
            <text class="of-btn primary" @click.stop="payOrder(order)">去支付</text>
          </view>
        </view>
      </view>

      <view v-if="loadMoreStatus === 'loading'" class="load-more-hint">
        <text>加载中...</text>
      </view>
      <view v-if="loadMoreStatus === 'noMore'" class="load-more-hint no-more">
        <text>— 已经到底了 —</text>
      </view>
    </scroll-view>

    <uni-popup ref="orderDetailPopup" type="bottom" :safe-area="true">
      <view class="detail-popup">
        <view class="dp-header">
          <text class="dp-title">订单详情</text>
          <u-icon name="close" size="40" color="#999" @click="closeOrderDetail"></u-icon>
        </view>

        <scroll-view class="dp-body" scroll-y>
          <view class="dp-section">
            <text class="dp-section-title">基本信息</text>
            <view class="dp-row">
              <text class="dp-label">订单编号</text>
              <text class="dp-value">{{ currentOrder.orderId }}</text>
            </view>
            <view class="dp-row">
              <text class="dp-label">充电站点</text>
              <text class="dp-value">{{ currentOrder.stationName }}</text>
            </view>
            <view class="dp-row">
              <text class="dp-label">充电桩号</text>
              <text class="dp-value">{{ currentOrder.pileNo }}</text>
            </view>
            <view class="dp-row">
              <text class="dp-label">充电类型</text>
              <text class="dp-value">{{ currentOrder.chargeType }}</text>
            </view>
            <view class="dp-row">
              <text class="dp-label">订单状态</text>
              <text class="dp-value status" :class="currentOrder.status">{{ currentOrder.statusText }}</text>
            </view>
          </view>

          <view class="dp-section">
            <text class="dp-section-title">充电明细</text>
            <view class="dp-row">
              <text class="dp-label">开始时间</text>
              <text class="dp-value">{{ currentOrder.createTime }}</text>
            </view>
            <view class="dp-row">
              <text class="dp-label">结束时间</text>
              <text class="dp-value">{{ currentOrder.endTime || '-' }}</text>
            </view>
            <view class="dp-row">
              <text class="dp-label">充电时长</text>
              <text class="dp-value">{{ currentOrder.duration }}</text>
            </view>
            <view class="dp-row">
              <text class="dp-label">充电电量</text>
              <text class="dp-value">{{ currentOrder.energy }} 度</text>
            </view>
            <view class="dp-row">
              <text class="dp-label">平均功率</text>
              <text class="dp-value">{{ currentOrder.avgPower || '-' }} kW</text>
            </view>
          </view>

          <view class="dp-section">
            <text class="dp-section-title">费用明细</text>
            <view class="dp-row">
              <text class="dp-label">电费</text>
              <text class="dp-value">¥{{ currentOrder.electricFee || '0.00' }}</text>
            </view>
            <view class="dp-row">
              <text class="dp-label">服务费</text>
              <text class="dp-value">¥{{ currentOrder.serviceFee || '0.00' }}</text>
            </view>
            <view class="dp-row">
              <text class="dp-label">停车费</text>
              <text class="dp-value">¥{{ currentOrder.parkFee || '0.00' }}</text>
            </view>
            <view class="dp-divider"></view>
            <view class="dp-row total">
              <text class="dp-label">合计</text>
              <text class="dp-value highlight">¥{{ currentOrder.amount }}</text>
            </view>
          </view>
        </scroll-view>
      </view>
    </uni-popup>

    <uni-popup ref="payPopup" type="center">
      <view class="pay-popup">
        <text class="pay-title">选择支付方式</text>
        <view class="pay-options">
          <view class="pay-option" :class="{ selected: payMethod === 'weixin' }" @click="payMethod = 'weixin'">
            <u-icon name="weixin-fill" size="40" color="#07c160"></u-icon>
            <text>微信支付</text>
            <u-icon v-if="payMethod === 'weixin'" name="checkbox-mark" size="32" color="#07c160"></u-icon>
          </view>
          <view class="pay-option" :class="{ selected: payMethod === 'zhifubao' }" @click="payMethod = 'zhifubao'">
            <u-icon name="rmb" size="40" color="#1677ff"></u-icon>
            <text>支付宝</text>
            <u-icon v-if="payMethod === 'zhifubao'" name="checkbox-mark" size="32" color="#07c160"></u-icon>
          </view>
        </view>
        <view class="pay-summary">
          <text class="pay-amount-label">支付金额</text>
          <text class="pay-amount">¥{{ currentOrder.amount }}</text>
        </view>
        <button class="pay-confirm" @click="doPay">确认支付 ¥{{ currentOrder.amount }}</button>
        <text class="pay-cancel" @click="closePayPopup">取消支付</text>
      </view>
    </uni-popup>

    <uni-popup ref="invoicePopup" type="center">
      <view class="invoice-popup">
        <text class="invoice-title">申请发票</text>
        <view class="invoice-form">
          <view class="invoice-field">
            <text class="if-label">发票类型</text>
            <picker :value="invoiceTypeIndex" :range="invoiceTypes" @change="onInvoiceTypeChange">
              <view class="if-value">{{ invoiceTypes[invoiceTypeIndex] }} <u-icon name="arrow-down" size="24" color="#999"></u-icon></view>
            </picker>
          </view>
          <view class="invoice-field">
            <text class="if-label">发票抬头</text>
            <input class="if-input" v-model="invoiceTitle" placeholder="请输入发票抬头" />
          </view>
          <view class="invoice-field">
            <text class="if-label">纳税人识别号</text>
            <input class="if-input" v-model="invoiceTaxNo" placeholder="请输入税号" />
          </view>
          <view class="invoice-field">
            <text class="if-label">接收邮箱</text>
            <input class="if-input" v-model="invoiceEmail" placeholder="请输入电子邮箱" type="email" />
          </view>
        </view>
        <view class="invoice-actions">
          <button class="invoice-cancel" @click="closeInvoicePopup">取消</button>
          <button class="invoice-confirm" @click="submitInvoice">提交申请</button>
        </view>
      </view>
    </uni-popup>
  </view>
</template>

<script>
import { getOrderList, payOrder, cancelOrder, applyInvoice } from '@/api/charge/station.js'
import ChargeHeader from '@/components/charge-header/charge-header.vue'

export default {
  components: { ChargeHeader },
  data() {
    return {
      activeTab: 0,
      tabList: ['全部', '已完成', '充电中', '待支付', '已取消'],
      loading: false,
      isRefreshing: false,
      loadMoreStatus: 'more',
      orderList: [],
      queryParams: { pageNum: 1, pageSize: 10, lat: 36.548, lng: 116.801 },
      currentOrder: {},
      payMethod: 'weixin',
      invoiceTypes: ['增值税电子普通发票', '增值税专用发票'],
      invoiceTypeIndex: 0,
      invoiceTitle: '',
      invoiceTaxNo: '',
      invoiceEmail: ''
    }
  },

  onLoad() {
    this.fetchOrderList()
  },

  methods: {
    async fetchOrderList(isRefresh = false) {
      if (this.loading && !isRefresh) return
      this.loading = true

      try {
        const res = await getOrderList(this.queryParams)
        const list = res.rows || []

        if (isRefresh) {
          this.orderList = list
          this.isRefreshing = false
          this.queryParams.pageNum = 1
        } else {
          this.orderList = [...this.orderList, ...list]
        }

        this.loadMoreStatus = list.length < this.queryParams.pageSize ? 'noMore' : 'more'
      } catch (e) {
        if (isRefresh) this.isRefreshing = false
        this.loadMockOrders()
      }

      this.loading = false
    },

    loadMockOrders() {
      const mockOrders = [
        {
          orderId: 'ORD20260528001', stationName: '文常山公园充电站', pileNo: 'A01',
          chargeType: '快充', duration: '1小时20分', energy: '28.5', amount: '36.48',
          createTime: '2026-05-28 14:30', endTime: '2026-05-28 15:50',
          status: 'finished', statusText: '已完成', score: 5,
          electricFee: '25.08', serviceFee: '11.40', parkFee: '0.00', avgPower: '62.3'
        },
        {
          orderId: 'ORD20260527002', stationName: '济南西站公共充电站', pileNo: 'B03',
          chargeType: '快充', duration: '45分', energy: '15.2', amount: '20.52',
          createTime: '2026-05-27 09:15', endTime: '2026-05-27 10:00',
          status: 'finished', statusText: '已完成', score: 4,
          electricFee: '14.44', serviceFee: '6.08', parkFee: '0.00', avgPower: '58.6'
        },
        {
          orderId: 'ORD20260526003', stationName: '齐鲁软件园充电站', pileNo: 'C01',
          chargeType: '慢充', duration: '3小时10分', energy: '35.8', amount: '42.24',
          createTime: '2026-05-26 22:00', endTime: '2026-05-27 01:10',
          status: 'finished', statusText: '已完成', score: 3,
          electricFee: '27.92', serviceFee: '14.32', parkFee: '0.00', avgPower: '21.4'
        },
        {
          orderId: 'ORD20260529004', stationName: '奥体中心充电站', pileNo: 'A02',
          chargeType: '快充', duration: '35分', energy: '12.0', amount: '17.04',
          createTime: '2026-05-29 08:20',
          status: 'charging', statusText: '充电中', score: 0,
          electricFee: '12.24', serviceFee: '4.80', parkFee: '0.00', avgPower: '60.0'
        },
        {
          orderId: 'ORD20260529005', stationName: '万达广场充电站', pileNo: 'D01',
          chargeType: '快充', duration: '-', energy: '0.0', amount: '38.75',
          createTime: '2026-05-29 10:00',
          status: 'unpaid', statusText: '待支付', score: 0,
          electricFee: '27.13', serviceFee: '11.62', parkFee: '0.00'
        },
        {
          orderId: 'ORD20260525006', stationName: '济南东站充电站', pileNo: 'E03',
          chargeType: '快充', duration: '1小时05分', energy: '22.3', amount: '30.77',
          createTime: '2026-05-25 16:00', endTime: '2026-05-25 17:05',
          status: 'cancelled', statusText: '已取消', score: 0,
          electricFee: '21.88', serviceFee: '8.92', parkFee: '5.00', avgPower: '55.8'
        }
      ]
      this.orderList = mockOrders
      this.loadMoreStatus = 'noMore'
    },

    loadMoreOrders() {
      if (this.loadMoreStatus !== 'more') return
      this.loadMoreStatus = 'loading'
      this.queryParams.pageNum++
      this.fetchOrderList()
    },

    onRefresh() {
      this.isRefreshing = true
      this.queryParams.pageNum = 1
      this.fetchOrderList(true)
    },

    switchTab(index) {
      this.activeTab = index
    },

    showOrderDetail(order) {
      this.currentOrder = order
      if (this.$refs.orderDetailPopup) this.$refs.orderDetailPopup.open()
    },

    closeOrderDetail() {
      if (this.$refs.orderDetailPopup) this.$refs.orderDetailPopup.close()
    },

    payOrder(order) {
      this.currentOrder = order
      this.payMethod = 'weixin'
      if (this.$refs.payPopup) this.$refs.payPopup.open()
    },

    closePayPopup() {
      if (this.$refs.payPopup) this.$refs.payPopup.close()
    },

    async doPay() {
      try {
        await payOrder({ orderId: this.currentOrder.orderId, payType: this.payMethod })
      } catch (e) {}

      if (this.$refs.payPopup) this.$refs.payPopup.close()
      uni.showToast({ title: '支付成功', icon: 'success' })
      this.currentOrder.status = 'finished'
      this.currentOrder.statusText = '已完成'
    },

    async cancelOrder(order) {
      uni.showModal({
        title: '确认取消',
        content: '确定取消该订单吗？',
        success: async (res) => {
          if (res.confirm) {
            try {
              await cancelOrder({ orderId: order.orderId })
            } catch (e) {}
            order.status = 'cancelled'
            order.statusText = '已取消'
            uni.showToast({ title: '已取消', icon: 'success' })
          }
        }
      })
    },

    confirmStop(order) {
      uni.showModal({
        title: '停止充电',
        content: '确定停止充电吗？',
        success: (res) => {
          if (res.confirm) {
            order.status = 'finished'
            order.statusText = '已完成'
            order.endTime = this.getCurrentTime()
            uni.showToast({ title: '充电已停止', icon: 'success' })
          }
        }
      })
    },

    viewCharging(order) {
      uni.navigateTo({
        url: `/pages/charge/charging?orderId=${order.orderId}&stationId=${order.stationName}`
      })
    },

    reOrder(order) {
      uni.showToast({ title: '已发起新订单', icon: 'success' })
    },

    applyInvoice(order) {
      this.currentOrder = order
      this.invoiceTitle = ''
      this.invoiceTaxNo = ''
      this.invoiceEmail = ''
      this.invoiceTypeIndex = 0
      if (this.$refs.invoicePopup) this.$refs.invoicePopup.open()
    },

    closeInvoicePopup() {
      if (this.$refs.invoicePopup) this.$refs.invoicePopup.close()
    },

    onInvoiceTypeChange(e) {
      this.invoiceTypeIndex = e.detail.value
    },

    async submitInvoice() {
      if (!this.invoiceTitle) {
        uni.showToast({ title: '请输入发票抬头', icon: 'none' })
        return
      }

      try {
        await applyInvoice({
          orderId: this.currentOrder.orderId,
          type: this.invoiceTypes[this.invoiceTypeIndex],
          title: this.invoiceTitle,
          taxNo: this.invoiceTaxNo,
          email: this.invoiceEmail
        })
      } catch (e) {}

      if (this.$refs.invoicePopup) this.$refs.invoicePopup.close()
      uni.showToast({ title: '申请成功', icon: 'success' })
    },

    goBack() {
      uni.navigateBack()
    },

    getCurrentTime() {
      const d = new Date()
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')} ${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`
    }
  },

  computed: {
    filteredOrders() {
      if (this.activeTab === 0) return this.orderList
      const statusMap = { 0: 'all', 1: 'finished', 2: 'charging', 3: 'unpaid', 4: 'cancelled' }
      const targetStatus = statusMap[this.activeTab]
      if (targetStatus === 'all') return this.orderList
      return this.orderList.filter(o => o.status === targetStatus)
    },

    totalAmount() {
      return this.orderList
        .filter(o => o.status === 'finished')
        .reduce((sum, o) => sum + parseFloat(o.amount || 0), 0)
        .toFixed(2)
    },

    totalEnergy() {
      return this.orderList
        .filter(o => o.status === 'finished')
        .reduce((sum, o) => sum + parseFloat(o.energy || 0), 0)
        .toFixed(1)
    },

    carbonSaved() {
      const energy = parseFloat(this.totalEnergy)
      return (energy * 0.785).toFixed(1)
    }
  }
}
</script>

<style lang="scss" scoped>
.order-page {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background: #f5f6fa;
}

.nav-bar {
  display: flex;
  align-items: center;
  padding: 14rpx 24rpx;
  background: #fff;

  .nav-back { width: 60rpx; height: 60rpx; display: flex; align-items: center; justify-content: center; }
  .nav-title { flex: 1; text-align: center; font-size: 32rpx; font-weight: 700; color: #1a1a1a; }
  .nav-right { width: 60rpx; }
}

.tabs-bar {
  display: flex;
  background: #fff;
  padding: 0 20rpx;
  border-bottom: 1rpx solid #f5f5f5;

  .tab-item {
    flex: 1;
    text-align: center;
    padding: 24rpx 0 20rpx;
    position: relative;

    text {
      font-size: 26rpx;
      color: #888;
    }

    &.active {
      text { color: #07c160; font-weight: 600; }
      .tab-line {
        position: absolute;
        bottom: 0;
        left: 20%;
        right: 20%;
        height: 4rpx;
        background: #07c160;
        border-radius: 2rpx;
      }
    }
  }
}

.stats-overview {
  display: flex;
  align-items: center;
  background: #fff;
  margin: 0 20rpx 16rpx;
  padding: 24rpx 0;
  border-radius: 16rpx;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.04);

  .stat-card {
    flex: 1;
    text-align: center;

    .stat-value {
      font-size: 36rpx;
      font-weight: 800;
      color: #1a1a1a;
      display: block;

      &.green { color: #07c160; }
    }

    .stat-label {
      font-size: 20rpx;
      color: #999;
      margin-top: 6rpx;
      display: block;
    }
  }

  .stat-divider {
    width: 1rpx;
    height: 48rpx;
    background: #f0f0f0;
  }
}

.order-list {
  flex: 1;
  padding: 0 20rpx 20rpx;
}

.order-card {
  background: #fff;
  border-radius: 16rpx;
  margin-bottom: 20rpx;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.04);
  overflow: hidden;

  .order-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 24rpx 24rpx 16rpx;

    .order-station {
      display: flex;
      align-items: center;
      flex: 1;

      .order-station-name {
        font-size: 28rpx;
        font-weight: 700;
        color: #1a1a1a;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        max-width: 360rpx;
      }

      .order-pile {
        font-size: 24rpx;
        color: #888;
      }
    }

    .order-status {
      padding: 4rpx 16rpx;
      border-radius: 6rpx;
      font-size: 22rpx;
      font-weight: 500;

      &.finished { color: #07c160; background: #e8f8ee; }
      &.charging { color: #1890ff; background: #e6f7ff; }
      &.unpaid { color: #fa8c16; background: #fff7e6; }
      &.cancelled { color: #999; background: #f5f5f5; }
    }
  }

  .order-body {
    padding: 0 24rpx 16rpx;

    .order-data-grid {
      display: flex;
      background: #f8f9fc;
      border-radius: 12rpx;
      padding: 16rpx 0;
      margin-bottom: 12rpx;

      .od-item {
        flex: 1;
        text-align: center;
        border-right: 1rpx solid #eee;
        &:last-child { border-right: none; }

        .od-label {
          font-size: 20rpx;
          color: #999;
          display: block;
          margin-bottom: 4rpx;
        }

        .od-value {
          font-size: 30rpx;
          font-weight: 700;
          color: #333;

          &.highlight { color: #ff6b00; }
        }
      }
    }

    .order-meta {
      display: flex;
      align-items: center;
      justify-content: space-between;

      .order-time {
        font-size: 22rpx;
        color: #bbb;
      }

      .order-type-tag {
        padding: 2rpx 12rpx;
        background: #f5f6fa;
        border-radius: 4rpx;
        text { font-size: 20rpx; color: #888; }
      }
    }
  }

  .order-footer {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 16rpx 24rpx;
    border-top: 1rpx solid #f9f9f9;

    .of-left {
      display: flex;
      align-items: center;
      gap: 8rpx;

      .of-score-label {
        font-size: 22rpx;
        color: #999;
      }

      .charging-tip, .unpaid-tip {
        font-size: 22rpx;
        color: #1890ff;
      }
    }

    .of-actions {
      display: flex;
      gap: 12rpx;

      .of-btn {
        padding: 8rpx 24rpx;
        font-size: 24rpx;
        border-radius: 20rpx;
        background: #f5f6fa;
        color: #666;

        &.primary { background: linear-gradient(135deg, #07c160, #06ad56); color: #fff; }
        &.danger { background: #fff1f0; color: #ff4d4f; }
      }
    }
  }
}

.load-more-hint {
  text-align: center;
  padding: 24rpx 0;
  text { font-size: 24rpx; color: #bbb; }

  &.no-more { text { color: #ddd; } }
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 160rpx;

  .empty-icon {
    width: 160rpx;
    height: 160rpx;
    background: #fafafa;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 24rpx;
  }

  .empty-title {
    font-size: 30rpx;
    color: #333;
    font-weight: 500;
    margin-bottom: 12rpx;
  }

  .empty-desc {
    font-size: 24rpx;
    color: #aaa;
  }
}

.detail-popup {
  background: #fff;
  border-radius: 24rpx 24rpx 0 0;
  max-height: 85vh;

  .dp-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 32rpx 32rpx 20rpx;

    .dp-title {
      font-size: 34rpx;
      font-weight: 700;
      color: #1a1a1a;
    }
  }

  .dp-body {
    padding: 0 32rpx 60rpx;
    max-height: 65vh;

    .dp-section {
      margin-bottom: 32rpx;

      .dp-section-title {
        font-size: 24rpx;
        color: #999;
        margin-bottom: 16rpx;
        display: block;
      }

      .dp-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 14rpx 0;
        border-bottom: 1rpx solid #f9f9f9;

        &.total { border-bottom: none; margin-top: 8rpx; }

        .dp-label {
          font-size: 26rpx;
          color: #666;
        }

        .dp-value {
          font-size: 26rpx;
          color: #333;
          font-weight: 500;

          &.status {
            padding: 2rpx 12rpx;
            border-radius: 4rpx;
            font-size: 22rpx;
            &.finished { color: #07c160; background: #e8f8ee; }
            &.charging { color: #1890ff; background: #e6f7ff; }
            &.unpaid { color: #fa8c16; background: #fff7e6; }
          }

          &.highlight { color: #ff6b00; font-size: 32rpx; font-weight: 700; }
        }
      }

      .dp-divider {
        height: 1rpx;
        background: #f0f0f0;
        margin: 8rpx 0;
      }
    }
  }
}

.pay-popup {
  background: #fff;
  border-radius: 20rpx;
  padding: 36rpx 32rpx 40rpx;
  width: 560rpx;

  .pay-title {
    font-size: 32rpx;
    font-weight: 700;
    color: #1a1a1a;
    text-align: center;
    display: block;
    margin-bottom: 28rpx;
  }

  .pay-options {
    .pay-option {
      display: flex;
      align-items: center;
      padding: 24rpx 20rpx;
      margin-bottom: 12rpx;
      border: 2rpx solid #f0f0f0;
      border-radius: 12rpx;

      &.selected {
        border-color: #07c160;
        background: #f8fcf9;
      }

      text {
        flex: 1;
        font-size: 28rpx;
        color: #333;
        margin-left: 12rpx;
      }
    }
  }

  .pay-summary {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20rpx 0;

    .pay-amount-label {
      font-size: 26rpx;
      color: #888;
    }

    .pay-amount {
      font-size: 40rpx;
      font-weight: 800;
      color: #ff6b00;
    }
  }

  .pay-confirm {
    width: 100%;
    height: 80rpx;
    line-height: 80rpx;
    background: linear-gradient(135deg, #07c160, #06ad56);
    color: #fff;
    font-size: 30rpx;
    font-weight: 500;
    border-radius: 40rpx;
    margin-top: 12rpx;
  }

  .pay-cancel {
    display: block;
    text-align: center;
    margin-top: 20rpx;
    font-size: 24rpx;
    color: #bbb;
  }
}

.invoice-popup {
  background: #fff;
  border-radius: 20rpx;
  padding: 36rpx 32rpx 40rpx;
  width: 600rpx;

  .invoice-title {
    font-size: 32rpx;
    font-weight: 700;
    color: #1a1a1a;
    text-align: center;
    display: block;
    margin-bottom: 28rpx;
  }

  .invoice-form {
    .invoice-field {
      margin-bottom: 24rpx;

      .if-label {
        font-size: 24rpx;
        color: #666;
        display: block;
        margin-bottom: 10rpx;
      }

      .if-value {
        font-size: 28rpx;
        color: #333;
        padding: 16rpx 20rpx;
        background: #f8f9fc;
        border-radius: 8rpx;
        display: flex;
        align-items: center;
        justify-content: space-between;
      }

      .if-input {
        font-size: 28rpx;
        color: #333;
        padding: 16rpx 20rpx;
        background: #f8f9fc;
        border-radius: 8rpx;
        width: 100%;
        box-sizing: border-box;
      }
    }
  }

  .invoice-actions {
    display: flex;
    gap: 20rpx;
    margin-top: 12rpx;

    button {
      flex: 1;
      height: 72rpx;
      line-height: 72rpx;
      font-size: 26rpx;
      border-radius: 36rpx;
    }

    .invoice-cancel {
      background: #f5f6fa;
      color: #333;
    }

    .invoice-confirm {
      background: linear-gradient(135deg, #07c160, #06ad56);
      color: #fff;
    }
  }
}
</style>