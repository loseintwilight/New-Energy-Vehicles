<template>
	<view class="page" :class="{ 'page-ready': isReady }">
		<view class="glow-matrix">
			<view class="glow-row" v-for="(row, ri) in glowRows" :key="ri">
				<view class="glow-spot" v-for="(dot, ci) in row.dots" :key="ci" :style="dot.style"></view>
			</view>
		</view>
		<view class="overlay-mask"></view>

		<scroll-view scroll-y class="main-scroll" :show-scrollbar="false">
			<view class="header">
				<view class="header-bg"></view>
				<view class="back-btn" hover-class="btn-hover" @tap="goBack">
					<text class="back-icon">❮</text>
				</view>
				<view class="header-info">
					<text class="header-title">车辆管理</text>
					<text class="header-sub">共 {{ vehicleList.length }} 辆车</text>
				</view>
				<view class="header-right" @tap="goAdd">
					<view class="add-btn">
						<text class="add-icon">+</text>
					</view>
				</view>
			</view>

			<!-- 筛选标签 -->
			<view class="filter-tabs">
				<view class="filter-tab" v-for="(tab, idx) in filterTabs" :key="idx" :class="{ active: activeFilter === idx }" @tap="switchFilter(idx)">
					<text>{{ tab }}</text>
				</view>
			</view>

			<!-- 搜索栏 -->
			<view class="search-bar">
				<text class="search-icon">🔍</text>
				<input class="search-input" v-model="searchKey" placeholder="搜索车型或品牌" placeholder-class="search-placeholder" />
			</view>

			<!-- 车辆列表 -->
			<view class="vehicle-list">
				<view class="vehicle-card" v-for="(item, idx) in filteredVehicles" :key="idx" hover-class="card-hover" @tap="goDetail(item.id)">
					<view class="vehicle-img-wrap">
						<text class="vehicle-img-placeholder">{{ item.brandIcon }}</text>
					</view>
					<view class="vehicle-info">
						<view class="vehicle-top">
							<text class="vehicle-name">{{ item.name }}</text>
							<text class="vehicle-status" :class="'status-' + item.statusType">{{ item.statusText }}</text>
						</view>
						<text class="vehicle-specs">{{ item.type }} | {{ item.range }}km | {{ item.power }}</text>
						<view class="vehicle-bottom">
							<text class="vehicle-price">¥{{ item.price }}</text>
							<text class="vehicle-stock">库存: {{ item.stock }}台</text>
						</view>
					</view>
				</view>
			</view>

			<view class="empty-state" v-if="filteredVehicles.length === 0">
				<text class="empty-icon">🚗</text>
				<text class="empty-text">暂无车辆</text>
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
			activeFilter: 0,
			searchKey: '',
			filterTabs: ['全部', '在售', '已售罄', '下架'],
			vehicleList: [
				{ id: 1, name: '比亚迪 汉EV', brandIcon: '🚗', type: '纯电动', range: '715', power: '180kW', price: '239,800', stock: '12', statusText: '在售', statusType: 'active' },
				{ id: 2, name: '特斯拉 Model Y', brandIcon: '🚙', type: '纯电动', range: '660', power: '220kW', price: '299,900', stock: '8', statusText: '在售', statusType: 'active' },
				{ id: 3, name: '小鹏 G9', brandIcon: '🏎️', type: '纯电动', range: '702', power: '230kW', price: '359,800', stock: '5', statusText: '在售', statusType: 'active' },
				{ id: 4, name: '蔚来 ET5', brandIcon: '🚘', type: '纯电动', range: '710', power: '210kW', price: '328,800', stock: '0', statusText: '已售罄', statusType: 'sold' },
				{ id: 5, name: '理想 L8', brandIcon: '🚐', type: '增程式', range: '1315', power: '113kW', price: '359,800', stock: '15', statusText: '在售', statusType: 'active' },
				{ id: 6, name: '极氪 001', brandIcon: '🏍️', type: '纯电动', range: '1032', power: '200kW', price: '269,000', stock: '7', statusText: '在售', statusType: 'active' },
				{ id: 7, name: '问界 M7', brandIcon: '🚛', type: '增程式', range: '1220', power: '112kW', price: '289,800', stock: '0', statusText: '下架', statusType: 'offline' },
				{ id: 8, name: '深蓝 SL03', brandIcon: '🚓', type: '纯电动', range: '705', power: '160kW', price: '189,900', stock: '20', statusText: '在售', statusType: 'active' }
			]
		}
	},
	computed: {
		filteredVehicles() {
			var self = this
			var list = self.vehicleList
			var filters = ['all', 'active', 'sold', 'offline']
			if (self.activeFilter !== 0) {
				list = list.filter(function(v) { return v.statusType === filters[self.activeFilter] })
			}
			if (self.searchKey) {
				var key = self.searchKey.toLowerCase()
				list = list.filter(function(v) { return v.name.toLowerCase().indexOf(key) !== -1 })
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
					dots.push({ style: 'width:' + (3 + Math.floor(Math.random() * 6)) + 'px;height:' + (3 + Math.floor(Math.random() * 6)) + 'px;background:' + color + ';animation-duration:' + (2 + Math.random() * 3) + 's;animation-delay:' + Math.random() * 2 + 's;' })
				}
				rows.push({ dots: dots })
			}
			this.glowRows = rows
		},
		goBack() { uni.navigateBack() },
		goAdd() { uni.navigateTo({ url: '/pages/mine/vehicle/vehicle-add' }) },
		switchFilter(idx) { this.activeFilter = idx },
		goDetail(id) { uni.navigateTo({ url: '/pages/mine/vehicle/vehicle-detail?vehicleId=' + id }) }
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
.add-icon { font-size: 32rpx; color: #fff; }

.filter-tabs { margin: 0 24rpx 16rpx; display: flex; gap: 12rpx; }
.filter-tab { padding: 12rpx 28rpx; border-radius: 20rpx; background: rgba(255,255,255,0.75); font-size: 24rpx; color: #78716c; transition: all 0.3s; }
.filter-tab.active { background: #f59e0b; color: #fff; box-shadow: 0 4rpx 12rpx rgba(245,158,11,0.3); }

.search-bar { margin: 0 24rpx 16rpx; background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 16rpx 20rpx; display: flex; align-items: center; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.search-icon { font-size: 28rpx; margin-right: 12rpx; }
.search-input { flex: 1; font-size: 26rpx; color: #1c1917; }
.search-placeholder { color: #a8a29e; }

.vehicle-list { padding: 0 24rpx; }
.vehicle-card { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 20rpx; margin-bottom: 16rpx; display: flex; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.card-hover { transform: scale(0.98); opacity: 0.9; }
.vehicle-img-wrap { width: 120rpx; height: 120rpx; border-radius: 16rpx; background: linear-gradient(135deg, #fef3c7, #fde68a); display: flex; align-items: center; justify-content: center; margin-right: 16rpx; flex-shrink: 0; }
.vehicle-img-placeholder { font-size: 48rpx; }
.vehicle-info { flex: 1; }
.vehicle-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 6rpx; }
.vehicle-name { font-size: 28rpx; font-weight: 700; color: #1c1917; }
.vehicle-status { font-size: 20rpx; padding: 4rpx 12rpx; border-radius: 12rpx; }
.status-active { background: #dcfce7; color: #16a34a; }
.status-sold { background: #fee2e2; color: #dc2626; }
.status-offline { background: #f3f4f6; color: #6b7280; }
.vehicle-specs { font-size: 22rpx; color: #a8a29e; display: block; margin-bottom: 8rpx; }
.vehicle-bottom { display: flex; justify-content: space-between; align-items: center; }
.vehicle-price { font-size: 30rpx; font-weight: 700; color: #f59e0b; }
.vehicle-stock { font-size: 22rpx; color: #78716c; }

.empty-state { padding: 120rpx 0; text-align: center; }
.empty-icon { font-size: 80rpx; display: block; margin-bottom: 16rpx; }
.empty-text { font-size: 28rpx; color: #a8a29e; }
</style>