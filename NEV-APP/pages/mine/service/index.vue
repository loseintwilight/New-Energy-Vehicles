<template>
	<view class="page-container">
		<view class="container" :style="{ minHeight: windowHeight + 'px' }">
		<!-- ====== 顶部个人卡片 ====== -->
		<view class="profile-card">
			<view class="profile-bg"></view>
			<view class="profile-content">
				<view class="profile-top">
					<view class="profile-user">
						<image v-if="avatar" :src="avatar" class="profile-avatar" mode="aspectFill" @click="handleToAvatar"></image>
						<view v-else class="profile-avatar profile-avatar-empty" @click="handleToAvatar">
							<uni-icons type="user" size="36" color="#fff"></uni-icons>
						</view>
						<view class="profile-info" @click="handleToInfo">
							<text class="profile-name">{{ name }}</text>
							<text class="profile-phone">{{ phone }}</text>
						</view>
					</view>
					<view class="profile-actions">
						<view class="switch-btn" @click="handleSwitchUser">切换用户版</view>
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
	import { getDashboardStats } from '@/api/maintenance/dashboard'
	export default {
		data() {
			return {
				windowHeight: 0,
				name: this.$store.state.user.name || '未登录',
				phone: this.$store.state.user.phonenumber || '',
				avatar: this.$store.state.user.avatar || '',
				stats: {},
				reviews: [
					{
						username: 'ry若依',
						avatar: '/static/images/index/touxiang.png',
						rating: 5,
						createTime: '2026-05-28',
						commentContent: '服务非常专业，电池检测报告详细，技师耐心解答了充电保养问题，好评！',
						shopName: '济南鑫维保-经十西路店'
					},
					{
						username: '李车主',
						avatar: '',
						rating: 4,
						createTime: '2026-05-22',
						commentContent: '更换了轮胎和空调滤芯，价格合理，服务态度不错，下次还会来。',
						shopName: '济南鑫维保-工业北路店'
					}
				]
			}
		},
		onLoad() {
			this.windowHeight = uni.getSystemInfoSync().windowHeight
			this.loadData()
		},
		onShow() {
			this.name = this.$store.state.user.name || '未登录'
			this.phone = this.$store.state.user.phonenumber || ''
			this.avatar = this.$store.state.user.avatar || ''
		},
		methods: {
			handleNotify() { this.$modal.msg('暂无新通知') },
			handleSwitchUser() { this.$tab.switchTab('/pages/mine/index') },
			handleToAvatar() { this.$tab.navigateTo('/pages/mine/avatar/index') },
			handleToInfo() { this.$tab.navigateTo('/pages/mine/info/index') },
			handleComment() { this.$tab.navigateTo('/pages/mine/service/shopComment/index') },
			handleShopList() { this.$tab.navigateTo('/pages/mine/service/shopList/index') },
			handleCreateShop() { this.$tab.navigateTo('/pages/mine/service/shopEdit/index') },
			handleOrders() { this.$tab.navigateTo('/pages/mine/service/orderList/index') },
			handleSettings() { this.$tab.navigateTo('/pages/mine/service/dataSettings/index') },
			loadData() { 
				getDashboardStats().then(res => { this.stats = res.data || [] })
			},
			getFirstChar(name) {
				return name ? name.charAt(0) : '匿'
			}
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


.container { 
	padding-top: 85px;
	padding-bottom: 30px; }

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

.profile-phone {
	font-size: 12px;
	color: rgba(255, 255, 255, 0.7);
}

.profile-avatar-empty {
	display: flex;
	align-items: center;
	justify-content: center;
	background: rgba(255, 255, 255, 0.2);
	border: 2px solid rgba(255, 255, 255, 0.4);
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
// ============ 快捷入口 ============
.entry-grid {
	display: flex;
	flex-wrap: wrap;
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
	width: 48%;
	margin-bottom: 10px;

	&:active {
		transform: scale(0.96);
	}
}

.entry-card:nth-child(odd) {
	margin-right: 4%;
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