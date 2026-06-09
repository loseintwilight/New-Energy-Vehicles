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
			<view class="order-card" v-for="(order, index) in orderList" :key="order.orderId" @click="handleDetail(order)">
				<view class="order-head">
					<text class="order-no">#{{ order.orderNo }}</text>
					<view class="order-status" :class="'os-' + order.orderStatus">{{ statusText(order.orderStatus) }}</view>
				</view>
				<view class="order-service">{{ order.serviceItem }}</view>
				<view class="order-info">
					<view class="info-row">
						<text class="info-label">门店</text>
						<text class="info-val">{{ order.shopName }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">金额</text>
						<text class="info-val info-price">¥{{ order.totalAmount }}</text>
					</view>
					<view class="info-row" v-if="order.payStatus === '1'">
						<text class="info-label">实付</text>
						<text class="info-val info-price">¥{{ order.paidAmount }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">预约</text>
						<text class="info-val">{{ order.expectDate }} {{ order.expectTimeSlot === 'am' ? '上午' : '下午' }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">支付</text>
						<text class="info-val" :class="order.payStatus === '1' ? 'pay-yes' : 'pay-no'">{{ order.payStatus === '1' ? '已支付' : '未支付' }}</text>
					</view>
				</view>

				<view class="order-foot">
					<text class="order-time">{{ order.createTime }}</text>
					<text class="order-cancel" v-if="order.orderStatus === '0'" @click.stop="handleCancel(order)">取消预约</text>
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
	import { listOrder, getOrderStats, cancelOrder } from '@/api/maintenance/order'
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
			    getOrderStats().then(res => { this.stats = res.data }).catch(() => {
			        // 本地统计
			        const local = uni.getStorageSync('local_maintenance_orders') || []
			        this.stats = {
			            total: local.length,
			            pending: local.filter(o => o.orderStatus === '0').length,
			            confirmed: local.filter(o => o.orderStatus === '1').length,
			            completed: local.filter(o => o.orderStatus === '3').length,
			            cancelled: local.filter(o => o.orderStatus === '4').length
			        }
			    })
			    listOrder({ pageNum:1, pageSize:50, orderStatus: this.filterStatus }).then(res => {
			        this.orderList = res.data.list || []
			        this.loading = false
			        uni.stopPullDownRefresh()
			    }).catch(() => {
			        // 从本地加载
			        let local = uni.getStorageSync('local_maintenance_orders') || []
			        if (this.filterStatus) {
			            local = local.filter(o => o.orderStatus === this.filterStatus)
			        }
			        this.orderList = local
			        this.loading = false
			        uni.stopPullDownRefresh()
			    })
			},
			handleDetail(order) {
				this.$tab.navigateTo('/pages/mine/service/orderList/detail?orderId=' + order.orderId + '&local=' + (order.orderNo && order.orderNo.startsWith('LOCAL') ? '1' : '0'))
			},
			handleCancel(order) {
				uni.showModal({
					title: '取消预约',
					content: '确定要取消订单 #' + order.orderNo + ' 吗？',
					success: (res) => {
						if (res.confirm) {
							uni.showLoading({ title: '取消中...' })
							const doCancel = () => {
								// 后端
								cancelOrder({ order_id: order.orderId, cancel_reason: '用户主动取消' }).then(() => {
									uni.hideLoading()
									uni.showToast({ title: '取消成功', icon: 'success' })
									this.loadList()
								}).catch(() => {
									// 本地取消
									const local = uni.getStorageSync('local_maintenance_orders') || []
									const idx = local.findIndex(o => o.orderId === order.orderId)
									if (idx > -1) {
										local[idx].orderStatus = '4'
										local[idx].cancelReason = '用户主动取消'
										uni.setStorageSync('local_maintenance_orders', local)
									}
									uni.hideLoading()
									uni.showToast({ title: '取消成功', icon: 'success' })
									this.loadList()
								})
							}
							doCancel()
						}
					}
				})
			},
			statusText(s) {
				const map = { '0': '待确认', '1': '已确认', '2': '服务中', '3': '已完成', '4': '已取消' }
				return map[s] || '未知'
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

.order-foot {
	border-top: 1px solid #f1f5f9;
	padding-top: 8px;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.order-time {
	font-size: 11px;
	color: $mute;
}

.order-cancel {
	font-size: 12px;
	color: #ef4444;
	font-weight: 500;
	padding: 4rpx 12rpx;
	border: 1px solid #fca5a5;
	border-radius: 20rpx;
	line-height: 1.6;

	&:active {
		background: #fef2f2;
	}
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