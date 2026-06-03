<template>
  <view class="page">
    <TradeInContent />
  </view>
</template>

<script>
import TradeInContent from './components/TradeInContent'

export default {
  components: { TradeInContent }
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