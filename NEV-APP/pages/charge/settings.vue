<template>
  <view class="settings-page">
    <charge-header />
    <view class="nav-bar">
      <view class="nav-back" @click="goBack">
        <u-icon name="arrow-left" size="36" color="#333"></u-icon>
      </view>
      <text class="nav-title">充电设置</text>
    </view>

    <scroll-view class="settings-scroll" scroll-y>
      <view class="settings-group">
        <text class="group-title">充电参数</text>

        <view class="setting-item">
          <view class="si-left">
            <text class="si-label">最大充电功率</text>
            <text class="si-desc">限制充电功率以避免电路过载</text>
          </view>
          <view class="si-right">
            <view class="si-value" @click="showPowerPicker">
              <text>{{ settings.maxPower }}kW</text>
              <u-icon name="arrow-right" size="24" color="#ccc"></u-icon>
            </view>
          </view>
        </view>

        <view class="setting-item">
          <view class="si-left">
            <text class="si-label">目标充电电量</text>
            <text class="si-desc">达到目标电量后自动停止充电</text>
          </view>
          <view class="si-right">
            <view class="si-value" @click="showSOCOptions = true">
              <text>{{ settings.targetSOC }}%</text>
              <u-icon name="arrow-right" size="24" color="#ccc"></u-icon>
            </view>
          </view>
        </view>

        <view class="setting-item">
          <view class="si-left">
            <text class="si-label">预约充电时间</text>
            <text class="si-desc">设置定时开始充电</text>
          </view>
          <view class="si-right">
            <switch :checked="settings.scheduledCharge" color="#07c160" @change="toggleScheduled" />
          </view>
        </view>

        <view class="setting-item" v-if="settings.scheduledCharge">
          <view class="si-left">
            <text class="si-label">开始时间</text>
          </view>
          <view class="si-right">
            <picker mode="time" :value="settings.scheduleTime" @change="onTimeChange">
              <view class="si-value">
                <text>{{ settings.scheduleTime }}</text>
                <u-icon name="arrow-right" size="24" color="#ccc"></u-icon>
              </view>
            </picker>
          </view>
        </view>
      </view>

      <view class="settings-group">
        <text class="group-title">充电偏好</text>

        <view class="setting-item">
          <view class="si-left">
            <text class="si-label">优先使用快充桩</text>
            <text class="si-desc">自动筛选快充桩优先</text>
          </view>
          <view class="si-right">
            <switch :checked="settings.preferFastCharge" color="#07c160" @change="toggleFastCharge" />
          </view>
        </view>

        <view class="setting-item">
          <view class="si-left">
            <text class="si-label">夜间错峰充电</text>
            <text class="si-desc">利用低谷电价时段充电更省钱</text>
          </view>
          <view class="si-right">
            <switch :checked="settings.nightCharge" color="#07c160" @change="toggleNightCharge" />
          </view>
        </view>

        <view class="setting-item" v-if="settings.nightCharge">
          <view class="si-left">
            <text class="si-label">错峰时段</text>
          </view>
          <view class="si-right">
            <view class="si-value">
              <text>23:00 - 07:00</text>
            </view>
          </view>
        </view>

        <view class="setting-item">
          <view class="si-left">
            <text class="si-label">充电完成后自动断电</text>
            <text class="si-desc">保护电池，避免过充</text>
          </view>
          <view class="si-right">
            <switch :checked="settings.autoShutdown" color="#07c160" @change="toggleAutoShutdown" />
          </view>
        </view>
      </view>

      <view class="settings-group">
        <text class="group-title">通知与安全</text>

        <view class="setting-item">
          <view class="si-left">
            <text class="si-label">充电完成通知</text>
            <text class="si-desc">充电完成时推送通知</text>
          </view>
          <view class="si-right">
            <switch :checked="settings.chargeNotify" color="#07c160" @change="toggleNotify" />
          </view>
        </view>

        <view class="setting-item">
          <view class="si-left">
            <text class="si-label">异常告警通知</text>
            <text class="si-desc">充电异常时及时告警</text>
          </view>
          <view class="si-right">
            <switch :checked="settings.alarmNotify" color="#07c160" @change="toggleAlarm" />
          </view>
        </view>

        <view class="setting-item">
          <view class="si-left">
            <text class="si-label">充电桩故障自动诊断</text>
            <text class="si-desc">充电前自动检测充电桩状态</text>
          </view>
          <view class="si-right">
            <switch :checked="settings.autoDiagnose" color="#07c160" @change="toggleDiagnose" />
          </view>
        </view>
      </view>

      <view class="save-section">
        <button class="save-btn" @click="saveSettings">保存设置</button>
      </view>
    </scroll-view>

    <uni-popup ref="powerPopup" type="bottom" :safe-area="true">
      <view class="popup-pick">
        <view class="popup-header">
          <text class="popup-title">选择最大功率</text>
          <text class="popup-cancel" @click="closePowerPicker">取消</text>
        </view>
        <picker-view :value="powerIndex" @change="onPowerChange" class="pick-view">
          <picker-view-column>
            <view class="pick-item" v-for="(p, pi) in powerOptions" :key="pi">{{ p }}kW</view>
          </picker-view-column>
        </picker-view>
      </view>
    </uni-popup>
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
      settings: {
        maxPower: 120,
        targetSOC: 80,
        scheduledCharge: false,
        scheduleTime: '23:00',
        preferFastCharge: true,
        nightCharge: false,
        autoShutdown: true,
        chargeNotify: true,
        alarmNotify: true,
        autoDiagnose: false
      },
      powerOptions: [60, 90, 120, 150, 180, 200],
      powerIndex: [2],
      showSOCOptions: false
    }
  },

  onLoad(options) {
    this.chargeStatus = options.chargeStatus || 'idle'
    if (this.chargeStatus === 'charging' || this.chargeStatus === 'paused' || this.chargeStatus === 'abnormal') {
      uni.showToast({ title: '充电过程中暂不支持修改设置，参数将在下次充电生效', icon: 'none', duration: 2000 })
      setTimeout(() => uni.navigateBack(), 2200)
      return
    }
    const saved = uni.getStorageSync('chargeSettings')
    if (saved) {
      this.settings = { ...this.settings, ...JSON.parse(saved) }
    }
  },

  methods: {
    goBack() {
      uni.navigateBack()
    },

    showPowerPicker() {
      if (this.$refs.powerPopup) this.$refs.powerPopup.open()
    },

    closePowerPicker() {
      if (this.$refs.powerPopup) this.$refs.powerPopup.close()
    },

    onPowerChange(e) {
      this.powerIndex = e.detail.value
      this.settings.maxPower = this.powerOptions[this.powerIndex[0]]
    },

    onTimeChange(e) {
      this.settings.scheduleTime = e.detail.value
    },

    toggleScheduled(e) {
      this.settings.scheduledCharge = e.detail.value
    },

    toggleFastCharge(e) {
      this.settings.preferFastCharge = e.detail.value
    },

    toggleNightCharge(e) {
      this.settings.nightCharge = e.detail.value
    },

    toggleAutoShutdown(e) {
      this.settings.autoShutdown = e.detail.value
    },

    toggleNotify(e) {
      this.settings.chargeNotify = e.detail.value
    },

    toggleAlarm(e) {
      this.settings.alarmNotify = e.detail.value
    },

    toggleDiagnose(e) {
      this.settings.autoDiagnose = e.detail.value
    },

    saveSettings() {
      uni.setStorageSync('chargeSettings', JSON.stringify(this.settings))
      uni.showToast({ title: '设置已保存', icon: 'success' })
      setTimeout(() => uni.navigateBack(), 1200)
    }
  }
}
</script>

<style lang="scss" scoped>
.settings-page {
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

.settings-scroll {
  flex: 1;
  padding-bottom: 40rpx;
}

.settings-group {
  background: #fff;
  margin: 20rpx 20rpx;
  border-radius: 16rpx;
  overflow: hidden;

  .group-title {
    display: block;
    padding: 28rpx 24rpx 12rpx;
    font-size: 28rpx;
    font-weight: 700;
    color: #1a1a1a;
  }
}

.setting-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24rpx 24rpx;

  .si-left {
    flex: 1;

    .si-label {
      font-size: 28rpx;
      color: #333;
      font-weight: 500;
      display: block;
    }

    .si-desc {
      font-size: 22rpx;
      color: #999;
      margin-top: 6rpx;
      display: block;
    }
  }

  .si-right {
    flex-shrink: 0;

    .si-value {
      display: flex;
      align-items: center;
      gap: 8rpx;
      font-size: 28rpx;
      color: #07c160;
      font-weight: 500;
    }

    switch {
      transform: scale(0.85);
    }
  }
}

.save-section {
  padding: 32rpx 20rpx 60rpx;

  .save-btn {
    width: 100%;
    height: 88rpx;
    line-height: 88rpx;
    background: linear-gradient(135deg, #07c160, #06ad56);
    color: #fff;
    font-size: 32rpx;
    font-weight: 700;
    border-radius: 44rpx;
    border: none;
  }
}

.popup-pick {
  background: #fff;
  border-radius: 24rpx 24rpx 0 0;
  padding: 24rpx 0 60rpx;

  .popup-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 24rpx 20rpx;

    .popup-title {
      font-size: 32rpx;
      font-weight: 700;
      color: #1a1a1a;
    }

    .popup-cancel {
      font-size: 28rpx;
      color: #07c160;
    }
  }

  .pick-view {
    height: 400rpx;

    .pick-item {
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 36rpx;
      color: #333;
    }
  }
}
</style>