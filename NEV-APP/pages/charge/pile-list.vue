<template>
  <view class="pile-list-page">
    <charge-header />
    <view class="nav-bar">
      <view class="nav-back" @click="goBack">
        <u-icon name="arrow-left" size="36" color="#333"></u-icon>
      </view>
      <text class="nav-title">{{ stationName }}</text>
      <view class="nav-share"></view>
    </view>

    <scroll-view class="list-scroll" scroll-y show-scrollbar="false">
      <view class="list-header">
        <text class="list-title">桩列表({{ totalPiles }})</text>
      </view>
      <scroll-view class="filter-bar" scroll-x enable-flex :show-scrollbar="false">
        <view class="f-tag" :class="{ active: activeFilter === 'all' }" @click="activeFilter = 'all'"><text>全部</text></view>
        <view class="f-tag" :class="{ active: activeFilter === 'fast' }" @click="activeFilter = 'fast'"><text>快充 {{ fastCount }}</text></view>
        <view class="f-tag" :class="{ active: activeFilter === 'slow' }" @click="activeFilter = 'slow'"><text>慢充 {{ slowCount }}</text></view>
      </scroll-view>
      <view class="pile-list">
        <view
          v-for="(pile, pi) in filteredPileList"
          :key="pi"
          class="pile-card"
        >
          <view class="pc-left">
            <view class="pc-icon-wrap" :class="'icon-' + pile.status">
              <image class="pc-icon-img" :src="pile.status === 'free' ? '/static/images/charge/free.png' : pile.status === 'fault' ? '/static/images/charge/error.png' : '/static/images/charge/charging.png'" mode="aspectFit"></image>
            </view>
            <text class="pc-badge" :class="'badge-' + pile.status">{{ pile.status === 'free' ? '空闲' : pile.status === 'charging' ? '充电中' : pile.statusText }}</text>
          </view>
          <view class="pc-right">
            <view class="pc-row">
              <text class="pc-label">桩 编 号</text>
              <text class="pc-value">{{ pile.pileCode }}</text>
              <image class="pc-copy-img" src="/static/images/charge/copy.png" mode="aspectFit"></image>
            </view>
            <view class="pc-row">
              <text class="pc-label">桩 名 称</text>
              <text class="pc-value bold">{{ pile.name }}</text>
            </view>
            <view class="pc-row">
              <text class="pc-label">枪 编 号</text>
              <text class="pc-value">{{ pile.gunCode }}</text>
            </view>
            <view class="pc-row price-row">
              <text class="pc-label">充电价格</text>
              <text class="pc-price">{{ currentPrice }}~1.28元/度</text>
              <text class="pc-price-link">价格详情 <u-icon name="arrow-right" size="16" color="#1b8e67" bold></u-icon></text>
            </view>
            <view class="pc-spec-row">
              <text class="spec-tag">{{ pile.type }}</text>
              <text class="spec-info">{{ pile.power }}</text>
              <text class="spec-info">{{ pile.voltage }}</text>
              <text class="spec-info">{{ pile.standard }}</text>
            </view>
            <view class="pc-realtime-row" v-if="pile.status === 'charging'">
              <text class="rt-item">实时SOC {{ pile.soc }}%</text>
              <text class="rt-divider">|</text>
              <text class="rt-item">电流 {{ pile.current }}A</text>
              <text class="rt-divider">|</text>
              <text class="rt-item">电压 {{ pile.voltageReal }}V</text>
              <text class="rt-divider">|</text>
              <text class="rt-item remain">预计剩余 {{ pile.remainTime }}</text>
            </view>
            <view class="pc-realtime-row free-row" v-else-if="pile.status === 'free'">
              <text class="rt-item remain">空闲中 可扫码充电</text>
            </view>
            <view class="pc-realtime-row" v-else>
              <text class="rt-item">{{ pile.statusText }}</text>
            </view>
          </view>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script>
import safeAreaMixin from '@/mixins/safe-area.js'
import ChargeHeader from '@/components/charge-header/charge-header.vue'

const mockPileData = [
  { number: 'A01', type: '快充', status: 'free', power: '120kW', statusText: '空闲', connectorType: 'GB/T直流', floor: 'B1', position: 'A区-01号', online: true,
    pileCode: '3740190000020104', name: '3号桩', gunCode: '3740190000020104001', voltage: '750V', standard: '国标2015', soc: 89, current: 18.9, voltageReal: 406.5 },
  { number: 'A02', type: '快充', status: 'free', power: '120kW', statusText: '空闲', connectorType: 'GB/T直流', floor: 'B1', position: 'A区-02号', online: true,
    pileCode: '3740190000020105', name: '1号桩', gunCode: '3740190000020105001', voltage: '750V', standard: '国标2015', soc: 100, current: 3.6, voltageReal: 395.5 },
  { number: 'A03', type: '快充', status: 'charging', power: '120kW', statusText: '使用中', connectorType: 'GB/T直流', floor: 'B1', position: 'A区-03号', online: true,
    pileCode: '3740190000020103', name: '7号桩', gunCode: '3740190000020103001', voltage: '750V', standard: '国标2015', soc: 40, current: 44.5, voltageReal: 414.0, remainTime: '35分钟' },
  { number: 'A04', type: '快充', status: 'free', power: '120kW', statusText: '空闲', connectorType: 'GB/T直流', floor: 'B1', position: 'A区-04号', online: true,
    pileCode: '3740190000020106', name: '2号桩', gunCode: '3740190000020106001', voltage: '750V', standard: '国标2015', soc: 75, current: 0, voltageReal: 400.0 },
  { number: 'A05', type: '快充', status: 'free', power: '120kW', statusText: '空闲', connectorType: 'GB/T直流', floor: 'B1', position: 'A区-05号', online: true,
    pileCode: '3740190000020107', name: '4号桩', gunCode: '3740190000020107001', voltage: '750V', standard: '国标2015', soc: 60, current: 0, voltageReal: 408.0 },
  { number: 'A06', type: '快充', status: 'charging', power: '120kW', statusText: '使用中', connectorType: 'GB/T直流', floor: 'B1', position: 'A区-06号', online: true,
    pileCode: '3740190000020108', name: '5号桩', gunCode: '3740190000020108001', voltage: '750V', standard: '国标2015', soc: 35, current: 52.3, voltageReal: 410.2, remainTime: '45分钟' },
  { number: 'A07', type: '快充', status: 'free', power: '120kW', statusText: '空闲', connectorType: 'GB/T直流', floor: 'B1', position: 'A区-07号', online: true,
    pileCode: '3740190000020109', name: '6号桩', gunCode: '3740190000020109001', voltage: '750V', standard: '国标2015', soc: 95, current: 0, voltageReal: 398.5 },
  { number: 'A08', type: '快充', status: 'free', power: '120kW', statusText: '空闲', connectorType: 'GB/T直流', floor: 'B1', position: 'A区-08号', online: true,
    pileCode: '3740190000020110', name: '8号桩', gunCode: '3740190000020110001', voltage: '750V', standard: '国标2015', soc: 20, current: 0, voltageReal: 402.0 },
  { number: 'B01', type: '慢充', status: 'free', power: '7kW', statusText: '空闲', connectorType: 'GB/T交流', floor: 'B2', position: 'B区-01号', online: true,
    pileCode: '3740190000020201', name: '慢充1号', gunCode: '3740190000020201001', voltage: '220V', standard: '国标2015', soc: 55, current: 12.0, voltageReal: 220.0 },
  { number: 'B02', type: '慢充', status: 'fault', power: '7kW', statusText: '故障维护', connectorType: 'GB/T交流', floor: 'B2', position: 'B区-02号', online: false,
    pileCode: '3740190000020202', name: '慢充2号', gunCode: '3740190000020202001', voltage: '220V', standard: '国标2015', soc: 0, current: 0, voltageReal: 0 },
  { number: 'B03', type: '慢充', status: 'free', power: '7kW', statusText: '空闲', connectorType: 'GB/T交流', floor: 'B2', position: 'B区-03号', online: true,
    pileCode: '3740190000020203', name: '慢充3号', gunCode: '3740190000020203001', voltage: '220V', standard: '国标2015', soc: 0, current: 0, voltageReal: 0 },
  { number: 'B04', type: '慢充', status: 'charging', power: '7kW', statusText: '使用中', connectorType: 'GB/T交流', floor: 'B2', position: 'B区-04号', online: true,
    pileCode: '3740190000020204', name: '慢充4号', gunCode: '3740190000020204001', voltage: '220V', standard: '国标2015', soc: 68, current: 10.5, voltageReal: 218.0, remainTime: '55分钟' },
  { number: 'B05', type: '慢充', status: 'free', power: '7kW', statusText: '空闲', connectorType: 'GB/T交流', floor: 'B2', position: 'B区-05号', online: true,
    pileCode: '3740190000020205', name: '慢充5号', gunCode: '3740190000020205001', voltage: '220V', standard: '国标2015', soc: 82, current: 0, voltageReal: 221.0 },
  { number: 'B06', type: '慢充', status: 'free', power: '7kW', statusText: '空闲', connectorType: 'GB/T交流', floor: 'B2', position: 'B区-06号', online: true,
    pileCode: '3740190000020206', name: '慢充6号', gunCode: '3740190000020206001', voltage: '220V', standard: '国标2015', soc: 45, current: 0, voltageReal: 219.5 },
  { number: 'C01', type: '快充', status: 'free', power: '180kW', statusText: '空闲', connectorType: 'GB/T直流', floor: 'B1', position: 'C区超充-01号', online: true,
    pileCode: '3740190000020301', name: '超充1号', gunCode: '3740190000020301001', voltage: '1000V', standard: '国标2015+', soc: 70, current: 0, voltageReal: 800.0 },
  { number: 'C02', type: '快充', status: 'free', power: '180kW', statusText: '空闲', connectorType: 'GB/T直流', floor: 'B1', position: 'C区超充-02号', online: true,
    pileCode: '3740190000020302', name: '超充2号', gunCode: '3740190000020302001', voltage: '1000V', standard: '国标2015+', soc: 88, current: 0, voltageReal: 795.0 },
  { number: 'C03', type: '快充', status: 'charging', power: '180kW', statusText: '使用中', connectorType: 'GB/T直流', floor: 'B1', position: 'C区超充-03号', online: true,
    pileCode: '3740190000020303', name: '超充3号', gunCode: '3740190000020303001', voltage: '1000V', standard: '国标2015+', soc: 25, current: 98.6, voltageReal: 788.0, remainTime: '25分钟' }
]

export default {
  mixins: [safeAreaMixin],
  components: { ChargeHeader },
  data() {
    return {
      stationId: '',
      stationName: '充电站',
      currentPrice: '1.28',
      totalPiles: 17,
      pileList: [],
      activeFilter: 'all'
    }
  },

  computed: {
    fastCount() {
      return this.pileList.filter(p => p.type === '快充').length
    },
    slowCount() {
      return this.pileList.filter(p => p.type === '慢充').length
    },
    filteredPileList() {
      if (this.activeFilter === 'fast') return this.pileList.filter(p => p.type === '快充')
      if (this.activeFilter === 'slow') return this.pileList.filter(p => p.type === '慢充')
      return this.pileList
    }
  },

  onLoad(options) {
    if (options.stationId) this.stationId = options.stationId
    if (options.name) this.stationName = decodeURIComponent(options.name)
    if (options.currentPrice) this.currentPrice = options.currentPrice
    if (options.pileFilter) this.activeFilter = options.pileFilter
    this.pileList = mockPileData
    this.totalPiles = mockPileData.length
  },

  methods: {
    goBack() {
      uni.navigateBack()
    }
  }
}
</script>

<style lang="scss" scoped>
.pile-list-page {
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

  .nav-back, .nav-share {
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
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
}

.list-scroll {
  flex: 1;
}

.list-header {
  padding: 24rpx 24rpx 16rpx;

  .list-title {
    font-size: 30rpx;
    font-weight: 700;
    color: #1a1a1a;
  }
}

.filter-bar {
  white-space: nowrap;
  padding: 0 24rpx 20rpx;

  .f-tag {
    display: inline-block;
    padding: 10rpx 32rpx;
    border-radius: 28rpx;
    font-size: 24rpx;
    margin-right: 16rpx;
    background: #f5f6fa;
    color: #666;

    &.active {
      background: #07c160;
      color: #fff;
    }
  }
}

.pile-list {
  padding: 0 24rpx 28rpx;
}

.pile-card {
  display: flex;
  gap: 24rpx;
  padding: 28rpx 24rpx;
  background: #fff;
  border-radius: 16rpx;
  margin-bottom: 16rpx;
  border: 1rpx solid #f0f0f0;

  .pc-left {
    flex-shrink: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 10rpx;

    .pc-icon-wrap {
      width: 88rpx;
      height: 100rpx;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 16rpx;

      &.icon-charging { background: #fff7e6; }
      &.icon-free { background: #e8f8ee; }
      &.icon-fault { background: #fff1f0; }

      .pc-icon-img {
        width: 72rpx;
        height: 84rpx;
      }
    }

    .pc-badge {
      font-size: 22rpx;
      border-radius: 20rpx;
      padding: 4rpx 22rpx;
      background: #fff;

      &.badge-charging {
        color: #ff9500;
        border: 1rpx solid #ff9500;
      }

      &.badge-free {
        color: #07c160;
        border: 1rpx solid #07c160;
      }

      &.badge-fault {
        color: #f5222d;
        border: 1rpx solid #f5222d;
      }
    }
  }

  .pc-right {
    flex: 1;
    min-width: 0;

    .pc-row {
      display: flex;
      align-items: center;
      gap: 8rpx;
      line-height: 1.8;

      .pc-label {
        font-size: 24rpx;
        color: #999;
        flex-shrink: 0;
        letter-spacing: 4rpx;
      }

      .pc-value {
        font-size: 28rpx;
        color: #333;
        flex: 1;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;

        &.bold { font-weight: 700; }
      }

      .pc-copy-img {
        width: 32rpx;
        height: 32rpx;
        flex-shrink: 0;
      }

      &.price-row {
        .pc-price { font-size: 28rpx; color: #333; font-weight: 500; }
        .pc-price-link { font-size: 28rpx; color: #1b8e67; flex-shrink: 0; margin-left: auto; }
      }
    }

    .pc-spec-row {
      display: flex;
      align-items: center;
      gap: 16rpx;
      margin-top: 6rpx;

      .spec-tag {
        font-size: 24rpx;
        color: #ff9500;
        background: #fff7e6;
        padding: 6rpx 18rpx;
        border-radius: 8rpx;
        font-weight: 500;
      }

      .spec-info { font-size: 24rpx; color: #888; }
    }

    .pc-realtime-row {
      display: flex;
      align-items: center;
      gap: 8rpx;
      margin-top: 12rpx;
      padding-top: 12rpx;
      border-top: 1rpx dashed #eee;

      .rt-item { font-size: 24rpx; color: #666; }
      .rt-divider { font-size: 24rpx; color: #ddd; }

      .rt-item.remain { font-size: 24rpx; color: #ff9500; font-weight: 500; }

      &.free-row {
        .rt-item { font-size: 24rpx; color: #07c160; font-weight: 500; }
      }
    }
  }
}
</style>