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
					<text class="header-title">添加车辆</text>
					<text class="header-sub">录入新车信息</text>
				</view>
				<view class="header-right" @tap="submitForm">
					<text class="submit-text">提交</text>
				</view>
			</view>

			<!-- 基本表单 -->
			<view class="info-section">
				<view class="section-title">
					<view class="title-line"></view>
					<text class="title-text">基本信息</text>
				</view>
				<view class="info-card">
					<view class="form-row">
						<text class="form-label">车型名称</text>
						<input class="form-input" v-model="form.name" placeholder="请输入车型名称" placeholder-class="form-placeholder" />
					</view>
					<view class="form-row">
						<text class="form-label">品牌</text>
						<input class="form-input" v-model="form.brand" placeholder="请输入品牌" placeholder-class="form-placeholder" />
					</view>
					<view class="form-row">
						<text class="form-label">车型类别</text>
						<picker class="form-picker" :range="typeOptions" @change="onTypeChange">
							<text class="picker-text" :class="{ placeholder: !form.type }">{{ form.type || '请选择车型类别' }}</text>
							<text class="picker-arrow">❯</text>
						</picker>
					</view>
					<view class="form-row">
						<text class="form-label">售价(元)</text>
						<input class="form-input" v-model="form.price" placeholder="请输入售价" placeholder-class="form-placeholder" type="number" />
					</view>
					<view class="form-row">
						<text class="form-label">初始库存</text>
						<input class="form-input" v-model="form.stock" placeholder="请输入库存数量" placeholder-class="form-placeholder" type="number" />
					</view>
				</view>
			</view>

			<!-- 性能参数 -->
			<view class="info-section">
				<view class="section-title">
					<view class="title-line line-green"></view>
					<text class="title-text">性能参数</text>
				</view>
				<view class="info-card">
					<view class="form-row">
						<text class="form-label">续航里程(km)</text>
						<input class="form-input" v-model="form.range" placeholder="请输入续航里程" placeholder-class="form-placeholder" type="number" />
					</view>
					<view class="form-row">
						<text class="form-label">电池容量</text>
						<input class="form-input" v-model="form.battery" placeholder="如：85.4kWh" placeholder-class="form-placeholder" />
					</view>
					<view class="form-row">
						<text class="form-label">电机功率</text>
						<input class="form-input" v-model="form.power" placeholder="如：180kW" placeholder-class="form-placeholder" />
					</view>
					<view class="form-row">
						<text class="form-label">百公里加速</text>
						<input class="form-input" v-model="form.acceleration" placeholder="如：3.9秒" placeholder-class="form-placeholder" />
					</view>
					<view class="form-row">
						<text class="form-label">最高时速</text>
						<input class="form-input" v-model="form.maxSpeed" placeholder="如：185km/h" placeholder-class="form-placeholder" />
					</view>
				</view>
			</view>

			<!-- 车辆描述 -->
			<view class="info-section">
				<view class="section-title">
					<view class="title-line line-blue"></view>
					<text class="title-text">车辆描述</text>
				</view>
				<view class="desc-card">
					<textarea class="desc-textarea" v-model="form.description" placeholder="请输入车辆描述信息..." placeholder-class="desc-placeholder" :maxlength="500" />
					<text class="desc-count">{{ form.description.length }}/500</text>
				</view>
			</view>

			<!-- 上传图片 -->
			<view class="info-section">
				<view class="section-title">
					<view class="title-line line-purple"></view>
					<text class="title-text">车辆图片</text>
				</view>
				<view class="upload-grid">
					<view class="upload-item" v-for="(img, idx) in uploadImages" :key="idx">
						<view class="upload-img" :style="{ background: img.bg }">
							<text class="upload-img-icon">{{ img.icon }}</text>
						</view>
					</view>
					<view class="upload-item upload-add" @tap="addImage">
						<text class="upload-add-icon">+</text>
						<text class="upload-add-text">添加图片</text>
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
			typeOptions: ['纯电动轿车', '纯电动SUV', '增程式SUV', '纯电动MPV', '纯电动跑车'],
			form: {
				name: '',
				brand: '',
				type: '',
				price: '',
				stock: '',
				range: '',
				battery: '',
				power: '',
				acceleration: '',
				maxSpeed: '',
				description: ''
			},
			uploadImages: [
				{ icon: '🚗', bg: 'linear-gradient(135deg, #fef3c7, #fde68a)' },
				{ icon: '📷', bg: 'linear-gradient(135deg, #dbeafe, #bfdbfe)' }
			]
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
		onTypeChange(e) {
			this.form.type = this.typeOptions[e.detail.value]
		},
		addImage() {
			uni.showToast({ title: '选择图片', icon: 'none', duration: 1500 })
		},
		submitForm() {
			if (!this.form.name) {
				uni.showToast({ title: '请输入车型名称', icon: 'none' })
				return
			}
			uni.showToast({ title: '提交成功', icon: 'success' })
			setTimeout(function() { uni.navigateBack() }, 1500)
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
.submit-text { font-size: 28rpx; color: #f59e0b; font-weight: 600; }

.info-section { margin: 0 24rpx 20rpx; }
.section-title { display: flex; align-items: center; margin-bottom: 16rpx; }
.title-line { width: 6rpx; height: 32rpx; border-radius: 3rpx; background: linear-gradient(180deg, #f59e0b, #f97316); margin-right: 12rpx; }
.line-green { background: linear-gradient(180deg, #22c55e, #16a34a); }
.line-blue { background: linear-gradient(180deg, #3b82f6, #2563eb); }
.line-purple { background: linear-gradient(180deg, #a855f7, #9333ea); }
.title-text { font-size: 30rpx; font-weight: 700; color: #1c1917; }

.info-card { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 8rpx 0; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); }
.form-row { display: flex; align-items: center; padding: 20rpx 24rpx; border-bottom: 1rpx solid #f5f5f4; }
.form-row:last-child { border-bottom: none; }
.form-label { width: 160rpx; font-size: 26rpx; color: #78716c; flex-shrink: 0; }
.form-input { flex: 1; font-size: 26rpx; color: #1c1917; text-align: right; }
.form-placeholder { color: #a8a29e; }
.form-picker { flex: 1; display: flex; align-items: center; justify-content: flex-end; }
.picker-text { font-size: 26rpx; color: #1c1917; }
.picker-text.placeholder { color: #a8a29e; }
.picker-arrow { font-size: 20rpx; color: #a8a29e; margin-left: 8rpx; }

.desc-card { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 24rpx; box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.04); position: relative; }
.desc-textarea { width: 100%; height: 200rpx; font-size: 26rpx; color: #1c1917; line-height: 1.6; }
.desc-placeholder { color: #a8a29e; }
.desc-count { text-align: right; font-size: 22rpx; color: #a8a29e; margin-top: 8rpx; display: block; }

.upload-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16rpx; }
.upload-item { width: 100%; aspect-ratio: 1; border-radius: 16rpx; overflow: hidden; }
.upload-img { width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; }
.upload-img-icon { font-size: 48rpx; }
.upload-add { background: rgba(255,255,255,0.85); backdrop-filter: blur(10px); border: 2rpx dashed #e5e7eb; display: flex; flex-direction: column; align-items: center; justify-content: center; }
.upload-add-icon { font-size: 48rpx; color: #a8a29e; }
.upload-add-text { font-size: 20rpx; color: #a8a29e; margin-top: 4rpx; }
</style>