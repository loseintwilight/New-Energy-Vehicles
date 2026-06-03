<template>
	<view class="page" :class="{ 'page-ready': isReady }">
		<view class="glow-matrix">
			<view class="glow-row" v-for="(row, ri) in glowRows" :key="ri">
				<view class="glow-spot" v-for="(dot, ci) in row.dots" :key="ci" :style="dot.style"></view>
			</view>
		</view>
		<view class="overlay-mask"></view>

		<scroll-view scroll-y class="main-scroll" :show-scrollbar="false">
			<!-- 顶栏 -->
			<view class="header">
				<view class="header-bg"></view>
				<view class="back-btn" hover-class="btn-hover" @tap="goBack">
					<text class="back-icon">❮</text>
				</view>
				<view class="header-info">
					<text class="header-title">充电桩管理</text>
					<text class="header-sub">共 {{ pileList.length }} 台充电桩</text>
				</view>
				<view class="header-right" @tap="goAdd">
					<view class="add-btn">
						<text class="add-icon">+</text>
					</view>
				</view>
			</view>

			<!-- 状态统计 -->
			<view class="status-bar">
				<view class="status-item" :class="{ active: activeStatus === 'all' }" @tap="switchStatus('all')">
					<text class="status-count">{{ pileList.length }}</text>
					<text class="status-label">全部</text>
				</view>
				<view class="status-item" :class="{ active: activeStatus === 'online' }" @tap="switchStatus('online')">
					<text class="status-count count-green">{{ onlineCount }}</text>
					<text class="status-label">在线</text>
				</view>
				<view class="status-item" :class="{ active: activeStatus === 'offline' }" @tap="switchStatus('offline')">
					<text class="status-count count-red">{{ offlineCount }}</text>
					<text class="status-label">离线</text>
				</view>
				<view class="status-item" :class="{ active: activeStatus === 'charging' }" @tap="switchStatus('charging')">
					<text class="status-count count-orange">{{ chargingCount }}</text>
					<text class="status-label">充电中</text>
				</view>
			</view>

			<!-- 搜索栏 -->
			<view class="search-bar">
				<text class="search-icon">🔍</text>
				<input class="search-input" v-model="searchKey" placeholder="搜索充电桩编号或站点" placeholder-class="search-placeholder" @input="onSearch" />
			</view>

			<!-- 充电桩列表 -->
			<view class="pile-list">
				<view class="pile-card" v-for="(item, idx) in filteredPiles" :key="idx" hover-class="card-hover" @tap="goDetail(item.id)">
					<view class="pile-card-top">
						<view class="pile-icon-wrap" :class="'icon-' + item.status">
							<text class="pile-icon">⚡</text>
						</view>
						<view class="pile-info">
							<text class="pile-name">{{ item.name }}</text>
							<text class="pile-station">{{ item.station }}</text>
						</view>
						<view class="pile-status-badge" :class="'badge-' + item.status">
							<view class="status-dot"></view>
							<text>{{ item.statusText }}</text>
						</view>
					</view>
					<view class="pile-card-bottom">
						<view class="pile-meta">
							<text class="meta-label">功率</text>
							<text class="meta-value">{{ item.power }}</text>
						</view>
						<view class="pile-meta">
							<text class="meta-label">今日充电</text>
							<text class="meta-value">{{ item.todayEnergy }}kWh</text>
						</view>
						<view class="pile-meta">
							<text class="meta-label">今日营收</text>
							<text class="meta-value meta-amount">¥{{ item.todayIncome }}</text>
						</view>
						<view class="pile-meta">
							<text class="meta-label">利用率</text>
							<text class="meta-value">{{ item.utilization }}</text>
						</view>
					</view>
					<view class="pile-progress">
						<view class="progress-fill" :style="{ width: item.utilization }"></view>
					</view>
				</view>
			</view>

			<view style="height: 120rpx;"></view>
		</scroll-view>
	</view>
</template>

<script>
export default {
	data() {
		return {
			isReady: false,
			glowRows: [],
			activeStatus: 'all',
			searchKey: '',
			pileList: [
				{ id: 1, name: '1号快充桩', station: '济南高新区充电站', power: '120kW', status: 'online', statusText: '在线', todayEnergy: '156.8', todayIncome: '250.88', utilization: '72%' },
				{ id: 2, name: '2号快充桩', station: '济南高新区充电站', power: '120kW', status: 'charging', statusText: '充电中', todayEnergy: '210.5', todayIncome: '336.80', utilization: '88%' },
				{ id: 3, name: '3号超充桩', station: '济南历下区旗舰站', power: '240kW', status: 'charging', statusText: '充电中', todayEnergy: '320.2', todayIncome: '736.46', utilization: '95%' },
				{ id: 4, name: '4号超充桩', station: '济南历下区旗舰站', power: '240kW', status: 'online', statusText: '在线', todayEnergy: '189.6', todayIncome: '436.08', utilization: '65%' },
				{ id: 5, name: '5号慢充桩', station: '济南天桥区充电站', power: '7kW', status: 'offline', statusText: '离线', todayEnergy: '0', todayIncome: '0.00', utilization: '0%' },
				{ id: 6, name: '1号快充桩', station: '济南槐荫区充电站', power: '120kW', status: 'online', statusText: '在线', todayEnergy: '98.3', todayIncome: '157.28', utilization: '45%' },
				{ id: 7, name: '2号快充桩', station: '济南槐荫区充电站', power: '120kW', status: 'charging', statusText: '充电中', todayEnergy: '145.7', todayIncome: '233.12', utilization: '68%' },
				{ id: 8, name: '6号慢充桩', station: '济南天桥区充电站', power: '7kW', status: 'online', statusText: '在线', todayEnergy: '28.5', todayIncome: '45.60', utilization: '32%' }
			]
		}
	},
	computed: {
		onlineCount() {
			return this.pileList.filter(function(p) { return p.status === 'online' }).length
		},
		offlineCount() {
			return this.pileList.filter(function(p) { return p.status === 'offline' }).length
		},
		chargingCount() {
			return this.pileList.filter(function(p) { return p.status === 'charging' }).length
		},
		filteredPiles() {
			var self = this
			var list = self.pileList
			if (self.activeStatus !== 'all') {
				list = list.filter(function(p) { return p.status === self.activeStatus })
			}
			if (self.searchKey) {
				var key = self.searchKey.toLowerCase()
				list = list.filter(function(p) { return p.name.toLowerCase().indexOf(key) !== -1 || p.station.toLowerCase().indexOf(key) !== -1 })
			}
			return list
		}
	},
	created() {
		this.buildGlowRows()
		var self = this
		setTimeout(function() { self.isReady = true }, 200)
	},
	methods: {
		buildGlowRows() {
			var rows = []
			var colors = ['#f59e0b', '#f97316', '#fb923c', '#fbbf24']
			for (var r = 0; r < 5; r++) {
				var dots = []
				var count = 3 + Math.floor(Math.random() * 4)
				for (var c = 0; c < count; c++) {
					var color = colors[Math.floor(Math.random() * colors.length)]
					dots.push({ style: 'width:' + (3 + Math.floor(Math.random() * 7)) + 'px;height:' + (3 + Math.floor(Math.random() * 7)) + 'px;background:' + color + ';animation-duration:' + (2 + Math.random() * 3) + 's;animation-delay:' + Math.random() * 2 + 's;' })
				}
				rows.push({ dots: dots })
			}
			this.glowRows = rows
		},
		goBack() { uni.navigateBack() },
		goAdd() { uni.navigateTo({ url: '/pages/mine/charge-pile/pile-add' }) },
		switchStatus(status) { this.activeStatus = status },
		onSearch() {},
		goDetail(id) { uni.navigateTo({ url: '/pages/mine/charge-pile/pile-detail?pileId=' + id }) }
	}
}
</script>

<style scoped>
.page { min-height: 100vh; background: linear-gradient(180deg, #fff7ed 0%, #fffbeb 30%, #fefce8 60%, #fff7ed 100%); opacity: 0; transition: opacity 0.5s ease; }
.page-ready { opacity: 1; }
.glow-matrix { position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 0; overflow: hidden; pointer-events: none; }
.glow-row { display: flex; justify-content: space-around; padding: 20rpx 30rpx; }
.glow-spot { border-radius: 50%; filter: blur(6px); opacity: 0; animation: glowPulse ease-in-out infinite alternate; }
@keyframes glowPulse { 0% { opacity: 0; transform: scale(0.6); } 50% { opacity: 0.5; } 100% { opacity: 0; transform: scale(1.4); } }
.overlay-mask { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: linear-gradient(180deg, rgba(255,247,237,0.3) 0%, rgba(255,251,235,0.43) 38%, rgba(254,252,232,0.55) 66%, rgba(255,247,237,0.63) 100%); z-index: 1; pointer-events: none; }
.main-scroll { position: relative; z-index: 2; }

/* 顶栏 */
.header { position: relative; padding: 30rpx 28rpx 24rpx; display: flex; align-items: center; }
.header-bg { position: absolute; top: -60rpx; left: -40rpx; right: -40rpx; bottom: 0; background: radial-gradient(ellipse at 20% 30%, rgba(251,146,60,0.12) 0%, transparent 60%), radial-gradient(ellipse at 80% 50%, rgba(250,204,21,0.1) 0%, transparent 55%); border-radius: 0 0 60rpx 60rpx; }
.back-btn { width: 60rpx; height: 60rpx; border-radius: 30rpx; background: rgba(255,255,255,0.75); backdrop-filter: blur(10px); display: flex; align-items: center; justify-content: center; z-index: 1; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06); }
.back-icon { font-size: 28rpx; color: #92400e; }
.btn-hover { opacity: 0.7; transform: scale(0.95); }
.header-info { flex: 1; margin-left: 20rpx; z-index: 1; }
.header-title { font-size: 36rpx; font-weight: 700; color: #451a03; display: block; }
.header-sub { font-size: 24rpx; color: #a16207; margin-top: 4rpx; display: block; }
.header-right { z-index: 1; }
.add-btn { width: 60rpx; height: 60rpx; border-radius: 30rpx; background: linear-gradient(135deg, #f59e0b, #f97316); display: flex; align-items: center; justify-content: center; box-shadow: 0 4rpx 16rpx rgba(245,158,11,0.35); }
.add-icon { font-size: 32rpx; color: #fff; font-weight: 300; }

/* 状态统计 */
.status-bar { margin: 0 24rpx 20rpx; display: flex; gap: 16rpx; }
.status-item { flex: 1; background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 16rpx; padding: 20rpx 12rpx; text-align: center; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); transition: all 0.3s; }
.status-item.active { background: #fff; box-shadow: 0 4rpx 20rpx rgba(245,158,11,0.2); border: 2rpx solid #f59e0b; }
.status-count { font-size: 36rpx; font-weight: 700; color: #1c1917; display: block; }
.count-green { color: #22c55e; }
.count-red { color: #dc2626; }
.count-orange { color: #f59e0b; }
.status-label { font-size: 22rpx; color: #78716c; margin-top: 4rpx; display: block; }

/* 搜索 */
.search-bar { margin: 0 24rpx 20rpx; background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 16rpx 20rpx; display: flex; align-items: center; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.search-icon { font-size: 28rpx; margin-right: 12rpx; }
.search-input { flex: 1; font-size: 26rpx; color: #1c1917; }
.search-placeholder { color: #a8a29e; }

/* 充电桩卡片 */
.pile-list { padding: 0 24rpx; }
.pile-card { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 24rpx; margin-bottom: 16rpx; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.card-hover { transform: scale(0.98); opacity: 0.9; }
.pile-card-top { display: flex; align-items: center; margin-bottom: 16rpx; }
.pile-icon-wrap { width: 56rpx; height: 56rpx; border-radius: 16rpx; display: flex; align-items: center; justify-content: center; margin-right: 16rpx; }
.icon-online { background: #dcfce7; }
.icon-charging { background: #fef3c7; }
.icon-offline { background: #fee2e2; }
.pile-icon { font-size: 28rpx; }
.pile-info { flex: 1; }
.pile-name { font-size: 28rpx; font-weight: 600; color: #1c1917; display: block; }
.pile-station { font-size: 22rpx; color: #a8a29e; margin-top: 4rpx; display: block; }
.pile-status-badge { display: flex; align-items: center; padding: 8rpx 16rpx; border-radius: 20rpx; font-size: 22rpx; }
.badge-online { background: #dcfce7; color: #16a34a; }
.badge-charging { background: #fef3c7; color: #b45309; }
.badge-offline { background: #fee2e2; color: #dc2626; }
.status-dot { width: 10rpx; height: 10rpx; border-radius: 5rpx; margin-right: 8rpx; }
.badge-online .status-dot { background: #22c55e; }
.badge-charging .status-dot { background: #f59e0b; animation: dotPulse 1.5s ease-in-out infinite; }
.badge-offline .status-dot { background: #ef4444; }
@keyframes dotPulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.3; } }
.pile-card-bottom { display: flex; justify-content: space-between; padding: 16rpx 0; border-top: 1rpx solid #f5f5f4; border-bottom: 1rpx solid #f5f5f4; }
.pile-meta { text-align: center; flex: 1; }
.meta-label { font-size: 20rpx; color: #a8a29e; display: block; }
.meta-value { font-size: 24rpx; font-weight: 600; color: #1c1917; display: block; margin-top: 4rpx; }
.meta-amount { color: #f59e0b; }
.pile-progress { height: 6rpx; background: #f5f5f4; border-radius: 3rpx; margin-top: 16rpx; overflow: hidden; }
.progress-fill { height: 100%; background: linear-gradient(90deg, #f59e0b, #f97316); border-radius: 3rpx; transition: width 0.6s ease; }
</style>