<template>
  <view class="page" :class="{ 'page-ready': isReady }">
    <!-- 背景光晕矩阵（琥珀橙暖色系） -->
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
      <!-- 琥珀渐变顶栏 -->
      <view class="header">
        <view class="header-bg"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="header-info">
          <text class="header-title">金融方案管理</text>
          <text class="header-sub">{{ activeCount }} 个在用中</text>
        </view>
        <view class="header-right" @tap="goAdd">
          <view class="add-btn-sm">
            <text class="add-icon-sm">+</text>
            <text class="add-text-sm">新增</text>
          </view>
        </view>
      </view>

      <!-- 统计概览 -->
      <view class="stats-row">
        <view class="stat-card stat-total">
          <text class="stat-label">方案总数</text>
          <text class="stat-value">{{ mockPlans.length }}</text>
          <text class="stat-unit">个</text>
        </view>
        <view class="stat-card stat-active">
          <text class="stat-label">在用方案</text>
          <text class="stat-value">{{ activeCount }}</text>
          <text class="stat-unit">个</text>
        </view>
        <view class="stat-card stat-rate">
          <text class="stat-label">平均年利率</text>
          <text class="stat-value">{{ avgYearRate }}</text>
          <text class="stat-unit"></text>
        </view>
      </view>

      <!-- 金融方案卡片列表 -->
      <view class="plan-list" v-if="mockPlans.length > 0">
        <view
          class="plan-card"
          v-for="(item, idx) in mockPlans"
          :key="item.planId"
          :class="[item.isRecommended ? 'card-recommended' : 'card-normal']"
          :style="{ 'animation-delay': (idx * 0.08) + 's' }"
          hover-class="card-hover"
          @tap="goEdit(item)"
        >
          <!-- 左侧彩色竖条 -->
          <view class="left-bar"></view>

          <!-- 推荐角标 -->
          <view class="recommend-badge" v-if="item.isRecommended">
            <text>★ 推荐</text>
          </view>

          <!-- 卡片主体 -->
          <view class="card-body">
            <!-- 卡片头部：名称 + 状态切换 -->
            <view class="card-header">
              <view class="header-left">
                <text class="plan-emoji">🏦</text>
                <text class="plan-name">{{ item.planName }}</text>
                <view v-if="item.status === '0'" class="stop-tag">
                  <text>已停用</text>
                </view>
              </view>
              <switch
                :checked="item.status === '1'"
                color="#f59e0b"
                style="transform: scale(0.8);"
                @tap.stop
                @change="toggleStatus(item, $event)"
              />
            </view>

            <!-- 核心数据区域 -->
            <view class="data-area">
              <!-- 首付 + 期数 -->
              <view class="info-grid">
                <view class="grid-item">
                  <text class="grid-label">首付比例</text>
                  <text class="grid-value">{{ (item.downRatio * 100).toFixed(0) }}%</text>
                </view>
                <view class="grid-item">
                  <text class="grid-label">贷款期限</text>
                  <text class="grid-value">{{ item.months }}期</text>
                </view>
                <view class="grid-item">
                  <text class="grid-label">适用条件</text>
                  <text class="grid-value cond-text">{{ item.condition }}</text>
                </view>
              </view>

              <!-- 年利率大字展示 -->
              <view class="rate-block">
                <text class="rate-label">年利率</text>
                <view class="rate-value-wrap">
                  <text class="rate-symbol">%</text>
                  <text class="rate-number">{{ fmtRate(item.yearRate) }}</text>
                </view>
                <text class="rate-zero-tag" v-if="item.yearRate === 0">🎉 0息免息</text>
              </view>

              <!-- 月供示例 -->
              <view class="monthly-example">
                <view class="example-left">
                  <text class="example-icon">📊</text>
                  <text class="example-label">月供示例（20万车价）</text>
                </view>
                <text class="example-value">&yen;{{ calcMonthly(item) }}</text>
              </view>
            </view>

            <!-- 底部状态条 -->
            <view class="status-bar" :class="item.status === '1' ? 'bar-on' : 'bar-off'">
              <view class="status-dot" v-if="item.status === '1'"></view>
              <text class="status-txt">{{ item.status === '1' ? '启用中 ✓' : '已停用 ✗' }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 空状态 -->
      <view class="empty-state" v-if="mockPlans.length === 0">
        <text class="empty-icon">💰</text>
        <text class="empty-text">暂无金融方案</text>
        <view class="empty-btn" @tap="goAdd">
          <text>立即添加方案</text>
        </view>
      </view>

      <view style="height: 140rpx;"></view>
    </scroll-view>

    <!-- 浮动新增按钮(FAB) -->
    <view class="fab-add" hover-class="fab-hover" @tap="goAdd">
      <text class="fab-icon">+</text>
    </view>
  </view>
</template>

<script>
export default {
  data: function() {
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

    return {
      isReady: false,
      glowRows: rows,
      examplePrice: 200000,
      mockPlans: [
        { planId: 1, planName: '12期极速还款', downRatio: 0.40, months: 12, yearRate: 0, monthlyRate: 0, isRecommended: true, status: '1', condition: '信用分≥650' },
        { planId: 2, planName: '24期0息方案', downRatio: 0.30, months: 24, yearRate: 0, monthlyRate: 0, isRecommended: true, status: '1', condition: '信用分≥680' },
        { planId: 3, planName: '36期低息方案', downRatio: 0.25, months: 36, yearRate: 0.035, monthlyRate: 0.0029, isRecommended: false, status: '1', condition: '信用分≥700' },
        { planId: 4, planName: '48期超长分期', downRatio: 0.20, months: 48, yearRate: 0.049, monthlyRate: 0.0041, isRecommended: false, status: '1', condition: '信用分≥720' },
        { planId: 5, planName: '60期轻松购', downRatio: 0.15, months: 60, yearRate: 0.059, monthlyRate: 0.0049, isRecommended: false, status: '0', condition: '信用分≥750' }
      ]
    }
  },
  computed: {
    activeCount: function() {
      var self = this
      return self.mockPlans.filter(function(p) { return p.status === '1' }).length
    },
    avgYearRate: function() {
      var self = this
      var active = self.mockPlans.filter(function(p) { return p.status === '1' })
      if (active.length === 0) return '0.00'
      var sum = 0
      for (var i = 0; i < active.length; i++) {
        sum += active[i].yearRate
      }
      return (sum / active.length * 100).toFixed(2) + '%'
    }
  },
  created: function() {
    var that = this
    setTimeout(function() { that.isReady = true }, 200)
  },
  methods: {
    goBack: function() {
      uni.navigateBack({ delta: 1 })
    },
    goAdd: function() {
      uni.navigateTo({ url: '/pages/mine/vehicle/finance-edit' })
    },
    goEdit: function(item) {
      uni.navigateTo({ url: '/pages/mine/vehicle/finance-edit?planId=' + item.planId })
    },
    toggleStatus: function(item, e) {
      item.status = e.detail.value ? '1' : '0'
      uni.showToast({
        title: item.status === '1' ? '已启用' : '已停用',
        icon: 'none',
        duration: 1200
      })
    },
    fmtRate: function(val) {
      if (val === undefined || val === null) return '0.00'
      return (val * 100).toFixed(1)
    },
    calcMonthly: function(item) {
      var price = this.examplePrice
      var loanAmount = price * (1 - item.downRatio)
      var mr = item.monthlyRate
      var n = item.months
      // 0息时等额本金
      if (mr === 0 || n === 0) {
        return (loanAmount / n).toFixed(0)
      }
      // 等额本息公式: P * [r(1+r)^n] / [(1+r)^n - 1]
      var factor = Math.pow(1 + mr, n)
      var monthly = loanAmount * (mr * factor) / (factor - 1)
      return monthly.toFixed(0)
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
.page-ready .plan-card {
  animation: fadeSlideUp 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) backwards;
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

/* ========== 琥珀渐变顶栏 ========== */
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
.header-right {
  z-index: 2;
}
.add-btn-sm {
  display: flex;
  align-items: center;
  background: rgba(255, 255, 255, 0.28);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  padding: 14rpx 26rpx;
  border-radius: 32rpx;
  box-shadow: 0 4rpx 14rpx rgba(0, 0, 0, 0.08);
}
.add-icon-sm {
  font-size: 30rpx;
  color: #ffffff;
  font-weight: 700;
  margin-right: 6rpx;
}
.add-text-sm {
  font-size: 24rpx;
  color: #ffffff;
  font-weight: 600;
}

/* ========== 统计概览 ========== */
.stats-row {
  display: flex;
  padding: 16rpx 24rpx;
  gap: 14rpx;
  position: relative;
  z-index: 2;
}
.stat-card {
  flex: 1;
  background: rgba(255, 255, 255, 0.82);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  border-radius: 18rpx;
  padding: 20rpx 12rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  box-shadow: 0 4rpx 16rpx rgba(245, 158, 11, 0.08);
  border: 1rpx solid rgba(245, 158, 11, 0.1);
}
.stat-label {
  font-size: 21rpx;
  color: #a16207;
  font-weight: 500;
  margin-bottom: 8rpx;
}
.stat-value {
  font-size: 36rpx;
  font-weight: 900;
  color: #f59e0b;
  line-height: 1.2;
}
.stat-unit {
  font-size: 19rpx;
  color: #d97706;
  font-weight: 600;
  margin-top: 2rpx;
}
.stat-active .stat-value { color: #ea580c; }
.stat-rate .stat-value { color: #dc2626; font-size: 28rpx; }

/* ========== 金融方案卡片列表 ========== */
.plan-list {
  padding: 12rpx 24rpx;
}
.plan-card {
  background: rgba(255, 255, 255, 0.82);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border-radius: 24rpx;
  margin-bottom: 20rpx;
  overflow: hidden;
  position: relative;
  box-shadow: 0 6rpx 28rpx rgba(0, 0, 0, 0.05), inset 0 1rpx 0 rgba(255, 255, 255, 0.9);
  border: 1rpx solid rgba(255, 255, 255, 0.8);
  transition: all 0.3s ease;
}
.card-hover {
  transform: scale(0.985) translateY(-2rpx);
  box-shadow: 0 12rpx 36rpx rgba(0, 0, 0, 0.1);
}

/* 左侧彩色竖条 */
.left-bar {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 6rpx;
  border-radius: 24rpx 0 0 24rpx;
  transition: all 0.3s ease;
}
.card-recommended .left-bar {
  background: linear-gradient(180deg, #fbbf24, #f59e0b, #d97706);
  box-shadow: 2rpx 0 16rpx rgba(245, 158, 11, 0.45);
}
.card-normal .left-bar {
  background: linear-gradient(180deg, #f59e0b, #fb923c, #fbbf24);
  box-shadow: 2rpx 0 16rpx rgba(245, 158, 11, 0.35);
}
.card-hover .left-bar { width: 8rpx; }

/* 推荐角标 */
.recommend-badge {
  position: absolute;
  top: 18rpx;
  right: -4rpx;
  background: linear-gradient(135deg, #fbbf24, #f59e0b);
  padding: 6rpx 22rpx 6rpx 14rpx;
  border-radius: 0 14rpx 14rpx 0;
  z-index: 3;
  box-shadow: 0 4rpx 12rpx rgba(245, 158, 11, 0.35);
}
.recommend-badge text {
  font-size: 19rpx;
  color: #ffffff;
  font-weight: 800;
  letter-spacing: 1rpx;
}

/* 卡片主体 */
.card-body {
  padding: 24rpx 22rpx 20rpx 26rpx;
  position: relative;
  z-index: 1;
}

/* ========== 卡片头部 ========== */
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16rpx;
}
.header-left {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  flex: 1;
  min-width: 0;
}
.plan-emoji {
  font-size: 32rpx;
  margin-right: 10rpx;
}
.plan-name {
  font-size: 30rpx;
  font-weight: 800;
  color: #1c1917;
  letter-spacing: 0.5rpx;
  margin-right: 12rpx;
}
.stop-tag {
  display: inline-block;
  padding: 5rpx 16rpx;
  border-radius: 14rpx;
  background: linear-gradient(135deg, rgba(156, 163, 175, 0.12), rgba(209, 213, 219, 0.06));
  border: 1rpx solid rgba(156, 163, 175, 0.18);
}
.stop-tag text {
  font-size: 20rpx;
  color: #9ca3af;
  font-weight: 700;
}

/* ========== 核心数据区域 ========== */
.data-area {
  background: linear-gradient(135deg, rgba(255, 251, 235, 0.95), rgba(255, 255, 255, 1));
  border-radius: 16rpx;
  padding: 18rpx 20rpx;
  margin-bottom: 14rpx;
  border: 1rpx solid rgba(245, 158, 11, 0.08);
}

/* 信息网格 */
.info-grid {
  display: flex;
  gap: 10rpx;
  margin-bottom: 16rpx;
}
.grid-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 12rpx 6rpx;
  background: rgba(255, 255, 255, 0.8);
  border-radius: 12rpx;
  border: 1rpx solid rgba(0, 0, 0, 0.03);
}
.grid-label {
  font-size: 20rpx;
  color: #a8a29e;
  font-weight: 500;
  margin-bottom: 6rpx;
}
.grid-value {
  font-size: 26rpx;
  font-weight: 800;
  color: #451a03;
}
.cond-text {
  font-size: 20rpx !important;
  font-weight: 600 !important;
}

/* 年利率大字展示 */
.rate-block {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16rpx 18rpx;
  margin-bottom: 14rpx;
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.08), rgba(251, 146, 60, 0.04));
  border-radius: 14rpx;
  border: 1rpx solid rgba(245, 158, 11, 0.12);
}
.rate-label {
  font-size: 23rpx;
  color: #92400e;
  font-weight: 600;
}
.rate-value-wrap {
  display: flex;
  align-items: baseline;
}
.rate-symbol {
  font-size: 24rpx;
  color: #f59e0b;
  font-weight: 700;
  margin-right: 4rpx;
}
.rate-number {
  font-size: 44rpx;
  font-weight: 900;
  color: #f59e0b;
  letter-spacing: -0.5rpx;
  text-shadow: 0 2rpx 10rpx rgba(245, 158, 11, 0.2);
}
.rate-zero-tag {
  font-size: 20rpx;
  color: #ea580c;
  font-weight: 700;
  background: rgba(234, 88, 12, 0.08);
  padding: 4rpx 12rpx;
  border-radius: 10rpx;
}

/* 月供示例 */
.monthly-example {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 14rpx 16rpx;
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.06), rgba(251, 191, 36, 0.03));
  border-radius: 12rpx;
  border: 1rpx solid rgba(245, 158, 11, 0.1);
}
.example-left {
  display: flex;
  align-items: center;
}
.example-icon {
  font-size: 24rpx;
  margin-right: 8rpx;
}
.example-label {
  font-size: 22rpx;
  color: #78716c;
  font-weight: 500;
}
.example-value {
  font-size: 30rpx;
  font-weight: 900;
  color: #d97706;
  letter-spacing: 0.5rpx;
}

/* ========== 底部状态条 ========== */
.status-bar {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 10rpx 0 2rpx;
  border-radius: 12rpx;
  gap: 8rpx;
}
.bar-on {
  background: linear-gradient(135deg, rgba(217, 119, 6, 0.08), rgba(245, 158, 11, 0.04));
}
.bar-off {
  background: linear-gradient(135deg, rgba(156, 163, 175, 0.08), rgba(209, 213, 219, 0.04));
}
.status-dot {
  width: 12rpx;
  height: 12rpx;
  border-radius: 50%;
  background: #d97706;
  animation: dotPulse 2s ease-in-out infinite;
  box-shadow: 0 0 8rpx #d97706;
}
@keyframes dotPulse {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.5; transform: scale(0.8); }
}
.status-txt {
  font-size: 21rpx;
  font-weight: 600;
}
.bar-on .status-txt { color: #d97706; }
.bar-off .status-txt { color: #9ca3af; }

/* ========== 空状态 ========== */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 120rpx 40rpx;
}
.empty-icon {
  font-size: 96rpx;
  opacity: 0.35;
  animation: floatBounce 2.5s ease-in-out infinite;
}
@keyframes floatBounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-16rpx); }
}
.empty-text {
  font-size: 30rpx;
  color: #a8a29e;
  font-weight: 500;
  margin-top: 20rpx;
}
.empty-btn {
  margin-top: 32rpx;
  padding: 22rpx 56rpx;
  background: linear-gradient(135deg, #f59e0b, #f97316);
  border-radius: 44rpx;
  font-size: 28rpx;
  color: #fff;
  font-weight: 700;
  letter-spacing: 2rpx;
  box-shadow: 0 8rpx 32rpx rgba(245, 158, 11, 0.35);
  transition: all 0.25s ease;
}
.empty-btn:active {
  transform: scale(0.94);
  box-shadow: 0 10rpx 40rpx rgba(245, 158, 11, 0.45);
}

/* ========== 浮动新增按钮(FAB) ========== */
.fab-add {
  position: fixed;
  right: 32rpx;
  bottom: 60rpx;
  width: 108rpx;
  height: 108rpx;
  border-radius: 54rpx;
  background: linear-gradient(135deg, #f59e0b, #f97316);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 99;
  box-shadow: 0 8rpx 32rpx rgba(245, 158, 11, 0.4), 0 2rpx 8rpx rgba(0, 0, 0, 0.08);
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.fab-hover {
  transform: scale(1.1) rotate(90deg);
  box-shadow: 0 12rpx 44rpx rgba(245, 158, 11, 0.5), 0 4rpx 12rpx rgba(0, 0, 0, 0.1);
}
.fab-icon {
  font-size: 52rpx;
  color: #ffffff;
  font-weight: 300;
  line-height: 1;
}
</style>
