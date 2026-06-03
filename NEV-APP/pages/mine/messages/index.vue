<template>
  <view class="page-container">
    <view class="tab-bar">
      <scroll-view class="tab-scroll" scroll-x :show-scrollbar="false">
        <view
          v-for="tab in tabs"
          :key="tab.value"
          class="tab-item"
          :class="{ active: activeTab === tab.value }"
          @click="activeTab = tab.value"
        >
          <text>{{ tab.label }}</text>
          <view class="tab-line" v-if="tab.value === activeTab"></view>
        </view>
      </scroll-view>
    </view>

    <scroll-view scroll-y class="msg-scroll">
      <view class="msg-list" v-if="filteredMessages.length > 0">
        <view
          v-for="msg in filteredMessages"
          :key="msg.id"
          class="msg-item"
          :class="{ unread: msg.unread }"
          @click="handleRead(msg)"
        >
          <view class="msg-icon-box">
            <view class="msg-dot" v-if="msg.unread"></view>
            <uni-icons :type="msg.icon" size="32" :color="msg.iconColor"></uni-icons>
          </view>
          <view class="msg-info">
            <view class="msg-top">
              <text class="msg-title">{{ msg.title }}</text>
              <text class="msg-time">{{ msg.time }}</text>
            </view>
            <text class="msg-content">{{ msg.content }}</text>
          </view>
        </view>
      </view>

      <view class="empty" v-else>
        <uni-icons type="notification" size="80" color="#ddd"></uni-icons>
        <text class="empty-text">暂无{{ currentTabLabel }}消息</text>
      </view>
    </scroll-view>

    <view class="msg-footer" v-if="filteredMessages.length > 0">
      <view class="footer-btn" @click="handleMarkAll">全部已读</view>
      <view class="footer-btn" @click="handleClearAll">清空消息</view>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      activeTab: 'all',
      tabs: [
        { label: '全部', value: 'all' },
        { label: '系统通知', value: 'system' },
        { label: '订单通知', value: 'order' },
        { label: '优惠提醒', value: 'coupon' },
        { label: '充电通知', value: 'charge' },
        { label: '维保通知', value: 'maintain' }
      ],
      allMessages: [
        {
          id: 1, category: 'order',
          title: '订单支付成功',
          content: '您的常规保养服务订单已支付成功，门店将为您安排服务时间。',
          icon: 'checkbox-filled', iconColor: '#27ae60',
          time: '10:30', unread: true
        },
        {
          id: 2, category: 'maintain',
          title: '维保服务提醒',
          content: '您的车辆电池检测服务将于明天上午9点开始，请按时前往济南鑫维保-经十西路店。',
          icon: 'calendar-filled', iconColor: '#3c96f3',
          time: '06-01 18:00', unread: true
        },
        {
          id: 3, category: 'coupon',
          title: '优惠券到期提醒',
          content: '您有一张 ¥50 保养满减券将于3天后到期，请尽快使用。',
          icon: 'ticket-filled', iconColor: '#ff9800',
          time: '05-30 12:00', unread: false
        },
        {
          id: 4, category: 'system',
          title: '系统更新通知',
          content: 'NEV Life 版本更新至 V2.1.0，新增充电地图功能，快来体验吧！',
          icon: 'notification-filled', iconColor: '#9b59b6',
          time: '05-28 09:00', unread: false
        },
        {
          id: 5, category: 'maintain',
          title: '维保完成通知',
          content: '您的车辆（鲁A·12345）轮胎更换服务已完成，请及时取车。',
          icon: 'checkmarkempty', iconColor: '#27ae60',
          time: '05-28 15:30', unread: false
        },
        {
          id: 6, category: 'system',
          title: '积分到账通知',
          content: '您通过充电签到获得 50 碳积分，累计碳积分 2680 分。',
          icon: 'star-filled', iconColor: '#f1c40f',
          time: '05-27 08:30', unread: false
        },
        {
          id: 7, category: 'order',
          title: '订单取消通知',
          content: '您的美容装饰订单已取消成功，如有疑问请联系客服。',
          icon: 'closeempty', iconColor: '#ff4757',
          time: '05-25 16:20', unread: false
        },
        {
          id: 8, category: 'charge',
          title: '充电完成通知',
          content: '您的车辆在星星充电站（槐荫区）充电已完成，充电量 42.5 kWh，费用 ¥38.25。',
          icon: 'bolt', iconColor: '#2ecc71',
          time: '06-01 19:20', unread: true
        },
        {
          id: 9, category: 'charge',
          title: '充电桩故障提醒',
          content: '特来电充电站（历下区）2号充电桩出现故障，已暂停使用，请选择其他充电桩。',
          icon: 'closeempty', iconColor: '#ff9800',
          time: '05-31 14:00', unread: true
        },
        {
          id: 10, category: 'charge',
          title: '充电优惠活动',
          content: '本周末星星充电站充电服务费5折优惠，快来参与吧！',
          icon: 'star-filled', iconColor: '#f1c40f',
          time: '05-29 10:00', unread: false
        },
        {
          id: 11, category: 'coupon',
          title: '新人优惠券到账',
          content: '恭喜您获得新人专享 ¥100 优惠券，满500元可用，赶紧去使用吧！',
          icon: 'gift-filled', iconColor: '#e74c3c',
          time: '05-20 09:00', unread: false
        }
      ]
    }
  },
  computed: {
    currentTabLabel() {
      const tab = this.tabs.find(t => t.value === this.activeTab)
      return tab ? tab.label : ''
    },
    filteredMessages() {
      if (this.activeTab === 'all') return this.allMessages
      return this.allMessages.filter(m => m.category === this.activeTab)
    }
  },
  onLoad(options) {
    if (options.tab) {
      this.activeTab = options.tab
    }
    this.syncUnreadCount()
  },
  methods: {
    syncUnreadCount() {
      const app = getApp()
      app.globalData.messageCount = this.allMessages.filter(m => m.unread).length
    },
    syncCategoryUnreadCount() {
      const app = getApp()
      app.globalData.messageCategoryCounts = {
        system: this.allMessages.filter(m => m.category === 'system' && m.unread).length,
        order: this.allMessages.filter(m => m.category === 'order' && m.unread).length,
        coupon: this.allMessages.filter(m => m.category === 'coupon' && m.unread).length,
        charge: this.allMessages.filter(m => m.category === 'charge' && m.unread).length,
        maintain: this.allMessages.filter(m => m.category === 'maintain' && m.unread).length
      }
    },
    handleRead(msg) {
      msg.unread = false
      this.syncUnreadCount()
      this.syncCategoryUnreadCount()
      uni.showToast({ title: '查看消息详情', icon: 'none' })
    },
    handleMarkAll() {
      this.filteredMessages.forEach(m => (m.unread = false))
      this.syncUnreadCount()
      this.syncCategoryUnreadCount()
      uni.showToast({ title: '全部已读', icon: 'success' })
    },
    handleClearAll() {
      uni.showModal({
        title: '清空消息',
        content: '确定要清空当前分类的所有消息吗？',
        success: (res) => {
          if (res.confirm) {
            this.allMessages = this.allMessages.filter(m => m.category !== this.activeTab)
            this.syncUnreadCount()
            this.syncCategoryUnreadCount()
            uni.showToast({ title: '已清空', icon: 'success' })
          }
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
page {
  background-color: #f5f6f7;
  min-height: 100vh;
}

.tab-bar {
  background-color: #fff;
  position: sticky;
  top: 0;
  z-index: 10;
}

.tab-scroll {
  display: flex;
  white-space: nowrap;
  padding: 0 20rpx;
}

.tab-item {
  display: inline-flex;
  flex-direction: column;
  align-items: center;
  padding: 24rpx 20rpx;
  font-size: 26rpx;
  color: #666;
  position: relative;
}

.tab-item.active {
  color: #3c96f3;
  font-weight: 600;
  font-size: 28rpx;
}

.tab-line {
  position: absolute;
  bottom: 0;
  width: 40rpx;
  height: 4rpx;
  background-color: #3c96f3;
  border-radius: 2rpx;
}

.msg-scroll {
  height: calc(100vh - 88rpx - 88rpx);
}

.msg-list {
  padding: 20rpx 30rpx;
}

.msg-item {
  display: flex;
  background-color: #fff;
  border-radius: 14rpx;
  padding: 24rpx;
  margin-bottom: 14rpx;
}

.msg-item.unread {
  background-color: #f0f7ff;
}

.msg-icon-box {
  width: 64rpx;
  height: 64rpx;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  position: relative;
  margin-right: 20rpx;
}

.msg-dot {
  position: absolute;
  top: 4rpx;
  right: 4rpx;
  width: 16rpx;
  height: 16rpx;
  background-color: #ff4757;
  border-radius: 50%;
  z-index: 2;
}

.msg-info {
  flex: 1;
}

.msg-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8rpx;
}

.msg-title {
  font-size: 28rpx;
  font-weight: 500;
  color: #333;
}

.msg-time {
  font-size: 22rpx;
  color: #bbb;
}

.msg-content {
  font-size: 24rpx;
  color: #999;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
}

.msg-footer {
  display: flex;
  justify-content: center;
  gap: 40rpx;
  padding: 20rpx 0;
  background-color: #fff;
  border-top: 1rpx solid #f0f0f0;
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
}

.footer-btn {
  font-size: 26rpx;
  color: #3c96f3;
  padding: 8rpx 32rpx;
}

.empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 200rpx;
}

.empty-text {
  font-size: 28rpx;
  color: #999;
  margin-top: 20rpx;
}
</style>