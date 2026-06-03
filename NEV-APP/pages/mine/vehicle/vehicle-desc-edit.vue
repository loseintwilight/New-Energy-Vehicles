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
					<text class="header-title">编辑描述</text>
					<text class="header-sub">{{ vehicleName }}</text>
				</view>
				<view class="header-right" @tap="saveDesc">
					<text class="save-text">保存</text>
				</view>
			</view>

			<!-- 快捷模板 -->
			<view class="template-section">
				<text class="template-label">快捷模板</text>
				<view class="template-grid">
					<view class="template-item" v-for="(tpl, idx) in templates" :key="idx" @tap="applyTemplate(tpl)">
						<text class="template-title">{{ tpl.title }}</text>
						<text class="template-preview">{{ tpl.preview }}</text>
					</view>
				</view>
			</view>

			<!-- 编辑区 -->
			<view class="edit-section">
				<view class="section-title">
					<view class="title-line"></view>
					<text class="title-text">车辆描述</text>
				</view>
				<view class="edit-card">
					<textarea class="edit-textarea" v-model="description" placeholder="请输入车辆描述..." placeholder-class="edit-placeholder" :maxlength="2000" :auto-height="true" />
					<view class="edit-toolbar">
						<text class="toolbar-count">{{ description.length }}/2000</text>
						<view class="toolbar-actions">
							<text class="tool-btn" @tap="clearDesc">清空</text>
							<text class="tool-btn" @tap="previewDesc">预览</text>
						</view>
					</view>
				</view>
			</view>

			<!-- 亮点功能 -->
			<view class="info-section">
				<view class="section-title">
					<view class="title-line line-green"></view>
					<text class="title-text">亮点功能</text>
				</view>
				<view class="highlight-card">
					<view class="highlight-item" v-for="(item, idx) in highlights" :key="idx">
						<view class="highlight-dot"></view>
						<text class="highlight-text">{{ item }}</text>
						<text class="highlight-del" @tap="removeHighlight(idx)">×</text>
					</view>
					<view class="highlight-add" @tap="addHighlight">
						<text class="highlight-add-icon">+</text>
						<text class="highlight-add-text">添加亮点</text>
					</view>
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
			vehicleName: '比亚迪 汉EV',
			description: '',
			templates: [
				{ title: '豪华轿车', preview: '集豪华、科技与性能于一身...', text: '集豪华、科技与性能于一身的中大型纯电轿车。搭载最新一代电池技术，续航里程优异，百公里加速表现出色。配备智能驾驶辅助系统，让出行更加安全便捷。' },
				{ title: '智能SUV', preview: '智能科技与舒适空间的完美结合...', text: '智能科技与舒适空间的完美结合。超大车内空间，满足全家出行需求。搭载先进的智能座舱系统，支持语音控制、自动泊车等功能，让驾驶更轻松。' },
				{ title: '性能跑车', preview: '极致的速度与操控体验...', text: '极致的速度与操控体验。采用轻量化车身设计，配合高性能电机，带来令人血脉偾张的加速感受。精准的底盘调校，让每一次过弯都充满信心。' }
			],
			highlights: ['超长续航715km', '刀片电池安全可靠', 'DiPilot智能驾驶', '豪华内饰配置']
		}
	},
	onLoad(options) {
		if (options.vehicleId) {
			console.log('车辆ID:', options.vehicleId)
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
		applyTemplate(tpl) { this.description = tpl.text },
		clearDesc() { this.description = '' },
		previewDesc() { uni.showToast({ title: '预览功能', icon: 'none', duration: 1500 }) },
		saveDesc() { uni.showToast({ title: '保存成功', icon: 'success' }) },
		addHighlight() { uni.showToast({ title: '添加亮点', icon: 'none', duration: 1500 }) },
		removeHighlight(idx) { this.highlights.splice(idx, 1) }
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
.save-text { font-size: 28rpx; color: #f59e0b; font-weight: 600; }

.template-section { margin: 0 24rpx 20rpx; }
.template-label { font-size: 24rpx; color: #a8a29e; margin-bottom: 12rpx; display: block; }
.template-grid { display: flex; gap: 12rpx; }
.template-item { flex: 1; background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 16rpx; padding: 16rpx; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.04); }
.template-title { font-size: 24rpx; font-weight: 600; color: #f59e0b; display: block; margin-bottom: 4rpx; }
.template-preview { font-size: 20rpx; color: #a8a29e; display: block; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }

.info-section { margin: 0 24rpx 20rpx; }
.edit-section { margin: 0 24rpx 20rpx; }
.section-title { display: flex; align-items: center; margin-bottom: 16rpx; }
.title-line { width: 6rpx; height: 32rpx; border-radius: 3rpx; background: linear-gradient(180deg, #f59e0b, #f97316); margin-right: 12rpx; }
.line-green { background: linear-gradient(180deg, #22c55e, #16a34a); }
.title-text { font-size: 30rpx; font-weight: 700; color: #1c1917; }

.edit-card { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 24rpx; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.edit-textarea { width: 100%; min-height: 300rpx; font-size: 26rpx; color: #1c1917; line-height: 1.8; }
.edit-placeholder { color: #a8a29e; }
.edit-toolbar { display: flex; justify-content: space-between; align-items: center; margin-top: 16rpx; padding-top: 16rpx; border-top: 1rpx solid #f5f5f4; }
.toolbar-count { font-size: 22rpx; color: #a8a29e; }
.toolbar-actions { display: flex; gap: 16rpx; }
.tool-btn { font-size: 24rpx; color: #f59e0b; }

.highlight-card { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 16rpx 24rpx; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.highlight-item { display: flex; align-items: center; padding: 14rpx 0; border-bottom: 1rpx solid #f5f5f4; }
.highlight-item:last-child { border-bottom: none; }
.highlight-dot { width: 10rpx; height: 10rpx; border-radius: 5rpx; background: #f59e0b; margin-right: 12rpx; flex-shrink: 0; }
.highlight-text { flex: 1; font-size: 26rpx; color: #1c1917; }
.highlight-del { font-size: 28rpx; color: #a8a29e; padding: 4rpx 8rpx; }
.highlight-add { display: flex; align-items: center; justify-content: center; padding: 14rpx 0; }
.highlight-add-icon { font-size: 28rpx; color: #f59e0b; margin-right: 8rpx; }
.highlight-add-text { font-size: 24rpx; color: #f59e0b; }
</style>