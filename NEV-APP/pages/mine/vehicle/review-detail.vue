<template>
  <view class="page" :class="{ 'page-ready': isReady }">
    <!-- 背景光晕矩阵（琥珀暖色系） -->
    <view class="glow-matrix">
      <view class="glow-row" v-for="(row, ri) in glowRows" :key="ri">
        <view class="glow-spot" v-for="(dot, ci) in row.dots" :key="ci" :style="dot.style"></view>
      </view>
    </view>
    <view class="overlay-mask"></view>

    <!-- 主滚动区 -->
    <scroll-view scroll-y class="main-scroll" :show-scrollbar="false">
      <!-- 顶栏 -->
      <view class="header">
        <view class="header-bg"></view>
        <view class="header-circle"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="header-info">
          <text class="header-title">评价详情</text>
          <text class="header-sub">客户真实反馈</text>
        </view>
      </view>

      <!-- 评价主体卡（大毛玻璃卡片） -->
      <view class="review-card">
        <view class="card-left-bar"></view>
        <!-- 用户信息行 -->
        <view class="card-top">
          <view class="avatar-box">
            <text class="avatar-letter">{{ review.avatarLetter }}</text>
          </view>
          <view class="user-col">
            <view class="user-row">
              <text class="user-name">{{ review.userName }}</text>
              <view class="star-row">
                <text class="star filled" v-for="s in review.rating" :key="s">★</text>
                <text class="star" v-for="s in (5 - review.rating)" :key="'e' + s">★</text>
              </view>
            </view>
            <text class="review-date">{{ review.createTime }}</text>
          </view>
        </view>
        <!-- 关联车辆标签 -->
        <view class="vehicle-tag">
          <text>🚗 {{ review.vehicleName }}</text>
        </view>
        <!-- 评价内容（完整展示） -->
        <view class="content-wrap">
          <text class="review-content">{{ review.content }}</text>
        </view>
        <!-- 配图区域（如有） -->
        <view class="image-grid" v-if="review.images && review.images.length > 0">
          <image
            class="review-img"
            v-for="(img, ii) in review.images"
            :key="ii"
            :src="img"
            mode="aspectFill"
            @tap="previewImage(ii)"
          />
        </view>
      </view>

      <!-- 操作区：返回列表按钮 -->
      <view class="action-area">
        <view class="back-list-btn" hover-class="btn-press" @tap="goBack">
          <text class="back-list-text">返回列表</text>
        </view>
      </view>

      <view style="height: 60rpx;"></view>
    </scroll-view>
  </view>
</template>

<script>
import { getReview } from '@/api/vehicle/vehicle'

export default {
  data: function() {
    return {
      isReady: false,
      glowRows: [],
      review: {}
    }
  },
  onLoad: function(options) {
    var that = this
    var reviewId = options.reviewId || 1
    that.buildGlowRows()
    // 从后端加载评价详情
    getReview(reviewId).then(function(res) {
      if (res.code === 1 && res.data) {
        var data = res.data
        that.review = {
          reviewId: data.reviewId,
          userName: data.nickName || '匿名用户',
          avatarLetter: (data.nickName || '匿').substring(0, 1),
          rating: data.rating || 0,
          vehicleName: data.vehicleName || '-',
          content: data.content || '',
          images: data.imageUrl ? data.imageUrl.split(',').filter(function(i) { return i }) : [],
          createTime: data.createTime || ''
        }
      } else {
        that.review = {
          reviewId: reviewId,
          userName: '未知用户',
          avatarLetter: '未',
          rating: 0,
          vehicleName: '-',
          content: '暂无评价内容',
          images: [],
          createTime: ''
        }
      }
      setTimeout(function() { that.isReady = true }, 200)
    }).catch(function() {
      that.review = {
        reviewId: reviewId,
        userName: '未知用户',
        avatarLetter: '未',
        rating: 0,
        vehicleName: '-',
        content: '加载失败',
        images: [],
        createTime: ''
      }
      setTimeout(function() { that.isReady = true }, 200)
    })
  },
  methods: {
    buildGlowRows: function() {
      var rows = []
      var colors = ['#f59e0b', '#f97316', '#fb923c', '#fbbf24', '#fcd34d', '#fde68a']
      for (var r = 0; r < 7; r++) {
        var dots = []
        var count = 4 + Math.floor(Math.random() * 3)
        for (var c = 0; c < count; c++) {
          var color = colors[Math.floor(Math.random() * colors.length)]
          var size = 60 + Math.floor(Math.random() * 70)
          var dur = 2.5 + Math.random() * 2.5
          var delay = Math.random() * 2.5
          var alpha = 0.08 + Math.random() * 0.18
          dots.push({
            style: 'width:' + size + 'rpx;height:' + size + 'rpx;background:radial-gradient(circle,' + color + ',' + color + '00);opacity:' + alpha.toFixed(2) + ';animation-duration:' + dur.toFixed(1) + 's;animation-delay:' + delay.toFixed(1) + 's;'
          })
        }
        rows.push({ dots: dots })
      }
      this.glowRows = rows
    },
    goBack: function() {
      uni.navigateBack({ delta: 1 })
    },
    previewImage: function(index) {
      uni.previewImage({
        urls: this.review.images,
        current: index
      })
    }
  }
}
</script>

<style scoped>
/* ========== 页面容器 ========== */
.page {
  min-height: 100vh;
  background: linear-gradient(180deg, #fff7ed 0%, #fffbeb 30%, #fefce8 60%, #fffbeb 100%);
  position: relative;
  overflow-x: hidden;
}
.page-ready .header { animation: fadeSlideDown 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; }
.page-ready .review-card { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.12s; }
.page-ready .image-grid { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.22s; }
.page-ready .action-area { animation: fadeSlideUp 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.32s; }

@keyframes fadeSlideDown {
  from { opacity: 0; transform: translateY(-20rpx); }
  to { opacity: 1; transform: translateY(0); }
}
@keyframes fadeSlideUp {
  from { opacity: 0; transform: translateY(30rpx) scale(0.96); }
  to { opacity: 1; transform: translateY(0) scale(1); }
}

/* ========== 背景光晕矩阵 ========== */
.glow-matrix {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 0;
  overflow: hidden;
  pointer-events: none;
}
.glow-row {
  display: flex;
  justify-content: space-around;
  align-items: center;
  padding: 24rpx 20rpx;
}
.glow-spot {
  border-radius: 50%;
  flex-shrink: 0;
  animation: glowPulse ease-in-out infinite alternate;
}
@keyframes glowPulse {
  0% { opacity: 0.15; transform: scale(0.85); }
  50% { opacity: 0.6; }
  100% { opacity: 0.15; transform: scale(1.25); }
}

.overlay-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(180deg,
    rgba(255, 247, 237, 0.92) 0%,
       rgba(255, 251, 235, 0.95) 35%,
       rgba(254, 252, 232, 0.96) 65%,
       rgba(255, 251, 235, 0.97) 100%
  );
  pointer-events: none;
  z-index: 1;
}
.main-scroll {
  position: relative;
  z-index: 2;
  height: 100vh;
}

/* ========== 顶栏 ========== */
.header {
  position: relative;
  padding: 28rpx 28rpx 24rpx;
  display: flex;
  align-items: center;
  overflow: hidden;
}
.header-bg {
  position: absolute;
  top: -80rpx;
  left: -40rpx;
  right: -40rpx;
  bottom: -20rpx;
  background: linear-gradient(135deg, #f59e0b 0%, #f97316 35%, #fb923c 65%, #fdba74 100%);
  border-radius: 0 0 60rpx 60rpx;
}
.header-circle {
  position: absolute;
  top: -50rpx;
  right: -30rpx;
  width: 300rpx;
  height: 300rpx;
  border-radius: 50%;
  background: radial-gradient(circle, rgba(255, 255, 255, 0.15) 0%, transparent 70%);
  pointer-events: none;
}
.back-btn {
  width: 64rpx;
  height: 64rpx;
  border-radius: 32rpx;
  background: rgba(255, 255, 255, 0.3);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2;
  box-shadow: 0 4rpx 14rpx rgba(0, 0, 0, 0.1);
}
.btn-hover {
  transform: scale(0.9);
  background: rgba(255, 255, 255, 0.45);
}
.back-icon {
  font-size: 36rpx;
  color: #ffffff;
  font-weight: 300;
}
.header-info {
  flex: 1;
  margin-left: 20rpx;
  z-index: 2;
  display: flex;
  flex-direction: column;
}
.header-title {
  font-size: 38rpx;
  font-weight: 800;
  color: #ffffff;
  letter-spacing: 1rpx;
  text-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.1);
}
.header-sub {
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.88);
  margin-top: 6rpx;
  font-weight: 500;
}

/* ========== 评价主体卡（大毛玻璃卡片） ========== */
.review-card {
  margin: 16rpx 24rpx 0;
  background: rgba(255, 255, 255, 0.88);
  backdrop-filter: blur(18px);
  -webkit-backdrop-filter: blur(18px);
  border-radius: 26rpx;
  padding: 28rpx 26rpx;
  box-shadow: 0 8rpx 32rpx rgba(0, 0, 0, 0.06), inset 0 1rpx 0 rgba(255, 255, 255, 0.95);
  border: 1rpx solid rgba(255, 255, 255, 0.85);
  position: relative;
  overflow: hidden;
}
.card-left-bar {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 6rpx;
  background: linear-gradient(180deg, #f59e0b, #fb923c);
  border-radius: 26rpx 0 0 26rpx;
  box-shadow: 2rpx 0 14rpx rgba(245, 158, 11, 0.25);
}

/* 卡片顶部用户信息 */
.card-top {
  display: flex;
  flex-direction: row;
  align-items: center;
  margin-bottom: 18rpx;
}
.avatar-box {
  width: 80rpx;
  height: 80rpx;
  border-radius: 40rpx;
  background: linear-gradient(135deg, #f59e0b, #fbbf24);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 18rpx;
  flex-shrink: 0;
  box-shadow: 0 4rpx 14rpx rgba(245, 158, 11, 0.3);
}
.avatar-letter {
  font-size: 32rpx;
  font-weight: 800;
  color: #ffffff;
  line-height: 1;
}
.user-col {
  flex: 1;
  display: flex;
  flex-direction: column;
}
.user-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  margin-bottom: 6rpx;
}
.user-name {
  font-size: 30rpx;
  font-weight: 700;
  color: #1c1917;
  margin-right: 14rpx;
}
.star-row {
  display: flex;
  flex-direction: row;
  gap: 3rpx;
}
.star {
  font-size: 26rpx;
  color: #e5e7eb;
}
.star.filled {
  color: #f59e0b;
}
.review-date {
  font-size: 23rpx;
  color: #a8a29e;
  font-weight: 500;
}

/* 关联车辆标签 */
.vehicle-tag {
  display: inline-flex;
  padding: 10rpx 20rpx;
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.08), rgba(251, 191, 36, 0.04));
  border-radius: 14rpx;
  border: 1rpx solid rgba(245, 158, 11, 0.12);
  margin-bottom: 20rpx;
}
.vehicle-tag text {
  font-size: 23rpx;
  color: #d97706;
  font-weight: 600;
}

/* 评价内容（完整展示） */
.content-wrap {
  margin-bottom: 10rpx;
}
.review-content {
  font-size: 28rpx;
  color: #44403c;
  line-height: 1.85;
  font-weight: 400;
  white-space: pre-line;
  display: block;
}

/* 配图区域 */
.image-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 12rpx;
  margin-top: 16rpx;
}
.review-img {
  width: 200rpx;
  height: 200rpx;
  border-radius: 14rpx;
  background: #f5f5f4;
}

/* ========== 操作区 ========== */
.action-area {
  padding: 32rpx 24rpx 0;
}
.back-list-btn {
  background: linear-gradient(135deg, #f59e0b, #d97706);
  border-radius: 20rpx;
  padding: 22rpx 0;
  text-align: center;
  box-shadow: 0 6rpx 24rpx rgba(245, 158, 11, 0.35);
}
.btn-press {
  transform: scale(0.97);
  opacity: 0.9;
}
.back-list-text {
  font-size: 30rpx;
  color: #ffffff;
  font-weight: 700;
  letter-spacing: 2rpx;
}
</style>
