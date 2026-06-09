<template>
	<view class="container">
		<!-- 加载状态 -->
		<view class="loading-mask" v-if="loading">
			<view class="loading-spinner"></view>
			<text class="loading-text">加载中...</text>
		</view>

		<template v-if="!loading && order.orderId">
			<!-- 顶部状态大卡 -->
			<view class="hero" :class="'hero-' + order.orderStatus">
				<view class="hero-glow"></view>
				<view class="hero-row">
					<view class="status-badge" :class="'sb-' + order.orderStatus">{{ statusText }}</view>
					<text class="hero-order-no">#{{ order.orderNo }}</text>
				</view>
				<view class="hero-price">
					<text class="hp-symbol">¥</text>
					<text class="hp-num">{{ formatPrice(order.totalAmount) }}</text>
				</view>
				<view class="hero-service">{{ order.serviceItem }}</view>
				<view class="hero-meta">
					<text class="hm-time">{{ order.createTime }}</text>
				</view>
			</view>

			<!-- 门店信息 -->
			<view class="section">
				<view class="s-title">维保门店</view>
				<view class="s-card">
					<view class="info-row">
						<text class="il">门店名称</text>
						<text class="iv">{{ order.shopName || '-' }}</text>
					</view>
					<view class="info-row">
						<text class="il">门店地址</text>
						<text class="iv">{{ order.shopAddress || '-' }}</text>
					</view>
					<view class="info-row">
						<text class="il">联系人</text>
						<text class="iv">{{ order.contactName || '-' }}</text>
					</view>
					<view class="info-row">
						<text class="il">联系电话</text>
						<text class="iv">{{ order.contactPhone || '-' }}</text>
					</view>
				</view>
			</view>

			<!-- 车辆信息 -->
			<view class="section">
				<view class="s-title">车辆信息</view>
				<view class="s-card">
					<view class="info-row">
						<text class="il">车型</text>
						<text class="iv">{{ order.vehicleName || '-' }}</text>
					</view>
				</view>
			</view>

			<!-- 预约信息 -->
			<view class="section">
				<view class="s-title">预约信息</view>
				<view class="s-card">
					<view class="info-row">
						<text class="il">期望日期</text>
						<text class="iv">{{ order.expectDate || '-' }}</text>
					</view>
					<view class="info-row">
						<text class="il">时间段</text>
						<text class="iv">{{ order.expectTimeSlot === 'am' ? '上午 (08:00-12:00)' : '下午 (13:00-18:00)' }}</text>
					</view>
					<view class="info-row">
						<text class="il">服务项目</text>
						<text class="iv">{{ order.serviceItem || '-' }}</text>
					</view>
				</view>
			</view>

			<!-- 费用信息 -->
			<view class="section">
				<view class="s-title">费用明细</view>
				<view class="s-card">
					<view class="info-row">
						<text class="il">服务价格</text>
						<text class="iv iv-price">¥{{ formatPrice(order.servicePrice) }}</text>
					</view>
					<view class="info-row total-row" v-if="order.totalAmount">
						<text class="il">合计金额</text>
						<text class="iv iv-total">¥{{ formatPrice(order.totalAmount) }}</text>
					</view>
					<view class="info-row" v-if="order.paidAmount > 0">
						<text class="il">实付金额</text>
						<text class="iv iv-paid">¥{{ formatPrice(order.paidAmount) }}</text>
					</view>
					<view class="info-row">
						<text class="il">支付状态</text>
						<text class="iv" :class="order.payStatus === '1' ? 'pay-yes' : 'pay-no'">{{ order.payStatus === '1' ? '已支付' : '未支付' }}</text>
					</view>
					<view class="info-row" v-if="order.paymentMethod">
						<text class="il">支付方式</text>
						<text class="iv">{{ order.paymentMethod }}</text>
					</view>
				</view>
			</view>

			<!-- 评价信息 -->
			<view class="section" v-if="order.rating">
				<view class="s-title">用户评价</view>
				<view class="s-card">
					<view class="rating-row">
						<text class="star fill" v-for="s in order.rating" :key="'on'+s">★</text>
						<text class="star" v-for="s in (5 - order.rating)" :key="'off'+s">★</text>
						<text class="rating-num">{{ order.rating }}分</text>
					</view>
					<text class="comment-text" v-if="order.commentContent">{{ order.commentContent }}</text>
				</view>
			</view>

			<!-- 取消原因 -->
			<view class="section" v-if="order.orderStatus === '4' && order.cancelReason">
				<view class="s-title">取消原因</view>
				<view class="s-card">
					<text class="cancel-text">{{ order.cancelReason }}</text>
				</view>
			</view>

			<!-- 底部按钮 -->
			<view class="footer-actions" v-if="order.orderStatus === '0'">
				<button class="btn-modify" @click="handleConfirm">确认预约</button>
				<button class="btn-cancel" @click="showCancelModal = true">取消预约</button>
			</view>

			<view class="footer-gap"></view>
		</template>

		<!-- 取消原因弹窗 -->
		<view class="modal-mask" v-if="showCancelModal" @click="showCancelModal = false">
			<view class="modal-panel" @click.stop>
				<view class="modal-title">取消预约</view>
				<text class="modal-desc">确定要取消该预约吗？取消后不可恢复。</text>
				<textarea class="modal-textarea" v-model="cancelReason" placeholder="请填写取消原因（选填）" />
				<view class="modal-actions">
					<button class="modal-btn modal-btn-no" @click="showCancelModal = false">再想想</button>
					<button class="modal-btn modal-btn-yes" :disabled="cancelling" @click="handleCancel">确认取消</button>
				</view>
			</view>
		</view>

		<!-- 空状态 -->
		<view class="empty-state" v-if="!loading && !order.orderId">
			<text class="empty-icon">📋</text>
			<text class="empty-text">订单不存在</text>
		</view>
	</view>
</template>

<script>
	import { getOrderDetail, cancelOrder, updateOrder } from '@/api/maintenance/order'

	export default {
		data() {
			return {
				loading: true,
				order: {},
				orderId: null,
				isLocal: false,
				showCancelModal: false,
				cancelReason: '',
				cancelling: false
			}
		},
		computed: {
			statusText() {
				const map = { '0': '待确认', '1': '已确认', '2': '服务中', '3': '已完成', '4': '已取消' }
				return map[this.order.orderStatus] || '未知'
			}
		},
		onLoad(options) {
			this.orderId = options.orderId
			this.isLocal = options.local === '1'
			this.loadDetail()
		},
		methods: {
			async loadDetail(orderId) {
				this.loading = true
				const id = orderId || this.orderId
				if (!id) {
					this.loading = false
					return
				}
				if (this.isLocal) {
					// 从本地存储读取
					const local = uni.getStorageSync('local_maintenance_orders') || []
					this.order = local.find(o => o.orderId === Number(id)) || {}
					this.loading = false
					return
				}
				try {
					const res = await getOrderDetail(id)
					this.order = res.data || {}
				} catch (e) {
					// 回退到本地
					const local = uni.getStorageSync('local_maintenance_orders') || []
					this.order = local.find(o => o.orderId === Number(id)) || {}
				}
				this.loading = false
			},
			formatPrice(val) {
				if (!val && val !== 0) return '0.00'
				return Number(val).toFixed(2)
			},
			handleConfirm() {
				uni.showLoading({ title: '确认中...' })
				updateOrder({
					order_id: this.order.orderId,
					order_status: '1'
				}).then(() => {
					uni.hideLoading()
					uni.showToast({ title: '已确认', icon: 'success' })
					this.order.orderStatus = '1'
				}).catch(() => {
					// 本地也更新
					const local = uni.getStorageSync('local_maintenance_orders') || []
					const idx = local.findIndex(o => o.orderId === this.order.orderId)
					if (idx > -1) {
						local[idx].orderStatus = '1'
						uni.setStorageSync('local_maintenance_orders', local)
					}
					uni.hideLoading()
					uni.showToast({ title: '已确认', icon: 'success' })
					this.order.orderStatus = '1'
				})
			},
			async handleCancel() {
				if (this.cancelling) return
				this.cancelling = true

				uni.showLoading({ title: '取消中...' })

				try {
					await cancelOrder({
						order_id: this.order.orderId,
						cancel_reason: this.cancelReason || '用户主动取消'
					})
				} catch (e) {
					// 尝试本地取消
				}

				// 本地存储也更新
				const local = uni.getStorageSync('local_maintenance_orders') || []
				const idx = local.findIndex(o => o.orderId === this.order.orderId)
				if (idx > -1) {
					local[idx].orderStatus = '4'
					local[idx].cancelReason = this.cancelReason || '用户主动取消'
					uni.setStorageSync('local_maintenance_orders', local)
				}

				uni.hideLoading()
				uni.showToast({ title: '取消成功', icon: 'success' })
				this.showCancelModal = false
				this.order.orderStatus = '4'
				this.order.cancelReason = this.cancelReason || '用户主动取消'
				this.cancelling = false
			}
		}
	}
</script>

<style lang="scss" scoped>
$bg: #f0fdf4;
$green1: #059669;
$green2: #34d399;
$green3: #d1fae5;
$card: #ffffff;
$text: #0f172a;
$mute: #94a3b8;
$gold: #f59e0b;

page { background-color: $bg; }
.container { min-height: 100vh; padding-bottom: 40px; }

// ====== 加载 ======
.loading-mask {
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	height: 60vh;
	gap: 12px;
}
.loading-spinner {
	width: 32px;
	height: 32px;
	border: 3px solid #e2e8f0;
	border-top-color: $green1;
	border-radius: 50%;
	animation: spin 0.8s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }
.loading-text { font-size: 14px; color: $mute; }

// ====== Hero ======
.hero {
	position: relative;
	margin: 0 16px;
	margin-top: 16px;
	border-radius: 20px;
	padding: 28px 20px 24px;
	overflow: hidden;
	color: #fff;

	&.hero-0 { background: linear-gradient(135deg, #f59e0b, #d97706); }
	&.hero-1 { background: linear-gradient(135deg, #3b82f6, #2563eb); }
	&.hero-2 { background: linear-gradient(135deg, #8b5cf6, #7c3aed); }
	&.hero-3 { background: linear-gradient(135deg, $green1, $green2); }
	&.hero-4 { background: linear-gradient(135deg, #94a3b8, #64748b); }
}

.hero-glow {
	position: absolute;
	top: -40%;
	right: -20%;
	width: 200px;
	height: 200px;
	border-radius: 50%;
	background: rgba(255,255,255,0.1);
}

.hero-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 16px;
}

.status-badge {
	font-size: 12px;
	padding: 3px 12px;
	border-radius: 6px;
	font-weight: 600;
	background: rgba(255,255,255,0.2);
}

.hero-order-no {
	font-size: 12px;
	opacity: 0.8;
	font-family: 'Courier New', monospace;
}

.hero-price {
	margin-bottom: 8px;
}

.hp-symbol {
	font-size: 20px;
	font-weight: 600;
	opacity: 0.9;
}

.hp-num {
	font-size: 42px;
	font-weight: 800;
	letter-spacing: -1px;
}

.hero-service {
	font-size: 16px;
	font-weight: 600;
	margin-bottom: 10px;
	opacity: 0.95;
}

.hero-meta {
	display: flex;
	gap: 12px;
}

.hm-time {
	font-size: 11px;
	opacity: 0.7;
}

// ====== Section ======
.section {
	margin: 20px 16px 0;
}

.s-title {
	font-size: 16px;
	font-weight: 700;
	color: $text;
	margin-bottom: 10px;
	padding-left: 10px;
	position: relative;
	&::before {
		content: '';
		position: absolute;
		left: 0;
		top: 3px;
		width: 3px;
		height: 18px;
		background: linear-gradient($green1, $green2);
		border-radius: 2px;
	}
}

.s-card {
	background: $card;
	border-radius: 14px;
	padding: 14px 16px;
	box-shadow: 0 2px 8px rgba(5,150,105,0.04);
}

.info-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 10px 0;
	border-bottom: 1px solid #f1f5f9;
	&:last-child { border-bottom: none; }
}

.il {
	font-size: 13px;
	color: $mute;
	min-width: 70px;
}

.iv {
	font-size: 13px;
	color: $text;
	text-align: right;
	flex: 1;
}

.iv-price { color: $mute; }
.iv-total { font-weight: 700; color: $text; font-size: 15px; }
.iv-paid { font-weight: 600; color: $green1; }

.pay-yes { color: $green1; font-weight: 600; }
.pay-no { color: #f59e0b; font-weight: 600; }

.total-row {
	padding: 12px 0;
	border-top: 1px dashed #e2e8f0;
	margin-top: 4px;
}

// ====== 评价 ======
.rating-row {
	display: flex;
	align-items: center;
	gap: 3px;
	margin-bottom: 8px;
}

.star {
	font-size: 16px;
	color: #e2e8f0;
	&.fill { color: $gold; }
}

.rating-num {
	font-size: 13px;
	color: $gold;
	margin-left: 6px;
	font-weight: 600;
}

.comment-text {
	font-size: 13px;
	color: #475569;
	line-height: 1.6;
}

.cancel-text {
	font-size: 13px;
	color: #ef4444;
	line-height: 1.6;
}

// ====== 底部按钮 ======
.footer-actions {
	margin: 24px 16px 0;
	display: flex;
	gap: 8px;
}

.btn-modify {
	flex: 1;
	height: 44px;
	background: $green1;
	border-radius: 22px;
	color: #fff;
	font-size: 15px;
	font-weight: 600;
	border: none;
	display: flex;
	align-items: center;
	justify-content: center;
}

.btn-cancel {
	flex: 1;
	height: 44px;
	background: #fff;
	border-radius: 22px;
	color: #ef4444;
	font-size: 15px;
	font-weight: 600;
	border: 1px solid #fca5a5;
	display: flex;
	align-items: center;
	justify-content: center;
}

// ====== 取消弹窗 ======
.modal-mask {
	position: fixed;
	top: 0; left: 0; right: 0; bottom: 0;
	background: rgba(0,0,0,0.45);
	z-index: 999;
	display: flex;
	align-items: center;
	justify-content: center;
}

.modal-panel {
	width: 280px;
	background: #fff;
	border-radius: 16px;
	padding: 24px 20px;
}

.modal-title {
	font-size: 17px;
	font-weight: 700;
	color: $text;
	text-align: center;
	margin-bottom: 8px;
}

.modal-desc {
	font-size: 13px;
	color: $mute;
	text-align: center;
	display: block;
	margin-bottom: 14px;
}

.modal-textarea {
	width: 100%;
	height: 72px;
	background: #f8fafc;
	border-radius: 8px;
	padding: 10px;
	font-size: 13px;
	color: $text;
	border: 1px solid #e2e8f0;
	box-sizing: border-box;
	resize: none;
}

.modal-actions {
	display: flex;
	gap: 10px;
	margin-top: 16px;
}

.modal-btn {
	flex: 1;
	height: 40px;
	border-radius: 20px;
	font-size: 14px;
	font-weight: 600;
	border: none;
	display: flex;
	align-items: center;
	justify-content: center;
}

.modal-btn-no {
	background: #f1f5f9;
	color: $mute;
}

.modal-btn-yes {
	background: #ef4444;
	color: #fff;
}

// ====== 空状态 ======
.empty-state {
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	height: 60vh;
	gap: 10px;
}
.empty-icon { font-size: 48px; }
.empty-text { font-size: 14px; color: $mute; }

.footer-gap { height: 20px; }
</style>