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
        <text v-if="searchKeyword" class="cs-search-clear" @click="clearSearch">清除</text>
      </view>
    </view>
    <view class="cs-current" @click="selectCity(currentCity)">
      <u-icon name="map-fill" size="28" color="#07c160"></u-icon>
      <text class="cs-current-label">当前定位：</text>
      <text class="cs-current-name">{{ currentCity }}</text>
    </view>
    <scroll-view class="cs-list" scroll-y :scroll-into-view="scrollInto">
      <view v-if="visibleSections.length === 0" class="cs-empty">
        <text>未找到匹配城市</text>
      </view>
      <view class="cs-section" v-for="(section, si) in visibleSections" :key="si">
        <view class="cs-section-title" :id="'letter-' + section.letter">{{ section.letter }}</view>
        <view
          v-for="(city, ci) in section.list"
          :key="ci"
          class="cs-city-group"
        >
          <view
            class="cs-city-header"
            :class="{ selected: currentCity === city.name }"
            @click="selectCity(city.name)"
          >
            <text class="cs-city-name">{{ city.name }}</text>
            <u-icon v-if="currentCity === city.name" name="checkbox-mark" size="32" color="#07c160"></u-icon>
            <u-icon v-else name="arrow-right" size="24" color="#ccc"></u-icon>
          </view>
          <view class="cs-district-list" v-if="city.districts && city.districts.length > 0">
            <view
              v-for="(district, di) in city.districts"
              :key="di"
              class="cs-district-item"
              @click="selectCity(city.name)"
            >
              <text class="cs-district-name">{{ district }}</text>
            </view>
          </view>
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

const CITY_LETTER_MAP = {
  '滨州市': 'B', '德州市': 'D', '东营市': 'D', '菏泽市': 'H',
  '济南市': 'J', '济宁市': 'J', '聊城市': 'L', '临沂市': 'L',
  '青岛市': 'Q', '日照市': 'R', '泰安市': 'T',
  '潍坊市': 'W', '威海市': 'W', '烟台市': 'Y', '枣庄市': 'Z', '淄博市': 'Z'
}

const CITY_DISTRICTS = {
  '济南市': ['历下区', '市中区', '槐荫区', '天桥区', '历城区', '长清区', '章丘区', '济阳区', '莱芜区', '钢城区', '平阴县', '商河县'],
  '青岛市': ['市南区', '市北区', '李沧区', '崂山区', '城阳区', '即墨区', '西海岸新区', '胶州市', '平度市', '莱西市'],
  '淄博市': ['张店区', '淄川区', '博山区', '临淄区', '周村区', '桓台县', '高青县', '沂源县'],
  '枣庄市': ['市中区', '薛城区', '峄城区', '台儿庄区', '山亭区', '滕州市'],
  '东营市': ['东营区', '河口区', '垦利区', '利津县', '广饶县'],
  '烟台市': ['芝罘区', '福山区', '牟平区', '莱山区', '蓬莱区', '龙口市', '莱阳市', '莱州市', '招远市', '栖霞市', '海阳市'],
  '潍坊市': ['潍城区', '寒亭区', '坊子区', '奎文区', '青州市', '诸城市', '寿光市', '安丘市', '高密市', '昌邑市', '临朐县', '昌乐县'],
  '济宁市': ['任城区', '兖州区', '曲阜市', '邹城市', '微山县', '鱼台县', '金乡县', '嘉祥县', '汶上县', '泗水县', '梁山县'],
  '泰安市': ['泰山区', '岱岳区', '新泰市', '肥城市', '宁阳县', '东平县'],
  '威海市': ['环翠区', '文登区', '荣成市', '乳山市'],
  '日照市': ['东港区', '岚山区', '五莲县', '莒县'],
  '临沂市': ['兰山区', '罗庄区', '河东区', '沂南县', '郯城县', '沂水县', '兰陵县', '费县', '平邑县', '莒南县', '蒙阴县', '临沭县'],
  '德州市': ['德城区', '陵城区', '乐陵市', '禹城市', '宁津县', '庆云县', '临邑县', '齐河县', '平原县', '夏津县', '武城县'],
  '聊城市': ['东昌府区', '临清市', '阳谷县', '莘县', '茌平区', '东阿县', '冠县', '高唐县'],
  '滨州市': ['滨城区', '沾化区', '惠民县', '阳信县', '无棣县', '博兴县', '邹平市'],
  '菏泽市': ['牡丹区', '定陶区', '曹县', '单县', '成武县', '巨野县', '郓城县', '鄄城县', '东明县']
}

const CITY_COORDS = {
  '济南市': { lat: 36.6512, lng: 117.1201 },
  '青岛市': { lat: 36.0671, lng: 120.3826 },
  '淄博市': { lat: 36.8135, lng: 118.0548 },
  '枣庄市': { lat: 34.8107, lng: 117.3217 },
  '东营市': { lat: 37.4348, lng: 118.6746 },
  '烟台市': { lat: 37.4645, lng: 121.4479 },
  '潍坊市': { lat: 36.7068, lng: 119.1618 },
  '济宁市': { lat: 35.4145, lng: 116.5870 },
  '泰安市': { lat: 36.2000, lng: 117.0876 },
  '威海市': { lat: 37.5135, lng: 122.1205 },
  '日照市': { lat: 35.4164, lng: 119.5269 },
  '临沂市': { lat: 35.1047, lng: 118.3565 },
  '德州市': { lat: 37.4356, lng: 116.3593 },
  '聊城市': { lat: 36.4570, lng: 115.9855 },
  '滨州市': { lat: 37.3820, lng: 117.9728 },
  '菏泽市': { lat: 35.2336, lng: 115.4806 }
}

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
      letters: []
    }
  },
  computed: {
    visibleSections() {
      if (!this.searchKeyword) return this.citySections
      return this.citySections.map(s => ({
        ...s,
        list: s.list.filter(c => c.name.includes(this.searchKeyword) ||
          (c.districts && c.districts.some(d => d.includes(this.searchKeyword))))
      })).filter(s => s.list.length > 0)
    }
  },
  onLoad() {
    this.loadCityList()
  },
  methods: {
    loadCityList() {
      const cityNames = Object.keys(CITY_LETTER_MAP)
      this.allCities = cityNames.map(name => ({
        name,
        letter: CITY_LETTER_MAP[name],
        districts: CITY_DISTRICTS[name] || []
      }))
      this.citySections = this.buildSections(this.allCities)
      this.letters = this.citySections.map(s => s.letter)

      this.fetchApiCities()
    },
    async fetchApiCities() {
      try {
        const res = await getCityList()
        const data = res.data || []
        if (!data.length) return
        const apiCities = data.map(item => {
          const name = item.city || item.name || ''
          if (!name || CITY_LETTER_MAP[name]) return null
          return { name, letter: name.charAt(0), districts: [] }
        }).filter(Boolean)
        const merged = new Map()
        this.allCities.forEach(c => merged.set(c.name, c))
        apiCities.forEach(c => { if (!merged.has(c.name)) merged.set(c.name, c) })
        this.allCities = Array.from(merged.values())
        this.citySections = this.buildSections(this.allCities)
        this.letters = this.citySections.map(s => s.letter)
      } catch (_) {}
    },
    buildSections(cities) {
      const grouped = {}
      cities.forEach(c => {
        const letter = c.letter || '#'
        if (!grouped[letter]) grouped[letter] = []
        grouped[letter].push(c)
      })
      return Object.keys(grouped).sort().map(letter => ({
        letter,
        list: grouped[letter]
      }))
    },
    onSearchInput() {},
    clearSearch() {
      this.searchKeyword = ''
    },
    selectCity(cityName) {
      const name = cityName.replace(/[市区县].*$/, '') + '市'
      const finalName = CITY_LETTER_MAP[name] ? name : cityName
      uni.setStorageSync('selectedCity', finalName)
      // 同时保存城市坐标
      const coords = CITY_COORDS[finalName]
      if (coords) {
        uni.setStorageSync('selectedCityCoords', coords)
      }
      // 设置标记，通知充电页面城市已变更需要重新定位
      uni.setStorageSync('cityJustChanged', true)
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
      letter-spacing: 2rpx;
    }

    .cs-city-group {
      margin-bottom: 8rpx;

      .cs-city-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 20rpx 0 12rpx;
        border-bottom: 1rpx solid #f0f0f0;

        .cs-city-name {
          font-size: 28rpx;
          color: #333;
          font-weight: 600;
        }

        &.selected {
          .cs-city-name {
            color: #07c160;
            font-weight: 700;
          }
        }

        &:active { background: #f8fffb; }
      }

      .cs-district-list {
        display: flex;
        flex-wrap: wrap;
        gap: 12rpx;
        padding: 10rpx 0 10rpx 20rpx;

        .cs-district-item {
          padding: 6rpx 16rpx;
          background: #f5f6fa;
          border-radius: 8rpx;

          .cs-district-name {
            font-size: 24rpx;
            color: #666;
          }

          &:active {
            background: #e8f8ee;
            .cs-district-name { color: #07c160; }
          }
        }
      }
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