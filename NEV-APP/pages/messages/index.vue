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
import { getMessageList, markAsRead, markAllAsRead, deleteMessage } from '@/api/message'

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
      allMessages: [],
      loading: false
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
    this.loadMessages()
  },
  methods: {
    async loadMessages() {
      this.loading = true
      try {
        const res = await getMessageList()
        const data = res.data || res
        this.allMessages = (data.rows || data.list || data || []).map(msg => this.formatMessage(msg))
        this.syncUnreadCount()
      } catch (e) {
        console.error('加载消息列表失败', e)
      } finally {
        this.loading = false
      }
    },
    formatMessage(msg) {
      const iconMap = {
        system: 'notification-filled',
        order: 'checkbox-filled',
        coupon: 'ticket-filled',
        charge: 'bolt',
        maintain: 'calendar-filled'
      }
      const colorMap = {
        system: '#9b59b6',
        order: '#27ae60',
        coupon: '#ff9800',
        charge: '#2ecc71',
        maintain: '#3c96f3'
      }
      const category = msg.category || msg.type || 'system'
      return {
        id: msg.id || msg.messageId,
        category: category,
        title: msg.title || '',
        content: msg.content || msg.messageContent || '',
        icon: iconMap[category] || 'notification-filled',
        iconColor: colorMap[category] || '#3c96f3',
        time: msg.createTime ? msg.createTime.split(' ')[1] || msg.createTime.split(' ')[0] : '',
        unread: msg.unread === 1 || msg.unread === true
      }
    },
    syncUnreadCount() {
      const app = getApp()
      if (app && app.globalData) {
        app.globalData.messageCount = this.allMessages.filter(m => m.unread).length
      }
    },
    syncCategoryUnreadCount() {
      const app = getApp()
      if (app && app.globalData) {
        app.globalData.messageCategoryCounts = {
          system: this.allMessages.filter(m => m.category === 'system' && m.unread).length,
          order: this.allMessages.filter(m => m.category === 'order' && m.unread).length,
          coupon: this.allMessages.filter(m => m.category === 'coupon' && m.unread).length,
          charge: this.allMessages.filter(m => m.category === 'charge' && m.unread).length,
          maintain: this.allMessages.filter(m => m.category === 'maintain' && m.unread).length
        }
      }
    },
    async handleRead(msg) {
      if (msg.unread) {
        try {
          await markAsRead(msg.id)
          msg.unread = false
          this.syncUnreadCount()
          this.syncCategoryUnreadCount()
        } catch (e) {
          console.error('标记已读失败', e)
        }
      }
      uni.showToast({ title: '查看消息详情', icon: 'none' })
    },
    async handleMarkAll() {
      try {
        await markAllAsRead()
        this.filteredMessages.forEach(m => (m.unread = false))
        this.syncUnreadCount()
        this.syncCategoryUnreadCount()
        uni.showToast({ title: '全部已读', icon: 'success' })
      } catch (e) {
        uni.showToast({ title: '操作失败', icon: 'none' })
      }
    },
    async handleClearAll() {
      uni.showModal({
        title: '清空消息',
        content: '确定要清空当前分类的所有消息吗？',
        success: async (res) => {
          if (res.confirm) {
            try {
              // 逐个删除
              for (const msg of this.filteredMessages) {
                await deleteMessage(msg.id)
              }
              this.allMessages = this.allMessages.filter(m => m.category !== this.activeTab)
              this.syncUnreadCount()
              this.syncCategoryUnreadCount()
              uni.showToast({ title: '已清空', icon: 'success' })
            } catch (e) {
              uni.showToast({ title: '清空失败', icon: 'none' })
            }
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