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
      <!-- 顶栏（琥珀渐变） -->
      <view class="header">
        <view class="header-bg"></view>
        <view class="header-circle"></view>
        <view class="back-btn" hover-class="btn-hover" @tap="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="header-info">
          <text class="header-title">站点详情</text>
          <text class="header-sub">{{ station.name }}</text>
        </view>
        <view class="header-right" @tap="goEdit">
          <text class="edit-text">编辑</text>
        </view>
      </view>

      <!-- Hero区域 - 站点大卡片 -->
      <view class="hero-section">
        <view class="hero-glow"></view>
        <view class="hero-top">
          <view class="hero-icon-wrap">
            <text class="hero-icon">🏪</text>
          </view>
          <view class="hero-name-area">
            <text class="hero-name">{{ station.name }}</text>
            <text class="hero-code">{{ station.code }}</text>
          </view>
          <view :class="['status-badge', 'badge-' + station.status]">
            <view class="badge-dot" v-if="station.status === '1'"></view>
            <text>{{ statusText }}</text>
          </view>
        </view>
        <view class="hero-addr-row">
          <text class="addr-icon">📍</text>
          <text class="addr-text">{{ station.province }}{{ station.city }}{{ station.district }}{{ station.address }}</text>
        </view>
        <view class="hero-coord-row">
          <text class="coord-text">经度 {{ station.longitude }} · 纬度 {{ station.latitude }}</text>
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
            <text class="info-label">站点名称</text>
            <text class="info-value">{{ station.name }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">站点编码</text>
            <text class="info-value code-val">{{ station.code }}</text>
          </view>
          <view class="info-row info-row-full">
            <text class="info-label">详细地址</text>
            <view class="addr-full">
              <text class="addr-mark">📍</text>
              <text class="info-value addr-val">{{ station.province }}{{ station.city }}{{ station.district }}{{ station.address }}</text>
            </view>
          </view>
          <view class="info-row">
            <text class="info-label">坐标位置</text>
            <text class="info-value coord-val">{{ station.longitude }}, {{ station.latitude }}</text>
          </view>
        </view>
      </view>

      <!-- 运营数据卡（绿色色条） -->
      <view class="section-block sb-green">
        <view class="title-bar">
          <view class="bar-line bar-line-green"></view>
          <view class="icon-wrap iw-green">
            <text class="bar-icon">📊</text>
          </view>
          <text class="bar-title">运营数据</text>
        </view>
        <view class="stats-grid">
          <view class="stat-item si-total">
            <view class="si-icon-wrap">
              <text class="si-icon">◎</text>
            </view>
            <text class="si-num">{{ station.totalPiles }}</text>
            <text class="si-label">总桩数</text>
          </view>
          <view class="stat-divider"></view>
          <view class="stat-item si-avail">
            <view class="si-icon-wrap">
              <text class="si-icon">✓</text>
            </view>
            <text class="si-num num-green">{{ station.availablePiles }}</text>
            <text class="si-label">空闲桩</text>
          </view>
          <view class="stat-divider"></view>
          <view class="stat-item si-busy">
            <view class="si-icon-wrap">
              <text class="si-icon">⚡</text>
            </view>
            <text class="si-num num-orange">{{ station.occupyingPiles || 0 }}</text>
            <text class="si-label">占用桩</text>
          </view>
          <view class="stat-divider"></view>
          <view class="stat-item si-fault">
            <view class="si-icon-wrap">
              <text class="si-icon">⚠</text>
            </view>
            <text class="si-num num-gray">{{ faultPiles }}</text>
            <text class="si-label">故障桩</text>
          </view>
        </view>
        <view class="ops-info">
          <view class="ops-row">
            <text class="ops-label">营业时间</text>
            <view class="ops-right">
              <view :class="['biz-badge', isBusinessOpen ? 'bb-open' : 'bb-close']">
                <text>{{ isBusinessOpen ? '营业中' : '已打烊' }}</text>
              </view>
              <text class="ops-time">{{ fmtTime(station.openTime) }} - {{ fmtTime(station.closeTime) }}</text>
            </view>
          </view>
          <view class="ops-row ops-row-last">
            <text class="ops-label">停车收费</text>
            <text class="ops-value">{{ station.parkingFee || '免费' }}</text>
          </view>
        </view>
      </view>

      <!-- 联系方式卡（蓝色色条） -->
      <view class="section-block sb-blue">
        <view class="title-bar">
          <view class="bar-line bar-line-blue"></view>
          <view class="icon-wrap iw-blue">
            <text class="bar-icon">📞</text>
          </view>
          <text class="bar-title">联系方式</text>
        </view>
        <view class="contact-card">
          <view class="contact-row" @tap="callPhone(station.servicePhone)">
            <text class="contact-label">服务电话</text>
            <view class="contact-phone-wrap">
              <text class="contact-phone">{{ station.servicePhone || '未设置' }}</text>
              <text class="call-arrow">›</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 配套设施卡（紫色色条） -->
      <view class="section-block sb-purple">
        <view class="title-bar">
          <view class="bar-line bar-line-purple"></view>
          <view class="icon-wrap iw-purple">
            <text class="bar-icon">🛎️</text>
          </view>
          <text class="bar-title">配套设施</text>
        </view>
        <view class="facility-card">
          <view v-if="station.facilities && station.facilities.length > 0" class="facility-tags">
            <text
              v-for="(fac, fidx) in station.facilities"
              :key="fidx"
              class="facility-tag"
            >{{ fac }}</text>
          </view>
          <view v-else class="facility-empty">
            <text class="empty-txt">暂无配套设施信息</text>
          </view>
        </view>
      </view>

      <!-- 充电桩列表预览 -->
      <view class="section-block sb-pile">
        <view class="title-bar">
          <view class="bar-line bar-line-orange2"></view>
          <view class="icon-wrap iw-orange">
            <text class="bar-icon">🔌</text>
          </view>
          <text class="bar-title">充电桩列表</text>
          <view class="pile-count-badge">
            <text>{{ piles.length }} 台</text>
          </view>
        </view>

        <view v-if="piles.length > 0" class="pile-list">
          <view
            v-for="(pile, pidx) in piles"
            :key="pile.pileId"
            class="pile-item"
            :class="'pi-' + (pidx % 4)"
            hover-class="pile-hover"
            @tap="goPileDetail(pile.pileId)"
          >
            <view class="pi-left-bar"></view>
            <view class="pi-body">
              <view class="pi-top">
                <text class="pi-code">{{ pile.code }}</text>
                <view :class="['type-tag', pile.type === 'dc' ? 'tag-dc' : 'tag-ac']">
                  <text>{{ pile.type === 'dc' ? 'DC快充' : 'AC慢充' }}</text>
                </view>
              </view>
              <view class="pi-bottom">
                <view class="pi-power">
                  <text class="power-icon">⚡</text>
                  <text class="power-num">{{ pile.power }}kW</text>
                  <text class="connector-text">{{ pile.connector }}</text>
                </view>
                <view :class="['pile-status-tag', 'pst-' + pile.status]">
                  <text>{{ getPileStatusText(pile.status) }}</text>
                </view>
              </view>
            </view>
            <view class="pi-arrow">
              <text>›</text>
            </view>
          </view>
        </view>

        <view v-else class="pile-empty-box">
          <view class="pe-icon-wrap">
            <text class="pe-icon">🔌</text>
          </view>
          <text class="pe-main">暂无充电桩数据</text>
          <text class="pe-sub">请前往管理页面添加充电桩</text>
        </view>
      </view>

      <!-- 快捷操作区 -->
      <view class="action-section">
        <view
          class="action-card act-edit"
          hover-class="act-hover"
          @tap="goEdit"
        >
          <view class="act-color-bar"></view>
          <text class="act-icon">✏️</text>
          <text class="act-name">编辑站点</text>
          <text class="act-desc">修改站点基础信息</text>
        </view>
        <view
          class="action-card act-pile"
          hover-class="act-hover"
          @tap="goPileList"
        >
          <view class="act-color-bar"></view>
          <text class="act-icon">🔌</text>
          <text class="act-name">管理充电桩</text>
          <text class="act-desc">添加/编辑/删除桩</text>
        </view>
        <view
          class="action-card act-del"
          hover-class="act-hover"
          @tap="doDeleteStation"
        >
          <view class="act-color-bar"></view>
          <text class="act-icon">🗑</text>
          <text class="act-name">删除站点</text>
          <text class="act-desc">移除此站点及所有桩</text>
        </view>
        <view
          class="action-card act-add-pile"
          hover-class="act-hover"
          @tap="goAddPile"
        >
          <view class="act-color-bar"></view>
          <text class="act-icon">➕</text>
          <text class="act-name">新增充电桩</text>
          <text class="act-desc">添加新充电桩到此站</text>
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
      station: {
        stationId: 1,
        name: '济南奥体中心充电站',
        code: 'JN-AT-001',
        merchantId: 2,
        province: '山东省',
        city: '济南市',
        district: '历下区',
        address: '奥体中路2000号奥体中心P1停车场',
        longitude: 117.1082,
        latitude: 36.6578,
        totalPiles: 8,
        availablePiles: 6,
        occupyingPiles: 2,
        openTime: '00:00:00',
        closeTime: '23:59:59',
        parkingFee: '充电免停2小时',
        servicePhone: '0531-88881001',
        facilities: ['卫生间', '休息室', '免费WiFi', '自动售货机'],
        images: ['station_01_01.jpg', 'station_01_02.jpg'],
        status: '1'
      },
      piles: [
        { pileId: 1, code: 'AT-DC-01', type: 'dc', power: 120, connector: 'GB/T', status: '0' },
        { pileId: 2, code: 'AT-DC-02', type: 'dc', power: 120, connector: 'GB/T', status: '0' },
        { pileId: 3, code: 'AT-DC-03', type: 'dc', power: 180, connector: 'GB/T', status: '1' },
        { pileId: 4, code: 'AT-DC-04', type: 'dc', power: 180, connector: 'CCS', status: '0' },
        { pileId: 5, code: 'AT-AC-01', type: 'ac', power: 7, connector: 'Type2', status: '0' },
        { pileId: 6, code: 'AT-AC-02', type: 'ac', power: 7, connector: 'Type2', status: '0' },
        { pileId: 7, code: 'AT-AC-03', type: 'ac', power: 7, connector: 'Type2', status: '0' },
        { pileId: 8, code: 'AT-AC-04', type: 'ac', power: 7, connector: 'Type2', status: '0' }
      ]
    }
  },
  computed: {
    statusText: function() {
      if (!this.station) return ''
      var map = { '1': '运营中', '2': '维护中', '3': '停用' }
      return map[this.station.status] || '未知'
    },
    faultPiles: function() {
      var count = 0
      for (var i = 0; i < this.piles.length; i++) {
        if (this.piles[i].status === '3') count++
      }
      return count
    },
    isBusinessOpen: function() {
      if (!this.station.openTime || !this.station.closeTime) return true
      var now = new Date()
      var curHM = now.getHours() * 100 + now.getMinutes()
      var openHM = this.timeToHM(this.station.openTime)
      var closeHM = this.timeToHM(this.station.closeTime)
      if (closeHM <= openHM) {
        return curHM >= openHM || curHM < closeHM
      }
      return curHM >= openHM && curHM < closeHM
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
    if (options && options.stationId) {
    }
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

    timeToHM: function(timeStr) {
      if (!timeStr) return 0
      var parts = timeStr.split(':')
      if (parts.length >= 2) {
        return parseInt(parts[0]) * 100 + parseInt(parts[1])
      }
      return 0
    },

    fmtTime: function(timeStr) {
      if (!timeStr) return '--:--'
      var parts = timeStr.split(':')
      if (parts.length >= 2) {
        return parts[0] + ':' + parts[1]
      }
      return timeStr
    },

    getPileStatusText: function(status) {
      var map = { '0': '空闲', '1': '充电中', '2': '离线', '3': '故障' }
      return map[status] || '未知'
    },

    callPhone: function(phone) {
      if (phone) {
        uni.makePhoneCall({ phoneNumber: phone })
      }
    },

    goBack: function() {
      uni.navigateBack({ delta: 1 })
    },

    goEdit: function() {
      uni.navigateTo({
        url: '/pages/mine/charge-pile/station-add?stationId=' + this.station.stationId
      })
    },

    goPileList: function() {
      uni.navigateTo({
        url: '/pages/mine/charge-pile/pile-list?stationId=' + this.station.stationId
      })
    },

    goPileDetail: function(pileId) {
      uni.navigateTo({
        url: '/pages/mine/charge-pile/pile-detail?pileId=' + pileId
      })
    },

    doDeleteStation: function() {
      var self = this
      uni.showModal({
        title: '确认删除',
        content: '确定要删除站点「' + this.station.name + '」吗？删除后该站点下所有充电桩数据也将被清除，不可恢复。',
        confirmColor: '#ef4444',
        success: function(res) {
          if (res.confirm) {
            uni.showToast({ title: '已删除', icon: 'success' })
            setTimeout(function() { uni.navigateBack({ delta: 1 }) }, 1200)
          }
        }
      })
    },

    goAddPile: function() {
      uni.navigateTo({ url: '/pages/mine/charge-pile/pile-add?stationId=' + this.station.stationId })
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
.page-ready .section-block:nth-of-type(4) { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.33s; }
.page-ready .section-block:nth-of-type(5) { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.40s; }
.page-ready .action-section { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; animation-delay: 0.47s; }

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

/* ========== 顶栏（琥珀渐变） ========== */
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
.header-right {
  z-index: 2;
}
.edit-text {
  font-size: 28rpx;
  color: #ffffff;
  font-weight: 600;
  padding: 10rpx 20rpx;
  border-radius: 16rpx;
  background: rgba(255, 255, 255, 0.2);
  transition: all 0.2s ease;
}
.header-right:active .edit-text {
  background: rgba(255, 255, 255, 0.35);
}

/* ========== Hero区域 ========== */
.hero-section {
  margin: 0 24rpx 20rpx;
  background: linear-gradient(135deg, #f59e0b 0%, #f97316 40%, #fb923c 70%, #fdba74 100%);
  border-radius: 28rpx;
  padding: 32rpx 28rpx 28rpx;
  position: relative;
  overflow: hidden;
  box-shadow:
    0 12rpx 40rpx rgba(245, 158, 11, 0.35),
    inset 0 1rpx 0 rgba(255, 255, 255, 0.25);
}
.hero-glow {
  position: absolute;
  top: -60rpx;
  right: -60rpx;
  width: 200rpx;
  height: 200rpx;
  border-radius: 50%;
  background: radial-gradient(circle, rgba(255, 255, 255, 0.18) 0%, transparent 70%);
  pointer-events: none;
}
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
  background: rgba(255, 255, 255, 0.25);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 18rpx;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.08);
}
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
.hero-code {
  font-size: 22rpx;
  color: rgba(255, 255, 255, 0.78);
  margin-top: 4rpx;
  font-family: monospace;
  letter-spacing: 0.5rpx;
}

/* 状态徽章 */
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
@keyframes badgePulse {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.5; transform: scale(0.85); }
}
.badge-1 { background: rgba(255, 255, 255, 0.22); color: #ffffff; border: 1rpx solid rgba(255, 255, 255, 0.35); }
.badge-2 { background: rgba(255, 255, 255, 0.18); color: #b45309; border: 1rpx solid rgba(180, 83, 9, 0.4); }
.badge-3 { background: rgba(255, 255, 255, 0.15); color: #dc2626; border: 1rpx solid rgba(220, 38, 38, 0.4); }

.hero-addr-row {
  display: flex;
  flex-direction: row;
  align-items: flex-start;
  margin-bottom: 10rpx;
  position: relative;
  z-index: 1;
}
.addr-icon { font-size: 26rpx; margin-right: 10rpx; flex-shrink: 0; margin-top: 2rpx; }
.addr-text {
  font-size: 25rpx;
  color: rgba(255, 255, 255, 0.92);
  line-height: 1.5;
  font-weight: 500;
}
.hero-coord-row {
  position: relative;
  z-index: 1;
}
.coord-text {
  font-size: 21rpx;
  color: rgba(255, 255, 255, 0.65);
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
.bar-line-purple { background: linear-gradient(180deg, #fb923c, #fbbf24); box-shadow: 0 0 12rpx rgba(251,146,60,0.35); }
.bar-line-orange2 { background: linear-gradient(180deg, #b45309, #d97706); box-shadow: 0 0 12rpx rgba(180,83,9,0.35); }

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
.iw-green { background: linear-gradient(135deg, rgba(217,119,6,0.15), rgba(245,158,11,0.08)); }
.iw-blue { background: linear-gradient(135deg, rgba(245,158,11,0.15), rgba(251,146,60,0.08)); }
.iw-purple { background: linear-gradient(135deg, rgba(251,146,60,0.15), rgba(251,191,36,0.08)); }
.iw-orange { background: linear-gradient(135deg, rgba(249, 115, 22, 0.15), rgba(234, 88, 12, 0.08)); }

.bar-icon { font-size: 26rpx; }
.bar-title {
  font-size: 30rpx;
  font-weight: 800;
  color: #1c1917;
  flex: 1;
  letter-spacing: 0.5rpx;
}
.pile-count-badge {
  min-width: 36rpx;
  height: 36rpx;
  line-height: 36rpx;
  text-align: center;
  background: linear-gradient(135deg, #f59e0b, #f97316);
  color: #fff;
  font-size: 20rpx;
  font-weight: 800;
  border-radius: 10rpx;
  padding: 0 10rpx;
  margin-left: 10rpx;
}
.pile-count-badge text { letter-spacing: 0.5rpx; }

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
.info-row-full { flex-direction: column; align-items: stretch; }
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
.addr-full {
  display: flex;
  flex-direction: row;
  align-items: flex-start;
  margin-top: 6rpx;
}
.addr-mark { font-size: 24rpx; flex-shrink: 0; margin-right: 8rpx; margin-top: 2rpx; }
.addr-val { text-align: left; line-height: 1.6; }
.coord-val { font-size: 23rpx; color: #78716c; font-weight: 500; }

/* ========== 运营数据统计 ========== */
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
  gap: 6rpx;
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
.si-total .si-icon-wrap { background: linear-gradient(135deg, rgba(245, 158, 11, 0.15), rgba(251, 146, 60, 0.08)); }
.si-avail .si-icon-wrap { background: linear-gradient(135deg, rgba(34, 197, 94, 0.15), rgba(22, 163, 74, 0.08)); }
.si-busy .si-icon-wrap { background: linear-gradient(135deg, rgba(249, 115, 22, 0.15), rgba(234, 88, 12, 0.08)); }
.si-fault .si-icon-wrap { background: linear-gradient(135deg, rgba(156, 163, 175, 0.15), rgba(107, 114, 128, 0.08)); }
.si-icon { font-size: 26rpx; font-weight: 900; }
.si-num {
  font-size: 36rpx;
  font-weight: 900;
  color: #1c1917;
  letter-spacing: 0.5rpx;
}
.si-num.num-green { color: #16a34a; }
.si-num.num-orange { color: #ea580c; }
.si-num.num-gray { color: #9ca3af; }
.si-label {
  font-size: 21rpx;
  color: #a8a29e;
  font-weight: 600;
}
.stat-divider {
  width: 1rpx;
  height: 52rpx;
  background: linear-gradient(180deg, transparent, #6b7280, transparent);
}

.ops-info {
  background: linear-gradient(135deg, rgba(250, 252, 250, 0.98), rgba(255, 255, 255, 1));
  border-radius: 16rpx;
  padding: 4rpx 22rpx;
  border: 1rpx solid rgba(34, 197, 94, 0.06);
}
.ops-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  padding: 14rpx 0;
  border-bottom: 1rpx solid rgba(34, 197, 94, 0.05);
}
.ops-row-last { border-bottom: none; }
.ops-label { font-size: 25rpx; color: #78716c; font-weight: 600; }
.ops-right {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 4rpx;
}
.biz-badge {
  font-size: 21rpx;
  font-weight: 800;
  padding: 4rpx 16rpx;
  border-radius: 10rpx;
}
.bb-open { color: #16a34a; background: linear-gradient(135deg, rgba(34, 197, 94, 0.12), rgba(22, 163, 74, 0.06)); }
.bb-close { color: #ea580c; background: linear-gradient(135deg, rgba(249, 115, 22, 0.12), rgba(234, 88, 12, 0.06)); }
.biz-badge text { white-space: nowrap; }
.ops-time { font-size: 22rpx; color: #a8a29e; font-weight: 500; }
.ops-value { font-size: 26rpx; color: #1c1917; font-weight: 600; }

/* ========== 联系方式 ========== */
.contact-card {
  background: linear-gradient(135deg, rgba(238, 242, 255, 0.98), rgba(255, 255, 255, 1));
  border-radius: 18rpx;
  padding: 6rpx 22rpx;
  border: 1rpx solid rgba(59, 130, 246, 0.08);
}
.contact-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  padding: 16rpx 0;
}
.contact-label { font-size: 25rpx; color: #78716c; font-weight: 600; }
.contact-phone-wrap {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 8rpx;
}
.contact-phone {
  font-size: 27rpx;
  color: #d97706;
  font-weight: 700;
  text-decoration: underline;
  text-decoration-color: rgba(217, 119, 6, 0.3);
}
.call-arrow { font-size: 28rpx; color: #f59e0b; font-weight: 700; }

/* ========== 配套设施 ========== */
.facility-card {
  background: linear-gradient(135deg, rgba(250, 245, 255, 0.98), rgba(255, 255, 255, 1));
  border-radius: 18rpx;
  padding: 18rpx 22rpx;
  border: 1rpx solid rgba(168, 85, 247, 0.08);
}
.facility-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 12rpx;
}
.facility-tag {
  font-size: 23rpx;
  padding: 8rpx 20rpx;
  background: linear-gradient(135deg, rgba(217, 119, 6, 0.1), rgba(245, 158, 11, 0.05));
  border-radius: 14rpx;
  color: #d97706;
  border: 1rpx solid rgba(217, 119, 6, 0.2);
  font-weight: 600;
}
.facility-empty { text-align: center; padding: 30rpx 0; }
.empty-txt { font-size: 24rpx; color: #a8a29e; }

/* ========== 充电桩列表 ========== */
.pile-list {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}
.pile-item {
  display: flex;
  flex-direction: row;
  align-items: center;
  padding: 20rpx 18rpx 20rpx 22rpx;
  border-radius: 18rpx;
  position: relative;
  overflow: hidden;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  background: linear-gradient(135deg, rgba(254, 251, 236, 0.98), rgba(255, 255, 255, 1));
  border: 1rpx solid rgba(0, 0, 0, 0.04);
  box-shadow: 0 4rpx 14rpx rgba(0, 0, 0, 0.03);
}
.pile-hover {
  transform: scale(0.97)!important;
  box-shadow: 0 10rpx 28rpx rgba(0, 0, 0, 0.09)!important;
}

.pi-left-bar {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 5rpx;
  border-radius: 18rpx 0 0 18rpx;
  transition: all 0.3s ease;
  z-index: 2;
}
.pi-0 .pi-left-bar { background: linear-gradient(180deg, #d97706, #f59e0b); box-shadow: 2rpx 0 12rpx rgba(217,119,6,0.2); }
.pi-1 .pi-left-bar { background: linear-gradient(180deg, #f59e0b, #fb923c); box-shadow: 2rpx 0 12rpx rgba(245,158,11,0.2); }
.pi-2 .pi-left-bar { background: linear-gradient(180deg, #fb923c, #fbbf24); box-shadow: 2rpx 0 12rpx rgba(251,146,60,0.2); }
.pi-3 .pi-left-bar { background: linear-gradient(180deg, #fbbf24, #fcd34d); box-shadow: 2rpx 0 12rpx rgba(251,191,36,0.2); }
.pile-hover .pi-left-bar { width: 7rpx; }

.pi-body {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 10rpx;
  position: relative;
  z-index: 1;
}
.pi-top {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 12rpx;
}
.pi-code {
  font-size: 27rpx;
  font-weight: 800;
  color: #1c1917;
  letter-spacing: 0.3rpx;
}
.type-tag {
  font-size: 20rpx;
  font-weight: 700;
  padding: 4rpx 14rpx;
  border-radius: 8rpx;
}
.tag-dc { color: #d97706; background: linear-gradient(135deg, rgba(217,119,6,0.12), rgba(245,158,11,0.06)); }
.tag-ac { color: #f59e0b; background: linear-gradient(135deg, rgba(245,158,11,0.12), rgba(251,146,60,0.06)); }
.type-tag text { white-space: nowrap; }

.pi-bottom {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
}
.pi-power {
  display: flex;
  align-items: center;
  gap: 6rpx;
}
.power-icon { font-size: 22rpx; }
.power-num { font-size: 25rpx; font-weight: 800; color: #d97706; }
.connector-text {
  font-size: 20rpx;
  color: #a8a29e;
  font-weight: 600;
  margin-left: 4rpx;
  padding: 2rpx 10rpx;
  background: rgba(0, 0, 0, 0.03);
  border-radius: 6rpx;
}

.pile-status-tag {
  font-size: 20rpx;
  font-weight: 700;
  padding: 4rpx 14rpx;
  border-radius: 8rpx;
}
.pst-0 { color: #d97706; background: linear-gradient(135deg, rgba(217,119,6,0.12), rgba(245,158,11,0.06)); border: 1rpx solid rgba(217,119,6,0.2); }
.pst-1 { color: #ef4444; background: linear-gradient(135deg, rgba(239, 68, 68, 0.12), rgba(248, 113, 113, 0.06)); border: 1rpx solid rgba(239, 68, 68, 0.2); }
.pst-2 { color: #6b7280; background: linear-gradient(135deg, rgba(107, 114, 128, 0.12), rgba(156, 163, 175, 0.06)); border: 1rpx solid rgba(107, 114, 128, 0.2); }
.pst-3 { color: #9ca3af; background: linear-gradient(135deg, rgba(156, 163, 175, 0.12), rgba(209, 213, 219, 0.06)); border: 1rpx solid rgba(156, 163, 175, 0.2); }
.pile-status-tag text { white-space: nowrap; }

.pi-arrow {
  width: 36rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  z-index: 1;
}
.pi-arrow text { font-size: 28rpx; color: #cccccc; font-weight: 600; }

/* 桩空状态 */
.pile-empty-box {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 60rpx 0 44rpx;
}
.pe-icon-wrap {
  width: 110rpx;
  height: 110rpx;
  border-radius: 50%;
  background: linear-gradient(135deg, rgba(249, 115, 22, 0.1), rgba(251, 146, 60, 0.05));
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 18rpx;
}
.pe-icon { font-size: 46rpx; }
.pe-main { font-size: 27rpx; color: #1c1917; font-weight: 700; margin-bottom: 8rpx; }
.pe-sub { font-size: 23rpx; color: #a8a29e; }

/* ========== 快捷操作区 ========== */
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
.act-edit {
  background: linear-gradient(135deg, #f59e0b, #f97316, #fb923c);
}
.act-edit .act-color-bar { background: linear-gradient(180deg, #ffffff 0%, rgba(255,255,255,0.3) 100%); }
.act-edit .act-icon, .act-edit .act-name { color: #ffffff; }
.act-edit .act-desc { color: rgba(255, 255, 255, 0.8); }

.act-pile {
  background: linear-gradient(135deg, #d97706, #f59e0b, #fb923c);
}
.act-pile .act-color-bar { background: linear-gradient(180deg, #ffffff 0%, rgba(255,255,255,0.3) 100%); }
.act-pile .act-icon, .act-pile .act-name { color: #ffffff; }
.act-pile .act-desc { color: rgba(255, 255, 255, 0.8); }

/* 删除站点（橙色系） */
.act-del {
  background: linear-gradient(135deg, #f59e0b, #fb923c, #fbbf24);
}
.act-del .act-color-bar { background: linear-gradient(180deg, #ffffff 0%, rgba(255,255,255,0.3) 100%); }
.act-del .act-icon, .act-del .act-name { color: #ffffff; }
.act-del .act-desc { color: rgba(255, 255, 255, 0.8); }

/* 新增充电桩（深琥珀系） */
.act-add-pile {
  background: linear-gradient(135deg, #d97706, #f59e0b, #fb923c);
}
.act-add-pile .act-color-bar { background: linear-gradient(180deg, #ffffff 0%, rgba(255,255,255,0.3) 100%); }
.act-add-pile .act-icon, .act-add-pile .act-name { color: #ffffff; }
.act-add-pile .act-desc { color: rgba(255, 255, 255, 0.8); }

.act-hover .act-color-bar { width: 7rpx; }

.act-icon { font-size: 36rpx; margin-bottom: 10rpx; }
.act-name { font-size: 26rpx; font-weight: 800; margin-bottom: 6rpx; }
.act-desc { font-size: 20rpx; font-weight: 500; }
</style>
