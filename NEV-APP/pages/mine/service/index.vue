<template>
	<view class="page-container">
		<view class="container" :style="{ minHeight: windowHeight + 'px' }">
		<!-- ====== 顶部个人卡片 ====== -->
		<view class="profile-card">
			<view class="profile-bg"></view>
			<view class="profile-content">
				<view class="profile-top">
					<view class="profile-user">
						<image class="profile-avatar" src="/static/images/service/service_header1.png" mode="aspectFill"></image>
						<view class="profile-info">
							<text class="profile-name">{{ userName }}</text>
							<text class="profile-role">商家维保</text>
						</view>
					</view>
<view class="profile-actions">
						<view class="switch-btn" @click="handleSwitchUser">切换用户版</view>
						<!-- <view class="profile-notify" @click="handleNotify">
							<view class="iconfont icon-community notify-icon"></view>
							<view class="notify-dot"></view>
						</view> -->
					</view>
				</view>
				<view class="profile-stats">
					<view class="profile-stat" @click="handleShopList">
						<text class="pstat-num">{{ stats.shopCount }}</text>
						<text class="pstat-label">门店总数</text>
					</view>
					<view class="pstat-divider"></view>
					<view class="profile-stat" @click="handleOrders">
						<text class="pstat-num">{{ stats.orderCount }}</text>
						<text class="pstat-label">今日订单</text>
					</view>
					<view class="pstat-divider"></view>
					<view class="profile-stat" @click="handleOrders">
						<text class="pstat-num">{{ stats.reviewCount }}</text>
						<text class="pstat-label">累计评价</text>
					</view>
					<view class="pstat-divider"></view>
					<view class="profile-stat">
						<text class="pstat-num pstat-num-gold">{{ stats.avgRating }}</text>
						<text class="pstat-label">综合评分</text>
					</view>
				</view>
			</view>
			<!-- 装饰圆 -->
			<view class="deco-circle c1"></view>
			<view class="deco-circle c2"></view>
			<view class="deco-circle c3"></view>
		</view>

		<!-- ====== 快捷入口 ====== -->
		<view class="section">
			<view class="section-head">
				<text class="section-title">综合服务</text>
			</view>
			<view class="entry-grid">
				<view class="entry-card" @click="handleShopList">
					<view class="entry-icon entry-icon-shop">
						<view class="iconfont icon-community"></view>
					</view>
					<text class="entry-name">门店管理</text>
					<text class="entry-badge">{{ stats.shopCount }}家</text>
				</view>
				<view class="entry-card" @click="handleCreateShop">
					<view class="entry-icon entry-icon-add">
						<view class="iconfont icon-dianzan"></view>
					</view>
					<text class="entry-name">创建门店</text>
					<text class="entry-badge">立即创建</text>
				</view>
				<view class="entry-card" @click="handleOrders">
					<view class="entry-icon entry-icon-order">
						<view class="iconfont icon-service"></view>
					</view>
					<text class="entry-name">订单管理</text>
					<text class="entry-badge">查看订单</text>
				</view>
				<!-- <view class="entry-card" @click="handleSettings">
					<view class="entry-icon entry-icon-set">
						<view class="iconfont icon-setting"></view>
					</view>
					<text class="entry-name">数据统计</text>
					<text class="entry-badge">业绩看板</text>
				</view> -->
				<view class="entry-card" @click="handleSettings">
					<view class="entry-icon entry-icon-set">
						<view class="iconfont icon-setting"></view>
					</view>
					<text class="entry-name">数据统计</text>
					<text class="entry-badge">业绩看板</text>
				</view>
			</view>
		</view>

		<!-- ====== 最近评价 ====== -->
		<view class="section">
			<view class="section-head">
				<text class="section-title">最近评价</text>
				<text class="section-more" @click="handleComment">查看全部 ›</text>
			</view>
			<view class="review-list">
				<view class="review-card" v-for="(item, index) in reviews" :key="index">
					<view class="rc-header">
						<view class="rc-avatar">
							<image class="rc-avatar-img" :src="item.avatar" mode="aspectFill" v-if="item.avatar"></image>
							<text v-else>{{ item.username ? item.username.charAt(0) : '匿' }}</text>
						</view>
						<view class="rc-info">
							<text class="rc-name">{{ item.username || '匿名用户' }}</text>
							<view class="rc-stars">
								<text class="rc-star fill" v-for="s in item.rating" :key="'on' + s">★</text>
								<text class="rc-star" v-for="s in (5 - item.rating)" :key="'off' + s">★</text>
							</view>
						</view>
						<text class="rc-time">{{ item.createTime }}</text>
					</view>
					<text class="rc-text">{{ item.commentContent }}</text>
					<text class="rc-shop">{{ item.shopName }}</text>
				</view>
			</view>
			<view class="review-empty" v-if="reviews.length === 0">暂无评价数据</view>
		</view>

		<!-- ====== 底部留白 ====== -->
		<view class="footer-gap"></view>
	</view>
	</view>
	
</template>

<script>
	export default {
		data() {
			return {
				windowHeight: 0,
				userName: '小雨滴777',
				stats: {
					shopCount: 4,
					orderCount: 6,
					reviewCount: 3,
					avgRating: '4.3'
				},
				reviews: [
					{ avatar: '/static/images/service/service_header1.png', username: '张先生', rating: 5, commentContent: '服务非常专业，师傅技术很好，价格也很合理。', shopName: '旗舰维保中心', createTime: '05-28' },
					{ avatar: '/static/images/service/service_header2.png', username: '李女士', rating: 4, commentContent: '环境不错，服务态度好，下次还来。', shopName: '旗舰维保中心', createTime: '05-27' },
					{ avatar: '/static/images/service/service_header3.png', username: '王先生', rating: 5, commentContent: '保养很细致，检查项目都很全面，推荐！', shopName: '新城服务站', createTime: '05-26' }
				]
			}
		},
		onLoad() {
			this.windowHeight = uni.getSystemInfoSync().windowHeight
		},
methods: {
			handleNotify() { this.$modal.msg('暂无新通知') },
			handleSwitchUser() { this.$tab.switchTab('/pages/mine/index') },
			handleComment() { this.$tab.navigateTo('/pages/mine/service/shopComment/index') },
			handleShopList() { this.$tab.navigateTo('/pages/mine/service/shopList/index') },
			handleCreateShop() { this.$tab.navigateTo('/pages/mine/service/shopEdit/index') },
			handleOrders() { this.$tab.navigateTo('/pages/mine/service/orderList/index') },
			handleSettings() { this.$tab.navigateTo('/pages/mine/service/dataSettings/index') }
		}
	}
</script>

<style lang="scss" scoped>
// ============ 颜色系统 ============
$g1: #059669;   // 深翠
$g2: #10b981;   // 翠绿
$g3: #34d399;   // 亮翠
$g4: #6ee7b7;   // 浅翠
$g5: #d1fae5;   // 底翠
$bg: #f0fdf4;
$card: #ffffff;
$text: #0f172a;
$mute: #94a3b8;
$gold: #f59e0b;


.container { padding-bottom: 30px; }

.page-container{
	background-color: #cfe5df;
}

// ============ 顶部个人卡片 ============
.profile-card {
	margin: 0 16px;
	position: relative;
	overflow: hidden;
	border-radius: 24px;
	min-height: 200px;
}

.profile-bg {
	position: absolute;
	inset: 0;
	background: linear-gradient(135deg, #a1c9be 0%, #8fc0b1 40%, #7db7a4 100%);
}

// 装饰圆
// .deco-circle {
// 	position: absolute;
// 	border-radius: 50%;
// 	opacity: 0.12;
// 	pointer-events: none;
// }
// .c1 {
// 	width: 160px; height: 160px;
// 	background: #fff;
// 	top: -60px; right: -40px;
// }
// .c2 {
// 	width: 100px; height: 100px;
// 	background: #fff;
// 	bottom: -30px; left: -20px;
// }
// .c3 {
// 	width: 60px; height: 60px;
// 	background: #fff;
// 	bottom: 20px; right: 30px;
// }

.profile-content {
	position: relative;
	z-index: 1;
	padding: 24px 20px 20px;
	display: flex;
	flex-direction: column;
	gap: 20px;
}

// 用户信息行
.profile-top {
	display: flex;
	align-items: center;
	justify-content: space-between;
}

.profile-user {
	display: flex;
	align-items: center;
	gap: 14px;
}

.profile-avatar {
	width: 56px;
	height: 56px;
	border-radius: 18px;
	border: 2px solid rgba(255, 255, 255, 0.3);
	background: #fff;
}

.profile-info {
	display: flex;
	flex-direction: column;
	gap: 4px;
}

.profile-name {
	font-size: 20px;
	font-weight: 700;
	color: #ffffff;
	letter-spacing: 1px;
}

.profile-role {
	font-size: 12px;
	color: rgba(255, 255, 255, 0.75);
}

// 右上角操作区
.profile-actions {
	display: flex;
	align-items: center;
	gap: 8px;
}

.switch-btn {
	font-size: 12px;
	color: #ffffff;
	background: rgba(255, 255, 255, 0.2);
	padding: 6px 12px;
	border-radius: 8px;
	font-weight: 500;
	backdrop-filter: blur(4px);
	border: 1px solid rgba(255, 255, 255, 0.1);
}

// 通知图标
.profile-notify {
	width: 40px;
	height: 40px;
	border-radius: 12px;
	background: rgba(255, 255, 255, 0.2);
	display: flex;
	align-items: center;
	justify-content: center;
	position: relative;
	backdrop-filter: blur(4px);
}

.notify-icon {
	font-size: 20px;
	color: #ffffff;
}

.notify-dot {
	position: absolute;
	top: 8px;
	right: 8px;
	width: 8px;
	height: 8px;
	border-radius: 50%;
	background: #ef4444;
	border: 2px solid #059669;
}

// 数据统计
.profile-stats {
	display: flex;
	background: rgba(255, 255, 255, 0.15);
	backdrop-filter: blur(8px);
	border-radius: 16px;
	padding: 14px 8px;
	border: 1px solid rgba(255, 255, 255, 0.1);
}

.profile-stat {
	flex: 1;
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 4px;
	text-align: center;
}

.pstat-num {
	font-size: 22px;
	font-weight: 700;
	color: #ffffff;
	font-family: 'Courier New', monospace;
	line-height: 1.2;
}

.pstat-num-gold {
	color: #fcd34d;
	text-shadow: 0 0 12px rgba(252, 211, 77, 0.35);
}

.pstat-label {
	font-size: 11px;
	color: rgba(255, 255, 255, 0.75);
	font-weight: 400;
}

.pstat-divider {
	width: 1px;
	align-self: stretch;
	margin: 4px 0;
	background: rgba(255, 255, 255, 0.15);
}

// ============ 分区通用 ============
.section {
	margin: 20px 16px 0;
}

.section-head {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: 14px;
}

.section-title {
	font-size: 18px;
	font-weight: 700;
	color: $text;
	position: relative;
	padding-left: 12px;

	&::before {
		content: '';
		position: absolute;
		left: 0;
		top: 3px;
		width: 4px;
		height: 18px;
		background: linear-gradient($g1, $g3);
		border-radius: 2px;
	}
}

.section-more {
	font-size: 13px;
	color: $g2;
	font-weight: 500;
}

// ============ 快捷入口 ============
.entry-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 12px;
}

.entry-card {
	background: $card;
	border-radius: 18px;
	padding: 20px 16px 16px;
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 8px;
	box-shadow: 0 2px 16px rgba(5, 150, 105, 0.08);
	transition: transform 0.2s;

	&:active {
		transform: scale(0.96);
	}
}

.entry-icon {
	width: 52px;
	height: 52px;
	border-radius: 16px;
	display: flex;
	align-items: center;
	justify-content: center;
	margin-bottom: 4px;

	.iconfont {
		font-size: 26px;
		color: #ffffff;
	}
}

.entry-icon-shop {
	background: linear-gradient(135deg, #059669, #34d399);
	box-shadow: 0 4px 12px rgba(5, 150, 105, 0.3);
}

.entry-icon-add {
	background: linear-gradient(135deg, #0ea5e9, #38bdf8);
	box-shadow: 0 4px 12px rgba(14, 165, 233, 0.3);
}

.entry-icon-order {
	background: linear-gradient(135deg, #8b5cf6, #a78bfa);
	box-shadow: 0 4px 12px rgba(139, 92, 246, 0.3);
}

.entry-icon-set {
	background: linear-gradient(135deg, #64748b, #94a3b8);
	box-shadow: 0 4px 12px rgba(100, 116, 139, 0.3);
}

.entry-name {
	font-size: 15px;
	font-weight: 600;
	color: $text;
}

.entry-badge {
	font-size: 11px;
	color: $mute;
	font-weight: 400;
}

// ============ 评价卡片（纵向） ============
.review-list {
	display: flex;
	flex-direction: column;
	gap: 12px;
}

.review-card {
	background: $card;
	border-radius: 18px;
	padding: 18px;
	box-shadow: 0 2px 16px rgba(5, 150, 105, 0.08);
	display: flex;
	flex-direction: column;
	gap: 10px;
}

.rc-header {
	display: flex;
	align-items: center;
	gap: 10px;
}

.rc-avatar {
	width: 38px;
	height: 38px;
	border-radius: 12px;
	background: linear-gradient(135deg, $g1, $g3);
	color: #ffffff;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 15px;
	font-weight: 700;
	flex-shrink: 0;
	overflow: hidden;
}

.rc-avatar-img {
	width: 100%;
	height: 100%;
	border-radius: 12px;
}

.rc-info {
	flex: 1;
	display: flex;
	flex-direction: column;
	gap: 3px;
}

.rc-name {
	font-size: 14px;
	font-weight: 600;
	color: $text;
}

.rc-stars {
	display: flex;
	gap: 2px;
}

.rc-star {
	font-size: 14px;
	color: #e2e8f0;

	&.fill {
		color: $gold;
		text-shadow: 0 0 6px rgba(245, 158, 11, 0.35);
	}
}

.rc-time {
	font-size: 11px;
	color: $mute;
	flex-shrink: 0;
}

.rc-text {
	font-size: 13px;
	color: #475569;
	line-height: 1.55;
}

.rc-shop {
	font-size: 11px;
	color: $g1;
	background: $g5;
	padding: 3px 10px;
	border-radius: 6px;
	font-weight: 500;
	align-self: flex-start;
}

.review-empty {
	text-align: center;
	padding: 20px 0;
	color: $mute;
	font-size: 14px;
}

.footer-gap {
	height: 24px;
}
</style>