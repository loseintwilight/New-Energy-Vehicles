<template>
	<view class="container">
		<!-- 门店图片 -->
		<view class="img-section" @click="handleUploadImg">
			<image class="shop-img" :src="form.image" mode="aspectFill" v-if="form.image"></image>
			<view class="img-upload" v-else>
				<view class="iconfont icon-dianzan upload-icon"></view>
				<text class="upload-text">上传门店图片</text>
			</view>
		</view>

		<!-- 基本信息 -->
		<view class="form-card">
			<view class="form-title">基本信息</view>
			<view class="form-item">
				<text class="form-label">门店名称 <text class="required">*</text></text>
				<input class="form-input" v-model="form.shop_name" placeholder="请输入门店名称" maxlength="100" />
			</view>
			<view class="form-row">
				<view class="form-item form-half">
					<text class="form-label">省份 <text class="required">*</text></text>
					<input class="form-input" v-model="form.province" placeholder="省份" maxlength="20" />
				</view>
				<view class="form-item form-half">
					<text class="form-label">城市 <text class="required">*</text></text>
					<input class="form-input" v-model="form.city" placeholder="城市" maxlength="20" />
				</view>
			</view>
			<view class="form-item">
				<text class="form-label">区县</text>
				<input class="form-input" v-model="form.district" placeholder="区县（选填）" maxlength="20" />
			</view>
			<view class="form-item">
				<text class="form-label">详细地址 <text class="required">*</text></text>
				<input class="form-input" v-model="form.address" placeholder="请输入详细地址" maxlength="255" />
			</view>
			
		</view>

		<!-- 联系人 -->
		<view class="form-card">
			<view class="form-title">联系人信息</view>
			<view class="form-item">
				<text class="form-label">联系人姓名 <text class="required">*</text></text>
				<input class="form-input" v-model="form.contactName" placeholder="请输入联系人" maxlength="30" />
			</view>
			<view class="form-item">
				<text class="form-label">联系电话 <text class="required">*</text></text>
				<input class="form-input" v-model="form.contactPhone" placeholder="请输入手机号" maxlength="11" type="number" />
			</view>
		</view>

		<!-- 服务项目 -->
		<view class="form-card">
			<view class="form-title">服务项目</view>
			<view class="service-list">
				<view class="service-tag" v-for="(svc, i) in serviceList" :key="i">
					<text>{{ svc }}</text>
					<text class="tag-del" @click="removeService(i)">×</text>
				</view>
				<view class="service-add" @click="showServiceInput = true" v-if="!showServiceInput">
					<text class="iconfont icon-dianzan" style="font-size:14px;color:#00c9a7;"></text>
					<text>添加服务项目</text>
				</view>
				<view class="service-input-row" v-if="showServiceInput">
					<input class="service-input" v-model="newService" placeholder="输入服务项目" @confirm="addService" />
					<text class="service-confirm" @click="addService">确定</text>
				</view>
			</view>
		</view>

		<!-- 门店介绍 -->
		<view class="form-card">
			<view class="form-title">门店介绍</view>
			<textarea class="form-textarea" v-model="form.description" placeholder="请输入门店介绍（选填）" maxlength="1000" />
			<text class="textarea-count">{{ form.description.length }}/1000</text>
		</view>

		<!-- 提交按钮 -->
		<view class="submit-bar">
			<button class="submit-btn" @click="handleSubmit">{{ isEdit ? '保存修改' : '创建门店' }}</button>
		</view>
	</view>
</template>

<script>
	import { getShop, createShop, updateShop } from '@/api/maintenance/shop'
	export default {
		data() {
			return {
				isEdit: false,
				form: {
					shop_id: null,
					image: '',
					shop_name: '',
					province: '',
					city: '',
					district: '',
					address: '',
					longitude: '',
					latitude: '',
					contactName: '',
					contactPhone: '',
					description: ''
				},
				serviceList: [],
				showServiceInput: false,
				newService: ''
			}
		},
		onLoad(options) {
			if (options.shop_id) {
				this.isEdit = true
				uni.setNavigationBarTitle({ title: '编辑门店' })
				this.loadShop(options.shop_id)
			}
		},
		methods: {
			loadShop(id) {
				getShop(id).then(res => {
				  this.form = res.data
				  try {
				    const info = res.data.servicesInfo
				    if (!info) {
				      this.serviceList = []
				    } else if (Array.isArray(info)) {
				      this.serviceList = info
				    } else if (typeof info === 'string') {
				      this.serviceList = info.split(/[,，、]/).filter(s => s.trim())
				    } else {
				      this.serviceList = []
				    }
				  } catch {
				    this.serviceList = []
				  }
				}).catch(() => {})
			},
			handleUploadImg() {
				uni.chooseImage({
					count: 1,
					success: (res) => {
						this.form.image = res.tempFilePaths[0]
					}
				})
			},
			addService() {
				const val = this.newService.trim()
				if (val && !this.serviceList.includes(val)) {
					this.serviceList.push(val)
				}
				this.newService = ''
				this.showServiceInput = false
			},
			removeService(index) {
				this.serviceList.splice(index, 1)
			},
			handleSubmit() {
			  if (!this.form.shop_name) return this.$modal.msgError('请输入门店名称')
			  if (!this.form.province) return this.$modal.msgError('请输入省份')
			  if (!this.form.city) return this.$modal.msgError('请输入城市')
			  if (!this.form.address) return this.$modal.msgError('请输入详细地址')
			  if (!this.form.contactName) return this.$modal.msgError('请输入联系人姓名')
			  if (!this.form.contactPhone || !/^1\d{10}$/.test(this.form.contactPhone)) return this.$modal.msgError('请输入有效手机号')
			
			  const submitData = {
			    ...this.form,
			    servicesInfo: JSON.stringify(this.serviceList)
			  }
			
			  if (this.isEdit) {
			    updateShop(submitData).then(() => {
			      this.$modal.msgSuccess('修改成功')
			      setTimeout(() => this.$tab.navigateBack(), 1000)
			    })
			  } else {
			    createShop(submitData).then(() => {
			      this.$modal.msgSuccess('创建成功')
			      setTimeout(() => this.$tab.navigateBack(), 1000)
			    })
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
.container { padding-bottom: 100px; }

// ====== 图片上传区 ======
.img-section {
	margin: 0 16px 12px;
	border-radius: 16px;
	overflow: hidden;
	height: 180px;
	background: $card;
}

.shop-img {
	width: 100%;
	height: 100%;
	display: block;
}

.img-upload {
	width: 100%;
	height: 100%;
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	gap: 8px;
	border: 2px dashed #d1d5db;
	border-radius: 16px;
}

.upload-icon {
	font-size: 36px;
	color: #d1d5db;
}

.upload-text {
	font-size: 13px;
	color: $mute;
}

// ====== 表单卡片 ======
.form-card {
	margin: 0 16px 12px;
	background: $card;
	border-radius: 16px;
	padding: 16px;
	box-shadow: 0 2px 8px rgba(5, 150, 105, 0.04);
}

.form-title {
	font-size: 15px;
	font-weight: 600;
	color: $text;
	padding-left: 10px;
	border-left: 3px solid $green;
	margin-bottom: 14px;
}

.form-item {
	margin-bottom: 14px;
}

.form-label {
	font-size: 13px;
	color: $text;
	font-weight: 500;
	display: block;
	margin-bottom: 6px;
}

.required {
	color: #ef4444;
}

.form-input {
	width: 100%;
	height: 42px;
	background: #f8fafc;
	border-radius: 10px;
	padding: 0 12px;
	font-size: 14px;
	color: $text;
	border: 1px solid #e2e8f0;
	box-sizing: border-box;
}

// .form-row {
// 	display: flex;
// 	gap: 10px;
// }

.form-half {
	flex: 1;
}

.form-textarea {
	width: 100%;
	min-height: 100px;
	background: #f8fafc;
	border-radius: 10px;
	padding: 10px 12px;
	font-size: 14px;
	color: $text;
	border: 1px solid #e2e8f0;
	box-sizing: border-box;
}

.textarea-count {
	font-size: 11px;
	color: $mute;
	text-align: right;
	display: block;
	margin-top: 4px;
}

// ====== 服务项目 ======
.service-list {
	display: flex;
	flex-wrap: wrap;
	gap: 8px;
}

.service-tag {
	font-size: 12px;
	color: $green-dark;
	background: $green-light;
	padding: 4px 10px;
	border-radius: 6px;
	display: flex;
	align-items: center;
	gap: 6px;
}

.tag-del {
	color: #ef4444;
	font-weight: bold;
	font-size: 14px;
	padding: 0 2px;
}

.service-add {
	font-size: 12px;
	color: $green;
	padding: 4px 10px;
	border: 1px dashed $green;
	border-radius: 6px;
	display: flex;
	align-items: center;
	gap: 4px;
}

.service-input-row {
	width: 100%;
	display: flex;
	gap: 8px;
}

.service-input {
	flex: 1;
	height: 36px;
	background: #f8fafc;
	border-radius: 8px;
	padding: 0 10px;
	font-size: 13px;
	border: 1px solid $green;
}

.service-confirm {
	font-size: 12px;
	color: #fff;
	background: $green;
	padding: 0 14px;
	border-radius: 8px;
	line-height: 36px;
}

// ====== 提交 ======
.submit-bar {
	position: fixed;
	bottom: 0;
	left: 0;
	right: 0;
	padding: 12px 16px;
	padding-bottom: calc(12px + env(safe-area-inset-bottom));
	background: #ffffff;
	box-shadow: 0 -2px 12px rgba(0, 0, 0, 0.04);
	z-index: 999;
}

.submit-btn {
	width: 100%;
	height: 46px;
	background: linear-gradient(135deg, $green, $green-dark);
	color: #ffffff;
	border-radius: 12px;
	font-size: 16px;
	font-weight: 600;
	border: none;
	line-height: 46px;
	text-align: center;
}
</style>