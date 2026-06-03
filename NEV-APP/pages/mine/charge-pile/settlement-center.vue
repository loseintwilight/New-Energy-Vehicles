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
					<text class="header-title">结算中心</text>
					<text class="header-sub">管理您的收益与提现</text>
				</view>
				<view class="header-right" @tap="goRecord">
					<text class="record-icon">📋</text>
				</view>
			</view>

			<!-- 余额卡片 -->
			<view class="balance-card">
				<view class="balance-bg"></view>
				<text class="balance-label">可提现余额</text>
				<text class="balance-amount">¥12,680.50</text>
				<view class="balance-row">
					<view class="balance-item">
						<text class="balance-item-val">¥8,920.00</text>
						<text class="balance-item-label">本月收入</text>
					</view>
					<view class="balance-divider"></view>
					<view class="balance-item">
						<text class="balance-item-val">¥2,350.00</text>
						<text class="balance-item-label">已提现</text>
					</view>
				</view>
				<view class="withdraw-btn" hover-class="btn-hover" @tap="goWithdraw">
					<text>立即提现</text>
				</view>
			</view>

			<!-- 收入概览 -->
			<view class="info-section">
				<view class="section-title">
					<view class="title-line"></view>
					<text class="title-text">收入概览</text>
				</view>
				<view class="income-grid">
					<view class="income-item">
						<text class="income-val">¥1,280.00</text>
						<text class="income-label">今日收入</text>
						<text class="income-trend up">▲ 12.5%</text>
					</view>
					<view class="income-item">
						<text class="income-val">¥8,960.00</text>
						<text class="income-label">本周收入</text>
						<text class="income-trend up">▲ 15.8%</text>
					</view>
					<view class="income-item">
						<text class="income-val">¥46,690.70</text>
						<text class="income-label">本月收入</text>
						<text class="income-trend up">▲ 22.4%</text>
					</view>
					<view class="income-item">
						<text class="income-val">¥186,520.00</text>
						<text class="income-label">累计收入</text>
						<text class="income-trend up">▲ 18.6%</text>
					</view>
				</view>
			</view>

			<!-- 提现记录 -->
			<view class="info-section">
				<view class="section-title">
					<view class="title-line line-green"></view>
					<text class="title-text">提现记录</text>
					<view class="bar-more" @tap="goRecord">
						<text class="bar-more-text">全部</text>
						<text class="bar-more-icon">❯</text>
					</view>
				</view>
				<view class="record-list">
					<view class="record-item" v-for="(item, idx) in withdrawRecords" :key="idx">
						<view class="record-left">
							<text class="record-title">{{ item.title }}</text>
							<text class="record-time">{{ item.time }}</text>
						</view>
						<view class="record-right">
							<text class="record-amount">-¥{{ item.amount }}</text>
							<text class="record-status" :class="'status-' + item.statusType">{{ item.status }}</text>
						</view>
					</view>
				</view>
			</view>

			<!-- 结算规则 -->
			<view class="info-section">
				<view class="section-title">
					<view class="title-line line-blue"></view>
					<text class="title-text">结算规则</text>
				</view>
				<view class="rule-card">
					<view class="rule-row">
						<text class="rule-label">结算周期</text>
						<text class="rule-value">T+1 自动结算</text>
					</view>
					<view class="rule-row">
						<text class="rule-label">手续费率</text>
						<text class="rule-value">0.6%</text>
					</view>
					<view class="rule-row">
						<text class="rule-label">最低提现</text>
						<text class="rule-value">¥100.00</text>
					</view>
					<view class="rule-row">
						<text class="rule-label">到账时间</text>
						<text class="rule-value">1-3个工作日</text>
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
			withdrawRecords: [
				{ title: '提现至银行卡(6222****1234)', time: '2026-06-01 14:30', amount: '2,000.00', status: '已到账', statusType: 'done' },
				{ title: '提现至银行卡(6222****1234)', time: '2026-05-25 10:15', amount: '3,500.00', status: '已到账', statusType: 'done' },
				{ title: '提现至银行卡(6222****1234)', time: '2026-05-18 16:45', amount: '1,500.00', status: '处理中', statusType: 'pending' }
			]
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
		goRecord() { uni.showToast({ title: '提现记录', icon: 'none', duration: 1500 }) },
		goWithdraw() {
			uni.showModal({
				title: '提现确认',
				content: '确认提现至绑定的银行卡？',
				success: function(res) {
					if (res.confirm) {
						uni.showToast({ title: '提现申请已提交', icon: 'success' })
					}
				}
			})
		}
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
.record-icon { font-size: 32rpx; padding: 12rpx; }

/* 余额卡片 */
.balance-card { margin: 0 24rpx 20rpx; background: linear-gradient(135deg, #f59e0b, #f97316); border-radius: 24rpx; padding: 36rpx; position: relative; overflow: hidden; box-shadow: 0 8rpx 24rpx rgba(245,158,11,0.3); }
.balance-bg { position: absolute; top: -40rpx; right: -40rpx; width: 200rpx; height: 200rpx; border-radius: 100rpx; background: rgba(255,255,255,0.1); }
.balance-label { font-size: 24rpx; color: rgba(255,255,255,0.8); display: block; }
.balance-amount { font-size: 56rpx; font-weight: 800; color: #fff; margin-top: 8rpx; display: block; }
.balance-row { display: flex; align-items: center; margin-top: 24rpx; padding-top: 24rpx; border-top: 1rpx solid rgba(255,255,255,0.2); }
.balance-item { flex: 1; }
.balance-item-val { font-size: 28rpx; font-weight: 700; color: #fff; display: block; }
.balance-item-label { font-size: 20rpx; color: rgba(255,255,255,0.7); margin-top: 4rpx; display: block; }
.balance-divider { width: 2rpx; height: 40rpx; background: rgba(255,255,255,0.2); }
.withdraw-btn { margin-top: 24rpx; background: #fff; border-radius: 16rpx; padding: 20rpx; text-align: center; font-size: 28rpx; font-weight: 700; color: #f59e0b; }

/* 收入概览 */
.info-section { margin: 0 24rpx 20rpx; }
.section-title { display: flex; align-items: center; margin-bottom: 16rpx; }
.title-line { width: 6rpx; height: 28rpx; border-radius: 3rpx; background: linear-gradient(180deg, #f59e0b, #f97316); margin-right: 12rpx; }
.title-line.line-green { background: linear-gradient(180deg, #22c55e, #16a34a); }
.title-line.line-blue { background: linear-gradient(180deg, #3b82f6, #2563eb); }
.title-text { font-size: 28rpx; font-weight: 700; color: #1c1917; flex: 1; }
.bar-more { display: flex; align-items: center; }
.bar-more-text { font-size: 24rpx; color: #a16207; }
.bar-more-icon { font-size: 20rpx; color: #a16207; margin-left: 4rpx; }
.income-grid { display: flex; flex-wrap: wrap; gap: 16rpx; }
.income-item { width: calc(50% - 8rpx); background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 16rpx; padding: 24rpx; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.income-val { font-size: 32rpx; font-weight: 700; color: #f59e0b; display: block; }
.income-label { font-size: 22rpx; color: #78716c; margin-top: 4rpx; display: block; }
.income-trend { font-size: 20rpx; margin-top: 6rpx; display: block; }
.income-trend.up { color: #22c55e; }

/* 提现记录 */
.record-list { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; overflow: hidden; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.record-item { display: flex; justify-content: space-between; align-items: center; padding: 24rpx; border-bottom: 1rpx solid #f5f5f4; }
.record-item:last-child { border-bottom: none; }
.record-left { flex: 1; }
.record-title { font-size: 26rpx; color: #1c1917; display: block; }
.record-time { font-size: 22rpx; color: #a8a29e; margin-top: 4rpx; display: block; }
.record-right { text-align: right; }
.record-amount { font-size: 28rpx; font-weight: 700; color: #dc2626; display: block; }
.record-status { font-size: 22rpx; padding: 4rpx 12rpx; border-radius: 12rpx; margin-top: 4rpx; display: inline-block; }
.status-done { background: #dcfce7; color: #16a34a; }
.status-pending { background: #fef3c7; color: #b45309; }

/* 结算规则 */
.rule-card { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; overflow: hidden; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.rule-row { display: flex; justify-content: space-between; align-items: center; padding: 20rpx 24rpx; border-bottom: 1rpx solid #f5f5f4; }
.rule-row:last-child { border-bottom: none; }
.rule-label { font-size: 26rpx; color: #78716c; }
.rule-value { font-size: 26rpx; color: #1c1917; font-weight: 500; }
</style>