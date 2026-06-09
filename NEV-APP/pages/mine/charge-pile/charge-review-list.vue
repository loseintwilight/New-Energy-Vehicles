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
          <text class="header-title">充电结算</text>
          <text class="header-sub">共 {{ filteredSettlements.length }} 条记录</text>
        </view>
      </view>

      <!-- 统计概览条 -->
      <view class="stats-bar">
        <view class="stat-item">
          <text class="stat-val">{{ totalCount }}</text>
          <text class="stat-label">总订单</text>
        </view>
        <view class="stat-divider"></view>
        <view class="stat-item">
          <text class="stat-val stat-amount">¥{{ totalSettleAmount }}</text>
          <text class="stat-label">总金额</text>
        </view>
        <view class="stat-divider"></view>
        <view class="stat-item">
          <text class="stat-val stat-pending">{{ pendingCount }}</text>
          <text class="stat-label">待结算</text>
        </view>
      </view>

      <!-- 筛选标签栏 - 结算状态 -->
      <view class="filter-section">
        <scroll-view scroll-x class="filter-scroll-x" :show-scrollbar="false">
          <view class="filter-row">
            <view
              class="filter-chip"
              v-for="(item, idx) in statusTabs"
              :key="idx"
              :class="{ active: activeStatus === idx }"
              @tap="switchStatus(idx)"
            >
              <text>{{ item.label }}</text>
            </view>
          </view>
        </scroll-view>

        <!-- 筛选标签栏 - 提现状态 -->
        <scroll-view scroll-x class="filter-scroll-x" :show-scrollbar="false">
          <view class="filter-row">
            <view
              class="filter-chip"
              v-for="(item, idx) in withdrawTabs"
              :key="'withdraw-' + idx"
              :class="{ active: activeWithdraw === idx }"
              @tap="switchWithdraw(idx)"
            >
              <text>{{ item.label }}</text>
            </view>
          </view>
        </scroll-view>
      </view>

      <!-- 结算卡片列表 -->
      <view class="settlement-list-wrap">
        <!-- 空状态 -->
        <view class="empty-state" v-if="filteredSettlements.length === 0">
          <text class="empty-icon">💰</text>
          <text class="empty-title">暂无结算数据</text>
          <text class="empty-desc">充电订单完成后会在此显示结算信息</text>
        </view>

        <!-- 结算卡片 -->
        <view
          class="settlement-card"
          v-for="(item, idx) in filteredSettlements"
          :key="item.settlementId"
          :style="{ animationDelay: (idx * 0.08) + 's' }"
          hover-class="card-hover"
          :hover-stay-time="120"
          @tap="goDetail(item)"
        >
          <!-- 左侧彩色条 -->
          <view class="sc-bar" :class="'bar-status-' + getSettlementLevel(item.status)"></view>
          <!-- 卡片主体 -->
          <view class="sc-body">
            <!-- 顶部：结算单号 + 状态 + 时间 -->
            <view class="sc-top">
              <view class="sc-left">
                <view class="settle-no-row">
                  <text class="no-icon">#</text>
                  <text class="no-text">{{ shortSettleNo(item.settlementId) }}</text>
                </view>
                <text class="sc-date">{{ fmtDate(item.settleDate || item.createTime) }}</text>
              </view>
              <view class="sc-right">
                <view class="status-tag" :class="'stag-' + item.status">
                  <text>{{ getSettlementStatusLabel(item.status) }}</text>
                </view>
                <text class="sc-withdraw" v-if="item.withdrawStatus !== undefined && item.withdrawStatus !== null">
                  {{ getWithdrawStatusLabel(item.withdrawStatus) }}
                </text>
              </view>
            </view>

            <!-- 中间：数据概览 -->
            <view class="sc-summary">
              <view class="summary-item">
                <text class="summary-label">订单数</text>
                <text class="summary-val">{{ item.totalOrders || 0 }} 笔</text>
              </view>
              <view class="summary-item">
                <text class="summary-label">电量</text>
                <text class="summary-val">{{ item.totalEnergy || 0 }} kWh</text>
              </view>
              <view class="summary-item">
                <text class="summary-label">总额</text>
                <text class="summary-val highlight">¥{{ fmtAmount(item.totalAmount) }}</text>
              </view>
            </view>

            <!-- 底部：佣金 + 结算金额 + 提现信息 -->
            <view class="sc-bottom">
              <view class="bottom-info">
                <text class="info-text">平台佣金：¥{{ fmtAmount(item.platformCommission) }}</text>
                <text class="info-text info-settle">结算金额：<text class="settle-amount">¥{{ fmtAmount(item.settleAmount) }}</text></text>
              </view>
              <view class="withdraw-info" v-if="item.withdrawAmount && item.withdrawAmount > 0">
                <text class="withdraw-text">已提现 ¥{{ fmtAmount(item.withdrawAmount) }}</text>
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
import { getSettlementList } from '@/api/charger/settlement'

export default {
  data: function() {
    return {
      isReady: false,
      glowRows: [],
      activeStatus: 0,
      activeWithdraw: 0,

      /* 结算数据（从接口加载） */
      settlementList: [],

      /* 筛选项 - 结算状态 */
      statusTabs: [
        { label: '全部', value: '' },
        { label: '待结算', value: '0' },
        { label: '已结算', value: '1' },
        { label: '已取消', value: '2' }
      ],
      /* 筛选项 - 提现状态 */
      withdrawTabs: [
        { label: '全部提现', value: '' },
        { label: '待提现', value: '0' },
        { label: '提现中', value: '1' },
        { label: '已完成', value: '2' }
      ]
    }
  },

  computed: {
    /* 筛选后的列表 */
    filteredSettlements: function() {
      var list = this.settlementList
      var self = this

      /* 按结算状态筛选 */
      if (this.activeStatus > 0) {
        var statusVal = this.statusTabs[this.activeStatus].value
        list = list.filter(function(s) { return String(s.status) === statusVal })
      }

      /* 按提现状态筛选 */
      if (this.activeWithdraw > 0) {
        var withdrawVal = this.withdrawTabs[this.activeWithdraw].value
        list = list.filter(function(s) { return String(s.withdrawStatus) === withdrawVal })
      }

      return list
    },

    /* 统计 */
    totalCount: function() {
      var count = 0
      for (var i = 0; i < this.settlementList.length; i++) {
        count += (this.settlementList[i].totalOrders || 0)
      }
      return count
    },
    totalSettleAmount: function() {
      if (this.settlementList.length === 0) return '0.00'
      var sum = 0
      for (var i = 0; i < this.settlementList.length; i++) {
        sum += (this.settlementList[i].totalAmount || 0)
      }
      return sum.toFixed(2)
    },
    pendingCount: function() {
      var c = 0
      for (var i = 0; i < this.settlementList.length; i++) {
        if (String(this.settlementList[i].status) === '0') c++
      }
      return c
    }
  },

  created: function() {
    this.buildGlowRows()
    this.loadSettlements()
    var self = this
    setTimeout(function() { self.isReady = true }, 200)
  },

  methods: {
    /* ---------- 数据加载 ---------- */
    loadSettlements: function() {
      var self = this
      getSettlementList({ pageSize: 100 }).then(function(res) {
        if (res.code === 200) {
          self.settlementList = res.rows || []
        } else {
          uni.showToast({ title: res.msg || '加载失败', icon: 'none' })
        }
      }).catch(function() {
        uni.showToast({ title: '网络异常', icon: 'none' })
      })
    },

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

    switchStatus: function(idx) {
      this.activeStatus = idx
    },

    switchWithdraw: function(idx) {
      this.activeWithdraw = idx
    },

    goDetail: function(item) {
      uni.navigateTo({
        url: '/pages/mine/charge-pile/charge-review-detail?settlementId=' + item.settlementId
      })
    },

    getSettlementLevel: function(status) {
      status = String(status)
      if (status === '1') return 'done'
      if (status === '0') return 'pending'
      return 'cancel'
    },

    getSettlementStatusLabel: function(status) {
      var map = { '0': '待结算', '1': '已结算', '2': '已取消' }
      return map[String(status)] || '未知'
    },

    getWithdrawStatusLabel: function(status) {
      var map = { '0': '待提现', '1': '提现中', '2': '已完成' }
      return map[String(status)] || ''
    },

    shortSettleNo: function(id) {
      if (!id) return ''
      var str = String(id)
      if (str.length > 12) {
        return str.substring(0, 9) + '...'
      }
      return str
    },

    fmtDate: function(dateStr) {
      if (!dateStr) return '-'
      var d = new Date(dateStr.replace(/-/g, '/'))
      if (isNaN(d.getTime())) return dateStr
      var y = d.getFullYear()
      var m = d.getMonth() + 1
      var day = d.getDate()
      var mStr = m < 10 ? '0' + m : '' + m
      var dStr = day < 10 ? '0' + day : '' + day
      return y + '-' + mStr + '-' + dStr
    },

    fmtAmount: function(amount) {
      if (amount === null || amount === undefined) return '0.00'
      return Number(amount).toFixed(2)
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
.stat-amount { color: #f59e0b !important; }
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

/* ========== 结算列表 ========== */
.settlement-list-wrap { padding: 0 24rpx; }

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

/* 结算卡片 */
.settlement-card {
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
.sc-bar {
  width: 5rpx;
  flex-shrink: 0;
  transition: all 0.3s ease;
}
.bar-status-done { background: linear-gradient(180deg, #22c55e, #16a34a); box-shadow: 0 0 12rpx rgba(34,197,94,0.25); }
.bar-status-pending { background: linear-gradient(180deg, #f59e0b, #fb923c); box-shadow: 0 0 12rpx rgba(245,158,11,0.25); }
.bar-status-cancel { background: linear-gradient(180deg, #9ca3af, #d1d5db); box-shadow: 0 0 12rpx rgba(156,163,175,0.25); }
.card-hover .bar-status-done { width: 7rpx; box-shadow: 0 0 24rpx rgba(34,197,94,0.45), 0 0 48rpx rgba(34,197,94,0.15); }
.card-hover .bar-status-pending { width: 7rpx; box-shadow: 0 0 24rpx rgba(245,158,11,0.45), 0 0 48rpx rgba(245,158,11,0.15); }
.card-hover .bar-status-cancel { width: 7rpx; box-shadow: 0 0 24rpx rgba(156,163,175,0.45), 0 0 48rpx rgba(156,163,175,0.15); }

/* 卡片主体 */
.sc-body {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: 20rpx 18rpx 18rpx;
  gap: 10rpx;
}

/* 顶部 */
.sc-top {
  display: flex;
  flex-direction: row;
  align-items: flex-start;
  justify-content: space-between;
}
.sc-left { display: flex; flex-direction: column; gap: 6rpx; flex: 1; min-width: 0; }
.settle-no-row { display: flex; align-items: center; gap: 6rpx; }
.no-icon { font-size: 22rpx; color: #f97316; font-weight: 900; }
.no-text { font-size: 24rpx; font-weight: 800; color: #292524; font-family: monospace; letter-spacing: 0.5rpx; }
.sc-date { font-size: 22rpx; color: #9ca3af; }

.sc-right { display: flex; flex-direction: column; align-items: flex-end; gap: 6rpx; flex-shrink: 0; margin-left: 12rpx; }
.status-tag {
  padding: 4rpx 16rpx;
  border-radius: 8rpx;
  font-size: 20rpx;
  font-weight: 700;
}
.stag-0 { background: linear-gradient(135deg, rgba(217,119,6,0.12), rgba(245,158,11,0.06)); color: #d97706; border: 1rpx solid rgba(217,119,6,0.2); }
.stag-1 { background: linear-gradient(135deg, rgba(34,197,94,0.12), rgba(74,222,128,0.06)); color: #16a34a; border: 1rpx solid rgba(34,197,94,0.2); }
.stag-2 { background: linear-gradient(135deg, rgba(107,114,128,0.1), rgba(156,163,175,0.05)); color: #6b7280; border: 1rpx solid rgba(107,114,128,0.15); }
.sc-withdraw { font-size: 20rpx; color: #78716c; font-weight: 500; }

/* 数据概览 */
.sc-summary {
  display: flex;
  flex-direction: row;
  gap: 20rpx;
  padding: 10rpx 8rpx;
  background: rgba(245, 158, 11, 0.04);
  border-radius: 12rpx;
  border: 1rpx solid rgba(245, 158, 11, 0.08);
}
.summary-item { flex: 1; display: flex; flex-direction: column; align-items: center; gap: 4rpx; }
.summary-label { font-size: 20rpx; color: #9ca3af; font-weight: 500; }
.summary-val { font-size: 24rpx; color: #374151; font-weight: 700; }
.summary-val.highlight { color: #f59e0b; }

/* 底部 */
.sc-bottom {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  padding-top: 8rpx;
  border-top: 1rpx solid rgba(0, 0, 0, 0.04);
}
.bottom-info { display: flex; flex-direction: column; gap: 4rpx; flex: 1; min-width: 0; }
.info-text { font-size: 21rpx; color: #78716c; font-weight: 500; }
.info-settle { color: #d97706; font-weight: 600; }
.settle-amount { font-weight: 800; color: #d97706; }
.withdraw-info { flex-shrink: 0; margin-right: 12rpx; }
.withdraw-text { font-size: 20rpx; color: #16a34a; font-weight: 600; background: rgba(34,197,94,0.08); padding: 4rpx 12rpx; border-radius: 8rpx; }
.bottom-arrow { padding: 6rpx 4rpx; }
.arrow-icon { font-size: 32rpx; color: #d1d5db; font-weight: 300; }
</style>
