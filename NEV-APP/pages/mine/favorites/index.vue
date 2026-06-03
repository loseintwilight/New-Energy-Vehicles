<template>
  <view class="page-container">
    <!-- Tab 切换栏 -->
    <view class="tab-bar">
      <view
        v-for="tab in tabs"
        :key="tab.value"
        class="tab-item"
        :class="{ active: activeTab === tab.value }"
        @click="switchTab(tab.value)"
      >
        <text>{{ tab.label }}</text>
        <view class="tab-line" v-if="activeTab === tab.value"></view>
      </view>
    </view>

    <!-- 汇总统计 -->
    <view class="summary-bar">
      <view class="summary-item">
        <text class="s-val">{{ summaryInfo.count }}</text>
        <text class="s-label">{{ summaryInfo.countLabel }}</text>
      </view>
      <view class="summary-item">
        <text class="s-val">{{ summaryInfo.subVal }}</text>
        <text class="s-label">{{ summaryInfo.subLabel }}</text>
      </view>
      <view class="summary-item">
        <text class="s-val">{{ summaryInfo.total }}</text>
        <text class="s-label">{{ summaryInfo.totalLabel }}</text>
      </view>
    </view>

    <scroll-view scroll-y class="list-scroll">
      <!-- 全部 -->
      <template v-if="activeTab === 'all'">
        <view class="section-block" v-if="textFavorites.length > 0">
          <view class="section-title-row">
            <text class="section-title">文字收藏</text>
            <text class="section-more" @click="switchTab('text')">更多 <u-icon name="arrow-right" size="20" color="#999"></u-icon></text>
          </view>
          <view v-for="item in textFavorites.slice(0, 2)" :key="item.id" class="fav-card text-card" @click="handleDetail(item)">
            <view class="fc-header">
              <text class="fc-source">{{ item.source }}</text>
              <text class="fc-time">{{ item.time }}</text>
            </view>
            <text class="fc-title">{{ item.title }}</text>
            <text class="fc-desc">{{ item.desc }}</text>
          </view>
        </view>
        <view class="section-block" v-if="carFavorites.length > 0">
          <view class="section-title-row">
            <text class="section-title">车辆收藏</text>
            <text class="section-more" @click="switchTab('car')">更多 <u-icon name="arrow-right" size="20" color="#999"></u-icon></text>
          </view>
          <view v-for="item in carFavorites.slice(0, 2)" :key="item.id" class="fav-card car-card" @click="handleDetail(item)">
            <view class="fc-row">
              <text class="fc-label">车型</text>
              <text class="fc-value">{{ item.model }}</text>
            </view>
            <view class="fc-row">
              <text class="fc-label">续航</text>
              <text class="fc-value">{{ item.range }}km</text>
            </view>
            <view class="fc-row">
              <text class="fc-label">价格</text>
              <text class="fc-value price">{{ item.price }}万元</text>
            </view>
          </view>
        </view>
        <view class="section-block" v-if="chargeFavorites.length > 0">
          <view class="section-title-row">
            <text class="section-title">充电收藏</text>
            <text class="section-more" @click="switchTab('charge')">更多 <u-icon name="arrow-right" size="20" color="#999"></u-icon></text>
          </view>
          <view v-for="item in chargeFavorites.slice(0, 2)" :key="item.id" class="fav-card charge-card" @click="handleDetail(item)">
            <view class="fc-header">
              <text class="fc-station">{{ item.stationName }}</text>
              <text class="fc-distance">距您{{ item.distance }}km</text>
            </view>
            <view class="fc-row">
              <text class="fc-label">{{ item.address }}</text>
              <text class="fc-price">¥{{ item.price }}/度</text>
            </view>
            <view class="fc-tags">
              <text v-for="(tag, ti) in item.tags" :key="ti" class="tag">{{ tag }}</text>
            </view>
          </view>
        </view>
        <view class="empty" v-if="textFavorites.length === 0 && carFavorites.length === 0 && chargeFavorites.length === 0">
          <uni-icons type="star" size="80" color="#ddd"></uni-icons>
          <text class="empty-text">暂无收藏内容</text>
          <text class="empty-sub">去发现更多精彩内容吧</text>
        </view>
      </template>

      <!-- 文字收藏 -->
      <template v-if="activeTab === 'text'">
        <view class="fav-list" v-if="textFavorites.length > 0">
          <view v-for="item in textFavorites" :key="item.id" class="fav-card text-card" @click="handleDetail(item)">
            <view class="fc-header">
              <text class="fc-source">{{ item.source }}</text>
              <text class="fc-time">{{ item.time }}</text>
            </view>
            <text class="fc-title">{{ item.title }}</text>
            <text class="fc-desc">{{ item.desc }}</text>
            <view class="fc-footer">
              <text class="fc-unfavorite" @click.stop="removeFavorite('text', item.id)">取消收藏</text>
            </view>
          </view>
        </view>
        <view class="empty" v-else>
          <uni-icons type="eye" size="80" color="#ddd"></uni-icons>
          <text class="empty-text">暂无文字收藏</text>
          <text class="empty-sub">阅读文章时点击收藏按钮即可保存</text>
        </view>
      </template>

      <!-- 车辆收藏 -->
      <template v-if="activeTab === 'car'">
        <view class="fav-list" v-if="carFavorites.length > 0">
          <view v-for="item in carFavorites" :key="item.id" class="fav-card car-card" @click="handleDetail(item)">
            <view class="fc-row">
              <text class="fc-label">车型</text>
              <text class="fc-value">{{ item.model }}</text>
            </view>
            <view class="fc-row">
              <text class="fc-label">品牌</text>
              <text class="fc-value">{{ item.brand }}</text>
            </view>
            <view class="fc-row">
              <text class="fc-label">续航</text>
              <text class="fc-value">{{ item.range }}km</text>
            </view>
            <view class="fc-row">
              <text class="fc-label">电池容量</text>
              <text class="fc-value">{{ item.battery }}kWh</text>
            </view>
            <view class="fc-row">
              <text class="fc-label">价格</text>
              <text class="fc-value price">{{ item.price }}万元</text>
            </view>
            <view class="fc-footer">
              <text class="fc-unfavorite" @click.stop="removeFavorite('car', item.id)">取消收藏</text>
            </view>
          </view>
        </view>
        <view class="empty" v-else>
          <uni-icons type="car" size="80" color="#ddd"></uni-icons>
          <text class="empty-text">暂无车辆收藏</text>
          <text class="empty-sub">浏览车型时点击收藏按钮即可保存</text>
        </view>
      </template>

      <!-- 充电收藏 -->
      <template v-if="activeTab === 'charge'">
        <view class="fav-list" v-if="chargeFavorites.length > 0">
          <view v-for="item in chargeFavorites" :key="item.id" class="fav-card charge-card" @click="handleDetail(item)">
            <view class="fc-header">
              <text class="fc-station">{{ item.stationName }}</text>
              <text class="fc-distance">距您{{ item.distance }}km</text>
            </view>
            <view class="fc-sub-header">
              <text class="fc-address">{{ item.address }}</text>
              <text class="fc-price">¥{{ item.price }}/度</text>
            </view>
            <view class="fc-tags">
              <text v-for="(tag, ti) in item.tags" :key="ti" class="tag">{{ tag }}</text>
            </view>
            <view class="fc-footer">
              <text class="fc-unfavorite" @click.stop="removeFavorite('charge', item.id)">取消收藏</text>
            </view>
          </view>
        </view>
        <view class="empty" v-else>
          <uni-icons type="bolt" size="80" color="#ddd"></uni-icons>
          <text class="empty-text">暂无充电收藏</text>
          <text class="empty-sub">浏览充电站时点击收藏按钮即可保存</text>
        </view>
      </template>

      <view class="bottom-space"></view>
    </scroll-view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      activeTab: 'all',
      tabs: [
        { label: '全部', value: 'all' },
        { label: '文字收藏', value: 'text' },
        { label: '车辆收藏', value: 'car' },
        { label: '充电收藏', value: 'charge' }
      ],
      textFavorites: [
        { id: 1, title: '纯电动车冬季续航保养指南', desc: '冬季用车电池注意事项，延长续航里程实用技巧', source: '保养知识', time: '2026-05-28' },
        { id: 2, title: '比亚迪海豚 原厂空调滤芯', desc: '适用车型：比亚迪海豚 2024款全系', source: '配件商城', time: '2026-05-25' },
        { id: 3, title: '济南鑫维保-经十西路店', desc: '专业新能源汽车维修保养，服务评分4.8分', source: '维保店铺', time: '2026-05-20' },
        { id: 4, title: '电动车快充 vs 慢充区别详解', desc: '不同充电方式对电池寿命的影响分析', source: '充电科普', time: '2026-05-15' },
        { id: 5, title: '新能源汽车充电注意事项全攻略', desc: '详细介绍了充电过程中需要注意的安全事项、充电枪使用方法和日常维护技巧。', source: '充电百科', time: '2026-05-10' },
        { id: 6, title: '2026年最新充电桩补贴政策解读', desc: '各地对充电桩建设和购买新能源汽车的补贴政策汇总。', source: '政策资讯', time: '2026-05-08' }
      ],
      carFavorites: [
        { id: 1, model: '比亚迪 海豹 2025款', brand: '比亚迪', range: 700, battery: 82.5, price: 22.98 },
        { id: 2, model: '特斯拉 Model 3 焕新版', brand: '特斯拉', range: 606, battery: 60.0, price: 24.59 },
        { id: 3, model: '小鹏 P7i 智驾版', brand: '小鹏', range: 650, battery: 86.2, price: 26.39 },
        { id: 4, model: '蔚来 ET5 75kWh', brand: '蔚来', range: 560, battery: 75.0, price: 29.80 }
      ],
      chargeFavorites: [
        { id: 1, stationName: '文常山公园充电站', distance: '3.7', address: '山东省济南市长清区文常山公园停车场', price: '0.88', tags: ['快充', '免费停车', '即插即充'] },
        { id: 2, stationName: '西站公共充电站', distance: '6.7', address: '济南市槐荫区日照路', price: '0.95', tags: ['快充', '免费停车4小时'] },
        { id: 3, stationName: '齐鲁软件园充电站', distance: '5.1', address: '济南市高新区齐鲁软件园', price: '0.78', tags: ['慢充', '夜间优惠'] }
      ]
    }
  },
  computed: {
    summaryInfo() {
      switch (this.activeTab) {
        case 'text':
          return {
            count: this.textFavorites.length,
            countLabel: '收藏文章',
            subVal: '6篇',
            subLabel: '来自6个来源',
            total: this.textFavorites.length + '篇',
            totalLabel: '收藏总数'
          }
        case 'car':
          return {
            count: this.carFavorites.length,
            countLabel: '收藏车型',
            subVal: Math.max(...this.carFavorites.map(c => c.range)),
            subLabel: '最长续航(km)',
            total: this.carFavorites.length + '款',
            totalLabel: '意向车型'
          }
        case 'charge':
          return {
            count: this.chargeFavorites.length,
            countLabel: '收藏电站',
            subVal: this.chargeFavorites.reduce((min, c) => Math.min(min, parseFloat(c.distance)), Infinity).toFixed(1),
            subLabel: '最近距离(km)',
            total: '¥' + (this.chargeFavorites.reduce((sum, c) => sum + parseFloat(c.price), 0) / this.chargeFavorites.length).toFixed(2),
            totalLabel: '均价/度'
          }
        default: // all
          return {
            count: this.textFavorites.length + this.carFavorites.length + this.chargeFavorites.length,
            countLabel: '全部收藏',
            subVal: this.textFavorites.length + '/' + this.carFavorites.length + '/' + this.chargeFavorites.length,
            subLabel: '文字/车辆/充电',
            total: '3类',
            totalLabel: '收藏分类'
          }
      }
    }
  },
  methods: {
    switchTab(value) {
      this.activeTab = value
    },
    handleDetail(item) {
      uni.showToast({ title: '查看详情：' + (item.title || item.model || item.stationName), icon: 'none' })
    },
    removeFavorite(category, id) {
      const keyMap = { text: 'textFavorites', car: 'carFavorites', charge: 'chargeFavorites' }
      const key = keyMap[category]
      this[key] = this[key].filter(item => item.id !== id)
      uni.showToast({ title: '已取消收藏', icon: 'success' })
    }
  }
}
</script>

<style lang="scss" scoped>
page {
  background-color: #f5f6f7;
  min-height: 100vh;
}

.tab-bar {
  display: flex;
  background: #fff;
  padding: 0 20rpx;
  position: sticky;
  top: 0;
  z-index: 10;
  border-bottom: 1rpx solid #f0f0f0;
}

.tab-item {
  flex: 1;
  text-align: center;
  padding: 24rpx 0 20rpx;
  position: relative;
  font-size: 26rpx;
  color: #666;

  &.active {
    color: #3c96f3;
    font-weight: 600;
  }

  .tab-line {
    position: absolute;
    bottom: 0;
    left: 50%;
    transform: translateX(-50%);
    width: 40rpx;
    height: 4rpx;
    background: #3c96f3;
    border-radius: 2rpx;
  }
}

.summary-bar {
  display: flex;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 30rpx 20rpx;
  margin: 20rpx 30rpx;
  border-radius: 16rpx;
}

.summary-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.s-val {
  font-size: 30rpx;
  font-weight: 700;
  color: #fff;
}

.s-label {
  font-size: 22rpx;
  color: rgba(255, 255, 255, 0.7);
  margin-top: 6rpx;
}

.list-scroll {
  height: calc(100vh - 260rpx);
}

.section-block {
  margin: 0 30rpx 20rpx;

  .section-title-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 12rpx 0;

    .section-title {
      font-size: 28rpx;
      font-weight: 700;
      color: #1a1a1a;
    }

    .section-more {
      font-size: 24rpx;
      color: #999;
      display: flex;
      align-items: center;
    }
  }
}

.fav-list {
  padding: 0 30rpx 20rpx;
}

.fav-card {
  background: #fff;
  border-radius: 14rpx;
  padding: 24rpx;
  margin-bottom: 16rpx;
}

// 文字收藏卡片
.text-card {
  .fc-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12rpx;

    .fc-source {
      font-size: 22rpx;
      color: #3c96f3;
      background: #e8f2ff;
      padding: 4rpx 12rpx;
      border-radius: 6rpx;
    }

    .fc-time {
      font-size: 22rpx;
      color: #bbb;
    }
  }

  .fc-title {
    font-size: 28rpx;
    font-weight: 600;
    color: #1a1a1a;
    display: block;
    margin-bottom: 8rpx;
    line-height: 1.5;
  }

  .fc-desc {
    font-size: 24rpx;
    color: #888;
    display: block;
    line-height: 1.5;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
  }
}

// 车辆收藏卡片
.car-card {
  .fc-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 8rpx 0;
    border-bottom: 1rpx solid #f9f9f9;

    &:last-of-type {
      border-bottom: none;
    }

    .fc-label {
      font-size: 24rpx;
      color: #888;
    }

    .fc-value {
      font-size: 26rpx;
      color: #333;
      font-weight: 500;

      &.price {
        color: #ff4757;
        font-weight: 700;
        font-size: 28rpx;
      }
    }
  }
}

// 充电收藏卡片
.charge-card {
  .fc-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10rpx;

    .fc-station {
      font-size: 28rpx;
      font-weight: 600;
      color: #1a1a1a;
    }

    .fc-distance {
      font-size: 22rpx;
      color: #3c96f3;
    }
  }

  .fc-sub-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10rpx;

    .fc-address {
      font-size: 22rpx;
      color: #888;
      flex: 1;
      margin-right: 12rpx;
    }

    .fc-price {
      font-size: 28rpx;
      font-weight: 700;
      color: #ff6b00;
    }
  }

  .fc-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 8rpx;

    .tag {
      font-size: 20rpx;
      color: #3c96f3;
      background: #e8f2ff;
      padding: 4rpx 12rpx;
      border-radius: 6rpx;
    }
  }
}

.fc-footer {
  margin-top: 16rpx;
  padding-top: 12rpx;
  border-top: 1rpx solid #f5f5f5;
  display: flex;
  justify-content: flex-end;

  .fc-unfavorite {
    font-size: 24rpx;
    color: #999;
    padding: 4rpx 16rpx;
    border: 1rpx solid #ddd;
    border-radius: 20rpx;
  }
}

.empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 120rpx;
}

.empty-text {
  font-size: 28rpx;
  color: #999;
  margin-top: 20rpx;
}

.empty-sub {
  font-size: 24rpx;
  color: #bbb;
  margin-top: 8rpx;
}

.bottom-space {
  height: 40rpx;
}
</style>