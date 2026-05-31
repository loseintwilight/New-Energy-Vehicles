<template>
  <!-- ========== 加载页面：绿色小车动画 ========== -->
  <view v-if="pageLoading" class="car-loading-page">
    <view class="car-loading-content">
      <view class="car-scene">
        <!-- 绿色小车 -->
        <view class="car">
          <view class="car-top"></view>
          <view class="car-main">
            <view class="car-window w-front"></view>
            <view class="car-window w-rear"></view>
          </view>
          <view class="car-wheels">
            <view class="wheel"></view>
            <view class="wheel"></view>
          </view>
          <!-- 车灯 -->
          <view class="car-light front"></view>
          <view class="car-light rear"></view>
        </view>
        <!-- 公路 -->
        <view class="road">
          <view class="road-dash"></view>
        </view>
      </view>
      <view class="loading-text-wrap">
        <text class="loading-label">正在准备充电</text>
        <view class="loading-dots">
          <view class="dot" v-for="i in 3" :key="i"></view>
        </view>
      </view>
    </view>
  </view>

  <!-- ========== 主页面 ========== -->
  <view v-else class="charging-page">
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px', paddingRight: px2rpx(systemInfo.windowWidth - capsuleRight + 12) + 'rpx' }">
      <view class="nav-back" @click="onBack">
        <u-icon name="arrow-left" size="36" color="#fff"></u-icon>
      </view>
      <text class="nav-title">充电中</text>
      <view class="nav-spacer"></view>
    </view>

    <scroll-view class="charging-scroll" scroll-y :show-scrollbar="false">
      <!-- 充电已停止提示横幅 -->
      <view v-if="isStopped" class="stop-notice-banner">
        <u-icon name="info-circle" size="28" color="#ffc107"></u-icon>
        <text class="stop-notice-text">充电已停止，请及时支付费用</text>
        <view class="stop-notice-action" @click="openOrderPopup">
          <text>查看订单</text>
        </view>
      </view>

      <view class="battery-section">
        <view class="battery-card">
          <view class="battery-info">
            <text class="battery-label">{{ stationName || '充电站' }}</text>
            <text class="battery-number">充电桩: {{ pileNumber }}</text>
          </view>

          <view class="battery-body">
            <view class="battery-icon">
              <view class="battery-shell">
                <view class="battery-level" :style="{ height: chargePercent + '%' }">
                  <view class="battery-wave"></view>
                </view>
                <view class="battery-cap"></view>
              </view>
              <text class="battery-percent">{{ chargePercent }}%</text>
            </view>

            <view class="charge-data">
              <view class="data-item main">
                <text class="data-label">当前功率</text>
                <text class="data-value highlight">{{ realTimePower }}<text class="data-unit">kW</text></text>
              </view>
              <view class="data-row">
                <view class="data-item">
                  <text class="data-label">已充电量</text>
                  <text class="data-value">{{ chargedEnergy }}<text class="data-unit">度</text></text>
                </view>
                <view class="data-item">
                  <text class="data-label">已充时长</text>
                  <text class="data-value">{{ chargedTime }}</text>
                </view>
              </view>
              <view class="data-row">
                <view class="data-item">
                  <text class="data-label">已充金额</text>
                  <text class="data-value">¥{{ chargedAmount }}</text>
                </view>
                <view class="data-item">
                  <text class="data-label">目标电量</text>
                  <text class="data-value">{{ targetEnergy }}<text class="data-unit">度</text></text>
                </view>
              </view>
            </view>
          </view>
        </view>

        <view class="battery-progress">
          <view class="progress-bar">
            <view class="progress-fill" :style="{ width: chargePercent + '%' }"></view>
            <view class="progress-dot" :style="{ left: chargePercent + '%' }"></view>
          </view>
          <view class="progress-labels">
            <text>0%</text>
            <text>50%</text>
            <text>100%</text>
          </view>
        </view>

        <view class="charge-info-row">
          <view class="ci-item">
            <text class="ci-label">充电模式</text>
            <view class="ci-tag">
              <text>标准模式</text>
            </view>
          </view>
          <view class="ci-item">
            <text class="ci-label">预计结束</text>
            <text class="ci-value">{{ estimatedEndTime }}</text>
          </view>
        </view>
      </view>

      <view class="monitor-panel">
        <view class="monitor-header">
          <text class="monitor-title">实时监控</text>
          <view class="monitor-status" :class="{ normal: temperature < 45, warning: temperature >= 45 && temperature < 55, danger: temperature >= 55 }">
            <view class="status-indicator"></view>
            <text>{{ temperature < 45 ? '正常' : (temperature < 55 ? '温度偏高' : '温度过高') }}</text>
          </view>
        </view>

        <view class="monitor-grid">
          <view class="monitor-item">
            <text class="mi-label">电池温度</text>
            <text class="mi-value" :class="{ warning: temperature >= 45 }">{{ temperature }}°C</text>
          </view>
          <view class="monitor-item">
            <text class="mi-label">充电电流</text>
            <text class="mi-value">{{ current }}A</text>
          </view>
          <view class="monitor-item">
            <text class="mi-label">充电电压</text>
            <text class="mi-value">{{ voltage }}V</text>
          </view>
          <view class="monitor-item">
            <text class="mi-label">实时功率</text>
            <text class="mi-value highlight">{{ realTimePower }}kW</text>
          </view>
        </view>

        <view class="power-chart">
          <text class="chart-title">功率变化趋势</text>
          <view class="chart-area">
            <view
              v-for="(point, pi) in powerHistory"
              :key="pi"
              class="chart-point"
              :style="{ left: (pi / Math.max(powerHistory.length - 1, 1)) * 100 + '%', bottom: (point / maxPower) * 100 + '%' }"
            ></view>
            <view class="chart-line"></view>
          </view>
          <view class="chart-labels">
            <text>开始</text>
            <text>现在</text>
          </view>
        </view>
      </view>

      <view class="scroll-bottom-spacer"></view>
    </scroll-view>

    <!-- 底部操作栏：充电中显示停止按钮 -->
    <view class="bottom-bar" :style="{ paddingBottom: (16 + safeBottom) + 'px' }" v-if="!isStopped">
      <view class="bb-left">
        <text class="bb-estimate">预估费用: <text class="bb-price">¥{{ totalEstimate }}</text></text>
      </view>
      <view class="bb-right" @click="confirmStop">
        <text>停止充电</text>
      </view>
    </view>

    <!-- ========== 停止充电确认弹窗 ========== -->
    <uni-popup ref="stopConfirmPopup" type="center">
      <view class="stop-popup">
        <u-icon name="error-circle" size="80" color="#fa8c16"></u-icon>
        <text class="stop-title">确认停止充电？</text>
        <text class="stop-desc">当前已充电 {{ chargedEnergy }} 度，费用 ¥{{ chargedAmount }}</text>
        <view class="stop-btns">
          <button class="stop-cancel" @click="cancelStop">继续充电</button>
          <button class="stop-confirm" @click="doStop">确认停止</button>
        </view>
      </view>
    </uni-popup>

    <!-- ========== 订单弹窗（可关闭，稍后支付） ========== -->
    <uni-popup ref="orderPopup" type="center">
      <view class="order-popup">
        <!-- 关闭按钮 -->
        <view class="order-close" @click="closeOrderPopup">
          <u-icon name="close" size="36" color="#999"></u-icon>
        </view>

        <view class="order-header">
          <view class="order-icon-wrap">
            <u-icon name="checkmark-circle" size="60" color="#07c160"></u-icon>
          </view>
          <text class="order-title">充电完成</text>
          <text class="order-sub">请支付充电费用以完成订单</text>
        </view>

        <view class="order-detail">
          <view class="od-row">
            <text class="od-label">充电站点</text>
            <text class="od-value">{{ stationName }}</text>
          </view>
          <view class="od-row">
            <text class="od-label">充电桩编号</text>
            <text class="od-value">{{ pileNumber }}</text>
          </view>
          <view class="od-divider"></view>
          <view class="od-row">
            <text class="od-label">充电时长</text>
            <text class="od-value">{{ payData.duration }}</text>
          </view>
          <view class="od-row">
            <text class="od-label">充电度数</text>
            <text class="od-value">{{ payData.energy }} 度</text>
          </view>
          <view class="od-divider"></view>
          <view class="od-row">
            <text class="od-label">电费
              <text class="od-unit">(¥{{ price }}/度)</text>
            </text>
            <text class="od-value sub">¥{{ payData.electricFee }}</text>
          </view>
          <view class="od-row">
            <text class="od-label">服务费</text>
            <text class="od-value sub">¥{{ payData.serviceFee }}</text>
          </view>
          <view class="od-divider"></view>
          <view class="od-row total">
            <text class="od-label">合计</text>
            <text class="od-value highlight">¥{{ payData.total }}</text>
          </view>
        </view>

        <button class="order-pay-btn" @click="handlePay" :disabled="paying">
          <text v-if="!paying">确认支付 ¥{{ payData.total }}</text>
          <text v-else>支付中...</text>
        </button>
        <text class="order-later" @click="closeOrderPopup">暂不支付，稍后处理</text>
      </view>
    </uni-popup>
  </view>
</template>

<script>
import { startCharge, stopCharge } from '@/api/charge/station.js'
import safeAreaMixin from '@/mixins/safe-area.js'

export default {
  mixins: [safeAreaMixin],
  data() {
    return {
      systemInfo: uni.getSystemInfoSync(),

      // ====== 页面加载（小车动画） ======
      pageLoading: false,

      // ====== 充电参数 ======
      stationName: '',
      stationId: null,
      pileNumber: 'A01',
      targetEnergy: 30,
      price: 1.28,

      // ====== 充电数据 ======
      currentPower: 0,
      targetPower: 36,
      chargePercent: 0,
      realTimePower: '0.0',
      chargedEnergy: '0.0',
      chargedTime: '0分钟',
      chargedAmount: '0.00',
      totalEstimate: '0.00',

      // ====== 监控数据 ======
      temperature: 36,
      current: 60,
      voltage: 380,
      powerHistory: [],
      maxPower: 150,

      // ====== 充电状态 ======
      isCharging: false,
      isStopped: false,
      timer: null,
      monitorTimer: null,
      startTime: null,
      elapsedSeconds: 0,
      orderId: null,

      // ====== 订单 / 支付 ======
      paying: false,
      payData: {
        duration: '0分钟',
        energy: '0.0',
        electricFee: '0.00',
        serviceFee: '0.00',
        total: '0.00'
      }
    }
  },

  onLoad(options) {
    this.stationId = options.stationId
    this.stationName = decodeURIComponent(options.stationName || '充电站')
    this.targetEnergy = parseFloat(options.targetEnergy || 30)
    this.price = parseFloat(options.price || 1.28)
    if (options.pileNumber) this.pileNumber = options.pileNumber

    this.initCharge()
  },

  onUnload() {
    this.clearTimers()
  },

  methods: {
    /** 初始化充电 */
    async initCharge() {
      try {
        const res = await startCharge({
          stationId: this.stationId,
          pileNo: this.pileNumber,
          energy: this.targetEnergy
        })
        this.orderId = res.data?.orderId || 'ORD' + Date.now()
      } catch (e) {
        this.orderId = 'ORD' + Date.now()
      }

      this.isCharging = true
      this.startTime = Date.now()
      this.startPolling()
    },

    /** 开始轮询充电数据 */
    startPolling() {
      this.timer = setInterval(() => {
        if (this.isStopped) return
        if (this.currentPower < this.targetPower) {
          const increment = Math.floor(Math.random() * 2) + 1
          this.currentPower = Math.min(this.targetPower, this.currentPower + increment)
          this.updateChargeData()
          this.updateRealTimeParams()
          this.updateMonitorData()
        }

        if (this.currentPower >= this.targetPower) {
          this.autoStop()
        }
      }, 3000)

      this.monitorTimer = setInterval(() => {
        this.updateMonitorData()
      }, 2000)
    },

    /** 更新充电数据 */
    updateChargeData() {
      this.chargePercent = Math.round((this.currentPower / this.targetPower) * 100)
      const energy = (this.currentPower / 36) * this.targetEnergy
      this.chargedEnergy = energy.toFixed(1)
      this.chargedAmount = (parseFloat(this.chargedEnergy) * this.price).toFixed(2)

      this.elapsedSeconds = Math.floor((Date.now() - this.startTime) / 1000)
      if (this.elapsedSeconds < 60) {
        this.chargedTime = '1分钟'
      } else if (this.elapsedSeconds < 3600) {
        this.chargedTime = `${Math.floor(this.elapsedSeconds / 60)}分钟`
      } else {
        const h = Math.floor(this.elapsedSeconds / 3600)
        const m = Math.floor((this.elapsedSeconds % 3600) / 60)
        this.chargedTime = `${h}小时${m}分钟`
      }

      this.totalEstimate = (this.targetEnergy * this.price).toFixed(2)
      this.realTimePower = (20 + Math.random() * 40).toFixed(1)
    },

    /** 更新实时参数 */
    updateRealTimeParams() {
      this.current = Math.floor(58 + Math.random() * 20)
      this.voltage = Math.floor(370 + Math.random() * 20)
    },

    /** 更新监控数据 */
    updateMonitorData() {
      this.temperature = Math.floor(35 + Math.random() * 20)

      if (this.powerHistory.length > 30) {
        this.powerHistory.shift()
      }
      this.powerHistory.push(parseFloat(this.realTimePower))
      this.maxPower = Math.max(this.maxPower, ...this.powerHistory.map(p => p * 1.2))
    },

    /** 确认停止充电 */
    confirmStop() {
      if (this.$refs.stopConfirmPopup) this.$refs.stopConfirmPopup.open()
    },

    /** 取消停止 */
    cancelStop() {
      if (this.$refs.stopConfirmPopup) this.$refs.stopConfirmPopup.close()
    },

    /** 执行停止充电 → 弹出订单 */
    async doStop() {
      try {
        await stopCharge({ orderId: this.orderId })
      } catch (e) {
        console.log('[doStop] stopCharge error:', e)
      }

      if (this.$refs.stopConfirmPopup) this.$refs.stopConfirmPopup.close()
      this.clearTimers()
      this.isCharging = false
      this.isStopped = true

      // 准备支付数据
      const total = parseFloat(this.chargedAmount)
      const electricFee = (total * 0.7).toFixed(2)
      const serviceFee = (total * 0.3).toFixed(2)

      this.payData = {
        duration: this.chargedTime,
        energy: this.chargedEnergy,
        electricFee: electricFee,
        serviceFee: serviceFee,
        total: this.chargedAmount
      }

      // 弹出订单，让用户选择支付或稍后处理
      this.$nextTick(() => {
        if (this.$refs.orderPopup) this.$refs.orderPopup.open()
      })

      uni.showToast({ title: '充电已停止', icon: 'none', duration: 1500 })
    },

    /** 自动完成充电 → 弹出订单 */
    autoStop() {
      this.clearTimers()
      this.isCharging = false
      this.isStopped = true

      const total = parseFloat(this.chargedAmount)
      const electricFee = (total * 0.7).toFixed(2)
      const serviceFee = (total * 0.3).toFixed(2)

      this.payData = {
        duration: this.chargedTime,
        energy: this.chargedEnergy,
        electricFee: electricFee,
        serviceFee: serviceFee,
        total: this.chargedAmount
      }

      this.$nextTick(() => {
        if (this.$refs.orderPopup) this.$refs.orderPopup.open()
      })

      uni.showToast({ title: '充电已完成', icon: 'none', duration: 1500 })
    },

    /** 关闭订单弹窗 */
    closeOrderPopup() {
      if (this.$refs.orderPopup) this.$refs.orderPopup.close()
    },

    /** 重新打开订单弹窗 */
    openOrderPopup() {
      if (this.$refs.orderPopup) this.$refs.orderPopup.open()
    },

    /** 支付处理 */
    async handlePay() {
      if (this.paying) return
      this.paying = true

      try {
        await new Promise((resolve) => setTimeout(resolve, 1500))

        uni.showToast({ title: '支付成功', icon: 'success' })

        if (this.$refs.orderPopup) this.$refs.orderPopup.close()

        setTimeout(() => {
          uni.redirectTo({
            url: `/pages/charge/detail?stationId=${this.stationId}&name=${encodeURIComponent(this.stationName)}`
          })
        }, 1000)
      } catch (e) {
        uni.showToast({ title: '支付失败，请重试', icon: 'none' })
      } finally {
        this.paying = false
      }
    },

    /** 清除定时器 */
    clearTimers() {
      if (this.timer) {
        clearInterval(this.timer)
        this.timer = null
      }
      if (this.monitorTimer) {
        clearInterval(this.monitorTimer)
        this.monitorTimer = null
      }
    },

    /** 返回上一页 */
    onBack() {
      if (this.isCharging && !this.isStopped) {
        this.confirmStop()
        return
      }
      if (this.isStopped) {
        uni.showModal({
          title: '提示',
          content: '订单尚未支付，确定要返回吗？',
          success: (res) => {
            if (res.confirm) uni.navigateBack()
          }
        })
        return
      }
      uni.navigateBack()
    }
  },

  computed: {
    chargeStatus() {
      if (this.isStopped) return 'stopped'
      if (this.currentPower >= this.targetPower && this.isCharging) return 'complete'
      if (this.isCharging) return 'charging'
      return 'idle'
    },

    estimatedEndTime() {
      const remaining = ((this.targetPower - this.currentPower) / this.targetPower) * this.targetEnergy
      if (remaining <= 0) return '即将完成'
      const avgPower = parseFloat(this.realTimePower) || 60
      if (avgPower <= 0) return '计算中...'
      const minutes = Math.ceil((remaining / avgPower) * 60)
      const now = new Date()
      now.setMinutes(now.getMinutes() + minutes)
      return `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`
    }
  }
}
</script>

<style lang="scss" scoped>
/* =====================================================
   🚗 小车加载动画（替代骨架屏）
   ===================================================== */
.car-loading-page {
  height: 100vh;
  background: linear-gradient(180deg, #0d2a1a 0%, #123a22 50%, #0d2e1a 100%);
  display: flex;
  align-items: center;
  justify-content: center;
}

.car-loading-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 80%;
}

/* --- 小车场景 --- */
.car-scene {
  position: relative;
  width: 100%;
  height: 200rpx;
  overflow: hidden;
  margin-bottom: 60rpx;
}

/* 公路 */
.road {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 6rpx;
  background: rgba(255, 255, 255, 0.15);
  border-radius: 3rpx;

  .road-dash {
    position: absolute;
    top: 0;
    left: 0;
    height: 100%;
    width: 200%;
    background: repeating-linear-gradient(
      90deg,
      rgba(255, 255, 255, 0.4) 0rpx,
      rgba(255, 255, 255, 0.4) 30rpx,
      transparent 30rpx,
      transparent 60rpx
    );
    animation: roadMove 0.8s linear infinite;
  }
}

/* 绿色小车 */
.car {
  position: absolute;
  bottom: 12rpx;
  left: -180rpx;
  width: 160rpx;
  height: 80rpx;
  animation: carDrive 2.5s ease-in-out infinite;

  /* 车顶 */
  .car-top {
    position: absolute;
    top: 0;
    left: 30rpx;
    right: 30rpx;
    height: 30rpx;
    background: linear-gradient(135deg, #07c160, #5ae09e);
    border-radius: 18rpx 18rpx 0 0;
    z-index: 2;
  }

  /* 车身 */
  .car-main {
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    height: 50rpx;
    background: linear-gradient(135deg, #07c160, #06ad56);
    border-radius: 10rpx 10rpx 16rpx 16rpx;
    z-index: 1;
    display: flex;
    align-items: center;
    justify-content: space-around;

    .car-window {
      width: 30rpx;
      height: 22rpx;
      background: rgba(255, 255, 255, 0.3);
      border-radius: 4rpx;

      &.w-front { margin-left: 10rpx; }
      &.w-rear { margin-right: 10rpx; }
    }
  }

  /* 车轮 */
  .car-wheels {
    position: absolute;
    bottom: -10rpx;
    left: 0;
    right: 0;
    display: flex;
    justify-content: space-around;
    z-index: 3;

    .wheel {
      width: 20rpx;
      height: 20rpx;
      background: #333;
      border: 4rpx solid #555;
      border-radius: 50%;

      &:first-child { margin-left: 20rpx; }
      &:last-child { margin-right: 20rpx; }
    }
  }

  /* 车灯 */
  .car-light {
    position: absolute;
    bottom: 8rpx;
    width: 8rpx;
    height: 8rpx;
    border-radius: 50%;
    z-index: 2;

    &.front {
      right: -4rpx;
      background: #ffc107;
      box-shadow: 0 0 12rpx 4rpx rgba(255, 193, 7, 0.4);
      animation: lightFlash 0.6s ease-in-out infinite alternate;
    }

    &.rear {
      left: -4rpx;
      background: #ff4d4f;
      box-shadow: 0 0 8rpx 2rpx rgba(255, 77, 79, 0.3);
    }
  }
}

/* --- 加载文字 --- */
.loading-text-wrap {
  display: flex;
  align-items: center;
  justify-content: center;

  .loading-label {
    font-size: 28rpx;
    color: rgba(255, 255, 255, 0.6);
  }

  .loading-dots {
    display: flex;
    gap: 8rpx;
    margin-left: 8rpx;

    .dot {
      width: 10rpx;
      height: 10rpx;
      border-radius: 50%;
      background: rgba(7, 193, 96, 0.6);
      animation: dotPulse 1.2s ease-in-out infinite;

      &:nth-child(1) { animation-delay: 0s; }
      &:nth-child(2) { animation-delay: 0.4s; }
      &:nth-child(3) { animation-delay: 0.8s; }
    }
  }
}

/* =====================================================
   主页面
   ===================================================== */
.charging-page {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background: linear-gradient(180deg, #0d2a1a 0%, #123a22 50%, #0d2e1a 100%);
  color: #fff;
}

/* =====================================================
   顶部导航栏
   ===================================================== */
.nav-bar {
  position: relative;
  display: flex;
  align-items: center;
  padding: 14rpx 24rpx;
  background: rgba(13, 42, 26, 0.95);

  .nav-back {
    width: 60rpx;
    height: 60rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
  }

  .nav-title {
    flex: 1;
    text-align: center;
    font-size: 32rpx;
    font-weight: 700;
  }

  .nav-spacer {
    width: 60rpx;
    flex-shrink: 0;
  }
}

/* =====================================================
   充电已停止提示横幅
   ===================================================== */
.stop-notice-banner {
  display: flex;
  align-items: center;
  gap: 10rpx;
  padding: 16rpx 24rpx;
  background: rgba(255, 193, 7, 0.12);
  border-radius: 12rpx;
  margin-bottom: 20rpx;

  .stop-notice-text {
    flex: 1;
    font-size: 26rpx;
    color: #ffc107;
    font-weight: 500;
  }

  .stop-notice-action {
    flex-shrink: 0;
    padding: 6rpx 20rpx;
    border: 1rpx solid rgba(255, 193, 7, 0.4);
    border-radius: 24rpx;

    text {
      font-size: 22rpx;
      color: #ffc107;
    }
  }
}

/* =====================================================
   滚动区域
   ===================================================== */
.charging-scroll {
  flex: 1;
  padding: 20rpx 24rpx 140rpx;
  background: linear-gradient(180deg, #0d2a1a 0%, #123a22 50%, #0d2e1a 100%);
}

.scroll-bottom-spacer {
  height: 40rpx;
}

/* =====================================================
   电池信息区
   ===================================================== */
.battery-section {
  margin-bottom: 24rpx;

  .battery-card {
    background: rgba(255, 255, 255, 0.06);
    border-radius: 20rpx;
    padding: 28rpx;
    backdrop-filter: blur(20px);
    border: 1rpx solid rgba(255, 255, 255, 0.08);

    .battery-info {
      .battery-label {
        font-size: 28rpx;
        font-weight: 600;
        color: rgba(255, 255, 255, 0.9);
        display: block;
      }

      .battery-number {
        font-size: 22rpx;
        color: rgba(255, 255, 255, 0.5);
        margin-top: 6rpx;
        display: block;
      }
    }

    .battery-body {
      display: flex;
      margin-top: 28rpx;
      gap: 32rpx;

      .battery-icon {
        display: flex;
        flex-direction: column;
        align-items: center;
        width: 120rpx;

        .battery-shell {
          width: 80rpx;
          height: 160rpx;
          border: 4rpx solid rgba(255, 255, 255, 0.3);
          border-radius: 14rpx;
          position: relative;
          overflow: hidden;

          .battery-level {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(0deg, #07c160, #5ae09e);
            transition: height 0.5s ease;
            border-radius: 0 0 8rpx 8rpx;

            .battery-wave {
              position: absolute;
              top: -10rpx;
              left: -10rpx;
              right: -10rpx;
              height: 20rpx;
              background: rgba(255, 255, 255, 0.3);
              border-radius: 50%;
              animation: wave 2s ease-in-out infinite;
            }
          }

          .battery-cap {
            position: absolute;
            top: -12rpx;
            left: 50%;
            transform: translateX(-50%);
            width: 30rpx;
            height: 10rpx;
            background: rgba(255, 255, 255, 0.3);
            border-radius: 4rpx 4rpx 0 0;
          }
        }

        .battery-percent {
          font-size: 30rpx;
          font-weight: 800;
          color: #07c160;
          margin-top: 12rpx;
        }
      }

      .charge-data {
        flex: 1;

        .data-item {
          &.main {
            margin-bottom: 20rpx;
            background: rgba(7, 193, 96, 0.1);
            border-radius: 12rpx;
            padding: 16rpx 20rpx;
            text-align: center;
          }

          .data-label {
            font-size: 22rpx;
            color: rgba(255, 255, 255, 0.5);
            display: block;
          }

          .data-value {
            font-size: 28rpx;
            font-weight: 700;
            color: rgba(255, 255, 255, 0.9);
            margin-top: 6rpx;
            display: block;

            &.highlight {
              font-size: 48rpx;
              color: #07c160;
            }

            .data-unit {
              font-size: 22rpx;
              font-weight: 400;
              color: rgba(255, 255, 255, 0.5);
              margin-left: 4rpx;
            }
          }
        }

        .data-row {
          display: flex;
          gap: 16rpx;
          margin-top: 12rpx;

          .data-item {
            flex: 1;
            background: rgba(255, 255, 255, 0.04);
            border-radius: 10rpx;
            padding: 12rpx 16rpx;
            text-align: center;

            .data-value {
              font-size: 32rpx;
            }
          }
        }
      }
    }
  }

  .battery-progress {
    margin-top: 24rpx;

    .progress-bar {
      position: relative;
      height: 8rpx;
      background: rgba(255, 255, 255, 0.1);
      border-radius: 4rpx;

      .progress-fill {
        height: 100%;
        background: linear-gradient(90deg, #07c160, #5ae09e);
        border-radius: 4rpx;
        transition: width 0.5s ease;
      }

      .progress-dot {
        position: absolute;
        top: 50%;
        transform: translate(-50%, -50%);
        width: 20rpx;
        height: 20rpx;
        background: #07c160;
        border-radius: 50%;
        box-shadow: 0 0 20rpx rgba(7, 193, 96, 0.6);
        transition: left 0.5s ease;
      }
    }

    .progress-labels {
      display: flex;
      justify-content: space-between;
      margin-top: 8rpx;

      text {
        font-size: 20rpx;
        color: rgba(255, 255, 255, 0.4);
      }
    }
  }

  .charge-info-row {
    display: flex;
    gap: 16rpx;
    margin-top: 20rpx;

    .ci-item {
      flex: 1;
      background: rgba(255, 255, 255, 0.04);
      border-radius: 12rpx;
      padding: 16rpx;
      text-align: center;

      .ci-label {
        font-size: 22rpx;
        color: rgba(255, 255, 255, 0.5);
        display: block;
        margin-bottom: 8rpx;
      }

      .ci-tag {
        display: inline-block;
        padding: 6rpx 20rpx;
        background: rgba(7, 193, 96, 0.15);
        border-radius: 20rpx;
        text { font-size: 24rpx; color: #07c160; }
      }

      .ci-value {
        font-size: 26rpx;
        color: rgba(255, 255, 255, 0.8);
      }
    }
  }
}

/* =====================================================
   实时监控面板
   ===================================================== */
.monitor-panel {
  background: rgba(255, 255, 255, 0.06);
  border-radius: 20rpx;
  padding: 28rpx;
  margin-bottom: 24rpx;
  backdrop-filter: blur(20px);
  border: 1rpx solid rgba(255, 255, 255, 0.08);

  .monitor-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 20rpx;

    .monitor-title {
      font-size: 28rpx;
      font-weight: 600;
      color: rgba(255, 255, 255, 0.9);
    }

    .monitor-status {
      display: flex;
      align-items: center;
      gap: 8rpx;
      padding: 6rpx 16rpx;
      border-radius: 20rpx;
      font-size: 22rpx;

      &.normal { background: rgba(7, 193, 96, 0.15); color: #07c160; }
      &.warning { background: rgba(250, 140, 22, 0.15); color: #fa8c16; }
      &.danger { background: rgba(245, 34, 45, 0.15); color: #ff4d4f; }

      .status-indicator {
        width: 12rpx;
        height: 12rpx;
        border-radius: 50%;
        background: currentColor;
        animation: pulse 1.5s ease-in-out infinite;
      }
    }
  }

  .monitor-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 16rpx;

    .monitor-item {
      background: rgba(255, 255, 255, 0.04);
      border-radius: 12rpx;
      padding: 20rpx;
      text-align: center;

      .mi-label {
        font-size: 22rpx;
        color: rgba(255, 255, 255, 0.5);
        display: block;
        margin-bottom: 8rpx;
      }

      .mi-value {
        font-size: 36rpx;
        font-weight: 700;
        color: rgba(255, 255, 255, 0.9);

        &.warning { color: #fa8c16; }
        &.highlight { color: #07c160; }
      }
    }
  }

  .power-chart {
    margin-top: 28rpx;

    .chart-title {
      font-size: 22rpx;
      color: rgba(255, 255, 255, 0.5);
      display: block;
      margin-bottom: 16rpx;
    }

    .chart-area {
      position: relative;
      height: 140rpx;
      background: rgba(255, 255, 255, 0.03);
      border-radius: 8rpx;
      margin-bottom: 12rpx;

      .chart-line {
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        height: 2rpx;
        background: rgba(255, 255, 255, 0.05);
      }

      .chart-point {
        position: absolute;
        width: 8rpx;
        height: 8rpx;
        background: #07c160;
        border-radius: 50%;
        transform: translate(-50%, 50%);
        box-shadow: 0 0 12rpx rgba(7, 193, 96, 0.4);
      }
    }

    .chart-labels {
      display: flex;
      justify-content: space-between;
      text { font-size: 20rpx; color: rgba(255, 255, 255, 0.3); }
    }
  }
}

/* =====================================================
   订单悬浮入口（停止后显示）
   ===================================================== */
.order-entry-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10rpx;
  padding: 20rpx;
  background: rgba(7, 193, 96, 0.06);
  border: 1rpx dashed rgba(7, 193, 96, 0.3);
  border-radius: 16rpx;
  margin-top: 10rpx;

  text {
    font-size: 26rpx;
    color: #07c160;
    font-weight: 500;
  }
}

/* =====================================================
   底部操作栏（充电中）
   ===================================================== */
.bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  align-items: center;
  padding: 16rpx 24rpx;
  background: rgba(13, 42, 26, 0.95);
  backdrop-filter: blur(20px);

  .bb-left {
    flex: 1;

    .bb-estimate {
      font-size: 24rpx;
      color: rgba(255, 255, 255, 0.6);

      .bb-price {
        font-size: 28rpx;
        font-weight: 700;
        color: #ffa940;
      }
    }
  }

  .bb-right {
    padding: 0 48rpx;
    height: 76rpx;
    line-height: 76rpx;
    background: linear-gradient(135deg, #ff4d4f, #ff7875);
    border-radius: 38rpx;
    font-size: 28rpx;
    color: #fff;
    font-weight: 500;
    text-align: center;
    &:active { opacity: 0.9; }
  }
}

/* =====================================================
   停止充电确认弹窗
   ===================================================== */
.stop-popup {
  background: rgba(20, 40, 28, 0.98);
  border-radius: 20rpx;
  padding: 48rpx 36rpx 36rpx;
  width: 540rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  backdrop-filter: blur(20px);
  border: 1rpx solid rgba(255, 255, 255, 0.08);

  .stop-title {
    font-size: 34rpx;
    font-weight: 700;
    color: rgba(255, 255, 255, 0.95);
    margin: 20rpx 0 12rpx;
  }

  .stop-desc {
    font-size: 26rpx;
    color: rgba(255, 255, 255, 0.5);
    text-align: center;
    margin-bottom: 32rpx;
  }

  .stop-btns {
    display: flex;
    gap: 20rpx;
    width: 100%;

    button {
      flex: 1;
      height: 72rpx;
      line-height: 72rpx;
      font-size: 26rpx;
      border-radius: 36rpx;
    }

    .stop-cancel {
      background: rgba(255, 255, 255, 0.08);
      color: rgba(255, 255, 255, 0.8);
    }

    .stop-confirm {
      background: linear-gradient(135deg, #ff4d4f, #ff7875);
      color: #fff;
    }
  }
}

/* =====================================================
   订单弹窗（可关闭，稍后支付）
   ===================================================== */
.order-popup {
  position: relative;
  background: rgba(20, 40, 28, 0.98);
  border-radius: 28rpx;
  padding: 48rpx 36rpx 36rpx;
  width: 600rpx;
  max-height: 85vh;
  overflow-y: auto;
  backdrop-filter: blur(20px);
  border: 1rpx solid rgba(255, 255, 255, 0.08);

  .order-close {
    position: absolute;
    top: 20rpx;
    right: 20rpx;
    width: 56rpx;
    height: 56rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(255, 255, 255, 0.08);
    border-radius: 50%;
    z-index: 2;
  }

  .order-header {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-bottom: 32rpx;

    .order-icon-wrap {
      width: 80rpx;
      height: 80rpx;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 12rpx;
    }

    .order-title {
      font-size: 34rpx;
      font-weight: 700;
      color: rgba(255, 255, 255, 0.95);
      margin-bottom: 8rpx;
    }

    .order-sub {
      font-size: 24rpx;
      color: rgba(255, 255, 255, 0.5);
    }
  }

  .order-detail {
    background: rgba(255, 255, 255, 0.04);
    border-radius: 16rpx;
    padding: 24rpx;
    margin-bottom: 28rpx;

    .od-row {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 12rpx 0;

      .od-label {
        font-size: 26rpx;
        color: rgba(255, 255, 255, 0.6);
        display: flex;
        align-items: baseline;
        gap: 6rpx;

        .od-unit {
          font-size: 20rpx;
          color: rgba(255, 255, 255, 0.35);
        }
      }

      .od-value {
        font-size: 28rpx;
        color: rgba(255, 255, 255, 0.9);
        font-weight: 500;

        &.sub { color: rgba(255, 255, 255, 0.6); font-weight: 400; }

        &.highlight {
          font-size: 36rpx;
          font-weight: 800;
          color: #07c160;
        }
      }

      &.total {
        .od-label { font-size: 28rpx; color: rgba(255, 255, 255, 0.95); font-weight: 600; }
      }
    }

    .od-divider {
      height: 1rpx;
      background: rgba(255, 255, 255, 0.06);
      margin: 4rpx 0;
    }
  }

  .order-pay-btn {
    width: 100%;
    height: 88rpx;
    line-height: 88rpx;
    background: linear-gradient(135deg, #07c160, #06ad56);
    color: #fff;
    font-size: 32rpx;
    font-weight: 700;
    border-radius: 44rpx;
    border: none;
    box-shadow: 0 4rpx 24rpx rgba(7, 193, 96, 0.3);

    &:active { opacity: 0.85; }
    &[disabled] { opacity: 0.6; }
  }

  .order-later {
    display: block;
    text-align: center;
    font-size: 26rpx;
    color: rgba(255, 255, 255, 0.4);
    margin-top: 24rpx;
    padding: 12rpx;

    &:active { color: #07c160; }
  }
}

/* =====================================================
   Keyframe 动画
   ===================================================== */

/* 小车从左到右行驶 */
@keyframes carDrive {
  0%   { transform: translateX(-180rpx); }
  50%  { transform: translateX(calc(80vw + 180rpx)); }
  100% { transform: translateX(-180rpx); }
}

/* 公路虚线移动 */
@keyframes roadMove {
  0%   { transform: translateX(0); }
  100% { transform: translateX(-50%); }
}

/* 前车灯闪烁 */
@keyframes lightFlash {
  0%   { opacity: 0.4; }
  100% { opacity: 1; }
}

/* 加载点闪烁 */
@keyframes dotPulse {
  0%, 100% { opacity: 0.2; transform: scale(0.8); }
  50%      { opacity: 1; transform: scale(1.2); }
}

/* 电池波浪 */
@keyframes wave {
  0%, 100% { transform: translateY(0) scaleY(1); }
  50% { transform: translateY(-6rpx) scaleY(1.2); }
}

/* 状态指示灯脉冲 */
@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.3; }
}
</style>
