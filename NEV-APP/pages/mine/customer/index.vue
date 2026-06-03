<template>
  <view class="page-container">
    <scroll-view scroll-y class="chat-scroll" :scroll-top="scrollTop" id="chatScroll">
      <view class="chat-list">
        <view v-for="(msg, idx) in chatList" :key="idx">
          <view class="chat-time" v-if="msg.type === 'time'">{{ msg.text }}</view>
          <view v-else class="chat-msg" :class="msg.from">
            <image v-if="msg.from === 'server'" class="chat-avatar" src="/static/images/imgs/zhanshi.jpg"></image>
            <view class="chat-bubble" :class="msg.from">
              <text>{{ msg.text }}</text>
            </view>
            <image v-if="msg.from === 'user'" class="chat-avatar" src="/static/images/imgs/zhanshi.jpg"></image>
          </view>
        </view>

        <view v-if="autoReplies.length > 0" class="quick-replies">
          <text class="qr-title">请选择您想咨询的问题：</text>
          <view class="qr-list">
            <view v-for="(q, idx) in autoReplies" :key="idx" class="qr-item" @click="handleQuickReply(q)">{{ q }}</view>
          </view>
        </view>
      </view>
    </scroll-view>

    <view class="chat-input-bar">
      <input class="chat-input" v-model="inputText" placeholder="请输入您的问题..." confirm-type="send" @confirm="handleSend" />
      <view class="send-btn" @click="handleSend">发送</view>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      inputText: '',
      scrollTop: 0,
      autoReplies: [
        '如何预约保养服务？',
        '保养周期是多长时间？',
        '如何查看充电记录？',
        '优惠券如何使用？',
        '如何联系维修门店？'
      ],
      chatList: [
        { type: 'time', text: '2026-06-02 10:00' },
        { from: 'server', text: '您好！欢迎来到 NEV Life 客服中心，我是智能客服小N，请问有什么可以帮您的？' },
        {
          from: 'server',
          text: '您可以通过以下方式获取帮助：\n1. 查看常见问题\n2. 直接输入问题\n3. 拨打客服热线 400-123-4567'
        }
      ]
    }
  },
  methods: {
    handleQuickReply(question) {
      this.chatList.push({ from: 'user', text: question })
      this.autoReplies = []
      setTimeout(() => {
        this.chatList.push({
          from: 'server',
          text: this.getReply(question)
        })
        this.scrollToBottom()
      }, 500)
      this.scrollToBottom()
    },
    handleSend() {
      const text = this.inputText.trim()
      if (!text) return
      this.chatList.push({ from: 'user', text })
      this.autoReplies = []
      this.inputText = ''
      setTimeout(() => {
        this.chatList.push({
          from: 'server',
          text: this.getReply(text)
        })
        this.scrollToBottom()
      }, 800)
      this.scrollToBottom()
    },
    getReply(question) {
      if (question.includes('预约') || question.includes('保养')) {
        return '您可以在"服务"页面选择维保服务进行在线预约，选择合适的时间段即可。如有疑问可拨打客服热线 400-123-4567。'
      }
      if (question.includes('保养周期')) {
        return '一般建议每5000公里或6个月进行一次常规保养，具体以车辆说明书为准。电动车保养主要包括：电池检测、空调滤芯更换、刹车系统检查等。'
      }
      if (question.includes('充电')) {
        return '您可以在"我的-充电记录"中查看历史充电记录。如需查找充电站，请在首页使用充电地图功能。'
      }
      if (question.includes('优惠券')) {
        return '优惠券可在"我的-优惠券"中查看。下单时系统会自动匹配可用优惠券，您也可以在支付页面手动选择。'
      }
      if (question.includes('门店') || question.includes('联系')) {
        return '您可以在"服务"页面查看附近的维保门店，选择门店后可查看详细地址和联系电话。客服热线：400-123-4567（工作日 9:00-18:00）。'
      }
      return '感谢您的咨询！我已记录您的问题，稍后会有客服专员与您联系。紧急问题请拨打客服热线 400-123-4567。'
    },
    scrollToBottom() {
      this.$nextTick(() => {
        this.scrollTop = 99999
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

.chat-scroll {
  height: calc(100vh - 100rpx);
  padding: 20rpx 24rpx;
}

.chat-time {
  text-align: center;
  padding: 16rpx 0;
}

.chat-time text {
  font-size: 22rpx;
  color: #bbb;
  background-color: #f0f0f0;
  padding: 4rpx 20rpx;
  border-radius: 20rpx;
}

.chat-msg {
  display: flex;
  margin-bottom: 20rpx;
}

.chat-msg.server {
  flex-direction: row;
}

.chat-msg.user {
  flex-direction: row-reverse;
}

.chat-avatar {
  width: 72rpx;
  height: 72rpx;
  border-radius: 50%;
  flex-shrink: 0;
}

.chat-bubble {
  max-width: 70%;
  padding: 16rpx 24rpx;
  border-radius: 16rpx;
  font-size: 28rpx;
  line-height: 1.6;
}

.chat-bubble.server {
  background-color: #fff;
  color: #333;
  margin-left: 16rpx;
  border-top-left-radius: 4rpx;
}

.chat-bubble.user {
  background-color: #3c96f3;
  color: #fff;
  margin-right: 16rpx;
  border-top-right-radius: 4rpx;
}

.quick-replies {
  background-color: #fff;
  border-radius: 14rpx;
  padding: 20rpx;
  margin-top: 20rpx;
}

.qr-title {
  font-size: 24rpx;
  color: #999;
}

.qr-list {
  display: flex;
  flex-wrap: wrap;
  gap: 14rpx;
  margin-top: 14rpx;
}

.qr-item {
  font-size: 24rpx;
  color: #3c96f3;
  background-color: #e8f2ff;
  padding: 10rpx 24rpx;
  border-radius: 30rpx;
}

.chat-input-bar {
  display: flex;
  align-items: center;
  padding: 16rpx 24rpx;
  background-color: #fff;
  border-top: 1rpx solid #f0f0f0;
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
}

.chat-input {
  flex: 1;
  height: 72rpx;
  background-color: #f5f6f7;
  border-radius: 36rpx;
  padding: 0 24rpx;
  font-size: 28rpx;
}

.send-btn {
  margin-left: 16rpx;
  padding: 14rpx 32rpx;
  background-color: #3c96f3;
  color: #fff;
  font-size: 26rpx;
  border-radius: 36rpx;
  flex-shrink: 0;
}
</style>