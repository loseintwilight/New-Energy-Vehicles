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
    <!-- 全屏加载提示 -->
    <view class="loading-mask" v-if="isLoading">
      <view class="loading-box">
        <view class="loading-spinner"></view>
        <text class="loading-text">数据加载中...</text>
      </view>
    </view>

    <scroll-view scroll-y class="main-scroll" :show-scrollbar="false">
      <!-- 顶栏 -->
      <view class="header">
        <view class="header-bg"></view>
        <view class="header-circle"></view>
        <view class="header-info">
          <text class="header-title">充电桩工作台</text>
          <text class="header-date">{{ todayDate }}</text>
        </view>
        <view class="header-right" @tap="showMoreModal = true">
          <view class="more-badge">
            <text class="more-icon">☰</text>
          </view>
        </view>
      </view>

      <!-- 用户信息（在充电桩工作台标题下方） -->
      <view class="user-info-row">
        <image v-if="userAvatar" :src="userAvatar" class="user-avatar" mode="aspectFill" @click="goToAvatar"></image>
        <view v-else class="user-avatar user-avatar-placeholder" @click="goToAvatar">
          <uni-icons type="person" size="22" color="#d97706"></uni-icons>
        </view>
        <view class="user-meta" @click="goToInfo">
          <text class="user-name">{{ userName }}</text>
        </view>
        <view class="switch-btn" @click="handleSwitchUser">切换用户端</view>
      </view>

      <!-- 4栏统计卡 -->
      <view class="stats-section">
        <view class="stats-row">
          <view
            class="stat-card"
            v-for="(item, idx) in statsData"
            :key="idx"
            :class="'stat-' + idx"
            hover-class="stat-hover"
            @tap="onStatTap(idx)"
          >
            <view class="stat-glow-bar"></view>
            <view class="stat-icon-wrap">
              <text class="stat-icon-text">{{ item.icon }}</text>
            </view>
            <text class="stat-value">{{ item.value }}</text>
            <text class="stat-label">{{ item.label }}</text>
          </view>
        </view>
      </view>

      <!-- 快捷管理 - 4大功能卡 + 更多 -->
      <view class="section-block">
        <view class="title-bar">
          <view class="bar-line"></view>
          <text class="bar-title">快捷管理</text>
          <view class="title-badge">4</view>
        </view>
        <view class="quick-list">
          <!-- 4个主要功能大卡片 -->
          <view
            class="quick-row"
            v-for="(row, ri) in quickMainRows"
            :key="ri"
          >
            <view
              class="quick-main-card"
              v-for="(item, ci) in row"
              :key="ci"
              :class="'qmc-' + item.colorIdx"
              hover-class="qmc-hover"
              @tap="goPage(item.url)"
            >
              <view class="qmc-left">
                <view class="qmc-icon-wrap">
                  <text class="qmc-icon">{{ item.icon }}</text>
                </view>
              </view>
              <view class="qmc-body">
                <text class="qmc-name">{{ item.name }}</text>
                <text class="qmc-desc">{{ item.desc }}</text>
              </view>
              <view class="qmc-arrow">
                <text class="qmc-arrow-icon">›</text>
              </view>
            </view>
          </view>
          <!-- 更多管理入口卡 -->
          <view
            class="quick-more-card"
            hover-class="qmc-hover"
            @tap="showMoreModal = true"
          >
            <view class="qmc-left qmc-more-left">
              <view class="qmc-icon-wrap qmc-more-icon-wrap">
                <text class="qmc-icon qmc-plus">+</text>
              </view>
            </view>
            <view class="qmc-body">
              <text class="qmc-name qmc-more-name">更多管理</text>
              <text class="qmc-desc qmc-more-desc">{{ moreMenuList.length }}项功能 · 结算中心 · 商户资料 · 系统设置</text>
            </view>
            <view class="qmc-arrow">
              <text class="qmc-arrow-icon">›</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 站点运行状态 -->
      <view class="section-block">
        <view class="title-bar">
          <view class="bar-line bar-line-green"></view>
          <text class="bar-title">站点运行状态</text>
          <view class="bar-more" @tap="goStationList">
            <text class="bar-more-text">查看全部</text>
            <text class="bar-more-icon">›</text>
          </view>
        </view>
        <view class="station-list">
          <view
            class="station-card"
            v-for="(st, idx) in stationList.slice(0, 3)"
            :key="idx"
            :class="'st-' + (idx % 4)"
            hover-class="station-hover"
            @tap="goStationDetail(st.stationId)"
          >
            <view class="st-left-bar"></view>
            <view class="st-body">
              <view class="st-header">
                <text class="st-name">{{ st.stationName }}</text>
                <view :class="['status-tag', 'tag-' + st.stationStatus]">
                  <view class="status-dot"></view>
                  <text>{{ getStatusText(st.stationStatus) }}</text>
                </view>
              </view>
              <view class="st-stats">
                <view class="st-stat-item">
                  <text class="st-stat-val">¥{{ fmtMoney(st.todayIncome) }}</text>
                  <text class="st-stat-lbl">今日营收</text>
                </view>
                <view class="st-stat-divider"></view>
                <view class="st-stat-item">
                  <text class="st-stat-val">{{ st.todayOrders || 0 }}单</text>
                  <text class="st-stat-lbl">今日订单</text>
                </view>
                <view class="st-stat-divider"></view>
                <view class="st-stat-item">
                  <text class="st-stat-val">{{ fmtEnergy(st.todayEnergy) }}kWh</text>
                  <text class="st-stat-lbl">充电量</text>
                </view>
              </view>
              <view class="st-pile-row">
                <view class="pile-progress-wrap">
                  <view class="pile-progress-bg">
                    <view class="pile-progress-fill" :style="{ width: getPilePercent(st.availablePiles, st.totalPiles) + '%' }"></view>
                  </view>
                </view>
                <view class="pile-text">
                  <text class="pile-available">{{ st.availablePiles || 0 }}空闲</text>
                  <text class="pile-slash">/</text>
                  <text class="pile-total">{{ st.totalPiles || 0 }}总桩</text>
                </view>
              </view>
            </view>
          </view>
          <!-- 站点空状态 -->
          <view class="empty-tip" v-if="dataLoaded && stationList.length === 0">
            <text class="empty-icon">📡</text>
            <text class="empty-text">暂无站点数据，请先在"站点管理"中添加站点</text>
          </view>
        </view>
      </view>

      <!-- 最近订单 -->
      <view class="section-block">
        <view class="title-bar">
          <view class="bar-line bar-line-orange"></view>
          <text class="bar-title">最近订单</text>
          <view class="bar-more" @tap="goOrderList">
            <text class="bar-more-text">更多</text>
            <text class="bar-more-icon">›</text>
          </view>
        </view>
        <view class="order-list">
          <view
            class="order-card"
            v-for="(od, idx) in recentOrders.slice(0, 3)"
            :key="idx"
            hover-class="order-hover"
            @tap="goOrderDetail(od.orderId)"
          >
            <view class="order-left-bar"></view>
            <view class="order-body">
              <view class="order-top">
                <view class="order-no">
                  <text class="order-no-icon">#</text>
                  <text class="order-no-text">{{ shortNo(od.orderNo) }}</text>
                </view>
                <view :class="['order-status', 'os-' + od.orderStatus]">
                  <view class="os-pulse" v-if="od.orderStatus === '0'"></view>
                  <text>{{ getOrderStatus(od.orderStatus) }}</text>
                </view>
              </view>
              <view class="order-mid">
                <text class="order-pile">🔌 {{ od.pileCode }}</text>
                <text class="order-time">🕐 {{ fmtTime(od.startTime) }}</text>
                <text class="order-energy">⚡ {{ od.energy || 0 }}kWh</text>
              </view>
              <view class="order-bottom">
                <text class="amount-lbl">应收金额</text>
                <text class="amount-val">¥{{ fmtAmount(od.amount) }}</text>
              </view>
            </view>
          </view>
          <!-- 订单空状态 -->
          <view class="empty-tip" v-if="dataLoaded && recentOrders.length === 0">
            <text class="empty-icon">📋</text>
            <text class="empty-text">暂无订单数据</text>
          </view>
        </view>
      </view>

      <!-- 最新评价 -->
      <view class="section-block" v-if="recentReviews.length > 0">
        <view class="title-bar">
          <view class="bar-line bar-line-blue"></view>
          <text class="bar-title">最新评价</text>
        </view>
        <view class="review-list">
          <view class="review-card" v-for="(rv, idx) in recentReviews" :key="idx">
            <view class="review-avatar">
              <text class="avatar-text">{{ rv.avatar }}</text>
            </view>
            <view class="review-body">
              <view class="review-top">
                <text class="review-name">{{ rv.name }}</text>
                <view class="review-stars">
                  <text class="star" v-for="s in 5" :key="s" :class="{ active: s <= rv.stars }">★</text>
                </view>
              </view>
              <text class="review-text">{{ rv.text }}</text>
              <text class="review-time">{{ rv.time }}</text>
            </view>
          </view>
        </view>
      </view>

      <view style="height: 100rpx;"></view>
    </scroll-view>

    <!-- 更多管理弹窗 -->
    <view class="modal-mask" v-if="showMoreModal" @tap="showMoreModal = false"></view>
    <view :class="['modal-panel', showMoreModal ? 'modal-show' : '']">
      <view class="modal-handle"></view>
      <view class="modal-header">
        <text class="modal-title">更多管理</text>
        <view class="modal-close" @tap="showMoreModal = false">
          <text>✕</text>
        </view>
      </view>
      <scroll-view scroll-y class="modal-scroll">
        <view class="menu-list">
          <view
            class="menu-item"
            v-for="(item, idx) in moreMenuList"
            :key="idx"
            :class="'menu-' + (idx % 5)"
            hover-class="menu-hover"
            @tap="onMenuTap(item)"
          >
            <view class="menu-color-bar"></view>
            <view class="menu-icon-wrap">
              <text class="menu-icon" :class="'mi-' + (idx % 5)">{{ item.icon }}</text>
            </view>
            <view class="menu-info">
              <text class="menu-name">{{ item.name }}</text>
              <text class="menu-desc">{{ item.desc }}</text>
            </view>
            <text class="menu-arrow">›</text>
          </view>
        </view>
      </scroll-view>
    </view>
  </view>
</template>

<script>
import { getMerchantStationList } from '@/api/charger/station'
import { getOrderList } from '@/api/charger/order'

export default {
  data: function() {
    return {
      userName: this.$store.state.user.name || '充电桩管理员',
      userPhone: this.$store.state.user.phonenumber || '',
      userAvatar: this.$store.state.user.avatar || '',
      isReady: false,
      isLoading: true,
      dataLoaded: false,
      todayDate: '',
      glowRows: [],
      showMoreModal: false,
      /* 4栏统计卡数据（与下方stationList汇总值保持一致） */
      statsData: [
        { icon: '¥', value: '0.00', label: '今日营收(元)' },
        { icon: '⚡', value: '0', label: '今日电量(kWh)' },
        { icon: '📋', value: '0', label: '今日订单(笔)' },
        { icon: '◎', value: '0/0', label: '空闲/总桩' }
      ],
      /* 4大功能卡片（2×2布局） */
      quickMain: [
        { icon: '◎', name: '站点管理', desc: '5个站点 · 运营监控', colorIdx: 0, url: '/pages/mine/charge-pile/station-list' },
        { icon: '📊', name: '数据概览', desc: '本月报告 · 趋势分析', colorIdx: 1, url: '/pages/mine/charge-pile/data-overview' },
        { icon: '📋', name: '订单中心', desc: '150笔订单 · 实时跟踪', colorIdx: 2, url: '/pages/mine/charge-pile/order-list' },
        { icon: '🔧', name: '结算中心', desc: '收益结算与提现', colorIdx: 3, url: '/pages/mine/charge-pile/settlement-center' }
      ],
      /* 站点运行状态 */
      stationList: [],
      /* 最近订单 */
      recentOrders: [],
      /* 最新评价 */
      recentReviews: [],
      /* 更多管理菜单（弹窗内展示） */
      moreMenuList: [
        { icon: '🔌', name: '充电桩管理', desc: '查看管理充电桩设备', path: '/pages/mine/charge-pile/pile-list' },
        { icon: '💰', name: '费率管理', desc: '设置充电费率方案', path: '/pages/mine/charge-pile/rate-list' },
        { icon: '💳', name: '结算中心', desc: '收益结算与提现', path: '/pages/mine/charge-pile/settlement-center' },
        { icon: '👥', name: '客户管理', desc: '用户列表 · 反馈处理', path: '/pages/mine/charge-pile/customer-manage' },
        { icon: '◆', name: '商户资料', desc: '企业信息 · 资质认证', path: '/pages/mine/charge-pile/merchant-info' },
        { icon: '○', name: '系统设置', desc: '通知 · 安全 · 关于', path: '/pages/mine/charge-pile/system-settings' }
      ]
    }
  },
  created: function() {
    this.buildGlowRows()
    this.initDate()
    this.loadDashboardData()
    var that = this
    setTimeout(function() {
      that.isReady = true
    }, 200)
  },
  onShow: function() {
    this.userName = this.$store.state.user.name || '充电桩管理员'
    this.userPhone = this.$store.state.user.phonenumber || ''
    this.userAvatar = this.$store.state.user.avatar || ''
  },
  computed: {
    /* 将4大功能拆成2行×2列 */
    quickMainRows: function() {
      var list = this.quickMain || []
      return [
        [list[0], list[1]],
        [list[2], list[3]]
      ]
    }
  },
  methods: {
    /* ---------- 页面跳转 ---------- */
    goPage: function(url) {
      if (!url) return
      uni.navigateTo({ url: url })
    },
    /* ---------- 初始化 ---------- */
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

    initDate: function() {
      var d = new Date()
      var y = d.getFullYear()
      var m = d.getMonth() + 1
      var day = d.getDate()
      var weeks = ['周日', '周一', '周二', '周三', '周四', '周五', '周六']
      this.todayDate = y + '.' + m + '.' + day + ' ' + weeks[d.getDay()]
    },

    /* ---------- 数据加载 ---------- */
    loadDashboardData: function() {
      this.isLoading = true
      this.loadStations()
      this.loadOrders()
    },

    loadStations: function() {
      var self = this
      getMerchantStationList().then(function(res) {
        self.isLoading = false
        if (res.code === 200) {
          var list = res.data.rows || []
          self.stationList = list
          /* 更新顶部统计数据 */
          self.updateStatsData(list, self.recentOrders)
          self.dataLoaded = true
        }
      }).catch(function() {
        self.isLoading = false
        self.dataLoaded = true
        uni.showToast({ title: '加载站点数据失败', icon: 'none' })
      })
    },

    loadOrders: function() {
      var self = this
      getOrderList({ pageSize: 20 }).then(function(res) {
        if (res.code === 200) {
          var list = res.data.rows || []
          // 映射字段名以匹配模板（orderStatus / pileCode）
          self.recentOrders = list.map(function(item) {
            return {
              orderId: item.orderId,
              orderNo: item.orderNo,
              orderStatus: item.status,
              pileCode: item.pileNo,
              startTime: item.startTime,
              energy: item.energy,
              amount: item.amount
            }
          })
          /* 更新顶部统计数据 */
          self.updateStatsData(self.stationList, self.recentOrders)
        }
      }).catch(function() {
        // 订单列表为空不报错（商户可能没有个人充电订单）
      })
    },

    updateStatsData: function(stations, orders) {
      var totalIncome = 0
      var totalEnergy = 0
      var totalOrders = 0
      var totalPiles = 0
      var availablePiles = 0

      for (var i = 0; i < stations.length; i++) {
        totalIncome += (stations[i].todayIncome || 0)
        totalEnergy += (stations[i].todayEnergy || 0)
        totalOrders += (stations[i].todayOrders || 0)
        totalPiles += (stations[i].totalPiles || 0)
        availablePiles += (stations[i].availablePiles || 0)
      }

      this.statsData = [
        { icon: '¥', value: totalIncome.toFixed(2), label: '今日营收(元)' },
        { icon: '⚡', value: totalEnergy.toFixed(1), label: '今日电量(kWh)' },
        { icon: '📋', value: totalOrders.toString(), label: '今日订单(笔)' },
        { icon: '◎', value: availablePiles + '/' + totalPiles, label: '空闲/总桩' }
      ]
    },

    /* ---------- 工具方法 ---------- */
    getPilePercent: function(avail, total) {
      if (!total || total === 0) return 0
      return Math.round((avail / total) * 100)
    },

    getStatusText: function(status) {
      var map = { '1': '运营中', '2': '维护中', '3': '已停用' }
      return map[status] || '未知'
    },

    getOrderStatus: function(status) {
      var map = { '0': '充电中', '1': '已完成', '2': '已取消' }
      return map[status] || '未知'
    },

    shortNo: function(no) {
      if (!no) return ''
      return no.length > 14 ? no.substring(0, 11) + '...' : no
    },

    fmtTime: function(timeStr) {
      if (!timeStr) return ''
      var d = new Date(timeStr.replace(/-/g, '/'))
      if (isNaN(d.getTime())) return timeStr
      var m = d.getMonth() + 1
      var day = d.getDate()
      var h = d.getHours()
      var min = d.getMinutes()
      return (m < 10 ? '0' + m : m) + '-' + (day < 10 ? '0' + day : day) + ' ' + (h < 10 ? '0' + h : h) + ':' + (min < 10 ? '0' + min : min)
    },

    fmtAmount: function(amount) {
      if (amount === null || amount === undefined) return '0.00'
      return Number(amount).toFixed(2)
    },

    fmtMoney: function(val) {
      if (val === null || val === undefined) return '0.00'
      return Number(val).toFixed(2)
    },

    fmtEnergy: function(val) {
      if (val === null || val === undefined) return '0.0'
      return Number(val).toFixed(1)
    },

    /* ---------- 页面跳转 ---------- */
    goBack: function() {
      uni.navigateBack({ delta: 1 })
    },

    onStatTap: function(idx) {
      var urls = ['/pages/mine/charge-pile/pile-list', '/pages/mine/charge-pile/order-list', '/pages/mine/charge-pile/data-overview', '/pages/mine/charge-pile/station-list']
      if (urls[idx]) {
        uni.navigateTo({ url: urls[idx] })
      }
    },

    goStationList: function() {
      uni.navigateTo({ url: '/pages/mine/charge-pile/station-list' })
    },

    goStationDetail: function(stationId) {
      uni.navigateTo({ url: '/pages/mine/charge-pile/station-detail?stationId=' + stationId })
    },

    goOrderList: function() {
      uni.navigateTo({ url: '/pages/mine/charge-pile/order-list' })
    },

    goOrderDetail: function(orderId) {
      uni.navigateTo({ url: '/pages/mine/charge-pile/order-detail?orderId=' + orderId })
    },

    onMenuTap: function(item) {
      this.showMoreModal = false
      if (!item.path) {
        this.$store.commit('SET_CURRENT_END', 'user')
        this.$tab.switchTab('/pages/mine/index')
        return
      }
      uni.navigateTo({ url: item.path })
    },

    goToAvatar: function() {
      uni.navigateTo({ url: '/pages/mine/avatar/index' })
    },

    goToInfo: function() {
      uni.navigateTo({ url: '/pages/mine/info/index' })
    },

    handleSwitchUser: function() {
      this.$tab.switchTab('/pages/mine/index')
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
.page-ready .stat-card { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; }
.page-ready .quick-main-card { animation: fadeSlideUp 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; }
.page-ready .quick-more-card { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; }
.page-ready .station-card { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; }
.page-ready .order-card { animation: fadeSlideUp 0.6s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; }
.page-ready .review-card { animation: fadeSlideUp 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; }

.page-ready .stat-card:nth-child(1) { animation-delay: 0.05s; }
.page-ready .stat-card:nth-child(2) { animation-delay: 0.1s; }
.page-ready .stat-card:nth-child(3) { animation-delay: 0.15s; }
.page-ready .stat-card:nth-child(4) { animation-delay: 0.2s; }
.page-ready .quick-main-card:nth-child(1) { animation-delay: 0.25s; }
.page-ready .quick-main-card:nth-child(2) { animation-delay: 0.30s; }
.page-ready .quick-main-card:nth-child(3) { animation-delay: 0.35s; }
.page-ready .quick-main-card:nth-child(4) { animation-delay: 0.40s; }
.page-ready .station-card:nth-child(1) { animation-delay: 0.54s; }
.page-ready .station-card:nth-child(2) { animation-delay: 0.60s; }
.page-ready .station-card:nth-child(3) { animation-delay: 0.66s; }
.page-ready .order-card:nth-child(1) { animation-delay: 0.72s; }
.page-ready .order-card:nth-child(2) { animation-delay: 0.78s; }
.page-ready .order-card:nth-child(3) { animation-delay: 0.84s; }
.page-ready .review-card:nth-child(1) { animation-delay: 0.88s; }
.page-ready .review-card:nth-child(2) { animation-delay: 0.94s; }
.page-ready .review-card:nth-child(3) { animation-delay: 1.0s; }

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

/* ========== 用户信息行（暖色风格） ========== */
.user-info-row {
  position: relative;
  z-index: 3;
  padding: 28rpx 28rpx 8rpx;
  display: flex;
  align-items: center;
  gap: 16rpx;
}
.user-avatar {
  width: 80rpx;
  height: 80rpx;
  border-radius: 50%;
  border: 3rpx solid rgba(251, 146, 60, 0.4);
}
.user-avatar-placeholder {
  background: linear-gradient(135deg, #fde68a, #fbbf24);
  display: flex;
  align-items: center;
  justify-content: center;
}
.user-meta {
  display: flex;
  flex-direction: column;
  gap: 4rpx;
}
.user-name {
  font-size: 30rpx;
  font-weight: 700;
  color: #431407;
}
.user-phone {
  font-size: 22rpx;
  color: #92400e;
}
.user-info-row .switch-btn {
  margin-left: auto;
  font-size: 22rpx;
  color: #ffffff;
  background: linear-gradient(135deg, #f59e0b, #d97706);
  padding: 8rpx 20rpx;
  border-radius: 10rpx;
  font-weight: 600;
  white-space: nowrap;
  box-shadow: 0 4rpx 12rpx rgba(217, 119, 6, 0.35);
  flex-shrink: 0;
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
.header-date {
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.88);
  margin-top: 6rpx;
  font-weight: 500;
}
.header-right {
  z-index: 2;
}
.more-badge {
  width: 64rpx;
  height: 64rpx;
  border-radius: 18rpx;
  background: rgba(255, 255, 255, 0.28);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4rpx 14rpx rgba(0, 0, 0, 0.08);
}
.more-icon {
  font-size: 32rpx;
  color: #ffffff;
  font-weight: 700;
}

/* ========== 4栏统计卡 ========== */
.stats-section {
  padding: 24rpx 24rpx 16rpx;
  position: relative;
  z-index: 2;
}
.stats-row {
  display: flex;
  flex-direction: row;
  gap: 14rpx;
}
.stat-card {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 22rpx 8rpx 18rpx;
  border-radius: 22rpx;
  position: relative;
  overflow: hidden;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  box-shadow: 0 6rpx 24rpx rgba(0, 0, 0, 0.07), inset 0 1rpx 0 rgba(255, 255, 255, 0.3);
}
.stat-hover {
  transform: scale(0.95) translateY(-4rpx);
  box-shadow: 0 14rpx 36rpx rgba(0, 0, 0, 0.13);
}
.stat-glow-bar {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 5rpx;
  box-shadow: 0 0 16rpx currentColor;
  opacity: 0.65;
}
/* 统计卡渐变色 - 统一琥珀橙色系 */
.stat-0 { background: linear-gradient(145deg, #d97706 0%, #f59e0b 50%, #fb923c 100%); }
.stat-1 { background: linear-gradient(145deg, #f59e0b 0%, #fb923c 50%, #fbbf24 100%); }
.stat-2 { background: linear-gradient(145deg, #d97706 0%, #f59e0b 50%, #fb923c 100%); }
.stat-3 { background: linear-gradient(145deg, #f59e0b 0%, #fb923c 50%, #fbbf24 100%); }
/* 发光条颜色 */
.stat-0 .stat-glow-bar { background: linear-gradient(180deg, #fff 0%, rgba(255,255,255,0.3) 100%); color: #d97706; }
.stat-1 .stat-glow-bar { background: linear-gradient(180deg, #fff 0%, rgba(255,255,255,0.3) 100%); color: #f59e0b; }
.stat-2 .stat-glow-bar { background: linear-gradient(180deg, #fff 0%, rgba(255,255,255,0.3) 100%); color: #fbbf24; }
.stat-3 .stat-glow-bar { background: linear-gradient(180deg, #fff 0%, rgba(255,255,255,0.3) 100%); color: #d97706; }

.stat-icon-wrap {
  width: 64rpx;
  height: 64rpx;
  border-radius: 18rpx;
  background: rgba(255, 255, 255, 0.28);
  margin-bottom: 10rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.1);
}
.stat-icon-text {
  font-size: 34rpx;
  font-weight: 900;
  color: #ffffff;
}
.stat-value {
  font-size: 30rpx;
  font-weight: 900;
  color: #ffffff;
  letter-spacing: 0.5rpx;
  text-shadow: 0 2rpx 6rpx rgba(0, 0, 0, 0.1);
}
.stat-label {
  font-size: 20rpx;
  color: rgba(255, 255, 255, 0.88);
  font-weight: 600;
  margin-top: 4rpx;
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
}
.title-bar {
  display: flex;
  flex-direction: row;
  align-items: center;
  margin-bottom: 20rpx;
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
.bar-line-orange { background: linear-gradient(180deg, #fb923c, #f97316); box-shadow: 0 0 12rpx rgba(251,146,60,0.35); }
.bar-line-blue { background: linear-gradient(180deg, #fbbf24, #fb923c); box-shadow: 0 0 12rpx rgba(251,191,36,0.35); }
.bar-title {
  font-size: 30rpx;
  font-weight: 800;
  color: #1c1917;
  flex: 1;
  letter-spacing: 0.5rpx;
}
.title-badge {
  min-width: 34rpx;
  height: 34rpx;
  line-height: 34rpx;
  text-align: center;
  background: linear-gradient(135deg, #f59e0b, #f97316);
  color: #fff;
  font-size: 20rpx;
  font-weight: 800;
  border-radius: 10rpx;
  padding: 0 8rpx;
  margin-left: 10rpx;
}
.bar-more {
  display: flex;
  align-items: center;
  padding: 6rpx 12rpx;
  border-radius: 12rpx;
}
.bar-more-text {
  font-size: 24rpx;
  color: #d97706;
  font-weight: 600;
}
.bar-more-icon {
  font-size: 26rpx;
  color: #d97706;
  font-weight: 700;
  margin-left: 2rpx;
}

/* ========== 快捷管理 - 4大卡片 + 更多 ========== */
.quick-list {
  display: flex;
  flex-direction: column;
  gap: 14rpx;
}
.quick-row {
  display: flex;
  gap: 14rpx;
}

/* 大功能卡 */
.quick-main-card {
  flex: 1;
  display: flex;
  align-items: center;
  background: rgba(255, 255, 255, 0.88);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border-radius: 20rpx;
  padding: 24rpx 20rpx;
  position: relative;
  overflow: hidden;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.05);
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  border-left: 5rpx solid transparent;
}
.qmc-hover {
  transform: scale(0.97) translateY(-2rpx);
  box-shadow: 0 10rpx 30rpx rgba(0, 0, 0, 0.1);
}
/* 统一琥珀橙色系（深→中→浅→淡，不再花花绿绿） */
.qmc-0 { border-left-color: #d97706; }
.qmc-1 { border-left-color: #f59e0b; }
.qmc-2 { border-left-color: #fb923c; }
.qmc-3 { border-left-color: #fbbf24; }

.qmc-hover.qmc-0 { border-left-color: #b45309; box-shadow: 0 10rpx 30rpx rgba(217,119,6,0.25); }
.qmc-hover.qmc-1 { border-left-color: #d97706; box-shadow: 0 10rpx 30rpx rgba(245,158,11,0.25); }
.qmc-hover.qmc-2 { border-left-color: #f59e0b; box-shadow: 0 10rpx 30rpx rgba(251,146,60,0.25); }
.qmc-hover.qmc-3 { border-left-color: #f97316; box-shadow: 0 10rpx 30rpx rgba(251,191,36,0.25); }

.qmc-left {
  margin-right: 18rpx;
  flex-shrink: 0;
}
.qmc-icon-wrap {
  width: 72rpx;
  height: 72rpx;
  border-radius: 18rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}
.qmc-0 .qmc-icon-wrap { background: linear-gradient(135deg, #fef3c7, #fde68a); }
.qmc-1 .qmc-icon-wrap { background: linear-gradient(135deg, #ffedd5, #fed7aa); }
.qmc-2 .qmc-icon-wrap { background: linear-gradient(135deg, #fffbeb, #fef9c3); }
.qmc-3 .qmc-icon-wrap { background: linear-gradient(135deg, #fffffe, #fefce8); }

.qmc-icon {
  font-size: 36rpx;
  line-height: 1;
}
.qmc-body {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-width: 0;
}
.qmc-name {
  font-size: 28rpx;
  font-weight: 700;
  color: #1c1917;
  line-height: 1.3;
}
.qmc-desc {
  font-size: 21rpx;
  color: #a8a29e;
  margin-top: 4rpx;
  line-height: 1.3;
}
.qmc-arrow {
  margin-left: 12rpx;
  flex-shrink: 0;
  display: flex;
  align-items: center;
}
.qmc-arrow-icon {
  font-size: 32rpx;
  color: #d6d3d1;
  font-weight: 300;
}

/* 更多管理入口卡 */
.quick-more-card {
  display: flex;
  align-items: center;
  background: linear-gradient(135deg, rgba(255,255,255,0.92), rgba(250,250,250,0.95));
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border-radius: 20rpx;
  padding: 24rpx 20rpx;
  position: relative;
  overflow: hidden;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.04);
  transition: all 0.3s ease;
  border: 1.5rpx dashed #d6d3d1;
  border-left: 5rpx solid #f59e0b;
}
.qmc-more-left .qmc-icon-wrap {
  width: 64rpx;
  height: 64rpx;
  border-radius: 50%;
  background: linear-gradient(135deg, #fef3c7, #fde68a);
}
.qmc-plus {
  font-size: 32rpx;
  color: #d97706;
  font-weight: 700;
}
.qmc-more-name {
  color: #6b7280;
}
.qmc-more-desc {
  color: #b0abaa;
}

/* ========== 站点运行状态 ========== */
.station-list {
  display: flex;
  flex-direction: column;
  gap: 14rpx;
}
.station-card {
  border-radius: 20rpx;
  overflow: hidden;
  position: relative;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.95), rgba(255, 255, 255, 1));
  border: 1rpx solid rgba(0, 0, 0, 0.04);
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.04);
  transition: all 0.3s ease;
}
.station-hover {
  transform: scale(0.98) translateY(-2rpx);
  box-shadow: 0 10rpx 30rpx rgba(0, 0, 0, 0.09);
}
.st-left-bar {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 5rpx;
  border-radius: 20rpx 0 0 20rpx;
  transition: all 0.3s ease;
}
.st-0 .st-left-bar { background: linear-gradient(180deg, #d97706, #f59e0b); }
.st-1 .st-left-bar { background: linear-gradient(180deg, #f59e0b, #fb923c); }
.st-2 .st-left-bar { background: linear-gradient(180deg, #fb923c, #fbbf24); }
.st-3 .st-left-bar { background: linear-gradient(180deg, #fbbf24, #fcd34d); }
.st-body {
  padding: 20rpx 18rpx 20rpx 22rpx;
}
.st-header {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12rpx;
}
.st-name {
  font-size: 27rpx;
  font-weight: 800;
  color: #1c1917;
  letter-spacing: 0.3rpx;
}
.status-tag {
  border-radius: 12rpx;
  padding: 6rpx 16rpx;
  font-size: 21rpx;
  font-weight: 700;
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
  display: flex;
  align-items: center;
  gap: 6rpx;
}
.status-dot {
  width: 10rpx;
  height: 10rpx;
  border-radius: 50%;
}
.tag-1 .status-dot { background: #22c55e; box-shadow: 0 0 8rpx #22c55e; animation: dotPulse 2s ease-in-out infinite; }
.tag-2 .status-dot { background: #f97316; box-shadow: 0 0 8rpx #f97316; }
.tag-3 .status-dot { background: #9ca3af; box-shadow: 0 0 8rpx #9ca3af; }
@keyframes dotPulse {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.5; transform: scale(0.8); }
}
.tag-1 { background: linear-gradient(135deg, rgba(34, 197, 94, 0.12), rgba(74, 222, 128, 0.06)); color: #16a34a; border: 1rpx solid rgba(34, 197, 94, 0.2); }
.tag-2 { background: linear-gradient(135deg, rgba(249, 115, 22, 0.12), rgba(251, 146, 60, 0.06)); color: #ea580c; border: 1rpx solid rgba(249, 115, 22, 0.2); }
.tag-3 { background: linear-gradient(135deg, rgba(156, 163, 175, 0.12), rgba(209, 213, 219, 0.06)); color: #6b7280; border: 1rpx solid rgba(156, 163, 175, 0.2); }

.st-stats {
  display: flex;
  flex-direction: row;
  align-items: center;
  padding: 12rpx 16rpx;
  background: linear-gradient(135deg, rgba(250, 252, 250, 0.95), rgba(255, 255, 255, 1));
  border-radius: 14rpx;
  margin-bottom: 12rpx;
}
.st-stat-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
}
.st-stat-val {
  font-size: 23rpx;
  font-weight: 800;
  color: #292524;
}
.st-stat-lbl {
  font-size: 18rpx;
  color: #a8a29e;
  margin-top: 2rpx;
}
.st-stat-divider {
  width: 1rpx;
  height: 32rpx;
  background: linear-gradient(180deg, transparent, #e5e5e5, transparent);
}

.st-pile-row {
  display: flex;
  flex-direction: column;
  gap: 8rpx;
}
.pile-progress-wrap {
  width: 100%;
}
.pile-progress-bg {
  width: 100%;
  height: 10rpx;
  background: rgba(0, 0, 0, 0.04);
  border-radius: 5rpx;
  overflow: hidden;
}
.pile-progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #f59e0b, #fb923c, #fbbf24);
  border-radius: 5rpx;
  transition: width 0.8s cubic-bezier(0.34, 1.56, 0.64, 1);
  box-shadow: 0 0 10rpx rgba(34, 197, 94, 0.3);
  position: relative;
}
.pile-progress-fill::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
  animation: progressShine 2.2s ease-in-out infinite;
}
@keyframes progressShine {
  0% { transform: translateX(-100%); }
  100% { transform: translateX(100%); }
}
.pile-text {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
}
.pile-available {
  font-size: 24rpx;
  color: #16a34a;
  font-weight: 800;
}
.pile-slash {
  font-size: 22rpx;
  color: #cccccc;
  margin: 0 6rpx;
}
.pile-total {
  font-size: 22rpx;
  color: #a8a29e;
  font-weight: 600;
}

/* ========== 最近订单 ========== */
.order-list {
  display: flex;
  flex-direction: column;
  gap: 14rpx;
}
.order-card {
  background: rgba(255, 255, 255, 0.88);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  border-radius: 20rpx;
  padding: 20rpx 22rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.04), inset 0 1rpx 0 rgba(255, 255, 255, 0.9);
  border: 1rpx solid rgba(255, 255, 255, 0.8);
  position: relative;
  overflow: hidden;
  transition: all 0.3s ease;
}
.order-hover {
  transform: scale(0.98) translateY(-2rpx);
  box-shadow: 0 10rpx 30rpx rgba(0, 0, 0, 0.09);
  border-color: rgba(249, 115, 22, 0.2);
}
.order-left-bar {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 5rpx;
  background: linear-gradient(180deg, #f97316, #fb923c);
  border-radius: 20rpx 0 0 20rpx;
  box-shadow: 2rpx 0 12rpx rgba(249, 115, 22, 0.2);
  transition: all 0.3s ease;
}
.order-hover .order-left-bar {
  width: 7rpx;
  box-shadow: 4rpx 0 20rpx rgba(249, 115, 22, 0.35);
}
.order-body {
  position: relative;
  z-index: 1;
}
.order-top {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12rpx;
}
.order-no {
  display: flex;
  align-items: center;
  gap: 6rpx;
}
.order-no-icon {
  font-size: 22rpx;
  color: #f97316;
  font-weight: 900;
}
.order-no-text {
  font-size: 25rpx;
  font-weight: 800;
  color: #292524;
  font-family: monospace;
  letter-spacing: 0.5rpx;
}
.order-status {
  border-radius: 12rpx;
  padding: 6rpx 16rpx;
  font-size: 21rpx;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 6rpx;
  position: relative;
  overflow: hidden;
}
.os-pulse {
  position: absolute;
  left: 10rpx;
  width: 8rpx;
  height: 8rpx;
  border-radius: 50%;
  background: #f59e0b;
  animation: chargePulse 1.5s ease-in-out infinite;
  box-shadow: 0 0 8rpx #f59e0b;
}
@keyframes chargePulse {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.4; transform: scale(0.7); }
}
.os-0 { background: linear-gradient(135deg, rgba(245, 158, 11, 0.12), rgba(251, 146, 60, 0.06)); color: #d97706; border: 1rpx solid rgba(245, 158, 11, 0.2); padding-left: 22rpx; }
.os-1 { background: linear-gradient(135deg, rgba(34, 197, 94, 0.12), rgba(74, 222, 128, 0.06)); color: #16a34a; border: 1rpx solid rgba(34, 197, 94, 0.2); }
.os-2 { background: linear-gradient(135deg, rgba(107, 114, 128, 0.12), rgba(156, 163, 175, 0.06)); color: #6b7280; border: 1rpx solid rgba(107, 114, 128, 0.2); }

.order-mid {
  display: flex;
  flex-direction: row;
  align-items: center;
  flex-wrap: wrap;
  gap: 10rpx;
  margin-bottom: 12rpx;
}
.order-pile, .order-time, .order-energy {
  font-size: 22rpx;
  color: #78716c;
  font-weight: 500;
  padding: 6rpx 12rpx;
  background: linear-gradient(135deg, rgba(250, 251, 252, 0.98), rgba(255, 255, 255, 1));
  border-radius: 10rpx;
  border: 1rpx solid rgba(0, 0, 0, 0.02);
}
.order-bottom {
  display: flex;
  flex-direction: row;
  justify-content: flex-end;
  align-items: center;
  padding-top: 12rpx;
  border-top: 1rpx dashed rgba(0, 0, 0, 0.06);
}
.amount-lbl {
  font-size: 20rpx;
  color: #a8a29e;
  font-weight: 600;
  margin-right: 8rpx;
}
.amount-val {
  font-size: 34rpx;
  font-weight: 900;
  color: #f97316;
  letter-spacing: 0.5rpx;
  text-shadow: 0 2rpx 8rpx rgba(249, 115, 22, 0.15);
}

/* ========== 最新评价 ========== */
.review-list {
  display: flex;
  flex-direction: column;
  gap: 14rpx;
}
.review-card {
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border-radius: 18rpx;
  padding: 18rpx 20rpx;
  display: flex;
  box-shadow: 0 2rpx 14rpx rgba(0, 0, 0, 0.03);
}
.review-avatar {
  width: 64rpx;
  height: 64rpx;
  border-radius: 32rpx;
  background: linear-gradient(135deg, #fef3c7, #fde68a);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 16rpx;
  flex-shrink: 0;
}
.avatar-text {
  font-size: 26rpx;
  font-weight: 700;
  color: #92400e;
}
.review-body {
  flex: 1;
  display: flex;
  flex-direction: column;
}
.review-top {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 6rpx;
}
.review-name {
  font-size: 26rpx;
  font-weight: 700;
  color: #1c1917;
}
.review-stars {
  display: flex;
  flex-direction: row;
  gap: 2rpx;
}
.star {
  font-size: 22rpx;
  color: #e5e7eb;
}
.star.active {
  color: #f59e0b;
}
.review-text {
  font-size: 24rpx;
  color: #57534e;
  line-height: 1.5;
  margin-top: 6rpx;
}
.review-time {
  font-size: 20rpx;
  color: #a8a29e;
  margin-top: 6rpx;
}

/* ========== 更多管理弹窗 ========== */
.modal-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.45);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
  z-index: 998;
  animation: maskFadeIn 0.25s ease-out;
}
@keyframes maskFadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}
.modal-panel {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(255, 255, 255, 0.97);
  backdrop-filter: blur(24px);
  -webkit-backdrop-filter: blur(24px);
  border-radius: 36rpx 36rpx 0 0;
  z-index: 999;
  transform: translateY(100%);
  transition: transform 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
  max-height: 78vh;
  box-shadow: 0 -10rpx 44rpx rgba(0, 0, 0, 0.12);
  overflow: hidden;
}
.modal-show {
  transform: translateY(0);
}
.modal-handle {
  width: 60rpx;
  height: 6rpx;
  border-radius: 3rpx;
  background: linear-gradient(90deg, #ddd, #eee, #ddd);
  margin: 16rpx auto 20rpx;
}
.modal-header {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  padding: 0 28rpx 20rpx;
  border-bottom: 1rpx solid rgba(0, 0, 0, 0.05);
}
.modal-title {
  font-size: 32rpx;
  font-weight: 900;
  color: #1c1917;
  letter-spacing: 0.5rpx;
}
.modal-close {
  width: 52rpx;
  height: 52rpx;
  line-height: 48rpx;
  text-align: center;
  border-radius: 50%;
  background: linear-gradient(135deg, #f5f5f5, #eee);
  font-size: 28rpx;
  color: #999;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.05);
}
.modal-close:active {
  transform: scale(0.92);
}
.modal-scroll {
  padding: 16rpx 24rpx 48rpx;
}
.menu-list {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}
.menu-item {
  display: flex;
  flex-direction: row;
  align-items: center;
  padding: 20rpx 16rpx;
  border-radius: 18rpx;
  background: linear-gradient(135deg, rgba(250, 252, 250, 0.98), rgba(255, 255, 255, 1));
  border: 1rpx solid rgba(0, 0, 0, 0.03);
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.02);
  position: relative;
  overflow: hidden;
  transition: all 0.3s ease;
}
.menu-hover {
  transform: scale(0.97) translateX(-4rpx);
  box-shadow: 0 6rpx 20rpx rgba(0, 0, 0, 0.07);
}
.menu-color-bar {
  position: absolute;
  left: 0;
  top: 8rpx;
  bottom: 8rpx;
  width: 5rpx;
  border-radius: 4rpx;
  transition: all 0.3s ease;
}
.menu-0 .menu-color-bar { background: linear-gradient(180deg, #f59e0b, #fb923c); color: #f59e0b; }
.menu-1 .menu-color-bar { background: linear-gradient(180deg, #d97706, #f59e0b); color: #d97706; }
.menu-2 .menu-color-bar { background: linear-gradient(180deg, #fb923c, #fbbf24); color: #f97316; }
.menu-3 .menu-color-bar { background: linear-gradient(180deg, #fbbf24, #fcd34d); color: #d97706; }
.menu-4 .menu-color-bar { background: linear-gradient(180deg, #b45309, #d97706); color: #92400e; }
.menu-hover .menu-color-bar {
  width: 7rpx;
  box-shadow: 0 0 14rpx currentColor;
}
.menu-icon-wrap {
  width: 62rpx;
  height: 62rpx;
  border-radius: 16rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 16rpx;
  flex-shrink: 0;
  transition: transform 0.2s ease;
}
.menu-hover .menu-icon-wrap {
  transform: scale(1.08) rotate(-5deg);
}
.menu-0 .menu-icon-wrap { background: linear-gradient(135deg, rgba(245, 158, 11, 0.12), rgba(251, 146, 60, 0.06)); }
.menu-1 .menu-icon-wrap { background: linear-gradient(135deg, rgba(217, 119, 6, 0.12), rgba(245, 158, 11, 0.06)); }
.menu-2 .menu-icon-wrap { background: linear-gradient(135deg, rgba(251, 146, 60, 0.12), rgba(251, 191, 36, 0.06)); }
.menu-3 .menu-icon-wrap { background: linear-gradient(135deg, rgba(251, 191, 36, 0.12), rgba(252, 211, 77, 0.06)); }
.menu-4 .menu-icon-wrap { background: linear-gradient(135deg, rgba(217, 119, 6, 0.10), rgba(180, 83, 9, 0.06)); }
.menu-icon {
  font-size: 32rpx;
  font-weight: 900;
  line-height: 1;
}
.mi-0 { color: #d97706; }
.mi-1 { color: #b45309; }
.mi-2 { color: #f59e0b; }
.mi-3 { color: #d97706; }
.mi-4 { color: #92400e; }
.menu-info {
  flex: 1;
  display: flex;
  flex-direction: column;
}
.menu-name {
  font-size: 27rpx;
  font-weight: 800;
  color: #1c1917;
  letter-spacing: 0.3rpx;
}
.menu-desc {
  font-size: 22rpx;
  color: #a8a29e;
  margin-top: 3rpx;
}
.menu-arrow {
  font-size: 28rpx;
  color: #ccc;
  font-weight: 600;
  margin-left: 8rpx;
}

/* ========== 加载状态 ========== */
.loading-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(255, 247, 237, 0.85);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 100;
}
.loading-box {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20rpx;
}
.loading-spinner {
  width: 60rpx;
  height: 60rpx;
  border: 6rpx solid #fde68a;
  border-top-color: #f59e0b;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}
@keyframes spin {
  to { transform: rotate(360deg); }
}
.loading-text {
  font-size: 26rpx;
  color: #d97706;
  font-weight: 600;
}

/* ========== 空状态 ========== */
.empty-tip {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40rpx 20rpx;
  gap: 14rpx;
}
.empty-icon {
  font-size: 52rpx;
}
.empty-text {
  font-size: 24rpx;
  color: #a8a29e;
  text-align: center;
}
</style>
