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
    <scroll-view scroll-y class="main-scroll" :show-scrollbar="false" @scrolltolower="loadMore">
      <!-- 顶栏 -->
      <view class="header">
        <view class="header-bg"></view>
        <view class="header-circle"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="header-info">
          <text class="header-title">客户评价</text>
          <text class="header-sub">{{ totalCount }} 条评价 · 好评率 {{ goodRate }}</text>
        </view>
      </view>

      <!-- 统计概览条 -->
      <view class="stats-bar">
        <view class="stat-item">
          <text class="stat-score">{{ avgScore }}</text>
          <text class="stat-star-icon">★</text>
          <text class="stat-label">综合评分</text>
        </view>
        <view class="stat-divider"></view>
        <view class="stat-item">
          <text class="stat-num">{{ totalCount }}</text>
          <text class="stat-label">总评价数</text>
        </view>
        <view class="stat-divider"></view>
        <view class="stat-item">
          <text class="stat-num rate-text">{{ goodRate }}</text>
          <text class="stat-label">好评率</text>
        </view>
      </view>

      <!-- 筛选标签 -->
      <view class="filter-tabs">
        <scroll-view scroll-x class="tab-scroll" :show-scrollbar="false">
          <view
            class="tab-item"
            v-for="(tab, idx) in filterTabs"
            :key="idx"
            :class="{ active: activeTab === idx }"
            @tap="switchTab(idx)"
          >
            <text>{{ tab.label }}</text>
          </view>
        </scroll-view>
      </view>

      <!-- 评价卡片列表 -->
      <view class="review-list">
        <!-- 空状态 -->
        <view v-if="filteredReviews.length === 0" class="empty-state">
          <view class="empty-circle">
            <text class="empty-icon">⭐</text>
          </view>
          <text class="empty-text">暂无相关评价</text>
          <text class="empty-hint">用户评价会显示在这里</text>
        </view>

        <!-- 卡片列表 -->
        <view
          class="review-card"
          v-for="(item, idx) in filteredReviews"
          :key="idx"
          hover-class="card-hover"
          @tap="goDetail(item.reviewId)"
        >
          <view class="card-left-bar"></view>
          <!-- 用户信息行 -->
          <view class="card-top">
            <view class="avatar-box">
              <text class="avatar-letter">{{ item.avatarLetter }}</text>
            </view>
            <view class="user-col">
              <view class="user-row">
                <text class="user-name">{{ item.userName }}</text>
                <view class="star-row">
                  <text class="star" v-for="s in 5" :key="s" :class="{ filled: s <= item.rating }">★</text>
                </view>
              </view>
              <text class="review-date">{{ item.date }}</text>
            </view>
          </view>
          <!-- 关联车辆 -->
          <view class="vehicle-tag">
            <text>🚗 {{ item.vehicleName }}</text>
          </view>
          <!-- 评价内容 -->
          <view class="content-wrap">
            <text class="review-content" :class="{ collapsed: !item.expanded && (item.content || '').length > 50 }">{{ item.content }}</text>
            <view class="expand-btn" v-if="(item.content || '').length > 50" @tap.stop="toggleExpand(idx)">
              <text>{{ item.expanded ? '收起' : '展开' }}</text>
            </view>
          </view>
          <!-- 商家回复 -->
          <view class="reply-box" v-if="item.reply">
            <text class="reply-label">商家回复：</text>
            <text class="reply-content">{{ item.reply }}</text>
          </view>
        </view>
      </view>

      <!-- 加载更多提示 -->
      <view class="load-more-tip" v-if="filteredReviews.length > 0">
        <text class="load-text">— 已经到底了 —</text>
      </view>

      <view style="height: 60rpx;"></view>
    </scroll-view>
  </view>
</template>

<script>
export default {
  data: function() {
    return {
      isReady: false,
      glowRows: [],
      activeTab: 0,
      avgScore: '4.8',
      totalCount: 5,
      goodRate: '96%',
      filterTabs: [
        { label: '全部', value: 'all' },
        { label: '5星', value: 5 },
        { label: '4星', value: 4 },
        { label: '3星及以下', value: 3 }
      ],
      mockReviews: [
        {
          reviewId: 1,
          userName: '张**',
          avatarLetter: '张',
          rating: 5,
          vehicleName: '比亚迪海豹 EV 700km 四驱旗舰版',
          content: '车子非常满意！续航真实，内饰做工精细，销售服务态度很好。提车当天就跑了200公里高速，电耗很满意。推荐购买！',
          reply: '感谢您的信任与支持！祝您用车愉快~',
          date: '2026-05-31',
          expanded: false
        },
        {
          reviewId: 2,
          userName: '李**',
          avatarLetter: '李',
          rating: 5,
          vehicleName: '特斯拉 Model Y 后驱版',
          content: 'Model Y的空间很大，家用完全够用。自动驾驶辅助功能在高速上很好用。充电也方便，家里装了家充桩。',
          reply: '',
          date: '2026-05-30',
          expanded: false
        },
        {
          reviewId: 3,
          userName: '王**',
          avatarLetter: '王',
          rating: 4,
          vehicleName: '蔚来 ES6 75kWh 运动版',
          content: '整体不错，换电服务确实方便。就是价格稍微有点高，不过考虑到服务和品质还是值得的。NOMI语音助手孩子很喜欢。',
          reply: '感谢您的认可！关于价格我们会持续优化优惠活动，欢迎关注。',
          date: '2026-05-29',
          expanded: false
        },
        {
          reviewId: 4,
          userName: '赵**',
          avatarLetter: '赵',
          rating: 5,
          vehicleName: '理想 L7 Pro 增程版',
          content: '作为家庭用车非常合适，六座布局老人小孩都舒服。增程解决了里程焦虑，市区用电长途用油，完美组合。冰箱彩电大沙发一个不少！',
          reply: '',
          date: '2026-05-28',
          expanded: false
        },
        {
          reviewId: 5,
          userName: '刘**',
          avatarLetter: '刘',
          rating: 3,
          vehicleName: '比亚迪汉 DM-i 冠军版',
          content: '油耗表现不错，纯电模式够日常通勤。但是车机系统偶尔卡顿，希望后续OTA能优化。总体还是满意的。',
          reply: '收到您的反馈，我们会将车机问题反馈给技术团队处理。',
          date: '2026-05-27',
          expanded: false
        }
      ]
    }
  },
  computed: {
    filteredReviews: function() {
      var that = this
      var list = that.mockReviews.slice()
      if (that.activeTab === 0) return list
      if (that.activeTab === 1) return list.filter(function(r) { return r.rating === 5 })
      if (that.activeTab === 2) return list.filter(function(r) { return r.rating === 4 })
      if (that.activeTab === 3) return list.filter(function(r) { return r.rating <= 3 })
      return list
    }
  },
  created: function() {
    this.buildGlowRows()
    var that = this
    setTimeout(function() {
      that.isReady = true
    }, 200)
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
    switchTab: function(idx) {
      this.activeTab = idx
    },
    goDetail: function(reviewId) {
      uni.navigateTo({ url: '/pages/mine/vehicle/review-detail?reviewId=' + reviewId })
    },
    toggleExpand: function(idx) {
      this.mockReviews[idx].expanded = !this.mockReviews[idx].expanded
    },
    isLongContent: function(content) {
      return content.length > 50
    },
    loadMore: function() {
      console.log('加载更多')
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
.page-ready .stats-bar { animation: fadeSlideUp 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.1s; }
.page-ready .filter-tabs { animation: fadeSlideUp 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.18s; }
.page-ready .review-card { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; }
.page-ready .review-card:nth-child(1) { animation-delay: 0.26s; }
.page-ready .review-card:nth-child(2) { animation-delay: 0.34s; }
.page-ready .review-card:nth-child(3) { animation-delay: 0.42s; }
.page-ready .review-card:nth-child(4) { animation-delay: 0.50s; }
.page-ready .review-card:nth-child(5) { animation-delay: 0.58s; }

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
  transition: all 0.2s ease;
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

/* ========== 统计概览条 ========== */
.stats-bar {
  margin: 16rpx 24rpx 0;
  display: flex;
  flex-direction: row;
  align-items: center;
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border-radius: 22rpx;
  padding: 24rpx 16rpx;
  box-shadow: 0 6rpx 28rpx rgba(0, 0, 0, 0.05), inset 0 1rpx 0 rgba(255, 255, 255, 0.9);
  border: 1rpx solid rgba(255, 255, 255, 0.8);
  position: relative;
  z-index: 2;
}
.stat-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}
.stat-score {
  font-size: 48rpx;
  font-weight: 900;
  color: #d97706;
  line-height: 1;
}
.stat-star-icon {
  font-size: 28rpx;
  color: #f59e0b;
  margin-left: 4rpx;
  line-height: 1;
}
.stat-num {
  font-size: 36rpx;
  font-weight: 800;
  color: #451a03;
  line-height: 1;
}
.rate-text {
  color: #16a34a;
}
.stat-label {
  font-size: 21rpx;
  color: #a8a29e;
  margin-top: 6rpx;
  font-weight: 600;
}
.stat-divider {
  width: 1rpx;
  height: 52rpx;
  background: linear-gradient(180deg, transparent, #e5e7eb, transparent);
}

/* ========== 筛选标签 ========== */
.filter-tabs {
  padding: 20rpx 24rpx 12rpx;
  position: relative;
  z-index: 2;
}
.tab-scroll {
  white-space: nowrap;
}
.tab-item {
  display: inline-block;
  padding: 14rpx 28rpx;
  margin-right: 14rpx;
  border-radius: 30rpx;
  font-size: 26rpx;
  color: #6b7280;
  background: rgba(255, 255, 255, 0.75);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  transition: all 0.3s ease;
  border: 1rpx solid rgba(0, 0, 0, 0.04);
}
.tab-item text {
  font-weight: 500;
}
.tab-item.active {
  background: linear-gradient(135deg, #f59e0b, #d97706);
  color: #ffffff;
  box-shadow: 0 4rpx 16rpx rgba(245, 158, 11, 0.35);
  border-color: transparent;
}
.tab-item.active text {
  font-weight: 700;
}

/* ========== 评价列表 ========== */
.review-list {
  padding: 0 24rpx;
  position: relative;
  z-index: 2;
}

/* ========== 空状态 ========== */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 160rpx 0;
}
.empty-circle {
  width: 160rpx;
  height: 160rpx;
  border-radius: 80rpx;
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.1), rgba(251, 191, 36, 0.05));
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 28rpx;
}
.empty-icon {
  font-size: 64rpx;
  opacity: 0.55;
}
.empty-text {
  font-size: 30rpx;
  color: #78716c;
  font-weight: 700;
  margin-bottom: 10rpx;
}
.empty-hint {
  font-size: 24rpx;
  color: #a8a29e;
}

/* ========== 评价卡片 ========== */
.review-card {
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  border-radius: 22rpx;
  padding: 24rpx 22rpx;
  margin-bottom: 18rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.04), inset 0 1rpx 0 rgba(255, 255, 255, 0.9);
  border: 1rpx solid rgba(255, 255, 255, 0.8);
  position: relative;
  overflow: hidden;
  transition: all 0.3s ease;
}
.card-hover {
  transform: scale(0.98) translateY(-2rpx);
  box-shadow: 0 10rpx 32rpx rgba(0, 0, 0, 0.09);
  border-color: rgba(245, 158, 11, 0.2);
}
.card-left-bar {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 5rpx;
  background: linear-gradient(180deg, #f59e0b, #fb923c);
  border-radius: 22rpx 0 0 22rpx;
  box-shadow: 2rpx 0 12rpx rgba(245, 158, 11, 0.2);
  transition: all 0.3s ease;
}
.card-hover .card-left-bar {
  width: 7rpx;
  box-shadow: 4px 0 20rpx rgba(245, 158, 11, 0.35);
}

/* 卡片顶部用户信息 */
.card-top {
  display: flex;
  flex-direction: row;
  align-items: center;
  margin-bottom: 14rpx;
}
.avatar-box {
  width: 72rpx;
  height: 72rpx;
  border-radius: 36rpx;
  background: linear-gradient(135deg, #f59e0b, #fbbf24);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 16rpx;
  flex-shrink: 0;
  box-shadow: 0 4rpx 12rpx rgba(245, 158, 11, 0.25);
}
.avatar-letter {
  font-size: 28rpx;
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
  margin-bottom: 4rpx;
}
.user-name {
  font-size: 27rpx;
  font-weight: 700;
  color: #1c1917;
  margin-right: 12rpx;
}
.star-row {
  display: flex;
  flex-direction: row;
  gap: 2rpx;
}
.star {
  font-size: 22rpx;
  color: #e5e7eb;
}
.star.filled {
  color: #f59e0b;
}
.review-date {
  font-size: 21rpx;
  color: #a8a29e;
  font-weight: 500;
}

/* 关联车辆标签 */
.vehicle-tag {
  display: inline-flex;
  padding: 8rpx 18rpx;
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.08), rgba(251, 191, 36, 0.04));
  border-radius: 12rpx;
  border: 1rpx solid rgba(245, 158, 11, 0.12);
  margin-bottom: 14rpx;
}
.vehicle-tag text {
  font-size: 22rpx;
  color: #d97706;
  font-weight: 600;
}

/* 评价内容 */
.content-wrap {
  margin-bottom: 10rpx;
}
.review-content {
  font-size: 26rpx;
  color: #44403c;
  line-height: 1.7;
  font-weight: 400;
  display: block;
}
.review-content.collapsed {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
}
.expand-btn {
  display: inline-block;
  margin-top: 8rpx;
  padding: 4rpx 16rpx;
}
.expand-btn text {
  font-size: 24rpx;
  color: #d97706;
  font-weight: 600;
}

/* 商家回复 */
.reply-box {
  background: linear-gradient(135deg, rgba(34, 197, 94, 0.06), rgba(74, 222, 128, 0.03));
  border-radius: 14rpx;
  padding: 16rpx 18rpx;
  border-left: 4rpx solid #22c55e;
  box-shadow: inset 0 1rpx 2rpx rgba(34, 197, 94, 0.06);
}
.reply-label {
  font-size: 22rpx;
  color: #16a34a;
  font-weight: 700;
}
.reply-content {
  font-size: 24rpx;
  color: #57534e;
  line-height: 1.6;
  margin-top: 4rpx;
  display: block;
}

/* ========== 加载更多 ========== */
.load-more-tip {
  text-align: center;
  padding: 32rpx 0 16rpx;
}
.load-text {
  font-size: 24rpx;
  color: #ccc;
  letter-spacing: 2rpx;
}
</style>
