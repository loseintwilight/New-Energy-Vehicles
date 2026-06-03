<template>
  <view class="page">
    <UsedCarContent @go-order="goOrder" />
  </view>
</template>

<script>
import UsedCarContent from './components/UsedCarContent'

export default {
  components: { UsedCarContent },
  methods: {
    goOrder(car) {
      uni.navigateTo({
        url: `/pages/car/order-used?car=${encodeURIComponent(JSON.stringify(car))}`
      })
    }
  }
}
</script>

<style lang="scss" scoped>
page {
  height: 100%;
  background: #f5f5f7;
}
.page {
  height: 100vh;
  background: #f5f5f7;
}
</style>