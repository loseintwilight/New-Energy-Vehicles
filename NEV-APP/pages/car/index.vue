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
          class="filter-tag"
          :class="{ on: !selectedColor && !selectedModel && priceSortDir === null }"
          @click="resetFilter"
        >
          <text class="filter-tag-label">全部</text>
        </view>
        <picker mode="selector" :range="colorOptions" @change="onColorChange">
          <view class="filter-tag" :class="{ on: selectedColor }">
            <text class="filter-tag-label">{{ selectedColor || '颜色' }}</text>
            <text class="arrow">▾</text>
          </view>
        </picker>
        <picker mode="selector" :range="modelOptions" @change="onModelChange">
          <view class="filter-tag" :class="{ on: selectedModel }">
            <text class="filter-tag-label">{{ selectedModel || '车型' }}</text>
            <text class="arrow">▾</text>
          </view>
        </picker>
        <view
          class="filter-tag"
          :class="{ on: priceSortDir !== null }"
          @click="togglePriceSort"
        >
          <text class="filter-tag-label">价格</text>
          <text v-if="priceSortDir === 'asc'" class="sort-arrow">↑</text>
          <text v-else-if="priceSortDir === 'desc'" class="sort-arrow">↓</text>
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
import { getFilterColors, getFilterModels } from '@/api/car/car'

export default {
  components: { NewCarContent, UsedCarContent, TradeInContent },

  data() {
    return {
      bannerList: [
        { image: '/static/images/car/轮播图1.jpg' },
        { image: '/static/images/car/轮播图2.jpg' },
        { image: '/static/images/car/轮播图3.jpg' }
      ],
      activeTab: 0,
      priceSortDir: null,
      tabList: [
        { name: '全新现车' },
        { name: '二手车' },
        { name: '以旧换新' }
      ],
      colorOptions: [],
      modelOptions: [],
      selectedColor: '',
      selectedModel: ''
    }
  },

  computed: {
    computedFilter() {
      return {
        color: this.selectedColor,
        model: this.selectedModel,
        sortDir: this.priceSortDir
      }
    }
  },

  created() {
    this.fetchFilterColors()
    this.fetchFilterModels()
  },

  methods: {
    fetchFilterColors() {
      getFilterColors().then(res => {
        this.colorOptions = res.data || []
      }).catch(() => {})
    },
    fetchFilterModels() {
      getFilterModels().then(res => {
        this.modelOptions = res.data || []
      }).catch(() => {})
    },
    resetFilter() {
      this.selectedColor = ''
      this.selectedModel = ''
      this.priceSortDir = null
    },
    onColorChange(e) {
      this.selectedColor = this.colorOptions[e.detail.value] || ''
      this.priceSortDir = null
    },
    onModelChange(e) {
      this.selectedModel = this.modelOptions[e.detail.value] || ''
      this.priceSortDir = null
    },
    togglePriceSort() {
      if (this.priceSortDir === null) this.priceSortDir = 'asc'
      else if (this.priceSortDir === 'asc') this.priceSortDir = 'desc'
      else this.priceSortDir = null
    },
    onTabClick(i) {
      this.activeTab = i
      this.resetFilter()
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
  height: 360rpx;
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
.filter-scroll picker {
  display: inline-flex;
  vertical-align: middle;
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
.arrow {
  font-size: 20rpx;
  margin-left: 4rpx;
  color: #999;
}
.content-area {
  flex: 1;
  overflow: hidden;
}
</style>