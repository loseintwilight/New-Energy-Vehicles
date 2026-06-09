<template>
	<view class="page" :class="{ 'page-ready': isReady }">
		<view class="glow-matrix">
			<view class="glow-row" v-for="(row, ri) in glowRows" :key="ri">
				<view class="glow-spot" v-for="(dot, ci) in row.dots" :key="ci" :style="dot.style"></view>
			</view>
		</view>
		<view class="overlay-mask"></view>

		<scroll-view scroll-y class="main-scroll" :show-scrollbar="false">
			<!-- 顶栏（琥珀渐变） -->
			<view class="header">
				<view class="header-bg"></view>
				<view class="header-circle"></view>
				<view class="back-btn" hover-class="btn-hover" @tap="goBack">
					<text class="back-icon">‹</text>
				</view>
				<view class="header-info">
					<text class="header-title">编辑描述</text>
					<text class="header-sub">{{ vehicleName }}</text>
				</view>
				<view class="header-right" hover-class="preview-hover" @tap="togglePreview">
					<text class="preview-text">{{ showPreview ? '编辑' : '预览' }}</text>
				</view>
			</view>

			<!-- 工具栏 -->
			<view class="toolbar">
				<view class="tool-btn" hover-class="tool-hover" @tap="insertTag('strong', 'strong')">
					<text class="tool-icon">B</text>
					<text class="tool-label">加粗</text>
				</view>
				<view class="tool-btn" hover-class="tool-hover" @tap="insertTag('em', 'em')">
					<text class="tool-icon ti-italic">I</text>
					<text class="tool-label">斜体</text>
				</view>
				<view class="tool-btn" hover-class="tool-hover" @tap="insertTag('h2', 'h2')">
					<text class="tool-icon">H₂</text>
					<text class="tool-label">标题</text>
				</view>
				<view class="tool-divider"></view>
				<view class="tool-btn" hover-class="tool-hover" @tap="insertTag('blockquote', 'blockquote')">
					<text class="tool-icon">❝</text>
					<text class="tool-label">引用</text>
				</view>
				<view class="tool-btn" hover-class="tool-hover" @tap="insertList('ul')">
					<text class="tool-icon">•</text>
					<text class="tool-label">无序</text>
				</view>
				<view class="tool-btn" hover-class="tool-hover" @tap="insertList('ol')">
					<text class="tool-icon">1.</text>
					<text class="tool-label">有序</text>
				</view>
			</view>

			<!-- 编辑区域 -->
			<view v-if="!showPreview" class="section-block sb-edit">
				<view class="title-bar">
					<view class="bar-line"></view>
					<view class="icon-wrap iw-amber"><text class="bar-icon">✏️</text></view>
					<text class="bar-title">编辑内容</text>
				</view>
				<view class="edit-card">
					<textarea id="descInput" :value="descContent" @input="onInput" class="desc-textarea" placeholder="请输入车辆详细描述..." placeholder-class="placeholder-style" :maxlength="3000" :auto-height="true" />
					<view class="char-count">
						<text>{{ (descContent || '').length }}/3000</text>
					</view>
				</view>
			</view>

			<!-- 预览区域 -->
			<view v-else class="section-block sb-preview">
				<view class="title-bar">
					<view class="bar-line bar-line-preview"></view>
					<view class="icon-wrap iw-preview"><text class="bar-icon">👁</text></view>
					<text class="bar-title">预览效果</text>
				</view>
				<view class="preview-card">
					<rich-text v-if="safeDesc" :nodes="safeDesc" class="rich-content"></rich-text>
					<view v-else class="preview-empty">
						<text>暂无内容</text>
					</view>
				</view>
			</view>

			<!-- 模板快捷区 -->
			<view class="section-block sb-tpl">
				<view class="title-bar">
					<view class="bar-line bar-line-tpl"></view>
					<view class="icon-wrap iw-tpl"><text class="bar-icon">📋</text></view>
					<text class="bar-title">常用模板</text>
				</view>
				<view class="tpl-list">
					<view class="tpl-item" v-for="(tpl, idx) in templates" :key="idx" hover-class="tpl-hover" @tap="applyTemplate(idx)">
						<view class="tpl-color-bar"></view>
						<view class="tpl-info">
							<text class="tpl-name">{{ tpl.name }}</text>
							<text class="tpl-preview">{{ tpl.preview }}</text>
						</view>
						<text class="tpl-arrow">›</text>
					</view>
				</view>
			</view>

			<view style="height: 140rpx;"></view>
		</scroll-view>

		<!-- 底部操作栏 -->
		<view class="fixed-bottom-bar">
			<view class="btn-row">
				<view class="action-btn btn-clear" hover-class="clear-hover" @tap="clearContent">
					<text>清空</text>
				</view>
				<view class="action-btn btn-save" hover-class="save-hover" @tap="saveDesc">
					<text>保存描述</text>
				</view>
			</view>
		</view>
	</view>
</template>

<script>
var USE_MOCK = false

import request from '@/utils/request'

export default {
	data: function() {
		return {
			isReady: false,
			glowRows: [],
			vehicleId: '',
			vehicleName: '车辆详情',
			descContent: '',
			showPreview: false,
			templates: [
				{
					name: '核心卖点模板',
					preview: '车型概述 + 核心配置 + 产品亮点',
					content: '<h2>【核心卖点】</h2><p>本车为2025年最新款新能源车型，搭载行业领先的三电系统。</p><p><strong>核心配置：</strong></p><ul><li>超长续航里程，满足日常出行需求</li><li>大容量电池组，支持快充技术</li><li>智能驾驶辅助系统，安全出行有保障</li></ul>'
				},
				{
					name: '配置亮点模板',
					preview: '动力参数 + 智能科技 + 舒适配置',
					content: '<h2>【配置亮点】</h2><p><strong>动力性能：</strong>高性能电机驱动，百公里加速表现出色。</p><blockquote>智能座舱系统，支持语音交互与远程控制。</blockquote><p><strong>舒适配置：</strong></p><ul><li>全景天窗设计，采光通透</li><li>真皮座椅 + 多向调节</li><li>品牌音响系统，沉浸式体验</li></ul>'
				},
				{
					name: '售后服务模板',
					preview: '质保政策 + 保养服务 + 客户权益',
					content: '<h2>【售后服务】</h2><p>我们为您提供全方位的售后保障服务：</p><ul><li><strong>整车质保：</strong>享受XX年/XX万公里整车质保</li><li><strong>电池保障：</strong>电池组享XX年质保政策</li><li><strong>免费保养：</strong>首任车主赠送X次免费常规保养</li><li><strong>道路救援：</strong>24小时道路救援服务</li></ul><blockquote>购车即送充电桩安装服务，让您用车无忧！</blockquote>'
				}
			]
		}
	},
	computed: {
		safeDesc: function() {
			return this.filterXss(this.descContent)
		}
	},
	onLoad: function(options) {
		var that = this
		if (options && options.vehicleId) {
			that.vehicleId = options.vehicleId
		}
		if (options && options.currentDesc) {
			try {
				that.descContent = decodeURIComponent(options.currentDesc)
			} catch(e) {
				that.descContent = ''
			}
		}
		if (options && options.vehicleName) {
			try {
				that.vehicleName = decodeURIComponent(options.vehicleName)
			} catch(e) {}
		}
		this.buildGlowRows()
		setTimeout(function() { that.isReady = true }, 200)
	},
	methods: {
		buildGlowRows: function() {
			var rows = []
			var colors = ['#f59e0b', '#f97316', '#fb923c', '#fbbf24', '#fcd34d', '#fde68a']
			for (var r = 0; r < 8; r++) {
				var dots = []
				var count = 3 + Math.floor(Math.random() * 3)
				for (var c = 0; c < count; c++) {
					var color = colors[Math.floor(Math.random() * colors.length)]
					var size = 60 + Math.floor(Math.random() * 80)
					var dur = 2.5 + Math.random() * 2.5
					var delay = Math.random() * 2.5
					var alpha = 0.06 + Math.random() * 0.16
					dots.push({
						style: 'width:' + size + 'rpx;height:' + size + 'rpx;background:radial-gradient(circle,' + color + ',' + color + '00);opacity:' + alpha.toFixed(2) + ';animation-duration:' + dur.toFixed(1) + 's;animation-delay:' + delay.toFixed(1) + 's;'
					})
				}
				rows.push({ dots: dots })
			}
			this.glowRows = rows
		},

		onInput: function(e) {
			this.descContent = e.detail.value || ''
		},

		insertTag: function(openTag, closeTag) {
			var self = this
			var labelMap = { strong: '加粗文字', em: '斜体文字', h2: '标题文字', blockquote: '引用内容' }
			uni.showModal({
				title: '插入格式',
				content: '请输入要格式化的文字',
				editable: true,
				placeholderText: '输入文字',
				success: function(res) {
					if (res.confirm && res.content) {
						self.descContent += '<' + openTag + '>' + res.content + '</' + closeTag + '>\n'
					}
				}
			})
		},

		insertList: function(type) {
			var self = this
			var title = type === 'ul' ? '无序列表' : '有序列表'
			uni.showModal({
				title: '插入' + title,
				content: '请输入列表项（每行一个）',
				editable: true,
				placeholderText: '第一项\n第二项\n第三项',
				success: function(res) {
					if (res.confirm && res.content) {
						var lines = res.content.split('\n').filter(function(line) { return line.trim() !== '' })
						var tag = type === 'ul' ? 'li' : 'li'
						var html = '<' + type + '>\n'
						for (var i = 0; i < lines.length; i++) {
							html += '<' + tag + '>' + lines[i].trim() + '</' + tag + '>\n'
						}
						html += '</' + type + '>\n'
						self.descContent += html
					}
				}
			})
		},

		filterXss: function(html) {
			if (!html) return ''
			var safe = String(html)
			safe = safe.replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '')
			safe = safe.replace(/on\w+\s*=/gi, '')
			return safe
		},

		togglePreview: function() {
			this.showPreview = !this.showPreview
		},

		applyTemplate: function(index) {
			var self = this
			var tpl = self.templates[index]
			if (!tpl) return
			uni.showModal({
				title: '应用模板',
				content: '确定要使用「' + tpl.name + '」吗？当前内容将被替换。',
				success: function(res) {
					if (res.confirm) {
						self.descContent = tpl.content
						uni.showToast({ title: '已应用模板', icon: 'success' })
					}
				}
			})
		},

		clearContent: function() {
			var self = this
			if (!self.descContent.trim()) return
			uni.showModal({
				title: '确认清空',
				content: '确定要清空所有内容吗？',
				success: function(res) {
					if (res.confirm) {
						self.descContent = ''
					}
				}
			})
		},

		saveDesc: function() {
			var self = this
			if (!self.descContent.trim()) {
				uni.showToast({ title: '请输入描述内容', icon: 'none' })
				return
			}
			if (USE_MOCK) {
				uni.showLoading({ title: '保存中...' })
				setTimeout(function() {
					uni.hideLoading()
					try {
						var pages = getCurrentPages()
						var prevPage = pages[pages.length - 2]
						if (prevPage && prevPage.$vm && prevPage.$vm.onDescUpdated) {
							prevPage.$vm.onDescUpdated(self.vehicleId, self.descContent)
						}
					} catch(e) {}
					uni.showToast({ title: '保存成功', icon: 'success' })
					setTimeout(function() { uni.navigateBack() }, 1200)
				}, 600)
			} else {
				uni.showLoading({ title: '保存中...' })
				request({
					url: '/merchant/vehicle',
					method: 'put',
					data: { vehicleId: self.vehicleId, description: self.descContent }
				}).then(function(res) {
					uni.hideLoading()
					if (res.code === 1) {
						uni.showToast({ title: '保存成功', icon: 'success' })
						setTimeout(function() { uni.navigateBack() }, 1200)
					} else {
						uni.showToast({ title: res.msg || '保存失败', icon: 'none' })
					}
				}).catch(function() {
					uni.hideLoading()
					uni.showToast({ title: '网络异常', icon: 'none' })
				})
			}
		},

		goBack: function() {
			uni.navigateBack({ delta: 1 })
		}
	}
}
</script>

<style scoped>
/* ========== 页面容器 ========== */
.page { min-height: 100vh; background: linear-gradient(180deg, #fff7ed 0%, #fffbeb 30%, #fefce8 60%, #fffbeb 100%); position: relative; overflow-x: hidden; opacity: 0; transition: opacity 0.5s ease; }
.page-ready { opacity: 1; }
.page-ready .header { animation: fadeSlideUp 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.05s; }
.page-ready .toolbar { animation: fadeSlideUp 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.12s; }
.page-ready .section-block:nth-of-type(1) { animation: fadeSlideUp 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.19s; }
.page-ready .section-block:nth-of-type(2) { animation: fadeSlideUp 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.26s; }

@keyframes fadeSlideUp { from { opacity: 0; transform: translateY(30rpx) scale(0.96); } to { opacity: 1; transform: translateY(0) scale(1); } }

/* ========== 背景光晕矩阵 ========== */
.glow-matrix { position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 0; overflow: hidden; pointer-events: none; }
.glow-row { display: flex; justify-content: space-around; align-items: center; padding: 24rpx 20rpx; }
.glow-spot { border-radius: 50%; flex-shrink: 0; animation: glowPulse ease-in-out infinite alternate; }
@keyframes glowPulse { 0% { opacity: 0.12; transform: scale(0.85); } 50% { opacity: 0.55; } 100% { opacity: 0.12; transform: scale(1.25); } }

.overlay-mask { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: linear-gradient(180deg, rgba(255,247,237,0.92) 0%, rgba(255,251,235,0.95) 35%, rgba(254,252,232,0.96) 65%, rgba(255,251,235,0.97) 100%); pointer-events: none; z-index: 1; }
.main-scroll { position: relative; z-index: 2; height: 100vh; }

/* ========== 顶栏（琥珀渐变） ========== */
.header { position: relative; padding: 28rpx 28rpx 24rpx; display: flex; align-items: center; overflow: hidden; }
.header-bg { position: absolute; top: -80rpx; left: -40rpx; right: -40rpx; bottom: -20rpx; background: linear-gradient(135deg, #f59e0b 0%, #f97316 35%, #fb923c 65%, #fdba74 100%); border-radius: 0 0 60rpx 60rpx; }
.header-circle { position: absolute; top: -50rpx; right: -30rpx; width: 300rpx; height: 300rpx; border-radius: 50%; background: radial-gradient(circle, rgba(255,255,255,0.15) 0%, transparent 70%); pointer-events: none; }
.back-btn { width: 64rpx; height: 64rpx; border-radius: 32rpx; background: rgba(255,255,255,0.3); backdrop-filter: blur(12px); -webkit-backdrop-filter: blur(12px); display: flex; align-items: center; justify-content: center; z-index: 2; box-shadow: 0 4rpx 14rpx rgba(0,0,0,0.1); transition: all 0.2s ease; }
.btn-hover { transform: scale(0.9); background: rgba(255,255,255,0.45); }
.back-icon { font-size: 36rpx; color: #ffffff; font-weight: 300; }
.header-info { flex: 1; margin-left: 20rpx; z-index: 2; display: flex; flex-direction: column; }
.header-title { font-size: 38rpx; font-weight: 800; color: #ffffff; letter-spacing: 1rpx; text-shadow: 0 2rpx 8rpx rgba(0,0,0,0.1); }
.header-sub { font-size: 24rpx; color: rgba(255,255,255,0.88); margin-top: 6rpx; font-weight: 500; }
.header-right { z-index: 2; }
.preview-text { font-size: 28rpx; color: #ffffff; font-weight: 600; padding: 10rpx 20rpx; border-radius: 16rpx; background: rgba(255,255,255,0.2); transition: all 0.2s ease; }
.preview-hover { background: rgba(255,255,255,0.35)!important; }

/* ========== 工具栏 ========== */
.toolbar { display: flex; align-items: center; padding: 18rpx 24rpx; margin: 0 24rpx; background: rgba(255,255,255,0.85); backdrop-filter: blur(14px); -webkit-backdrop-filter: blur(14px); border-radius: 20rpx; gap: 10rpx; position: relative; z-index: 2; box-shadow: 0 4rpx 16rpx rgba(245,158,11,0.08), inset 0 1rpx 0 rgba(255,255,255,0.9); border: 1rpx solid rgba(255,255,255,0.75); }
.tool-btn { display: flex; align-items: center; gap: 6rpx; padding: 12rpx 18rpx; border-radius: 12rpx; background: linear-gradient(135deg, rgba(254,251,236,0.98), rgba(255,255,255,1)); border: 1.5rpx solid rgba(245,158,11,0.08); transition: all 0.15s ease; }
.tool-hover { transform: scale(0.95)!important; background: linear-gradient(135deg, rgba(245,158,11,0.1), rgba(251,146,60,0.05))!important; border-color: rgba(245,158,11,0.2)!important; }
.tool-icon { font-size: 28rpx; font-weight: 800; color: #d97706; width: 36rpx; text-align: center; }
.ti-italic { font-style: italic; font-family: Georgia, serif; }
.tool-label { font-size: 21rpx; color: #92400e; font-weight: 600; white-space: nowrap; }
.tool-divider { width: 1.5rpx; height: 36rpx; background: linear-gradient(180deg, transparent, rgba(217,119,6,0.2), transparent); margin: 0 6rpx; flex-shrink: 0; }

/* ========== 区块通用 ========== */
.section-block { margin: 0 24rpx 20rpx; background: rgba(255,255,255,0.82); backdrop-filter: blur(16px); -webkit-backdrop-filter: blur(16px); border-radius: 24rpx; padding: 22rpx 20rpx; box-shadow: 0 6rpx 28rpx rgba(0,0,0,0.05), inset 0 1rpx 0 rgba(255,255,255,0.9); border: 1rpx solid rgba(255,255,255,0.8); position: relative; z-index: 2; overflow: hidden; }
.title-bar { display: flex; align-items: center; margin-bottom: 18rpx; }
.bar-line { width: 7rpx; height: 32rpx; border-radius: 4px; margin-right: 12rpx; background: linear-gradient(180deg, #f59e0b, #f97316); box-shadow: 0 0 12rpx rgba(245,158,11,0.35); }
.bar-line-preview { background: linear-gradient(180deg, #d97706, #f59e0b); box-shadow: 0 0 12rpx rgba(217,119,6,0.35); }
.bar-line-tpl { background: linear-gradient(180deg, #f59e0b, #fb923c); box-shadow: 0 0 12rpx rgba(245,158,11,0.35); }
.icon-wrap { width: 44rpx; height: 44rpx; border-radius: 12rpx; display: flex; align-items: center; justify-content: center; margin-right: 12rpx; }
.iw-amber { background: linear-gradient(135deg, rgba(245,158,11,0.15), rgba(251,146,60,0.08)); }
.iw-preview { background: linear-gradient(135deg, rgba(217,119,6,0.15), rgba(245,158,11,0.08)); }
.iw-tpl { background: linear-gradient(135deg, rgba(245,158,11,0.15), rgba(251,146,60,0.08)); }
.bar-icon { font-size: 24rpx; }
.bar-title { font-size: 29rpx; font-weight: 800; color: #1c1917; letter-spacing: 0.5rpx; }

/* ========== 编辑区 ========== */
.edit-card { background: linear-gradient(135deg, rgba(254,251,236,0.98), rgba(255,255,255,1)); border-radius: 16rpx; padding: 18rpx 20rpx; border: 1rpx solid rgba(245,158,11,0.08); }
.desc-textarea { width: 100%; min-height: 360rpx; font-size: 27rpx; line-height: 1.85; color: #1c1917; font-weight: 400; }
.placeholder-style { color: #bbbbbb; font-size: 27rpx; }
.char-count { text-align: right; padding-top: 14rpx; border-top: 1rpx dashed rgba(0,0,0,0.06); margin-top: 14rpx; }
.char-count text { font-size: 22rpx; color: #a8a29e; font-weight: 500; }

/* ========== 预览区 ========== */
.preview-card { background: linear-gradient(135deg, rgba(254,251,236,0.98), rgba(255,255,255,1)); border-radius: 16rpx; padding: 18rpx 20rpx; border: 1rpx solid rgba(245,158,11,0.06); min-height: 360rpx; }
.rich-content { font-size: 26rpx; color: #44403c; line-height: 1.85; }
.rich-content >>> h2 { font-size: 30rpx; font-weight: 800; color: #1e40af; margin: 16rpx 0 10rpx; }
.rich-content >>> strong { color: #1c1917; font-weight: 700; }
.rich-content >>> blockquote { border-left: 5rpx solid #f59e0b; padding-left: 16rpx; margin: 12rpx 0; color: #78716c; background: rgba(245,158,11,0.04); border-radius: 0 10rpx 10rpx 0; }
.rich-content >>> ul, .rich-content >>> ol { padding-left: 28rpx; margin: 10rpx 0; }
.rich-content >>> li { line-height: 1.8; color: #44403c; }
.preview-empty { display: flex; align-items: center; justify-content: center; min-height: 280rpx; color: #cccccc; font-size: 27rpx; }

/* ========== 模板区 ========== */
.tpl-list { display: flex; flex-direction: column; gap: 14rpx; }
.tpl-item { display: flex; align-items: center; padding: 22rpx 20rpx; background: linear-gradient(135deg, rgba(254,251,236,0.95), rgba(255,255,255,1)); border-radius: 16rpx; border: 1.5rpx solid rgba(245,158,11,0.05); position: relative; overflow: hidden; transition: all 0.15s ease; }
.tpl-hover { transform: scale(0.98)!important; background: linear-gradient(135deg, rgba(245,158,11,0.06), rgba(251,146,60,0.03))!important; border-color: rgba(245,158,11,0.15)!important; }
.tpl-color-bar { position: absolute; left: 0; top: 0; bottom: 0; width: 5rpx; background: linear-gradient(180deg, #d97706, #f59e0b); border-radius: 0 4rpx 4rpx 0; }
.tpl-info { flex: 1; padding-left: 18rpx; }
.tpl-name { font-size: 27rpx; color: #1c1917; font-weight: 700; display: block; margin-bottom: 6rpx; }
.tpl-preview { font-size: 22rpx; color: #999999; display: block; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; max-width: 340rpx; }
.tpl-arrow { font-size: 34rpx; color: #cccccc; font-weight: 300; padding-left: 12rpx; flex-shrink: 0; }

/* ========== 底部操作栏 ========== */
.fixed-bottom-bar { position: fixed; left: 0; right: 0; bottom: 0; background: rgba(255,255,255,0.95); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px); padding: 16rpx 28rpx calc(16rpx + env(safe-area-inset-bottom)); box-shadow: 0 -4rpx 30rpx rgba(0,0,0,0.08), 0 0 40rpx rgba(245,158,11,0.08); border-top: 1.5rpx solid rgba(245,158,11,0.1); z-index: 100; }
.btn-row { display: flex; gap: 20rpx; }
.action-btn { flex: 1; border-radius: 46rpx; padding: 24rpx 0; text-align: center; font-size: 28rpx; font-weight: 700; transition: all 0.15s cubic-bezier(0.34, 1.56, 0.64, 1); }
.action-btn::after { border: none; }
.btn-clear { color: #78716c; background: linear-gradient(135deg, #fefaf3, #fff5eb); border: 2rpx solid rgba(217,119,6,0.25); box-shadow: 0 2rpx 8rpx rgba(217,119,6,0.08); }
.clear-hover { transform: scale(0.96)!important; background: linear-gradient(135deg, #eeeeee, #e0e0e0)!important; }
.btn-save { color: #ffffff; background: linear-gradient(135deg, #f59e0b 0%, #f97316 45%, #fb923c 100%); box-shadow: 0 8rpx 28rpx rgba(245,158,11,0.4), 0 3rpx 10rpx rgba(245,158,11,0.2); }
.save-hover { transform: scale(0.96)!important; box-shadow: 0 4rpx 18rpx rgba(245,158,11,0.5), 0 2rpx 12rpx rgba(245,158,11,0.25)!important; }
</style>
