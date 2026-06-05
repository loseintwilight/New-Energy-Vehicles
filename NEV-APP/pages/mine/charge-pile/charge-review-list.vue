<template>
  <view class="page" :class="{ 'page-ready': isReady }">
    <!-- 背景光晕矩阵 -->
    <view class="glow-matrix">
      <view class="glow-row" v-for="(row, ri) in glowRows" :key="ri">
        <view
          class="glow-spot"
          v-for="(dot, ci) in row.dots"
          :key="ci"
          :style="dot.style"
        ></view>
      </view>
    </view>
    <view class="overlay-mask"></view>

    <!-- 主滚动区 -->
    <scroll-view scroll-y class="main-scroll" :show-scrollbar="false">
      <!-- 顶栏 -->
      <view class="header">
        <view class="header-bg"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="header-info">
          <text class="header-title">充电评价管理</text>
          <text class="header-sub">共 {{ filteredReviews.length }} 条评价</text>
        </view>
      </view>

      <!-- 统计概览条 -->
      <view class="stats-bar">
        <view class="stat-item">
          <text class="stat-val">{{ totalReviews }}</text>
          <text class="stat-label">总评价数</text>
        </view>
        <view class="stat-divider"></view>
        <view class="stat-item">
          <text class="stat-val stat-score">{{ avgScore }}</text>
          <text class="stat-label">平均评分</text>
        </view>
        <view class="stat-divider"></view>
        <view class="stat-item">
          <text class="stat-val stat-pending">{{ pendingCount }}</text>
          <text class="stat-label">待回复</text>
        </view>
      </view>

      <!-- 筛选标签栏 - 评分 -->
      <view class="filter-section">
        <scroll-view scroll-x class="filter-scroll-x" :show-scrollbar="false">
          <view class="filter-row">
            <view
              class="filter-chip"
              v-for="(item, idx) in ratingTabs"
              :key="idx"
              :class="{ active: activeRating === idx }"
              @tap="switchRating(idx)"
            >
              <text>{{ item.label }}</text>
            </view>
          </view>
        </scroll-view>

        <!-- 筛选标签栏 - 回复状态 -->
        <scroll-view scroll-x class="filter-scroll-x" :show-scrollbar="false">
          <view class="filter-row">
            <view
              class="filter-chip"
              v-for="(item, idx) in replyTabs"
              :key="idx + 100"
              :class="{ active: activeReply === idx }"
              @tap="switchReply(idx)"
            >
              <text>{{ item.label }}</text>
            </view>
          </view>
        </scroll-view>
      </view>

      <!-- 评价卡片列表 -->
      <view class="review-list-wrap">
        <!-- 空状态 -->
        <view class="empty-state" v-if="filteredReviews.length === 0">
          <text class="empty-icon">⭐</text>
          <text class="empty-title">暂无评价数据</text>
          <text class="empty-desc">用户充电完成后会在此显示评价</text>
        </view>

        <!-- 评价卡片 -->
        <view
          class="review-card"
          v-for="(item, idx) in filteredReviews"
          :key="item.reviewId"
          :style="{ animationDelay: (idx * 0.08) + 's' }"
          hover-class="card-hover"
          :hover-stay-time="120"
          @tap="goDetail(item)"
        >
          <!-- 左侧彩色条 -->
          <view class="rc-bar" :class="'bar-rating-' + getRatingLevel(item.rating)"></view>
          <!-- 卡片主体 -->
          <view class="rc-body">
            <!-- 顶部：用户 + 评分 + 时间 -->
            <view class="rc-top">
              <view class="rc-user">
                <view class="user-avatar" :style="{ background: item.avatarBg }">
                  <text class="avatar-text">{{ item.userName.charAt(0) }}</text>
                </view>
                <view class="user-info">
                  <text class="user-name">{{ item.userName }}</text>
                  <text class="user-station">{{ item.stationName }} · {{ item.pileCode }}</text>
                </view>
              </view>
              <view class="rc-right">
                <view class="star-row">
                  <text class="star-icon" v-for="s in 5" :key="s" :class="{ filled: s <= item.rating }">★</text>
                </view>
                <text class="rc-time">{{ item.createTime }}</text>
              </view>
            </view>

            <!-- 评价内容 -->
            <view class="rc-content">
              <text class="rc-text">{{ item.content }}</text>
            </view>

            <!-- 底部：回复状态 + 箭头 -->
            <view class="rc-bottom">
              <view class="reply-tag" :class="'rt-' + item.replyStatus">
                <text class="reply-text">{{ item.replyStatus === 1 ? '已回复' : '待回复' }}</text>
              </view>
              <view class="bottom-arrow">
                <text class="arrow-icon">›</text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <view style="height: 120rpx;"></view>
    </scroll-view>
  </view>
</template>

<script>
export default {
  data: function() {
    return {
      isReady: false,
      glowRows: [],
      activeRating: 0,
      activeReply: 0,

      /* Mock数据：充电评价（来自stad_charging_settlement） */
      mockReviews: [
        { reviewId: 1, userName: '张先生', phone: '138****6789', stationName: '济南奥体中心充电站', pileCode: 'DC-001', rating: 5, content: '充电速度很快，桩位好找，环境干净整洁，下次还来！', createTime: '2026-06-03 14:30', replyStatus: 1, replyContent: '感谢您的认可，欢迎下次光临！', avatarBg: 'linear-gradient(135deg, #fef3c7, #fde68a)' },
        { reviewId: 2, userName: '李女士', phone: '139****8901', stationName: '济南万达广场充电站', pileCode: 'DC-003', rating: 4, content: '整体不错，就是周末人有点多需要排队，希望能增加快充桩数量。', createTime: '2026-06-03 11:20', replyStatus: 1, replyContent: '收到建议，我们正在规划扩容，谢谢反馈！', avatarBg: 'linear-gradient(135deg, #dbeafe, #bfdbfe)' },
        { reviewId: 3, userName: '王先生', phone: '136****2345', stationName: '青岛万象城充电站', pileCode: 'AC-002', rating: 2, content: '充电桩故障，插上枪没反应，等了20分钟才换到别的桩，体验很差。', createTime: '2026-06-02 18:45', replyStatus: 0, replyContent: '', avatarBg: 'linear-gradient(135deg, #fee2e2, #fecaca)' },
        { reviewId: 4, userName: '赵女士', phone: '137****4567', stationName: '淄博万象汇充电站', pileCode: 'DC-002', rating: 5, content: '第一次来这个站，设施很新，停车方便，价格也合理，五星好评！', createTime: '2026-06-02 16:10', replyStatus: 0, replyContent: '', avatarBg: 'linear-gradient(135deg, #dcfce7, #bbf7d0)' },
        { reviewId: 5, userName: '孙先生', phone: '135****7890', stationName: '济南奥体中心充电站', pileCode: 'DC-004', rating: 3, content: '中规中矩吧，没什么特别的，就是普通充电站。', createTime: '2026-06-01 22:05', replyStatus: 1, replyContent: '我们会持续提升服务品质，感谢您的使用。', avatarBg: 'linear-gradient(135deg, #f3e8ff, #e9d5ff)' },
        { reviewId: 6, userName: '周女士', phone: '158****1122', stationName: '烟台芝罘万达充电站', pileCode: 'DC-001', rating: 4, content: '位置很好找，就在商场地下停车场B2层，充电顺便逛逛街很方便。', createTime: '2026-06-01 09:30', replyStatus: 0, replyContent: '', avatarBg: 'linear-gradient(135deg, #ccfbf1, #99f6e4)' },
        { reviewId: 7, userName: '吴先生', phone: '186****3344', stationName: '济南万达广场充电站', pileCode: 'AC-001', rating: 1, content: 'App经常连不上桩，客服电话打不通，非常糟糕的体验！', createTime: '2026-05-31 15:20', replyStatus: 0, replyContent: '', avatarBg: 'linear-gradient(255, 235, 235, 253, 230)' },
        { reviewId: 8, userName: '郑女士', phone: '177****5566', stationName: '青岛万象城充电站', pileCode: 'DC-001', rating: 5, content: '夜间充电有优惠活动，凌晨过来充的，几乎没人，体验超棒！', createTime: '2026-05-31 02:18', replyStatus: 1, replyContent: '夜间优惠持续进行中，欢迎常来~', avatarBg: 'linear-gradient(135deg, #ffe4e6, #fecdd3)' }
      ],

      /* 筛选项 */
      ratingTabs: [
        { label: '全部', value: 0 },
        { label: '⭐⭐⭐⭐⭐ 好评', value: 5 },
        { label: '⭐⭐⭐⭐ 中评', value: 4 },
        { label: '⭐⭐⭐ 一般', value: 3 },
        { label: '⭐⭐ 差评', value: 2 }
      ],
      replyTabs: [
        { label: '全部状态', value: 0 },
        { label: '待回复', value: 1 },
        { label: '已回复', value: 2 }
      ]
    }
  },

  computed: {
    /* 筛选后的列表 */
    filteredReviews: function() {
      var list = this.mockReviews
      var self = this

      /* 按评分筛选 */
      if (this.activeRating > 0) {
        var targetRating = this.ratingTabs[this.activeRating].value
        if (targetRating === 5) {
          list = list.filter(function(r) { return r.rating === 5 })
        } else if (targetRating === 4) {
          list = list.filter(function(r) { return r.rating === 4 })
        } else if (targetRating === 3) {
          list = list.filter(function(r) { return r.rating === 3 })
        } else if (targetRating === 2) {
          list = list.filter(function(r) { return r.rating <= 2 })
        }
      }

      /* 按回复状态筛选 */
      if (this.activeReply === 1) {
        list = list.filter(function(r) { return r.replyStatus === 0 })
      } else if (this.activeReply === 2) {
        list = list.filter(function(r) { return r.replyStatus === 1 })
      }

      return list
    },

    /* 统计 */
    totalReviews: function() {
      return this.mockReviews.length
    },
    avgScore: function() {
      if (this.mockReviews.length === 0) return '0.0'
      var sum = 0
      for (var i = 0; i < this.mockReviews.length; i++) {
        sum += this.mockReviews[i].rating
      }
      return (sum / this.mockReviews.length).toFixed(1)
    },
    pendingCount: function() {
      var c = 0
      for (var i = 0; i < this.mockReviews.length; i++) {
        if (this.mockReviews[i].replyStatus === 0) c++
      }
      return c
    }
  },

  created: function() {
    this.buildGlowRows()
    var self = this
    setTimeout(function() { self.isReady = true }, 200)
  },

  methods: {
    buildGlowRows: function() {
      var rows = []
      var colors = ['#f59e0b', '#f97316', '#fb923c', '#fbbf24', '#fcd34d', '#fde68a']
      for (var r = 0; r < 7; r++) {
        var dots = []
        for (var c = 0; c < 6; c++) {
          var size = Math.random() * 120 + 40
          dots.push({
            style: 'left:' + (c * 18 + Math.random() * 12) + '%;top:' + (r * 16 + Math.random() * 10) + '%;width:' + size + 'rpx;height:' + size + 'rpx;background:' + colors[Math.floor(Math.random() * colors.length)] + ';opacity:' + (Math.random() * 0.06 + 0.02) + ';border-radius:50%;animation:floatGlow ' + (Math.random() * 6 + 4) + 's ease-in-out ' + (Math.random() * 2) + 's infinite alternate;'
          })
        }
        rows.push({ dots: dots })
      }
      this.glowRows = rows
    },

    goBack: function() {
      uni.navigateBack({ delta: 1 })
    },

    switchRating: function(idx) {
      this.activeRating = idx
    },

    switchReply: function(idx) {
      this.activeReply = idx
    },

    goDetail: function(item) {
      uni.navigateTo({
        url: '/pages/mine/charge-pile/charge-review-detail?reviewId=' + item.reviewId
      })
    },

    getRatingLevel: function(rating) {
      if (rating >= 4) return 'good'
      if (rating === 3) return 'mid'
      return 'bad'
    }
  }
}
</script>

<style scoped>
/* ========== 页面容器 ========== */
.page {
  min-height: 100vh;
  background: linear-gradient(180deg, #fff7ed 0%, #fffbeb 35%, #fefce8 65%, #fffbeb 100%);
  position: relative;
  overflow-x: hidden;
}

/* 光晕矩阵 */
.glow-matrix {
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  z-index: 0;
  pointer-events: none;
}
.glow-spot {
  position: absolute;
  border-radius: 50%;
  filter: blur(60rpx);
}
@keyframes floatGlow {
  0% { transform: translate(0, 0) scale(1); }
  100% { transform: translate(20rpx, -30rpx) scale(1.15); }
}

/* 遮罩层 */
.overlay-mask {
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  background: linear-gradient(180deg, rgba(255,247,237,0.92) 0%, rgba(255,251,235,0.95) 38%, rgba(254,252,232,0.96) 66%, rgba(255,247,237,0.97) 100%);
  z-index: 1;
  pointer-events: none;
}

/* 主滚动区 */
.main-scroll {
  height: 100vh;
  position: relative;
  z-index: 2;
}

/* ---------- 入场动画 ---------- */
.page-ready .main-scroll { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) both; }
@keyframes fadeSlideUp {
  from { opacity: 0; transform: translateY(28rpx); }
  to { opacity: 1; transform: translateY(0); }
}

/* ========== 顶栏 ========== */
.header {
  display: flex;
  flex-direction: row;
  align-items: center;
  padding: 28rpx 28rpx 24rpx;
  position: relative;
  overflow: hidden;
}
.header-bg {
  position: absolute;
  top: -80rpx;
  left: -40rpx;
  right: -40rpx;
  bottom: -20rpx;
  background: linear-gradient(135deg, #d97706 0%, #f59e0b 40%, #fb923c 70%, #fbbf24 100%);
  border-radius: 0 0 60rpx 60rpx;
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
.back-icon { font-size: 36rpx; color: #ffffff; font-weight: 300; }
.btn-hover { transform: scale(0.92); background: rgba(255, 255, 255, 0.32); }
.header-info { flex: 1; margin-left: 20rpx; z-index: 2; display: flex; flex-direction: column; }
.header-title { font-size: 38rpx; color: #ffffff; font-weight: 800; letter-spacing: 1rpx; text-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.1); }
.header-sub { font-size: 24rpx; color: rgba(255, 255, 255, 0.88); margin-top: 6rpx; font-weight: 500; }

/* ========== 统计概览条 ========== */
.stats-bar {
  margin: 24rpx 24rpx 18rpx;
  padding: 22rpx 16rpx;
  border-radius: 22rpx;
  background: rgba(255, 255, 255, 0.72);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  display: flex;
  flex-direction: row;
  align-items: center;
  box-shadow: 0 4rpx 20rpx rgba(245, 158, 11, 0.07);
  border: 1rpx solid rgba(255, 255, 255, 0.85);
}
.stat-item { flex: 1; display: flex; flex-direction: column; align-items: center; }
.stat-val { font-size: 34rpx; font-weight: 700; color: #1f2937; }
.stat-label { font-size: 22rpx; color: #9ca3af; margin-top: 4rpx; }
.stat-divider { width: 1rpx; height: 44rpx; background: linear-gradient(180deg, transparent, #e5e7eb, transparent); }
.stat-score { color: #f59e0b !important; }
.stat-pending { color: #ef4444 !important; }

/* ========== 筛选栏 ========== */
.filter-section { padding: 0 24rpx; margin-bottom: 14rpx; }
.filter-scroll-x { white-space: nowrap; margin-bottom: 12rpx; }
.filter-row { display: inline-flex; gap: 14rpx; }
.filter-chip {
  display: inline-flex;
  align-items: center;
  padding: 12rpx 26rpx;
  border-radius: 28rpx;
  background: rgba(255, 255, 255, 0.75);
  border: 1rpx solid rgba(209, 213, 219, 0.5);
  font-size: 24rpx;
  color: #6b7280;
  font-weight: 500;
  transition: all 0.25s ease;
  white-space: nowrap;
}
.filter-chip.active {
  background: linear-gradient(135deg, #f59e0b, #fb923c);
  color: #ffffff;
  border-color: transparent;
  box-shadow: 0 4rpx 14rpx rgba(245, 158, 11, 0.3);
}

/* ========== 评价列表 ========== */
.review-list-wrap { padding: 0 24rpx; }

/* 空状态 */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 120rpx 40rpx;
}
.empty-icon { font-size: 88rpx; margin-bottom: 20rpx; }
.empty-title { font-size: 30rpx; color: #374151; font-weight: 600; margin-bottom: 10rpx; }
.empty-desc { font-size: 24rpx; color: #9ca3af; text-align: center; }

/* 评价卡片 */
.review-card {
  display: flex;
  flex-direction: row;
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(18px);
  -webkit-backdrop-filter: blur(18px);
  border-radius: 22rpx;
  margin-bottom: 18rpx;
  box-shadow: 0 6rpx 26rpx rgba(0, 0, 0, 0.04), 0 2rpx 8rpx rgba(245, 158, 11, 0.04);
  border: 1rpx solid rgba(255, 255, 255, 0.8);
  position: relative;
  overflow: hidden;
  transition: all 0.35s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.card-hover {
  transform: scale(0.98)!important;
  box-shadow: 0 12rpx 36rpx rgba(0, 0, 0, 0.09)!important;
}

/* 左侧颜色条 */
.rc-bar {
  width: 5rpx;
  flex-shrink: 0;
  transition: all 0.3s ease;
}
.bar-rating-good { background: linear-gradient(180deg, #f59e0b, #fb923c); box-shadow: 0 0 12rpx rgba(245,158,11,0.25); }
.bar-rating-mid { background: linear-gradient(180deg, #fbbf24, #fcd34d); box-shadow: 0 0 12rpx rgba(251,191,36,0.25); }
.bar-rating-bad { background: linear-gradient(180deg, #f97316, #ea580c); box-shadow: 0 0 12rpx rgba(249,115,22,0.3); }
.card-hover .bar-rating-good { width: 7rpx; box-shadow: 0 0 24rpx rgba(245,158,11,0.45), 0 0 48rpx rgba(245,158,11,0.15); }
.card-hover .bar-rating-mid { width: 7rpx; box-shadow: 0 0 24rpx rgba(251,191,36,0.45), 0 0 48rpx rgba(251,191,36,0.15); }
.card-hover .bar-rating-bad { width: 7rpx; box-shadow: 0 0 24rpx rgba(249,115,22,0.5), 0 0 48rpx rgba(249,115,22,0.18); }

/* 卡片主体 */
.rc-body {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: 20rpx 18rpx 18rpx;
  gap: 12rpx;
}

/* 顶部 */
.rc-top {
  display: flex;
  flex-direction: row;
  align-items: flex-start;
  justify-content: space-between;
}
.rc-user { display: flex; flex-direction: row; align-items: center; gap: 14rpx; flex: 1; min-width: 0; }
.user-avatar {
  width: 64rpx; height: 64rpx;
  border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  flex-shrink: 0;
}
.avatar-text { font-size: 26rpx; color: #ffffff; font-weight: 700; }
.user-info { display: flex; flex-direction: column; gap: 4rpx; min-width: 0; }
.user-name { font-size: 28rpx; color: #1f2937; font-weight: 600; }
.user-station { font-size: 22rpx; color: #9ca3af; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }

.rc-right { display: flex; flex-direction: column; align-items: flex-end; gap: 6rpx; flex-shrink: 0; margin-left: 12rpx; }
.star-row { display: flex; flex-direction: row; gap: 2rpx; }
.star-icon { font-size: 24rpx; color: #e5e7eb; }
.star-icon.filled { color: #f59e0b; }
.rc-time { font-size: 20rpx; color: #9ca3af; }

/* 评价内容 */
.rc-content { padding: 0 4rpx; }
.rc-text { font-size: 26rpx; color: #4b5563; line-height: 1.6; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; }

/* 底部 */
.rc-bottom {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  padding-top: 8rpx;
  border-top: 1rpx solid rgba(0, 0, 0, 0.04);
}
.reply-tag {
  padding: 4rpx 16rpx;
  border-radius: 8rpx;
  font-size: 20rpx;
  font-weight: 600;
}
.rt-0 { background: linear-gradient(135deg, rgba(239,68,68,0.1), rgba(239,68,68,0.05)); color: #dc2626; }
.rt-1 { background: linear-gradient(135deg, rgba(34,197,94,0.1), rgba(34,197,94,0.05)); color: #16a34a; }
.bottom-arrow { padding: 6rpx 4rpx; }
.arrow-icon { font-size: 32rpx; color: #d1d5db; font-weight: 300; }
</style>
