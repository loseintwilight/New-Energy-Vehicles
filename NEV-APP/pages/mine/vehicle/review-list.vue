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
          <text class="header-title">评价管理</text>
          <text class="header-sub">综合评分 {{ avgScore }} 分</text>
        </view>
        <view class="header-right">
          <view class="sort-btn" @tap="toggleSort">
            <text class="sort-icon">{{ sortAsc ? '↑' : '↓' }}</text>
          </view>
        </view>
      </view>

      <view class="score-overview">
        <view class="score-main">
          <text class="score-big">{{ avgScore }}</text>
          <text class="score-outof">/ 5.0</text>
        </view>
        <view class="score-bars">
          <view class="bar-row" v-for="(item, idx) in scoreDistribution" :key="idx">
            <text class="bar-label">{{ item.stars }}星</text>
            <view class="bar-track">
              <view class="bar-fill" :style="{ width: item.percent + '%' }" :class="'bar-' + idx"></view>
            </view>
            <text class="bar-count">{{ item.count }}</text>
          </view>
        </view>
      </view>

      <view class="filter-tabs">
        <scroll-view scroll-x class="tab-scroll" :show-scrollbar="false">
          <view class="tab-item" v-for="(tab, idx) in tabs" :key="idx" :class="{ active: activeTab === idx }" @tap="switchTab(idx)">
            <text>{{ tab }}</text>
          </view>
        </scroll-view>
      </view>

      <view class="review-list">
        <view class="review-card" v-for="(item, idx) in filteredReviews" :key="idx" hover-class="card-hover" @tap="goDetail(item.id)">
          <view class="review-top">
            <view class="review-avatar">
              <text class="avatar-text">{{ item.avatar }}</text>
            </view>
            <view class="review-user">
              <text class="user-name">{{ item.user }}</text>
              <view class="user-stars">
                <text class="star" v-for="s in 5" :key="s" :class="{ active: s <= item.rating }">★</text>
              </view>
            </view>
            <view class="review-time">
              <text class="time-text">{{ item.time }}</text>
              <text class="vehicle-tag">{{ item.vehicle }}</text>
            </view>
          </view>
          <view class="review-content">
            <text class="review-text">{{ item.content }}</text>
          </view>
          <view class="review-footer">
            <view class="review-tags" v-if="item.tags">
              <text class="r-tag" v-for="(tag, ti) in item.tags" :key="ti">{{ tag }}</text>
            </view>
            <view class="review-reply" v-if="item.reply">
              <text class="reply-label">商家回复：</text>
              <text class="reply-text">{{ item.reply }}</text>
            </view>
          </view>
        </view>

        <view v-if="filteredReviews.length === 0" class="empty-wrap">
          <view class="empty-circle">
            <text class="empty-icon">⭐</text>
          </view>
          <text class="empty-text">暂无评价</text>
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
      activeTab: 0,
      sortAsc: false,
      tabs: ['全部', '好评(4-5)', '中评(3)', '差评(1-2)'],
      avgScore: '4.6',
      scoreDistribution: [
        { stars: 5, count: 128, percent: 58 },
        { stars: 4, count: 56, percent: 25 },
        { stars: 3, count: 22, percent: 10 },
        { stars: 2, count: 8, percent: 4 },
        { stars: 1, count: 6, percent: 3 }
      ],
      reviews: [
        { id: 1, user: '张先生', avatar: '张', rating: 5, vehicle: '比亚迪 海豹', time: '2025-06-01', content: '非常满意的一次购车体验！销售顾问专业耐心，交车流程顺畅，车辆品质超出预期。充电方便，续航表现优秀。', tags: ['服务好', '续航强', '充电快'], reply: '感谢您的认可！我们将继续提供优质服务。' },
        { id: 2, user: '李女士', avatar: '李', rating: 5, vehicle: '特斯拉 Model 3', time: '2025-05-30', content: 'Model 3焕新版真不错，内饰质感提升明显，驾驶体验一流。店里的服务也很到位，从试驾到提车都很顺利。', tags: ['内饰好', '驾驶爽'], reply: '' },
        { id: 3, user: '王先生', avatar: '王', rating: 4, vehicle: '蔚来 ET5', time: '2025-05-28', content: '整体满意，车辆外观时尚，换电服务很方便。就是提车等了一周，希望交车效率能再提升一些。', tags: ['外观好', '换电方便'], reply: '感谢您的建议，我们正在优化交车流程。' },
        { id: 4, user: '赵女士', avatar: '赵', rating: 3, vehicle: '小鹏 G6', time: '2025-05-26', content: '车还不错，智能驾驶辅助功能很好用。但充电桩安装等了一周多，售后响应速度有待提高。', tags: ['智驾好', '售后慢'], reply: '非常抱歉给您带来不便，已加急处理您的安装需求。' },
        { id: 5, user: '陈先生', avatar: '陈', rating: 5, vehicle: '理想 L7', time: '2025-05-25', content: '理想L7空间真大，全家出行太方便了！增程模式没有续航焦虑，日常通勤基本用电，很省钱。', tags: ['空间大', '续航好', '省油'], reply: '' },
        { id: 6, user: '刘女士', avatar: '刘', rating: 2, vehicle: '比亚迪 汉EV', time: '2025-05-22', content: '提车后发现中控屏有轻微漏光，联系售后处理态度还可以，但等了半个月才换好。', tags: ['品控一般', '售后慢'], reply: '非常抱歉，我们已优化配件供应流程，后续会更快响应。' },
        { id: 7, user: '周先生', avatar: '周', rating: 5, vehicle: '极氪 001', time: '2025-05-20', content: '极氪001的操控太棒了，底盘调教很有质感。销售顾问讲解很专业，帮我选到了最合适的配置。', tags: ['操控好', '专业'], reply: '' },
        { id: 8, user: '吴女士', avatar: '吴', rating: 4, vehicle: '问界 M7', time: '2025-05-18', content: '问界M7的鸿蒙座舱体验很好，和手机无缝连接。空间够大，适合二胎家庭。就是价格如果能再优惠些就完美了。', tags: ['智能好', '空间大'], reply: '感谢您的支持，我们会持续推出优惠活动！' }
      ]
    }
  },
  computed: {
    filteredReviews() {
      var list = this.reviews.slice()
      if (this.activeTab === 1) list = list.filter(function(r) { return r.rating >= 4 })
      else if (this.activeTab === 2) list = list.filter(function(r) { return r.rating === 3 })
      else if (this.activeTab === 3) list = list.filter(function(r) { return r.rating <= 2 })
      if (this.sortAsc) list.sort(function(a, b) { return a.rating - b.rating })
      else list.sort(function(a, b) { return b.rating - a.rating })
      return list
    }
  },
  created() {
    this.buildGlowRows()
    var self = this
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
    switchTab(idx) { this.activeTab = idx },
    toggleSort() { this.sortAsc = !this.sortAsc },
    goDetail(id) { uni.navigateTo({ url: '/pages/mine/vehicle/review-detail?id=' + id }) }
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
.sort-btn { width: 60rpx; height: 60rpx; border-radius: 30rpx; background: linear-gradient(135deg, #f59e0b, #d97706); display: flex; align-items: center; justify-content: center; box-shadow: 0 4rpx 16rpx rgba(245,158,11,0.35); }
.sort-icon { font-size: 28rpx; color: #fff; font-weight: 700; }

.score-overview { display: flex; padding: 0 28rpx 20rpx; }
.score-main { width: 160rpx; text-align: center; background: rgba(255,255,255,0.8); border-radius: 20rpx; padding: 24rpx 16rpx; margin-right: 16rpx; box-shadow: 0 2rpx 16rpx rgba(0,0,0,0.04); }
.score-big { font-size: 56rpx; font-weight: 700; color: #d97706; display: block; }
.score-outof { font-size: 24rpx; color: #9ca3af; display: block; }
.score-bars { flex: 1; background: rgba(255,255,255,0.8); border-radius: 20rpx; padding: 20rpx; box-shadow: 0 2rpx 16rpx rgba(0,0,0,0.04); }
.bar-row { display: flex; align-items: center; margin-bottom: 8rpx; }
.bar-row:last-child { margin-bottom: 0; }
.bar-label { font-size: 22rpx; color: #9ca3af; width: 48rpx; }
.bar-track { flex: 1; height: 10rpx; background: rgba(0,0,0,0.05); border-radius: 5rpx; margin: 0 12rpx; overflow: hidden; }
.bar-fill { height: 100%; border-radius: 5rpx; }
.bar-0 { background: linear-gradient(90deg, #f59e0b, #fbbf24); }
.bar-1 { background: linear-gradient(90deg, #fbbf24, #fcd34d); }
.bar-2 { background: linear-gradient(90deg, #fcd34d, #fde68a); }
.bar-3 { background: linear-gradient(90deg, #fde68a, #fef3c7); }
.bar-4 { background: linear-gradient(90deg, #fef3c7, #fffbeb); }
.bar-count { font-size: 22rpx; color: #9ca3af; width: 48rpx; text-align: right; }

.filter-tabs { padding: 0 28rpx 16rpx; }
.tab-scroll { white-space: nowrap; }
.tab-item { display: inline-block; padding: 12rpx 24rpx; margin-right: 12rpx; border-radius: 30rpx; font-size: 26rpx; color: #6b7280; background: rgba(255,255,255,0.7); transition: all 0.3s; }
.tab-item.active { background: linear-gradient(135deg, #f59e0b, #d97706); color: #fff; box-shadow: 0 4rpx 12rpx rgba(245,158,11,0.3); }

.review-list { padding: 0 28rpx; }
.review-card { background: rgba(255,255,255,0.8); backdrop-filter: blur(10px); border-radius: 20rpx; padding: 24rpx; margin-bottom: 16rpx; box-shadow: 0 2rpx 16rpx rgba(0,0,0,0.04); }
.card-hover { transform: scale(0.98); }
.review-top { display: flex; align-items: center; margin-bottom: 16rpx; }
.review-avatar { width: 56rpx; height: 56rpx; border-radius: 28rpx; background: linear-gradient(135deg, #f59e0b, #fbbf24); display: flex; align-items: center; justify-content: center; margin-right: 16rpx; }
.avatar-text { font-size: 24rpx; color: #fff; font-weight: 600; }
.review-user { flex: 1; }
.user-name { font-size: 28rpx; font-weight: 500; color: #1f2937; display: block; }
.user-stars { margin-top: 4rpx; }
.star { font-size: 22rpx; color: #e5e7eb; margin-right: 2rpx; }
.star.active { color: #f59e0b; }
.review-time { text-align: right; }
.time-text { font-size: 22rpx; color: #9ca3af; display: block; }
.vehicle-tag { font-size: 20rpx; color: #d97706; background: rgba(245,158,11,0.1); padding: 2rpx 10rpx; border-radius: 8rpx; margin-top: 4rpx; display: inline-block; }
.review-content { margin-bottom: 12rpx; }
.review-text { font-size: 26rpx; color: #374151; line-height: 1.6; }
.review-footer { }
.review-tags { display: flex; flex-wrap: wrap; gap: 8rpx; margin-bottom: 8rpx; }
.r-tag { font-size: 20rpx; color: #d97706; background: rgba(245,158,11,0.08); padding: 4rpx 12rpx; border-radius: 10rpx; }
.review-reply { background: rgba(245,158,11,0.05); border-radius: 12rpx; padding: 12rpx 16rpx; }
.reply-label { font-size: 22rpx; color: #d97706; font-weight: 500; }
.reply-text { font-size: 24rpx; color: #6b7280; }

.empty-wrap { display: flex; flex-direction: column; align-items: center; padding: 80rpx 0; }
.empty-circle { width: 120rpx; height: 120rpx; border-radius: 60rpx; background: rgba(255,255,255,0.6); display: flex; align-items: center; justify-content: center; margin-bottom: 20rpx; }
.empty-icon { font-size: 48rpx; }
.empty-text { font-size: 28rpx; color: #9ca3af; }

.bottom-safe { height: 40rpx; }
</style>