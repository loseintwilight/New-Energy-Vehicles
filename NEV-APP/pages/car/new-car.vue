<template>
  <view class="page">
    <NewCarContent @go-order="goOrder" />
  </view>
</template>

<script>
import NewCarContent from './components/NewCarContent'

export default {
  components: { NewCarContent },
  methods: {
    goOrder(car) {
      uni.navigateTo({
        url: `/pages/car/order-new?car=${encodeURIComponent(JSON.stringify(car))}`
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