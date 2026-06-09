<template>
	<view class="container">
		<view class="page-header">
			<text class="header-title">全部评价</text>
			<text class="header-count">共 {{ reviews.length }} 条</text>
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

		<view class="empty-state" v-if="reviews.length === 0">
			<text class="empty-text">暂无评价数据</text>
		</view>
	</view>
</template>

<script>
	import { listReview } from '@/api/maintenance/order'
	export default {
		data() {
			return {
				reviews: []
			}
		},
		onLoad() {
			this.loadData()
		},
		methods: {
			loadData() {
				listReview({ pageNum:1, pageSize:50 }).then(res => { this.reviews = res.data.list || [] })
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
$gold: #f59e0b;

page { background-color: $bg; }

.container {
	padding: 16px 16px 24px;
}

.page-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 16px;
}

.header-title {
	font-size: 18px;
	font-weight: 700;
	color: $text;
}

.header-count {
	font-size: 12px;
	color: $mute;
}

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
	background: linear-gradient(135deg, $green-dark, $green);
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
	color: $green-dark;
	background: $green-light;
	padding: 3px 10px;
	border-radius: 6px;
	font-weight: 500;
	align-self: flex-start;
}

.empty-state {
	padding: 60px 0;
	text-align: center;
}

.empty-text {
	font-size: 14px;
	color: $mute;
}
</style>