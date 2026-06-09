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
				<text class="back-icon">‹</text>
			</view>
			<view class="header-info">
					<text class="header-title">结算中心</text>
					<text class="header-sub">{{ settlementList.length }} 条结算单</text>
				</view>
				<view class="header-right" @tap="goRecord">
					<text class="record-icon">📋</text>
				</view>
			</view>

			<!-- 余额卡片 -->
			<view class="balance-card">
				<view class="balance-bg"></view>
				<text class="balance-label">可提现余额（待结算总额）</text>
				<text class="balance-amount">¥{{ summary.totalAmount }}</text>
				<view class="balance-row">
					<view class="balance-item">
						<text class="balance-item-val">¥{{ summary.settleAmount }}</text>
						<text class="balance-item-label">已结算金额</text>
					</view>
					<view class="balance-divider"></view>
					<view class="balance-item">
						<text class="balance-item-val">¥{{ summary.withdrawAmount }}</text>
						<text class="balance-item-label">已提现金额</text>
					</view>
				</view>
				<view class="withdraw-btn" hover-class="btn-hover" @tap="goWithdraw">
					<text>查看详情</text>
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
						<text class="income-val">¥{{ summary.totalAmount }}</text>
						<text class="income-label">总金额</text>
					</view>
					<view class="income-item">
						<text class="income-val">¥{{ summary.platformCommission }}</text>
						<text class="income-label">平台佣金</text>
					</view>
					<view class="income-item">
						<text class="income-val">¥{{ summary.settleAmount }}</text>
						<text class="income-label">结算到账</text>
					</view>
					<view class="income-item">
						<text class="income-val">{{ summary.totalOrders }}</text>
						<text class="income-label">总订单数</text>
					</view>
				</view>
			</view>

			<!-- 结算列表 -->
			<view class="info-section">
				<view class="section-title">
					<view class="title-line line-green"></view>
					<text class="title-text">结算明细</text>
					<view class="bar-more" @tap="goRecord">
						<text class="bar-more-text">全部</text>
						<text class="bar-more-icon">›</text>
					</view>
				</view>
				<view class="record-list" v-if="settlementList.length > 0">
					<view
						class="record-item"
						v-for="(item, idx) in settlementList"
						:key="item.settlementId"
						@tap="goDetail(item.settlementId)"
					>
						<view class="record-left">
							<text class="record-title">{{ item.settleDate || '--' }} 结算单</text>
							<text class="record-time">订单数: {{ item.totalOrders || 0 }} · 充电量: {{ fmtEnergy(item.totalEnergy) }}</text>
							<text class="record-time" v-if="item.settleTime">{{ item.settleTime }}</text>
						</view>
						<view class="record-right">
							<text class="record-amount">¥{{ fmtAmt(item.settleAmount) }}</text>
							<text class="record-status" :class="'status-' + (item.status === '1' ? 'done' : 'pending')">{{ item.status === '1' ? '已结算' : '待结算' }}</text>
						</view>
					</view>
				</view>
				<view v-else class="empty-hint">
					<text>暂无结算数据</text>
				</view>
			</view>

			<view style="height: 120rpx;"></view>
		</scroll-view>
	</view>
</template>

<script>
import { getSettlementList, exportSettlement } from '@/api/charger/settlement'

export default {
	data() {
		var rows = []
		var colors = ['#f59e0b', '#f97316', '#fb923c', '#fbbf24', '#fcd34d', '#fde68a']
		for (var r = 0; r < 7; r++) {
			var dots = []
			var count = 4 + Math.floor(Math.random() * 3)
			for (var c = 0; c < count; c++) {
				var color = colors[Math.floor(Math.random() * colors.length)]
				var size = 60 + Math.floor(Math.random() * 70)
				var dur = 2.5 + Math.random() * 2.5
				var delay = Math.random() * 2.5
				var alpha = 0.08 + Math.random() * 0.18
				dots.push({
					style: 'width:' + size + 'rpx;height:' + size + 'rpx;background:radial-gradient(circle,' + color + ',' + color + '00);opacity:' + alpha.toFixed(2) + ';animation-duration:' + dur.toFixed(1) + 's;animation-delay:' + delay.toFixed(1) + 's;'
				})
			}
			rows.push({ dots: dots })
		}
		return {
			isReady: false,
			glowRows: rows,
			settlementList: [],
			summary: {
				totalAmount: '0.00',
				settleAmount: '0.00',
				withdrawAmount: '0.00',
				platformCommission: '0.00',
				totalOrders: 0
			}
		}
	},
	created() {
		this.loadSettlements()
		var self = this
		setTimeout(function() { self.isReady = true }, 200)
	},
	methods: {
		goBack() { uni.navigateBack({ delta: 1 }) },
		loadSettlements() {
			var self = this
			getSettlementList({ pageSize: 100 }).then(function(res) {
				if (res.code === 200 && res.rows) {
					self.settlementList = res.rows || []
					self.calcSummary()
				}
			}).catch(function() {})
		},
		calcSummary() {
			var list = this.settlementList
			var totalAmt = 0, settleAmt = 0, withdrawAmt = 0, commission = 0, totalOrd = 0
			for (var i = 0; i < list.length; i++) {
				totalAmt += Number(list[i].totalAmount) || 0
				settleAmt += Number(list[i].settleAmount) || 0
				withdrawAmt += Number(list[i].withdrawAmount) || 0
				commission += Number(list[i].platformCommission) || 0
				totalOrd += Number(list[i].totalOrders) || 0
			}
			this.summary = {
				totalAmount: totalAmt.toFixed(2),
				settleAmount: settleAmt.toFixed(2),
				withdrawAmount: withdrawAmt.toFixed(2),
				platformCommission: commission.toFixed(2),
				totalOrders: totalOrd
			}
		},
		goDetail(settlementId) {
			uni.navigateTo({ url: '/pages/mine/charge-pile/charge-review-detail?settlementId=' + settlementId })
		},
		goRecord() {
			uni.navigateTo({ url: '/pages/mine/charge-pile/charge-review-list' })
		},
		goWithdraw() {
			this.goRecord()
		},
		fmtAmt(val) {
			if (val === undefined || val === null) return '0.00'
			return Number(val).toFixed(2)
		},
		fmtEnergy(val) {
			if (!val) return '0'
			return Number(val).toFixed(1) + 'kWh'
		}
	}
}
</script>

<style scoped>
.page { min-height: 100vh; background: linear-gradient(180deg, #fff7ed 0%, #fffbeb 30%, #fefce8 60%, #fff7ed 100%); opacity: 0; transition: opacity 0.5s ease; }
.page-ready { opacity: 1; }
.glow-matrix { position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 0; overflow: hidden; pointer-events: none; }
.glow-row { display: flex; justify-content: space-around; padding: 24rpx 20rpx; }
.glow-spot { border-radius: 50%; flex-shrink: 0; animation: glowPulse ease-in-out infinite alternate; }
@keyframes glowPulse { 0% { opacity: 0.15; transform: scale(0.85); } 50% { opacity: 0.6; } 100% { opacity: 0.15; transform: scale(1.25); } }
.overlay-mask { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: linear-gradient(180deg, rgba(255,247,237,0.92) 0%, rgba(255,251,235,0.95) 35%, rgba(254,252,232,0.96) 65%, rgba(255,251,235,0.97) 100%); pointer-events: none; z-index: 1; }
.main-scroll { position: relative; z-index: 2; height: 100vh; }

.header { position: relative; padding: 28rpx 28rpx 24rpx; display: flex; align-items: center; overflow: visible; }
.header-bg { position: absolute; top: -120rpx; left: -40rpx; right: -40rpx; bottom: -40rpx; background: linear-gradient(135deg, #f59e0b 0%, #f97316 35%, #fb923c 65%, #dba74 100%); border-radius: 0 0 60rpx 60rpx; }
.back-btn { width: 64rpx; height: 64rpx; border-radius: 50%; background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); display: flex; align-items: center; justify-content: center; z-index: 2; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06); }
.btn-hover { transform: scale(0.9); opacity: 0.7; }
.back-icon { font-size: 32rpx; color: #f97306; font-weight: bold; }
.header-info { flex: 1; margin-left: 20rpx; z-index: 2; display: flex; flex-direction: column; }
.header-title { font-size: 38rpx; font-weight: 800; color: #451a03; letter-spacing: 1rpx; }
.header-sub { font-size: 24rpx; color: #a16207; margin-top: 6rpx; font-weight: 500; }
.header-right { z-index: 2; }
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
.income-val { font-size: 32rpx; font-weight: 700; color: #f59e0b; display: block; word-break: break-all; }
.income-label { font-size: 22rpx; color: #78716c; margin-top: 4rpx; display: block; }

/* 结算明细 */
.record-list { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; overflow: hidden; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.record-item { display: flex; justify-content: space-between; align-items: center; padding: 24rpx; border-bottom: 1rpx solid #f5f5f4; }
.record-item:last-child { border-bottom: none; }
.record-left { flex: 1; min-width: 0; }
.record-title { font-size: 26rpx; color: #1c1917; display: block; font-weight: 600; }
.record-time { font-size: 22rpx; color: #a8a29e; margin-top: 4rpx; display: block; }
.record-right { text-align: right; flex-shrink: 0; margin-left: 12rpx; }
.record-amount { font-size: 28rpx; font-weight: 700; color: #d97706; display: block; }
.record-status { font-size: 22rpx; padding: 4rpx 12rpx; border-radius: 12rpx; margin-top: 4rpx; display: inline-block; }
.status-done { background: #dcfce7; color: #16a34a; }
.status-pending { background: #fef3c7; color: #b45309; }

.empty-hint { background: rgba(255,255,255,0.85); border-radius: 20rpx; padding: 60rpx 0; text-align: center; font-size: 26rpx; color: #a8a29e; }
</style>
