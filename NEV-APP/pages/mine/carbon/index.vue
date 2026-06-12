	<template>
	  <view class="carbon-container">
		<!-- 顶部导航栏 -->
		<view class="navbar">
		  <view class="nav-back" @click="handleBack">
			<uni-icons type="back" size="28" color="#333"></uni-icons>
		  </view>
		  <view class="nav-title">碳积分</view>
		  <view class="nav-placeholder"></view>
		</view>

		<!-- 页面内容 -->
		<view class="content">
		  <!-- 当前积分卡片 -->
		  <view class="balance-card">
			<view class="balance-bg"></view>
			<view class="balance-content">
			  <view class="balance-label">当前碳积分</view>
			  <view class="balance-value">{{ totalPoints }}<text class="balance-unit">积分</text></view>
			  <view class="balance-desc">累计减少 {{ totalReduction }} kg CO₂ 排放</view>
			</view>
			<view class="balance-icon">
			  <text class="balance-icon-text">C</text>
			</view>
		  </view>

		  <!-- 统计数据 -->
		  <view class="stats-section">
			<view class="stats-card">
			  <view class="stat-item">
				<view class="stat-value earn">{{ earnedPoints }}</view>
				<view class="stat-label">累计获得</view>
			  </view>
			  <view class="stat-divider"></view>
			  <view class="stat-item">
				<view class="stat-value spend">{{ spentPoints }}</view>
				<view class="stat-label">累计消耗</view>
			  </view>
			  <view class="stat-divider"></view>
			  <view class="stat-item">
				<view class="stat-value redeem">{{ redeemedPoints }}</view>
				<view class="stat-label">累计兑换</view>
			  </view>
			</view>
		  </view>

		  <!-- 获取方式 -->
		  <view class="earn-section">
			<view class="section-header">
			  <text class="section-title">获取积分方式</text>
			</view>
			<view class="earn-grid">
			  <view class="earn-item" v-for="item in earnWays" :key="item.type">
				<view class="earn-icon" :class="item.bgClass">
				  <image class="earn-icon-img" :src="item.iconImg || item.iconText" mode="aspectFit" />
				</view>
				<view class="earn-name">{{ item.name }}</view>
				<view class="earn-points">+{{ item.points }} 积分</view>
				<view class="earn-desc">{{ item.desc }}</view>
			  </view>
			</view>
		  </view>

		  <!-- 积分流水 -->
		  <view class="record-section">
			<view class="section-header">
			  <text class="section-title">积分流水</text>
			  <view class="filter-tabs">
				<view 
				  class="filter-tab" 
				  :class="{ active: currentFilter === 'all' }"
				  @click="currentFilter = 'all'"
				>全部</view>
				<view 
				  class="filter-tab" 
				  :class="{ active: currentFilter === 'earn' }"
				  @click="currentFilter = 'earn'"
				>获得</view>
				<view 
				  class="filter-tab" 
				  :class="{ active: currentFilter === 'spend' }"
				  @click="currentFilter = 'spend'"
				>消耗</view>
				<view 
				  class="filter-tab" 
				  :class="{ active: currentFilter === 'exchange' }"
				  @click="currentFilter = 'exchange'"
				>兑换</view>
			  </view>
			</view>
			<view class="record-list">
			  <view class="record-item" v-for="record in filteredRecords" :key="record.ledger_id">
				<view class="record-icon" :class="record._iconClass">
				  <text class="iconfont record-icon-text">{{ record._iconText || record._icon }}</text>
				</view>
				<view class="record-info">
				  <view class="record-title">{{ record._title }}</view>
				  <view class="record-time">{{ record._time }}</view>
				</view>
				<view class="record-points" :class="record._pointsClass">
				  {{ record.points > 0 ? '+' : '' }}{{ record.points }}
				</view>
			  </view>
			  <view v-if="filteredRecords.length === 0" class="empty-state">
				<text class="empty-icon">•</text>
				<text class="empty-text">暂无记录</text>
			  </view>
			</view>
		  </view>

		  <!-- 积分规则说明 -->
		  <view class="rule-section">
			<view class="section-header">
			  <text class="section-title">积分规则</text>
			</view>
			<view class="rule-list">
			  <view class="rule-item">
				<view class="rule-number">1</view>
				<view class="rule-content">碳积分可用于兑换优惠券、礼品等</view>
			  </view>
			  <view class="rule-item">
				<view class="rule-number">2</view>
				<view class="rule-content">积分有效期为获得之日起12个月</view>
			  </view>
			  <view class="rule-item">
				<view class="rule-number">3</view>
				<view class="rule-content">1积分 = 减少0.05kg CO₂排放</view>
			  </view>
			  <view class="rule-item">
				<view class="rule-number">4</view>
				<view class="rule-content">每日签到可获得10积分</view>
			  </view>
			</view>
		  </view>
		</view>
	  </view>
	</template>

	<script>
	import { getCarbonOverview, getCarbonRecords, getCarbonEarnWays } from '@/api/mine/carbon'

	export default {
	  data() {
		return {
		  currentFilter: 'all',
		  totalPoints: 0,
		  totalReduction: 0,
		  earnedPoints: 0,
		  spentPoints: 0,
		  redeemedPoints: 0,
		  earnWays: [],
		  records: []
		}
	  },
	  computed: {
		filteredRecords() {
      const typeMap = {
        earn: 0,
        spend: 1,
        exchange: 2
      }
      const list = this.currentFilter === 'all'
        ? this.records
        : this.records.filter(r => r.record_type === typeMap[this.currentFilter])
      const iconMap = { 0: '', 1: '', 2: '', 3: '' }
      const iconClassMap = { 0: 'icon-earn', 1: 'icon-spend', 2: 'icon-exchange', 3: 'icon-read' }
      const sourceTitles = { 0: '充电获得', 1: '购车奖励', 2: '阅读获得', 3: '签到获得', 4: '积分兑换', 5: '系统操作' }
      return list.map(r => ({
        ...r,
        _iconText: iconMap[r.record_type] || '\ue601',
        _iconClass: iconClassMap[r.record_type] || 'icon-default',
        _pointsClass: r.record_type === 0 ? 'points-earn' : 'points-spend',
        _title: r.remark || sourceTitles[r.source_type] || '积分变动',
        _time: (r.create_time || '').split(' ')[0]
      }))
    }
	  },
	  onLoad() {
		this.loadData()
	  },
	  methods: {
		async loadData() {
      try {
        // 并行请求概览和记录
        const [overviewRes, recordsRes, waysRes] = await Promise.allSettled([
          getCarbonOverview(),
          getCarbonRecords(),
          getCarbonEarnWays()
        ])

        // 处理概览数据
        if (overviewRes.status === 'fulfilled' && overviewRes.value) {
          const data = overviewRes.value.data || overviewRes.value
          this.totalPoints = data.points || 0
          this.totalReduction = data.totalReduction || 0
          this.earnedPoints = data.earnedPoints || data.totalEarned || 0
          this.spentPoints = data.spentPoints || data.totalSpent || 0
          this.redeemedPoints = data.redeemedPoints || data.totalRedeemed || 0
        }

        // 处理积分记录
        if (recordsRes.status === 'fulfilled' && recordsRes.value) {
          const recordsData = recordsRes.value.data || recordsRes.value
          this.records = Array.isArray(recordsData) ? recordsData : (recordsData.rows || [])
        }

        // 处理获取方式
        if (waysRes.status === 'fulfilled' && waysRes.value) {
          const waysData = waysRes.value.data || waysRes.value
          const ways = Array.isArray(waysData) ? waysData : (waysData.list || [])
          this.earnWays = ways.map(item => ({
            type: item.type || item.actionType,
            name: item.name || item.actionName,
            iconImg: this.getIconForType(item.type || item.actionType),
            points: item.points || item.pointsValue,
            desc: item.desc || item.actionDesc,
            bgClass: this.getBgClassForType(item.type || item.actionType)
          }))
        }
      } catch (e) {
        console.error('加载碳积分数据失败', e)
        // 使用默认获取方式
        if (this.earnWays.length === 0) {
          this.earnWays = [
            { type: 'charge', name: '充电', iconImg: '/static/images/index/charging.png', points: 10, desc: '订单支付后每1kWh获得10积分', bgClass: 'bg-green' },
            { type: 'purchase', name: '购车', iconImg: '/static/images/index/car.png', points: 500, desc: '支付完成后一次性获得500积分', bgClass: 'bg-blue' }
          ]
        }
      }
    },
		getIconForType(type) {
		  const iconMap = {
			charge: '/static/images/index/charging.png',
			purchase: '/static/images/index/car.png',
			read: '/static/images/index/CO2.png',
			checkin: '/static/images/index/work.png'
		  }
		  return iconMap[type] || '/static/images/index/car.png'
		},
		getBgClassForType(type) {
		  const bgMap = {
			charge: 'bg-green',
			purchase: 'bg-blue',
			read: 'bg-orange',
			checkin: 'bg-purple'
		  }
		  return bgMap[type] || 'bg-green'
		},
		handleBack() {
		  uni.navigateBack()
		}
	  }
	}
	</script>

	<style lang="scss" scoped>
	page {
	  background-color: #f5f6f7;
	  min-height: 100vh;
	}

	.carbon-container {
	  width: 100%;
	  min-height: 100vh;
	  background-color: #f5f6f7;
	}

	.navbar {
	  display: flex;
	  align-items: center;
	  justify-content: space-between;
	  height: 88rpx;
	  padding: 0 30rpx;
	  background-color: #fff;
	  position: sticky;
	  top: 0;
	  z-index: 100;
	  box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.05);
	}

	.nav-back {
	  width: 60rpx;
	  height: 60rpx;
	  display: flex;
	  align-items: center;
	  justify-content: center;
	}

	.nav-title {
	  font-size: 32rpx;
	  font-weight: 600;
	  color: #333;
	}

	.nav-placeholder {
	  width: 60rpx;
	}

	.content {
	  padding: 24rpx 30rpx;
	}

	.section-header {
	  display: flex;
	  align-items: center;
	  justify-content: space-between;
	  margin-bottom: 20rpx;
	}

	.section-title {
	  font-size: 28rpx;
	  font-weight: 600;
	  color: #333;
	}

	/* 当前积分卡片 */
	.balance-card {
	  position: relative;
	  background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%);
	  border-radius: 24rpx;
	  padding: 40rpx;
	  margin-bottom: 30rpx;
	  overflow: hidden;
	}

	.balance-bg {
	  position: absolute;
	  top: -50rpx;
	  right: -50rpx;
	  width: 200rpx;
	  height: 200rpx;
	  background-color: rgba(255, 255, 255, 0.1);
	  border-radius: 50%;
	}

	.balance-content {
	  position: relative;
	  z-index: 1;
	}

	.balance-label {
	  font-size: 26rpx;
	  color: rgba(255, 255, 255, 0.8);
	  margin-bottom: 12rpx;
	}

	.balance-value {
	  font-size: 48rpx;
	  font-weight: 700;
	  color: #fff;
	}

	.balance-unit {
	  font-size: 24rpx;
	  font-weight: 400;
	  color: rgba(255, 255, 255, 0.9);
	  margin-left: 8rpx;
	}

	.balance-desc {
	  font-size: 24rpx;
	  color: rgba(255, 255, 255, 0.8);
	  margin-top: 8rpx;
	}

	.balance-icon {
	  position: absolute;
	  right: 40rpx;
	  top: 50%;
	  transform: translateY(-50%);
	  opacity: 0.2;
	}

	.balance-icon-text {
	  font-size: 80rpx;
	  font-weight: 800;
	  color: #fff;
	}

	.earn-icon-img {
	  width: 45rpx;
	  height: 45rpx;
	}

	.record-icon-text {
	  font-size: 28rpx;
	  font-weight: 700;
	  color: #fff;
	}

	.empty-icon {
	  font-size: 80rpx;
	  color: #ccc;
	}

	/* 统计数据 */
	.stats-section {
	  margin-bottom: 30rpx;
	}

	.stats-card {
	  display: flex;
	  background-color: #fff;
	  border-radius: 16rpx;
	  padding: 30rpx;
	  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
	}

	.stat-item {
	  flex: 1;
	  text-align: center;
	}

	.stat-value {
	  font-size: 36rpx;
	  font-weight: 700;
	  margin-bottom: 8rpx;
	}

	.stat-value.earn {
	  color: #2ecc71;
	}

	.stat-value.spend {
	  color: #e67e22;
	}

	.stat-value.redeem {
	  color: #9b59b6;
	}

	.stat-label {
	  font-size: 24rpx;
	  color: #999;
	}

	.stat-divider {
	  width: 1rpx;
	  background-color: #f0f0f0;
	  margin: 0 20rpx;
	}

	/* 获取方式 */
	.earn-section {
	  background-color: #fff;
	  border-radius: 16rpx;
	  padding: 24rpx;
	  margin-bottom: 30rpx;
	  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
	}

	.earn-grid {
	  display: grid;
	  grid-template-columns: repeat(4, 1fr);
	  gap: 20rpx;
	}

	.earn-item {
	  display: flex;
	  flex-direction: column;
	  align-items: center;
	}

	.earn-icon {
	  width: 80rpx;
	  height: 80rpx;
	  border-radius: 50%;
	  display: flex;
	  align-items: center;
	  justify-content: center;
	  margin-bottom: 12rpx;
	}

	.earn-icon.bg-green {
	  background-color: #e8f5e9;
	}

	.earn-icon.bg-blue {
	  background-color: #e3f2fd;
	}

	.earn-icon.bg-orange {
	  background-color: #fff3e0;
	}

	.earn-icon.bg-purple {
	  background-color: #f3e5f5;
	}

	.earn-name {
	  font-size: 24rpx;
	  color: #333;
	  margin-bottom: 4rpx;
	}

	.earn-points {
	  font-size: 22rpx;
	  color: #2ecc71;
	  font-weight: 600;
	  margin-bottom: 4rpx;
	}

	.earn-desc {
	  font-size: 20rpx;
	  color: #999;
	  text-align: center;
	}

	/* 积分流水 */
	.record-section {
	  background-color: #fff;
	  border-radius: 16rpx;
	  padding: 24rpx;
	  margin-bottom: 30rpx;
	  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
	}

	.filter-tabs {
	  display: flex;
	  gap: 16rpx;
	}

	.filter-tab {
	  padding: 8rpx 20rpx;
	  font-size: 24rpx;
	  color: #999;
	  background-color: #f5f6f7;
	  border-radius: 20rpx;
	  transition: all 0.3s;
	}

	.filter-tab.active {
	  background-color: #2ecc71;
	  color: #fff;
	}

	.record-list {
	  margin-top: 10rpx;
	}

	.record-item {
	  display: flex;
	  align-items: center;
	  padding: 20rpx 0;
	  border-bottom: 1rpx solid #f5f6f7;
	}

	.record-item:last-child {
	  border-bottom: none;
	}

	.record-icon {
	  width: 56rpx;
	  height: 56rpx;
	  border-radius: 14rpx;
	  display: flex;
	  align-items: center;
	  justify-content: center;
	  margin-right: 20rpx;
	}

	.record-icon.icon-earn {
	  background-color: rgba(46, 204, 113, 0.15);
	}

	.record-icon.icon-spend {
	  background-color: rgba(231, 76, 60, 0.15);
	}

	.record-icon.icon-exchange {
	  background-color: rgba(155, 89, 182, 0.15);
	}

	.record-icon.icon-read {
	  background-color: rgba(52, 152, 219, 0.15);
	}

	.record-info {
	  flex: 1;
	}

	.record-title {
	  font-size: 28rpx;
	  color: #333;
	  margin-bottom: 6rpx;
	}

	.record-time {
	  font-size: 22rpx;
	  color: #999;
	}

	.record-points {
	  font-size: 28rpx;
	  font-weight: 600;
	}

	.record-points.points-earn {
	  color: #2ecc71;
	}

	.record-points.points-spend {
	  color: #e74c3c;
	}

	.empty-state {
	  display: flex;
	  flex-direction: column;
	  align-items: center;
	  padding: 60rpx 0;
	}

	.empty-text {
	  font-size: 26rpx;
	  color: #999;
	  margin-top: 16rpx;
	}

	/* 积分规则 */
	.rule-section {
	  background-color: #fff;
	  border-radius: 16rpx;
	  padding: 24rpx;
	  margin-bottom: 40rpx;
	  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
	}

	.rule-list {
	  margin-top: 10rpx;
	}

	.rule-item {
	  display: flex;
	  align-items: flex-start;
	  padding: 16rpx 0;
	}

	.rule-number {
	  width: 40rpx;
	  height: 40rpx;
	  background-color: #f0f8ff;
	  border-radius: 50%;
	  display: flex;
	  align-items: center;
	  justify-content: center;
	  font-size: 24rpx;
	  color: #2ecc71;
	  font-weight: 600;
	  margin-right: 16rpx;
	  flex-shrink: 0;
	}

	.rule-content {
	  font-size: 26rpx;
	  color: #666;
	  line-height: 1.6;
	}
	</style>