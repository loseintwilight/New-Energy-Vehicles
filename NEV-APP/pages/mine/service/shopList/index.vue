<template>
	<view class="container">
		<!-- 搜索栏 -->
		<view class="search-bar">
			<view class="search-input-wrap">
				<view class="iconfont icon-search search-icon"></view>
				<input class="search-input" v-model="keyword" placeholder="搜索门店名称" @confirm="handleSearch" />
				<text class="search-clear iconfont icon-clean" v-if="keyword" @click="keyword = ''; handleSearch()"></text>
			</view>
		</view>

		<!-- 状态筛选 -->
		<scroll-view class="filter-scroll" scroll-x enhanced show-scrollbar="false">
			<view class="filter-track">
				<view class="filter-tag" :class="{ active: curStatus === '' }" @click="curStatus = ''; loadList()">全部</view>
				<view class="filter-tag" :class="{ active: curStatus === '0' }" @click="curStatus = '0'; loadList()">待审核</view>
				<view class="filter-tag" :class="{ active: curStatus === '1' }" @click="curStatus = '1'; loadList()">营业中</view>
				<view class="filter-tag" :class="{ active: curStatus === '2' }" @click="curStatus = '2'; loadList()">已停用</view>
			</view>
		</scroll-view>

		<!-- 门店列表 -->
		<view class="shop-list">
			<view class="shop-card" v-for="(shop, index) in shopList" :key="shop.shopId" @click="handleDetail(shop)">
				<image class="shop-img" :src="shop.image" mode="aspectFill" v-if="shop.image"></image>
				<view class="shop-top">
					<view class="shop-name">{{ shop.shopName }}</view>
					<view class="status-tag" :class="'status-' + shop.status">{{ statusText(shop.status) }}</view>
				</view>
				<view class="shop-rating">
					<text class="star fill" v-for="s in Math.floor(shop.rating)" :key="'on' + s">★</text>
					<text class="star" v-for="s in (5 - Math.floor(shop.rating))" :key="'off' + s">★</text>
					<text class="rating-num">{{ shop.rating }}</text>
				</view>
				<view class="shop-addr">
					<view class="iconfont icon-community addr-icon"></view>
					<text>{{ shop.province }}{{ shop.city }}{{ shop.district }}{{ shop.address }}</text>
				</view>
				<view class="shop-contact">
					<view class="contact-item">
						<view class="iconfont icon-user contact-icon"></view>
						<text>{{ shop.contactName }}</text>
					</view>
					<view class="contact-item">
						<view class="iconfont icon-service contact-icon"></view>
						<text>{{ shop.contactPhone }}</text>
					</view>
				</view>
				<view class="shop-services" v-if="shop.servicesInfo">
					<text class="service-tag" v-for="(svc, si) in parseServices(shop.servicesInfo)" :key="si">{{ svc }}</text>
				</view>
				<view class="shop-desc" v-if="shop.description">{{ shop.description }}</view>
				<view class="shop-footer">
					<text class="shop-time">创建: {{ shop.createTime }}</text>
					<view class="shop-actions">
						<text class="action-btn" @click.stop="handleEdit(shop)">编辑</text>
						<text class="action-btn action-btn-del" @click.stop="handleDelete(shop)">删除</text>
					</view>
				</view>
			</view>
		</view>

		<!-- 空状态 -->
		<view class="empty-state" v-if="shopList.length === 0 && !loading">
			<view class="iconfont icon-community empty-icon"></view>
			<text class="empty-text">暂无门店数据</text>
		</view>

		<!-- 加载中 -->
		<view class="loading-tip" v-if="loading">
			<text>加载中...</text>
		</view>
	</view>
</template>

<script>
	import { listShop, deleteShop } from '@/api/maintenance/shop'
	export default {
		data() {
			return {
				keyword: '',
				curStatus: '',
				loading: false,
				shopList: []
			}
		},
		onLoad() {
			this.loadList()
		},
		onPullDownRefresh() {
			this.loadList()
		},
		methods: {
			loadList() {
				 listShop({
				    pageNum: 1,
				    pageSize: 50,
				    keyword: this.keyword,
				    status: this.curStatus
				  }).then(res => {
				    this.shopList = res.data.list || []
				    uni.stopPullDownRefresh()
				  })
			},
			handleSearch() {
				this.loadList()
			},
			handleDetail(shop) {
				this.$tab.navigateTo('/pages/mine/service/shopEdit/index?shop_id=' + shop.shopId)
			},
			handleEdit(shop) {
				this.$tab.navigateTo('/pages/mine/service/shopEdit/index?shop_id=' + shop.shopId)
			},
			handleDelete(shop) {
			  this.$modal.confirm('确认删除门店「' + shop.shopName + '」？').then(() => {
			    deleteShop(shop.shopId).then(() => {
			      this.$modal.msgSuccess('删除成功')
			      this.loadList()
			    })
			  }).catch(() => {})
			},
			statusText(status) {
				const map = { '0': '待审核', '1': '营业中', '2': '已停用' }
				return map[status] || '未知'
			},
			parseServices(info) {
				try {
					const arr = typeof info === 'string' ? JSON.parse(info) : info
					return Array.isArray(arr) ? arr.slice(0, 3) : [info]
				} catch {
					return info ? info.split(/[,，、]/).slice(0, 3) : []
				}
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

.container {
	padding: 0 16px 24px;
}

// ====== 搜索栏 ======
.search-bar {
	padding: 14px 0 10px;
}

.search-input-wrap {
	background: $card;
	border-radius: 12px;
	padding: 0 14px;
	display: flex;
	align-items: center;
	height: 42px;
	box-shadow: 0 2px 8px rgba(5, 150, 105, 0.06);
}

.search-icon {
	font-size: 16px;
	color: $mute;
	margin-right: 8px;
	flex-shrink: 0;
}

.search-input {
	flex: 1;
	font-size: 14px;
	color: $text;
	height: 42px;
}

.search-clear {
	font-size: 14px;
	color: $mute;
	padding: 0 4px;
}

// ====== 状态筛选 ======
.filter-scroll {
	margin: 0 -16px;
	padding: 0 16px 12px;
	overflow: hidden;
}

.filter-track {
	display: flex;
	gap: 8px;
	width: max-content;
}

.filter-tag {
	padding: 5px 16px;
	border-radius: 20px;
	font-size: 12px;
	color: $mute;
	background: #f1f5f9;
	border: 1px solid #e2e8f0;

	&.active {
		color: $green-dark;
		background: $green-light;
		border-color: $green;
		font-weight: 500;
	}
}

// ====== 门店卡片 ======
.shop-list {
	display: flex;
	flex-direction: column;
	gap: 12px;
}

.shop-card {
	background: $card;
	border-radius: 16px;
	padding: 16px;
	box-shadow: 0 2px 12px rgba(5, 150, 105, 0.06);
	overflow: hidden;
}

.shop-img {
	width: calc(100% + 32px);
	height: 160px;
	margin: -16px -16px 12px;
	display: block;
	background: #e2e8f0;
}

.shop-top {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 8px;
}

.shop-name {
	font-size: 16px;
	font-weight: 700;
	color: $text;
}

.status-tag {
	font-size: 11px;
	padding: 2px 10px;
	border-radius: 4px;
	font-weight: 500;

	&.status-0 { color: #f59e0b; background: #fef3c7; }
	&.status-1 { color: $green-dark; background: $green-light; }
	&.status-2 { color: #94a3b8; background: #f1f5f9; }
}

// 评分
.shop-rating {
	margin-bottom: 10px;
	display: flex;
	align-items: center;
	gap: 2px;

	.star {
		font-size: 13px;
		color: #e2e8f0;

		&.fill { color: #f59e0b; }
	}

	.rating-num {
		font-size: 11px;
		color: $mute;
		margin-left: 4px;
	}
}

// 地址
.shop-addr {
	font-size: 13px;
	color: #475569;
	display: flex;
	align-items: flex-start;
	margin-bottom: 8px;
	line-height: 1.4;
}

.addr-icon {
	font-size: 13px;
	color: $mute;
	margin-right: 4px;
	flex-shrink: 0;
	margin-top: 2px;
}

// 联系人
.shop-contact {
	display: flex;
	gap: 16px;
	margin-bottom: 8px;
}

.contact-item {
	display: flex;
	align-items: center;
	gap: 4px;
	font-size: 13px;
	color: #475569;
}

.contact-icon {
	font-size: 13px;
	color: $mute;
}

// 服务标签
.shop-services {
	display: flex;
	flex-wrap: wrap;
	gap: 6px;
	margin-bottom: 8px;
}

.service-tag {
	font-size: 11px;
	color: $green-dark;
	background: $green-light;
	padding: 2px 10px;
	border-radius: 4px;
}

// 描述
.shop-desc {
	font-size: 12px;
	color: $mute;
	margin-bottom: 10px;
	line-height: 1.4;
}

// 底部
.shop-footer {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding-top: 10px;
	border-top: 1px solid #f1f5f9;
}

.shop-time {
	font-size: 11px;
	color: $mute;
}

.shop-actions {
	display: flex;
	gap: 8px;
}

.action-btn {
	font-size: 12px;
	color: $green-dark;
	background: $green-light;
	padding: 3px 14px;
	border-radius: 6px;
	font-weight: 500;

	&:active { opacity: 0.7; }
}

.action-btn-del {
	color: #ef4444;
	background: #fef2f2;
}

// ====== 空状态 / 加载 ======
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