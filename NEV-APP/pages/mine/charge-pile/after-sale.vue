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
					<text class="header-title">售后管理</text>
					<text class="header-sub">共 {{ ticketList.length }} 个工单</text>
				</view>
			</view>

			<!-- 统计 -->
			<view class="stats-bar">
				<view class="stats-item" :class="{ active: activeTab === 'all' }" @tap="switchTab('all')">
					<text class="stats-num">{{ ticketList.length }}</text>
					<text class="stats-label">全部</text>
				</view>
				<view class="stats-item" :class="{ active: activeTab === 'pending' }" @tap="switchTab('pending')">
					<text class="stats-num num-orange">{{ pendingCount }}</text>
					<text class="stats-label">待处理</text>
				</view>
				<view class="stats-item" :class="{ active: activeTab === 'processing' }" @tap="switchTab('processing')">
					<text class="stats-num num-blue">{{ processingCount }}</text>
					<text class="stats-label">处理中</text>
				</view>
				<view class="stats-item" :class="{ active: activeTab === 'done' }" @tap="switchTab('done')">
					<text class="stats-num num-green">{{ doneCount }}</text>
					<text class="stats-label">已完成</text>
				</view>
			</view>

			<view class="ticket-list">
				<view class="ticket-card" v-for="(item, idx) in filteredTickets" :key="idx" hover-class="card-hover" @tap="goDetail(item.id)">
					<view class="ticket-top">
						<text class="ticket-title">{{ item.title }}</text>
						<text class="ticket-status" :class="'status-' + item.statusType">{{ item.status }}</text>
					</view>
					<text class="ticket-desc">{{ item.desc }}</text>
					<view class="ticket-bottom">
						<view class="ticket-user">
							<view class="ticket-avatar">{{ item.userName.charAt(0) }}</view>
							<text class="ticket-name">{{ item.userName }}</text>
						</view>
						<text class="ticket-time">{{ item.time }}</text>
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
			activeTab: 'all',
			ticketList: [
				{ id: 1, title: '充电桩无法启动', desc: '1号快充桩扫码后无法启动充电，屏幕显示异常', userName: '张先生', time: '2026-06-03 10:30', status: '待处理', statusType: 'pending' },
				{ id: 2, title: '充电速度过慢', desc: '3号超充桩实际充电功率只有60kW，远低于标称240kW', userName: '李女士', time: '2026-06-03 09:15', status: '处理中', statusType: 'processing' },
				{ id: 3, title: '费用异常', desc: '充电完成后扣费金额与显示金额不一致，多扣了15元', userName: '王先生', time: '2026-06-02 18:45', status: '已完成', statusType: 'done' },
				{ id: 4, title: '充电枪无法拔出', desc: '充电完成后充电枪卡住无法拔出，需要现场处理', userName: '赵女士', time: '2026-06-02 16:20', status: '处理中', statusType: 'processing' },
				{ id: 5, title: 'APP显示异常', desc: 'APP上显示充电桩状态与实际不符，显示离线但实际在线', userName: '孙先生', time: '2026-06-02 14:10', status: '已完成', statusType: 'done' }
			]
		}
	},
	computed: {
		pendingCount() { return this.ticketList.filter(function(t) { return t.statusType === 'pending' }).length },
		processingCount() { return this.ticketList.filter(function(t) { return t.statusType === 'processing' }).length },
		doneCount() { return this.ticketList.filter(function(t) { return t.statusType === 'done' }).length },
		filteredTickets() {
			var self = this
			if (self.activeTab === 'all') return self.ticketList
			return self.ticketList.filter(function(t) { return t.statusType === self.activeTab })
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
		switchTab(tab) { this.activeTab = tab },
		goDetail(id) { uni.showToast({ title: '工单详情 ID:' + id, icon: 'none', duration: 1500 }) }
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

/* 统计 */
.stats-bar { margin: 0 24rpx 20rpx; display: flex; gap: 16rpx; }
.stats-item { flex: 1; background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 16rpx; padding: 20rpx 12rpx; text-align: center; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); transition: all 0.3s; }
.stats-item.active { background: #fff; box-shadow: 0 4rpx 20rpx rgba(245,158,11,0.2); border: 2rpx solid #f59e0b; }
.stats-num { font-size: 32rpx; font-weight: 700; color: #1c1917; display: block; }
.num-orange { color: #f59e0b; }
.num-blue { color: #3b82f6; }
.num-green { color: #22c55e; }
.stats-label { font-size: 22rpx; color: #78716c; margin-top: 4rpx; display: block; }

/* 工单 */
.ticket-list { padding: 0 24rpx; }
.ticket-card { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 24rpx; margin-bottom: 16rpx; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.card-hover { transform: scale(0.98); opacity: 0.9; }
.ticket-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12rpx; }
.ticket-title { font-size: 28rpx; font-weight: 600; color: #1c1917; }
.ticket-status { font-size: 22rpx; padding: 4rpx 16rpx; border-radius: 16rpx; }
.status-pending { background: #fef3c7; color: #b45309; }
.status-processing { background: #dbeafe; color: #2563eb; }
.status-done { background: #dcfce7; color: #16a34a; }
.ticket-desc { font-size: 24rpx; color: #78716c; line-height: 1.5; display: block; margin-bottom: 16rpx; }
.ticket-bottom { display: flex; justify-content: space-between; align-items: center; padding-top: 16rpx; border-top: 1rpx solid #f5f5f4; }
.ticket-user { display: flex; align-items: center; }
.ticket-avatar { width: 40rpx; height: 40rpx; border-radius: 20rpx; background: linear-gradient(135deg, #fef3c7, #fde68a); display: flex; align-items: center; justify-content: center; font-size: 20rpx; font-weight: 600; color: #92400e; margin-right: 10rpx; }
.ticket-name { font-size: 24rpx; color: #57534e; }
.ticket-time { font-size: 22rpx; color: #a8a29e; }
</style>