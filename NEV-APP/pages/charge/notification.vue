<template>
  <view class="notification-page">
    <charge-header />
    <view class="np-header">
      <view class="np-header-inner">
        <view class="np-back" @click="goBack">
          <u-icon name="arrow-left" size="36" color="#333"></u-icon>
        </view>
        <text class="np-title">消息通知</text>
        <view class="np-clear" @click="clearAllRead" v-if="unreadCount > 0">
          <text>全部已读</text>
        </view>
        <view class="np-placeholder" v-else></view>
      </view>
    </view>

    <view class="np-tabs">
      <view
        v-for="(tab, ti) in tabs"
        :key="ti"
        class="np-tab"
        :class="{ active: activeTab === tab.key }"
        @click="activeTab = tab.key"
      >
        <text>{{ tab.label }}</text>
        <view v-if="tab.count > 0" class="np-tab-badge">{{ tab.count }}</view>
      </view>
    </view>

    <scroll-view class="np-list" scroll-y refresher-enabled refresher-triggered="isRefreshing" @refresherrefresh="onRefresh">
      <view v-if="displayList.length === 0" class="np-empty">
        <view class="np-empty-icon">
          <u-icon name="bell" size="80" color="#ddd"></u-icon>
        </view>
        <text class="np-empty-text">暂无消息</text>
      </view>
      <view
        v-for="(item, ni) in displayList"
        :key="item.id"
        class="np-item"
        :class="{ unread: !item.read }"
        @click="markRead(item)"
      >
        <view class="np-item-dot" v-if="!item.read"></view>
        <view class="np-item-content" :class="{ 'no-dot': item.read }">
          <view class="np-item-head">
            <text class="np-item-title">{{ item.title }}</text>
            <text class="np-item-time">{{ item.time }}</text>
          </view>
          <text class="np-item-body">{{ item.content }}</text>
        </view>
        <view class="np-item-arrow">
          <u-icon name="arrow-right" size="24" color="#ccc"></u-icon>
        </view>
      </view>
      <view class="np-bottom-space"></view>
    </scroll-view>
  </view>
</template>

<script>
import safeAreaMixin from '@/mixins/safe-area.js'
import ChargeHeader from '@/components/charge-header/charge-header.vue'

export default {
  mixins: [safeAreaMixin],
  components: { ChargeHeader },
  data() {
    return {
      isRefreshing: false,
      activeTab: 'all',
      tabs: [
        { key: 'all', label: '全部', count: 0 },
        { key: 'system', label: '系统通知', count: 0 },
        { key: 'order', label: '订单通知', count: 0 },
        { key: 'promotion', label: '优惠提醒', count: 0 }
      ],
      noticeList: [
        { id: 1, title: '系统通知', content: '济南东站充电站已上线，新站充电享8折优惠！', time: '2026-05-28 14:30', read: false, type: 'system' },
        { id: 2, title: '优惠提醒', content: '您有2张限时活动券即将过期，请尽快使用', time: '2026-05-28 10:00', read: false, type: 'promotion' },
        { id: 3, title: '充电提醒', content: '您的爱车已充电完成，请及时移车以免产生占位费', time: '2026-05-27 22:15', read: false, type: 'order' },
        { id: 4, title: '订单通知', content: '充电订单已完成，本次充电花费 ¥35.60', time: '2026-05-26 18:30', read: true, type: 'order' },
        { id: 5, title: '系统通知', content: '夜间错峰充电功能已上线，享受低谷电价更省钱', time: '2026-05-25 09:00', read: true, type: 'system' },
        { id: 6, title: '优惠提醒', content: '周末充电优惠活动：指定站点充电享7折', time: '2026-05-24 12:00', read: true, type: 'promotion' },
        { id: 7, title: '系统通知', content: 'App版本更新v2.3.0已发布，优化充电体验', time: '2026-05-23 08:00', read: false, type: 'system' }
      ]
    }
  },
  computed: {
    unreadCount() {
      return this.noticeList.filter(n => !n.read).length
    },
    displayList() {
      if (this.activeTab === 'all') return this.noticeList
      return this.noticeList.filter(n => n.type === this.activeTab)
    }
  },
  watch: {
    noticeList: {
      handler() {
        this.syncTabs()
        this.syncUnread()
      },
      deep: true,
      immediate: true
    }
  },
  onLoad() {
    this.syncUnread()
  },
  onShow() {
    this.syncUnread()
  },
  methods: {
    syncUnread() {
      const saved = uni.getStorageSync('unreadNotice')
      if (saved !== undefined && saved !== null) {
        this.syncCountToStorage()
      }
    },
    syncCountToStorage() {
      uni.setStorageSync('unreadNotice', this.unreadCount)
    },
    syncTabs() {
      this.tabs.forEach(tab => {
        if (tab.key === 'all') tab.count = this.unreadCount
        else tab.count = this.noticeList.filter(n => !n.read && n.type === tab.key).length
      })
    },
    markRead(item) {
      if (item.read) return
      item.read = true
      this.syncCountToStorage()
    },
    clearAllRead() {
      this.noticeList.forEach(n => { n.read = true })
      this.syncCountToStorage()
      uni.showToast({ title: '已全部标记为已读', icon: 'success' })
    },
    onRefresh() {
      this.isRefreshing = true
      setTimeout(() => { this.isRefreshing = false }, 500)
    },
    goBack() {
      uni.navigateBack()
    }
  }
}
</script>

<style lang="scss" scoped>
.notification-page {
  height: 100vh;
  background: #f5f6fa;
  display: flex;
  flex-direction: column;
}

.np-header {
  background: #fff;

  .np-header-inner {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 20rpx 16rpx;

    .np-back {
      width: 56rpx;
      height: 56rpx;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .np-title {
      font-size: 32rpx;
      font-weight: 700;
      color: #1a1a1a;
    }

    .np-clear text {
      font-size: 24rpx;
      color: #07c160;
    }

    .np-placeholder {
      width: 100rpx;
    }
  }
}

.np-tabs {
  display: flex;
  background: #fff;
  padding: 0 20rpx 8rpx;
  border-bottom: 1rpx solid #f0f0f0;

  .np-tab {
    position: relative;
    display: flex;
    align-items: center;
    padding: 12rpx 20rpx;
    font-size: 26rpx;
    color: #888;
    margin-right: 8rpx;

    &.active {
      color: #07c160;
      font-weight: 600;
      border-bottom: 4rpx solid #07c160;
    }

    .np-tab-badge {
      margin-left: 6rpx;
      min-width: 28rpx;
      height: 28rpx;
      line-height: 28rpx;
      text-align: center;
      font-size: 16rpx;
      color: #fff;
      background: #ff4d4f;
      border-radius: 14rpx;
      padding: 0 6rpx;
    }
  }
}

.np-list {
  flex: 1;
  padding: 0 24rpx;

  .np-empty {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding-top: 160rpx;

    .np-empty-icon {
      width: 140rpx;
      height: 140rpx;
      background: #fafafa;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 20rpx;
    }

    .np-empty-text {
      font-size: 28rpx;
      color: #bbb;
    }
  }

  .np-item {
    display: flex;
    align-items: flex-start;
    padding: 24rpx 20rpx;
    background: #fff;
    border-radius: 12rpx;
    margin-top: 12rpx;
    box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.02);

    &.unread {
      background: #fafff8;
    }

    .np-item-dot {
      width: 12rpx;
      height: 12rpx;
      background: #07c160;
      border-radius: 50%;
      margin-top: 8rpx;
      margin-right: 14rpx;
      flex-shrink: 0;
    }

    .np-item-content {
      flex: 1;
      min-width: 0;

      &.no-dot {
        margin-left: 26rpx;
      }

      .np-item-head {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 6rpx;

        .np-item-title {
          font-size: 28rpx;
          font-weight: 600;
          color: #1a1a1a;
        }

        .np-item-time {
          font-size: 20rpx;
          color: #bbb;
          flex-shrink: 0;
          margin-left: 12rpx;
        }
      }

      .np-item-body {
        font-size: 24rpx;
        color: #888;
        line-height: 1.5;
      }
    }

    .np-item-arrow {
      flex-shrink: 0;
      margin-left: 12rpx;
      display: flex;
      align-items: center;
      height: 100%;
      padding-top: 8rpx;
    }
  }

  .np-bottom-space {
    height: 40rpx;
  }
}
</style>