<template>
  <view class="page-container">
    <view class="under-construction">
      <view class="uc-icon-wrapper">
        <uni-icons type="circle" size="80" color="#3c96f3"></uni-icons>
      </view>
      <text class="uc-title">意见反馈</text>
      <text class="uc-desc">意见反馈功能正在建设中</text>
      <text class="uc-sub">您可以在这里提交反馈和建议</text>
      <view class="uc-features">
        <view class="uc-feature-item">
          <uni-icons type="checkmarkempty" size="20" color="#27ae60"></uni-icons>
          <text>提交反馈</text>
        </view>
        <view class="uc-feature-item">
          <uni-icons type="checkmarkempty" size="20" color="#27ae60"></uni-icons>
          <text>反馈记录</text>
        </view>
        <view class="uc-feature-item">
          <uni-icons type="checkmarkempty" size="20" color="#27ae60"></uni-icons>
          <text>客服回复</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
import { submitFeedback, getFeedbackList } from '@/api/feedback'

export default {
  data() {
    return {
      content: '',
      images: [],
      contact: '',
      feedbackType: 'suggest',
      feedbackTypes: [
        { label: '功能建议', value: 'suggest' },
        { label: '问题反馈', value: 'problem' },
        { label: '其他', value: 'other' }
      ],
      submitting: false
    }
  },
  methods: {
    async handleSubmit() {
      if (!this.content.trim()) {
        uni.showToast({ title: '请输入反馈内容', icon: 'none' })
        return
      }
      
      this.submitting = true
      try {
        await submitFeedback({
          content: this.content,
          type: this.feedbackType,
          contact: this.contact,
          images: this.images
        })
        uni.showToast({ title: '提交成功', icon: 'success' })
        this.content = ''
        this.images = []
        this.contact = ''
      } catch (e) {
        uni.showToast({ title: '提交失败', icon: 'none' })
      } finally {
        this.submitting = false
      }
    }
  }
}
</script>

<style lang="scss" scoped>
page {
  background-color: #f5f6f7;
  min-height: 100vh;
}

.under-construction {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 120rpx 60rpx;
}

.uc-icon-wrapper {
  width: 160rpx;
  height: 160rpx;
  border-radius: 50%;
  background: #e8f0fe;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 40rpx;
}

.uc-title {
  font-size: 36rpx;
  font-weight: 600;
  color: #333;
  margin-bottom: 16rpx;
}

.uc-desc {
  font-size: 28rpx;
  color: #999;
  margin-bottom: 8rpx;
}

.uc-sub {
  font-size: 24rpx;
  color: #bbb;
  margin-bottom: 50rpx;
}

.uc-features {
  width: 100%;
  background: #fff;
  border-radius: 16rpx;
  padding: 30rpx;
}

.uc-feature-item {
  display: flex;
  align-items: center;
  padding: 16rpx 0;
  border-bottom: 1rpx solid #f5f5f5;
  font-size: 28rpx;
  color: #333;
}

.uc-feature-item:last-child {
  border-bottom: none;
}

.uc-feature-item text {
  margin-left: 16rpx;
}
</style>