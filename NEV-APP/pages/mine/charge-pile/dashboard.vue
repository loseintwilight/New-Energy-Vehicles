<template>
	<view class="page" :class="{ 'page-ready': isReady }">
		<!-- 背景矩阵光晕 -->
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
					<text class="header-title">充电桩管理台</text>
					<text class="header-date">{{ todayDate }}</text>
				</view>
				<view class="header-right" @tap="switchToUser">
					<view class="more-badge">
						<text class="more-icon">⇋</text>
					</view>
				</view>
			</view>

			<!-- 4栏统计卡 -->
			<view class="stats-section">
				<view class="stats-row">
					<view class="stat-card" v-for="(item, idx) in statsData" :key="idx" :class="'stat-' + idx" hover-class="stat-hover" @tap="onStatTap(idx)">
						<view class="stat-glow-bar"></view>
						<view class="stat-icon-wrap">
							<text class="stat-icon-text">{{ item.icon }}</text>
						</view>
						<text class="stat-value">{{ item.value }}</text>
						<text class="stat-label">{{ item.label }}</text>
					</view>
				</view>
			</view>

			<!-- 快捷入口 -->
			<view class="section-block">
				<view class="title-bar">
					<view class="bar-line"></view>
					<text class="bar-title">快捷管理</text>
				</view>
				<view class="quick-grid">
					<view class="quick-card" v-for="(item, idx) in quickEntries" :key="idx" :class="item.cls" hover-class="quick-hover" @tap="onQuickTap(item)">
						<view class="quick-glow"></view>
						<text class="quick-icon">{{ item.icon }}</text>
						<text class="quick-name">{{ item.name }}</text>
						<text class="quick-desc">{{ item.desc }}</text>
					</view>
				</view>
			</view>

			<!-- 最新订单 -->
			<view class="section-block">
				<view class="title-bar">
					<view class="bar-line line-green"></view>
					<text class="bar-title">最新订单</text>
					<view class="bar-more" @tap="goOrderList">
						<text class="bar-more-text">全部</text>
						<text class="bar-more-icon">❯</text>
					</view>
				</view>
				<view class="order-list">
					<view class="order-item" v-for="(item, idx) in recentOrders" :key="idx" hover-class="order-hover" @tap="goOrderDetail(item.id)">
						<view class="order-left">
							<text class="order-station">{{ item.station }}</text>
							<text class="order-info">{{ item.pile }} | {{ item.time }}</text>
						</view>
						<view class="order-right">
							<text class="order-amount">¥{{ item.amount }}</text>
							<text class="order-status" :class="'status-' + item.statusType">{{ item.status }}</text>
						</view>
					</view>
				</view>
			</view>

			<!-- 最新评价 -->
			<view class="section-block">
				<view class="title-bar">
					<view class="bar-line line-blue"></view>
					<text class="bar-title">最新评价</text>
				</view>
				<view class="review-list">
					<view class="review-item" v-for="(item, idx) in recentReviews" :key="idx">
						<view class="review-avatar">{{ item.avatar }}</view>
						<view class="review-body">
							<view class="review-top">
								<text class="review-name">{{ item.name }}</text>
								<view class="review-stars">
									<text class="star" v-for="s in 5" :key="s" :class="{ active: s <= item.stars }">★</text>
								</view>
							</view>
							<text class="review-text">{{ item.text }}</text>
							<text class="review-time">{{ item.time }}</text>
						</view>
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
			todayDate: '',
			glowRows: [],
			statsData: [
				{ icon: '⚡', value: '186', label: '充电桩总数' },
				{ icon: '📋', value: '1,256', label: '今日订单' },
				{ icon: '¥', value: '8,920', label: '今日营收' },
				{ icon: '👤', value: '486', label: '活跃用户' }
			],
			quickEntries: [
				{ icon: '🔌', name: '充电桩管理', desc: '查看管理充电桩', cls: 'qc-orange', url: '/pages/mine/charge-pile/pile-list' },
				{ icon: '📊', name: '数据概览', desc: '运营数据分析', cls: 'qc-green', url: '/pages/mine/charge-pile/data-overview' },
				{ icon: '💰', name: '费率管理', desc: '设置充电费率', cls: 'qc-purple', url: '/pages/mine/charge-pile/rate-list' },
				{ icon: '🏪', name: '站点管理', desc: '管理充电站点', cls: 'qc-blue', url: '/pages/mine/charge-pile/station-list' },
				{ icon: '👥', name: '客户管理', desc: '管理客户信息', cls: 'qc-pink', url: '/pages/mine/charge-pile/customer-manage' },
				{ icon: '🔧', name: '售后管理', desc: '处理售后问题', cls: 'qc-teal', url: '/pages/mine/charge-pile/after-sale' },
				{ icon: '📝', name: '订单管理', desc: '查看所有订单', cls: 'qc-amber', url: '/pages/mine/charge-pile/order-list' },
				{ icon: '💳', name: '结算中心', desc: '收益结算提现', cls: 'qc-red', url: '/pages/mine/charge-pile/settlement-center' }
			],
			recentOrders: [
				{ id: 1001, station: '济南高新区充电站', pile: '1号快充桩', time: '10:32', amount: '45.80', status: '已完成', statusType: 'done' },
				{ id: 1002, station: '济南历下区旗舰站', pile: '3号超充桩', time: '10:15', amount: '128.50', status: '充电中', statusType: 'charging' },
				{ id: 1003, station: '济南市中区超充站', pile: '2号快充桩', time: '09:48', amount: '32.00', status: '已完成', statusType: 'done' },
				{ id: 1004, station: '济南天桥区充电站', pile: '5号慢充桩', time: '09:20', amount: '18.60', status: '已取消', statusType: 'cancel' }
			],
			recentReviews: [
				{ avatar: '张', name: '张先生', stars: 5, text: '充电速度很快，环境也很干净，下次还来！', time: '10分钟前' },
				{ avatar: '李', name: '李女士', stars: 4, text: '位置好找，价格合理，就是高峰期要排队。', time: '25分钟前' },
				{ avatar: '王', name: '王先生', stars: 5, text: '超充桩给力，半小时就充满了，好评！', time: '1小时前' }
			]
		}
	},
	created() {
		this.buildGlowRows()
		this.todayDate = this.getTodayDate()
		var self = this
		setTimeout(function() { self.isReady = true }, 200)
	},
	methods: {
		buildGlowRows() {
			var rows = []
			var colors = ['#f59e0b', '#f97316', '#fb923c', '#fbbf24', '#fcd34d', '#fde68a']
			for (var r = 0; r < 6; r++) {
				var dots = []
				var count = 4 + Math.floor(Math.random() * 4)
				for (var c = 0; c < count; c++) {
					var color = colors[Math.floor(Math.random() * colors.length)]
					var size = 4 + Math.floor(Math.random() * 8)
					var dur = 2 + Math.random() * 3
					var delay = Math.random() * 2
					dots.push({
						style: 'width:' + size + 'px;height:' + size + 'px;background:' + color + ';animation-duration:' + dur + 's;animation-delay:' + delay + 's;'
					})
				}
				rows.push({ dots: dots })
			}
			this.glowRows = rows
		},
		getTodayDate() {
			var d = new Date()
			return d.getFullYear() + '年' + (d.getMonth() + 1) + '月' + d.getDate() + '日'
		},
		goBack() { uni.navigateBack() },
		switchToUser() {
			this.$store.commit('SET_CURRENT_END', 'user')
			this.$tab.switchTab('/pages/mine/index')
		},
		onStatTap(idx) {
			var urls = ['/pages/mine/charge-pile/pile-list', '/pages/mine/charge-pile/order-list', '/pages/mine/charge-pile/data-overview', '/pages/mine/charge-pile/customer-manage']
			if (urls[idx]) uni.navigateTo({ url: urls[idx] })
		},
		onQuickTap(item) {
			if (item.url) uni.navigateTo({ url: item.url })
		},
		goOrderList() { uni.navigateTo({ url: '/pages/mine/charge-pile/order-list' }) },
		goOrderDetail(id) { uni.navigateTo({ url: '/pages/mine/charge-pile/order-detail?orderId=' + id }) }
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

/* ===== 背景光晕 ===== */
.glow-matrix {
	position: fixed;
	top: 0; left: 0; right: 0; bottom: 0;
	z-index: 0;
	overflow: hidden;
	pointer-events: none;
}
.glow-row {
	display: flex;
	justify-content: space-around;
	padding: 20rpx 30rpx;
}
.glow-spot {
	border-radius: 50%;
	filter: blur(6px);
	opacity: 0;
	animation: glowPulse ease-in-out infinite alternate;
}
@keyframes glowPulse {
	0% { opacity: 0; transform: scale(0.6); }
	50% { opacity: 0.5; }
	100% { opacity: 0; transform: scale(1.4); }
}
.overlay-mask {
	position: fixed;
	top: 0; left: 0; right: 0; bottom: 0;
	background: linear-gradient(180deg, rgba(255,247,237,0.3) 0%, rgba(255,251,235,0.43) 38%, rgba(254,252,232,0.55) 66%, rgba(255,247,237,0.63) 100%);
	z-index: 1;
	pointer-events: none;
}
.main-scroll { position: relative; z-index: 2; }

/* ===== 顶栏 ===== */
.header {
	position: relative;
	padding: 30rpx 28rpx 24rpx;
	display: flex;
	align-items: center;
}
.header-bg {
	position: absolute;
	top: -60rpx; left: -40rpx; right: -40rpx; bottom: 0;
	background: radial-gradient(ellipse at 20% 30%, rgba(251,146,60,0.12) 0%, transparent 60%),
	            radial-gradient(ellipse at 80% 50%, rgba(250,204,21,0.1) 0%, transparent 55%);
	border-radius: 0 0 60rpx 60rpx;
}
.back-btn {
	width: 60rpx; height: 60rpx;
	border-radius: 30rpx;
	background: rgba(255,255,255,0.75);
	backdrop-filter: blur(10px);
	display: flex;
	align-items: center;
	justify-content: center;
	z-index: 1;
	box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06);
}
.back-icon { font-size: 28rpx; color: #92400e; }
.btn-hover { opacity: 0.7; transform: scale(0.95); }
.header-info { flex: 1; margin-left: 20rpx; z-index: 1; }
.header-title { font-size: 36rpx; font-weight: 700; color: #451a03; display: block; }
.header-date { font-size: 24rpx; color: #a16207; margin-top: 4rpx; display: block; }
.header-right { z-index: 1; }
.more-badge {
	width: 64rpx; height: 64rpx;
	border-radius: 32rpx;
	background: linear-gradient(135deg, #f59e0b, #f97316);
	display: flex;
	align-items: center;
	justify-content: center;
	box-shadow: 0 4rpx 16rpx rgba(245,158,11,0.35);
}
.more-icon { font-size: 26rpx; color: #fff; }

/* ===== 统计卡 ===== */
.stats-section { padding: 0 24rpx 20rpx; }
.stats-row { display: flex; gap: 16rpx; }
.stat-card {
	flex: 1;
	background: rgba(255,255,255,0.85);
	backdrop-filter: blur(12px);
	border-radius: 24rpx;
	padding: 24rpx 16rpx 20rpx;
	position: relative;
	overflow: hidden;
	box-shadow: 0 4rpx 20rpx rgba(0,0,0,0.04);
	display: flex;
	flex-direction: column;
	align-items: center;
}
.stat-hover { transform: scale(0.97); }
.stat-glow-bar {
	position: absolute;
	top: 0; left: 20%; right: 20%; height: 4rpx;
	border-radius: 0 0 4rpx 4rpx;
}
.stat-0 .stat-glow-bar { background: #f59e0b; }
.stat-1 .stat-glow-bar { background: #22c55e; }
.stat-2 .stat-glow-bar { background: #3b82f6; }
.stat-3 .stat-glow-bar { background: #a855f7; }
.stat-icon-wrap {
	width: 56rpx; height: 56rpx;
	border-radius: 28rpx;
	display: flex;
	align-items: center;
	justify-content: center;
	margin-bottom: 12rpx;
}
.stat-0 .stat-icon-wrap { background: #fef3c7; }
.stat-1 .stat-icon-wrap { background: #dcfce7; }
.stat-2 .stat-icon-wrap { background: #dbeafe; }
.stat-3 .stat-icon-wrap { background: #f3e8ff; }
.stat-icon-text { font-size: 28rpx; }
.stat-value { font-size: 32rpx; font-weight: 700; color: #1c1917; }
.stat-label { font-size: 22rpx; color: #78716c; margin-top: 4rpx; }

/* ===== 区块通用 ===== */
.section-block { margin: 0 24rpx 20rpx; }
.title-bar {
	display: flex;
	align-items: center;
	margin-bottom: 16rpx;
}
.bar-line {
	width: 6rpx; height: 32rpx;
	border-radius: 3rpx;
	background: linear-gradient(180deg, #f59e0b, #f97316);
	margin-right: 12rpx;
}
.bar-line.line-green { background: linear-gradient(180deg, #22c55e, #16a34a); }
.bar-line.line-blue { background: linear-gradient(180deg, #3b82f6, #2563eb); }
.bar-title { font-size: 30rpx; font-weight: 700; color: #1c1917; flex: 1; }
.bar-more { display: flex; align-items: center; }
.bar-more-text { font-size: 24rpx; color: #a16207; }
.bar-more-icon { font-size: 20rpx; color: #a16207; margin-left: 4rpx; }

/* ===== 快捷入口 ===== */
.quick-grid {
	display: flex;
	flex-wrap: wrap;
	gap: 16rpx;
}
.quick-card {
	width: calc(25% - 12rpx);
	aspect-ratio: 1;
	background: rgba(255,255,255,0.85);
	backdrop-filter: blur(10px);
	border-radius: 20rpx;
	padding: 20rpx 12rpx;
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	position: relative;
	overflow: hidden;
	box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04);
}
.quick-hover { transform: scale(0.95); }
.quick-glow {
	position: absolute;
	top: -20rpx; right: -20rpx;
	width: 60rpx; height: 60rpx;
	border-radius: 30rpx;
	opacity: 0.15;
}
.qc-orange .quick-glow { background: #f59e0b; }
.qc-green .quick-glow { background: #22c55e; }
.qc-purple .quick-glow { background: #a855f7; }
.qc-blue .quick-glow { background: #3b82f6; }
.qc-pink .quick-glow { background: #ec4899; }
.qc-teal .quick-glow { background: #14b8a6; }
.qc-amber .quick-glow { background: #d97706; }
.qc-red .quick-glow { background: #ef4444; }
.quick-icon { font-size: 36rpx; margin-bottom: 8rpx; }
.quick-name { font-size: 22rpx; font-weight: 600; color: #1c1917; }
.quick-desc { font-size: 18rpx; color: #a8a29e; margin-top: 4rpx; }

/* ===== 订单列表 ===== */
.order-item {
	background: rgba(255,255,255,0.85);
	backdrop-filter: blur(10px);
	border-radius: 16rpx;
	padding: 20rpx;
	margin-bottom: 12rpx;
	display: flex;
	justify-content: space-between;
	align-items: center;
	box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.03);
}
.order-hover { opacity: 0.8; }
.order-left { flex: 1; }
.order-station { font-size: 28rpx; font-weight: 600; color: #1c1917; display: block; }
.order-info { font-size: 22rpx; color: #a8a29e; margin-top: 4rpx; display: block; }
.order-right { text-align: right; }
.order-amount { font-size: 30rpx; font-weight: 700; color: #f59e0b; display: block; }
.order-status { font-size: 22rpx; padding: 4rpx 12rpx; border-radius: 12rpx; margin-top: 4rpx; display: inline-block; }
.status-done { background: #dcfce7; color: #16a34a; }
.status-charging { background: #fef3c7; color: #b45309; }
.status-cancel { background: #fee2e2; color: #dc2626; }

/* ===== 评价列表 ===== */
.review-item {
	background: rgba(255,255,255,0.85);
	backdrop-filter: blur(10px);
	border-radius: 16rpx;
	padding: 20rpx;
	margin-bottom: 12rpx;
	display: flex;
	box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.03);
}
.review-avatar {
	width: 64rpx; height: 64rpx;
	border-radius: 32rpx;
	background: linear-gradient(135deg, #fef3c7, #fde68a);
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 26rpx;
	font-weight: 600;
	color: #92400e;
	margin-right: 16rpx;
	flex-shrink: 0;
}
.review-body { flex: 1; }
.review-top { display: flex; justify-content: space-between; align-items: center; }
.review-name { font-size: 26rpx; font-weight: 600; color: #1c1917; }
.star { font-size: 24rpx; color: #e5e7eb; }
.star.active { color: #f59e0b; }
.review-text { font-size: 24rpx; color: #57534e; margin-top: 8rpx; display: block; line-height: 1.5; }
.review-time { font-size: 20rpx; color: #a8a29e; margin-top: 6rpx; display: block; }
</style>