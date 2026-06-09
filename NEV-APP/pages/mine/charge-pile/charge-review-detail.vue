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
        <view class="header-bg" :class="'hb-' + settlement.status"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="header-info">
          <text class="header-title">结算详情</text>
          <text class="header-sub">结算单号 #{{ settlement.settlementId }}</text>
        </view>
      </view>

      <!-- 核心金额卡片 -->
      <view class="amount-card">
        <view class="amount-row">
          <text class="amount-label">总金额</text>
          <text class="amount-big">¥{{ fmtAmount(settlement.totalAmount) }}</text>
        </view>
        <view class="amount-sub">
          <view class="sub-item">
            <text class="sub-lbl">平台佣金</text>
            <text class="sub-val">-¥{{ fmtAmount(settlement.platformCommission) }}</text>
          </view>
          <view class="sub-divider"></view>
          <view class="sub-item sub-highlight">
            <text class="sub-lbl">实际到账</text>
            <text class="sub-val big">¥{{ fmtAmount(settlement.settleAmount) }}</text>
          </view>
        </view>
      </view>

      <!-- 结算信息 -->
      <view class="info-section">
        <view class="bar-line bar-line-orange2"></view>
        <text class="section-title">结算信息</text>
        <view class="info-grid">
          <view class="info-cell">
            <text class="info-lbl">结算状态</text>
            <text class="info-val status-val" :class="'st-' + settlement.status">{{ getSettlementStatus(settlement.status) }}</text>
          </view>
          <view class="info-cell">
            <text class="info-lbl">提现状态</text>
            <text class="info-val withdraw-val">{{ getWithdrawStatus(settlement.withdrawStatus) }}</text>
          </view>
          <view class="info-cell">
            <text class="info-lbl">结算日期</text>
            <text class="info-val time-val">{{ settlement.settleDate || '--' }}</text>
          </view>
          <view class="info-cell">
            <text class="info-lbl">结算时间</text>
            <text class="info-val time-val">{{ settlement.settleTime || '--' }}</text>
          </view>
        </view>
      </view>

      <!-- 订单统计 -->
      <view class="info-section">
        <view class="bar-line bar-line-green"></view>
        <text class="section-title">订单统计</text>
        <view class="stat-grid">
          <view class="stat-cell">
            <text class="stat-num">{{ settlement.totalOrders || 0 }}</text>
            <text class="stat-lbl">订单数</text>
          </view>
          <view class="stat-cell">
            <text class="stat-num">{{ settlement.totalEnergy || 0 }}<text class="stat-unit">kWh</text></text>
            <text class="stat-lbl">总电量</text>
          </view>
        </view>
      </view>

      <!-- 提现信息（有提现记录时显示） -->
      <view class="info-section" v-if="settlement.withdrawNo">
        <view class="bar-line bar-line-blue"></view>
        <text class="section-title">提现信息</text>
        <view class="info-grid">
          <view class="info-cell">
            <text class="info-lbl">提现单号</text>
            <text class="info-val">{{ settlement.withdrawNo }}</text>
          </view>
          <view class="info-cell">
            <text class="info-lbl">提现金额</text>
            <text class="info-val amount-text">¥{{ fmtAmount(settlement.withdrawAmount) }}</text>
          </view>
          <view class="info-cell">
            <text class="info-lbl">提现时间</text>
            <text class="info-val time-val">{{ settlement.withdrawTime || '--' }}</text>
          </view>
        </view>
      </view>

      <!-- 操作按钮区 -->
      <view class="action-section">
        <view class="action-card act-back" hover-class="act-hover" @tap="goBack">
          <view class="act-color-bar ac-back-bar"></view>
          <text class="act-icon">←</text>
          <text class="act-name">返回列表</text>
          <text class="act-desc">查看更多结算单</text>
        </view>
      </view>

      <view style="height: 100rpx;"></view>
    </scroll-view>
  </view>
</template>

<script>
import { getSettlementDetail } from '@/api/charger/settlement'

export default {
  data: function() {
    return {
      isReady: false,
      glowRows: [],
      settlementId: '',
      settlement: {
        settlementId: '', merchantId: '', settleDate: '', totalOrders: 0,
        totalEnergy: 0, totalAmount: 0, platformCommission: 0,
        settleAmount: 0, status: '', settleTime: '',
        withdrawNo: '', withdrawAmount: 0, withdrawStatus: '',
        withdrawTime: '', createTime: ''
      }
    }
  },
  onLoad: function(options) {
    if (options && options.settlementId) {
      this.settlementId = options.settlementId
      this.loadSettlementData(options.settlementId)
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

    loadSettlementData: function(settlementId) {
      var self = this
      getSettlementDetail(settlementId).then(function(res) {
        if (res.code === 200) {
          var data = res.data
          data.settlementId = settlementId
          self.settlement = data
        } else {
          uni.showToast({ title: res.msg || '加载数据失败', icon: 'none' })
        }
      }).catch(function() {
        uni.showToast({ title: '网络异常', icon: 'none' })
      })
    },

    goBack: function() {
      uni.navigateBack({ delta: 1 })
    },

    getSettlementStatus: function(status) {
      var map = { '0': '待结算', '1': '已结算', '2': '已取消' }
      return map[status] || '未知'
    },

    getWithdrawStatus: function(status) {
      if (!status) return '未提现'
      var map = { '0': '待提现', '1': '提现中', '2': '已完成' }
      return map[status] || status
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
.page { min-height: 100vh; background: linear-gradient(180deg, #fff7ed 0%, #fffbeb 35%, #fefce8 65%, #fffbeb 100%); position: relative; overflow-x: hidden; }
.glow-matrix { position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 0; pointer-events: none; }
.glow-spot { position: absolute; border-radius: 50%; filter: blur(60rpx); }
@keyframes floatGlow { 0% { transform: translate(0, 0) scale(1); } 100% { transform: translate(20rpx, -30rpx) scale(1.15); } }
.overlay-mask { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: linear-gradient(180deg, rgba(255,247,237,0.92) 0%, rgba(255,251,235,0.95) 38%, rgba(254,252,232,0.96) 66%, rgba(255,247,237,0.97) 100%); z-index: 1; pointer-events: none; }
.main-scroll { height: 100vh; position: relative; z-index: 2; }

.page-ready .main-scroll { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) both; }
@keyframes fadeSlideUp { from { opacity: 0; transform: translateY(28rpx); } to { opacity: 1; transform: translateY(0); } }

/* ========== 顶栏 ========== */
.header { display: flex; flex-direction: row; align-items: center; padding: 80rpx 28rpx 36rpx; position: relative; z-index: 2; }
.header-bg { position: absolute; top: 0; left: 0; right: 0; height: 280rpx; border-radius: 0 0 48rpx 48rpx; box-shadow: 0 10rpx 40rpx rgba(217, 119, 6, 0.18); }
.hb-0 { background: linear-gradient(135deg, #9ca3af 0%, #d1d5db 40%, #e5e7eb 70%, #f3f4f6 100%); }
.hb-1 { background: linear-gradient(135deg, #d97706 0%, #f59e0b 40%, #fb923c 70%, #fbbf24 100%); }
.hb-2 { background: linear-gradient(135deg, #9ca3af 0%, #d1d5db 40%, #e5e7eb 70%, #f3f4f6 100%); }
.back-btn { width: 64rpx; height: 64rpx; border-radius: 50%; background: rgba(255,255,255,0.22); display: flex; align-items: center; justify-content: center; z-index: 3; }
.back-icon { font-size: 36rpx; color: #ffffff; font-weight: 300; }
.btn-hover { transform: scale(0.92); background: rgba(255,255,255,0.32); }
.header-info { flex: 1; margin-left: 18rpx; z-index: 2; }
.header-title { font-size: 36rpx; color: #ffffff; font-weight: 700; letter-spacing: 1px; }
.header-sub { font-size: 24rpx; color: rgba(255,255,255,0.82); margin-top: 4px; font-weight: 500; }

/* ========== 金额卡片 ========== */
.amount-card { margin: 16rpx 24rpx 18rpx; padding: 32rpx; border-radius: 24rpx; background: rgba(255, 255, 255, 0.88); backdrop-filter: blur(20px); box-shadow: 0 10rpx 40rpx rgba(217, 119, 6, 0.12); border: 1px solid rgba(255, 255, 255, 0.9); position: relative; z-index: 3; }
.amount-row { display: flex; align-items: baseline; justify-content: space-between; margin-bottom: 16rpx; }
.amount-label { font-size: 26rpx; color: #78716c; font-weight: 500; }
.amount-big { font-size: 52rpx; font-weight: 900; color: #f59e0b; letter-spacing: -0.5rpx; }
.amount-sub { display: flex; align-items: center; gap: 16rpx; padding-top: 16rpx; border-top: 1rpx solid rgba(245, 158, 11, 0.08); }
.sub-item { display: flex; flex-direction: column; align-items: center; }
.sub-lbl { font-size: 20rpx; color: #9ca3af; }
.sub-val { font-size: 24rpx; color: #374151; font-weight: 600; margin-top: 2rpx; }
.sub-divider { width: 1rpx; height: 36rpx; background: #e5e7eb; }
.sub-highlight .sub-val.big { font-size: 28rpx; color: #16a34a; font-weight: 800; }

/* ========== 信息区块 ========== */
.info-section { margin: 0 24rpx 18rpx; padding: 24rpx; border-radius: 22rpx; background: rgba(255, 255, 255, 0.82); backdrop-filter: blur(16px); box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.04); border: 1px solid rgba(255, 255, 255, 0.85); }
.bar-line { width: 5rpx; height: 28rpx; border-radius: 3px; margin-right: 14rpx; flex-shrink: 0; }
.bar-line-orange2 { background: linear-gradient(180deg, #b45309, #d97706); box-shadow: 0 0 10rpx rgba(180,83,9,0.3); }
.bar-line-green { background: linear-gradient(180deg, #d97706, #f59e0b); box-shadow: 0 0 10rpx rgba(217,119,6,0.3); }
.bar-line-blue { background: linear-gradient(180deg, #f59e0b, #fb923c); box-shadow: 0 0 10rpx rgba(245,158,11,0.3); }
.section-title { display: flex; align-items: center; font-size: 28rpx; font-weight: 700; color: #1f2937; margin-bottom: 18rpx; }

.info-grid { display: flex; flex-direction: column; gap: 14rpx; }
.info-cell { display: flex; flex-direction: row; align-items: center; justify-content: space-between; padding: 10rpx 0; border-bottom: 1rpx solid rgba(0,0,0,0.03); }
.info-cell:last-child { border-bottom: none; }
.info-lbl { font-size: 24rpx; color: #9ca3af; }
.info-val { font-size: 26rpx; color: #374151; font-weight: 500; }
.status-val.st-0 { color: #f59e0b !important; font-weight: 700; }
.status-val.st-1 { color: #16a34a !important; font-weight: 700; }
.status-val.st-2 { color: #9ca3af !important; font-weight: 700; }
.withdraw-val { color: #2563eb !important; font-weight: 600; }
.time-val { color: #6b7280; }
.amount-text { color: #16a34a !important; font-weight: 700; }

/* ========== 统计网格 ========== */
.stat-grid { display: flex; flex-direction: row; gap: 16rpx; }
.stat-cell { flex: 1; text-align: center; padding: 20rpx 12rpx; background: linear-gradient(135deg, rgba(245,158,11,0.05), rgba(251,146,60,0.03)); border-radius: 14rpx; border: 1rpx solid rgba(245, 158, 11, 0.08); }
.stat-num { font-size: 34rpx; font-weight: 800; color: #f59e0b; }
.stat-unit { font-size: 20rpx; color: #d97706; font-weight: 500; }
.stat-lbl { font-size: 22rpx; color: #9ca3af; margin-top: 6rpx; }

/* ========== 操作按钮区 ========== */
.action-section { display: flex; gap: 16rpx; padding: 0 24rpx; position: relative; z-index: 2; }
.action-card { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 28rpx 16rpx; border-radius: 22rpx; position: relative; overflow: hidden; transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1); box-shadow: 0 6rpx 24rpx rgba(0, 0, 0, 0.06); }
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
