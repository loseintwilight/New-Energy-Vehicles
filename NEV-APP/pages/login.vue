<template>
	<view class="page-container">
		<image class="bg-image" src="/static/images/login/back6.jpg" mode="aspectFill"></image>
		<view class="normal-login-container">
			<view class="logo-content align-center justify-center flex">
				<image style="width: 70rpx;height: 70rpx;" src="../static/images/login/logo.PNG" mode="widthFix">
				</image>
				<text class="title">新能源汽车全生命周期服务平台</text>
			</view>
			<view class="login-form-content">
				<view class="input-item flex align-center">
					<view class="iconfont icon-user icon"></view>
					<input v-model="loginForm.username" class="input" type="text" placeholder="请输入账号" maxlength="30" />
				</view>
				<view class="input-item flex align-center">
					<view class="iconfont icon-password icon"></view>
					<input v-model="loginForm.password" type="password" class="input" placeholder="请输入密码"
						maxlength="20" />
				</view>
				<view class="input-item flex align-center" style="width: 60%;margin: 0px;" v-if="captchaEnabled">
					<view class="iconfont icon-code icon"></view>
					<input v-model="loginForm.code" type="number" class="input" placeholder="请输入验证码" maxlength="4" />
					<view class="login-code">
						<image :src="codeUrl" @click="getCode" class="login-code-img"></image>
					</view>
				</view>
				<view class="action-btn">
					<button @click="handleLogin" class="login-btn cu-btn block bg-green lg round">登录</button>
				</view>
				<view class="reg text-center" v-if="register">
					<text class="text-grey1">没有账号？</text>
					<text @click="handleUserRegister" class="text-blue">立即注册</text>
				</view>
				<view class="xieyi text-center">
					<text class="text-grey1">登录即代表同意</text>
					<text @click="handleUserAgrement" class="text-blue">《用户协议》</text>
					<text @click="handlePrivacy" class="text-blue">《隐私协议》</text>
				</view>
			</view>

		</view>
	</view>

</template>

<script>
	import {
		getCodeImg
	} from '@/api/login'
	import {
		getToken
	} from '@/utils/auth'

	export default {
		data() {
			return {
				codeUrl: "",
				captchaEnabled: true,
				// 用户注册开关
				register: false,
				globalConfig: getApp().globalData.config,
				loginForm: {
					username: "admin",
					password: "admin123",
					code: "",
					uuid: ""
				}
			}
		},
		created() {
			this.getCode()
		},
		onLoad() {
			//#ifdef H5
			if (getToken()) {
				this.$tab.reLaunch('/pages/index')
			}
			//#endif
		},
		methods: {
			// 用户注册
			handleUserRegister() {
				this.$tab.redirectTo(`/pages/register`)
			},
			// 隐私协议
			handlePrivacy() {
				let site = this.globalConfig.appInfo.agreements[0]
				this.$tab.navigateTo(`/pages/common/webview/index?title=${site.title}&url=${site.url}`)
			},
			// 用户协议
			handleUserAgrement() {
				let site = this.globalConfig.appInfo.agreements[1]
				this.$tab.navigateTo(`/pages/common/webview/index?title=${site.title}&url=${site.url}`)
			},
			// 获取图形验证码
			getCode() {
				getCodeImg().then(res => {
					this.captchaEnabled = res.captchaEnabled === undefined ? true : res.captchaEnabled
					if (this.captchaEnabled) {
						this.codeUrl = 'data:image/gif;base64,' + res.img
						this.loginForm.uuid = res.uuid
					}
				})
			},
			// 登录方法
			async handleLogin() {
				if (this.loginForm.username === "") {
					this.$modal.msgError("请输入账号")
				} else if (this.loginForm.password === "") {
					this.$modal.msgError("请输入密码")
				} else if (this.loginForm.code === "" && this.captchaEnabled) {
					this.$modal.msgError("请输入验证码")
				} else {
					this.$modal.loading("登录中，请耐心等待...")
					this.pwdLogin()
				}
			},
			// 密码登录
			async pwdLogin() {
				this.$store.dispatch('Login', this.loginForm).then(() => {
					this.$modal.closeLoading()
					this.loginSuccess()
				}).catch(() => {
					if (this.captchaEnabled) {
						this.getCode()
					}
				})
			},
			// 登录成功后，处理函数
			loginSuccess(result) {
				// 设置用户信息
				this.$store.dispatch('GetInfo').then(res => {
					this.$tab.reLaunch('/pages/index')
				})
			}
		}
	}
</script>

<style lang="scss">
	/* 不加 scoped，page 样式才能生效 */
	page {}
</style>

<style lang="scss" scoped>
	.page-container {
		position: relative;
		width: 100%;
		min-height: 100vh;
	}

	.bg-image {
		position: absolute;
		top: 0;
		left: 0;
		width: 100%;
		height: 100vh;
		z-index: 0;
	}

	.title {
		color: #fff;
		text-shadow: 2rpx 2rpx 4rpx rgba(0, 0, 0, 0.5);
		font-size: 45rpx;
		font-weight: 600;
	}

	.normal-login-container {
		width: 100%;
		position: relative;
		z-index: 1;

		.logo-content {
			width: 100%;
			font-size: 21px;
			text-align: center;
			padding-top: 15%;

			image {
				border-radius: 4px;
			}

			.title {
				margin-left: 10px;
			}
		}

		.login-form-content {
			text-align: center;
			margin: 20px auto;
			margin-top: 15%;
			width: 80%;

			.input-item {
				margin: 20px auto;
				background-color: #F1FDF3;
				box-shadow: 2rpx 2rpx 4rpx rgba(0, 0, 0, 0.5);
				height: 45px;
				border-radius: 20px;

				.icon {
					font-size: 38rpx;
					margin-left: 10px;
					color: #999;
				}

				.input {
					width: 100%;
					font-size: 14px;
					line-height: 20px;
					text-align: left;
					padding-left: 15px;
				}

			}

			// .login-btn {
			// 	margin-top: 40px;
			// 	height: 45px;
			// 	background-color: #c5e398;
			// 	box-shadow: 6rpx 6rpx 12rpx #0e4929;
			// }
			.login-btn {
			  margin-top: 50rpx;
			  height: 45px;
			  // background-color: #c5e398;
			  background-color: #11a689;
			  border-radius: 10rpx;
			  /* 深墨绿色阴影，加大不透明度，立体感拉满 */
			  box-shadow: 7rpx 7rpx 14rpx black;
			  // transition: all 0.15s ease;
			  border: none;
			}
			/* 按压下沉，阴影同步缩小变淡 */
			.login-btn:active {
			  transform: translateY(3rpx);
			  box-shadow: 4rpx 4rpx 8rpx rgba(10, 60, 30, 0.3);
			}

			.reg {
				margin-top: 15px;
			}

			.xieyi {
				color: #333;
				// color: #fff;
				margin-top: 20px;
			}
			.text-grey1{
				color: #fff;
			}
			.text-blue{
				color: #c5e398;
			}

			.login-code {
				height: 38px;
				float: right;

				.login-code-img {
					height: 38px;
					position: absolute;
					margin-left: 10px;
					width: 200rpx;
				}
			}
		}
	}
</style>