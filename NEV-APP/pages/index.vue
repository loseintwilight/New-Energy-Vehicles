// index.vue - 首页（修改后）
<template>
	<view class="page-container">
		<!-- 轮播图 Banner -->
		<view class="con1">
			<swiper class="con1-swiper" circular indicator-dots="false" autoplay="true" interval="5000" duration="500">
				<swiper-item v-for="(item, index) in newlist" :key="index">
					<image class="con1-img" :src="item" mode="aspectFill"></image>
				</swiper-item>
			</swiper>
		</view>

		<!-- 用户卡片 + 导航 -->
		<view>
			<view class="user-card">
				<view class="user-left">
					<img src="/static/images/index/touxiang.png" alt="头像" class="avatar-circle" />
					<view class="user-info">
						<text class="user-name">改革开放</text>
						<text class="user-phone">138******78</text>
					</view>
				</view>
				<view class="user-right">
					<text class="points-num">1,280&nbsp;&nbsp;</text>
					<text class="points-label">我的碳积分</text>
				</view>
			</view>

			<view class="nav-grid">
				<view class="nav-item" @click="handleNavClick('充电服务')">
					<view class="nav-icon icon-blue">
						<img src="/static/images/index/charging.png" alt="充电服务" class="nav-icon-img" />
					</view>
					<text class="nav-text">去充电</text>
				</view>
				<view class="nav-item" @click="handleNavClick('购车')">
					<view class="nav-icon icon-orange">
						<img src="/static/images/index/car.png" alt="购车" class="nav-icon-img" />
					</view>
					<text class="nav-text">购车</text>
				</view>
				<view class="nav-item" @click="handleNavClick('碳积分')">
					<view class="nav-icon icon-green">
						<img src="/static/images/index/CO2.png" alt="碳积分" class="nav-icon-img" />
					</view>
					<text class="nav-text">碳积分</text>
				</view>
				<view class="nav-item" @click="handleNavClick('预约维保')">
					<view class="nav-icon icon-purple">
						<img src="/static/images/index/work.png" alt="预约维保" class="nav-icon-img" />
					</view>
					<text class="nav-text">预约维保</text>
				</view>
			</view>
		</view>

<!-- 		Tab 切换栏 -->
		<view class="tab-bar">
			<view class="tab-item" v-for="(tab, index) in tabs" :key="index" @click="switchTab(index)">
				<text class="tab-text" :class="{ 'active': currentTab === index }">{{ tab }}</text>
				<view class="tab-line" v-if="currentTab === index"></view>
			</view>
		</view>

		<!-- 内容列表区 -->
		<view class="content-area">
			<!-- Tab 0: 精选科普 -->
			<view v-if="currentTab === 0" class="list-container">
				<view class="card-item" v-for="item in dataScience" :key="item.id" @click="goToDetail('science', item.id)">
					<view class="card-header">
						<view class="tag" :style="{ backgroundColor: item.bgColor || '#e8f5e9' }">
							<text>{{ item.tag || '科普' }}</text>
						</view>
						<text class="date">{{ item.date }}</text>
					</view>
					<view class="card-content">
						<text class="card-title">{{ item.title }}</text>
						<text class="card-desc">{{ item.desc }}</text>
					</view>
				</view>
			</view>

			<!-- Tab 1: 购车推荐 -->
			<view v-if="currentTab === 1" class="list-container">
				<view class="car-card-item" v-for="car in carList" :key="car.id" @click="goToDetail('car', car.id)">
					<video :src="car.videoSrc" class="card-full-video" objectFit="cover" muted playsinline @error="videoError" @click.stop></video>
					<view class="car-info">
						<text class="car-name">{{ car.carName }}</text>
						<view class="car-price-row">
							<text class="price-symbol">¥</text>
							<text class="price-num">{{ car.price }}</text>
							<text class="price-unit">万起</text>
						</view>
					</view>
				</view>
			</view>

			<!-- Tab 2: 政策解读 -->
			<view v-if="currentTab === 2" class="list-container">
				<view class="card-item" v-for="item in dataPolicy" :key="item.id" @click="goToDetail('policy', item.id)">
					<view class="card-header">
						<view class="tag" style="background-color: #e3f2fd;">
							<text>政策</text>
						</view>
						<text class="date">{{ item.date }}</text>
					</view>
					<view class="card-content">
						<text class="card-title">{{ item.title }}</text>
						<text class="card-desc">{{ item.desc }}</text>
					</view>
				</view>
			</view>
		</view>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				newlist: [
					"/static/images/index/img2.png",
					"/static/images/index/img1.png",
					"/static/images/index/img3.png"
				],
				currentTab: 0,
				tabs: ['精选科普', '购车推荐', '政策解读'],

				// 科普数据（增加详细内容字段）
				dataScience: [{
					id: 1,
					tag: '科普',
					date: '3月12日',
					title: '冬季新能源车续航为什么会下降',
					desc: '从电池热管理、空调使用和驾驶习惯解释续航变化。',
					content: '冬季续航下降主要由三个因素导致：1. 电池活性降低，低温下锂离子移动速度变慢；2. 空调制热耗电，PTC加热器功率可达5-8kW；3. 轮胎阻力增加，空气密度增大。建议：出发前预热电池、合理使用座椅加热、保持胎压正常。',
					bgColor: '#e8f5e9'
				}, {
					id: 2,
					tag: '科普',
					date: '2月20日',
					title: '新能源车日常保养小技巧',
					desc: '掌握这些要点，延长爱车寿命。',
					content: '新能源车保养重点：1. 每5000公里检查轮胎胎压和磨损；2. 每1万公里更换空调滤芯；3. 每2万公里检查刹车油和冷却液；4. 避免电池过度放电（保持20%-90%电量）；5. 定期进行高压系统检查。',
					bgColor: '#fff3e0'
				}, {
					id: 3,
					tag: '科普',
					date: '1月8日',
					title: '超级快充与换电技术谁更有未来',
					desc: '分析两种主流补能方式的优劣势与发展前景。',
					content: '超级快充和换电是当前两大主流补能方案。快充优势在于兼容性好、无需额外场地，800V高压平台已可实现充电15分钟续航400km；换电优势在于补能时间短（3-5分钟），且可参与电网调峰。未来趋势可能是"快充为主、换电为辅"的格局，但对运营车辆而言换电仍是不可替代的选择。',
					bgColor: '#fce4ec'
				}, {
					id: 4,
					tag: '科普',
					date: '12月25日',
					title: '智能驾驶分级L0-L5到底有什么区别',
					desc: '一张图看懂自动驾驶分级标准，买车不被忽悠。',
					content: 'L0：纯人工驾驶；L1：定速巡航等单功能辅助；L2：车道居中+自适应巡航等组合辅助（当前主流）；L3：条件自动驾驶，系统可独立完成驾驶但需要人工接管（如奔驰Drive Pilot）；L4：高度自动驾驶，特定场景下完全自主（如Robotaxi）；L5：全场景完全自动驾驶（尚未实现）。目前市面上绝大多数号称"自动驾驶"的车型实际仅为L2+级别。',
					bgColor: '#e8eaf6'
				}],

				// 政策数据（增加详细内容字段）
				dataPolicy: [{
					id: 1,
					date: '1月20日',
					title: '2025年新能源汽车购置税减免政策延续',
					desc: '购置日期在2025年1月1日至2025年12月31日期间的新能源汽车免征车辆购置税。',
					content: '根据财政部、税务总局、工信部联合公告，对购置日期在2025年1月1日至2025年12月31日期间的新能源汽车免征车辆购置税。其中，每辆新能源乘用车免税额不超过3万元。购车日期以机动车销售统一发票或海关关税专用缴款书等有效凭证的开具日期为准。'
				}, {
					id: 2,
					date: '1月15日',
					title: '济南市充电基础设施补贴实施细则',
					desc: '对符合条件的公共充电桩建设给予财政补贴。',
					content: '济南市对2025年新建的公共充电桩给予建设补贴：直流快充桩每千瓦补贴300元，交流慢充桩每千瓦补贴100元。单个项目最高补贴不超过50万元。申请条件：充电桩接入市级平台、运营满6个月、对外开放。'
				}, {
					id: 3,
					date: '12月30日',
					title: '新能源汽车动力电池回收管理办法',
					desc: '新规明确电池溯源管理及回收主体责任。',
					content: '工信部发布新版《新能源汽车动力蓄电池回收利用管理办法》，明确车企承担电池回收主体责任，需建立电池溯源管理系统。消费者在报废或更换电池时，应通过正规渠道交由有资质的企业处理。违规处置电池将面临最高20万元罚款。该办法自2025年3月1日起施行。'
				}, {
					id: 4,
					date: '12月10日',
					title: '上海推出新能源汽车专用牌照新政策',
					desc: '2025年起插混车型不再发放免费专用牌照额度。',
					content: '上海市发改委宣布，自2025年1月1日起，对购置插电式混合动力（含增程式）汽车的消费者，不再发放新能源汽车专用牌照额度。纯电动汽车仍可继续申请免费绿牌。此举旨在进一步引导市场向纯电动技术路线转型，同时缓解城市交通压力。'
				}],

				// 购车数据（丰富字段用于详情页）
				carList: [{
					id: 1,
					carName: '特斯拉 Model Y',
					price: '26.39',
					videoSrc: "https://media.w3.org/2010/05/sintel/trailer.mp4",
					desc: '纯电动中型SUV，续航554km，百公里加速5.0秒',
					range: '554km',
					acceleration: '5.0秒',
					battery: '60kWh磷酸铁锂电池'
				}, {
					id: 2,
					carName: '比亚迪 汉EV',
					price: '20.98',
					videoSrc: "/static/images/index/car4.mp4",
					desc: '中大型纯电轿车，续航715km，刀片电池技术',
					range: '715km',
					acceleration: '3.9秒',
					battery: '85.4kWh刀片电池'
				}, {
					id: 3,
					carName: '蔚来 ET5',
					price: '29.80',
					videoSrc: "https://media.w3.org/2010/05/sintel/trailer.mp4",
					desc: '智能电动轿跑，续航710km，支持换电模式',
					range: '710km',
					acceleration: '4.0秒',
					battery: '75kWh三元锂电池'
				}, {
					id: 4,
					carName: '小鹏 G6',
					price: '20.99',
					videoSrc: "https://media.w3.org/2010/05/sintel/trailer.mp4",
					desc: '超智驾轿跑SUV，续航755km，XNGP全场景智驾',
					range: '755km',
					acceleration: '3.9秒',
					battery: '87.5kWh磷酸铁锂电池'
				}]
			};
		},

		methods: {
			switchTab(index) {
				this.currentTab = index;
			},
			videoError(e) {
				console.log('视频加载错误:', e.detail);
			},
			// 跳转详情页
			goToDetail(type, id) {
				uni.navigateTo({
					url: `/pages/index/detail?type=${type}&id=${id}`
				});
			},
			handleNavClick(title) {
				const pageMap = {
					'充电服务': '/pages/charge/index',
					'购车': '/pages/car/index',
					'碳积分': '/pages/mine/index',
					'预约维保': '/pages/work/index'
				};
				if (pageMap[title]) {
					uni.switchTab({ url: pageMap[title] });
				} else {
					uni.showToast({ title: `即将跳转至${title}`, icon: "none" });
				}
			}
		}
	};
</script>

<style scoped>
	/* 轮播图 */
	.con1 {
		margin-bottom: 30rpx;
		margin-left: -20rpx;
		margin-right: -20rpx;
	}
	.con1-swiper {
		width: 100%;
		height: 400rpx;
	}
	.con1-img {
		width: 100%;
		height: 400rpx;
	}
	.page-container {
		background-color: #f2f7fe;
		
		min-height: 100vh;
		padding: 0 20rpx 40rpx 20rpx;
	}
	.user-card {
		background: #fff;
		border-radius: 20rpx 20rpx 0 0;
		padding: 24rpx;
		display: flex;
		justify-content: space-between;
		align-items: center;
		border-bottom: 1rpx solid #f5f5f5;
	}
	.nav-grid {
		background-color: #fff;
		display: flex;
		justify-content: space-around;
		padding: 30rpx 0 40rpx;
		border-radius: 0 0 20rpx 20rpx;
		margin-bottom: 30rpx;
	}
	.user-left {
		display: flex;
		align-items: center;
	}
	.avatar-circle {
		width: 70rpx;
		height: 70rpx;
		border-radius: 50%;
		margin-left: 20rpx;
	}
	.user-info {
		display: flex;
		flex-direction: column;
		margin-left: 30rpx;
	}
	.user-name {
		font-size: 32rpx;
		font-weight: bold;
		color: black;
	}
	.user-phone {
		font-size: 28rpx;
		color: black;
		margin-top: 10rpx;
	}
	.user-right {
		display: flex;
		flex-direction: column;
		align-items: flex-start;
		color: black;
		margin-right: 80rpx;
	}
	.points-label {
		font-size: 25rpx;
		opacity: 0.9;
	}
	.points-num {
		font-size: 45rpx;
		font-weight: bold;
		margin-bottom: 10rpx;
		color: #65b262;
	}
	.nav-item {
		display: flex;
		flex-direction: column;
		align-items: center;
	}
	.nav-icon {
		width: 80rpx;
		height: 80rpx;
		border-radius: 50%;
		display: flex;
		align-items: center;
		justify-content: center;
		margin-bottom: 12rpx;
	}
	.nav-icon-img {
		width: 45rpx;
		height: 45rpx;
	}
	.icon-green { background-color: #e8f5e9; }
	.icon-orange { background-color: #fff3e0; }
	.icon-blue { background-color: #e3f2fd; }
	.icon-purple { background-color: #f3e5f5; }
	.nav-text {
		font-size: 26rpx;
		color: #333;
		font-weight: 500;
	}
	.tab-bar {
		/* background-color: #f5f6fa; */
		background-color: #f2f7fe;
		display: flex;
		justify-content: space-around;
		padding: 16rpx 0;
		border-bottom: 1px solid #f0f0f0;
	}
	.tab-item {
		position: relative;
		padding: 10rpx 0;
		display: flex;
		flex-direction: column;
		align-items: center;
	}
	.tab-text {
		font-size: 30rpx;
		color: #666;
		font-weight: 500;
	}
	.tab-text.active {
		color: #222;
		font-weight: bold;
	}
	.tab-line {
		position: absolute;
		bottom: 0;
		width: 40rpx;
		height: 4rpx;
		background-color: #ff9800;
		border-radius: 2rpx;
	}
	.content-area {
		padding: 20rpx;
	}
	.card-item {
		background: #fff;
		border-radius: 20rpx;
		padding: 24rpx;
		margin-bottom: 20rpx;
		box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.03);
	}
	.card-header {
		display: flex;
		align-items: center;
		gap: 16rpx;
		margin-bottom: 10rpx;
	}
	.tag {
		padding: 4rpx 16rpx;
		border-radius: 6rpx;
		font-size: 22rpx;
		font-weight: bold;
		color: #333;
	}
	.date {
		font-size: 24rpx;
		color: #999;
	}
	.card-title {
		display: block;
		font-size: 32rpx;
		font-weight: bold;
		color: #222;
		margin-bottom: 8rpx;
	}
	.card-desc {
		display: block;
		font-size: 26rpx;
		color: #666;
		line-height: 1.4;
	}
	/* 购车卡片样式 */
	.car-card-item {
		background: #fff;
		border-radius: 20rpx;
		margin-bottom: 20rpx;
		overflow: hidden;
		box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.05);
	}
	.card-full-video {
		width: 100%;
		height: 360rpx;
		background-color: #000;
	}
	.car-info {
		padding: 20rpx;
	}
	.car-name {
		font-size: 32rpx;
		font-weight: bold;
		color: #222;
		display: block;
		margin-bottom: 10rpx;
	}
	.car-price-row {
		display: flex;
		align-items: baseline;
	}
	.price-symbol {
		font-size: 28rpx;
		font-weight: bold;
		color: #ff5252;
	}
	.price-num {
		font-size: 40rpx;
		font-weight: bold;
		color: #ff5252;
	}
	.price-unit {
		font-size: 26rpx;
		color: #ff5252;
	}
</style>