<template>
  <view class="fault-page">
    <charge-header />
    <view class="nav-bar">
      <view class="nav-back" @click="goBack">
        <u-icon name="arrow-left" size="36" color="#333"></u-icon>
      </view>
      <text class="nav-title">故障诊断</text>
    </view>

    <scroll-view class="fault-scroll" scroll-y>
      <view class="status-card" :class="overallStatus">
        <view class="status-icon">
          <u-icon :name="overallStatus === 'normal' ? 'checkbox-mark' : 'error-circle'" :size="80" :color="overallStatus === 'normal' ? '#07c160' : '#fa8c16'"></u-icon>
        </view>
        <text class="status-title">{{ overallStatus === 'normal' ? '车辆状态正常' : '存在异常项' }}</text>
        <text class="status-desc">最近一次诊断: {{ lastDiagnoseTime }}</text>
        <view class="status-btn" @click="startDiagnose" v-if="!isDiagnosing">
          <text>{{ overallStatus === 'normal' ? '重新诊断' : '开始诊断' }}</text>
        </view>
        <view class="status-btn diagnosing" v-else>
          <text>诊断中...</text>
        </view>
      </view>

      <view class="diagnose-progress" v-if="isDiagnosing">
        <view class="progress-bar">
          <view class="progress-fill" :style="{ width: diagnoseProgress + '%' }"></view>
        </view>
        <text class="progress-text">{{ diagnoseProgress }}%</text>
      </view>

      <view class="section-title">系统检测项</view>

      <view
        v-for="(item, i) in diagnoseItems"
        :key="i"
        class="diagnose-item"
        :class="'status-' + item.status"
      >
        <view class="di-left">
          <view class="di-icon" :class="item.status">
            <u-icon :name="item.icon" size="36" :color="iconColor(item.status)"></u-icon>
          </view>
          <view class="di-info">
            <text class="di-name">{{ item.name }}</text>
            <text class="di-desc">{{ item.desc }}</text>
          </view>
        </view>
        <view class="di-right">
          <view class="di-badge" :class="item.status">
            <text>{{ item.statusText }}</text>
          </view>
        </view>
      </view>

      <view class="section-title" v-if="faultHistory.length > 0">历史故障记录</view>

      <view
        v-for="(record, ri) in faultHistory"
        :key="ri"
        class="history-card"
      >
        <view class="hc-header">
          <text class="hc-name">{{ record.name }}</text>
          <text class="hc-status" :class="record.status">{{ record.statusText }}</text>
        </view>
        <text class="hc-time">{{ record.time }}</text>
        <text class="hc-desc">{{ record.desc }}</text>
      </view>

      <view class="action-row">
        <view class="action-btn" @click="callService">
          <u-icon name="phone" size="32" color="#1890ff"></u-icon>
          <text>联系客服</text>
        </view>
        <view class="action-btn" @click="viewManual">
          <u-icon name="list" size="32" color="#07c160"></u-icon>
          <text>使用指南</text>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script>
import safeAreaMixin from '@/mixins/safe-area.js'
import ChargeHeader from '@/components/charge-header/charge-header.vue'

export default {
  mixins: [safeAreaMixin],
  components: { ChargeHeader },
  data() {
    return {
      chargeStatus: 'idle',
      isDiagnosing: false,
      diagnoseProgress: 0,
      lastDiagnoseTime: '2026-05-29 14:30',
      overallStatus: 'normal',
      diagnoseTimer: null,
      diagnoseItems: [
        { name: '电池系统', desc: '电池健康度 92%，状态良好', icon: 'checkmark-circle', status: 'normal', statusText: '正常' },
        { name: '充电接口', desc: '接口无异常，接触良好', icon: 'checkmark-circle', status: 'normal', statusText: '正常' },
        { name: 'BMS 通讯', desc: '通讯正常，延迟 12ms', icon: 'checkmark-circle', status: 'normal', statusText: '正常' },
        { name: '温度传感器', desc: '传感器工作正常', icon: 'checkmark-circle', status: 'normal', statusText: '正常' },
        { name: '接地保护', desc: '接地电阻 0.3Ω，符合标准', icon: 'checkmark-circle', status: 'normal', statusText: '正常' },
        { name: '漏电保护', desc: '漏电保护装置正常', icon: 'checkmark-circle', status: 'normal', statusText: '正常' }
      ],
      faultHistory: [
        { name: '充电中断异常', status: 'resolved', statusText: '已解决', time: '2026-05-25 18:20', desc: '充电过程中意外中断，经检查为充电枪未插紧导致，重新插拔后恢复正常。' },
        { name: '通讯超时告警', status: 'resolved', statusText: '已忽略', time: '2026-05-20 09:15', desc: 'BMS 通讯短暂超时，系统自动恢复，未影响正常充电。' }
      ]
    }
  },

  onLoad(options) {
    this.chargeStatus = options.chargeStatus || 'idle'
    if (this.chargeStatus === 'charging' || this.chargeStatus === 'paused') {
      uni.showToast({ title: '充电过程中无法执行完整故障诊断，请充电结束后再操作', icon: 'none', duration: 2000 })
      setTimeout(() => uni.navigateBack(), 2200)
      return
    }
    this.simulateDiagnose()
  },

  onUnload() {
    if (this.diagnoseTimer) {
      clearInterval(this.diagnoseTimer)
    }
  },

  methods: {
    goBack() {
      uni.navigateBack()
    },

    iconColor(status) {
      if (status === 'normal') return '#07c160'
      if (status === 'warning') return '#fa8c16'
      return '#ff4d4f'
    },

    startDiagnose() {
      this.isDiagnosing = true
      this.diagnoseProgress = 0
      this.simulateDiagnose()
    },

    simulateDiagnose() {
      this.diagnoseTimer = setInterval(() => {
        this.diagnoseProgress += Math.floor(Math.random() * 8) + 3
        if (this.diagnoseProgress >= 100) {
          this.diagnoseProgress = 100
          clearInterval(this.diagnoseTimer)
          this.diagnoseTimer = null
          setTimeout(() => {
            this.isDiagnosing = false
            this.overallStatus = 'normal'
            this.lastDiagnoseTime = new Date().toLocaleString('zh-CN', { hour12: false }).replace(/\//g, '-')
            uni.showToast({ title: '诊断完成，状态正常', icon: 'success' })
          }, 500)
        }
      }, 400)
    },

    callService() {
      uni.makePhoneCall({ phoneNumber: '400-123-4567' })
    },

    viewManual() {
      uni.showToast({ title: '使用指南开发中', icon: 'none' })
    }
  }
}
</script>

<style lang="scss" scoped>
.fault-page {
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

  .nav-back {
    width: 60rpx;
    height: 60rpx;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .nav-title {
    flex: 1;
    text-align: center;
    font-size: 32rpx;
    font-weight: 700;
    color: #1a1a1a;
  }
}

.fault-scroll {
  flex: 1;
  padding: 20rpx 24rpx 40rpx;
}

.status-card {
  background: #fff;
  border-radius: 20rpx;
  padding: 40rpx 32rpx;
  text-align: center;
  margin-bottom: 24rpx;
  box-shadow: 0 2rpx 16rpx rgba(0, 0, 0, 0.04);

  &.warning {
    border: 2rpx solid #fa8c16;
  }

  .status-icon {
    margin-bottom: 16rpx;
  }

  .status-title {
    font-size: 34rpx;
    font-weight: 700;
    color: #1a1a1a;
    display: block;
  }

  .status-desc {
    font-size: 24rpx;
    color: #999;
    margin-top: 8rpx;
    display: block;
  }

  .status-btn {
    margin-top: 24rpx;
    display: inline-block;
    padding: 16rpx 56rpx;
    background: linear-gradient(135deg, #07c160, #06ad56);
    border-radius: 36rpx;

    text {
      font-size: 28rpx;
      color: #fff;
      font-weight: 500;
    }

    &.diagnosing {
      background: #e8f8ee;
      text { color: #07c160; }
    }
  }
}

.diagnose-progress {
  display: flex;
  align-items: center;
  gap: 16rpx;
  margin-bottom: 24rpx;

  .progress-bar {
    flex: 1;
    height: 8rpx;
    background: #f0f0f0;
    border-radius: 4rpx;
    overflow: hidden;

    .progress-fill {
      height: 100%;
      background: linear-gradient(90deg, #07c160, #5ae09e);
      border-radius: 4rpx;
      transition: width 0.3s ease;
    }
  }

  .progress-text {
    font-size: 24rpx;
    color: #07c160;
    font-weight: 600;
    min-width: 48rpx;
    text-align: right;
  }
}

.section-title {
  font-size: 28rpx;
  font-weight: 700;
  color: #333;
  margin: 20rpx 0 16rpx;
  display: block;
}

.diagnose-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: #fff;
  border-radius: 14rpx;
  padding: 24rpx 20rpx;
  margin-bottom: 12rpx;

  &.status-warning {
    border-left: 6rpx solid #fa8c16;
  }

  &.status-error {
    border-left: 6rpx solid #ff4d4f;
  }

  .di-left {
    display: flex;
    align-items: center;
    gap: 16rpx;

    .di-icon {
      width: 56rpx;
      height: 56rpx;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;

      &.normal { background: #e8f8ee; }
      &.warning { background: #fff7e6; }
      &.error { background: #fff1f0; }
    }

    .di-info {
      .di-name {
        font-size: 28rpx;
        font-weight: 600;
        color: #1a1a1a;
        display: block;
      }

      .di-desc {
        font-size: 22rpx;
        color: #888;
        margin-top: 4rpx;
        display: block;
      }
    }
  }

  .di-right {
    .di-badge {
      padding: 6rpx 18rpx;
      border-radius: 20rpx;
      font-size: 22rpx;
      font-weight: 500;

      &.normal { color: #07c160; background: #e8f8ee; }
      &.warning { color: #fa8c16; background: #fff7e6; }
      &.error { color: #ff4d4f; background: #fff1f0; }
    }
  }
}

.history-card {
  background: #fff;
  border-radius: 14rpx;
  padding: 24rpx 20rpx;
  margin-bottom: 12rpx;

  .hc-header {
    display: flex;
    align-items: center;
    justify-content: space-between;

    .hc-name {
      font-size: 26rpx;
      font-weight: 600;
      color: #333;
    }

    .hc-status {
      font-size: 22rpx;
      padding: 4rpx 14rpx;
      border-radius: 4rpx;

      &.resolved { color: #07c160; background: #e8f8ee; }
    }
  }

  .hc-time {
    font-size: 22rpx;
    color: #bbb;
    margin-top: 8rpx;
    display: block;
  }

  .hc-desc {
    font-size: 24rpx;
    color: #666;
    margin-top: 8rpx;
    line-height: 1.6;
    display: block;
  }
}

.action-row {
  display: flex;
  gap: 20rpx;
  margin-top: 32rpx;
  padding-bottom: 40rpx;

  .action-btn {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 12rpx;
    height: 80rpx;
    background: #fff;
    border-radius: 40rpx;
    box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.04);

    text {
      font-size: 26rpx;
      font-weight: 500;
      color: #333;
    }

    &:active { opacity: 0.8; }
  }
}
</style>