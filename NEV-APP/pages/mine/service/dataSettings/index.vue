<template>
	<view class="container">
		<!-- 概览卡片 -->
		<view class="summary-grid">
			<view class="summary-card">
				<view class="sc-icon sc-icon-green">
					<view class="iconfont icon-community"></view>
				</view>
				<text class="sc-num">{{ data.shopCount }}</text>
				<text class="sc-label">门店总数</text>
			</view>
			<view class="summary-card">
				<view class="sc-icon sc-icon-blue">
					<view class="iconfont icon-service"></view>
				</view>
				<text class="sc-num">{{ data.orderCount }}</text>
				<text class="sc-label">订单总数</text>
			</view>
			<view class="summary-card">
				<view class="sc-icon sc-icon-amber">
					<view class="iconfont icon-dianzan"></view>
				</view>
				<text class="sc-num">¥{{ data.revenue }}</text>
				<text class="sc-label">门店总收入</text>
			</view>
			<view class="summary-card">
				<view class="sc-icon sc-icon-purple">
					<view class="iconfont icon-aixin"></view>
				</view>
				<text class="sc-num">{{ data.avgRating }}</text>
				<text class="sc-label">平均评分</text>
			</view>
		</view>

		<!-- 订单状态分布 -->
		<view class="data-card">
			<view class="data-card-title">订单状态分布</view>
			<view class="dist-list">
				<view class="dist-item" v-for="d in statusDist" :key="d.label">
					<view class="dist-left">
						<view class="dist-dot" :style="{ background: d.color }"></view>
						<text class="dist-label">{{ d.label }}</text>
					</view>
					<view class="dist-right">
						<view class="dist-bar-bg">
							<view class="dist-bar" :style="{ width: d.pct + '%', background: d.color }"></view>
						</view>
						<text class="dist-num">{{ d.count }}</text>
					</view>
				</view>
			</view>
		</view>

		<!-- 月度趋势 -->
		<view class="data-card">
			<view class="data-card-title">月度订单趋势</view>
			<view class="chart-area">
				<view class="chart-bar" v-for="(m, i) in monthlyData" :key="i">
					<view class="bar-fill" :style="{ height: m.pct + '%' }">
						<text class="bar-val" v-if="m.count > 0">{{ m.count }}</text>
					</view>
					<text class="bar-label">{{ m.month }}</text>
				</view>
			</view>
		</view>

		<!-- 门店排行 -->
		<view class="data-card">
			<view class="data-card-title">门店评分排行</view>
			<view class="rank-list">
				<view class="rank-item" v-for="(s, i) in shopRanking" :key="s.shopId">
					<view class="rank-pos" :class="'rank-' + (i + 1)">{{ i + 1 }}</view>
					<text class="rank-name">{{ s.shopName }}</text>
					<view class="rank-stars">
						<text class="star fill" v-for="n in Math.floor(s.rating)" :key="'on' + n">★</text>
						<text class="star" v-for="n in (5 - Math.floor(s.rating))" :key="'off' + n">★</text>
						<text class="rank-rating">{{ s.rating }}</text>
					</view>
				</view>
			</view>
		</view>

		<view class="footer-note">数据更新至 {{ data.updateTime }}</view>
	</view>
</template>

<script>
	import { getDashboardStats, getStatusDist, getMonthlyTrend, getShopRanking } from '@/api/maintenance/dashboard'
	export default {
		data() {
			return {
				data: {
					shopCount: 0, orderCount: 0, revenue: '0', avgRating: '0.0', updateTime: ''
				},
				statusDist: [],
				monthlyData: [],
				shopRanking: []
			}
		},
		onLoad() { this.loadData() },
		onPullDownRefresh() { this.loadData() },
		methods: {
			loadData() {
			  getDashboardStats().then(res => {
			    this.data = res.data
			  })
			  getStatusDist().then(res => {
			    const max = Math.max(...res.data.map(d => d.count), 1)
			    this.statusDist = res.data.map(d => ({ ...d, pct: Math.round(d.count / max * 100) }))
			  })
			  getMonthlyTrend({ year: new Date().getFullYear() }).then(res => {
			    const maxM = Math.max(...res.data.map(m => m.count), 1)
			    this.monthlyData = res.data.map(m => ({ ...m, pct: Math.round(m.count / maxM * 100) }))
			  })
			  getShopRanking().then(res => {
			    this.shopRanking = res.data
			  })
			  uni.stopPullDownRefresh()
			}
		}
	}
</script>

<style lang="scss" scoped>
$green: #00c9a7;
$green-dark: #059669;
$bg: #ecfdf5;
$card: #ffffff;
$text: #0f172a;
$mute: #94a3b8;

page { background-color: $bg; }
.container { padding: 0 16px 24px; }

.summary-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 10px;
	padding: 16px 0 12px;
}

.summary-card {
	background: $card;
	border-radius: 16px;
	padding: 16px;
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 6px;
	box-shadow: 0 2px 8px rgba(5, 150, 105, 0.04);
}

.sc-icon {
	width: 40px;
	height: 40px;
	border-radius: 12px;
	display: flex;
	align-items: center;
	justify-content: center;
	.iconfont { font-size: 20px; color: #fff; }
}

.sc-icon-green { background: linear-gradient(135deg, #00c9a7, #059669); }
.sc-icon-blue { background: linear-gradient(135deg, #38bdf8, #0284c7); }
.sc-icon-amber { background: linear-gradient(135deg, #fbbf24, #f59e0b); }
.sc-icon-purple { background: linear-gradient(135deg, #a78bfa, #7c3aed); }

.sc-num {
	font-size: 22px;
	font-weight: 700;
	color: $text;
	font-family: 'Courier New', monospace;
}

.sc-label {
	font-size: 12px;
	color: $mute;
}

.data-card {
	background: $card;
	border-radius: 16px;
	padding: 16px;
	margin-bottom: 12px;
	box-shadow: 0 2px 8px rgba(5, 150, 105, 0.04);
}

.data-card-title {
	font-size: 15px;
	font-weight: 600;
	color: $text;
	padding-left: 10px;
	border-left: 3px solid $green;
	margin-bottom: 14px;
}

.dist-list {
	display: flex;
	flex-direction: column;
	gap: 10px;
}

.dist-item {
	display: flex;
	align-items: center;
	justify-content: space-between;
}

.dist-left {
	display: flex;
	align-items: center;
	gap: 8px;
	width: 70px;
}

.dist-dot {
	width: 8px;
	height: 8px;
	border-radius: 50%;
}

.dist-label {
	font-size: 13px;
	color: $text;
}

.dist-right {
	display: flex;
	align-items: center;
	gap: 10px;
	flex: 1;
}

.dist-bar-bg {
	flex: 1;
	height: 8px;
	background: #f1f5f9;
	border-radius: 4px;
	overflow: hidden;
}

.dist-bar {
	height: 100%;
	border-radius: 4px;
	transition: width 0.3s;
}

.dist-num {
	font-size: 13px;
	font-weight: 600;
	color: $text;
	width: 24px;
	text-align: right;
}

.chart-area {
	display: flex;
	align-items: flex-end;
	justify-content: space-around;
	height: 140px;
	padding: 0 4px;
}

.chart-bar {
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 6px;
	height: 100%;
	justify-content: flex-end;
}

.bar-fill {
	width: 28px;
	background: linear-gradient(to top, $green-dark, $green);
	border-radius: 6px 6px 2px 2px;
	display: flex;
	align-items: flex-start;
	justify-content: center;
	padding-top: 4px;
	transition: height 0.4s;
	min-height: 4px;
}

.bar-val {
	font-size: 10px;
	color: #fff;
	font-weight: 600;
}

.bar-label {
	font-size: 11px;
	color: $mute;
}

.rank-list {
	display: flex;
	flex-direction: column;
	gap: 10px;
}

.rank-item {
	display: flex;
	align-items: center;
	gap: 10px;
}

.rank-pos {
	width: 22px;
	height: 22px;
	border-radius: 6px;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 12px;
	font-weight: 700;
	color: #fff;
	background: #94a3b8;

	&.rank-1 { background: linear-gradient(135deg, #f59e0b, #fbbf24); }
	&.rank-2 { background: linear-gradient(135deg, #94a3b8, #cbd5e1); }
	&.rank-3 { background: linear-gradient(135deg, #d97706, #f59e0b); }
}

.rank-name {
	flex: 1;
	font-size: 14px;
	color: $text;
	font-weight: 500;
}

.rank-stars {
	display: flex;
	align-items: center;
	gap: 1px;
}

.star { font-size: 12px; color: #e2e8f0; &.fill { color: #f59e0b; } }

.rank-rating {
	font-size: 12px;
	color: $mute;
	margin-left: 4px;
}

.footer-note {
	text-align: center;
	font-size: 11px;
	color: $mute;
	padding: 8px 0 20px;
}
</style>