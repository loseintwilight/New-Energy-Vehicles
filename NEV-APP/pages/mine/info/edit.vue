<template>
  <view class="edit-container">
    <!-- 表单区域 -->
    <view class="form-section">
      <view class="form-item">
        <view class="form-label">
          <uni-icons type="person" size="22" color="#3c96f3"></uni-icons>
          <text>用户名</text>
        </view>
        <input v-model="form.userName" class="form-input" type="text" placeholder="请输入用户名" />
      </view>

      <view class="form-item">
        <view class="form-label">
          <uni-icons type="user" size="22" color="#3c96f3"></uni-icons>
          <text>昵称</text>
        </view>
        <input v-model="form.nickName" class="form-input" type="text" placeholder="请输入昵称" />
      </view>

      <view class="form-item">
        <view class="form-label">
          <uni-icons type="phone" size="22" color="#3c96f3"></uni-icons>
          <text>手机号码</text>
        </view>
        <input v-model="form.phonenumber" class="form-input" type="number" placeholder="请输入手机号码" maxlength="11" />
      </view>

      <view class="form-item">
        <view class="form-label">
          <uni-icons type="mail" size="22" color="#3c96f3"></uni-icons>
          <text>邮箱地址</text>
        </view>
        <input v-model="form.email" class="form-input" type="text" placeholder="请输入邮箱地址" />
      </view>

      <view class="form-item">
        <view class="form-label">
          <uni-icons type="user" size="22" color="#3c96f3"></uni-icons>
          <text>性别</text>
        </view>
        <view class="gender-picker" @click="showGenderPicker = true">
          <text class="picker-value">{{ genderText }}</text>
          <uni-icons type="forward" size="20" color="#ccc"></uni-icons>
        </view>
      </view>

      <view class="form-item">
        <view class="form-label">
          <uni-icons type="calendar" size="22" color="#3c96f3"></uni-icons>
          <text>出生日期</text>
        </view>
        <view class="date-picker" @click="showDatePicker = true">
          <text class="picker-value">{{ form.birthday || '请选择出生日期' }}</text>
          <uni-icons type="forward" size="20" color="#ccc"></uni-icons>
        </view>
      </view>

      <view class="form-item">
        <view class="form-label">
          <uni-icons type="map" size="22" color="#3c96f3"></uni-icons>
          <text>地址</text>
        </view>
        <textarea v-model="form.address" class="form-textarea" placeholder="请输入地址"></textarea>
      </view>
    </view>

    <!-- 性别选择器 -->
    <view v-if="showGenderPicker" class="picker-overlay" @click="showGenderPicker = false">
      <view class="picker-content" @click.stop>
        <view class="picker-header">
          <text class="picker-cancel" @click="showGenderPicker = false">取消</text>
          <text class="picker-title">选择性别</text>
          <text class="picker-confirm" @click="confirmGender">确定</text>
        </view>
        <view class="picker-options">
          <view 
            v-for="item in genderOptions" 
            :key="item.value"
            :class="['picker-option', currentGender === item.value ? 'active' : '']"
            @click="currentGender = item.value"
          >
            <text>{{ item.label }}</text>
            <view v-if="currentGender === item.value" class="option-check">
              <uni-icons type="checkmarkempty" size="20" color="#3c96f3"></uni-icons>
            </view>
          </view>
        </view>
      </view>
    </view>

    <!-- 日期选择器 -->
    <view v-if="showDatePicker" class="picker-overlay" @click="showDatePicker = false">
      <view class="picker-content" @click.stop>
        <view class="picker-header">
          <text class="picker-cancel" @click="showDatePicker = false">取消</text>
          <text class="picker-title">选择日期</text>
          <text class="picker-confirm" @click="confirmDate">确定</text>
        </view>
        <view class="date-picker-content">
          <picker mode="date" :value="form.birthday" @change="onDateChange">
            <view class="date-input">
              <text>{{ form.birthday || '请选择日期' }}</text>
            </view>
          </picker>
        </view>
      </view>
    </view>

    <!-- 提交按钮 -->
    <view class="submit-section">
      <button @click="handleSubmit" class="submit-btn">保存修改</button>
    </view>
  </view>
</template>

<script>
  import { getUserProfile, updateUserProfile } from "@/api/system/user"

  export default {
    data() {
      return {
        form: {
          userName: '',
          nickName: '',
          phonenumber: '',
          email: '',
          sex: '2',
          birthday: '',
          address: ''
        },
        showGenderPicker: false,
        showDatePicker: false,
        currentGender: '2',
        genderOptions: [
          { value: '0', label: '男' },
          { value: '1', label: '女' },
          { value: '2', label: '未知' }
        ]
      }
    },
    computed: {
      genderText() {
        const found = this.genderOptions.find(item => item.value === this.form.sex)
        return found ? found.label : '请选择'
      }
    },
    onLoad() {
      this.getUserInfo()
    },
    methods: {
      getUserInfo() {
        // 从 API 获取真实用户数据
        getUserProfile().then(response => {
          const user = response.data || {}
          this.form = {
            userName: user.userName || '',
            nickName: user.nickName || '',
            phonenumber: user.phonenumber || '',
            email: user.email || '',
            sex: user.sex || '2',
            birthday: user.birthday || '',
            address: user.address || ''
          }
          this.currentGender = this.form.sex
        }).catch(() => {
          // 接口失败时从 Vuex 读取
          const state = this.$store.state.user
          this.form = {
            userName: state.name || '',
            nickName: state.name || '',
            phonenumber: state.phonenumber || '',
            email: '',
            sex: '2',
            birthday: '',
            address: ''
          }
          this.currentGender = this.form.sex
        })
      },
      confirmGender() {
        this.form.sex = this.currentGender
        this.showGenderPicker = false
      },
      onDateChange(e) {
        this.form.birthday = e.detail.value
      },
      confirmDate() {
        this.showDatePicker = false
      },
      handleSubmit() {
        if (!this.form.userName) {
          this.$modal.msgError('请输入用户名')
          return
        }
        if (!this.form.nickName) {
          this.$modal.msgError('请输入昵称')
          return
        }
        if (this.form.phonenumber && !/^1[3-9]\d{9}$/.test(this.form.phonenumber)) {
          this.$modal.msgError('请输入正确的手机号码')
          return
        }
        if (this.form.email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(this.form.email)) {
          this.$modal.msgError('请输入正确的邮箱地址')
          return
        }

        this.$modal.loading('保存中...')
        updateUserProfile({
          userName: this.form.userName,
          nickName: this.form.nickName,
          phonenumber: this.form.phonenumber,
          email: this.form.email,
          sex: this.form.sex,
          birthday: this.form.birthday,
          address: this.form.address
        }).then(() => {
          this.$modal.closeLoading()
          this.$modal.msgSuccess('保存成功')
          // 更新 Vuex 和本地存储，其他页面即时同步
          this.$store.commit('SET_NAME', this.form.nickName || this.form.userName)
          this.$store.commit('SET_PHONENUMBER', this.form.phonenumber)
          setTimeout(() => {
            this.$tab.navigateBack()
          }, 1500)
        }).catch(() => {
          this.$modal.closeLoading()
          this.$modal.msgError('保存失败，请重试')
        })
      }
    }
  }
</script>

<style lang="scss" scoped>
  page {
    background-color: #f5f6f7;
    min-height: 100vh;
  }

  .edit-container {
    width: 100%;
    min-height: 100vh;
    padding-bottom: 160rpx;
  }

  /* 表单区域 */
  .form-section {
    padding: 30rpx;
  }

  .form-item {
    background-color: #fff;
    padding: 26rpx 30rpx;
    border-radius: 16rpx;
    margin-bottom: 20rpx;
    display: flex;
    align-items: center;
    box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.03);
  }

  .form-label {
    display: flex;
    align-items: center;
    width: 160rpx;
    font-size: 28rpx;
    color: #666;
  }

  .form-icon {
    font-size: 28rpx;
    color: #3c96f3;
    margin-right: 12rpx;
  }

  .form-input {
    flex: 1;
    font-size: 28rpx;
    color: #333;
    text-align: right;
  }

  .form-textarea {
    flex: 1;
    font-size: 28rpx;
    color: #333;
    min-height: 120rpx;
    text-align: right;
  }

  .gender-picker,
  .date-picker {
    flex: 1;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .picker-value {
    font-size: 28rpx;
    color: #333;
  }

  .picker-arrow {
    font-size: 24rpx;
    color: #ccc;
  }

  /* 选择器遮罩 */
  .picker-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: flex-end;
    z-index: 999;
  }

  .picker-content {
    width: 100%;
    background-color: #fff;
    border-radius: 20rpx 20rpx 0 0;
  }

  .picker-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 30rpx;
    border-bottom: 1rpx solid #f0f0f0;
  }

  .picker-cancel,
  .picker-confirm {
    font-size: 28rpx;
    color: #3c96f3;
  }

  .picker-title {
    font-size: 32rpx;
    font-weight: 500;
    color: #333;
  }

  .picker-options {
    padding: 20rpx 0;
  }

  .picker-option {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 30rpx;
    font-size: 30rpx;
    color: #333;
  }

  .picker-option.active {
    color: #3c96f3;
  }

  .option-check {
    width: 40rpx;
    height: 40rpx;
    background-color: #3c96f3;
    border-radius: 50%;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .option-check .iconfont {
    font-size: 24rpx;
    color: #fff;
  }

  .date-picker-content {
    padding: 30rpx;
  }

  .date-input {
    text-align: center;
    font-size: 32rpx;
    color: #333;
    padding: 20rpx;
    background-color: #f5f6f7;
    border-radius: 12rpx;
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

  .icon-check:before {
    content: "\e64a";
  }
</style>