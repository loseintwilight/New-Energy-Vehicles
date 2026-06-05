<template>
  <view class="city-select-page">
    <view class="cs-header" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="cs-header-inner">
        <view class="cs-back" @click="goBack">
          <u-icon name="arrow-left" size="36" color="#333"></u-icon>
        </view>
        <text class="cs-title">选择城市</text>
        <view class="cs-placeholder"></view>
      </view>
      <view class="cs-search">
        <u-icon name="search" size="28" color="#bbb"></u-icon>
        <input class="cs-search-input" v-model="searchKeyword" placeholder="输入城市名称搜索" placeholder-style="color: #bfbfbf; font-size: 24rpx;" @input="onSearchInput" />
        <text v-if="searchKeyword" class="cs-search-clear" @click="searchKeyword = ''">清除</text>
      </view>
    </view>
    <view class="cs-current" @click="selectCity(currentCity)">
      <u-icon name="map-fill" size="28" color="#07c160"></u-icon>
      <text class="cs-current-label">当前定位：</text>
      <text class="cs-current-name">{{ currentCity }}</text>
    </view>
    <scroll-view class="cs-list" scroll-y :scroll-into-view="scrollInto">
      <view v-if="filteredCities.length === 0" class="cs-empty">
        <text>未找到匹配城市</text>
      </view>
      <view class="cs-section" v-for="(section, si) in citySections" :key="si" v-show="section.list.length > 0">
        <view class="cs-section-title" :id="'letter-' + section.letter">{{ section.letter }}</view>
        <view
          v-for="(city, ci) in section.list"
          :key="ci"
          class="cs-city-item"
          :class="{ selected: currentCity === city.name }"
          @click="selectCity(city.name)"
        >
          <text class="cs-city-name">{{ city.name }}</text>
          <u-icon v-if="currentCity === city.name" name="checkbox-mark" size="32" color="#07c160"></u-icon>
        </view>
      </view>
    </scroll-view>
    <view class="cs-letters">
      <view
        v-for="letter in letters"
        :key="letter"
        class="cs-letter"
        :class="{ active: activeLetter === letter }"
        @click="scrollToLetter(letter)"
      >
        <text>{{ letter }}</text>
      </view>
    </view>
  </view>
</template>

<script>
import { getCityList } from '@/api/charge/station.js'
import safeAreaMixin from '@/mixins/safe-area.js'

export default {
  mixins: [safeAreaMixin],
  data() {
    return {
      searchKeyword: '',
      currentCity: uni.getStorageSync('selectedCity') || '济南市',
      activeLetter: '',
      scrollInto: '',
      allCities: [],
      citySections: [],
      letters: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')
    }
  },
  computed: {
    filteredCities() {
      if (!this.searchKeyword) return this.allCities
      return this.allCities.filter(c => c.name.includes(this.searchKeyword))
    }
  },
  onLoad() {
    this.loadCityList()
  },

  methods: {
    async loadCityList() {
      try {
        const res = await getCityList()
        const data = res.data || []
        this.allCities = data.map(item => {
          const name = item.city || item.name || ''
          const letter = name ? name.charAt(0).toUpperCase() : '#'
          return { name, letter }
        })
        this.citySections = this.buildSections(this.allCities)
      } catch (e) {
        this.allCities = []
        this.citySections = this.buildSections([])
      }
    },
    buildSections(cities) {
      const sections = []
      const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')
      const grouped = {}
      cities.forEach(c => {
        if (!grouped[c.letter]) grouped[c.letter] = []
        grouped[c.letter].push(c)
      })
      letters.forEach(letter => {
        if (grouped[letter]) {
          sections.push({ letter, list: grouped[letter] })
        } else {
          sections.push({ letter, list: [] })
        }
      })
      return sections
    },
    onSearchInput() {
      this.citySections = this.buildSections(this.filteredCities)
    },
    selectCity(cityName) {
      uni.setStorageSync('selectedCity', cityName)
      uni.navigateBack()
    },
    scrollToLetter(letter) {
      this.activeLetter = letter
      this.scrollInto = 'letter-' + letter
    },
    goBack() {
      uni.navigateBack()
    }
  }
}
</script>

<style lang="scss" scoped>
.city-select-page {
  height: 100vh;
  background: #f5f6fa;
  display: flex;
  flex-direction: column;
}

.cs-header {
  background: #fff;
  padding-bottom: 12rpx;

  .cs-header-inner {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 20rpx;

    .cs-back {
      width: 56rpx;
      height: 56rpx;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .cs-title {
      font-size: 32rpx;
      font-weight: 700;
      color: #1a1a1a;
    }

    .cs-placeholder {
      width: 56rpx;
    }
  }

  .cs-search {
    display: flex;
    align-items: center;
    margin: 12rpx 20rpx 0;
    height: 64rpx;
    background: #f2f3f7;
    border-radius: 32rpx;
    padding: 0 24rpx;

    .cs-search-input {
      flex: 1;
      font-size: 26rpx;
      color: #333;
      margin-left: 10rpx;
    }

    .cs-search-clear {
      font-size: 22rpx;
      color: #999;
      flex-shrink: 0;
    }
  }
}

.cs-current {
  display: flex;
  align-items: center;
  padding: 20rpx 24rpx;
  background: #f9fdf8;
  margin: 2rpx 0;

  .cs-current-label {
    font-size: 26rpx;
    color: #888;
    margin-left: 10rpx;
  }

  .cs-current-name {
    font-size: 28rpx;
    color: #07c160;
    font-weight: 600;
  }
}

.cs-list {
  flex: 1;
  padding: 0 24rpx;
  background: #fff;

  .cs-empty {
    text-align: center;
    padding: 80rpx 0;
    font-size: 28rpx;
    color: #999;
  }

  .cs-section {
    .cs-section-title {
      font-size: 24rpx;
      color: #999;
      padding: 20rpx 0 12rpx;
      font-weight: 600;
    }

    .cs-city-item {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 22rpx 0;
      border-bottom: 1rpx solid #f8f8f8;

      .cs-city-name {
        font-size: 28rpx;
        color: #333;
      }

      &.selected {
        .cs-city-name {
          color: #07c160;
          font-weight: 600;
        }
      }

      &:active { background: #f8fffb; }
    }
  }
}

.cs-letters {
  position: fixed;
  right: 0;
  top: 50%;
  transform: translateY(-50%);
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 8rpx 4rpx;
  z-index: 10;

  .cs-letter {
    width: 36rpx;
    height: 28rpx;
    display: flex;
    align-items: center;
    justify-content: center;

    text {
      font-size: 18rpx;
      color: #999;
    }

    &.active text {
      color: #07c160;
      font-weight: 700;
      font-size: 20rpx;
    }
  }
}
</style>