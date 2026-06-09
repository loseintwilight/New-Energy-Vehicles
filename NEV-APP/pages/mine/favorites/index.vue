<template>
  <view class="page-container">
    <!-- Tab 切换栏 -->
    <view class="tab-bar">
      <view class="tab-bg"></view>
      <view
        v-for="tab in tabs"
        :key="tab.value"
        class="tab-item"
        :class="{ active: activeTab === tab.value }"
        @click="switchTab(tab.value)"
      >
        <view class="tab-icon-wrapper">
          <template v-if="tab.value === 'car'">
            <image src="/static/images/index/car.png" class="tab-icon-img" mode="aspectFit" />
          </template>
          <template v-else>
            <uni-icons :type="tab.icon" :size="26" :color="activeTab === tab.value ? '#fff' : '#666'"></uni-icons>
          </template>
        </view>
        <text class="tab-text">{{ tab.label }}</text>
        <view class="tab-indicator" v-if="activeTab === tab.value"></view>
      </view>
    </view>

    <!-- 汇总统计卡片 -->
    <view class="summary-card">
      <view class="summary-bg"></view>
      <view class="summary-content">
        <view class="summary-main">
          <view class="summary-icon">
            <uni-icons type="star" size="40" color="#fff"></uni-icons>
          </view>
          <view class="summary-info">
            <text class="summary-count">{{ summaryInfo.count }}</text>
            <text class="summary-label">{{ summaryInfo.countLabel }}</text>
          </view>
        </view>
        <view class="summary-divider"></view>
        <view class="summary-detail">
          <view class="detail-item">
            <text class="detail-value">{{ summaryInfo.subVal }}</text>
            <text class="detail-label">{{ summaryInfo.subLabel }}</text>
          </view>
          <view class="detail-item">
            <text class="detail-value">{{ summaryInfo.total }}</text>
            <text class="detail-label">{{ summaryInfo.totalLabel }}</text>
          </view>
        </view>
      </view>
    </view>

    <scroll-view scroll-y class="list-scroll">
      <!-- 全部 -->
      <template v-if="activeTab === 'all'">
        <view class="section-block" v-if="textFavorites.length > 0">
          <view class="section-header">
            <view class="section-title-row">
              <view class="section-icon-box bg-blue">
                <uni-icons type="info" size="24" color="#3c96f3"></uni-icons>
              </view>
              <text class="section-title">文字收藏</text>
            </view>
            <view class="section-more" @click="switchTab('text')">
              <text>查看全部</text>
              <uni-icons type="forward" size="20" color="#999"></uni-icons>
            </view>
          </view>
          <view v-for="item in textFavorites.slice(0, 2)" :key="item.id" class="fav-card text-card" @click="handleDetail(item)">
            <view class="card-bg"></view>
            <view class="card-content">
              <view class="fc-header">
                <view class="fc-source-tag">
                  <text>{{ item.source }}</text>
                </view>
                <text class="fc-time">{{ item.time }}</text>
              </view>
              <text class="fc-title">{{ item.title }}</text>
              <text class="fc-desc">{{ item.desc }}</text>
            </view>
            <view class="card-arrow">
              <uni-icons type="forward" size="24" color="#ccc"></uni-icons>
            </view>
          </view>
        </view>

        <view class="section-block" v-if="carFavorites.length > 0">
          <view class="section-header">
            <view class="section-title-row">
              <view class="section-icon-box bg-orange">
                <image src="/static/images/index/car.png" class="section-icon-img" mode="aspectFit" />
              </view>
              <text class="section-title">车辆收藏</text>
            </view>
            <view class="section-more" @click="switchTab('car')">
              <text>查看全部</text>
              <uni-icons type="forward" size="20" color="#999"></uni-icons>
            </view>
          </view>
          <view v-for="item in carFavorites.slice(0, 2)" :key="item.id" class="fav-card car-card" @click="handleDetail(item)">
            <view class="card-bg car-bg"></view>
            <view class="card-content">
              <view class="car-main">
                <view class="car-icon-box">
                  <image src="/static/images/index/car.png" class="car-card-icon" mode="aspectFit" />
                </view>
                <view class="car-info">
                  <text class="car-model">{{ item.model }}</text>
                  <text class="car-brand">{{ item.brand }}</text>
                </view>
              </view>
              <view class="car-specs">
                <view class="spec-item">
                  <text class="spec-label">续航</text>
                  <text class="spec-value">{{ item.range }}km</text>
                </view>
                <view class="spec-item">
                  <text class="spec-label">电池</text>
                  <text class="spec-value">{{ item.battery }}kWh</text>
                </view>
              </view>
              <view class="car-price-row">
                <text class="price-symbol">¥</text>
                <text class="price-num">{{ item.price }}</text>
                <text class="price-unit">万</text>
              </view>
            </view>
            <view class="card-arrow">
              <uni-icons type="forward" size="24" color="#ccc"></uni-icons>
            </view>
          </view>
        </view>

        <view class="section-block" v-if="chargeFavorites.length > 0">
          <view class="section-header">
            <view class="section-title-row">
              <view class="section-icon-box bg-green">
                <uni-icons type="location" size="24" color="#4caf50"></uni-icons>
              </view>
              <text class="section-title">充电收藏</text>
            </view>
            <view class="section-more" @click="switchTab('charge')">
              <text>查看全部</text>
              <uni-icons type="forward" size="20" color="#999"></uni-icons>
            </view>
          </view>
          <view v-for="item in chargeFavorites.slice(0, 2)" :key="item.id" class="fav-card charge-card" @click="handleDetail(item)">
            <view class="card-bg charge-bg"></view>
            <view class="card-content">
              <view class="charge-header">
                <view class="charge-icon">
                <uni-icons type="location" size="32" color="#fff"></uni-icons>
              </view>
                <view class="charge-info">
                  <text class="charge-station">{{ item.stationName }}</text>
                  <text class="charge-address">{{ item.address }}</text>
                </view>
                <text class="charge-price">¥{{ item.price }}<text class="price-unit-small">/度</text></text>
              </view>
              <view class="charge-footer">
                <view class="distance-tag">
                  <uni-icons type="location" size="18" color="#3c96f3"></uni-icons>
                  <text>距您{{ item.distance }}km</text>
                </view>
                <view class="charge-tags">
                  <text v-for="(tag, ti) in item.tags" :key="ti" class="tag">{{ tag }}</text>
                </view>
              </view>
            </view>
            <view class="card-arrow">
              <uni-icons type="forward" size="24" color="#ccc"></uni-icons>
            </view>
          </view>
        </view>

        <view class="empty-state" v-if="textFavorites.length === 0 && carFavorites.length === 0 && chargeFavorites.length === 0">
          <view class="empty-icon-wrapper">
            <uni-icons type="star" size="100" color="#e0e0e0"></uni-icons>
          </view>
          <text class="empty-title">暂无收藏内容</text>
          <text class="empty-desc">去发现更多精彩内容吧</text>
          <view class="empty-action" @click="goExplore">
            <text>去逛逛</text>
            <uni-icons type="forward" size="20" color="#fff"></uni-icons>
          </view>
        </view>
      </template>

      <!-- 文字收藏 -->
      <template v-if="activeTab === 'text'">
        <view class="fav-list" v-if="textFavorites.length > 0">
          <view v-for="item in textFavorites" :key="item.id" class="fav-card text-card-full" @click="handleDetail(item)">
            <view class="card-content">
              <view class="fc-header">
                <view class="fc-source-tag">
                  <text>{{ item.source }}</text>
                </view>
                <text class="fc-time">{{ item.time }}</text>
              </view>
              <text class="fc-title">{{ item.title }}</text>
              <text class="fc-desc">{{ item.desc }}</text>
            </view>
            <view class="card-actions">
              <view class="action-btn unfavorite-btn" @click.stop="removeFavorite('text', item.id)">
                <uni-icons type="heart" size="22" color="#ff4757"></uni-icons>
                <text>取消收藏</text>
              </view>
              <view class="card-arrow">
                <uni-icons type="forward" size="24" color="#ccc"></uni-icons>
              </view>
            </view>
          </view>
        </view>
        <view class="empty-state" v-else>
          <view class="empty-icon-wrapper">
            <uni-icons type="info" size="100" color="#e0e0e0"></uni-icons>
          </view>
          <text class="empty-title">暂无文字收藏</text>
          <text class="empty-desc">阅读文章时点击收藏按钮即可保存</text>
        </view>
      </template>

      <!-- 车辆收藏 -->
      <template v-if="activeTab === 'car'">
        <view class="fav-list" v-if="carFavorites.length > 0">
          <view v-for="item in carFavorites" :key="item.id" class="fav-card car-card-full" @click="handleDetail(item)">
            <view class="card-content">
              <view class="car-main">
                <view class="car-icon-box">
                  <image src="/static/images/index/car.png" class="car-card-icon" mode="aspectFit" />
                </view>
                <view class="car-info">
                  <text class="car-model">{{ item.model }}</text>
                  <text class="car-brand">{{ item.brand }}</text>
                </view>
              </view>
              <view class="car-specs-grid">
                <view class="spec-item-grid">
                  <text class="spec-value">{{ item.range }}km</text>
                  <text class="spec-label">续航</text>
                </view>
                <view class="spec-item-grid">
                  <text class="spec-value">{{ item.battery }}kWh</text>
                  <text class="spec-label">电池容量</text>
                </view>
              </view>
              <view class="car-price-row">
                <text class="price-symbol">¥</text>
                <text class="price-num">{{ item.price }}</text>
                <text class="price-unit">万起</text>
              </view>
            </view>
            <view class="card-actions">
              <view class="action-btn unfavorite-btn" @click.stop="removeFavorite('car', item.id)">
                <uni-icons type="heart" size="22" color="#ff4757"></uni-icons>
                <text>取消收藏</text>
              </view>
              <view class="card-arrow">
                <uni-icons type="forward" size="24" color="#ccc"></uni-icons>
              </view>
            </view>
          </view>
        </view>
        <view class="empty-state" v-else>
          <view class="empty-icon-wrapper">
            <image src="/static/images/index/car.png" class="empty-icon-img" mode="aspectFit" />
          </view>
          <text class="empty-title">暂无车辆收藏</text>
          <text class="empty-desc">浏览车型时点击收藏按钮即可保存</text>
        </view>
      </template>

      <!-- 充电收藏 -->
      <template v-if="activeTab === 'charge'">
        <view class="fav-list" v-if="chargeFavorites.length > 0">
          <view v-for="item in chargeFavorites" :key="item.id" class="fav-card charge-card-full" @click="handleDetail(item)">
            <view class="card-content">
              <view class="charge-header">
                <view class="charge-icon">
                <uni-icons type="location" size="32" color="#fff"></uni-icons>
              </view>
                <view class="charge-info">
                  <text class="charge-station">{{ item.stationName }}</text>
                  <text class="charge-address">{{ item.address }}</text>
                </view>
                <text class="charge-price">¥{{ item.price }}<text class="price-unit-small">/度</text></text>
              </view>
              <view class="charge-footer">
                <view class="distance-tag">
                  <uni-icons type="location" size="18" color="#3c96f3"></uni-icons>
                  <text>距您{{ item.distance }}km</text>
                </view>
                <view class="charge-tags">
                  <text v-for="(tag, ti) in item.tags" :key="ti" class="tag">{{ tag }}</text>
                </view>
              </view>
            </view>
            <view class="card-actions">
              <view class="action-btn unfavorite-btn" @click.stop="removeFavorite('charge', item.id)">
                <uni-icons type="heart" size="22" color="#ff4757"></uni-icons>
                <text>取消收藏</text>
              </view>
              <view class="card-arrow">
                <uni-icons type="forward" size="24" color="#ccc"></uni-icons>
              </view>
            </view>
          </view>
        </view>
        <view class="empty-state" v-else>
          <view class="empty-icon-wrapper">
            <uni-icons type="location" size="100" color="#e0e0e0"></uni-icons>
          </view>
          <text class="empty-title">暂无充电收藏</text>
          <text class="empty-desc">浏览充电站时点击收藏按钮即可保存</text>
        </view>
      </template>

      <view class="bottom-space"></view>
    </scroll-view>
  </view>
</template>

<script>
import { getCollectionList, cancelCollection } from '@/api/mine/collection'

export default {
  data() {
    return {
      activeTab: 'all',
      tabs: [
        { label: '全部', value: 'all', icon: 'star' },
        { label: '文字', value: 'text', icon: 'info' },
        { label: '车辆', value: 'car', icon: 'car' },
        { label: '充电', value: 'charge', icon: 'location' }
      ],
      textFavorites: [],
      carFavorites: [],
      chargeFavorites: [],
      loading: false
    }
  },
  computed: {
    summaryInfo() {
      switch (this.activeTab) {
        case 'text':
          return {
            count: this.textFavorites.length,
            countLabel: '文字收藏',
            subVal: this.textFavorites.length + '篇',
            subLabel: '文章数量',
            total: this.getUniqueSources(this.textFavorites) + '个来源',
            totalLabel: '来源'
          }
        case 'car':
          return {
            count: this.carFavorites.length,
            countLabel: '车辆收藏',
            subVal: this.carFavorites.length > 0 ? Math.max(...this.carFavorites.map(c => c.range || 0)) + 'km' : '0km',
            subLabel: '最长续航',
            total: this.carFavorites.length + '款',
            totalLabel: '收藏车型'
          }
        case 'charge':
          return {
            count: this.chargeFavorites.length,
            countLabel: '充电收藏',
            subVal: this.chargeFavorites.length > 0 ? '¥' + (this.chargeFavorites.reduce((sum, c) => sum + parseFloat(c.price), 0) / this.chargeFavorites.length).toFixed(2) : '¥0',
            subLabel: '均价/度',
            total: this.chargeFavorites.length > 0 ? Math.min(...this.chargeFavorites.map(c => parseFloat(c.distance) || Infinity)).toFixed(1) + 'km' : '0km',
            totalLabel: '最近距离'
          }
        default:
          return {
            count: this.textFavorites.length + this.carFavorites.length + this.chargeFavorites.length,
            countLabel: '全部收藏',
            subVal: this.textFavorites.length + '/' + this.carFavorites.length + '/' + this.chargeFavorites.length,
            subLabel: '文字/车辆/充电',
            total: '3类',
            totalLabel: '分类'
          }
      }
    }
  },
  onShow() {
    this.loadFavorites()
  },
  methods: {
    getUniqueSources(list) {
      return new Set(list.map(item => item.source)).size
    },
    async loadFavorites() {
      this.loading = true
      try {
        const res = await getCollectionList()
        const data = res.data || res
        const list = data.rows || data.list || data || []
        
        this.textFavorites = list.filter(item => item.type === 'text' || item.type === 0).map(item => this.formatTextFavorite(item))
        this.carFavorites = list.filter(item => item.type === 'car' || item.type === 1).map(item => this.formatCarFavorite(item))
        this.chargeFavorites = list.filter(item => item.type === 'charge' || item.type === 2).map(item => this.formatChargeFavorite(item))
      } catch (e) {
        console.error('加载收藏列表失败', e)
      } finally {
        this.loading = false
      }
    },
    formatTextFavorite(item) {
      return {
        id: item.id,
        targetId: item.targetId || 0,
        title: item.title || item.articleTitle || '',
        desc: item.desc || item.articleDesc || '',
        source: item.source || item.articleSource || '来源',
        time: item.createTime ? item.createTime.split(' ')[0] : ''
      }
    },
    formatCarFavorite(item) {
      return {
        id: item.id,
        targetId: item.targetId || 0,
        model: item.model || item.carModel || '',
        brand: item.brand || '',
        range: item.range || item.batteryRange || 0,
        battery: item.battery || item.batteryCapacity || 0,
        price: item.price || 0
      }
    },
    formatChargeFavorite(item) {
      return {
        id: item.id,
        targetId: item.targetId || 0,
        stationName: item.stationName || item.name || '',
        distance: item.distance || '0',
        address: item.address || '',
        price: item.price || 0,
        tags: item.tags ? (typeof item.tags === 'string' ? item.tags.split(',') : item.tags) : ['快充', '免费停车']
      }
    },
    switchTab(value) {
      this.activeTab = value
    },
    handleDetail(item) {
      // 根据卡片的数据字段判断类型（兼容全部tab和独立tab）
      if (item.title) {
        // 文章 → 跳转详情页
        const articleType = (item.source && (item.source.indexOf('政策') !== -1 || item.source.indexOf('法规') !== -1)) ? 'policy' : 'science'
        uni.navigateTo({ url: `/pages/index/detail?type=${articleType}&id=${item.targetId}` })
      } else if (item.model) {
        // 车辆 → 跳转购车页（使用车型对应图片）
        const carImageMap = {
          '比亚迪汉EV冠军版': '/static/images/car/main/比亚迪汉EV冠军版 .jpg',
          '特斯拉Model Y': '/static/images/car/main/特斯拉Model Y.png',
          '蔚来ES6': '/static/images/car/main/蔚来ES6.jpg',
          '小鹏P7': '/static/images/car/main/小鹏p7i.jpeg',
          '理想L7': '/static/images/car/main/理想L7.jpg',
          '五菱宏光MINI EV': '/static/images/car/main/五菱宏光MINI EV 马卡龙.jpg',
          '比亚迪汉EV 创世版': '/static/images/car/main/比亚迪汉EV 创世版.jpg',
          '特斯拉Model 3': '/static/images/car/main/特斯拉Model3.jpg'
        }
        const carData = {
          vehicleId: item.targetId,
          modelName: item.model,
          guidePrice: item.price,
          image: carImageMap[item.model] || '/static/images/car/car1.png'
        }
        uni.navigateTo({ url: `/pages/car/order-new?car=${encodeURIComponent(JSON.stringify(carData))}` })
      } else if (item.stationName) {
        // 充电站 → 跳转站点详情
        uni.navigateTo({ url: `/pages/charge/detail?stationId=${item.targetId}&name=${encodeURIComponent(item.stationName)}` })
      }
    },
    async removeFavorite(category, id) {
      try {
        await cancelCollection(id)
        const keyMap = { text: 'textFavorites', car: 'carFavorites', charge: 'chargeFavorites' }
        const key = keyMap[category]
        this[key] = this[key].filter(item => item.id !== id)
        uni.showToast({ title: '已取消收藏', icon: 'success' })
      } catch (e) {
        uni.showToast({ title: '取消失败', icon: 'none' })
      }
    },
    goExplore() {
      uni.switchTab({ url: '/pages/index' })
    }
  }
}
</script>

<style lang="scss" scoped>
page {
  background-color: #f2f7fe;
  min-height: 100vh;
}

.page-container {
  min-height: 100vh;
}

.tab-bar {
  position: sticky;
  top: 0;
  z-index: 100;
  background: #fff;
  padding: 20rpx 30rpx;
  display: flex;
  justify-content: space-around;
  box-shadow: 0 2rpx 20rpx rgba(0, 0, 0, 0.05);
}

.tab-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 16rpx 0;
  position: relative;
  transition: all 0.3s ease;
}

.tab-icon-wrapper {
  width: 48rpx;
  height: 48rpx;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 8rpx;
  transition: all 0.3s ease;
  background: #f5f6f7;
}

.tab-item.active .tab-icon-wrapper {
  background: linear-gradient(135deg, #3c96f3 0%, #6b7bff 100%);
  transform: scale(1.1);
}

.tab-text {
  font-size: 24rpx;
  color: #666;
  transition: all 0.3s ease;
}

.tab-item.active .tab-text {
  color: #3c96f3;
  font-weight: 600;
}

.tab-indicator {
  position: absolute;
  bottom: 0;
  width: 48rpx;
  height: 6rpx;
  background: linear-gradient(90deg, #3c96f3 0%, #6b7bff 100%);
  border-radius: 3rpx;
  animation: slideIn 0.3s ease;
}

.tab-icon-img {
  width: 36rpx;
  height: 36rpx;
}

.section-icon-img {
  width: 32rpx;
  height: 32rpx;
}

.empty-icon-img {
  width: 80rpx;
  height: 80rpx;
  opacity: 0.5;
}

@keyframes slideIn {
  from {
    transform: scaleX(0);
    opacity: 0;
  }
  to {
    transform: scaleX(1);
    opacity: 1;
  }
}

.summary-card {
  margin: 24rpx 30rpx;
  position: relative;
  border-radius: 24rpx;
  overflow: hidden;
  box-shadow: 0 8rpx 32rpx rgba(60, 150, 243, 0.2);
}

.summary-bg {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, #3c96f3 0%, #6b7bff 50%, #7c4dff 100%);
}

.summary-content {
  position: relative;
  z-index: 1;
  padding: 32rpx;
}

.summary-main {
  display: flex;
  align-items: center;
  margin-bottom: 24rpx;
}

.summary-icon {
  width: 80rpx;
  height: 80rpx;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 20rpx;
  display: flex;
  justify-content: center;
  align-items: center;
  margin-right: 20rpx;
}

.summary-info {
  display: flex;
  flex-direction: column;
}

.summary-count {
  font-size: 48rpx;
  font-weight: 700;
  color: #fff;
  line-height: 1.2;
}

.summary-label {
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.8);
  margin-top: 4rpx;
}

.summary-divider {
  height: 1rpx;
  background: rgba(255, 255, 255, 0.2);
  margin-bottom: 20rpx;
}

.summary-detail {
  display: flex;
  justify-content: space-around;
}

.detail-item {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.detail-value {
  font-size: 32rpx;
  font-weight: 600;
  color: #fff;
}

.detail-label {
  font-size: 22rpx;
  color: rgba(255, 255, 255, 0.7);
  margin-top: 6rpx;
}

.list-scroll {
  height: calc(100vh - 380rpx);
}

.section-block {
  margin-bottom: 32rpx;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 30rpx;
  margin-bottom: 20rpx;
}

.section-title-row {
  display: flex;
  align-items: center;
}

.section-icon-box {
  width: 48rpx;
  height: 48rpx;
  border-radius: 12rpx;
  display: flex;
  justify-content: center;
  align-items: center;
  margin-right: 16rpx;
}

.section-icon-box.bg-blue {
  background: #e3f2fd;
}

.section-icon-box.bg-orange {
  background: #fff3e0;
}

.section-icon-box.bg-green {
  background: #e8f5e9;
}

.section-title {
  font-size: 32rpx;
  font-weight: 700;
  color: #1a1a1a;
}

.section-more {
  display: flex;
  align-items: center;
  font-size: 26rpx;
  color: #999;
}

.fav-list {
  padding: 0 30rpx;
}

.fav-card {
  background: #fff;
  border-radius: 20rpx;
  margin-bottom: 20rpx;
  overflow: hidden;
  position: relative;
  box-shadow: 0 4rpx 24rpx rgba(0, 0, 0, 0.06);
  transition: all 0.3s ease;
}

.fav-card:active {
  transform: scale(0.98);
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.08);
}

.card-bg {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 120rpx;
  background: linear-gradient(135deg, #f5f9ff 0%, #e8f2ff 100%);
}

.card-bg.car-bg {
  background: linear-gradient(135deg, #fff8f0 0%, #fff3e0 100%);
}

.card-bg.charge-bg {
  background: linear-gradient(135deg, #f0fff4 0%, #e8f5e9 100%);
}

.card-content {
  position: relative;
  z-index: 1;
  padding: 28rpx;
}

.card-arrow {
  position: absolute;
  right: 24rpx;
  top: 50%;
  transform: translateY(-50%);
  width: 48rpx;
  height: 48rpx;
  display: flex;
  justify-content: center;
  align-items: center;
}

.card-actions {
  position: relative;
  z-index: 1;
  padding: 0 28rpx 28rpx;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.action-btn {
  display: flex;
  align-items: center;
  padding: 12rpx 24rpx;
  border-radius: 24rpx;
  font-size: 24rpx;
}

.unfavorite-btn {
  background: #fff5f5;
  color: #ff4757;
}

.text-card .fc-header,
.text-card-full .fc-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16rpx;
}

.fc-source-tag {
  background: linear-gradient(135deg, #3c96f3 0%, #6b7bff 100%);
  padding: 6rpx 16rpx;
  border-radius: 8rpx;
  font-size: 22rpx;
  color: #fff;
  font-weight: 500;
}

.fc-time {
  font-size: 22rpx;
  color: #bbb;
}

.text-card .fc-title,
.text-card-full .fc-title {
  font-size: 30rpx;
  font-weight: 600;
  color: #1a1a1a;
  display: block;
  margin-bottom: 12rpx;
  line-height: 1.5;
}

.text-card .fc-desc,
.text-card-full .fc-desc {
  font-size: 26rpx;
  color: #888;
  display: block;
  line-height: 1.6;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.car-card .car-main,
.car-card-full .car-main {
  display: flex;
  align-items: center;
  margin-bottom: 20rpx;
}

.car-icon-box {
    width: 80rpx;
    height: 80rpx;
    background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
    border-radius: 20rpx;
    margin-right: 20rpx;
    display: flex;
    justify-content: center;
    align-items: center;
  }

.car-card-icon {
    width: 50rpx;
    height: 50rpx;
  }

.car-info {
  flex: 1;
}

.car-model {
  font-size: 32rpx;
  font-weight: 600;
  color: #1a1a1a;
  display: block;
  margin-bottom: 6rpx;
}

.car-brand {
  font-size: 24rpx;
  color: #888;
}

.car-card .car-specs {
  display: flex;
  justify-content: space-around;
  padding: 16rpx 0;
  background: #fafafa;
  border-radius: 12rpx;
  margin-bottom: 16rpx;
}

.car-card-full .car-specs-grid {
  display: flex;
  justify-content: space-around;
  padding: 20rpx 0;
  background: #fafafa;
  border-radius: 12rpx;
  margin-bottom: 16rpx;
}

.car-card .spec-item {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.car-card-full .spec-item-grid {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.car-card .spec-label,
.car-card-full .spec-label {
  font-size: 22rpx;
  color: #999;
  margin-bottom: 6rpx;
}

.car-card .spec-value,
.car-card-full .spec-value {
  font-size: 26rpx;
  font-weight: 600;
  color: #333;
}

.car-price-row {
  display: flex;
  align-items: baseline;
}

.price-symbol {
  font-size: 28rpx;
  font-weight: 700;
  color: #ff4757;
}

.price-num {
  font-size: 44rpx;
  font-weight: 700;
  color: #ff4757;
  margin-left: 4rpx;
}

.price-unit {
  font-size: 26rpx;
  color: #ff4757;
  margin-left: 4rpx;
}

.charge-card .charge-header,
.charge-card-full .charge-header {
  display: flex;
  align-items: flex-start;
  margin-bottom: 16rpx;
}

.charge-icon {
  width: 64rpx;
  height: 64rpx;
  background: linear-gradient(135deg, #4caf50 0%, #2ecc71 100%);
  border-radius: 16rpx;
  display: flex;
  justify-content: center;
  align-items: center;
  margin-right: 16rpx;
  flex-shrink: 0;
}

.charge-info {
  flex: 1;
}

.charge-station {
  font-size: 30rpx;
  font-weight: 600;
  color: #1a1a1a;
  display: block;
  margin-bottom: 6rpx;
}

.charge-address {
  font-size: 24rpx;
  color: #888;
}

.charge-price {
  font-size: 36rpx;
  font-weight: 700;
  color: #ff6b00;
  flex-shrink: 0;
}

.price-unit-small {
  font-size: 22rpx;
  font-weight: 400;
}

.charge-card .charge-footer,
.charge-card-full .charge-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.distance-tag {
  display: flex;
  align-items: center;
  font-size: 24rpx;
  color: #3c96f3;
}

.charge-tags {
  display: flex;
  gap: 12rpx;
}

.charge-tags .tag {
  font-size: 22rpx;
  color: #3c96f3;
  background: #e8f2ff;
  padding: 6rpx 14rpx;
  border-radius: 8rpx;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 120rpx 40rpx;
}

.empty-icon-wrapper {
  width: 160rpx;
  height: 160rpx;
  background: #f5f6f7;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 32rpx;
}

.empty-title {
  font-size: 32rpx;
  font-weight: 600;
  color: #333;
  margin-bottom: 12rpx;
}

.empty-desc {
  font-size: 26rpx;
  color: #999;
  margin-bottom: 40rpx;
}

.empty-action {
  display: flex;
  align-items: center;
  padding: 20rpx 48rpx;
  background: linear-gradient(135deg, #3c96f3 0%, #6b7bff 100%);
  border-radius: 40rpx;
  font-size: 28rpx;
  color: #fff;
  font-weight: 500;
}

.bottom-space {
  height: 60rpx;
}
</style>