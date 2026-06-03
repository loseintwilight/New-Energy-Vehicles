<template>
	<view class="page" :class="{ 'page-ready': isReady }">
		<view class="glow-matrix">
			<view class="glow-row" v-for="(row, ri) in glowRows" :key="ri">
				<view class="glow-spot" v-for="(dot, ci) in row.dots" :key="ci" :style="dot.style"></view>
			</view>
		</view>
		<view class="overlay-mask"></view>

		<scroll-view scroll-y class="main-scroll" :show-scrollbar="false">
			<view class="header">
				<view class="header-bg"></view>
				<view class="back-btn" hover-class="btn-hover" @tap="goBack">
					<text class="back-icon">❮</text>
				</view>
				<view class="header-info">
					<text class="header-title">商户信息</text>
					<text class="header-sub">管理您的商户资料</text>
				</view>
				<view class="header-right" @tap="saveInfo">
					<text class="save-text">保存</text>
				</view>
			</view>

			<!-- 商户头像 -->
			<view class="avatar-section">
				<view class="avatar-wrap" @tap="changeAvatar">
					<text class="avatar-text">充</text>
					<view class="avatar-camera">
						<text>📷</text>
					</view>
				</view>
				<text class="avatar-tip">点击更换头像</text>
			</view>

			<!-- 基本信息 -->
			<view class="info-section">
				<view class="section-title">
					<view class="title-line"></view>
					<text class="title-text">基本信息</text>
				</view>
				<view class="info-card">
					<view class="info-row">
						<text class="info-label">商户名称</text>
						<input class="info-input" v-model="merchant.name" placeholder="请输入商户名称" />
					</view>
					<view class="info-row">
						<text class="info-label">联系人</text>
						<input class="info-input" v-model="merchant.contact" placeholder="请输入联系人" />
					</view>
					<view class="info-row">
						<text class="info-label">联系电话</text>
						<input class="info-input" v-model="merchant.phone" placeholder="请输入联系电话" type="number" />
					</view>
					<view class="info-row">
						<text class="info-label">营业时间</text>
						<input class="info-input" v-model="merchant.businessHours" placeholder="如：08:00-22:00" />
					</view>
				</view>
			</view>

			<!-- 经营信息 -->
			<view class="info-section">
				<view class="section-title">
					<view class="title-line line-green"></view>
					<text class="title-text">经营信息</text>
				</view>
				<view class="info-card">
					<view class="info-row">
						<text class="info-label">站点数量</text>
						<text class="info-value">{{ merchant.stationCount }} 个</text>
					</view>
					<view class="info-row">
						<text class="info-label">充电桩数</text>
						<text class="info-value">{{ merchant.pileCount }} 台</text>
					</view>
					<view class="info-row">
						<text class="info-label">注册时间</text>
						<text class="info-value">{{ merchant.registerDate }}</text>
					</view>
					<view class="info-row">
						<text class="info-label">商户等级</text>
						<text class="info-value level-tag">{{ merchant.level }}</text>
					</view>
				</view>
			</view>

			<!-- 账户安全 -->
			<view class="info-section">
				<view class="section-title">
					<view class="title-line line-blue"></view>
					<text class="title-text">账户安全</text>
				</view>
				<view class="info-card">
					<view class="info-row" @tap="changePassword">
						<text class="info-label">修改密码</text>
						<text class="info-arrow">❯</text>
					</view>
					<view class="info-row" @tap="bindPhone">
						<text class="info-label">绑定手机</text>
						<text class="info-value">{{ merchant.phone }}</text>
					</view>
					<view class="info-row" @tap="bindBank">
						<text class="info-label">结算银行卡</text>
						<text class="info-value">{{ merchant.bankCard }}</text>
					</view>
				</view>
			</view>

			<!-- 退出登录 -->
			<view class="logout-section">
				<view class="logout-btn" hover-class="btn-hover" @tap="logout">
					<text>退出登录</text>
				</view>
			</view>

			<view style="height: 120rpx;"></view>
		</scroll-view>
	</view>
</template>

<script>
export default {
	data() {
		return {
			isReady: false,
			glowRows: [],
			merchant: {
				name: '济南新能源充电服务有限公司',
				contact: '陈经理',
				phone: '186****8888',
				businessHours: '06:00-24:00',
				stationCount: '5',
				pileCount: '186',
				registerDate: '2025-03-15',
				level: '金牌商户',
				bankCard: '6222****1234'
			}
		}
	},
	created() {
		this.buildGlowRows()
		var self = this
		setTimeout(function() { self.isReady = true }, 200)
	},
	methods: {
		buildGlowRows() {
			var rows = []
			var colors = ['#f59e0b', '#f97316', '#fb923c', '#fbbf24']
			for (var r = 0; r < 5; r++) {
				var dots = []
				var count = 3 + Math.floor(Math.random() * 4)
				for (var c = 0; c < count; c++) {
					var color = colors[Math.floor(Math.random() * colors.length)]
					dots.push({ style: 'width:' + (3 + Math.floor(Math.random() * 6)) + 'px;height:' + (3 + Math.floor(Math.random() * 6)) + 'px;background:' + color + ';animation-duration:' + (2 + Math.random() * 3) + 's;animation-delay:' + Math.random() * 2 + 's;' })
				}
				rows.push({ dots: dots })
			}
			this.glowRows = rows
		},
		goBack() { uni.navigateBack() },
		saveInfo() { uni.showToast({ title: '保存成功', icon: 'success' }) },
		changeAvatar() { uni.showToast({ title: '更换头像', icon: 'none', duration: 1500 }) },
		changePassword() { uni.showToast({ title: '修改密码', icon: 'none', duration: 1500 }) },
		bindPhone() { uni.showToast({ title: '绑定手机', icon: 'none', duration: 1500 }) },
		bindBank() { uni.showToast({ title: '绑定银行卡', icon: 'none', duration: 1500 }) },
		logout() {
			uni.showModal({
				title: '确认退出',
				content: '确定要退出登录吗？',
				success: function(res) {
					if (res.confirm) {
						uni.showToast({ title: '已退出登录', icon: 'success' })
					}
				}
			})
		}
	}
}
</script>

<style scoped>
.page { min-height: 100vh; background: linear-gradient(180deg, #fff7ed 0%, #fffbeb 30%, #fefce8 60%, #fff7ed 100%); opacity: 0; transition: opacity 0.5s ease; }
.page-ready { opacity: 1; }
.glow-matrix { position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 0; overflow: hidden; pointer-events: none; }
.glow-row { display: flex; justify-content: space-around; padding: 20rpx 30rpx; }
.glow-spot { border-radius: 50%; filter: blur(6px); opacity: 0; animation: glowPulse ease-in-out infinite alternate; }
@keyframes glowPulse { 0% { opacity: 0; transform: scale(0.6); } 50% { opacity: 0.5; } 100% { opacity: 0; transform: scale(1.4); } }
.overlay-mask { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: linear-gradient(180deg, rgba(255,247,237,0.3) 0%, rgba(255,251,235,0.43) 38%, rgba(254,252,232,0.55) 66%, rgba(255,247,237,0.63) 100%); z-index: 1; pointer-events: none; }
.main-scroll { position: relative; z-index: 2; }

.header { position: relative; padding: 30rpx 28rpx 24rpx; display: flex; align-items: center; }
.header-bg { position: absolute; top: -60rpx; left: -40rpx; right: -40rpx; bottom: 0; background: radial-gradient(ellipse at 20% 30%, rgba(251,146,60,0.12) 0%, transparent 60%), radial-gradient(ellipse at 80% 50%, rgba(250,204,21,0.1) 0%, transparent 55%); border-radius: 0 0 60rpx 60rpx; }
.back-btn { width: 60rpx; height: 60rpx; border-radius: 30rpx; background: rgba(255,255,255,0.75); backdrop-filter: blur(10px); display: flex; align-items: center; justify-content: center; z-index: 1; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06); }
.back-icon { font-size: 28rpx; color: #92400e; }
.btn-hover { opacity: 0.7; transform: scale(0.95); }
.header-info { flex: 1; margin-left: 20rpx; z-index: 1; }
.header-title { font-size: 36rpx; font-weight: 700; color: #451a03; display: block; }
.header-sub { font-size: 24rpx; color: #a16207; margin-top: 4rpx; display: block; }
.header-right { z-index: 1; }
.save-text { font-size: 28rpx; color: #f59e0b; font-weight: 600; padding: 12rpx; }

/* 头像 */
.avatar-section { display: flex; flex-direction: column; align-items: center; padding: 32rpx 0; }
.avatar-wrap { width: 120rpx; height: 120rpx; border-radius: 60rpx; background: linear-gradient(135deg, #f59e0b, #f97316); display: flex; align-items: center; justify-content: center; position: relative; box-shadow: 0 8rpx 24rpx rgba(245,158,11,0.3); }
.avatar-text { font-size: 48rpx; font-weight: 700; color: #fff; }
.avatar-camera { position: absolute; bottom: 0; right: 0; width: 40rpx; height: 40rpx; border-radius: 20rpx; background: #fff; display: flex; align-items: center; justify-content: center; box-shadow: 0 2rpx 8rpx rgba(0,0,0,0.1); }
.avatar-camera text { font-size: 20rpx; }
.avatar-tip { font-size: 22rpx; color: #a8a29e; margin-top: 12rpx; }

/* 信息 */
.info-section { margin: 0 24rpx 20rpx; }
.section-title { display: flex; align-items: center; margin-bottom: 16rpx; }
.title-line { width: 6rpx; height: 28rpx; border-radius: 3rpx; background: linear-gradient(180deg, #f59e0b, #f97316); margin-right: 12rpx; }
.title-line.line-green { background: linear-gradient(180deg, #22c55e, #16a34a); }
.title-line.line-blue { background: linear-gradient(180deg, #3b82f6, #2563eb); }
.title-text { font-size: 28rpx; font-weight: 700; color: #1c1917; }
.info-card { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; overflow: hidden; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.info-row { display: flex; justify-content: space-between; align-items: center; padding: 24rpx; border-bottom: 1rpx solid #f5f5f4; }
.info-row:last-child { border-bottom: none; }
.info-label { font-size: 26rpx; color: #78716c; min-width: 140rpx; }
.info-input { flex: 1; font-size: 26rpx; color: #1c1917; text-align: right; }
.info-value { font-size: 26rpx; color: #1c1917; font-weight: 500; }
.info-arrow { font-size: 22rpx; color: #a8a29e; }
.level-tag { color: #f59e0b !important; font-weight: 700 !important; }

/* 退出 */
.logout-section { padding: 40rpx 24rpx; }
.logout-btn { background: rgba(239,68,68,0.08); border: 2rpx solid rgba(239,68,68,0.2); border-radius: 20rpx; padding: 24rpx; text-align: center; font-size: 28rpx; color: #dc2626; font-weight: 600; }
</style>