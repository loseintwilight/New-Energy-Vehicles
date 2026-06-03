<template>
  <view class="page" :class="{ 'page-ready': isReady }">
    <!-- 背景装饰 -->
    <view class="glow-matrix">
      <view class="glow-row" v-for="(row, ri) in glowRows" :key="ri">
        <view class="glow-spot" v-for="(dot, ci) in row.dots" :key="ci" :style="dot.style"></view>
      </view>
    </view>
    <view class="overlay-mask"></view>

    <!-- 状态横幅 -->
    <view class="status-banner" :class="'banner-' + order.status">
      <view class="back-btn" hover-class="btn-hover" @tap="goBack">
        <text class="back-icon">❮</text>
      </view>
      <view class="banner-content">
        <text class="banner-status">{{ statusMap[order.status] }}</text>
        <text class="banner-desc">{{ statusDescMap[order.status] }}</text>
      </view>
    </view>

    <scroll-view scroll-y class="detail-scroll" :show-scrollbar="false">
      <!-- 订单信息 -->
      <view class="section-card">
        <view class="section-title">
          <view class="title-line"></view>
          <text class="title-text">订单信息</text>
        </view>
        <view class="info-card">
          <view class="info-row">
            <text class="info-label">订单编号</text>
            <text class="info-value mono">{{ order.order_no }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">订单类型</text>
            <view class="type-badge" :class="'type-' + order.type">
              <text>{{ typeMap[order.type] }}</text>
            </view>
          </view>
          <view class="info-row">
            <text class="info-label">下单时间</text>
            <text class="info-value">{{ order.create_time }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">支付时间</text>
            <text class="info-value">{{ order.pay_time || '未支付' }}</text>
          </view>
        </view>
      </view>

      <!-- 车辆信息 -->
      <view class="section-card">
        <view class="section-title">
          <view class="title-line line-blue"></view>
          <text class="title-text">车辆信息</text>
        </view>
        <view class="info-card car-card">
          <view class="car-img">
            <text class="car-icon">🚗</text>
          </view>
          <view class="car-detail">
            <text class="car-name">{{ order.car_name }}</text>
            <text class="car-price">¥{{ formatPrice(order.car_price) }}</text>
          </view>
        </view>
      </view>

      <!-- 客户信息 -->
      <view class="section-card">
        <view class="section-title">
          <view class="title-line line-purple"></view>
          <text class="title-text">客户信息</text>
        </view>
        <view class="info-card">
          <view class="customer-row">
            <text class="row-icon">👤</text>
            <text class="customer-name">{{ order.contact_name }}</text>
            <text class="customer-phone">{{ order.contact_phone }}</text>
            <view class="call-btn" hover-class="call-btn-hover" @tap="callCustomer">
              <text>拨打</text>
            </view>
          </view>
          <view v-if="order.address" class="customer-row">
            <text class="row-icon">📍</text>
            <text class="address-text">{{ order.address }}</text>
          </view>
        </view>
      </view>

      <!-- 金额明细 -->
      <view class="section-card">
        <view class="section-title">
          <view class="title-line line-orange"></view>
          <text class="title-text">金额明细</text>
        </view>
        <view class="info-card">
          <view class="amount-row">
            <text class="amount-label">车辆价格</text>
            <text class="amount-value">¥{{ formatPrice(order.car_price) }}</text>
          </view>
          <view v-if="order.deposit > 0" class="amount-row">
            <text class="amount-label">已付定金</text>
            <text class="amount-value deduct">-¥{{ formatPrice(order.deposit) }}</text>
          </view>
          <view v-if="order.trade_in_discount > 0" class="amount-row">
            <text class="amount-label">旧车抵扣</text>
            <text class="amount-value deduct">-¥{{ formatPrice(order.trade_in_discount) }}</text>
          </view>
          <view class="amount-row total-row">
            <text class="amount-label total-label">应付金额</text>
            <text class="amount-value total-value">¥{{ formatPrice(order.amount) }}</text>
          </view>
          <view class="amount-row">
            <text class="amount-label">已付金额</text>
            <text class="amount-value paid-value">¥{{ formatPrice(order.paid_amount) }}</text>
          </view>
        </view>
      </view>

      <!-- 试驾信息 -->
      <view v-if="order.type === 'test_drive'" class="section-card">
        <view class="section-title">
          <view class="title-line line-teal"></view>
          <text class="title-text">试驾信息</text>
        </view>
        <view class="info-card">
          <view class="info-row">
            <text class="info-label">试驾日期</text>
            <text class="info-value">{{ order.test_drive_date }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">试驾时段</text>
            <view class="time-slot-tag">
              <text>{{ order.test_drive_time_slot }}</text>
            </view>
          </view>
          <view v-if="order.remark" class="info-row remark-row">
            <text class="info-label">客户备注</text>
            <text class="info-value remark-text">{{ order.remark }}</text>
          </view>
        </view>
      </view>

      <!-- 旧车信息 -->
      <view v-if="order.type === 'trade_in'" class="section-card">
        <view class="section-title">
          <view class="title-line line-amber"></view>
          <text class="title-text">旧车信息</text>
        </view>
        <view class="info-card">
          <view class="old-car-header">
            <text class="old-car-name">{{ order.old_car_name }}</text>
            <view class="evaluate-tag"><text>已估价</text></view>
          </view>
          <view class="info-row">
            <text class="info-label">品牌型号</text>
            <text class="info-value">{{ order.old_car_brand }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">上牌日期</text>
            <text class="info-value">{{ order.old_car_register_date }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">行驶里程</text>
            <text class="info-value">{{ order.old_car_mileage }} 公里</text>
          </view>
          <view class="info-row">
            <text class="info-label">估价金额</text>
            <text class="info-value eval-price">¥{{ formatPrice(order.trade_in_discount) }}</text>
          </view>
        </view>
      </view>

      <view style="height: 240rpx;"></view>
    </scroll-view>

    <!-- 底部操作栏 -->
    <view class="bottom-bar">
      <view v-if="order.status === 'pending_payment'" class="action-btns">
        <view class="btn btn-cancel" hover-class="btn-cancel-hover" @tap="cancelOrder">
          <text>取消订单</text>
        </view>
        <view class="btn btn-confirm" hover-class="btn-confirm-hover" @tap="confirmOrder">
          <text>确认收款</text>
        </view>
      </view>
      <view v-else-if="order.status === 'paid'" class="action-btns">
        <view class="btn btn-outline" hover-class="btn-outline-hover" @tap="contactCustomer">
          <text>联系客户</text>
        </view>
        <view class="btn btn-primary" hover-class="btn-primary-hover" @tap="completeOrder">
          <text>完成订单</text>
        </view>
      </view>
      <view v-else class="action-single">
        <view class="btn btn-outline full" hover-class="btn-outline-hover" @tap="goBack">
          <text>返回列表</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      isReady: false,
      glowRows: [],
      orderId: '',
      order: {},
      typeMap: {
        purchase: '购车订单',
        test_drive: '试驾预约',
        trade_in: '以旧换新'
      },
      statusMap: {
        pending_payment: '待付款',
        paid: '已付款',
        completed: '已完成',
        cancelled: '已取消'
      },
      statusDescMap: {
        pending_payment: '等待客户完成支付',
        paid: '客户已完成支付，请及时处理',
        completed: '订单已完成',
        cancelled: '该订单已取消'
      }
    }
  },
  onLoad(options) {
    var that = this
    that.orderId = options.orderId || ''
    that.loadOrderDetail()
    this.buildGlowRows()
    setTimeout(function() { that.isReady = true }, 100)
  },
  methods: {
    buildGlowRows() {
      var rows = []
      var colors = ['#16a34a', '#22c55e', '#4ade80', '#86efac']
      for (var r = 0; r < 5; r++) {
        var dots = []
        var count = 3 + Math.floor(Math.random() * 4)
        for (var c = 0; c < count; c++) {
          var color = colors[Math.floor(Math.random() * colors.length)]
          dots.push({ style: 'width:' + (3 + Math.random() * 6) + 'px;height:' + (3 + Math.random() * 6) + 'px;background:' + color + ';animation-duration:' + (2 + Math.random() * 3) + 's;animation-delay:' + (Math.random() * 2) + 's;' })
        }
        rows.push({ dots: dots })
      }
      this.glowRows = rows
    },
    formatPrice(val) {
      if (!val && val !== 0) return '--'
      return Number(val).toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 })
    },
    goBack() { uni.navigateBack() },
    loadOrderDetail() {
      var that = this
      var mockData = {
        'ORD20260601001': {
          id: 'ORD20260601001', order_no: 'NEV2026060100001', type: 'purchase',
          contact_name: '张先生', contact_phone: '138****1234', phone_full: '13812341234',
          address: '北京市朝阳区建国路88号某某小区3单元501',
          car_name: '特斯拉 Model Y 长续航版', car_price: 299900,
          deposit: 50000, trade_in_discount: 0,
          amount: 249900, paid_amount: 50000,
          status: 'paid', create_time: '2026-06-01 10:23:15', pay_time: '2026-06-01 10:35:22'
        },
        'ORD20260601002': {
          id: 'ORD20260601002', order_no: 'NEV2026060100002', type: 'test_drive',
          contact_name: '李女士', contact_phone: '139****5678', phone_full: '13956785678',
          address: '',
          car_name: '比亚迪 汉EV 冠军版', car_price: 209800,
          deposit: 0, trade_in_discount: 0,
          amount: 0, paid_amount: 0,
          status: 'pending_payment', create_time: '2026-06-01 09:45:30', pay_time: '',
          test_drive_date: '2026-06-03', test_drive_time_slot: '14:00 - 16:00',
          remark: '希望试驾时能详细讲解智能驾驶功能'
        },
        'ORD20260601003': {
          id: 'ORD20260601003', order_no: 'NEV2026060100003', type: 'trade_in',
          contact_name: '王先生', contact_phone: '137****9012', phone_full: '13790129012',
          address: '上海市浦东新区陆家嘴环路1000号恒生银行大厦18层',
          car_name: '蔚来 ET5 75kWh', car_price: 328000,
          deposit: 30000, trade_in_discount: 85000,
          amount: 213000, paid_amount: 213000,
          status: 'completed', create_time: '2026-05-31 16:08:42', pay_time: '2026-05-31 17:20:10',
          old_car_name: '大众 迈腾 2019款 330TSI',
          old_car_brand: '大众 迈腾',
          old_car_register_date: '2019年6月',
          old_car_mileage: '68000'
        },
        'ORD20260601004': {
          id: 'ORD20260601004', order_no: 'NEV2026060100004', type: 'purchase',
          contact_name: '赵女士', contact_phone: '136****3456', phone_full: '13634563456',
          address: '广州市天河区珠江新城花城大道66号',
          car_name: '小鹏 P7i 702 Max', car_price: 289900,
          deposit: 30000, trade_in_discount: 0,
          amount: 259900, paid_amount: 0,
          status: 'pending_payment', create_time: '2026-05-31 14:22:18', pay_time: ''
        },
        'ORD20260601006': {
          id: 'ORD20260601006', order_no: 'NEV2026060100006', type: 'purchase',
          contact_name: '周先生', contact_phone: '134****2345', phone_full: '13423452345',
          address: '深圳市南山区科技园南区A栋1201',
          car_name: '极氪 001 YOU版', car_price: 389000,
          deposit: 50000, trade_in_discount: 0,
          amount: 339000, paid_amount: 0,
          status: 'cancelled', create_time: '2026-05-30 09:17:33', pay_time: ''
        },
        'ORD20260601007': {
          id: 'ORD20260601007', order_no: 'NEV2026060100007', type: 'trade_in',
          contact_name: '吴先生', contact_phone: '133****6789', phone_full: '13367896789',
          address: '杭州市西湖区文三路478号华星时代广场',
          car_name: '问界 M7 Plus', car_price: 319800,
          deposit: 20000, trade_in_discount: 120000,
          amount: 179800, paid_amount: 179800,
          status: 'paid', create_time: '2026-05-29 15:44:20', pay_time: '2026-05-29 16:10:05',
          old_car_name: '奥迪 A4L 2018款 40TFSI',
          old_car_brand: '奥迪 A4L',
          old_car_register_date: '2018年3月',
          old_car_mileage: '95000'
        }
      }
      that.order = mockData[that.orderId] || mockData['ORD20260601001']
    },
    formatPrice: function(val) {
      if (!val && val !== 0) return '--'
      return Number(val).toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 })
    },
    callCustomer() {
      if (this.order.phone_full) {
        uni.makePhoneCall({ phoneNumber: this.order.phone_full })
      }
    },
    cancelOrder() {
      var that = this
      uni.showModal({
        title: '取消订单',
        content: '确定要取消该订单吗？',
        success: function(res) {
          if (res.confirm) {
            that.order.status = 'cancelled'
            uni.showToast({ title: '已取消', icon: 'success' })
          }
        }
      })
    },
    confirmOrder() {
      var that = this
      uni.showModal({
        title: '收款确认',
        content: '确认客户已完成支付？',
        success: function(res) {
          if (res.confirm) {
            that.order.status = 'paid'
            that.order.paid_amount = that.order.amount
            that.order.pay_time = new Date().toLocaleString('zh-CN')
            uni.showToast({ title: '收款确认成功', icon: 'success' })
          }
        }
      })
    },
    contactCustomer() {
      this.callCustomer()
    },
    completeOrder() {
      var that = this
      uni.showModal({
        title: '完成订单',
        content: '确认该订单已完成交付？',
        success: function(res) {
          if (res.confirm) {
            that.order.status = 'completed'
            uni.showToast({ title: '订单已完成', icon: 'success' })
          }
        }
      })
    }
  }
}
</script>

<style scoped>
/* ========== 页面容器 ========== */
.page {
  min-height: 100vh;
  background: linear-gradient(180deg, #ecfdf5 0%, #f0fdf4 30%, #f7fee7 60%, #fefefe 100%);
  position: relative; overflow: hidden; opacity: 0;
}
.page-ready { opacity: 1; }
.page-ready .section-card {
  animation: slideUp 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) backwards;
}
.page-ready .section-card:nth-child(1) { animation-delay: 0.05s; }
.page-ready .section-card:nth-child(2) { animation-delay: 0.1s; }
.page-ready .section-card:nth-child(3) { animation-delay: 0.15s; }
.page-ready .section-card:nth-child(4) { animation-delay: 0.2s; }
.page-ready .section-card:nth-child(5) { animation-delay: 0.25s; }
.page-ready .section-card:nth-child(6) { animation-delay: 0.3s; }

@keyframes slideUp {
  from { opacity: 0; transform: translateY(30rpx); }
  to { opacity: 1; transform: translateY(0); }
}

/* ========== 背景光晕 ========== */
.glow-matrix {
  position: fixed; top: 0; left: 0; right: 0; bottom: 0;
  pointer-events: none; z-index: 0; overflow: hidden;
  display: flex; flex-direction: column;
}
.glow-row { display: flex; justify-content: space-around; align-items: center; padding: 20rpx 12rpx; gap: 16rpx; }
.glow-spot { border-radius: 50%; flex-shrink: 0; animation: glowPulse ease-in-out infinite; }
@keyframes glowPulse {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.5; transform: scale(0.9); }
}
.overlay-mask {
  position: fixed; top: 0; left: 0; right: 0; bottom: 0;
  background: linear-gradient(180deg, rgba(240,253,244,0.88) 0%, rgba(236,253,245,0.9) 30%, rgba(248,250,252,0.93) 70%, rgba(255,255,255,0.96) 100%);
  z-index: 1; pointer-events: none;
}

/* ========== 状态横幅 ========== */
.status-banner {
  height: 200rpx; padding: 0 28rpx; display: flex; align-items: center;
  position: relative; z-index: 10;
  background: linear-gradient(135deg, #16a34a 0%, #22c55e 40%, #4ade80 70%, #86efac 100%);
  border-radius: 0 0 32rpx 32rpx;
}
.status-banner::after {
  content: ''; position: absolute; bottom: -16rpx; left: 0; right: 0;
  height: 32rpx;
  background: linear-gradient(180deg, #16a34a, transparent);
  border-radius: 0 0 32rpx 32rpx; filter: blur(10rpx); opacity: 0.3;
}
.status-banner.banner-pending_payment {
  background: linear-gradient(135deg, #d97706 0%, #f59e0b 50%, #fbbf24 100%);
}
.status-banner.banner-pending_payment::after {
  background: linear-gradient(180deg, #d97706, transparent);
}
.status-banner.banner-completed {
  background: linear-gradient(135deg, #2563eb 0%, #3b82f6 50%, #60a5fa 100%);
}
.status-banner.banner-completed::after {
  background: linear-gradient(180deg, #2563eb, transparent);
}
.status-banner.banner-cancelled {
  background: linear-gradient(135deg, #64748b 0%, #94a3b8 50%, #cbd5e1 100%);
}
.status-banner.banner-cancelled::after {
  background: linear-gradient(180deg, #64748b, transparent);
}

.back-btn {
  width: 64rpx; height: 64rpx; border-radius: 50%;
  background: rgba(255,255,255,0.22);
  display: flex; align-items: center; justify-content: center;
  margin-right: 20rpx; z-index: 1; transition: all 0.12s ease;
}
.btn-hover { transform: scale(0.92); background: rgba(255,255,255,0.4); }
.back-icon { color: #fff; font-size: 36rpx; font-weight: 300; }
.banner-content { flex: 1; z-index: 1; }
.banner-status { font-size: 40rpx; font-weight: 700; color: #fff; display: block; }
.banner-desc { font-size: 24rpx; color: rgba(255,255,255,0.8); margin-top: 6rpx; display: block; }

/* ========== 滚动区 ========== */
.detail-scroll { position: relative; z-index: 2; padding: 20rpx 28rpx; }

/* ========== 通用卡片 ========== */
.section-card { margin-bottom: 20rpx; }
.section-title {
  display: flex; align-items: center; margin-bottom: 16rpx; padding-left: 4rpx;
}
.title-line {
  width: 6rpx; height: 28rpx; border-radius: 3rpx;
  background: linear-gradient(180deg, #16a34a, #86efac);
  margin-right: 12rpx;
}
.title-line.line-blue { background: linear-gradient(180deg, #3b82f6, #93c5fd); }
.title-line.line-purple { background: linear-gradient(180deg, #8b5cf6, #c4b5fd); }
.title-line.line-orange { background: linear-gradient(180deg, #f97316, #fdba74); }
.title-line.line-teal { background: linear-gradient(180deg, #14b8a6, #5eead4); }
.title-line.line-amber { background: linear-gradient(180deg, #d97706, #fcd34d); }
.title-text { font-size: 28rpx; font-weight: 600; color: #1a1a2e; }
.info-card {
  background: #fff; border-radius: 20rpx; padding: 24rpx;
  box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.04);
}

/* ========== 信息行 ========== */
.info-row {
  display: flex; justify-content: space-between; align-items: center;
  padding: 16rpx 0; border-bottom: 1rpx solid #f5f5f5;
}
.info-row:last-child { border-bottom: none; }
.info-label { font-size: 26rpx; color: #888; flex-shrink: 0; }
.info-value { font-size: 26rpx; color: #333; text-align: right; }
.info-value.mono { font-family: monospace; font-size: 24rpx; color: #888; }
.remark-row { flex-direction: column; align-items: flex-start; gap: 8rpx; }
.remark-text { text-align: left; color: #666; line-height: 1.6; }

.type-badge {
  padding: 6rpx 16rpx; border-radius: 12rpx; font-size: 22rpx; font-weight: 500;
  background: #eff6ff; color: #3b82f6;
}
.type-badge.type-test_drive { background: #fef3c7; color: #d97706; }
.type-badge.type-trade_in { background: #ede9fe; color: #7c3aed; }

.time-slot-tag {
  padding: 6rpx 16rpx; border-radius: 12rpx;
  background: #ccfbf1; color: #0d9488; font-size: 24rpx;
}

/* ========== 车辆卡片 ========== */
.car-card {
  display: flex; align-items: center; gap: 20rpx;
}
.car-img {
  width: 100rpx; height: 100rpx; border-radius: 16rpx;
  background: linear-gradient(135deg, #ecfdf5, #d1fae5);
  display: flex; align-items: center; justify-content: center;
  flex-shrink: 0;
}
.car-icon { font-size: 48rpx; }
.car-detail { flex: 1; }
.car-name { font-size: 30rpx; font-weight: 600; color: #1a1a2e; display: block; }
.car-price { font-size: 32rpx; font-weight: 700; color: #e53e3e; margin-top: 6rpx; display: block; }

/* ========== 客户信息 ========== */
.customer-row {
  display: flex; align-items: center; padding: 12rpx 0;
  border-bottom: 1rpx solid #f5f5f5;
}
.customer-row:last-child { border-bottom: none; }
.row-icon { font-size: 28rpx; margin-right: 12rpx; }
.customer-name { font-size: 28rpx; font-weight: 500; color: #1a1a2e; margin-right: 16rpx; }
.customer-phone { font-size: 26rpx; color: #888; flex: 1; }
.address-text { font-size: 24rpx; color: #666; flex: 1; }
.call-btn {
  padding: 10rpx 24rpx; border-radius: 20rpx;
  background: linear-gradient(135deg, #16a34a, #22c55e);
  color: #fff; font-size: 24rpx;
}
.call-btn-hover { opacity: 0.8; }

/* ========== 金额明细 ========== */
.amount-row {
  display: flex; justify-content: space-between; align-items: center;
  padding: 16rpx 0; border-bottom: 1rpx solid #f5f5f5;
}
.amount-row:last-child { border-bottom: none; }
.amount-label { font-size: 26rpx; color: #888; }
.amount-value { font-size: 28rpx; font-weight: 600; color: #333; }
.amount-value.deduct { color: #16a34a; }
.total-row { padding: 20rpx 0; border-bottom: 1rpx dashed #e0e0e0; }
.total-label { font-size: 28rpx; font-weight: 600; color: #1a1a2e; }
.total-value { font-size: 34rpx; font-weight: 700; color: #e53e3e; }
.paid-value { color: #16a34a; }

/* ========== 旧车信息 ========== */
.old-car-header {
  display: flex; justify-content: space-between; align-items: center;
  margin-bottom: 16rpx; padding-bottom: 16rpx; border-bottom: 1rpx solid #f5f5f5;
}
.old-car-name { font-size: 30rpx; font-weight: 600; color: #1a1a2e; }
.evaluate-tag {
  padding: 6rpx 16rpx; border-radius: 12rpx;
  background: #fef3c7; color: #d97706; font-size: 22rpx;
}
.eval-price { color: #7c3aed; font-weight: 600; }

/* ========== 底部操作栏 ========== */
.bottom-bar {
  position: fixed; bottom: 0; left: 0; right: 0;
  padding: 20rpx 28rpx; padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
  background: #fff; box-shadow: 0 -4rpx 20rpx rgba(0,0,0,0.06);
  z-index: 100;
}
.action-btns { display: flex; gap: 20rpx; }
.action-single { display: flex; }
.btn {
  flex: 1; height: 88rpx; border-radius: 44rpx;
  display: flex; align-items: center; justify-content: center;
  font-size: 30rpx; font-weight: 600;
}
.btn-cancel {
  background: #f1f5f9; color: #64748b;
}
.btn-cancel-hover { background: #e2e8f0; }
.btn-confirm {
  background: linear-gradient(135deg, #16a34a, #22c55e); color: #fff;
}
.btn-confirm-hover { opacity: 0.85; }
.btn-outline {
  background: #fff; color: #16a34a; border: 2rpx solid #16a34a;
}
.btn-outline-hover { background: #f0fdf4; }
.btn-primary {
  background: linear-gradient(135deg, #16a34a, #22c55e); color: #fff;
}
.btn-primary-hover { opacity: 0.85; }
.btn.full { flex: 1; }
</style>