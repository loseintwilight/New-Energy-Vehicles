<template>
	<view class="detail-container">
		<!-- 顶部导航栏 -->
		<view class="detail-navbar">
			<view class="nav-back" @click="goBack">
				<uni-icons type="back" size="28" color="#333"></uni-icons>
			</view>
			<view class="nav-title">详情</view>
			<view class="nav-placeholder"></view>
		</view>
		<!-- 骨架屏 (保持不变) -->
		<view v-if="loading" class="skeleton">
			<view class="skeleton-title"></view>
			<view class="skeleton-line"></view>
			<view class="skeleton-line"></view>
			<view class="skeleton-line short"></view>
		</view>
		<template v-else>
			<scroll-view scroll-y class="scroll-content" :style="{ paddingTop: headerHeight + 'px' }">
				<!-- 科普/政策详情 -->
				<view v-if="type === 'science' || type === 'policy'" class="article-wrapper">
					<!-- 作者信息行 -->
					<view class="author-row">
						<view class="author-meta">
							<view class="name-line">
								<text class="original-tag">原创</text>
								<image class="avatar" src="/static/images/index/touxiang.png" mode="aspectFill"></image>
								<text class="author-name">新能源之家</text>
								<text class="read-count">{{ readCount }}阅读</text>
							</view>
							<view class="time-line">
								<text class="publish-time">{{ detail.date }} {{ detail.year || '2025' }}</text>
							</view>
						</view>
					</view>

					<!-- 标题 -->
					<text class="article-title">{{ detail.title }}</text>

					<!-- 正文部分 -->
					<view v-if="detail && detail.content" class="content-wrapper">
						
						<!-- 卡片 1 -->
						<view class="card-style-1">
							<text class="content-text">{{ detail.content[0] }}</text>
						</view>

						<view class="card-style-2">
							<text class="content-text">{{ detail.content[1] }}</text>
						</view>

					</view>
					<view v-else-if="detail && detail.desc" class="content-wrapper">
						<view class="card-style-1">
							<text class="content-text">{{ detail.desc }}</text>
						</view>
					</view>
				</view>

				<!-- 购车详情 -->
				<view v-else-if="type === 'car'" class="car-wrapper">
					<view class="video-container">
						<video :src="detail.videoSrc" class="car-video" controls objectFit="contain" autoplay></video>
					</view>
					<view class="car-info">
						<text class="car-name">{{ detail.carName }}</text>
						<view class="price-row">
							<text class="price-symbol">¥</text>
							<text class="price-num">{{ detail.price }}</text>
							<text class="price-unit">万起</text>
						</view>
						<view class="spec-table">
							<view class="spec-row">
								<text class="spec-label">续航里程</text>
								<text class="spec-value">{{ detail.range }}</text>
							</view>
							<view class="spec-row">
								<text class="spec-label">百公里加速</text>
								<text class="spec-value">{{ detail.acceleration }}</text>
							</view>
							<view class="spec-row">
								<text class="spec-label">电池类型</text>
								<text class="spec-value">{{ detail.battery }}</text>
							</view>
						</view>
						<view class="desc-box">
							<text class="desc-title">车型简介</text>
							<text class="desc-text">{{ detail.desc }}</text>
						</view>
						<button class="book-btn" @click="bookTestDrive">预约试驾</button>
					</view>
				</view>

				<!-- ===== 【恢复并修改】正文与推荐之间的操作栏 ===== -->
				<view class="section-action-bar" v-if="type === 'science' || type === 'policy'">
					<view class="action-item" @click="handleLike">
						<uni-icons type="hand-thumbsup" size="24" :color="isLiked ? '#e74c3c' : '#666'"></uni-icons>
						<text class="action-num" :class="{ liked: isLiked }">{{ likeCount }}</text>
					</view>
					<view class="action-item" @click="handleComment">
						<image class="action-icon-img" src="/static/images/index/preview.png" mode="aspectFit"></image>
						<text class="action-num">{{ commentCount }}</text>
					</view>
					<view class="action-item" @click="handleShare">
						<image class="action-icon-img" src="/static/images/index/share.png" mode="aspectFit"></image>
						<text class="action-num">分享</text>
					</view>
				</view>

				<!-- ===== 往期推荐 ===== -->
				<view class="recommend-section" v-if="recommendList.length">
					<view class="section-title">
						<text class="title-text">往期推荐</text>
					</view>
					<view class="recommend-list-vertical">
						<view class="rec-card" v-for="item in recommendList" :key="item.id" @click="goToDetail(item.type, item.id)">
							<image v-if="item.cover" class="rec-cover" :src="item.cover" mode="aspectFill"></image>
							<view class="rec-info">
								<text class="rec-title">{{ item.title }}</text>
								<text class="rec-desc">{{ item.desc }}</text>
							</view>
						</view>
					</view>
				</view>

				<!-- 底部占位 -->
				<view style="height: 120rpx;"></view>
			</scroll-view>

			<!-- ===== 【修改】底部评论栏 ===== -->
			<view class="bottom-comment-bar" v-if="type !== 'car'">
				<view class="comment-input">
					<input class="comment-field" v-model="commentText" placeholder="写评论..." :focus="commentFocused" @confirm="submitComment" />
					<text class="send-btn" :class="{ active: commentText.trim() }" @click="submitComment">发送</text>
				</view>
				<view class="bottom-actions">
					<view class="bottom-action" @click="handleLike">
						<uni-icons type="hand-thumbsup" size="26" :color="isLiked ? '#e74c3c' : '#999'"></uni-icons>
						<text class="action-text" :class="{ liked: isLiked }">赞</text>
					</view>
					<view class="bottom-action" @click="toggleFavorite">
						<uni-icons type="star-filled" size="24" :color="isFavorited ? '#ffc107' : '#999'"></uni-icons>
						<text class="action-text" :class="{ favorited: isFavorited }">收藏</text>
					</view>
				</view>
			</view>
		</template>
	</view>
</template>

<script>
import { addCollection, getFavoriteStatus, cancelCollectionByTarget } from '@/api/mine/collection'
// 原有JS代码完整保留
	export default {
		data() {
			return {
				type: '',
				id: null,
				detail: null,
				loading: true,
				headerHeight: 88,
				readCount: 0,
				likeCount: 0,
				commentCount: 0,
				isLiked: false,
				isFavorited: false,
				commentText: '',
				commentFocused: false,
				scienceList: [
					{ id: 1, date: '3月12日', year: '2025', title: '冬季新能源车续航为什么会下降', desc: '从电池热管理、空调使用和驾驶习惯解释续航变化。', content: ['冬季续航下降主要由三个因素导致：\n1. 电池活性降低，低温下锂离子移动速度变慢；\n2. 空调制热耗电，PTC加热器功率可达5-8kW；\n3. 轮胎阻力增加，空气密度增大。', '针对以上问题，建议出发前预热电池，利用充电桩的预热功能使电池达到最佳工作温度。行车过程中合理使用座椅加热代替空调制热，可大幅降低能耗。同时保持正常胎压，冬季建议胎压维持在2.5-2.8bar之间，能有效减少滚动阻力，提升续航表现。'], cover: '/static/images/index/img1.png' },
					{ id: 2, date: '2月20日', year: '2025', title: '新能源车日常保养小技巧', desc: '掌握这些要点，延长爱车寿命。', content: ['新能源车保养重点：\n1. 每5000公里检查轮胎胎压和磨损；\n2. 每1万公里更换空调滤芯；\n3. 每2万公里检查刹车油和冷却液。', '4. 避免电池过度放电，日常使用建议保持电量在20%-90%之间，长期停放时保持50%左右最为适宜；\n5. 定期进行高压系统检查，包括电池组、电机和电控系统的健康状态检测，建议每2万公里或每年到授权服务站进行一次全面检测。'], cover: '/static/images/index/img2.png' },
					{ id: 3, date: '1月8日', year: '2025', title: '超级快充与换电技术谁更有未来', desc: '分析两种主流补能方式的优劣势与发展前景。', content: ['超级快充和换电是当前两大主流补能方案，各有其核心优势。快充技术近年来发展迅猛，800V高压平台已可实现充电15分钟续航400km，且兼容性好，无需额外建设专用场地，普通充电站即可升级。', '换电模式的优势在于补能速度极快，全程仅需3-5分钟，与加油体验相当，同时换电站还可参与电网调峰，实现车网互动。从未来趋势看，预计将形成"快充为主、换电为辅"的格局，但对出租车、网约车等运营车辆而言，换电仍是不可替代的高效选择。'], cover: '/static/images/index/img1.png' },
					{ id: 4, date: '12月25日', year: '2024', title: '智能驾驶分级L0-L5到底有什么区别', desc: '一张图看懂自动驾驶分级标准，买车不被忽悠。', content: ['智能驾驶分为L0到L5六个等级：L0为纯人工驾驶，车辆没有任何辅助功能；L1级配备定速巡航等单功能辅助，可控制车速或方向之一；L2级具备车道居中和自适应巡航等组合辅助功能，可同时控制车速和方向，这是当前市面量产车的主流水平。', 'L3级为条件自动驾驶，系统可在特定场景下独立完成驾驶操作，但需驾驶员随时准备接管；L4级为高度自动驾驶，在限定区域内可完全自主行驶；L5级为全场景完全自动驾驶，目前尚未实现。市面上绝大多数号称"自动驾驶"的车型实际仅为L2+级别，购车时需仔细甄别。'], cover: '/static/images/index/img2.png' }
				],
				policyList: [
					{ id: 1, date: '1月20日', year: '2025', title: '2025年新能源汽车购置税减免政策延续', desc: '购置日期在2025年1月1日至2025年12月31日期间的新能源汽车免征车辆购置税。', content: ['根据财政部、税务总局、工信部联合公告，对购置日期在2025年1月1日至2025年12月31日期间的新能源汽车免征车辆购置税。其中，每辆新能源乘用车免税额不超过3万元，超出部分需按规定缴税。', '购车日期以机动车销售统一发票或海关关税专用缴款书等有效凭证的开具日期为准。该政策仅适用于纯电动汽车、插电式混合动力（含增程式）汽车和燃料电池汽车，非插电式混动车型不享受此优惠。'], cover: '/static/images/index/img1.png' },
					{ id: 2, date: '1月15日', year: '2025', title: '济南市充电基础设施补贴实施细则', desc: '对符合条件的公共充电桩建设给予财政补贴。', content: ['济南市对2025年新建的公共充电桩给予建设补贴：直流快充桩每千瓦补贴300元，交流慢充桩每千瓦补贴100元。单个项目最高补贴不超过50万元，有效降低了充电基础设施建设的投资门槛。', '申请补贴需满足以下条件：充电桩必须接入市级充电设施运营管理平台、正式运营满6个月以上、且对外开放共享使用。此举旨在鼓励社会资本参与充电网络建设，进一步缓解新能源汽车用户的充电焦虑。'], cover: '/static/images/index/img2.png' },
					{ id: 3, date: '12月30日', year: '2024', title: '新能源汽车动力电池回收管理办法', desc: '新规明确电池溯源管理及回收主体责任。', content: ['工信部发布新版《新能源汽车动力蓄电池回收利用管理办法》，明确车企承担电池回收主体责任，需建立电池溯源管理系统，对动力电池从生产、使用到报废的全生命周期进行跟踪记录。', '消费者在报废或更换电池时，应通过正规渠道交由有资质的企业处理，不得私自拆卸或随意丢弃。违规处置电池将面临最高20万元罚款。该办法自2025年3月1日起正式施行，推动新能源产业形成绿色闭环。'], cover: '/static/images/index/img1.png' },
					{ id: 4, date: '12月10日', year: '2024', title: '上海推出新能源汽车专用牌照新政策', desc: '2025年起插混车型不再发放免费专用牌照额度。', content: ['上海市发改委宣布，自2025年1月1日起，对购置插电式混合动力（含增程式）汽车的消费者，不再发放新能源汽车专用牌照额度。插混车型在上海将不再享受免费绿牌政策，需参与普通燃油车牌照拍卖。', '纯电动汽车仍可继续申请免费绿牌，不受此次政策调整影响。此举旨在进一步引导汽车消费市场向纯电动技术路线加速转型，同时通过控制插混车型的增长来缓解城市交通压力。'], cover: '/static/images/index/img2.png' }
				],
				carList: [
					{ id: 1, carName: '特斯拉 Model Y', price: '26.39', videoSrc: "https://media.w3.org/2010/05/sintel/trailer.mp4", desc: '纯电动中型SUV，续航554km，百公里加速5.0秒，智能驾驶辅助系统。', range: '554km', acceleration: '5.0秒', battery: '60kWh磷酸铁锂电池', cover: '/static/images/index/img1.png' },
					{ id: 2, carName: '比亚迪 汉EV', price: '20.98', videoSrc: "/static/images/index/car4.mp4", desc: '中大型纯电轿车，续航715km，刀片电池技术，豪华内饰。', range: '715km', acceleration: '3.9秒', battery: '85.4kWh刀片电池', cover: '/static/images/index/img2.png' },
					{ id: 3, carName: '蔚来 ET5', price: '29.80', videoSrc: "https://media.w3.org/2010/05/sintel/trailer.mp4", desc: '智能电动轿跑，续航710km，支持换电模式，智能座舱。', range: '710km', acceleration: '4.0秒', battery: '75kWh三元锂电池', cover: '/static/images/index/img1.png' },
					{ id: 4, carName: '小鹏 G6', price: '20.99', videoSrc: "https://media.w3.org/2010/05/sintel/trailer.mp4", desc: '超智驾轿跑SUV，续航755km，XNGP全场景智能驾驶。', range: '755km', acceleration: '3.9秒', battery: '87.5kWh磷酸铁锂电池', cover: '/static/images/index/img2.png' }
				]
			}
		},
		computed: {
			recommendList() {
				if (!this.detail) return [];
				let list = [];
				if (this.type === 'science') {
					list = this.scienceList.filter(item => item.id !== this.id);
				} else if (this.type === 'policy') {
					list = this.policyList.filter(item => item.id !== this.id);
				} else if (this.type === 'car') {
					list = this.carList.filter(item => item.id !== this.id);
				}
				return list.slice(0, 3).map(item => {
					item.type = this.type;
					item.cover = item.cover || '/static/images/index/img1.png';
					return item;
				});
			}
		},
		onLoad(options) {
			const { type, id } = options;
			this.type = type;
			this.id = parseInt(id);
			this.loadDetail();
			this.readCount = Math.floor(Math.random() * 500) + 168;
			this.likeCount = Math.floor(Math.random() * 100) + 30;
			this.commentCount = Math.floor(Math.random() * 50) + 10;
			this.$nextTick(() => {
				this.loadFavoriteStatus();
			});
		},
		methods: {
			loadDetail() {
				let detailData = null;
				if (this.type === 'science') {
					detailData = this.scienceList.find(item => item.id === this.id);
				} else if (this.type === 'policy') {
					detailData = this.policyList.find(item => item.id === this.id);
				} else if (this.type === 'car') {
					detailData = this.carList.find(item => item.id === this.id);
				}
				setTimeout(() => {
					this.detail = detailData;
					this.loading = false;
					if (!this.detail) {
						uni.showToast({ title: '内容不存在', icon: 'none' });
					}
				}, 300);
			},
			goBack() { uni.navigateBack(); },
			handleShare() { uni.showToast({ title: '分享功能开发中', icon: 'none' }); },
			handleLike() {
				this.isLiked = !this.isLiked;
				this.likeCount += this.isLiked ? 1 : -1;
			},
			getTargetInfo() {
				if (this.type === 'science' || this.type === 'policy') {
					return { targetType: 'article', targetId: this.id };
				}
				if (this.type === 'car') {
					return { targetType: 'vehicle', targetId: this.id };
				}
				return { targetType: 'article', targetId: this.id };
			},
			async loadFavoriteStatus() {
				try {
					const { targetType, targetId } = this.getTargetInfo();
					const res = await getFavoriteStatus(targetType, targetId);
					this.isFavorited = res.data === true;
				} catch (e) {
					this.isFavorited = false;
				}
			},
			async toggleFavorite() {
				try {
					const { targetType, targetId } = this.getTargetInfo();
					if (this.isFavorited) {
						await cancelCollectionByTarget(targetType, targetId);
						this.isFavorited = false;
					} else {
						await addCollection({ targetType, targetId });
						this.isFavorited = true;
					}
				} catch (e) {
					console.error('收藏操作失败', e);
				}
			},
			handleComment() {
				this.commentFocused = true;
			},
			submitComment() {
				const text = this.commentText.trim();
				if (!text) return;
				this.commentCount++;
				this.commentText = '';
				this.commentFocused = false;
				uni.showToast({ title: '发送成功', icon: 'none' });
			},
			bookTestDrive() { uni.showToast({ title: '预约试驾功能开发中', icon: 'none' }); },
			goToDetail(type, id) {
				uni.navigateTo({ url: `/pages/index/detail?type=${type}&id=${id}` });
			}
		}
	}
</script>

<style scoped>
	/* 原有基础样式保持不变 */
	.detail-container { background-color: #ffffff; min-height: 100vh; }

	.detail-navbar {
		display: flex;
		align-items: center;
		justify-content: space-between;
		height: 88rpx;
		padding: 0 30rpx;
		background-color: #fff;
		position: fixed;
		top: 0;
		left: 0;
		right: 0;
		z-index: 100;
		border-bottom: 1rpx solid rgba(0, 0, 0, 0.05);
	}
	.nav-back {
		width: 60rpx;
		height: 60rpx;
		display: flex;
		align-items: center;
		justify-content: center;
	}
	.nav-title {
		font-size: 32rpx;
		font-weight: 600;
		color: #333;
	}
	.nav-placeholder {
		width: 60rpx;
	}

	.custom-header { position: fixed; top: 0; left: 0; right: 0; height: 88rpx; display: flex; justify-content: space-between; align-items: center; padding: 0 30rpx; background-color: rgba(255, 255, 255, 0.96); backdrop-filter: blur(10px); z-index: 100; border-bottom: 1rpx solid rgba(0, 0, 0, 0.05); }
	.header-left .back-icon, .header-right .menu-icon { font-size: 44rpx; color: #333; font-weight: 500; }
	.scroll-content { height: 100vh; background-color: #fff; }
	.skeleton { padding: 40rpx; }
	.skeleton-title { height: 48rpx; width: 60%; background: #e0e0e0; border-radius: 8rpx; margin-bottom: 30rpx; }
	.skeleton-line { height: 32rpx; background: #e0e0e0; border-radius: 8rpx; margin-bottom: 20rpx; }
	.skeleton-line.short { width: 80%; }

	/* ===== 文章样式 ===== */
	.article-wrapper { padding: 20rpx 40rpx 10rpx; }
	.author-row { display: flex; align-items: center; margin-bottom: 20rpx; font-size: 26rpx; color: #999; }
	.author-meta { display: flex; flex-direction: column; width: 100%; }
	.name-line { display: flex; align-items: center; flex-wrap: wrap; }
	.original-tag { font-size: 22rpx; color: #d48806; background-color: #fffbe6; border: 1rpx solid #ffe58f; padding: 2rpx 10rpx; border-radius: 4rpx; margin-right: 16rpx; }
	.avatar { width: 50rpx; height: 50rpx; border-radius: 50%; margin-right: 12rpx; }
	.author-name { font-size: 28rpx; font-weight: 500; color: #222; margin-right: 12rpx; }
	.read-count { font-size: 24rpx; color: #999; margin-right: 10rpx; }
	.time-line { margin-top: 8rpx; }
	.publish-time { font-size: 24rpx; color: #999; }
	.article-title { font-size: 48rpx; font-weight: 700; color: #1a1a1a; line-height: 1.4; margin-bottom: 30rpx; display: block; }
	.content-wrapper { margin-bottom: 30rpx; }
	.content-text { white-space: pre-wrap; font-size: 32rpx; line-height: 1.8; color: #333; display: block; }
	.card-style-1 { position: relative; border: 1px solid #58b2c9; padding: 40rpx 30rpx; margin-bottom: 20rpx; background-color: #ffffff; }
	.card-style-1::before { content: ""; position: absolute; top: -1px; right: -1px; width: 30rpx; height: 30rpx; border-top: 1px solid #58b2c9; border-right: 1px solid #58b2c9; }
	.card-style-1::after { content: ""; position: absolute; bottom: -1px; right: -1px; width: 30rpx; height: 30rpx; border-bottom: 1px solid #58b2c9; border-right: 1px solid #58b2c9; }
	.card-style-2 { position: relative; background-color: #f1f8fc; padding: 40rpx 30rpx 60rpx 30rpx; margin-bottom: 20rpx; clip-path: polygon(0% 0%, 100% 0%, 100% 88%, 98% 100%, 92% 89%, 84% 100%, 78% 89%, 70% 100%, 64% 89%, 56% 100%, 50% 89%, 42% 100%, 36% 89%, 28% 100%, 22% 89%, 14% 100%, 8% 89%, 2% 100%, 0% 88%); }

	/* ===== 购车样式 ===== */
	.car-wrapper { background: #fff; overflow: hidden; }
	.video-container { width: 100%; background: #000; }
	.car-video { width: 100%; height: 420rpx; }
	.car-info { padding: 30rpx; }
	.car-name { font-size: 44rpx; font-weight: bold; color: #222; display: block; margin-bottom: 12rpx; }
	.price-row { margin-bottom: 30rpx; }
	.price-symbol { font-size: 32rpx; font-weight: bold; color: #ff5252; }
	.price-num { font-size: 52rpx; font-weight: bold; color: #ff5252; }
	.price-unit { font-size: 28rpx; color: #ff5252; }
	.spec-table { background: #f8f8f8; border-radius: 20rpx; padding: 20rpx; margin-bottom: 30rpx; }
	.spec-row { display: flex; justify-content: space-between; padding: 16rpx 0; border-bottom: 1rpx solid #eee; }
	.spec-label { font-size: 28rpx; color: #888; }
	.spec-value { font-size: 28rpx; font-weight: 500; color: #333; }
	.desc-box { margin-bottom: 40rpx; }
	.desc-title { font-size: 32rpx; font-weight: bold; color: #222; margin-bottom: 16rpx; display: block; }
	.desc-text { font-size: 28rpx; color: #555; line-height: 1.5; }
	.book-btn { background: linear-gradient(135deg, #ff9800, #ff6d00); color: white; border-radius: 50rpx; font-size: 32rpx; font-weight: bold; margin-top: 20rpx; }

	/* ===== 【新增】正文与推荐之间的操作栏 ===== */
	.section-action-bar {
		display: flex;
		justify-content: space-around;
		align-items: center;
		padding: 20rpx 0;
		border-top: 1rpx solid #f0f0f0;
		border-bottom: 1rpx solid #f0f0f0;
		margin: 30rpx 40rpx 20rpx;
	}
	.section-action-bar .action-item {
		display: flex;
		align-items: center;
		gap: 8rpx;
	}
	.section-action-bar .action-icon-img {
		width: 40rpx;
		height: 40rpx;
	}
	.section-action-bar .action-num {
		font-size: 28rpx;
		color: #333;
		font-weight: 500;
	}

	/* ===== 往期推荐（保留之前修改后的样式） ===== */
	.recommend-section {
		padding: 20rpx 30rpx 20rpx;
		background-color: #ffffff;
		margin-top: 10rpx;
	}
	.section-title {
		display: flex;
		align-items: center;
		margin-bottom: 20rpx;
	}
	.title-text {
		font-size: 34rpx;
		font-weight: 700;
		color: #333;
		background-color: #f3e5f5;
		padding: 8rpx 24rpx;
		border-radius: 30rpx;
	}
	.rec-card {
		display: flex;
		align-items: center;
		background: #ffffff;
		border-radius: 16rpx;
		padding: 12rpx;
		margin-bottom: 20rpx;
		box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.06);
	}
	.rec-cover {
		width: 160rpx;
		height: 100rpx;
		border-radius: 10rpx;
		flex-shrink: 0;
		background-color: #f0f0f0;
	}
	.rec-info {
		flex: 1;
		padding-left: 20rpx;
		display: flex;
		flex-direction: column;
		justify-content: center;
	}
	.rec-title {
		font-size: 28rpx;
		font-weight: 500;
		color: #222;
		line-height: 1.3;
		margin-bottom: 6rpx;
		display: -webkit-box;
		-webkit-line-clamp: 2;
		-webkit-box-orient: vertical;
		overflow: hidden;
	}
	.rec-desc {
		font-size: 24rpx;
		color: #999;
		display: -webkit-box;
		-webkit-line-clamp: 1;
		-webkit-box-orient: vertical;
		overflow: hidden;
	}

	/* ===== 【修改】底部评论栏 ===== */
	.bottom-comment-bar {
		position: fixed;
		bottom: 0;
		left: 0;
		right: 0;
		background: #ffffff;
		padding: 12rpx 24rpx;
		display: flex;
		align-items: center;
		border-top: 1rpx solid rgba(0, 0, 0, 0.05);
		box-shadow: 0 -2rpx 8rpx rgba(0, 0, 0, 0.02);
		z-index: 99;
	}
	.comment-input {
		flex: 1;
		background: #f2f4f6;
		border-radius: 40rpx;
		padding: 0 24rpx;
		margin-right: 16rpx;
		display: flex;
		align-items: center;
	}
	.comment-field {
		flex: 1;
		height: 64rpx;
		font-size: 28rpx;
		color: #333;
		background: transparent;
		border: none;
		outline: none;
	}
	.send-btn {
		font-size: 26rpx;
		color: #ccc;
		flex-shrink: 0;
		padding-left: 12rpx;
	}
	.send-btn.active {
		color: #07c160;
	}
	.bottom-actions {
		display: flex;
		align-items: center;
		gap: 30rpx;
	}
	.bottom-action {
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
	}
	.bottom-action .action-icon-img {
		width: 40rpx;
		height: 40rpx;
	}
	.bottom-action .action-text {
		font-size: 20rpx;
		color: #666;
		margin-top: 2rpx;
	}
	.bottom-action .action-text.liked,
	.section-action-bar .action-num.liked {
		color: #e74c3c !important;
	}
</style>