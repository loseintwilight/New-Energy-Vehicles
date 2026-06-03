<template>
  <view class="help-container">
    <!-- 搜索栏 -->
    <view class="search-section">
      <view class="search-box">
        <uni-icons type="search" size="24" color="#999" class="search-icon"></uni-icons>
        <input 
          v-model="searchKeyword" 
          class="search-input" 
          placeholder="搜索问题" 
          @confirm="handleSearch"
        />
      </view>
    </view>

    <!-- 分类标签 -->
    <scroll-view scroll-x class="category-scroll">
      <view class="category-list">
        <view 
          v-for="item in categories" 
          :key="item.id"
          :class="['category-item', currentCategory === item.id ? 'active' : '']"
          @click="currentCategory = item.id"
        >
          <text>{{ item.name }}</text>
        </view>
      </view>
    </scroll-view>

    <!-- 常见问题列表 -->
    <view class="faq-list">
      <view 
        v-for="(item, index) in filteredFAQs" 
        :key="index"
        class="faq-item"
        @click="toggleFAQ(index)"
      >
        <view class="faq-header">
          <view class="faq-icon">
            <uni-icons type="help-circle" size="24" color="#3c96f3"></uni-icons>
          </view>
          <view class="faq-content">
            <text class="faq-question">{{ item.question }}</text>
          </view>
          <view :class="['expand-icon', expandedIndex === index ? 'expanded' : '']">
            <uni-icons type="bottom" size="20" color="#999"></uni-icons>
          </view>
        </view>
        <view v-if="expandedIndex === index" class="faq-answer">
          <text>{{ item.answer }}</text>
        </view>
      </view>
    </view>

    <!-- 联系客服 -->
    <view class="contact-section">
      <view class="contact-card" @click="handleContact">
        <view class="contact-icon">
          <uni-icons type="phone" size="32" color="#3c96f3"></uni-icons>
        </view>
        <view class="contact-info">
          <text class="contact-title">联系客服</text>
          <text class="contact-desc">工作时间：9:00-21:00</text>
        </view>
        <uni-icons type="forward" size="20" color="#999" class="contact-arrow"></uni-icons>
      </view>
    </view>
  </view>
</template>

<script>
  export default {
    data() {
      return {
        searchKeyword: '',
        currentCategory: 'all',
        expandedIndex: -1,
        categories: [
          { id: 'all', name: '全部' },
          { id: 'order', name: '订单相关' },
          { id: 'payment', name: '支付问题' },
          { id: 'account', name: '账户问题' },
          { id: 'service', name: '服务咨询' }
        ],
        faqs: [
          {
            id: 1,
            category: 'order',
            question: '如何查询订单状态？',
            answer: '您可以在"我的订单"页面查看所有订单的状态。点击进入具体订单详情，可查看订单的实时状态、物流信息等。'
          },
          {
            id: 2,
            category: 'order',
            question: '如何取消订单？',
            answer: '在订单未发货前，您可以在订单详情页点击"取消订单"按钮。已发货的订单需要联系客服协助处理。'
          },
          {
            id: 3,
            category: 'payment',
            question: '支持哪些支付方式？',
            answer: '我们支持微信支付、支付宝、银行卡等多种支付方式。在提交订单时，您可以选择最方便的支付方式。'
          },
          {
            id: 4,
            category: 'payment',
            question: '支付失败怎么办？',
            answer: '支付失败可能是网络问题或账户余额不足。请检查网络连接和账户余额后重新支付。如多次失败，请联系客服。'
          },
          {
            id: 5,
            category: 'account',
            question: '如何修改密码？',
            answer: '在"我的"页面点击"设置"，选择"修改密码"，按照提示输入原密码和新密码即可完成修改。'
          },
          {
            id: 6,
            category: 'account',
            question: '忘记密码怎么办？',
            answer: '在登录页面点击"忘记密码"，通过注册手机号获取验证码，设置新密码即可找回账户。'
          },
          {
            id: 7,
            category: 'service',
            question: '售后服务政策是怎样的？',
            answer: '我们提供7天无理由退换服务。商品如有质量问题，可申请退换货。具体政策请查看"售后服务"页面。'
          },
          {
            id: 8,
            category: 'service',
            question: '如何联系客服？',
            answer: '您可以通过帮助中心的"联系客服"入口，或在"我的"页面点击客服按钮，在线咨询客服人员。'
          }
        ]
      }
    },
    computed: {
      filteredFAQs() {
        let result = this.faqs
        
        if (this.currentCategory !== 'all') {
          result = result.filter(item => item.category === this.currentCategory)
        }
        
        if (this.searchKeyword) {
          const keyword = this.searchKeyword.toLowerCase()
          result = result.filter(item => 
            item.question.toLowerCase().includes(keyword) ||
            item.answer.toLowerCase().includes(keyword)
          )
        }
        
        return result
      }
    },
    methods: {
      toggleFAQ(index) {
        this.expandedIndex = this.expandedIndex === index ? -1 : index
      },
      handleSearch() {
        // 搜索逻辑已在computed中实现
      },
      handleContact() {
        uni.showToast({
          title: '正在连接客服...',
          icon: 'loading',
          duration: 2000
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

  .help-container {
    padding-bottom: 100rpx;
  }

  /* 搜索栏 */
  .search-section {
    padding: 30rpx;
    background-color: #fff;
  }

  .search-box {
    display: flex;
    align-items: center;
    background-color: #f5f6f7;
    border-radius: 44rpx;
    padding: 0 30rpx;
    height: 72rpx;
  }

  .search-icon {
    font-size: 28rpx;
    color: #999;
    margin-right: 16rpx;
  }

  .search-input {
    flex: 1;
    font-size: 28rpx;
    color: #333;
  }

  /* 分类标签 */
  .category-scroll {
    white-space: nowrap;
    background-color: #fff;
    padding: 20rpx 0;
    border-bottom: 1rpx solid #f0f0f0;
  }

  .category-list {
    display: inline-flex;
    padding: 0 20rpx;
  }

  .category-item {
    padding: 16rpx 32rpx;
    margin-right: 20rpx;
    background-color: #f5f6f7;
    border-radius: 32rpx;
    font-size: 26rpx;
    color: #666;
  }

  .category-item.active {
    background-color: #3c96f3;
    color: #fff;
  }

  /* 常见问题列表 */
  .faq-list {
    padding: 30rpx;
  }

  .faq-item {
    background-color: #fff;
    border-radius: 16rpx;
    margin-bottom: 20rpx;
    overflow: hidden;
    box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
  }

  .faq-header {
    display: flex;
    align-items: center;
    padding: 26rpx 30rpx;
  }

  .faq-icon {
    width: 48rpx;
    height: 48rpx;
    background-color: #e6f0ff;
    border-radius: 50%;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-right: 16rpx;
  }

  .faq-icon .iconfont {
    font-size: 24rpx;
    color: #3c96f3;
  }

  .faq-content {
    flex: 1;
  }

  .faq-question {
    font-size: 28rpx;
    color: #333;
    font-weight: 500;
  }

  .expand-icon {
    width: 48rpx;
    height: 48rpx;
    display: flex;
    justify-content: center;
    align-items: center;
    transition: transform 0.3s;
  }

  .expand-icon.expanded {
    transform: rotate(180deg);
  }

  .expand-icon .iconfont {
    font-size: 24rpx;
    color: #999;
  }

  .faq-answer {
    padding: 0 30rpx 26rpx;
    margin-top: -10rpx;
  }

  .faq-answer text {
    font-size: 26rpx;
    color: #666;
    line-height: 1.8;
  }

  /* 联系客服 */
  .contact-section {
    padding: 30rpx;
    padding-bottom: 60rpx;
  }

  .contact-card {
    background: linear-gradient(135deg, #3c96f3 0%, #6b7bff 100%);
    border-radius: 16rpx;
    padding: 30rpx;
    display: flex;
    align-items: center;
  }

  .contact-icon {
    width: 72rpx;
    height: 72rpx;
    background-color: rgba(255, 255, 255, 0.2);
    border-radius: 50%;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-right: 20rpx;
  }

  .contact-icon .iconfont {
    font-size: 32rpx;
    color: #fff;
  }

  .contact-info {
    flex: 1;
  }

  .contact-title {
    display: block;
    font-size: 30rpx;
    font-weight: 500;
    color: #fff;
    margin-bottom: 6rpx;
  }

  .contact-desc {
    font-size: 24rpx;
    color: rgba(255, 255, 255, 0.8);
  }

  .contact-arrow {
    font-size: 28rpx;
    color: rgba(255, 255, 255, 0.8);
  }

  .icon-search:before {
    content: "\e600";
  }

  .icon-question:before {
    content: "\e601";
  }

  .icon-down:before {
    content: "\e602";
  }

  .icon-service:before {
    content: "\e604";
  }
</style>