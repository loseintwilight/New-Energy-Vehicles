<template>
  <view class="page">
    <swiper class="banner" autoplay circular indicator-dots indicator-color="rgba(255,255,255,0.35)" indicator-active-color="#3072f6">
      <swiper-item v-for="(banner, i) in bannerList" :key="i">
        <image class="banner-img" :src="banner.image" mode="aspectFill"></image>
      </swiper-item>
    </swiper>

    <view class="tabs-bar">
      <view
        v-for="(tab, i) in tabList"
        :key="i"
        class="tab-item"
        :class="{ on: activeTab === i }"
        @click="onTabClick(i)"
      >
        <text class="tab-label">{{ tab.name }}</text>
      </view>
      <view class="tab-indicator" :style="{ transform: 'translateX(' + (activeTab * 100) + '%)' }"></view>
    </view>

    <view class="filter-bar" v-if="activeTab < 2">
      <scroll-view scroll-x class="filter-scroll" show-scrollbar="false">
        <view
          v-for="(f, i) in filterOptions"
          :key="i"
          class="filter-tag"
          :class="{ on: activeFilter === i }"
          @click="onFilterClick(i)"
        >
          <text class="filter-tag-label">{{ f.label }}</text>
          <text v-if="i === 1" class="sort-arrow">{{ priceSortDir === 'asc' ? '↑' : '↓' }}</text>
        </view>
      </scroll-view>
    </view>

    <view class="content-area">
      <NewCarContent v-if="activeTab === 0" :filter="computedFilter" @go-order="navigateToOrder" />
      <UsedCarContent v-else-if="activeTab === 1" :filter="computedFilter" @go-order="navigateToOrder" />
      <TradeInContent v-else />
    </view>
  </view>
</template>

<script>
import NewCarContent from './components/NewCarContent'
import UsedCarContent from './components/UsedCarContent'
import TradeInContent from './components/TradeInContent'

export default {
  components: { NewCarContent, UsedCarContent, TradeInContent },

  data() {
    return {
      bannerList: [
        { image: '/static/images/car/car1.png' },
        { image: '/static/images/car/car2.png' },
        { image: '/static/images/car/car3.png' }
      ],
      activeTab: 0,
      activeFilter: 0,
      priceSortDir: 'asc',
      tabList: [
        { name: '全新现车' },
        { name: '二手车' },
        { name: '以旧换新' }
      ],
      filterOptions: [
        { label: '全部' },
        { label: '价格' }
      ]
    }
  },

  computed: {
    computedFilter() {
      if (this.activeFilter === 1) return this.priceSortDir === 'asc' ? 1 : 2
      return this.activeFilter
    }
  },

  methods: {
    onFilterClick(i) {
      if (i === 1) {
        this.priceSortDir = this.priceSortDir === 'asc' ? 'desc' : 'asc'
      }
      this.activeFilter = i
    },
    onTabClick(i) {
      this.activeTab = i
      this.activeFilter = 0
    },
    navigateToOrder(car) {
      if (this.activeTab === 0) {
        uni.navigateTo({
          url: `/pages/car/order-new?car=${encodeURIComponent(JSON.stringify(car))}`
        })
      } else if (this.activeTab === 1) {
        uni.navigateTo({
          url: `/pages/car/order-used?car=${encodeURIComponent(JSON.stringify(car))}`
        })
      }
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
  display: flex;
  flex-direction: column;
  height: 100vh;
  background: #f5f5f7;
}
.banner {
  width: 100%;
  height: 180rpx;
  flex-shrink: 0;
}
.banner-img {
  width: 100%;
  height: 100%;
}
.tabs-bar {
  position: relative;
  display: flex;
  background: #fff;
  border-bottom: 1rpx solid #eee;
  flex-shrink: 0;
}
.tab-item {
  flex: 1;
  text-align: center;
  padding: 24rpx 0;
  position: relative;
  z-index: 2;
}
.tab-label {
  font-size: 28rpx;
  font-weight: 500;
  color: #999;
}
.tab-item.on .tab-label {
  color: #3072f6;
  font-weight: 700;
}
.tab-indicator {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 33.33%;
  height: 4rpx;
  background: #3072f6;
  border-radius: 2rpx;
  transition: transform 0.3s ease;
  z-index: 1;
}
.filter-bar {
  background: #fff;
  padding: 16rpx 0;
  border-bottom: 1rpx solid #f0f0f0;
  flex-shrink: 0;
}
.filter-scroll {
  white-space: nowrap;
  padding: 0 24rpx;
}
.filter-tag {
  display: inline-flex;
  padding: 12rpx 28rpx;
  margin-right: 16rpx;
  border-radius: 30rpx;
  font-size: 24rpx;
  color: #666;
  background: #f5f5f7;
  border: 1rpx solid #eee;
  vertical-align: middle;
}
.filter-tag.on {
  color: #3072f6;
  background: #f0f6ff;
  border-color: #3072f6;
}
.filter-tag-label {
  font-size: 24rpx;
  font-weight: 500;
}
.sort-arrow {
  font-size: 22rpx;
  margin-left: 4rpx;
}
.content-area {
  flex: 1;
  overflow: hidden;
}
</style>