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
          <text class="header-title">评价详情</text>
          <text class="header-sub">{{ review.user }}</text>
        </view>
        <view class="header-right" @tap="deleteReview">
          <text class="delete-text">删除</text>
        </view>
      </view>

      <view class="review-hero">
        <view class="hero-avatar">
          <text class="hero-avatar-text">{{ review.avatar }}</text>
        </view>
        <text class="hero-name">{{ review.user }}</text>
        <view class="hero-stars">
          <text class="h-star" v-for="s in 5" :key="s" :class="{ active: s <= review.rating }">★</text>
        </view>
        <text class="hero-vehicle">{{ review.vehicle }}</text>
        <text class="hero-time">{{ review.time }}</text>
      </view>

      <view class="info-section">
        <view class="section-title">
          <view class="title-line"></view>
          <text class="title-text">评价内容</text>
        </view>
        <view class="info-card">
          <text class="content-text">{{ review.content }}</text>
          <view class="content-tags" v-if="review.tags">
            <text class="c-tag" v-for="(tag, ti) in review.tags" :key="ti">{{ tag }}</text>
          </view>
        </view>
      </view>

      <view class="info-section" v-if="review.reply">
        <view class="section-title">
          <view class="title-line line-green"></view>
          <text class="title-text">商家回复</text>
        </view>
        <view class="info-card reply-card">
          <text class="reply-text">{{ review.reply }}</text>
          <text class="reply-time">回复于 {{ review.replyTime || review.time }}</text>
        </view>
      </view>

      <view class="info-section" v-if="!review.reply">
        <view class="section-title">
          <view class="title-line line-green"></view>
          <text class="title-text">回复评价</text>
        </view>
        <view class="info-card">
          <textarea class="reply-input" v-model="replyText" placeholder="输入您的回复内容..." placeholder-class="ph" />
          <view class="reply-submit" @tap="submitReply">
            <text class="submit-text">发送回复</text>
          </view>
        </view>
      </view>

      <view class="bottom-safe"></view>
    </scroll-view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      isReady: false,
      glowRows: [],
      replyText: '',
      review: {}
    }
  },
  onLoad(options) {
    var self = this
    this.review = {
      id: options.id || 1,
      user: '张先生',
      avatar: '张',
      rating: 5,
      vehicle: '比亚迪 海豹 2025款 冠军版',
      time: '2025-06-01 14:30',
      content: '非常满意的一次购车体验！销售顾问专业耐心，从选车到试驾再到提车，每个环节都很顺畅。车辆品质超出预期，外观设计时尚动感，内饰做工精细。充电方便，续航表现优秀，日常通勤完全够用。售后服务也很到位，有问题随时响应。强烈推荐！',
      tags: ['服务好', '续航强', '充电快', '外观时尚'],
      reply: '感谢您的认可和详细分享！我们一直致力于为每一位客户提供最优质的购车体验和服务。您的满意是我们最大的动力，祝您用车愉快！如有任何问题，随时联系我们。',
      replyTime: '2025-06-01 16:00'
    }
    this.buildGlowRows()
    setTimeout(function() { self.isReady = true }, 200)
  },
  methods: {
    buildGlowRows() {
      var rows = []
      var colors = ['#f59e0b', '#fbbf24', '#fcd34d', '#fde68a']
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
    deleteReview() {
      var self = this
      uni.showModal({
        title: '删除评价',
        content: '确定要删除这条评价吗？',
        success: function(res) {
          if (res.confirm) { uni.showToast({ title: '已删除', icon: 'success' }); setTimeout(function() { uni.navigateBack() }, 1500) }
        }
      })
    },
    submitReply() {
      if (!this.replyText) { uni.showToast({ title: '请输入回复内容', icon: 'none' }); return }
      uni.showToast({ title: '回复成功', icon: 'success' })
      var self = this
      setTimeout(function() { self.review.reply = self.replyText; self.replyText = '' }, 1500)
    }
  }
}
</script>

<style scoped>
.page { min-height: 100vh; background: linear-gradient(180deg, #fffbeb 0%, #fefce8 30%, #fef9c3 60%, #fffbeb 100%); opacity: 0; transition: opacity 0.5s ease; }
.page-ready { opacity: 1; }
.glow-matrix { position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 0; overflow: hidden; pointer-events: none; }
.glow-row { display: flex; justify-content: space-around; padding: 20rpx 30rpx; }
.glow-spot { border-radius: 50%; filter: blur(6px); opacity: 0; animation: glowPulse ease-in-out infinite alternate; }
@keyframes glowPulse { 0% { opacity: 0; transform: scale(0.6); } 50% { opacity: 0.5; } 100% { opacity: 0; transform: scale(1.4); } }
.overlay-mask { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: linear-gradient(180deg, rgba(255,251,235,0.35) 0%, rgba(254,252,232,0.45) 38%, rgba(254,249,195,0.55) 66%, rgba(255,251,235,0.65) 100%); z-index: 1; pointer-events: none; }
.main-scroll { position: relative; z-index: 2; }

.header { position: relative; padding: 30rpx 28rpx 24rpx; display: flex; align-items: center; }
.header-bg { position: absolute; top: -60rpx; left: -40rpx; right: -40rpx; bottom: 0; background: radial-gradient(ellipse at 20% 30%, rgba(245,158,11,0.1) 0%, transparent 60%), radial-gradient(ellipse at 80% 50%, rgba(251,191,36,0.08) 0%, transparent 55%); border-radius: 0 0 60rpx 60rpx; }
.back-btn { width: 60rpx; height: 60rpx; border-radius: 30rpx; background: rgba(255,255,255,0.75); backdrop-filter: blur(10px); display: flex; align-items: center; justify-content: center; z-index: 1; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06); }
.back-icon { font-size: 28rpx; color: #92400e; }
.header-info { flex: 1; margin-left: 20rpx; z-index: 1; }
.header-title { font-size: 36rpx; font-weight: 700; color: #451a03; display: block; }
.header-sub { font-size: 24rpx; color: #b45309; margin-top: 4rpx; display: block; }
.header-right { z-index: 1; }
.delete-text { font-size: 26rpx; color: #ef4444; }

.review-hero { text-align: center; padding: 20rpx 28rpx 32rpx; }
.hero-avatar { width: 88rpx; height: 88rpx; border-radius: 44rpx; background: linear-gradient(135deg, #f59e0b, #fbbf24); display: flex; align-items: center; justify-content: center; margin: 0 auto 16rpx; }
.hero-avatar-text { font-size: 36rpx; color: #fff; font-weight: 700; }
.hero-name { font-size: 32rpx; font-weight: 600; color: #1f2937; display: block; }
.hero-stars { margin: 8rpx 0; }
.h-star { font-size: 32rpx; color: #e5e7eb; margin: 0 2rpx; }
.h-star.active { color: #f59e0b; }
.hero-vehicle { font-size: 26rpx; color: #d97706; display: block; }
.hero-time { font-size: 24rpx; color: #9ca3af; display: block; margin-top: 4rpx; }

.info-section { padding: 0 28rpx 16rpx; }
.section-title { display: flex; align-items: center; margin-bottom: 16rpx; }
.title-line { width: 6rpx; height: 28rpx; background: linear-gradient(180deg, #f59e0b, #d97706); border-radius: 3rpx; margin-right: 12rpx; }
.title-line.line-green { background: linear-gradient(180deg, #fbbf24, #f59e0b); }
.title-text { font-size: 28rpx; font-weight: 600; color: #92400e; }
.info-card { background: rgba(255,255,255,0.8); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 24rpx; box-shadow: 0 2rpx 16rpx rgba(0,0,0,0.04); }
.content-text { font-size: 28rpx; color: #374151; line-height: 1.8; }
.content-tags { display: flex; flex-wrap: wrap; gap: 8rpx; margin-top: 16rpx; }
.c-tag { font-size: 22rpx; color: #d97706; background: rgba(245,158,11,0.1); padding: 6rpx 16rpx; border-radius: 12rpx; }

.reply-card { }
.reply-text { font-size: 28rpx; color: #374151; line-height: 1.8; }
.reply-time { font-size: 24rpx; color: #9ca3af; margin-top: 12rpx; display: block; }

.reply-input { width: 100%; height: 160rpx; font-size: 28rpx; color: #1f2937; }
.ph { color: #d1d5db; }
.reply-submit { margin-top: 16rpx; background: linear-gradient(135deg, #f59e0b, #d97706); border-radius: 16rpx; padding: 16rpx; text-align: center; }
.reply-submit:active { transform: scale(0.97); }
.submit-text { font-size: 28rpx; color: #fff; font-weight: 600; }

.bottom-safe { height: 40rpx; }
</style>