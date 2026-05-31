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
import safeAreaMixin from '@/mixins/safe-area.js'

const ALL_CITIES = [
  { name: '北京市', letter: 'B' }, { name: '天津市', letter: 'T' }, { name: '上海市', letter: 'S' }, { name: '重庆市', letter: 'C' },
  { name: '石家庄市', letter: 'S' }, { name: '唐山市', letter: 'T' }, { name: '秦皇岛市', letter: 'Q' }, { name: '邯郸市', letter: 'H' },
  { name: '邢台市', letter: 'X' }, { name: '保定市', letter: 'B' }, { name: '张家口市', letter: 'Z' }, { name: '承德市', letter: 'C' },
  { name: '沧州市', letter: 'C' }, { name: '廊坊市', letter: 'L' }, { name: '衡水市', letter: 'H' },
  { name: '太原市', letter: 'T' }, { name: '大同市', letter: 'D' }, { name: '阳泉市', letter: 'Y' }, { name: '长治市', letter: 'C' },
  { name: '晋城市', letter: 'J' }, { name: '朔州市', letter: 'S' }, { name: '晋中市', letter: 'J' }, { name: '运城市', letter: 'Y' },
  { name: '忻州市', letter: 'X' }, { name: '临汾市', letter: 'L' }, { name: '吕梁市', letter: 'L' },
  { name: '呼和浩特市', letter: 'H' }, { name: '包头市', letter: 'B' }, { name: '乌海市', letter: 'W' }, { name: '赤峰市', letter: 'C' },
  { name: '通辽市', letter: 'T' }, { name: '鄂尔多斯市', letter: 'E' }, { name: '呼伦贝尔市', letter: 'H' },
  { name: '巴彦淖尔市', letter: 'B' }, { name: '乌兰察布市', letter: 'W' },
  { name: '沈阳市', letter: 'S' }, { name: '大连市', letter: 'D' }, { name: '鞍山市', letter: 'A' }, { name: '抚顺市', letter: 'F' },
  { name: '本溪市', letter: 'B' }, { name: '丹东市', letter: 'D' }, { name: '锦州市', letter: 'J' }, { name: '营口市', letter: 'Y' },
  { name: '阜新市', letter: 'F' }, { name: '辽阳市', letter: 'L' }, { name: '盘锦市', letter: 'P' }, { name: '铁岭市', letter: 'T' },
  { name: '朝阳市', letter: 'C' }, { name: '葫芦岛市', letter: 'H' },
  { name: '长春市', letter: 'C' }, { name: '吉林市', letter: 'J' }, { name: '四平市', letter: 'S' }, { name: '辽源市', letter: 'L' },
  { name: '通化市', letter: 'T' }, { name: '白山市', letter: 'B' }, { name: '松原市', letter: 'S' }, { name: '白城市', letter: 'B' },
  { name: '哈尔滨市', letter: 'H' }, { name: '齐齐哈尔市', letter: 'Q' }, { name: '鸡西市', letter: 'J' }, { name: '鹤岗市', letter: 'H' },
  { name: '双鸭山市', letter: 'S' }, { name: '大庆市', letter: 'D' }, { name: '伊春市', letter: 'Y' }, { name: '佳木斯市', letter: 'J' },
  { name: '七台河市', letter: 'Q' }, { name: '牡丹江市', letter: 'M' }, { name: '黑河市', letter: 'H' }, { name: '绥化市', letter: 'S' },
  { name: '南京市', letter: 'N' }, { name: '无锡市', letter: 'W' }, { name: '徐州市', letter: 'X' }, { name: '常州市', letter: 'C' },
  { name: '苏州市', letter: 'S' }, { name: '南通市', letter: 'N' }, { name: '连云港市', letter: 'L' }, { name: '淮安市', letter: 'H' },
  { name: '盐城市', letter: 'Y' }, { name: '扬州市', letter: 'Y' }, { name: '镇江市', letter: 'Z' }, { name: '泰州市', letter: 'T' },
  { name: '宿迁市', letter: 'S' },
  { name: '杭州市', letter: 'H' }, { name: '宁波市', letter: 'N' }, { name: '温州市', letter: 'W' }, { name: '嘉兴市', letter: 'J' },
  { name: '湖州市', letter: 'H' }, { name: '绍兴市', letter: 'S' }, { name: '金华市', letter: 'J' }, { name: '衢州市', letter: 'Q' },
  { name: '舟山市', letter: 'Z' }, { name: '台州市', letter: 'T' }, { name: '丽水市', letter: 'L' },
  { name: '合肥市', letter: 'H' }, { name: '芜湖市', letter: 'W' }, { name: '蚌埠市', letter: 'B' }, { name: '淮南市', letter: 'H' },
  { name: '马鞍山市', letter: 'M' }, { name: '淮北市', letter: 'H' }, { name: '铜陵市', letter: 'T' }, { name: '安庆市', letter: 'A' },
  { name: '黄山市', letter: 'H' }, { name: '滁州市', letter: 'C' }, { name: '阜阳市', letter: 'F' }, { name: '宿州市', letter: 'S' },
  { name: '六安市', letter: 'L' }, { name: '亳州市', letter: 'B' }, { name: '池州市', letter: 'C' }, { name: '宣城市', letter: 'X' },
  { name: '福州市', letter: 'F' }, { name: '厦门市', letter: 'X' }, { name: '莆田市', letter: 'P' }, { name: '三明市', letter: 'S' },
  { name: '泉州市', letter: 'Q' }, { name: '漳州市', letter: 'Z' }, { name: '南平市', letter: 'N' }, { name: '龙岩市', letter: 'L' },
  { name: '宁德市', letter: 'N' },
  { name: '南昌市', letter: 'N' }, { name: '景德镇市', letter: 'J' }, { name: '萍乡市', letter: 'P' }, { name: '九江市', letter: 'J' },
  { name: '新余市', letter: 'X' }, { name: '鹰潭市', letter: 'Y' }, { name: '赣州市', letter: 'G' }, { name: '吉安市', letter: 'J' },
  { name: '宜春市', letter: 'Y' }, { name: '抚州市', letter: 'F' }, { name: '上饶市', letter: 'S' },
  { name: '济南市', letter: 'J' }, { name: '青岛市', letter: 'Q' }, { name: '淄博市', letter: 'Z' }, { name: '枣庄市', letter: 'Z' },
  { name: '东营市', letter: 'D' }, { name: '烟台市', letter: 'Y' }, { name: '潍坊市', letter: 'W' }, { name: '济宁市', letter: 'J' },
  { name: '泰安市', letter: 'T' }, { name: '威海市', letter: 'W' }, { name: '日照市', letter: 'R' }, { name: '临沂市', letter: 'L' },
  { name: '德州市', letter: 'D' }, { name: '聊城市', letter: 'L' }, { name: '滨州市', letter: 'B' }, { name: '菏泽市', letter: 'H' },
  { name: '郑州市', letter: 'Z' }, { name: '开封市', letter: 'K' }, { name: '洛阳市', letter: 'L' }, { name: '平顶山市', letter: 'P' },
  { name: '安阳市', letter: 'A' }, { name: '鹤壁市', letter: 'H' }, { name: '新乡市', letter: 'X' }, { name: '焦作市', letter: 'J' },
  { name: '濮阳市', letter: 'P' }, { name: '许昌市', letter: 'X' }, { name: '漯河市', letter: 'L' }, { name: '三门峡市', letter: 'S' },
  { name: '南阳市', letter: 'N' }, { name: '商丘市', letter: 'S' }, { name: '信阳市', letter: 'X' }, { name: '周口市', letter: 'Z' },
  { name: '驻马店市', letter: 'Z' },
  { name: '武汉市', letter: 'W' }, { name: '黄石市', letter: 'H' }, { name: '十堰市', letter: 'S' }, { name: '宜昌市', letter: 'Y' },
  { name: '襄阳市', letter: 'X' }, { name: '鄂州市', letter: 'E' }, { name: '荆门市', letter: 'J' }, { name: '孝感市', letter: 'X' },
  { name: '荆州市', letter: 'J' }, { name: '黄冈市', letter: 'H' }, { name: '咸宁市', letter: 'X' }, { name: '随州市', letter: 'S' },
  { name: '长沙市', letter: 'C' }, { name: '株洲市', letter: 'Z' }, { name: '湘潭市', letter: 'X' }, { name: '衡阳市', letter: 'H' },
  { name: '邵阳市', letter: 'S' }, { name: '岳阳市', letter: 'Y' }, { name: '常德市', letter: 'C' }, { name: '张家界市', letter: 'Z' },
  { name: '益阳市', letter: 'Y' }, { name: '郴州市', letter: 'C' }, { name: '永州市', letter: 'Y' }, { name: '怀化市', letter: 'H' },
  { name: '娄底市', letter: 'L' },
  { name: '广州市', letter: 'G' }, { name: '韶关市', letter: 'S' }, { name: '深圳市', letter: 'S' }, { name: '珠海市', letter: 'Z' },
  { name: '汕头市', letter: 'S' }, { name: '佛山市', letter: 'F' }, { name: '江门市', letter: 'J' }, { name: '湛江市', letter: 'Z' },
  { name: '茂名市', letter: 'M' }, { name: '肇庆市', letter: 'Z' }, { name: '惠州市', letter: 'H' }, { name: '梅州市', letter: 'M' },
  { name: '汕尾市', letter: 'S' }, { name: '河源市', letter: 'H' }, { name: '阳江市', letter: 'Y' }, { name: '清远市', letter: 'Q' },
  { name: '东莞市', letter: 'D' }, { name: '中山市', letter: 'Z' }, { name: '潮州市', letter: 'C' }, { name: '揭阳市', letter: 'J' },
  { name: '云浮市', letter: 'Y' },
  { name: '南宁市', letter: 'N' }, { name: '柳州市', letter: 'L' }, { name: '桂林市', letter: 'G' }, { name: '梧州市', letter: 'W' },
  { name: '北海市', letter: 'B' }, { name: '防城港市', letter: 'F' }, { name: '钦州市', letter: 'Q' }, { name: '贵港市', letter: 'G' },
  { name: '玉林市', letter: 'Y' }, { name: '百色市', letter: 'B' }, { name: '贺州市', letter: 'H' }, { name: '河池市', letter: 'H' },
  { name: '来宾市', letter: 'L' }, { name: '崇左市', letter: 'C' },
  { name: '海口市', letter: 'H' }, { name: '三亚市', letter: 'S' }, { name: '三沙市', letter: 'S' }, { name: '儋州市', letter: 'D' },
  { name: '成都市', letter: 'C' }, { name: '自贡市', letter: 'Z' }, { name: '攀枝花市', letter: 'P' }, { name: '泸州市', letter: 'L' },
  { name: '德阳市', letter: 'D' }, { name: '绵阳市', letter: 'M' }, { name: '广元市', letter: 'G' }, { name: '遂宁市', letter: 'S' },
  { name: '内江市', letter: 'N' }, { name: '乐山市', letter: 'L' }, { name: '南充市', letter: 'N' }, { name: '眉山市', letter: 'M' },
  { name: '宜宾市', letter: 'Y' }, { name: '广安市', letter: 'G' }, { name: '达州市', letter: 'D' }, { name: '雅安市', letter: 'Y' },
  { name: '巴中市', letter: 'B' }, { name: '资阳市', letter: 'Z' },
  { name: '贵阳市', letter: 'G' }, { name: '六盘水市', letter: 'L' }, { name: '遵义市', letter: 'Z' }, { name: '安顺市', letter: 'A' },
  { name: '毕节市', letter: 'B' }, { name: '铜仁市', letter: 'T' },
  { name: '昆明市', letter: 'K' }, { name: '曲靖市', letter: 'Q' }, { name: '玉溪市', letter: 'Y' }, { name: '保山市', letter: 'B' },
  { name: '昭通市', letter: 'Z' }, { name: '丽江市', letter: 'L' }, { name: '普洱市', letter: 'P' }, { name: '临沧市', letter: 'L' },
  { name: '拉萨市', letter: 'L' }, { name: '日喀则市', letter: 'R' }, { name: '昌都市', letter: 'C' }, { name: '林芝市', letter: 'L' },
  { name: '山南市', letter: 'S' }, { name: '那曲市', letter: 'N' },
  { name: '西安市', letter: 'X' }, { name: '铜川市', letter: 'T' }, { name: '宝鸡市', letter: 'B' }, { name: '咸阳市', letter: 'X' },
  { name: '渭南市', letter: 'W' }, { name: '延安市', letter: 'Y' }, { name: '汉中市', letter: 'H' }, { name: '榆林市', letter: 'Y' },
  { name: '安康市', letter: 'A' }, { name: '商洛市', letter: 'S' },
  { name: '兰州市', letter: 'L' }, { name: '嘉峪关市', letter: 'J' }, { name: '金昌市', letter: 'J' }, { name: '白银市', letter: 'B' },
  { name: '天水市', letter: 'T' }, { name: '武威市', letter: 'W' }, { name: '张掖市', letter: 'Z' }, { name: '平凉市', letter: 'P' },
  { name: '酒泉市', letter: 'J' }, { name: '庆阳市', letter: 'Q' }, { name: '定西市', letter: 'D' }, { name: '陇南市', letter: 'L' },
  { name: '西宁市', letter: 'X' }, { name: '海东市', letter: 'H' },
  { name: '银川市', letter: 'Y' }, { name: '石嘴山市', letter: 'S' }, { name: '吴忠市', letter: 'W' }, { name: '固原市', letter: 'G' },
  { name: '中卫市', letter: 'Z' },
  { name: '乌鲁木齐市', letter: 'W' }, { name: '克拉玛依市', letter: 'K' }, { name: '吐鲁番市', letter: 'T' }, { name: '哈密市', letter: 'H' },
  { name: '香港特别行政区', letter: 'X' }, { name: '澳门特别行政区', letter: 'A' }, { name: '台北市', letter: 'T' }
]

export default {
  mixins: [safeAreaMixin],
  data() {
    return {
      searchKeyword: '',
      currentCity: uni.getStorageSync('selectedCity') || '济南市',
      activeLetter: '',
      scrollInto: '',
      citySections: this.buildSections(ALL_CITIES),
      letters: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')
    }
  },
  computed: {
    filteredCities() {
      if (!this.searchKeyword) return ALL_CITIES
      return ALL_CITIES.filter(c => c.name.includes(this.searchKeyword))
    }
  },
  methods: {
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