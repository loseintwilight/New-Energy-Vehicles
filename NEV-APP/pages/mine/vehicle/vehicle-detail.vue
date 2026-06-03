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
					<text class="header-title">车辆详情</text>
					<text class="header-sub">{{ vehicle.name }}</text>
				</view>
				<view class="header-right" @tap="goEdit">
					<text class="edit-text">编辑</text>
				</view>
			</view>

			<!-- 车辆图片 -->
			<view class="vehicle-hero">
				<view class="hero-bg"></view>
				<text class="hero-icon">{{ vehicle.brandIcon }}</text>
				<view class="hero-badge" :class="'badge-' + vehicle.statusType">{{ vehicle.statusText }}</view>
			</view>

			<!-- 基本信息 -->
			<view class="info-section">
				<view class="section-title">
					<view class="title-line"></view>
					<text class="title-text">基本信息</text>
				</view>
				<view class="info-card">
					<view class="info-row">
						<text class="info-label">车型名称</text>
						<text class="info-value">{{ vehicle.name }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">品牌</text>
						<text class="info-value">{{ vehicle.brand }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">车型类别</text>
						<text class="info-value">{{ vehicle.type }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">售价</text>
						<text class="info-value highlight">¥{{ vehicle.price }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">库存</text>
						<text class="info-value">{{ vehicle.stock }} 台</text>
					</view>
				</view>
			</view>

			<!-- 性能参数 -->
			<view class="info-section">
				<view class="section-title">
					<view class="title-line line-green"></view>
					<text class="title-text">性能参数</text>
				</view>
				<view class="info-card">
					<view class="info-row">
						<text class="info-label">续航里程</text>
						<text class="info-value">{{ vehicle.range }} km</text>
					</view>
					<view class="info-row">
						<text class="info-label">电池容量</text>
						<text class="info-value">{{ vehicle.battery }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">电机功率</text>
						<text class="info-value">{{ vehicle.power }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">百公里加速</text>
						<text class="info-value">{{ vehicle.acceleration }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">最高时速</text>
						<text class="info-value">{{ vehicle.maxSpeed }}</text>
					</view>
				</view>
			</view>

			<!-- 销售数据 -->
			<view class="info-section">
				<view class="section-title">
					<view class="title-line line-blue"></view>
					<text class="title-text">销售数据</text>
				</view>
				<view class="data-grid">
					<view class="data-item">
						<text class="data-val">{{ vehicle.totalSales }}</text>
						<text class="data-label">累计销量</text>
					</view>
					<view class="data-item">
						<text class="data-val">{{ vehicle.monthSales }}</text>
						<text class="data-label">本月销量</text>
					</view>
					<view class="data-item">
						<text class="data-val">{{ vehicle.avgRating }}</text>
						<text class="data-label">平均评分</text>
					</view>
					<view class="data-item">
						<text class="data-val">{{ vehicle.reviewCount }}</text>
						<text class="data-label">评价数</text>
					</view>
				</view>
			</view>

			<!-- 车辆描述 -->
			<view class="info-section">
				<view class="section-title">
					<view class="title-line line-purple"></view>
					<text class="title-text">车辆描述</text>
				</view>
				<view class="desc-card">
					<text class="desc-text">{{ vehicle.description }}</text>
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
			vehicle: {
				id: 1,
				name: '比亚迪 汉EV',
				brandIcon: '🚗',
				brand: '比亚迪',
				type: '纯电动轿车',
				price: '239,800',
				stock: '12',
				range: '715',
				battery: '85.4kWh',
				power: '180kW',
				acceleration: '3.9秒',
				maxSpeed: '185km/h',
				statusText: '在售',
				statusType: 'active',
				totalSales: '1,286',
				monthSales: '56',
				avgRating: '4.8',
				reviewCount: '328',
				description: '比亚迪汉EV是一款集豪华、科技与性能于一身的中大型纯电轿车。搭载刀片电池，续航里程达715km，百公里加速仅需3.9秒。配备DiPilot智能驾驶辅助系统，让出行更加安全便捷。'
			}
		}
	},
	onLoad(options) {
		if (options.vehicleId) {
			console.log('车辆ID:', options.vehicleId)
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
		goEdit() { uni.navigateTo({ url: '/pages/mine/vehicle/vehicle-desc-edit?vehicleId=' + this.vehicle.id }) }
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
.edit-text { font-size: 28rpx; color: #f59e0b; font-weight: 600; }

.vehicle-hero { position: relative; margin: 0 24rpx 20rpx; height: 280rpx; border-radius: 24rpx; overflow: hidden; display: flex; align-items: center; justify-content: center; }
.hero-bg { position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: linear-gradient(135deg, #fef3c7, #fde68a, #fcd34d); }
.hero-icon { font-size: 100rpx; position: relative; z-index: 1; }
.hero-badge { position: absolute; top: 20rpx; right: 20rpx; font-size: 22rpx; padding: 6rpx 16rpx; border-radius: 16rpx; z-index: 1; }
.badge-active { background: #dcfce7; color: #16a34a; }
.badge-sold { background: #fee2e2; color: #dc2626; }

.info-section { margin: 0 24rpx 20rpx; }
.section-title { display: flex; align-items: center; margin-bottom: 16rpx; }
.title-line { width: 6rpx; height: 32rpx; border-radius: 3rpx; background: linear-gradient(180deg, #f59e0b, #f97316); margin-right: 12rpx; }
.line-green { background: linear-gradient(180deg, #22c55e, #16a34a); }
.line-blue { background: linear-gradient(180deg, #3b82f6, #2563eb); }
.line-purple { background: linear-gradient(180deg, #a855f7, #9333ea); }
.title-text { font-size: 30rpx; font-weight: 700; color: #1c1917; }

.info-card { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 8rpx 0; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.info-row { display: flex; justify-content: space-between; align-items: center; padding: 20rpx 24rpx; border-bottom: 1rpx solid #f5f5f4; }
.info-row:last-child { border-bottom: none; }
.info-label { font-size: 26rpx; color: #78716c; }
.info-value { font-size: 26rpx; color: #1c1917; font-weight: 500; }
.info-value.highlight { color: #f59e0b; font-weight: 700; font-size: 30rpx; }

.data-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12rpx; }
.data-item { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 16rpx; padding: 24rpx 12rpx; text-align: center; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.data-val { font-size: 32rpx; font-weight: 700; color: #1c1917; display: block; }
.data-label { font-size: 20rpx; color: #a8a29e; margin-top: 4rpx; display: block; }

.desc-card { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 24rpx; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.desc-text { font-size: 26rpx; color: #57534e; line-height: 1.8; }
</style>