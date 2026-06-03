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
					<text class="header-title">充电桩详情</text>
					<text class="header-sub">{{ pile.name }}</text>
				</view>
				<view class="header-right" @tap="showActions">
					<text class="action-icon">⋯</text>
				</view>
			</view>

			<!-- 状态卡片 -->
			<view class="status-card" :class="'card-' + pile.status">
				<view class="status-badge" :class="'badge-' + pile.status">
					<view class="dot"></view>
					<text>{{ pile.statusText }}</text>
				</view>
				<text class="pile-name-big">{{ pile.name }}</text>
				<text class="pile-station-big">{{ pile.station }}</text>
				<view class="status-metrics">
					<view class="metric">
						<text class="metric-val">{{ pile.power }}</text>
						<text class="metric-label">额定功率</text>
					</view>
					<view class="metric">
						<text class="metric-val">{{ pile.utilization }}</text>
						<text class="metric-label">利用率</text>
					</view>
					<view class="metric">
						<text class="metric-val">{{ pile.temp }}°C</text>
						<text class="metric-label">温度</text>
					</view>
				</view>
			</view>

			<!-- 今日数据 -->
			<view class="info-section">
				<view class="section-title">
					<view class="title-line"></view>
					<text class="title-text">今日数据</text>
				</view>
				<view class="data-grid">
					<view class="data-item">
						<text class="data-val">{{ pile.todayEnergy }}</text>
						<text class="data-label">充电量(kWh)</text>
					</view>
					<view class="data-item">
						<text class="data-val">¥{{ pile.todayIncome }}</text>
						<text class="data-label">营收</text>
					</view>
					<view class="data-item">
						<text class="data-val">{{ pile.todayOrders }}</text>
						<text class="data-label">服务次数</text>
					</view>
					<view class="data-item">
						<text class="data-val">{{ pile.avgDuration }}</text>
						<text class="data-label">平均时长</text>
					</view>
				</view>
			</view>

			<!-- 基本信息 -->
			<view class="info-section">
				<view class="section-title">
					<view class="title-line line-green"></view>
					<text class="title-text">基本信息</text>
				</view>
				<view class="info-card">
					<view class="info-row">
						<text class="info-label">充电桩编号</text>
						<text class="info-value">{{ pile.code }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">所属站点</text>
						<text class="info-value">{{ pile.station }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">充电类型</text>
						<text class="info-value">{{ pile.type }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">接口标准</text>
						<text class="info-value">{{ pile.standard }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">输出电压</text>
						<text class="info-value">{{ pile.voltage }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">安装日期</text>
						<text class="info-value">{{ pile.installDate }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">最后维护</text>
						<text class="info-value">{{ pile.lastMaintain }}</text>
					</view>
				</view>
			</view>

			<!-- 操作按钮 -->
			<view class="action-btns">
				<view class="action-btn btn-warn" hover-class="btn-hover" @tap="restartPile">
					<text>重启设备</text>
				</view>
				<view class="action-btn btn-primary" hover-class="btn-hover" @tap="editPile">
					<text>编辑信息</text>
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
			pile: {
				id: 1,
				name: '1号快充桩',
				code: 'CP-HN-GX-001',
				station: '济南高新区充电站',
				status: 'online',
				statusText: '在线',
				power: '120kW',
				type: '直流快充',
				standard: 'GB/T 20234.3',
				voltage: '200-750V',
				utilization: '72%',
				temp: '38',
				todayEnergy: '156.8',
				todayIncome: '250.88',
				todayOrders: '12',
				avgDuration: '28min',
				installDate: '2025-08-15',
				lastMaintain: '2026-05-20'
			}
		}
	},
	onLoad(options) {
		if (options.pileId) {
			console.log('充电桩ID:', options.pileId)
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
		showActions() {
			uni.showActionSheet({
				itemList: ['重启设备', '强制下线', '查看日志', '删除设备'],
				success: function(res) {
					console.log('选择:', res.tapIndex)
				}
			})
		},
		restartPile() {
			uni.showModal({
				title: '确认重启',
				content: '确定要重启该充电桩吗？',
				success: function(res) {
					if (res.confirm) {
						uni.showToast({ title: '重启指令已发送', icon: 'success' })
					}
				}
			})
		},
		editPile() { uni.navigateTo({ url: '/pages/mine/charge-pile/pile-add?pileId=' + this.pile.id }) }
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
.action-icon { font-size: 36rpx; color: #92400e; padding: 12rpx; }

/* 状态卡片 */
.status-card { margin: 0 24rpx 20rpx; border-radius: 24rpx; padding: 32rpx; text-align: center; box-shadow: 0 8rpx 24rpx rgba(0,0,0,0.08); }
.card-online { background: linear-gradient(135deg, #dcfce7, #bbf7d0); }
.card-charging { background: linear-gradient(135deg, #fef3c7, #fde68a); }
.card-offline { background: linear-gradient(135deg, #fee2e2, #fecaca); }
.status-badge { display: inline-flex; align-items: center; padding: 8rpx 20rpx; border-radius: 20rpx; font-size: 22rpx; margin-bottom: 16rpx; }
.badge-online { background: rgba(22,163,74,0.15); color: #16a34a; }
.badge-charging { background: rgba(245,158,11,0.15); color: #b45309; }
.badge-offline { background: rgba(220,38,38,0.15); color: #dc2626; }
.dot { width: 10rpx; height: 10rpx; border-radius: 5rpx; margin-right: 8rpx; }
.badge-online .dot { background: #22c55e; }
.badge-charging .dot { background: #f59e0b; animation: dotPulse 1.5s ease-in-out infinite; }
.badge-offline .dot { background: #ef4444; }
@keyframes dotPulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.3; } }
.pile-name-big { font-size: 40rpx; font-weight: 700; color: #1c1917; display: block; }
.pile-station-big { font-size: 24rpx; color: #78716c; margin-top: 8rpx; display: block; }
.status-metrics { display: flex; justify-content: space-around; margin-top: 24rpx; padding-top: 24rpx; border-top: 1rpx solid rgba(0,0,0,0.06); }
.metric { text-align: center; }
.metric-val { font-size: 32rpx; font-weight: 700; color: #1c1917; display: block; }
.metric-label { font-size: 20rpx; color: #78716c; margin-top: 4rpx; display: block; }

/* 数据网格 */
.info-section { margin: 0 24rpx 20rpx; }
.section-title { display: flex; align-items: center; margin-bottom: 16rpx; }
.title-line { width: 6rpx; height: 28rpx; border-radius: 3rpx; background: linear-gradient(180deg, #f59e0b, #f97316); margin-right: 12rpx; }
.title-line.line-green { background: linear-gradient(180deg, #22c55e, #16a34a); }
.title-text { font-size: 28rpx; font-weight: 700; color: #1c1917; }
.data-grid { display: flex; gap: 16rpx; }
.data-item { flex: 1; background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 16rpx; padding: 24rpx 16rpx; text-align: center; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.data-val { font-size: 30rpx; font-weight: 700; color: #f59e0b; display: block; }
.data-label { font-size: 20rpx; color: #78716c; margin-top: 6rpx; display: block; }

/* 信息卡片 */
.info-card { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 8rpx 0; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.info-row { display: flex; justify-content: space-between; align-items: center; padding: 20rpx 24rpx; border-bottom: 1rpx solid #f5f5f4; }
.info-row:last-child { border-bottom: none; }
.info-label { font-size: 26rpx; color: #78716c; }
.info-value { font-size: 26rpx; color: #1c1917; font-weight: 500; }

/* 操作按钮 */
.action-btns { padding: 0 24rpx; display: flex; gap: 16rpx; }
.action-btn { flex: 1; padding: 24rpx; border-radius: 20rpx; text-align: center; font-size: 28rpx; font-weight: 600; }
.btn-warn { background: rgba(239,68,68,0.1); color: #dc2626; border: 2rpx solid rgba(239,68,68,0.2); }
.btn-primary { background: linear-gradient(135deg, #f59e0b, #f97316); color: #fff; }
</style>