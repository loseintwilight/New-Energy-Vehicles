<template>
  <view :style="{ paddingTop: statusBarHeight + 'px', background: bgColor }">
    <view style="height: 80rpx; display: flex; align-items: center; justify-content: center; padding: 0 24rpx;">
      <text :style="{ fontSize: '30rpx', fontWeight: '600', color: textColor }">{{ title }}</text>
    </view>
  </view>
</template>

<script>
const systemInfo = uni.getSystemInfoSync()

export default {
  name: 'ChargeHeader',
  props: {
    title: {
      type: String,
      default: '充电服务'
    },
    bgColor: {
      type: String,
      default: '#fff'
    },
    textColor: {
      type: String,
      default: '#333'
    }
  },
  data() {
    return {
      statusBarHeight: systemInfo.statusBarHeight || 20
    }
  }
}
</script>