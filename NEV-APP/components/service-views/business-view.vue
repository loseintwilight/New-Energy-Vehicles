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
				<view class="back-btn" hover-class="btn-hover" @tap="switchToUser">
					<text class="back-icon">⇋</text>
				</view>
				<view class="header-info">
					<text class="header-title">车辆管理台</text>
					<text class="header-date">{{ todayDate }}</text>
				</view>
				<view class="header-right" @tap="showMore">
					<view class="more-badge">
						<text class="more-icon">✦</text>
					</view>
				</view>
			</view>

			<!-- 用户信息（在车辆管理台标题下方） -->
			<view class="user-info-row">
				<image v-if="userAvatar" :src="userAvatar" class="user-avatar" mode="aspectFill" @click="goToAvatar"></image>
				<view v-else class="user-avatar user-avatar-placeholder" @click="goToAvatar">
					<uni-icons type="person" size="22" color="#d97706"></uni-icons>
				</view>
				<view class="user-meta" @click="goToInfo">
					<text class="user-name">{{ userName }}</text>
					<text class="user-phone">{{ userPhone }}</text>
				</view>
			</view>

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
							<text class="order-model">{{ item.model }}</text>
							<text class="order-info">{{ item.customer }} | {{ item.time }}</text>
						</view>
						<view class="order-right">
							<text class="order-amount">¥{{ item.amount }}</text>
							<text class="order-status" :class="'status-' + item.statusType">{{ item.status }}</text>
						</view>
					</view>
				</view>
			</view>

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
	name: 'BusinessView',
	data() {
		return {
			userName: this.$store.state.user.name || '商家管理员',
			userPhone: this.$store.state.user.phonenumber || '',
			userAvatar: this.$store.state.user.avatar || '',
			isReady: false,
			todayDate: '',
			glowRows: [],
			statsData: [
				{ icon: '🚗', value: '128', label: '车辆总数' },
				{ icon: '📋', value: '856', label: '今日订单' },
				{ icon: '¥', value: '156,800', label: '今日营收' },
				{ icon: '👤', value: '326', label: '活跃用户' }
			],
			quickEntries: [
				{ icon: '🚙', name: '车辆管理', desc: '查看管理车辆', cls: 'qc-orange', url: '/pages/mine/vehicle/vehicle-list' },
				{ icon: '➕', name: '添加车辆', desc: '上架新车', cls: 'qc-green', url: '/pages/mine/vehicle/vehicle-add' },
				{ icon: '📦', name: '库存管理', desc: '管理车辆库存', cls: 'qc-purple', url: '/pages/mine/vehicle/stock-manage' },
				{ icon: '💰', name: '价格管理', desc: '设置车辆价格', cls: 'qc-blue', url: '/pages/mine/vehicle/price-manage' },
				{ icon: '📝', name: '订单管理', desc: '查看所有订单', cls: 'qc-amber', url: '/pages/mine/vehicle/vehicle-order-list' },
				{ icon: '💳', name: '财务管理', desc: '收支明细', cls: 'qc-pink', url: '/pages/mine/vehicle/finance-list' },
				{ icon: '🔧', name: '售后管理', desc: '处理售后问题', cls: 'qc-teal', url: '/pages/mine/vehicle/after-sale' },
				{ icon: '⭐', name: '评价管理', desc: '查看用户评价', cls: 'qc-red', url: '/pages/mine/vehicle/review-list' }
			],
			recentOrders: [
				{ id: 2001, model: '比亚迪 汉EV', customer: '张先生', time: '10:32', amount: '239,800', status: '已完成', statusType: 'done' },
				{ id: 2002, model: '特斯拉 Model Y', customer: '李女士', time: '10:15', amount: '299,900', status: '待交付', statusType: 'pending' },
				{ id: 2003, model: '小鹏 G9', customer: '王先生', time: '09:48', amount: '359,800', status: '已完成', statusType: 'done' },
				{ id: 2004, model: '蔚来 ET5', customer: '赵女士', time: '09:20', amount: '328,800', status: '已取消', statusType: 'cancel' }
			],
			recentReviews: [
				{ avatar: '张', name: '张先生', stars: 5, text: '车辆外观漂亮，续航扎实，非常满意这次购车体验！', time: '10分钟前' },
				{ avatar: '李', name: '李女士', stars: 4, text: '服务态度好，提车流程顺畅，就是等车时间有点长。', time: '25分钟前' },
				{ avatar: '王', name: '王先生', stars: 5, text: '智能驾驶辅助很好用，内饰做工精细，推荐！', time: '1小时前' }
			]
		}
	},
	created() {
		this.buildGlowRows()
		this.todayDate = this.getTodayDate()
		var self = this
		setTimeout(function() { self.isReady = true }, 200)
	},
	onShow() {
		this.userName = this.$store.state.user.name || '商家管理员'
		this.userPhone = this.$store.state.user.phonenumber || ''
		this.userAvatar = this.$store.state.user.avatar || ''
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
		switchToUser() {
			this.$store.commit('SET_CURRENT_END', 'user')
		},
		showMore() { uni.showToast({ title: '更多功能', icon: 'none', duration: 1500 }) },
		onStatTap(idx) {
			var urls = ['/pages/mine/vehicle/vehicle-list', '/pages/mine/vehicle/vehicle-order-list', '/pages/mine/vehicle/finance-list', '/pages/mine/vehicle/review-list']
			if (urls[idx]) uni.navigateTo({ url: urls[idx] })
		},
		onQuickTap(item) {
			if (item.url) uni.navigateTo({ url: item.url })
		},
		goOrderList() { uni.navigateTo({ url: '/pages/mine/vehicle/vehicle-order-list' }) },
		goOrderDetail(id) { uni.navigateTo({ url: '/pages/mine/vehicle/vehicle-order-detail?orderId=' + id }) },
		goToAvatar() { uni.navigateTo({ url: '/pages/mine/avatar/index' }) },
		goToInfo() { uni.navigateTo({ url: '/pages/mine/info/index' }) }
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
	100% { opacity: 0.5; transform: scale(1.2); }
}

.main-scroll { position: relative; z-index: 2; }

/* ========== 用户信息行（暖色风格） ========== */
.user-info-row {
	position: relative;
	z-index: 3;
	padding: 28rpx 28rpx 8rpx;
	display: flex;
	align-items: center;
	gap: 16rpx;
}
.user-avatar {
	width: 80rpx;
	height: 80rpx;
	border-radius: 50%;
	border: 3rpx solid rgba(251, 146, 60, 0.4);
}
.user-avatar-placeholder {
	background: linear-gradient(135deg, #fde68a, #fbbf24);
	display: flex;
	align-items: center;
	justify-content: center;
}
.user-meta {
	display: flex;
	flex-direction: column;
	gap: 4rpx;
}
.user-name {
	font-size: 30rpx;
	font-weight: 700;
	color: #431407;
}
.user-phone {
	font-size: 22rpx;
	color: #92400e;
}

/* ========== 顶栏 ========== */
.overlay-mask {
	position: fixed;
	top: 0; left: 0; right: 0; bottom: 0;
	background: linear-gradient(180deg, rgba(255,247,237,0.3) 0%, rgba(255,251,235,0.43) 38%, rgba(254,252,232,0.55) 66%, rgba(255,247,237,0.63) 100%);
	z-index: 1;
	pointer-events: none;
}
.main-scroll { position: relative; z-index: 2; }

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
.line-green { background: linear-gradient(180deg, #22c55e, #16a34a); }
.line-blue { background: linear-gradient(180deg, #3b82f6, #2563eb); }
.bar-title { font-size: 30rpx; font-weight: 700; color: #1c1917; flex: 1; }
.bar-more { display: flex; align-items: center; }
.bar-more-text { font-size: 24rpx; color: #a8a29e; }
.bar-more-icon { font-size: 22rpx; color: #a8a29e; margin-left: 4rpx; }

.quick-grid {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 16rpx;
}
.quick-card {
	background: rgba(255,255,255,0.85);
	backdrop-filter: blur(12px);
	border-radius: 20rpx;
	padding: 24rpx 12rpx 20rpx;
	text-align: center;
	position: relative;
	overflow: hidden;
	box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04);
}
.quick-hover { transform: scale(0.95); opacity: 0.85; }
.quick-glow {
	position: absolute;
	top: -20rpx; right: -20rpx;
	width: 80rpx; height: 80rpx;
	border-radius: 40rpx;
	opacity: 0.12;
}
.qc-orange .quick-glow { background: #f59e0b; }
.qc-green .quick-glow { background: #22c55e; }
.qc-purple .quick-glow { background: #a855f7; }
.qc-blue .quick-glow { background: #3b82f6; }
.qc-amber .quick-glow { background: #f59e0b; }
.qc-pink .quick-glow { background: #ec4899; }
.qc-teal .quick-glow { background: #14b8a6; }
.qc-red .quick-glow { background: #ef4444; }
.quick-icon { font-size: 36rpx; display: block; margin-bottom: 8rpx; }
.quick-name { font-size: 24rpx; font-weight: 600; color: #1c1917; display: block; }
.quick-desc { font-size: 20rpx; color: #a8a29e; margin-top: 4rpx; display: block; }

.order-item {
	background: rgba(255,255,255,0.85);
	backdrop-filter: blur(10px);
	border-radius: 20rpx;
	padding: 24rpx;
	margin-bottom: 12rpx;
	display: flex;
	justify-content: space-between;
	align-items: center;
	box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04);
}
.order-hover { transform: scale(0.98); opacity: 0.9; }
.order-left { flex: 1; }
.order-model { font-size: 28rpx; font-weight: 600; color: #1c1917; display: block; }
.order-info { font-size: 22rpx; color: #a8a29e; margin-top: 4rpx; display: block; }
.order-right { text-align: right; }
.order-amount { font-size: 28rpx; font-weight: 700; color: #f59e0b; display: block; }
.order-status { font-size: 20rpx; padding: 4rpx 12rpx; border-radius: 12rpx; margin-top: 6rpx; display: inline-block; }
.status-done { background: #dcfce7; color: #16a34a; }
.status-pending { background: #fef3c7; color: #b45309; }
.status-cancel { background: #fee2e2; color: #dc2626; }

.review-item {
	background: rgba(255,255,255,0.85);
	backdrop-filter: blur(10px);
	border-radius: 20rpx;
	padding: 24rpx;
	margin-bottom: 12rpx;
	display: flex;
	box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04);
}
.review-avatar {
	width: 68rpx; height: 68rpx;
	border-radius: 34rpx;
	background: linear-gradient(135deg, #fef3c7, #fde68a);
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 28rpx;
	font-weight: 700;
	color: #92400e;
	margin-right: 16rpx;
	flex-shrink: 0;
}
.review-body { flex: 1; }
.review-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 8rpx; }
.review-name { font-size: 26rpx; font-weight: 600; color: #1c1917; }
.review-stars { display: flex; }
.star { font-size: 22rpx; color: #e5e7eb; margin-left: 2rpx; }
.star.active { color: #f59e0b; }
.review-text { font-size: 24rpx; color: #57534e; line-height: 1.5; display: block; }
.review-time { font-size: 20rpx; color: #a8a29e; margin-top: 8rpx; display: block; }
</style>
