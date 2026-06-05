<template>
  <view class="page" :class="{ 'page-ready': isReady }">
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

    <scroll-view scroll-y class="main-scroll" :show-scrollbar="false">
      <!-- 顶栏 -->
      <view class="header">
        <view class="header-bg" :class="'hb-' + getRatingLevel(review.rating)"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="header-info">
          <text class="header-title">评价详情</text>
          <text class="header-sub">{{ review.userName }} 的充电评价</text>
        </view>
      </view>

      <!-- 评分卡片 -->
      <view class="score-card">
        <view class="score-big">
          <text class="score-num">{{ review.rating }}</text>
          <text class="score-unit">/ 5</text>
        </view>
        <view class="star-big-row">
          <text class="star-big" v-for="s in 5" :key="s" :class="{ filled: s <= review.rating }">★</text>
        </view>
        <text class="score-label">{{ getRatingText(review.rating) }}</text>
      </view>

      <!-- 用户信息 -->
      <view class="info-section">
        <view class="bar-line bar-line-orange2"></view>
        <text class="section-title">用户信息</text>
        <view class="info-grid">
          <view class="info-cell">
            <text class="info-lbl">用户昵称</text>
            <text class="info-val name-val">{{ review.userName }}</text>
          </view>
          <view class="info-cell">
            <text class="info-lbl">联系电话</text>
            <text class="info-val">{{ review.phone }}</text>
          </view>
          <view class="info-cell">
            <text class="info-lbl">充电站点</text>
            <text class="info-val station-val">{{ review.stationName }}</text>
          </view>
          <view class="info-cell">
            <text class="info-lbl">充电桩号</text>
            <text class="info-val pile-val">{{ review.pileCode }}</text>
          </view>
          <view class="info-cell">
            <text class="info-lbl">评价时间</text>
            <text class="info-val time-val">{{ review.createTime }}</text>
          </view>
        </view>
      </view>

      <!-- 评价内容 -->
      <view class="content-section">
        <view class="bar-line bar-line-green"></view>
        <text class="section-title">评价内容</text>
        <view class="content-box">
          <text class="content-text">{{ review.content }}</text>
        </view>
      </view>

      <!-- 回复区域 -->
      <view class="reply-section" v-if="review.replyStatus === 1">
        <view class="bar-line bar-line-blue"></view>
        <text class="section-title">商家回复</text>
        <view class="reply-box">
          <view class="reply-header">
            <text class="reply-badge">已回复</text>
          </view>
          <text class="reply-text">{{ review.replyContent }}</text>
        </view>
      </view>

      <view class="reply-section" v-else>
        <view class="bar-line bar-line-purple"></view>
        <text class="section-title">回复评价</text>
        <textarea
          class="reply-input"
          v-model="replyText"
          placeholder="请输入回复内容..."
          placeholder-class="reply-placeholder"
          maxlength="200"
        ></textarea>
        <view class="reply-actions">
          <view class="btn-reply" @tap="doReply">
            <text class="btn-reply-text">发送回复</text>
          </view>
        </view>
      </view>

      <!-- 操作按钮区 -->
      <view class="action-section">
        <view class="action-card act-back" hover-class="act-hover" @tap="goBack">
          <view class="act-color-bar ac-back-bar"></view>
          <text class="act-icon">←</text>
          <text class="act-name">返回列表</text>
          <text class="act-desc">查看更多评价</text>
        </view>
      </view>

      <view style="height: 100rpx;"></view>
    </scroll-view>
  </view>
</template>

<script>
export default {
  data: function() {
    return {
      isReady: false,
      glowRows: [],
      reviewId: '',
      replyText: '',
      review: {
        reviewId: '', userName: '', phone: '', stationName: '',
        pileCode: '', rating: 0, content: '', createTime: '',
        replyStatus: 0, replyContent: ''
      },

      /* Mock数据池 */
      mockDataMap: {
        '1': { userName: '张先生', phone: '138****6789', stationName: '济南奥体中心充电站', pileCode: 'DC-001', rating: 5, content: '充电速度很快，桩位好找，环境干净整洁，下次还来！', createTime: '2026-06-03 14:30', replyStatus: 1, replyContent: '感谢您的认可，欢迎下次光临！' },
        '2': { userName: '李女士', phone: '139****8901', stationName: '济南万达广场充电站', pileCode: 'DC-003', rating: 4, content: '整体不错，就是周末人有点多需要排队，希望能增加快充桩数量。', createTime: '2026-06-03 11:20', replyStatus: 1, replyContent: '收到建议，我们正在规划扩容，谢谢反馈！' },
        '3': { userName: '王先生', phone: '136****2345', stationName: '青岛万象城充电站', pileCode: 'AC-002', rating: 2, content: '充电桩故障，插上枪没反应，等了20分钟才换到别的桩，体验很差。', createTime: '2026-06-02 18:45', replyStatus: 0, replyContent: '' },
        '4': { userName: '赵女士', phone: '137****4567', stationName: '淄博万象汇充电站', pileCode: 'DC-002', rating: 5, content: '第一次来这个站，设施很新，停车方便，价格也合理，五星好评！', createTime: '2026-06-02 16:10', replyStatus: 0, replyContent: '' },
        '5': { userName: '孙先生', phone: '135****7890', stationName: '济南奥体中心充电站', pileCode: 'DC-004', rating: 3, content: '中规中矩吧，没什么特别的，就是普通充电站。', createTime: '2026-06-01 22:05', replyStatus: 1, replyContent: '我们会持续提升服务品质，感谢您的使用。' },
        '6': { userName: '周女士', phone: '158****1122', stationName: '烟台芝罘万达充电站', pileCode: 'DC-001', rating: 4, content: '位置很好找，就在商场地下停车场B2层，充电顺便逛逛街很方便。', createTime: '2026-06-01 09:30', replyStatus: 0, replyContent: '' },
        '7': { userName: '吴先生', phone: '186****3344', stationName: '济南万达广场充电站', pileCode: 'AC-001', rating: 1, content: 'App经常连不上桩，客服电话打不通，非常糟糕的体验！', createTime: '2026-05-31 15:20', replyStatus: 0, replyContent: '' },
        '8': { userName: '郑女士', phone: '177****5566', stationName: '青岛万象城充电站', pileCode: 'DC-001', rating: 5, content: '夜间充电有优惠活动，凌晨过来充的，几乎没人，体验超棒！', createTime: '2026-05-31 02:18', replyStatus: 1, replyContent: '夜间优惠持续进行中，欢迎常来~' }
      }
    }
  },
  onLoad: function(options) {
    if (options && options.reviewId) {
      this.reviewId = options.reviewId
      this.loadReviewData(options.reviewId)
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

    loadReviewData: function(reviewId) {
      var data = this.mockDataMap[reviewId]
      if (data) {
        data.reviewId = reviewId
        this.review = data
      }
    },

    goBack: function() {
      uni.navigateBack({ delta: 1 })
    },

    doReply: function() {
      if (!this.replyText.trim()) {
        uni.showToast({ title: '请输入回复内容', icon: 'none' }); return
      }
      var self = this
      uni.showModal({
        title: '确认发送',
        content: '确定发送此回复吗？',
        success: function(res) {
          if (res.confirm) {
            self.review.replyStatus = 1
            self.review.replyContent = self.replyText
            self.replyText = ''
            uni.showToast({ title: '回复成功', icon: 'success' })
          }
        }
      })
    },

    getRatingLevel: function(rating) {
      if (rating >= 4) return 'good'
      if (rating === 3) return 'mid'
      return 'bad'
    },

    getRatingText: function(rating) {
      if (rating >= 5) return '非常满意'
      if (rating === 4) return '比较满意'
      if (rating === 3) return '一般般'
      if (rating === 2) return '不太满意'
      return '非常不满意'
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
.glow-matrix { position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 0; pointer-events: none; }
.glow-spot { position: absolute; border-radius: 50%; filter: blur(60rpx); }
@keyframes floatGlow {
  0% { transform: translate(0, 0) scale(1); }
  100% { transform: translate(20rpx, -30rpx) scale(1.15); }
}
.overlay-mask { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: linear-gradient(180deg, rgba(255,247,237,0.92) 0%, rgba(255,251,235,0.95) 38%, rgba(254,252,232,0.96) 66%, rgba(255,247,237,0.97) 100%); z-index: 1; pointer-events: none; }
.main-scroll { height: 100vh; position: relative; z-index: 2; }

.page-ready .main-scroll { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) both; }
@keyframes fadeSlideUp {
  from { opacity: 0; transform: translateY(28rpx); }
  to { opacity: 1; transform: translateY(0); }
}

/* ========== 顶栏 ========== */
.header {
  display: flex; flex-direction: row; align-items: center;
  padding: 80rpx 28rpx 36rpx; position: relative; z-index: 2;
}
.header-bg {
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 280rpx;
  border-radius: 0 0 48rpx 48rpx;
  box-shadow: 0 10rpx 40rpx rgba(217, 119, 6, 0.18);
}
.hb-good { background: linear-gradient(135deg, #d97706 0%, #f59e0b 40%, #fb923c 70%, #fbbf24 100%); }
.hb-mid { background: linear-gradient(135deg, #f59e0b 0%, #fb923c 35%, #fcd34d 65%, #fde68a 100%); }
.hb-bad { background: linear-gradient(135deg, #f97316 0%, #ea580c 30%, #dc2626 65%, #ef4444 100%); }
.back-btn { width: 64rpx; height: 64rpx; border-radius: 50%; background: rgba(255,255,255,0.22); display: flex; align-items: center; justify-content: center; z-index: 3; }
.back-icon { font-size: 36rpx; color: #ffffff; font-weight: 300; }
.btn-hover { transform: scale(0.92); background: rgba(255,255,255,0.32); }
.header-info { flex: 1; margin-left: 18rpx; z-index: 2; }
.header-title { font-size: 36rpx; color: #ffffff; font-weight: 700; letter-spacing: 1rpx; }
.header-sub { font-size: 24rpx; color: rgba(255,255,255,0.82); margin-top: 4rpx; font-weight: 500; }

/* ========== 评分卡片 ========== */
.score-card {
  margin: 16rpx 24rpx 18rpx;
  padding: 32rpx;
  border-radius: 24rpx;
  background: rgba(255, 255, 255, 0.88);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  display: flex; flex-direction: column; align-items: center;
  gap: 12rpx;
  box-shadow: 0 10rpx 40rpx rgba(217, 119, 6, 0.12);
  border: 1rpx solid rgba(255, 255, 255, 0.9);
  position: relative; z-index: 3;
}
.page-ready .score-card { animation: fadeSlideUp 0.5s 0.15s cubic-bezier(0.34, 1.56, 0.64, 1) both; }
.score-big { display: flex; align-items: baseline; gap: 4rpx; }
.score-num { font-size: 72rpx; font-weight: 800; color: #f59e0b; line-height: 1; }
.score-unit { font-size: 28rpx; color: #d97706; font-weight: 600; }
.star-big-row { display: flex; gap: 8rpx; }
.star-big { font-size: 38rpx; color: #e5e7eb; }
.star-big.filled { color: #f59e0b; }
.score-label { font-size: 26rpx; color: #9ca3af; font-weight: 500; }

/* ========== 信息区块 ========== */
.info-section, .content-section, .reply-section {
  margin: 0 24rpx 18rpx;
  padding: 24rpx;
  border-radius: 22rpx;
  background: rgba(255, 255, 255, 0.82);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.04);
  border: 1rpx solid rgba(255, 255, 255, 0.85);
}
.bar-line { width: 5rpx; height: 28rpx; border-radius: 3rpx; margin-right: 14rpx; flex-shrink: 0; }
.bar-line-orange2 { background: linear-gradient(180deg, #b45309, #d97706); box-shadow: 0 0 10rpx rgba(180,83,9,0.3); }
.bar-line-green { background: linear-gradient(180deg, #d97706, #f59e0b); box-shadow: 0 0 10rpx rgba(217,119,6,0.3); }
.bar-line-blue { background: linear-gradient(180deg, #f59e0b, #fb923c); box-shadow: 0 0 10rpx rgba(245,158,11,0.3); }
.bar-line-purple { background: linear-gradient(180deg, #fb923c, #fbbf24); box-shadow: 0 0 10rpx rgba(251,146,60,0.3); }

.section-title { display: flex; align-items: center; font-size: 28rpx; font-weight: 700; color: #1f2937; margin-bottom: 18rpx; }

.info-grid { display: flex; flex-direction: column; gap: 14rpx; }
.info-cell { display: flex; flex-direction: row; align-items: center; justify-content: space-between; padding: 10rpx 0; border-bottom: 1rpx solid rgba(0,0,0,0.03); }
.info-cell:last-child { border-bottom: none; }
.info-lbl { font-size: 24rpx; color: #9ca3af; }
.info-val { font-size: 26rpx; color: #374151; font-weight: 500; }
.name-val { color: #d97706 !important; font-weight: 600; }
.station-val { color: #f59e0b !important; }
.pile-val { color: #b45309 !important; }
.time-val { color: #6b7280; }

/* ========== 评价内容 ========== */
.content-box { padding: 16rpx 8rpx; }
.content-text { font-size: 28rpx; color: #4b5563; line-height: 1.75; }

/* ========== 回复区域 ========== */
.reply-box { padding: 16rpx; background: linear-gradient(135deg, rgba(245,158,11,0.05), rgba(251,146,60,0.03)); border-radius: 14rpx; border: 1rpx solid rgba(245,158,11,0.1); }
.reply-header { margin-bottom: 10rpx; }
.reply-badge { display: inline-block; padding: 4rpx 14rpx; border-radius: 8rpx; font-size: 20rpx; font-weight: 600; background: linear-gradient(135deg, rgba(34,197,94,0.12), rgba(74,222,128,0.06)); color: #16a34a; }
.reply-text { font-size: 27rpx; color: #4b5563; line-height: 1.7; }

/* 回复输入 */
.reply-input {
  width: 100%;
  min-height: 160rpx;
  padding: 18rpx;
  border-radius: 16rpx;
  background: #fafaf9;
  border: 1rpx solid #e5e7eb;
  font-size: 27rpx;
  color: #374151;
  line-height: 1.6;
  box-sizing: border-box;
}
.reply-placeholder { color: #9ca3af; }
.reply-actions { display: flex; justify-content: flex-end; margin-top: 14rpx; }
.btn-reply {
  padding: 14rpx 40rpx;
  border-radius: 14rpx;
  background: linear-gradient(135deg, #f59e0b, #fb923c);
  box-shadow: 0 4rpx 14rpx rgba(245, 158, 11, 0.3);
}
.btn-reply-text { font-size: 26rpx; color: #ffffff; font-weight: 600; }

/* ========== 操作按钮区 ========== */
.action-section { display: flex; gap: 16rpx; padding: 0 24rpx; position: relative; z-index: 2; }
.action-card {
  flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center;
  padding: 28rpx 16rpx; border-radius: 22rpx; position: relative; overflow: hidden;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  box-shadow: 0 6rpx 24rpx rgba(0, 0, 0, 0.06);
}
.act-hover { transform: scale(0.95)!important; box-shadow: 0 12rpx 32rpx rgba(0, 0, 0, 0.12)!important; }
.act-color-bar { position: absolute; left: 0; top: 0; bottom: 0; width: 5rpx; border-radius: 22rpx 0 0 22rpx; transition: all 0.3s ease; }
.act-hover .act-color-bar { width: 7rpx; }
.act-icon { font-size: 36rpx; margin-bottom: 10rpx; }
.act-name { font-size: 26rpx; font-weight: 700; }
.act-desc { font-size: 21rpx; margin-top: 4rpx; }
.act-back { background: linear-gradient(135deg, #f59e0b, #f97316, #fb923c); }
.act-back .ac-back-bar { background: linear-gradient(180deg, #ffffff 0%, rgba(255,255,255,0.3) 100%); }
.act-back .act-icon, .act-back .act-name { color: #ffffff; }
.act-back .act-desc { color: rgba(255, 255, 255, 0.8); }
</style>
