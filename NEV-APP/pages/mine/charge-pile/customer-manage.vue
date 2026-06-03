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
					<text class="header-title">客户管理</text>
					<text class="header-sub">共 {{ customerList.length }} 位客户</text>
				</view>
				<view class="header-right" @tap="addCustomer">
					<view class="add-btn">
						<text class="add-icon">+</text>
					</view>
				</view>
			</view>

			<view class="search-bar">
				<text class="search-icon">🔍</text>
				<input class="search-input" v-model="searchKey" placeholder="搜索客户姓名或手机号" placeholder-class="search-placeholder" />
			</view>

			<view class="customer-list">
				<view class="customer-card" v-for="(item, idx) in filteredCustomers" :key="idx" hover-class="card-hover" @tap="goDetail(item.id)">
					<view class="customer-avatar" :style="{ background: item.avatarBg }">
						<text>{{ item.name.charAt(0) }}</text>
					</view>
					<view class="customer-info">
						<view class="customer-top">
							<text class="customer-name">{{ item.name }}</text>
							<text class="customer-level" :class="'level-' + item.level">{{ item.levelText }}</text>
						</view>
						<text class="customer-phone">{{ item.phone }}</text>
						<text class="customer-car">{{ item.car }}</text>
					</view>
					<view class="customer-right">
						<text class="customer-orders">{{ item.totalOrders }}笔</text>
						<text class="customer-amount">¥{{ item.totalAmount }}</text>
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
			searchKey: '',
			customerList: [
				{ id: 1, name: '张先生', phone: '138****6789', car: '比亚迪 汉EV', level: 'vip', levelText: 'VIP', totalOrders: '86', totalAmount: '4,520.80', avatarBg: 'linear-gradient(135deg, #fef3c7, #fde68a)' },
				{ id: 2, name: '李女士', phone: '139****8901', car: '特斯拉 Model 3', level: 'vip', levelText: 'VIP', totalOrders: '72', totalAmount: '3,890.50', avatarBg: 'linear-gradient(135deg, #dbeafe, #bfdbfe)' },
				{ id: 3, name: '王先生', phone: '136****2345', car: '小鹏 P7', level: 'normal', levelText: '普通', totalOrders: '35', totalAmount: '1,680.00', avatarBg: 'linear-gradient(135deg, #dcfce7, #bbf7d0)' },
				{ id: 4, name: '赵女士', phone: '137****4567', car: '蔚来 ES6', level: 'normal', levelText: '普通', totalOrders: '28', totalAmount: '1,320.00', avatarBg: 'linear-gradient(135deg, #f3e8ff, #e9d5ff)' },
				{ id: 5, name: '孙先生', phone: '135****7890', car: '理想 L8', level: 'new', levelText: '新用户', totalOrders: '8', totalAmount: '386.00', avatarBg: 'linear-gradient(135deg, #fee2e2, #fecaca)' }
			]
		}
	},
	computed: {
		filteredCustomers() {
			var self = this
			if (!self.searchKey) return self.customerList
			var key = self.searchKey.toLowerCase()
			return self.customerList.filter(function(c) {
				return c.name.toLowerCase().indexOf(key) !== -1 || c.phone.indexOf(key) !== -1
			})
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
		addCustomer() { uni.showToast({ title: '添加客户', icon: 'none', duration: 1500 }) },
		goDetail(id) { uni.showToast({ title: '客户详情 ID:' + id, icon: 'none', duration: 1500 }) }
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
.header-info { flex: 1; margin-left: 20rpx; z-index: 1; }
.header-title { font-size: 36rpx; font-weight: 700; color: #451a03; display: block; }
.header-sub { font-size: 24rpx; color: #a16207; margin-top: 4rpx; display: block; }
.header-right { z-index: 1; }
.add-btn { width: 60rpx; height: 60rpx; border-radius: 30rpx; background: linear-gradient(135deg, #f59e0b, #f97316); display: flex; align-items: center; justify-content: center; box-shadow: 0 4rpx 16rpx rgba(245,158,11,0.35); }
.add-icon { font-size: 32rpx; color: #fff; }
.btn-hover { opacity: 0.7; }

.search-bar { margin: 0 24rpx 20rpx; background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 16rpx 20rpx; display: flex; align-items: center; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.search-icon { font-size: 28rpx; margin-right: 12rpx; }
.search-input { flex: 1; font-size: 26rpx; color: #1c1917; }
.search-placeholder { color: #a8a29e; }

.customer-list { padding: 0 24rpx; }
.customer-card { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 24rpx; margin-bottom: 16rpx; display: flex; align-items: center; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.card-hover { transform: scale(0.98); opacity: 0.9; }
.customer-avatar { width: 68rpx; height: 68rpx; border-radius: 34rpx; display: flex; align-items: center; justify-content: center; font-size: 28rpx; font-weight: 700; color: #92400e; margin-right: 16rpx; flex-shrink: 0; }
.customer-info { flex: 1; }
.customer-top { display: flex; align-items: center; }
.customer-name { font-size: 28rpx; font-weight: 600; color: #1c1917; }
.customer-level { font-size: 20rpx; padding: 2rpx 10rpx; border-radius: 10rpx; margin-left: 10rpx; }
.level-vip { background: #fef3c7; color: #b45309; }
.level-normal { background: #dcfce7; color: #16a34a; }
.level-new { background: #dbeafe; color: #2563eb; }
.customer-phone { font-size: 22rpx; color: #a8a29e; margin-top: 4rpx; display: block; }
.customer-car { font-size: 22rpx; color: #a8a29e; margin-top: 2rpx; display: block; }
.customer-right { text-align: right; }
.customer-orders { font-size: 24rpx; color: #57534e; display: block; }
.customer-amount { font-size: 28rpx; font-weight: 700; color: #f59e0b; margin-top: 4rpx; display: block; }
</style>