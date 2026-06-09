<template>
	<view class="page">
		<!-- 顶部导航 -->
		<view class="header">
			<view class="back-btn" hover-class="btn-hover" @tap="goBack">
				<text class="back-icon">❮</text>
			</view>
			<text class="header-title">{{ isEdit ? '编辑客户' : '添加客户' }}</text>
		</view>

		<!-- 表单区域 -->
		<view class="form-card">
			<view class="form-item">
				<text class="form-label">姓名</text>
				<input class="form-input" v-model="form.customerName" placeholder="请输入客户姓名" placeholder-class="placeholder-style" />
			</view>
			<view class="form-item">
				<text class="form-label">手机号</text>
				<input class="form-input" v-model="form.phone" placeholder="请输入手机号" placeholder-class="placeholder-style" type="number" maxlength="11" />
			</view>
			<view class="form-item">
				<text class="form-label">车型</text>
				<input class="form-input" v-model="form.carModel" placeholder="请输入车型" placeholder-class="placeholder-style" />
			</view>
			<view class="form-item">
				<text class="form-label">车牌号</text>
				<input class="form-input" v-model="form.carPlate" placeholder="请输入车牌号" placeholder-class="placeholder-style" />
			</view>
			<view class="form-item">
				<text class="form-label">等级</text>
				<picker :range="levelOptions" :value="levelIndex" @change="onLevelChange">
					<view class="picker-value">{{ form.level || '请选择等级' }}</view>
				</picker>
			</view>
			<view class="form-item form-item-textarea">
				<text class="form-label">备注</text>
				<textarea class="form-textarea" v-model="form.remark" placeholder="请输入备注信息" placeholder-class="placeholder-style" :maxlength="200" />
			</view>
		</view>

		<!-- 提交按钮 -->
		<button class="submit-btn" hover-class="btn-hover" @tap="handleSubmit">{{ isEdit ? '保存修改' : '确认添加' }}</button>

		<view style="height: 60rpx;"></view>
	</view>
</template>

<script>
import { addCustomer, updateCustomer, getCustomerDetail } from '@/api/charger/customer'

export default {
	data() {
		return {
			customerId: null,
			isEdit: false,
			form: {
				customerName: '',
				phone: '',
				carModel: '',
				carPlate: '',
				level: '普通',
				remark: ''
			},
			levelOptions: ['普通', 'VIP'],
			levelIndex: 0
		}
	},
	onLoad(options) {
		if (options.id) {
			this.customerId = options.id
			this.isEdit = true
			this.loadCustomerData()
		}
	},
	methods: {
		goBack() {
			uni.navigateBack()
		},
		onLevelChange(e) {
			var index = e.detail.value
			this.levelIndex = index
			this.form.level = this.levelOptions[index]
		},
		loadCustomerData() {
			var self = this
			getCustomerDetail(self.customerId).then(function(res) {
				if (res.data) {
					self.form.customerName = res.data.customerName || ''
					self.form.phone = res.data.phone || ''
					self.form.carModel = res.data.carModel || ''
					self.form.carPlate = res.data.carPlate || ''
					self.form.level = res.data.level || '普通'
					self.form.remark = res.data.remark || ''
					for (var i = 0; i < self.levelOptions.length; i++) {
						if (self.levelOptions[i] === self.form.level) {
							self.levelIndex = i
							break
						}
					}
				}
			})
		},
		handleSubmit() {
			var self = this
			if (!self.form.customerName) {
				uni.showToast({ title: '请输入客户姓名', icon: 'none', duration: 1500 })
				return
			}
			if (!self.form.phone) {
				uni.showToast({ title: '请输入手机号', icon: 'none', duration: 1500 })
				return
			}
			var phoneReg = /^1[3-9]\d{9}$/
			if (!phoneReg.test(self.form.phone)) {
				uni.showToast({ title: '请输入正确的手机号', icon: 'none', duration: 1500 })
				return
			}

			uni.showLoading({ title: '提交中...', mask: true })

			var submitData = {
				customerName: self.form.customerName,
				phone: self.form.phone,
				carModel: self.form.carModel,
				carPlate: self.form.carPlate,
				level: self.form.level,
				remark: self.form.remark
			}

			if (self.isEdit) {
				submitData.id = self.customerId
				updateCustomer(submitData).then(function(res) {
					uni.hideLoading()
					uni.showToast({ title: '修改成功', icon: 'success', duration: 1500 })
					setTimeout(function() { uni.navigateBack() }, 1500)
				}).catch(function(err) {
					uni.hideLoading()
					uni.showToast({ title: err.msg || '修改失败', icon: 'none', duration: 1500 })
				})
			} else {
				addCustomer(submitData).then(function(res) {
					uni.hideLoading()
					uni.showToast({ title: '添加成功', icon: 'success', duration: 1500 })
					setTimeout(function() { uni.navigateBack() }, 1500)
				}).catch(function(err) {
					uni.hideLoading()
					uni.showToast({ title: err.msg || '添加失败', icon: 'none', duration: 1500 })
				})
			}
		}
	}
}
</script>

<style scoped>
.page { min-height: 100vh; background: linear-gradient(180deg, #fff7ed 0%, #fefce8 100%); }

.header { position: relative; padding: 30rpx 28rpx 24rpx; display: flex; align-items: center; }
.back-btn { width: 60rpx; height: 60rpx; border-radius: 30rpx; background: rgba(255,255,255,0.75); backdrop-filter: blur(10px); display: flex; align-items: center; justify-content: center; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06); z-index: 1; }
.back-icon { font-size: 28rpx; color: #92400e; }
.header-title { flex: 1; margin-left: 20rpx; font-size: 36rpx; font-weight: 700; color: #451a03; z-index: 1; }
.btn-hover { opacity: 0.7; }

.form-card { margin: 20rpx 24rpx; background: #ffffff; border-radius: 24rpx; padding: 10rpx 28rpx; box-shadow: 0 4rpx 20rpx rgba(0,0,0,0.06); }

.form-item { display: flex; align-items: center; padding: 24rpx 0; border-bottom: 1rpx solid #f5f0eb; }
.form-item:last-child { border-bottom: none; }
.form-item-textarea { align-items: flex-start; }
.form-label { width: 140rpx; font-size: 28rpx; color: #451a03; font-weight: 500; flex-shrink: 0; }
.form-input { flex: 1; font-size: 28rpx; color: #1c1917; text-align: right; }
.picker-value { flex: 1; font-size: 28rpx; color: #1c1917; text-align: right; }
.form-textarea { flex: 1; font-size: 28rpx; color: #1c1917; min-height: 120rpx; margin-top: -4rpx; }
.placeholder-style { color: #d6d3d1; }

.submit-btn { margin: 40rpx 24rpx 0; height: 88rpx; line-height: 88rpx; border-radius: 44rpx; background: linear-gradient(135deg, #f59e0b, #f97316); color: #ffffff; font-size: 32rpx; font-weight: 600; border: none; box-shadow: 0 8rpx 24rpx rgba(249,115,22,0.35); }
.submit-btn::after { border: none; }
</style>
