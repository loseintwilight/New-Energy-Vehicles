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
					<text class="header-title">订单管理</text>
					<text class="header-sub">共 {{ totalOrders }} 笔订单</text>
				</view>
				<view class="header-right" @tap="showFilter">
					<text class="filter-icon">☰</text>
				</view>
			</view>

			<!-- 统计条 -->
			<view class="summary-bar">
				<view class="summary-item">
					<text class="summary-val">¥{{ totalAmount }}</text>
					<text class="summary-label">今日营收</text>
				</view>
				<view class="summary-divider"></view>
				<view class="summary-item">
					<text class="summary-val">{{ todayCount }}</text>
					<text class="summary-label">今日订单</text>
				</view>
				<view class="summary-divider"></view>
				<view class="summary-item">
					<text class="summary-val">¥{{ avgAmount }}</text>
					<text class="summary-label">客单价</text>
				</view>
			</view>

			<!-- 筛选标签 -->
			<view class="filter-tabs">
				<view class="filter-tab" v-for="(tab, idx) in filterTabs" :key="idx" :class="{ active: activeFilter === idx }" @tap="switchFilter(idx)">
					<text>{{ tab }}</text>
				</view>
			</view>

			<!-- 订单列表 -->
			<view class="order-list">
				<view class="order-card" v-for="(item, idx) in filteredOrders" :key="idx" hover-class="card-hover" @tap="goDetail(item.id)">
					<view class="order-card-top">
						<view class="order-station-row">
							<text class="order-station">{{ item.station }}</text>
							<text class="order-status" :class="'status-' + item.statusType">{{ item.status }}</text>
						</view>
						<text class="order-pile">{{ item.pileNo }}</text>
					</view>
					<view class="order-card-bottom">
						<view class="order-user">
							<view class="user-avatar">{{ item.userName.charAt(0) }}</view>
							<text class="user-name">{{ item.userName }}</text>
						</view>
						<view class="order-info-row">
							<text class="order-time">{{ item.time }}</text>
							<text class="order-energy">{{ item.energy }}kWh</text>
							<text class="order-amount">¥{{ item.amount }}</text>
						</view>
					</view>
				</view>
			</view>

			<!-- 空状态 -->
			<view class="empty-state" v-if="filteredOrders.length === 0">
				<text class="empty-icon">📋</text>
				<text class="empty-text">暂无订单</text>
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
			filterTabs: ['全部', '充电中', '已完成', '已取消'],
			allOrders: [
				{ id: 1001, station: '济南高新区充电站', pileNo: '1号快充桩 (120kW)', userName: '张先生', time: '2026-06-03 10:32', energy: '28.6', amount: '45.80', status: '已完成', statusType: 'done' },
				{ id: 1002, station: '济南历下区旗舰站', pileNo: '3号超充桩 (240kW)', userName: '李女士', time: '2026-06-03 10:15', energy: '56.2', amount: '128.50', status: '充电中', statusType: 'charging' },
				{ id: 1003, station: '济南市中区超充站', pileNo: '2号快充桩 (120kW)', userName: '王先生', time: '2026-06-03 09:48', energy: '20.0', amount: '32.00', status: '已完成', statusType: 'done' },
				{ id: 1004, station: '济南天桥区充电站', pileNo: '5号慢充桩 (7kW)', userName: '赵女士', time: '2026-06-03 09:20', energy: '11.6', amount: '18.60', status: '已取消', statusType: 'cancel' },
				{ id: 1005, station: '济南槐荫区充电站', pileNo: '1号快充桩 (120kW)', userName: '孙先生', time: '2026-06-03 08:55', energy: '35.8', amount: '57.30', status: '已完成', statusType: 'done' },
				{ id: 1006, station: '济南高新区充电站', pileNo: '4号超充桩 (240kW)', userName: '周女士', time: '2026-06-03 08:30', energy: '42.1', amount: '96.80', status: '已完成', statusType: 'done' },
				{ id: 1007, station: '济南历下区旗舰站', pileNo: '2号慢充桩 (7kW)', userName: '吴先生', time: '2026-06-02 18:20', energy: '15.3', amount: '24.50', status: '已完成', statusType: 'done' },
				{ id: 1008, station: '济南市中区超充站', pileNo: '3号快充桩 (120kW)', userName: '郑女士', time: '2026-06-02 17:45', energy: '0', amount: '0.00', status: '已取消', statusType: 'cancel' }
			]
		}
	},
	computed: {
		filteredOrders() {
			var self = this
			var filters = ['all', 'charging', 'done', 'cancel']
			var filter = filters[self.activeFilter]
			if (filter === 'all') return self.allOrders
			return self.allOrders.filter(function(o) { return o.statusType === filter })
		},
		totalOrders() { return this.allOrders.length },
		todayCount() {
			var self = this
			return self.allOrders.filter(function(o) { return o.time.indexOf('2026-06-03') !== -1 }).length
		},
		totalAmount() {
			var self = this
			var sum = 0
			self.allOrders.filter(function(o) { return o.time.indexOf('2026-06-03') !== -1 }).forEach(function(o) { sum += parseFloat(o.amount) })
			return sum.toFixed(2)
		},
		avgAmount() {
			var self = this
			var todayOrders = self.allOrders.filter(function(o) { return o.time.indexOf('2026-06-03') !== -1 && o.statusType !== 'cancel' })
			if (todayOrders.length === 0) return '0.00'
			var sum = 0
			todayOrders.forEach(function(o) { sum += parseFloat(o.amount) })
			return (sum / todayOrders.length).toFixed(2)
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
			var colors = ['#f59e0b', '#f97316', '#fb923c', '#fbbf24', '#fcd34d']
			for (var r = 0; r < 5; r++) {
				var dots = []
				var count = 3 + Math.floor(Math.random() * 4)
				for (var c = 0; c < count; c++) {
					var color = colors[Math.floor(Math.random() * colors.length)]
					var size = 3 + Math.floor(Math.random() * 7)
					var dur = 2 + Math.random() * 3
					dots.push({ style: 'width:' + size + 'px;height:' + size + 'px;background:' + color + ';animation-duration:' + dur + 's;animation-delay:' + Math.random() * 2 + 's;' })
				}
				rows.push({ dots: dots })
			}
			this.glowRows = rows
		},
		goBack() { uni.navigateBack() },
		showFilter() { uni.showToast({ title: '筛选功能', icon: 'none', duration: 1500 }) },
		switchFilter(idx) { this.activeFilter = idx },
		goDetail(id) { uni.navigateTo({ url: '/pages/mine/charge-pile/order-detail?orderId=' + id }) }
	}
}
</script>

<style scoped>
.page {
	min-height: 100vh;
	background: linear-gradient(180deg, #fff7ed 0%, #fffbeb 30%, #fefce8 60%, #fff7ed 100%);
	opacity: 0;
	transition: opacity 0.5s ease;
}
.page-ready { opacity: 1; }
.glow-matrix { position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 0; overflow: hidden; pointer-events: none; }
.glow-row { display: flex; justify-content: space-around; padding: 20rpx 30rpx; }
.glow-spot { border-radius: 50%; filter: blur(6px); opacity: 0; animation: glowPulse ease-in-out infinite alternate; }
@keyframes glowPulse {
	0% { opacity: 0; transform: scale(0.6); }
	50% { opacity: 0.5; }
	100% { opacity: 0; transform: scale(1.4); }
}
.overlay-mask {
	position: fixed; top: 0; left: 0; right: 0; bottom: 0;
	background: linear-gradient(180deg, rgba(255,247,237,0.3) 0%, rgba(255,251,235,0.43) 38%, rgba(254,252,232,0.55) 66%, rgba(255,247,237,0.63) 100%);
	z-index: 1; pointer-events: none;
}
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
.filter-icon { font-size: 32rpx; color: #92400e; padding: 12rpx; }

/* 统计条 */
.summary-bar { margin: 0 24rpx 20rpx; background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 24rpx; display: flex; align-items: center; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.summary-item { flex: 1; text-align: center; }
.summary-val { font-size: 32rpx; font-weight: 700; color: #f59e0b; display: block; }
.summary-label { font-size: 22rpx; color: #78716c; margin-top: 4rpx; display: block; }
.summary-divider { width: 2rpx; height: 48rpx; background: #e7e5e4; }

/* 筛选标签 */
.filter-tabs { display: flex; gap: 16rpx; padding: 0 24rpx 20rpx; }
.filter-tab { padding: 12rpx 28rpx; border-radius: 32rpx; font-size: 24rpx; color: #78716c; background: rgba(255,255,255,0.7); transition: all 0.3s; }
.filter-tab.active { background: linear-gradient(135deg, #f59e0b, #f97316); color: #fff; font-weight: 600; box-shadow: 0 4rpx 12rpx rgba(245,158,11,0.3); }

/* 订单卡片 */
.order-list { padding: 0 24rpx; }
.order-card { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 24rpx; margin-bottom: 16rpx; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.card-hover { transform: scale(0.98); opacity: 0.9; }
.order-card-top { margin-bottom: 16rpx; }
.order-station-row { display: flex; justify-content: space-between; align-items: center; }
.order-station { font-size: 28rpx; font-weight: 600; color: #1c1917; }
.order-status { font-size: 22rpx; padding: 4rpx 16rpx; border-radius: 16rpx; }
.status-done { background: #dcfce7; color: #16a34a; }
.status-charging { background: #fef3c7; color: #b45309; }
.status-cancel { background: #fee2e2; color: #dc2626; }
.order-pile { font-size: 22rpx; color: #a8a29e; margin-top: 6rpx; display: block; }
.order-card-bottom { display: flex; justify-content: space-between; align-items: center; }
.order-user { display: flex; align-items: center; }
.user-avatar { width: 48rpx; height: 48rpx; border-radius: 24rpx; background: linear-gradient(135deg, #fef3c7, #fde68a); display: flex; align-items: center; justify-content: center; font-size: 22rpx; font-weight: 600; color: #92400e; margin-right: 10rpx; }
.user-name { font-size: 24rpx; color: #57534e; }
.order-info-row { text-align: right; }
.order-time { font-size: 22rpx; color: #a8a29e; display: block; }
.order-energy { font-size: 22rpx; color: #a8a29e; display: block; }
.order-amount { font-size: 30rpx; font-weight: 700; color: #f59e0b; display: block; }

/* 空状态 */
.empty-state { display: flex; flex-direction: column; align-items: center; padding: 120rpx 0; }
.empty-icon { font-size: 80rpx; margin-bottom: 16rpx; }
.empty-text { font-size: 28rpx; color: #a8a29e; }
</style>