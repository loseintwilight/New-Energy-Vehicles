<template>
	<view class="container">
		<!-- 顶部统计条 -->
		<view class="stat-bar">
			<view class="stat-cell" @click="filterStatus = ''; loadList()">
				<text class="stat-num">{{ stats.total }}</text>
				<text class="stat-label">全部</text>
			</view>
			<view class="stat-cell" @click="filterStatus = '0'; loadList()">
				<text class="stat-num">{{ stats.pending }}</text>
				<text class="stat-label">待确认</text>
			</view>
			<view class="stat-cell" @click="filterStatus = '1'; loadList()">
				<text class="stat-num">{{ stats.confirmed }}</text>
				<text class="stat-label">已确认</text>
			</view>
			<view class="stat-cell" @click="filterStatus = '3'; loadList()">
				<text class="stat-num">{{ stats.completed }}</text>
				<text class="stat-label">已完成</text>
			</view>
			<view class="stat-cell" @click="filterStatus = '4'; loadList()">
				<text class="stat-num">{{ stats.cancelled }}</text>
				<text class="stat-label">已取消</text>
			</view>
		</view>

		<!-- 订单列表 -->
		<view class="order-list">
			<view class="order-card" v-for="(order, index) in orderList" :key="order.order_id" @click="handleDetail(order)">
				<view class="order-head">
					<text class="order-no">#{{ order.order_no }}</text>
					<view class="order-status" :class="'os-' + order.order_status">{{ statusText(order.order_status) }}</view>
				</view>
				<view class="order-service">{{ order.service_item }}</view>
				<view class="order-info">
					<view class="info-row">
						<text class="info-label">门店</text>
						<text class="info-val">{{ order.shop_name }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">金额</text>
						<text class="info-val info-price">¥{{ order.total_amount }}</text>
					</view>
					<view class="info-row" v-if="order.pay_status === '1'">
						<text class="info-label">实付</text>
						<text class="info-val info-price">¥{{ order.paid_amount }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">预约</text>
						<text class="info-val">{{ order.expect_date }} {{ order.expect_time_slot === 'am' ? '上午' : '下午' }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">支付</text>
						<text class="info-val" :class="order.pay_status === '1' ? 'pay-yes' : 'pay-no'">{{ order.pay_status === '1' ? '已支付' : '未支付' }}</text>
					</view>
				</view>
				<view class="order-rating" v-if="order.rating">
					
					<text v-for="st in getStars(order.rating,'star')" :key="st.key" :class="st.cls">★</text>
					<text class="rating-text" v-if="order.comment_content">「{{ order.comment_content }}」</text>
				</view>
				<view class="order-foot">
					<text class="order-time">{{ order.create_time }}</text>
				</view>
			</view>
		</view>

		<view class="empty-state" v-if="orderList.length === 0 && !loading">
			<view class="iconfont icon-service empty-icon"></view>
			<text class="empty-text">暂无订单</text>
		</view>

		<view class="loading-tip" v-if="loading">加载中...</view>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				filterStatus: '',
				loading: false,
				stats: { total: 0, pending: 0, confirmed: 0, completed: 0, cancelled: 0 },
				orderList: []
			}
		},
		onLoad() { this.loadList() },
		onPullDownRefresh() { this.loadList() },
		methods: {
			loadList() {
				this.loading = true
				setTimeout(() => {
					const all = this.mockData()
					this.stats = {
						total: all.length,
						pending: all.filter(o => o.order_status === '0').length,
						confirmed: all.filter(o => o.order_status === '1').length,
						completed: all.filter(o => o.order_status === '3').length,
						cancelled: all.filter(o => o.order_status === '4').length
					}
					this.orderList = this.filterStatus ? all.filter(o => o.order_status === this.filterStatus) : all
					this.loading = false
					uni.stopPullDownRefresh()
				}, 300)
			},
			handleDetail(order) {
				this.$modal.msg('订单详情页开发中')
			},
			statusText(s) {
				const map = { '0': '待确认', '1': '已确认', '2': '服务中', '3': '已完成', '4': '已取消' }
				return map[s] || '未知'
			},
			mockData() {
				return [
					{
						order_id: 1, order_no: 'MC20260528001', shop_name: '旗舰维保中心',
						service_item: '常规保养 + 电池检测', total_amount: '680.00', paid_amount: '680.00',
						expect_date: '2026-05-28', expect_time_slot: 'am',
						order_status: '3', pay_status: '1',
						rating: 5, comment_content: '服务非常好，专业细致',
						create_time: '2026-05-27 14:30'
					},
					{
						order_id: 2, order_no: 'MC20260529002', shop_name: '旗舰维保中心',
						service_item: '空调维修', total_amount: '350.00', paid_amount: '0',
						expect_date: '2026-05-30', expect_time_slot: 'pm',
						order_status: '1', pay_status: '0',
						rating: 0, comment_content: '',
						create_time: '2026-05-29 09:15'
					},
					{
						order_id: 3, order_no: 'MC20260528003', shop_name: '新城服务站',
						service_item: '充电桩安装', total_amount: '2800.00', paid_amount: '2800.00',
						expect_date: '2026-05-28', expect_time_slot: 'am',
						order_status: '3', pay_status: '1',
						rating: 4, comment_content: '安装师傅很专业',
						create_time: '2026-05-26 16:00'
					},
					{
						order_id: 4, order_no: 'MC20260525004', shop_name: '新城服务站',
						service_item: '故障诊断', total_amount: '200.00', paid_amount: '0',
						expect_date: '2026-05-25', expect_time_slot: 'am',
						order_status: '4', pay_status: '0',
						rating: 0, comment_content: '',
						cancel_reason: '用户取消',
						create_time: '2026-05-24 11:20'
					},
					{
						order_id: 5, order_no: 'MC20260529005', shop_name: '高新维保点',
						service_item: '电池检测', total_amount: '150.00', paid_amount: '150.00',
						expect_date: '2026-05-29', expect_time_slot: 'am',
						order_status: '2', pay_status: '1',
						rating: 0, comment_content: '',
						create_time: '2026-05-29 08:00'
					},
					{
						order_id: 6, order_no: 'MC20260527006', shop_name: '旗舰维保中心',
						service_item: '轮胎更换 + 四轮定位', total_amount: '880.00', paid_amount: '880.00',
						expect_date: '2026-05-27', expect_time_slot: 'am',
						order_status: '3', pay_status: '1',
						rating: 5, comment_content: '换了四条轮胎，师傅很细心',
						create_time: '2026-05-26 10:00'
					}
				]
				},
				getStars(rating, baseClass) {
					const filled = Math.floor(rating)
					const items = []
					for (let i = 0; i < 5; i++) {
						items.push({ key: 'k' + i, cls: baseClass + (i < filled ? ' fill' : '') })
					}
					return items
				}
			}
		}
</script>

<style lang="scss" scoped>
$green: #00c9a7;
$green-dark: #059669;
$green-light: #d1fae5;
$bg: #ecfdf5;
$card: #ffffff;
$text: #0f172a;
$mute: #94a3b8;

page { background-color: $bg; }
.container { padding: 0 16px 24px; }

// ====== 顶部统计 ======
.stat-bar {
	display: flex;
	background: $card;
	border-radius: 16px;
	padding: 14px 0;
	margin: 14px 0 12px;
	box-shadow: 0 2px 8px rgba(5, 150, 105, 0.04);
}

.stat-cell {
	flex: 1;
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 3px;
	text-align: center;
	&:active { opacity: 0.6; }
}

.stat-num {
	font-size: 18px;
	font-weight: 700;
	color: $text;
	font-family: 'Courier New', monospace;
}

.stat-label {
	font-size: 11px;
	color: $mute;
}

// ====== 订单卡片 ======
.order-list {
	display: flex;
	flex-direction: column;
	gap: 10px;
}

.order-card {
	background: $card;
	border-radius: 16px;
	padding: 14px 16px;
	box-shadow: 0 2px 8px rgba(5, 150, 105, 0.04);
}

.order-head {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 8px;
}

.order-no {
	font-size: 13px;
	color: $text;
	font-weight: 500;
	font-family: 'Courier New', monospace;
}

.order-status {
	font-size: 11px;
	padding: 2px 10px;
	border-radius: 4px;
	font-weight: 500;

	&.os-0 { color: #f59e0b; background: #fef3c7; }
	&.os-1 { color: #3b82f6; background: #dbeafe; }
	&.os-2 { color: #8b5cf6; background: #ede9fe; }
	&.os-3 { color: $green-dark; background: $green-light; }
	&.os-4 { color: #94a3b8; background: #f1f5f9; }
}

.order-service {
	font-size: 15px;
	font-weight: 600;
	color: $text;
	margin-bottom: 8px;
}

.order-info {
	display: flex;
	flex-direction: column;
	gap: 5px;
	margin-bottom: 8px;
	padding: 8px 10px;
	background: #f8fafc;
	border-radius: 10px;
}

.info-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.info-label {
	font-size: 12px;
	color: $mute;
}

.info-val {
	font-size: 12px;
	color: $text;
}

.info-price {
	font-weight: 600;
	color: $text;
}

.pay-yes { color: $green-dark; }
.pay-no { color: #f59e0b; }

// 评价
.order-rating {
	display: flex;
	align-items: center;
	gap: 2px;
	margin-bottom: 8px;
	.star { font-size: 12px; color: #e2e8f0; &.fill { color: #f59e0b; } }
}

.rating-text {
	font-size: 12px;
	color: $mute;
	margin-left: 4px;
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
	flex: 1;
}

.order-foot {
	border-top: 1px solid #f1f5f9;
	padding-top: 8px;
}

.order-time {
	font-size: 11px;
	color: $mute;
}

// ====== 空状态 ======
.empty-state {
	padding: 60px 0;
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 10px;
}

.empty-icon {
	font-size: 48px;
	color: #d1d5db;
}

.empty-text {
	font-size: 14px;
	color: $mute;
}

.loading-tip {
	padding: 20px 0;
	text-align: center;
	font-size: 13px;
	color: $mute;
}
</style>