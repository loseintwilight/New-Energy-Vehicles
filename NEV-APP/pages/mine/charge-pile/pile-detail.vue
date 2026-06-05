<template>
  <view class="page" :class="{ 'page-ready': isReady }">
    <!-- 背景光晕矩阵（暖色琥珀系） -->
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
      <!-- 顶栏（根据桩类型显示不同颜色） -->
      <view class="header" :class="'header-' + pile.type">
        <view class="header-bg" :class="'hbg-' + pile.type"></view>
        <view class="header-circle" :class="'hc-' + pile.type"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="header-info">
          <text class="header-title">充电桩详情</text>
          <text class="header-sub">{{ pile.code }}</text>
        </view>
        <view :class="['status-mini', 'sm-' + pile.status]">
          <view class="sm-dot" v-if="pile.status === '1'"></view>
          <text>{{ statusText }}</text>
        </view>
      </view>

      <!-- Hero区域 - 充电桩大卡片 -->
      <view class="hero-section" :class="'hero-' + pile.type">
        <view class="hero-glow" :class="'hg-' + pile.type"></view>
        <view class="hero-top">
          <view class="hero-icon-wrap" :class="'hiw-' + pile.type">
            <text class="hero-icon">{{ pile.type === 'dc' ? '⚡' : '🔌' }}</text>
          </view>
          <view class="hero-name-area">
            <text class="hero-name">{{ pile.code }}</text>
            <text class="hero-type-label">{{ pile.typeLabel }}</text>
          </view>
          <view :class="['status-badge', 'badge-' + pile.status]">
            <view class="badge-dot" v-if="pile.status === '1'"></view>
            <text>{{ statusText }}</text>
          </view>
        </view>
        <view class="hero-power-row">
          <text class="power-big-num">{{ pile.power }}</text>
          <text class="power-unit">kW</text>
          <view class="connector-tag">
            <text>{{ pile.connector }}</text>
          </view>
        </view>
        <view class="hero-station-row">
          <text class="station-icon">🏪</text>
          <text class="station-text">{{ pile.stationName }}</text>
        </view>
      </view>

      <!-- 基本信息卡（琥珀色条） -->
      <view class="section-block sb-amber">
        <view class="title-bar">
          <view class="bar-line"></view>
          <view class="icon-wrap iw-amber">
            <text class="bar-icon">📋</text>
          </view>
          <text class="bar-title">基本信息</text>
        </view>
        <view class="info-card">
          <view class="info-row">
            <text class="info-label">桩编码</text>
            <text class="info-value code-val">{{ pile.code }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">所属站点</text>
            <text class="info-value">{{ pile.stationName }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">接入方式</text>
            <view class="access-tag-wrap">
              <text :class="['access-tag', 'at-' + pile.accessType]">{{ accessTypeText }}</text>
            </view>
          </view>
          <view class="info-row">
            <text class="info-label">接口类型</text>
            <view class="connector-wrap">
              <text class="connector-icon">{{ connectorIcon }}</text>
              <text class="connector-name">{{ pile.connector }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 实时状态卡（蓝色色条）- 仅充电中时显示 -->
      <view v-if="pile.status === '1'" class="section-block sb-blue">
        <view class="title-bar">
          <view class="bar-line bar-line-blue"></view>
          <view class="icon-wrap iw-blue">
            <text class="bar-icon">📡</text>
          </view>
          <text class="bar-title">实时状态</text>
          <view class="live-dot-wrap">
            <view class="live-dot"></view>
            <text class="live-text">LIVE</text>
          </view>
        </view>
        <view class="monitor-grid">
          <view class="mon-item mi-voltage">
            <text class="mon-label">电压</text>
            <text class="mon-val"><text class="mon-num">{{ pile.voltage }}</text><text class="mon-unit">V</text></text>
          </view>
          <view class="mon-item mi-current">
            <text class="mon-label">电流</text>
            <text class="mon-val"><text class="mon-num">{{ pile.currentA }}</text><text class="mon-unit">A</text></text>
          </view>
          <view class="mon-item mi-power">
            <text class="mon-label">功率</text>
            <text class="mon-val highlight-p"><text class="mon-num big-n">{{ pile.powerNow }}</text><text class="mon-unit">kW</text></text>
          </view>
          <view class="mon-item mi-energy">
            <text class="mon-label">已充时长</text>
            <text class="mon-val"><text class="mon-num time-n">{{ chargingDuration }}</text><text class="mon-unit">分钟</text></text>
          </view>
        </view>
        <view class="extra-info-card">
          <view class="extra-row">
            <text class="extra-label">当前订单号</text>
            <text class="extra-value order-no-val">{{ pile.currentOrderNo }}</text>
          </view>
          <view class="extra-row">
            <text class="extra-label">充电用户</text>
            <text class="extra-value">{{ pile.currentUser }}</text>
          </view>
          <view class="extra-row">
            <text class="extra-label">开始时间</text>
            <text class="extra-value">{{ pile.currentStartTime }}</text>
          </view>
          <view class="extra-row extra-row-last">
            <text class="extra-label">本次已充电量</text>
            <text class="extra-value energy-highlight">{{ chargedEnergy }} kWh</text>
          </view>
        </view>
      </view>

      <!-- 历史数据卡（绿色色条） -->
      <view class="section-block sb-green">
        <view class="title-bar">
          <view class="bar-line bar-line-green"></view>
          <view class="icon-wrap iw-green">
            <text class="bar-icon">📊</text>
          </view>
          <text class="bar-title">历史数据</text>
        </view>
        <view class="stats-grid">
          <view class="stat-item si-total-e">
            <view class="si-icon-wrap si-ewrap">
              <text class="si-icon">⚡</text>
            </view>
            <text class="si-num">{{ pile.energyTotal }}</text>
            <text class="si-unit">kWh</text>
            <text class="si-label">累计充电总量</text>
          </view>
          <view class="stat-divider"></view>
          <view class="stat-item si-today">
            <view class="si-icon-wrap si-twrap">
              <text class="si-icon">📅</text>
            </view>
            <text class="si-num num-green">{{ pile.todayEnergy }}</text>
            <text class="si-unit">kWh</text>
            <text class="si-label">今日充电量</text>
          </view>
          <view class="stat-divider"></view>
          <view class="stat-item si-count">
            <view class="si-icon-wrap si-cwrap">
              <text class="si-icon">🔢</text>
            </view>
            <text class="si-num num-orange">{{ pile.todayCount }}</text>
            <text class="si-unit">次</text>
            <text class="si-label">今日充电次数</text>
          </view>
        </view>
        <view class="heartbeat-card">
          <view class="hb-row">
            <text class="hb-label">最后通讯时间</text>
            <view class="hb-right">
              <view :class="['hb-dot', isOnline ? 'hb-online' : 'hb-offline']"></view>
              <text class="hb-time">{{ pile.lastHeartbeat }}</text>
              <text class="hb-ago">{{ heartbeatAgo }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 操作按钮区 -->
      <view class="action-section">
        <view
          class="action-card act-edit-pile"
          hover-class="act-hover"
          @tap="goEditPile"
        >
          <view class="act-color-bar"></view>
          <text class="act-icon">✏️</text>
          <text class="act-name">编辑充电桩</text>
          <text class="act-desc">修改桩信息与参数</text>
        </view>
        <view
          class="action-card act-del-pile"
          hover-class="act-hover"
          @tap="doDeletePile"
        >
          <view class="act-color-bar ac-del-bar"></view>
          <text class="act-icon">🗑️</text>
          <text class="act-name">删除充电桩</text>
          <text class="act-desc">移除此充电桩</text>
        </view>
        <view
          v-if="pile.status === '2'"
          class="action-card act-restart"
          hover-class="act-hover"
          @tap="doRestart"
        >
          <view class="act-color-bar ac-restart-bar"></view>
          <text class="act-icon">🔄</text>
          <text class="act-name">远程重启</text>
          <text class="act-desc">尝试恢复设备运行</text>
        </view>
        <view
          v-if="pile.status === '1'"
          class="action-card act-order"
          hover-class="act-hover"
          @tap="goOrder"
        >
          <view class="act-color-bar ac-order-bar"></view>
          <text class="act-icon">📋</text>
          <text class="act-name">查看订单</text>
          <text class="act-desc">查看当前充电订单详情</text>
        </view>
        <view
          class="action-card act-back"
          hover-class="act-hover"
          @tap="goBack"
        >
          <view class="act-color-bar ac-back-bar"></view>
          <text class="act-icon">←</text>
          <text class="act-name">返回列表</text>
          <text class="act-desc">回到充电桩列表页</text>
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
      pileId: '',
      timer: null,
      pile: {
        pileId: 3,
        code: 'AT-DC-03',
        type: 'dc',
        typeLabel: 'DC快充',
        power: 180,
        connector: 'GB/T',
        accessType: 'public',
        status: '1',
        statusText: '充电中',
        stationId: 1,
        stationName: '济南奥体中心充电站',
        currentOrderNo: 'CO20260531000001',
        currentUser: '张**',
        currentStartTime: '2026-05-31 08:00:00',
        voltage: 380,
        currentA: 120,
        powerNow: 45.6,
        energyTotal: 12800.80,
        todayEnergy: 128.0,
        todayCount: 8,
        lastHeartbeat: '2026-05-31 08:45:00'
      }
    }
  },
  computed: {
    statusText: function() {
      if (!this.pile) return ''
      var map = { '0': '空闲', '1': '充电中', '2': '离线', '3': '故障' }
      return map[this.pile.status] || '未知'
    },
    accessTypeText: function() {
      if (!this.pile) return ''
      var map = { public: '公用', dedicated: '专用', private: '自用' }
      return map[this.pile.accessType] || this.pile.accessType || '-'
    },
    connectorIcon: function() {
      if (!this.pile) return '🔌'
      var icons = { 'GB/T': '🔌', 'CCS': '⚡', 'Type2': '🔋' }
      return icons[this.pile.connector] || '🔌'
    },
    isOnline: function() {
      if (!this.pile || !this.pile.lastHeartbeat) return false
      var hbTime = new Date(this.pile.lastHeartbeat.replace(/-/g, '/'))
      var now = new Date()
      var diffMin = (now - hbTime) / 1000 / 60
      return diffMin < 30
    },
    heartbeatAgo: function() {
      if (!this.pile || !this.pile.lastHeartbeat) return ''
      var hbTime = new Date(this.pile.lastHeartbeat.replace(/-/g, '/'))
      var now = new Date()
      var diffMin = Math.floor((now - hbTime) / 1000 / 60)
      if (diffMin < 1) return '刚刚'
      if (diffMin < 60) return diffMin + '分钟前'
      if (diffMin < 1440) return Math.floor(diffMin / 60) + '小时前'
      return Math.floor(diffMin / 1440) + '天前'
    },
    chargingDuration: function() {
      if (!this.pile || !this.pile.currentStartTime || this.pile.status !== '1') return '--'
      var startTime = new Date(this.pile.currentStartTime.replace(/-/g, '/'))
      var now = new Date()
      var diffMin = Math.floor((now - startTime) / 1000 / 60)
      return diffMin > 0 ? diffMin : 0
    },
    chargedEnergy: function() {
      if (this.pile.status !== '1' || !this.pile.powerNow) return '0.00'
      var duration = this.chargingDuration
      if (duration <= 0) return '0.00'
      var energy = (this.pile.powerNow * duration / 60).toFixed(2)
      return energy
    }
  },
  created: function() {
    this.buildGlowRows()
    var that = this
    setTimeout(function() {
      that.isReady = true
    }, 200)
  },
  onLoad: function(options) {
    if (options && options.pileId) {
      this.pileId = options.pileId
    }
  },
  onShow: function() {
    this.startTimer()
  },
  onHide: function() {
    this.stopTimer()
  },
  onUnload: function() {
    this.stopTimer()
  },
  methods: {
    buildGlowRows: function() {
      var rows = []
      var colors = ['#f59e0b', '#f97316', '#fb923c', '#fbbf24', '#fcd34d', '#fde68a']
      for (var r = 0; r < 8; r++) {
        var dots = []
        var count = 3 + Math.floor(Math.random() * 3)
        for (var c = 0; c < count; c++) {
          var color = colors[Math.floor(Math.random() * colors.length)]
          var size = 60 + Math.floor(Math.random() * 80)
          var dur = 2.5 + Math.random() * 2.5
          var delay = Math.random() * 2.5
          var alpha = 0.06 + Math.random() * 0.16
          dots.push({
            style: 'width:' + size + 'rpx;height:' + size + 'rpx;background:radial-gradient(circle,' + color + ',' + color + '00);opacity:' + alpha.toFixed(2) + ';animation-duration:' + dur.toFixed(1) + 's;animation-delay:' + delay.toFixed(1) + 's;'
          })
        }
        rows.push({ dots: dots })
      }
      this.glowRows = rows
    },

    startTimer: function() {
      var that = this
      that.stopTimer()
      that.timer = setInterval(function() {
        that.$forceUpdate()
      }, 60000)
    },

    stopTimer: function() {
      if (this.timer) {
        clearInterval(this.timer)
        this.timer = null
      }
    },

    goBack: function() {
      uni.navigateBack({ delta: 1 })
    },

    goEditPile: function() {
      uni.navigateTo({ url: '/pages/mine/charge-pile/pile-add?pileId=' + this.pileId + '&mode=edit' })
    },

    doDeletePile: function() {
      var self = this
      uni.showModal({
        title: '确认删除',
        content: '确定要删除充电桩「' + this.pile.code + '」吗？删除后不可恢复。',
        confirmColor: '#ef4444',
        success: function(res) {
          if (res.confirm) {
            uni.showToast({ title: '已删除', icon: 'success' })
            setTimeout(function() { uni.navigateBack({ delta: 1 }) }, 1200)
          }
        }
      })
    },

    doRestart: function() {
      var that = this
      uni.showModal({
        title: '确认远程重启',
        content: '确定要远程重启该充电桩吗？重启后设备将短暂离线。',
        success: function(res) {
          if (res.confirm) {
            uni.showToast({ title: '重启指令已发送', icon: 'success' })
          }
        }
      })
    },

    goOrder: function() {
      uni.showToast({
        title: '正在跳转订单详情...',
        icon: 'none'
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

/* ========== 入场动画 ========== */
.page-ready .hero-section { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.05s; }
.page-ready .section-block:nth-of-type(1) { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.12s; }
.page-ready .section-block:nth-of-type(2) { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.19s; }
.page-ready .section-block:nth-of-type(3) { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.26s; }
.page-ready .action-section { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.33s; }

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
  0% { opacity: 0.12; transform: scale(0.85); }
  50% { opacity: 0.55; }
  100% { opacity: 0.12; transform: scale(1.25); }
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

/* ========== 顶栏（动态颜色） ========== */
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
  border-radius: 0 0 60rpx 60rpx;
}
.hbg-dc {
  background: linear-gradient(135deg, #d97706 0%, #f59e0b 35%, #fb923c 65%, #fbbf24 100%);
}
.hbg-ac {
  background: linear-gradient(135deg, #f59e0b 0%, #fb923c 35%, #fcd34d 65%, #fde68a 100%);
}

.header-circle {
  position: absolute;
  top: -50rpx;
  right: -30rpx;
  width: 300rpx;
  height: 300rpx;
  border-radius: 50%;
  pointer-events: none;
}
.hc-dc {
  background: radial-gradient(circle, rgba(255, 255, 255, 0.15) 0%, transparent 70%);
}
.hc-ac {
  background: radial-gradient(circle, rgba(255, 255, 255, 0.12) 0%, transparent 70%);
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

/* 顶栏状态徽章 */
.status-mini {
  border-radius: 14rpx;
  padding: 8rpx 18rpx;
  font-size: 22rpx;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 8rpx;
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  z-index: 2;
}
.sm-dot {
  width: 10rpx;
  height: 10rpx;
  border-radius: 50%;
  background: #ffffff;
  box-shadow: 0 0 8rpx #ffffff;
  animation: badgePulse 2s ease-in-out infinite;
}
@keyframes badgePulse {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.5; transform: scale(0.85); }
}
.sm-0 { background: rgba(255, 255, 255, 0.22); color: #ffffff; border: 1rpx solid rgba(255, 255, 255, 0.35); }
.sm-1 { background: rgba(255, 255, 255, 0.22); color: #ffffff; border: 1rpx solid rgba(255, 255, 255, 0.35); }
.sm-2 { background: rgba(255, 255, 255, 0.18); color: #dc2626; border: 1rpx solid rgba(220, 38, 38, 0.4); }
.sm-3 { background: rgba(255, 255, 255, 0.15); color: #6b7280; border: 1rpx solid rgba(107, 114, 128, 0.4); }

/* ========== Hero区域 ========== */
.hero-section {
  margin: 0 24rpx 20rpx;
  border-radius: 28rpx;
  padding: 32rpx 28rpx 28rpx;
  position: relative;
  overflow: hidden;
  box-shadow: inset 0 1rpx 0 rgba(255, 255, 255, 0.25);
}
.hero-dc {
  background: linear-gradient(135deg, #d97706 0%, #f59e0b 40%, #fb923c 70%, #fbbf24 100%);
  box-shadow: 0 12rpx 40rpx rgba(217, 119, 6, 0.35), inset 0 1rpx 0 rgba(255, 255, 255, 0.25);
}
.hero-ac {
  background: linear-gradient(135deg, #f59e0b 0%, #fb923c 40%, #fcd34d 70%, #fde68a 100%);
  box-shadow: 0 12rpx 40rpx rgba(245, 158, 11, 0.35), inset 0 1rpx 0 rgba(255, 255, 255, 0.25);
}
.hero-glow {
  position: absolute;
  top: -60rpx;
  right: -60rpx;
  width: 200rpx;
  height: 200rpx;
  border-radius: 50%;
  pointer-events: none;
}
.hg-dc { background: radial-gradient(circle, rgba(255, 255, 255, 0.18) 0%, transparent 70%); }
.hg-ac { background: radial-gradient(circle, rgba(255, 255, 255, 0.15) 0%, transparent 70%); }

.hero-top {
  display: flex;
  flex-direction: row;
  align-items: center;
  margin-bottom: 20rpx;
  position: relative;
  z-index: 1;
}
.hero-icon-wrap {
  width: 80rpx;
  height: 80rpx;
  border-radius: 22rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 18rpx;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.08);
}
.hiw-dc { background: rgba(255, 255, 255, 0.28); }
.hiw-ac { background: rgba(255, 255, 255, 0.25); }
.hero-icon { font-size: 40rpx; }
.hero-name-area {
  flex: 1;
  display: flex;
  flex-direction: column;
}
.hero-name {
  font-size: 32rpx;
  font-weight: 800;
  color: #ffffff;
  letter-spacing: 0.5rpx;
  text-shadow: 0 2rpx 6rpx rgba(0, 0, 0, 0.1);
}
.hero-type-label {
  font-size: 22rpx;
  color: rgba(255, 255, 255, 0.78);
  margin-top: 4rpx;
  font-weight: 500;
}

/* Hero内状态徽章 */
.status-badge {
  border-radius: 14rpx;
  padding: 8rpx 18rpx;
  font-size: 22rpx;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 8rpx;
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
}
.badge-dot {
  width: 10rpx;
  height: 10rpx;
  border-radius: 50%;
  background: #ffffff;
  box-shadow: 0 0 8rpx #ffffff;
  animation: badgePulse 2s ease-in-out infinite;
}
.badge-0 { background: rgba(255, 255, 255, 0.22); color: #ffffff; border: 1rpx solid rgba(255, 255, 255, 0.35); }
.badge-1 { background: rgba(255, 255, 255, 0.22); color: #ffffff; border: 1rpx solid rgba(255, 255, 255, 0.35); }
.badge-2 { background: rgba(255, 255, 255, 0.18); color: #dc2626; border: 1rpx solid rgba(220, 38, 38, 0.4); }
.badge-3 { background: rgba(255, 255, 255, 0.15); color: #6b7280; border: 1rpx solid rgba(107, 114, 128, 0.4); }

/* 功率行 */
.hero-power-row {
  display: flex;
  flex-direction: row;
  align-items: baseline;
  margin-bottom: 16rpx;
  position: relative;
  z-index: 1;
}
.power-big-num {
  font-size: 72rpx;
  font-weight: 900;
  color: #ffffff;
  line-height: 1;
  text-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.12);
}
.power-unit {
  font-size: 30rpx;
  font-weight: 700;
  color: rgba(255, 255, 255, 0.85);
  margin-left: 8rpx;
}
.connector-tag {
  margin-left: 20rpx;
  padding: 6rpx 18rpx;
  border-radius: 12rpx;
  background: rgba(255, 255, 255, 0.22);
  border: 1rpx solid rgba(255, 255, 255, 0.35);
}
.connector-tag text {
  font-size: 22rpx;
  font-weight: 700;
  color: #ffffff;
}

/* 站点行 */
.hero-station-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  position: relative;
  z-index: 1;
}
.station-icon { font-size: 26rpx; margin-right: 10rpx; }
.station-text {
  font-size: 25rpx;
  color: rgba(255, 255, 255, 0.92);
  font-weight: 500;
}

/* ========== 区块通用 ========== */
.section-block {
  margin: 0 24rpx 20rpx;
  background: rgba(255, 255, 255, 0.82);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border-radius: 24rpx;
  padding: 24rpx 22rpx;
  box-shadow: 0 6rpx 28rpx rgba(0, 0, 0, 0.05), inset 0 1rpx 0 rgba(255, 255, 255, 0.9);
  border: 1rpx solid rgba(255, 255, 255, 0.8);
  position: relative;
  z-index: 2;
  overflow: hidden;
}

.title-bar {
  display: flex;
  flex-direction: row;
  align-items: center;
  margin-bottom: 18rpx;
}
.bar-line {
  width: 7rpx;
  height: 32rpx;
  border-radius: 4rpx;
  margin-right: 12rpx;
  background: linear-gradient(180deg, #f59e0b, #f97316);
  box-shadow: 0 0 12rpx rgba(245, 158, 11, 0.35);
}
.bar-line-green { background: linear-gradient(180deg, #d97706, #f59e0b); box-shadow: 0 0 12rpx rgba(217,119,6,0.35); }
.bar-line-blue { background: linear-gradient(180deg, #f59e0b, #fb923c); box-shadow: 0 0 12rpx rgba(245,158,11,0.35); }

.icon-wrap {
  width: 48rpx;
  height: 48rpx;
  border-radius: 14rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 12rpx;
}
.iw-amber { background: linear-gradient(135deg, rgba(245, 158, 11, 0.15), rgba(251, 146, 60, 0.08)); }
.iw-green { background: linear-gradient(135deg, rgba(34, 197, 94, 0.15), rgba(22, 163, 74, 0.08)); }
.iw-blue { background: linear-gradient(135deg, rgba(59, 130, 246, 0.15), rgba(37, 99, 235, 0.08)); }

.bar-icon { font-size: 26rpx; }
.bar-title {
  font-size: 30rpx;
  font-weight: 800;
  color: #1c1917;
  flex: 1;
  letter-spacing: 0.5rpx;
}

.live-dot-wrap {
  display: flex;
  align-items: center;
  gap: 6rpx;
  padding: 4rpx 14rpx;
  border-radius: 10rpx;
  background: linear-gradient(135deg, rgba(239, 68, 68, 0.1), rgba(220, 38, 38, 0.05));
}
.live-dot {
  width: 10rpx;
  height: 10rpx;
  border-radius: 50%;
  background: #ef4444;
  animation: liveBlink 1.2s ease-in-out infinite;
}
@keyframes liveBlink {
  0%, 100% { opacity: 1; box-shadow: 0 0 6rpx #ef4444; }
  50% { opacity: 0.3; box-shadow: 0 0 2rpx #ef4444; }
}
.live-text {
  font-size: 18rpx;
  font-weight: 800;
  color: #dc2626;
  letter-spacing: 1rpx;
}

/* ========== 信息卡片 ========== */
.info-card {
  background: linear-gradient(135deg, rgba(254, 251, 236, 0.98), rgba(255, 255, 255, 1));
  border-radius: 18rpx;
  padding: 6rpx 22rpx;
  border: 1rpx solid rgba(245, 158, 11, 0.08);
}
.info-row {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  padding: 14rpx 0;
  border-bottom: 1rpx solid rgba(245, 158, 11, 0.06);
}
.info-row:last-child { border-bottom: none; }
.info-label {
  font-size: 25rpx;
  color: #a16207;
  font-weight: 600;
  flex-shrink: 0;
}
.info-value {
  font-size: 26rpx;
  color: #1c1917;
  font-weight: 600;
  text-align: right;
}
.info-value.code-val {
  font-family: monospace;
  letter-spacing: 0.5rpx;
  color: #d97706;
}

.access-tag-wrap {
  display: flex;
  justify-content: flex-end;
}
.access-tag {
  font-size: 22rpx;
  font-weight: 700;
  padding: 6rpx 20rpx;
  border-radius: 10rpx;
}
.at-public { color: #d97706; background: linear-gradient(135deg, rgba(217,119,6,0.12), rgba(245,158,11,0.06)); border: 1rpx solid rgba(217,119,6,0.2); }
.at-dedicated { color: #f59e0b; background: linear-gradient(135deg, rgba(245,158,11,0.12), rgba(251,146,60,0.06)); border: 1rpx solid rgba(245,158,11,0.2); }
.at-private { color: #78716c; background: linear-gradient(135deg, rgba(120, 113, 108, 0.1), rgba(168, 162, 158, 0.05)); }

.connector-wrap {
  display: flex;
  align-items: center;
  gap: 8rpx;
}
.connector-icon { font-size: 28rpx; }
.connector-name {
  font-size: 26rpx;
  color: #1c1917;
  font-weight: 600;
}

/* ========== 实时监控网格 ========== */
.monitor-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 14rpx;
  margin-bottom: 14rpx;
}
.mon-item {
  text-align: center;
  padding: 24rpx 16rpx;
  border-radius: 18rpx;
  position: relative;
  overflow: hidden;
}
.mi-voltage { background: linear-gradient(135deg, rgba(34, 197, 94, 0.08), rgba(22, 163, 74, 0.04)); }
.mi-current { background: linear-gradient(135deg, rgba(59, 130, 246, 0.08), rgba(37, 99, 235, 0.04)); }
.mi-power { background: linear-gradient(135deg, rgba(245, 158, 11, 0.1), rgba(251, 146, 60, 0.05)); }
.mi-energy { background: linear-gradient(135deg, rgba(168, 85, 247, 0.08), rgba(147, 51, 234, 0.04)); }

.mon-label {
  display: block;
  font-size: 21rpx;
  color: #78716c;
  font-weight: 600;
  margin-bottom: 10rpx;
}
.mon-val {
  font-size: 28rpx;
  font-weight: 700;
  color: #334155;
}
.highlight-p { color: #ea580c; }
.mon-num {
  font-size: 36rpx;
  font-weight: 900;
}
.big-n { font-size: 44rpx; }
.time-n { font-size: 32rpx; }
.mon-unit {
  font-size: 20rpx;
  font-weight: normal;
  margin-left: 4rpx;
  opacity: 0.7;
}

.extra-info-card {
  background: linear-gradient(135deg, rgba(238, 242, 255, 0.98), rgba(255, 255, 255, 1));
  border-radius: 18rpx;
  padding: 4rpx 22rpx;
  border: 1rpx solid rgba(59, 130, 246, 0.08);
}
.extra-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  padding: 14rpx 0;
  border-bottom: 1rpx solid rgba(59, 130, 246, 0.05);
}
.extra-row-last { border-bottom: none; }
.extra-label {
  font-size: 24rpx;
  color: #78716c;
  font-weight: 600;
  flex-shrink: 0;
}
.extra-value {
  font-size: 25rpx;
  color: #1c1917;
  font-weight: 600;
  text-align: right;
}
.order-no-val {
  font-family: "Courier New", Consolas, monospace;
  font-size: 22rpx;
  letter-spacing: 0.5rpx;
  word-break: break-all;
}
.energy-highlight {
  color: #d97706;
  font-weight: 800;
  font-size: 27rpx;
}

/* ========== 历史数据统计 ========== */
.stats-grid {
  display: flex;
  flex-direction: row;
  align-items: center;
  background: linear-gradient(135deg, rgba(240, 253, 244, 0.98), rgba(255, 255, 255, 1));
  border-radius: 18rpx;
  padding: 24rpx 8rpx;
  border: 1rpx solid rgba(34, 197, 94, 0.08);
  margin-bottom: 14rpx;
}
.stat-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4rpx;
}
.si-icon-wrap {
  width: 52rpx;
  height: 52rpx;
  border-radius: 14rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 4rpx;
}
.si-ewrap { background: linear-gradient(135deg, rgba(245, 158, 11, 0.15), rgba(251, 146, 60, 0.08)); }
.si-twrap { background: linear-gradient(135deg, rgba(34, 197, 94, 0.15), rgba(22, 163, 74, 0.08)); }
.si-cwrap { background: linear-gradient(135deg, rgba(249, 115, 22, 0.15), rgba(234, 88, 12, 0.08)); }
.si-icon { font-size: 26rpx; font-weight: 900; }
.si-num {
  font-size: 34rpx;
  font-weight: 900;
  color: #1c1917;
  letter-spacing: 0.5rpx;
  line-height: 1.2;
}
.si-num.num-green { color: #d97706; }
.si-num.num-orange { color: #ea580c; }
.si-unit {
  font-size: 19rpx;
  color: #a8a29e;
  font-weight: 500;
}
.si-label {
  font-size: 20rpx;
  color: #a8a29e;
  font-weight: 600;
  margin-top: 4rpx;
}
.stat-divider {
  width: 1rpx;
  height: 56rpx;
  background: linear-gradient(180deg, transparent, #6b7280, transparent);
}

.heartbeat-card {
  background: linear-gradient(135deg, rgba(250, 252, 250, 0.98), rgba(255, 255, 255, 1));
  border-radius: 16rpx;
  padding: 4rpx 22rpx;
  border: 1rpx solid rgba(34, 197, 94, 0.06);
}
.hb-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  padding: 16rpx 0;
}
.hb-label { font-size: 25rpx; color: #78716c; font-weight: 600; }
.hb-right {
  display: flex;
  align-items: center;
  gap: 10rpx;
}
.hb-dot {
  width: 14rpx;
  height: 14rpx;
  border-radius: 50%;
}
.hb-online {
  background: #22c55e;
  box-shadow: 0 0 10rpx rgba(34, 197, 94, 0.5);
  animation: hbPulse 2s ease-in-out infinite;
}
.hb-offline { background: #9ca3af; }
@keyframes hbPulse {
  0%, 100% { box-shadow: 0 0 10rpx rgba(34, 197, 94, 0.5); }
  50% { box-shadow: 0 0 20rpx rgba(34, 197, 94, 0.8), 0 0 36rpx rgba(34, 197, 94, 0.3); }
}
.hb-time {
  font-size: 23rpx;
  color: #334155;
  font-weight: 600;
}
.hb-ago {
  font-size: 20rpx;
  color: #a8a29e;
  font-weight: 500;
}

/* ========== 操作按钮区 ========== */
.action-section {
  display: flex;
  gap: 16rpx;
  padding: 0 24rpx;
  position: relative;
  z-index: 2;
}
.action-card {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 28rpx 16rpx;
  border-radius: 22rpx;
  position: relative;
  overflow: hidden;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  box-shadow: 0 6rpx 24rpx rgba(0, 0, 0, 0.06);
}
.act-hover {
  transform: scale(0.95)!important;
  box-shadow: 0 12rpx 32rpx rgba(0, 0, 0, 0.12)!important;
}
.act-color-bar {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 5rpx;
  border-radius: 22rpx 0 0 22rpx;
  transition: all 0.3s ease;
}

/* 编辑充电桩（深琥珀系） */
.act-edit-pile {
  background: linear-gradient(135deg, #d97706, #f59e0b, #fb923c);
}
.act-edit-pile .act-color-bar { background: linear-gradient(180deg, #ffffff 0%, rgba(255,255,255,0.3) 100%); }
.act-edit-pile .act-icon, .act-edit-pile .act-name { color: #ffffff; }
.act-edit-pile .act-desc { color: rgba(255, 255, 255, 0.8); }

/* 删除充电桩（橙色系） */
.act-del-pile {
  background: linear-gradient(135deg, #f59e0b, #fb923c, #fbbf24);
}
.act-del-pile .ac-del-bar { background: linear-gradient(180deg, #ffffff 0%, rgba(255,255,255,0.3) 100%); }
.act-del-pile .act-icon, .act-del-pile .act-name { color: #ffffff; }
.act-del-pile .act-desc { color: rgba(255, 255, 255, 0.8); }

/* 远程重启（红色系） */
.act-restart {
  background: linear-gradient(135deg, #ef4444, #dc2626, #b91c1c);
}
.ac-restart-bar { background: linear-gradient(180deg, #ffffff 0%, rgba(255,255,255,0.3) 100%); }
.act-restart .act-icon, .act-restart .act-name { color: #ffffff; }
.act-restart .act-desc { color: rgba(255, 255, 255, 0.8); }

/* 查看订单（琥珀系） */
.act-order {
  background: linear-gradient(135deg, #f59e0b, #f97316, #ea580c);
}
.ac-order-bar { background: linear-gradient(180deg, #ffffff 0%, rgba(255,255,255,0.3) 100%); }
.act-order .act-icon, .act-order .act-name { color: #ffffff; }
.act-order .act-desc { color: rgba(255, 255, 255, 0.8); }

/* 返回列表（灰色系） */
.act-back {
  background: linear-gradient(135deg, #9ca3af, #6b7280, #4b5563);
}
.ac-back-bar { background: linear-gradient(180deg, #ffffff 0%, rgba(255,255,255,0.3) 100%); }
.act-back .act-icon, .act-back .act-name { color: #ffffff; }
.act-back .act-desc { color: rgba(255, 255, 255, 0.8); }

.act-hover .act-color-bar { width: 7rpx; }

.act-icon { font-size: 36rpx; margin-bottom: 10rpx; }
.act-name { font-size: 26rpx; font-weight: 800; margin-bottom: 6rpx; }
.act-desc { font-size: 20rpx; font-weight: 500; }
</style>
