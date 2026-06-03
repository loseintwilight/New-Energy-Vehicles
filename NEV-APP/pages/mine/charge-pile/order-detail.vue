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
					<text class="header-title">订单详情</text>
					<text class="header-sub">订单号：{{ order.orderNo }}</text>
				</view>
			</view>

			<!-- 状态卡片 -->
			<view class="status-card">
				<view class="status-icon-wrap">
					<text class="status-icon">{{ order.statusIcon }}</text>
				</view>
				<text class="status-text">{{ order.status }}</text>
				<text class="status-amount">¥{{ order.amount }}</text>
			</view>

			<!-- 充电信息 -->
			<view class="info-section">
				<view class="section-title">
					<view class="title-line"></view>
					<text class="title-text">充电信息</text>
				</view>
				<view class="info-card">
					<view class="info-row">
						<text class="info-label">充电站点</text>
						<text class="info-value">{{ order.station }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">充电桩号</text>
						<text class="info-value">{{ order.pileNo }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">开始时间</text>
						<text class="info-value">{{ order.startTime }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">结束时间</text>
						<text class="info-value">{{ order.endTime }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">充电时长</text>
						<text class="info-value">{{ order.duration }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">充电电量</text>
						<text class="info-value highlight">{{ order.energy }} kWh</text>
					</view>
				</view>
			</view>

			<!-- 费用明细 -->
			<view class="info-section">
				<view class="section-title">
					<view class="title-line line-green"></view>
					<text class="title-text">费用明细</text>
				</view>
				<view class="info-card">
					<view class="info-row">
						<text class="info-label">电费单价</text>
						<text class="info-value">¥{{ order.unitPrice }}/kWh</text>
					</view>
					<view class="info-row">
						<text class="info-label">电费金额</text>
						<text class="info-value">¥{{ order.energyFee }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">服务费</text>
						<text class="info-value">¥{{ order.serviceFee }}</text>
					</view>
					<view class="info-row total-row">
						<text class="info-label">合计</text>
						<text class="info-value total-amount">¥{{ order.amount }}</text>
					</view>
				</view>
			</view>

			<!-- 用户信息 -->
			<view class="info-section">
				<view class="section-title">
					<view class="title-line line-blue"></view>
					<text class="title-text">用户信息</text>
				</view>
				<view class="info-card">
					<view class="info-row">
						<text class="info-label">用户姓名</text>
						<text class="info-value">{{ order.userName }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">联系电话</text>
						<text class="info-value">{{ order.userPhone }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">车辆型号</text>
						<text class="info-value">{{ order.carModel }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">车牌号</text>
						<text class="info-value">{{ order.plateNo }}</text>
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
			order: {
				orderNo: 'CP202606031032001',
				status: '已完成',
				statusIcon: '✅',
				amount: '45.80',
				station: '济南高新区充电站',
				pileNo: '1号快充桩 (120kW)',
				startTime: '2026-06-03 10:32:15',
				endTime: '2026-06-03 11:02:15',
				duration: '30分钟',
				energy: '28.6',
				unitPrice: '1.20',
				energyFee: '34.32',
				serviceFee: '11.48',
				userName: '张先生',
				userPhone: '138****6789',
				carModel: '比亚迪 汉EV',
				plateNo: '鲁A·12345'
			}
		}
	},
	onLoad(options) {
		if (options.orderId) {
			console.log('订单ID:', options.orderId)
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
		goBack() { uni.navigateBack() }
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

/* 状态卡片 */
.status-card { margin: 0 24rpx 20rpx; background: linear-gradient(135deg, #fef3c7, #fde68a); border-radius: 24rpx; padding: 36rpx; text-align: center; box-shadow: 0 8rpx 24rpx rgba(245,158,11,0.15); }
.status-icon-wrap { margin-bottom: 12rpx; }
.status-icon { font-size: 56rpx; }
.status-text { font-size: 28rpx; font-weight: 600; color: #92400e; display: block; }
.status-amount { font-size: 52rpx; font-weight: 800; color: #451a03; margin-top: 12rpx; display: block; }

/* 信息区块 */
.info-section { margin: 0 24rpx 20rpx; }
.section-title { display: flex; align-items: center; margin-bottom: 16rpx; }
.title-line { width: 6rpx; height: 28rpx; border-radius: 3rpx; background: linear-gradient(180deg, #f59e0b, #f97316); margin-right: 12rpx; }
.title-line.line-green { background: linear-gradient(180deg, #22c55e, #16a34a); }
.title-line.line-blue { background: linear-gradient(180deg, #3b82f6, #2563eb); }
.title-text { font-size: 28rpx; font-weight: 700; color: #1c1917; }
.info-card { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 8rpx 0; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.info-row { display: flex; justify-content: space-between; align-items: center; padding: 20rpx 24rpx; border-bottom: 1rpx solid #f5f5f4; }
.info-row:last-child { border-bottom: none; }
.info-label { font-size: 26rpx; color: #78716c; }
.info-value { font-size: 26rpx; color: #1c1917; font-weight: 500; }
.info-value.highlight { color: #f59e0b; font-weight: 700; }
.total-row { background: #fffbeb; border-radius: 0 0 20rpx 20rpx; }
.total-amount { font-size: 32rpx; font-weight: 800; color: #f59e0b !important; }
</style>