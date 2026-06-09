<template>
  <view class="avatar-container">
    <!-- 头像预览区域 -->
    <view class="preview-section">
      <view class="preview-bg"></view>
      <view class="preview-card">
        <view class="avatar-preview">
          <view v-if="!avatarUrl" class="avatar-placeholder" @click="chooseImage">
            <view class="iconfont icon-camera"></view>
            <text>点击更换头像</text>
          </view>
          <image v-else :src="avatarUrl" class="avatar-image" mode="aspectFill"></image>
        </view>
        <view class="preview-tip">建议使用正方形图片</view>
      </view>
    </view>

    <!-- 操作按钮区域 -->
    <view class="action-section">
      <view class="action-card">
        <view class="action-title">选择方式</view>
        <view class="action-list">
          <view class="action-item" @click="chooseFromAlbum">
            <view class="action-icon-box bg-blue">
              <text class="iconfont icon-image"></text>
            </view>
            <view class="action-info">
              <text class="action-name">从相册选择</text>
              <text class="action-desc">选择手机相册中的图片</text>
            </view>
            <text class="iconfont icon-right action-arrow"></text>
          </view>
          <view class="action-item" @click="takePhoto">
            <view class="action-icon-box bg-green">
              <text class="iconfont icon-camera"></text>
            </view>
            <view class="action-info">
              <text class="action-name">拍照</text>
              <text class="action-desc">使用相机拍摄照片</text>
            </view>
            <text class="iconfont icon-right action-arrow"></text>
          </view>
        </view>
      </view>

      <view class="action-card">
        <view class="action-title">提示</view>
        <view class="tips-content">
          <view class="tip-item">
            <text class="tip-dot">•</text>
            <text class="tip-text">支持 JPG、PNG 格式图片</text>
          </view>
          <view class="tip-item">
            <text class="tip-dot">•</text>
            <text class="tip-text">图片大小不超过 2MB</text>
          </view>
          <view class="tip-item">
            <text class="tip-dot">•</text>
            <text class="tip-text">建议尺寸 200x200 像素</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 保存按钮 -->
    <view class="submit-section">
      <button @click="handleSave" :disabled="!avatarUrl" class="submit-btn" :class="{ disabled: !avatarUrl }">保存头像</button>
    </view>
  </view>
</template>

<script>
  import { uploadAvatar } from "@/api/system/user"
  import config from '@/config'

  export default {
    data() {
      return {
        avatarUrl: ''
      }
    },
    onLoad() {
      // 从 Vuex 获取当前头像
      this.avatarUrl = this.$store.state.user.avatar || ''
    },
    methods: {
      chooseImage() {
        uni.showActionSheet({
          itemList: ['从相册选择', '拍照'],
          success: (res) => {
            if (res.tapIndex === 0) {
              this.chooseFromAlbum()
            } else {
              this.takePhoto()
            }
          }
        })
      },
      chooseFromAlbum() {
        uni.chooseImage({
          count: 1,
          sizeType: ['compressed'],
          sourceType: ['album'],
          success: (res) => {
            this.avatarUrl = res.tempFilePaths[0]
          },
          fail: () => {
            this.$modal.msgError('选择图片失败')
          }
        })
      },
      takePhoto() {
        uni.chooseImage({
          count: 1,
          sizeType: ['compressed'],
          sourceType: ['camera'],
          success: (res) => {
            this.avatarUrl = res.tempFilePaths[0]
          },
          fail: () => {
            this.$modal.msgError('拍照失败')
          }
        })
      },
      handleSave() {
        if (!this.avatarUrl) {
          this.$modal.msgError('请先选择头像')
          return
        }

        this.$modal.loading('上传中...')

        uploadAvatar({
          filePath: this.avatarUrl,
          name: 'avatarfile'
        }).then(response => {
          this.$modal.closeLoading()
          this.$modal.msgSuccess('头像上传成功')
          // 后端返回 imgUrl （相对路径），拼接 baseUrl 得到完整访问地址
          const newAvatar = response.imgUrl ? (config.baseUrl + response.imgUrl) : (response.data || response.url || this.avatarUrl)
          this.$store.commit('SET_AVATAR', newAvatar)
          setTimeout(() => {
            this.$tab.navigateBack()
          }, 1500)
        }).catch(() => {
          this.$modal.closeLoading()
          this.$modal.msgError('头像上传失败，请重试')
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

  .avatar-container {
    width: 100%;
    min-height: 100vh;
    padding-bottom: 160rpx;
  }

  /* 头像预览区域 */
  .preview-section {
    position: relative;
    padding: 60rpx 30rpx;
    overflow: hidden;
  }

  .preview-bg {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 400rpx;
    background: linear-gradient(135deg, #3c96f3 0%, #6b7bff 100%);
  }

  .preview-card {
    position: relative;
    background-color: #fff;
    border-radius: 20rpx;
    padding: 40rpx;
    box-shadow: 0 8rpx 30rpx rgba(0, 0, 0, 0.1);
    display: flex;
    flex-direction: column;
    align-items: center;
  }

  .avatar-preview {
    width: 240rpx;
    height: 240rpx;
    border-radius: 50%;
    overflow: hidden;
    margin-bottom: 20rpx;
    border: 4rpx solid #e0e0e0;
  }

  .avatar-placeholder {
    width: 100%;
    height: 100%;
    background-color: #f5f6f7;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }

  .avatar-placeholder .iconfont {
    font-size: 56rpx;
    color: #999;
    margin-bottom: 12rpx;
  }

  .avatar-placeholder text {
    font-size: 24rpx;
    color: #999;
  }

  .avatar-image {
    width: 100%;
    height: 100%;
  }

  .preview-tip {
    font-size: 24rpx;
    color: #999;
  }

  /* 操作区域 */
  .action-section {
    padding: 30rpx;
  }

  .action-card {
    background-color: #fff;
    border-radius: 16rpx;
    margin-bottom: 20rpx;
    padding: 20rpx 0;
    box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
  }

  .action-title {
    font-size: 30rpx;
    font-weight: 600;
    color: #333;
    padding: 20rpx 30rpx;
    border-bottom: 1rpx solid #f0f0f0;
  }

  .action-list {
    padding: 10rpx 0;
  }

  .action-item {
    display: flex;
    align-items: center;
    padding: 26rpx 30rpx;
    border-bottom: 1rpx solid #f5f5f5;
  }

  .action-item:last-child {
    border-bottom: none;
  }

  .action-icon-box {
    width: 72rpx;
    height: 72rpx;
    border-radius: 18rpx;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-right: 24rpx;
  }

  .bg-blue {
    background-color: #e6f0ff;
  }

  .bg-blue .iconfont {
    color: #3c96f3;
  }

  .bg-green {
    background-color: #e8f5e9;
  }

  .bg-green .iconfont {
    color: #39b54a;
  }

  .action-icon-box .iconfont {
    font-size: 32rpx;
  }

  .action-info {
    flex: 1;
    display: flex;
    flex-direction: column;
  }

  .action-name {
    font-size: 28rpx;
    color: #333;
    margin-bottom: 6rpx;
  }

  .action-desc {
    font-size: 22rpx;
    color: #999;
  }

  .action-arrow {
    font-size: 24rpx;
    color: #ccc;
  }

  /* 提示内容 */
  .tips-content {
    padding: 20rpx 30rpx;
  }

  .tip-item {
    display: flex;
    margin-bottom: 12rpx;
  }

  .tip-item:last-child {
    margin-bottom: 0;
  }

  .tip-dot {
    color: #3c96f3;
    margin-right: 12rpx;
    font-size: 28rpx;
  }

  .tip-text {
    font-size: 26rpx;
    color: #666;
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

  .submit-btn.disabled {
    background: #ccc;
  }

  .submit-btn::after {
    border: none;
  }

  .icon-camera:before {
    content: "\e60b";
  }

  .icon-image:before {
    content: "\e631";
  }
</style>