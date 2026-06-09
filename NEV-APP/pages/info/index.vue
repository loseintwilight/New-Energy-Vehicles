<template>
  <view class="info-container">
    <!-- 用户头像区域 -->
    <view class="avatar-section">
      <view class="avatar-bg"></view>
      <view class="avatar-card">
        <view v-if="!user.avatar" class="avatar-wrapper">
          <uni-icons type="person" size="60" color="#fff"></uni-icons>
        </view>
        <image v-else :src="user.avatar" class="avatar-image" mode="aspectFill"></image>
        <view class="user-name">{{ user.nickName || '未设置昵称' }}</view>
        <view class="user-role">{{ roleGroup || '普通用户' }}</view>
        <view class="edit-btn" @click="handleToEdit">
          <uni-icons type="edit" size="20" color="#3c96f3"></uni-icons>
          <text>编辑资料</text>
        </view>
      </view>
    </view>

    <!-- 个人信息列表 -->
    <view class="info-section">
      <view class="section-title">基本信息</view>
      <view class="info-list">
        <view class="info-item">
          <view class="info-icon-wrapper">
            <uni-icons type="person" size="24" color="#3c96f3"></uni-icons>
          </view>
          <view class="info-content">
            <text class="info-label">用户名</text>
            <text class="info-value">{{ user.userName || '-' }}</text>
          </view>
        </view>
        <view class="info-item">
          <view class="info-icon-wrapper">
            <uni-icons type="phone" size="24" color="#3c96f3"></uni-icons>
          </view>
          <view class="info-content">
            <text class="info-label">手机号码</text>
            <text class="info-value">{{ user.phonenumber || '-' }}</text>
          </view>
        </view>
        <view class="info-item">
          <view class="info-icon-wrapper">
            <uni-icons type="mail" size="24" color="#3c96f3"></uni-icons>
          </view>
          <view class="info-content">
            <text class="info-label">邮箱地址</text>
            <text class="info-value">{{ user.email || '-' }}</text>
          </view>
        </view>
        <view class="info-item">
          <view class="info-icon-wrapper">
            <uni-icons type="user" size="24" color="#3c96f3"></uni-icons>
          </view>
          <view class="info-content">
            <text class="info-label">性别</text>
            <text class="info-value">{{ genderText }}</text>
          </view>
        </view>
        <view class="info-item">
          <view class="info-icon-wrapper">
            <uni-icons type="calendar" size="24" color="#3c96f3"></uni-icons>
          </view>
          <view class="info-content">
            <text class="info-label">出生日期</text>
            <text class="info-value">{{ user.birthday || '-' }}</text>
          </view>
        </view>
        <view class="info-item">
          <view class="info-icon-wrapper">
            <uni-icons type="map" size="24" color="#3c96f3"></uni-icons>
          </view>
          <view class="info-content">
            <text class="info-label">地址</text>
            <text class="info-value">{{ user.address || '-' }}</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 账号信息 -->
    <view class="info-section">
      <view class="section-title">账号信息</view>
      <view class="info-list">
        <view class="info-item">
          <view class="info-icon-wrapper">
            <uni-icons type="list" size="24" color="#3c96f3"></uni-icons>
          </view>
          <view class="info-content">
            <text class="info-label">岗位</text>
            <text class="info-value">{{ postGroup || '-' }}</text>
          </view>
        </view>
        <view class="info-item">
          <view class="info-icon-wrapper">
            <uni-icons type="star" size="24" color="#3c96f3"></uni-icons>
          </view>
          <view class="info-content">
            <text class="info-label">角色</text>
            <text class="info-value">{{ roleGroup || '-' }}</text>
          </view>
        </view>
        <view class="info-item">
          <view class="info-icon-wrapper">
            <uni-icons type="clock" size="24" color="#3c96f3"></uni-icons>
          </view>
          <view class="info-content">
            <text class="info-label">创建时间</text>
            <text class="info-value">{{ formatDate(user.createTime) || '-' }}</text>
          </view>
        </view>
        <view class="info-item">
          <view class="info-icon-wrapper">
            <uni-icons type="checkbox" size="24" color="#3c96f3"></uni-icons>
          </view>
          <view class="info-content">
            <text class="info-label">账号状态</text>
            <view class="status-wrapper">
              <text class="info-value">{{ statusText }}</text>
              <view :class="['status-dot', user.status === '0' ? 'status-active' : 'status-inactive']"></view>
            </view>
          </view>
        </view>
      </view>
    </view>

    <!-- 操作按钮 -->
    <view class="action-section">
      <button @click="handleToAvatar" class="action-btn bg-primary">修改头像</button>
      <button @click="handleToEdit" class="action-btn bg-outline">编辑资料</button>
    </view>
  </view>
</template>

<script>
  import { getUserProfile } from "@/api/system/user"

  export default {
    data() {
      return {
        user: {},
        roleGroup: "",
        postGroup: ""
      }
    },
    computed: {
      genderText() {
        const genderMap = {
          '0': '男',
          '1': '女',
          '2': '未知'
        }
        return genderMap[this.user.sex] || '-'
      },
      statusText() {
        return this.user.status === '0' ? '正常' : '禁用'
      }
    },
    onLoad() {
      this.getUser()
    },
    methods: {
      getUser() {
        getUserProfile().then(response => {
          this.user = response.data
          this.roleGroup = response.roleGroup
          this.postGroup = response.postGroup
        }).catch(() => {
          // 如果接口调用失败，使用模拟数据
          this.user = {
            nickName: '新能源用户',
            userName: 'user001',
            phonenumber: '138****8888',
            email: 'user@example.com',
            sex: '0',
            birthday: '1990-01-01',
            address: '北京市朝阳区',
            createTime: '2024-01-15 10:30:00',
            status: '0'
          }
          this.roleGroup = '普通用户'
          this.postGroup = '用户'
        })
      },
      formatDate(dateStr) {
        if (!dateStr) return ''
        return dateStr.replace('T', ' ')
      },
      handleToEdit() {
        this.$tab.navigateTo('/pages/mine/info/edit')
      },
      handleToAvatar() {
        this.$tab.navigateTo('/pages/mine/avatar/index')
      }
    }
  }
</script>

<style lang="scss" scoped>
  page {
    background-color: #f5f6f7;
    min-height: 100vh;
  }

  .info-container {
    width: 100%;
    min-height: 100vh;
    padding-bottom: 160rpx;
  }

  /* 头像区域 */
  .avatar-section {
    position: relative;
    padding: 40rpx 30rpx 60rpx;
    overflow: hidden;
  }

  .avatar-bg {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 320rpx;
    background: linear-gradient(135deg, #3c96f3 0%, #6b7bff 100%);
  }

  .avatar-card {
    position: relative;
    display: flex;
    flex-direction: column;
    align-items: center;
    background-color: #fff;
    margin-top: 60rpx;
    padding: 40rpx 30rpx;
    border-radius: 20rpx;
    box-shadow: 0 8rpx 30rpx rgba(0, 0, 0, 0.1);
  }

  .avatar-wrapper {
    width: 160rpx;
    height: 160rpx;
    border-radius: 50%;
    background-color: #f5f6f7;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-bottom: 20rpx;
    border: 4rpx solid #e0e0e0;
  }

  .avatar-icon {
    font-size: 72rpx;
    color: #999;
  }

  .avatar-image {
    width: 160rpx;
    height: 160rpx;
    border-radius: 50%;
    margin-bottom: 20rpx;
    border: 4rpx solid #e0e0e0;
  }

  .user-name {
    font-size: 36rpx;
    font-weight: 600;
    color: #333;
    margin-bottom: 12rpx;
  }

  .user-role {
    font-size: 24rpx;
    color: #999;
    margin-bottom: 24rpx;
  }

  .edit-btn {
    display: flex;
    align-items: center;
    padding: 16rpx 32rpx;
    background-color: #f5f6f7;
    border-radius: 40rpx;
    font-size: 26rpx;
    color: #666;
  }

  .edit-btn .iconfont {
    margin-right: 8rpx;
    font-size: 24rpx;
  }

  /* 信息区域 */
  .info-section {
    margin: 30rpx;
    background-color: #fff;
    border-radius: 16rpx;
    padding: 20rpx 0;
    box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
  }

  .section-title {
    font-size: 30rpx;
    font-weight: 600;
    color: #333;
    padding: 20rpx 30rpx;
    border-bottom: 1rpx solid #f0f0f0;
    margin-bottom: 10rpx;
  }

  .info-list {
    padding: 10rpx 0;
  }

  .info-item {
    display: flex;
    align-items: center;
    padding: 26rpx 30rpx;
    border-bottom: 1rpx solid #f5f5f5;
  }

  .info-item:last-child {
    border-bottom: none;
  }

  .info-icon-wrapper {
    width: 56rpx;
    height: 56rpx;
    background-color: #f0f7ff;
    border-radius: 14rpx;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-right: 20rpx;
  }

  .info-icon {
    font-size: 28rpx;
    color: #3c96f3;
  }

  .info-content {
    flex: 1;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .info-label {
    font-size: 28rpx;
    color: #666;
  }

  .info-value {
    font-size: 28rpx;
    color: #333;
  }

  .status-wrapper {
    display: flex;
    align-items: center;
  }

  .status-dot {
    width: 12rpx;
    height: 12rpx;
    border-radius: 50%;
    margin-left: 12rpx;
  }

  .status-active {
    background-color: #39b54a;
  }

  .status-inactive {
    background-color: #ccc;
  }

  /* 操作按钮 */
  .action-section {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    padding: 20rpx 30rpx;
    padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
    background-color: #fff;
    display: flex;
    gap: 20rpx;
    box-shadow: 0 -4rpx 20rpx rgba(0, 0, 0, 0.05);
  }

  .action-btn {
    flex: 1;
    height: 88rpx;
    border-radius: 44rpx;
    font-size: 30rpx;
    font-weight: 500;
  }

  .action-btn::after {
    border: none;
  }

  .bg-primary {
    background: linear-gradient(135deg, #3c96f3 0%, #6b7bff 100%);
    color: #fff;
  }

  .bg-outline {
    background-color: #fff;
    color: #3c96f3;
    border: 2rpx solid #3c96f3;
  }
</style>