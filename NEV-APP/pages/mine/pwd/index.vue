<template>
  <view class="pwd-container">
    <!-- 安全提示 -->
    <view class="safe-tip">
      <view class="tip-icon">
        <uni-icons type="lock" size="32" color="#3c96f3"></uni-icons>
      </view>
      <view class="tip-content">
        <text class="tip-title">密码安全</text>
        <text class="tip-desc">请设置6-20位密码，建议包含数字和字母组合</text>
      </view>
    </view>

    <!-- 表单区域 -->
    <view class="form-section">
      <view class="form-item">
        <view class="form-icon-wrapper">
          <uni-icons type="lock" size="22" color="#999"></uni-icons>
        </view>
        <input 
          v-model="form.oldPassword" 
          class="form-input" 
          type="password" 
          placeholder="请输入原密码" 
          :password="!showOldPwd"
        />
        <view class="eye-btn" @click="showOldPwd = !showOldPwd">
          <uni-icons :type="showOldPwd ? 'eye' : 'eye-slash'" size="22" color="#999"></uni-icons>
        </view>
      </view>

      <view class="form-item">
        <view class="form-icon-wrapper">
          <uni-icons type="lock" size="22" color="#999"></uni-icons>
        </view>
        <input 
          v-model="form.newPassword" 
          class="form-input" 
          type="password" 
          placeholder="请输入新密码" 
          :password="!showNewPwd"
        />
        <view class="eye-btn" @click="showNewPwd = !showNewPwd">
          <uni-icons :type="showNewPwd ? 'eye' : 'eye-slash'" size="22" color="#999"></uni-icons>
        </view>
      </view>

      <view class="form-item">
        <view class="form-icon-wrapper">
          <uni-icons type="lock" size="22" color="#999"></uni-icons>
        </view>
        <input 
          v-model="form.confirmPassword" 
          class="form-input" 
          type="password" 
          placeholder="请确认新密码" 
          :password="!showConfirmPwd"
        />
        <view class="eye-btn" @click="showConfirmPwd = !showConfirmPwd">
          <uni-icons :type="showConfirmPwd ? 'eye' : 'eye-slash'" size="22" color="#999"></uni-icons>
        </view>
      </view>
    </view>

    <!-- 密码强度提示 -->
    <view class="strength-section" v-if="form.newPassword">
      <view class="strength-title">密码强度</view>
      <view class="strength-bars">
        <view :class="['strength-bar', getStrengthClass(1)]"></view>
        <view :class="['strength-bar', getStrengthClass(2)]"></view>
        <view :class="['strength-bar', getStrengthClass(3)]"></view>
        <view :class="['strength-bar', getStrengthClass(4)]"></view>
      </view>
      <view class="strength-text">{{ getStrengthText() }}</view>
    </view>

    <!-- 提交按钮 -->
    <view class="submit-section">
      <button @click="handleSubmit" class="submit-btn">确认修改</button>
    </view>
  </view>
</template>

<script>
  import { updatePassword } from "@/api/system/user"

  export default {
    data() {
      return {
        form: {
          oldPassword: '',
          newPassword: '',
          confirmPassword: ''
        },
        showOldPwd: false,
        showNewPwd: false,
        showConfirmPwd: false
      }
    },
    methods: {
      getPasswordStrength() {
        let score = 0
        const pwd = this.form.newPassword
        
        if (pwd.length >= 6) score++
        if (pwd.length >= 10) score++
        if (/[a-zA-Z]/.test(pwd)) score++
        if (/[0-9]/.test(pwd)) score++
        if (/[^a-zA-Z0-9]/.test(pwd)) score++
        
        return Math.min(score, 4)
      },
      getStrengthClass(level) {
        const strength = this.getPasswordStrength()
        if (level <= strength) {
          if (strength <= 1) return 'weak'
          if (strength <= 2) return 'medium'
          if (strength <= 3) return 'strong'
          return 'very-strong'
        }
        return 'empty'
      },
      getStrengthText() {
        const strength = this.getPasswordStrength()
        if (strength <= 1) return '弱'
        if (strength <= 2) return '中等'
        if (strength <= 3) return '强'
        return '非常强'
      },
      handleSubmit() {
        if (!this.form.oldPassword) {
          this.$modal.msgError('请输入原密码')
          return
        }
        if (!this.form.newPassword) {
          this.$modal.msgError('请输入新密码')
          return
        }
        if (this.form.newPassword.length < 6) {
          this.$modal.msgError('密码长度不能少于6位')
          return
        }
        if (this.form.newPassword.length > 20) {
          this.$modal.msgError('密码长度不能超过20位')
          return
        }
        if (!this.form.confirmPassword) {
          this.$modal.msgError('请确认新密码')
          return
        }
        if (this.form.newPassword !== this.form.confirmPassword) {
          this.$modal.msgError('两次输入的密码不一致')
          return
        }

        this.$modal.loading('修改中...')
        
        // 模拟修改密码
        setTimeout(() => {
          this.$modal.closeLoading()
          this.$modal.msgSuccess('密码修改成功')
          setTimeout(() => {
            this.$tab.navigateBack()
          }, 1500)
        }, 1000)
      }
    }
  }
</script>

<style lang="scss" scoped>
  page {
    background-color: #f5f6f7;
    min-height: 100vh;
  }

  .pwd-container {
    width: 100%;
    min-height: 100vh;
    padding-bottom: 160rpx;
  }

  /* 安全提示 */
  .safe-tip {
    margin: 30rpx;
    background: linear-gradient(135deg, #fff5f5 0%, #ffe4e4 100%);
    border-radius: 16rpx;
    padding: 24rpx;
    display: flex;
    align-items: center;
  }

  .tip-icon {
    width: 64rpx;
    height: 64rpx;
    background-color: #ffccc7;
    border-radius: 50%;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-right: 20rpx;
  }

  .tip-icon .iconfont {
    font-size: 32rpx;
    color: #ff4d4f;
  }

  .tip-content {
    flex: 1;
  }

  .tip-title {
    display: block;
    font-size: 28rpx;
    font-weight: 500;
    color: #ff4d4f;
    margin-bottom: 8rpx;
  }

  .tip-desc {
    font-size: 24rpx;
    color: #ff7875;
  }

  /* 表单区域 */
  .form-section {
    padding: 30rpx;
  }

  .form-item {
    background-color: #fff;
    padding: 0 30rpx;
    border-radius: 16rpx;
    margin-bottom: 20rpx;
    display: flex;
    align-items: center;
    height: 88rpx;
    box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.03);
  }

  .form-icon-wrapper {
    width: 48rpx;
    height: 48rpx;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-right: 16rpx;
  }

  .form-icon {
    font-size: 28rpx;
    color: #3c96f3;
  }

  .form-input {
    flex: 1;
    font-size: 28rpx;
    color: #333;
  }

  .eye-btn {
    width: 48rpx;
    height: 48rpx;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .eye-btn .iconfont {
    font-size: 28rpx;
    color: #999;
  }

  /* 密码强度 */
  .strength-section {
    padding: 0 30rpx 30rpx;
  }

  .strength-title {
    font-size: 24rpx;
    color: #999;
    margin-bottom: 12rpx;
  }

  .strength-bars {
    display: flex;
    gap: 12rpx;
    margin-bottom: 12rpx;
  }

  .strength-bar {
    flex: 1;
    height: 12rpx;
    border-radius: 6rpx;
  }

  .strength-bar.empty {
    background-color: #f0f0f0;
  }

  .strength-bar.weak {
    background-color: #ff4d4f;
  }

  .strength-bar.medium {
    background-color: #faad14;
  }

  .strength-bar.strong {
    background-color: #73d13d;
  }

  .strength-bar.very-strong {
    background-color: #3c96f3;
  }

  .strength-text {
    font-size: 24rpx;
    color: #999;
  }

  /* 提交按钮 */
  .submit-section {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    padding: 20rpx 30rpx;
    padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
    background-color: #fff;
    box-shadow: 0 -4rpx 20rpx rgba(0, 0, 0, 0.05);
  }

  .submit-btn {
    width: 100%;
    height: 88rpx;
    background: linear-gradient(135deg, #3c96f3 0%, #6b7bff 100%);
    border-radius: 44rpx;
    font-size: 32rpx;
    font-weight: 500;
    color: #fff;
  }

  .submit-btn::after {
    border: none;
  }

  .icon-lock:before {
    content: "\e60e";
  }

  .icon-eye:before {
    content: "\e60d";
  }

  .icon-eye-off:before {
    content: "\e60c";
  }
</style>