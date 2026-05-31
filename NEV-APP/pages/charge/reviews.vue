<template>
  <view class="reviews-page">
    <charge-header />
    <view class="nav-bar">
      <view class="nav-back" @click="goBack">
        <u-icon name="arrow-left" size="36" color="#333"></u-icon>
      </view>
      <text class="nav-title">用户评价</text>
      <view class="nav-right">
        <view class="nav-write" @click="writeReview">
          <u-icon name="edit-pen" size="34" color="#07c160"></u-icon>
        </view>
      </view>
    </view>

    <view class="review-summary">
      <view class="rs-score">
        <text class="rs-num">{{ avgScore }}</text>
        <text class="rs-label">综合评分</text>
      </view>
      <view class="rs-bars">
        <view class="rs-bar-row" v-for="(level, li) in scoreLevels" :key="li">
          <text class="rs-bar-label">{{ level.label }}</text>
          <view class="rs-bar-track">
            <view class="rs-bar-fill" :style="{ width: level.percent + '%' }"></view>
          </view>
          <text class="rs-bar-num">{{ level.count }}</text>
        </view>
      </view>
      <view class="rs-total">
        <text class="rs-total-text">{{ totalReviews }}条评价</text>
      </view>
    </view>

    <view class="filter-tabs">
      <view
        v-for="(tab, ti) in reviewTabs"
        :key="ti"
        class="filter-tab"
        :class="{ active: activeTab === tab.key }"
        @click="switchTab(tab)"
      >
        <text>{{ tab.label }}</text>
      </view>
    </view>

    <scroll-view
      class="review-list"
      scroll-y
      :refresher-enabled="true"
      :refresher-triggered="isRefreshing"
      @refresherrefresh="onRefresh"
      @scrolltolower="loadMore"
      :enhanced="true"
      :bounces="false"
    >
      <view
        v-for="(review, ri) in reviewList"
        :key="ri"
        class="review-card"
      >
        <view class="review-user">
          <image :src="review.avatar || '/static/images/tabbar/我的.png'" class="review-avatar" mode="aspectFill"></image>
          <view class="review-user-info">
            <view class="review-name-row">
              <text class="review-nickname">{{ review.nickname }}</text>
              <view class="review-badge" v-if="review.isVip">
                <text>VIP</text>
              </view>
            </view>
            <uni-rate :value="review.score" readonly size="20" active-color="#ffc107" inactive-color="#eee" />
          </view>
          <text class="review-time">{{ review.time }}</text>
        </view>
        <text class="review-content">{{ review.content }}</text>
        <view class="review-imgs" v-if="review.images && review.images.length > 0">
          <image
            v-for="(img, ii) in review.images"
            :key="ii"
            :src="img"
            mode="aspectFill"
            class="review-img"
            @click="previewImage(review.images, ii)"
          ></image>
        </view>
        <view class="review-meta">
          <text class="review-charge-type">{{ review.chargeType }}</text>
          <view class="review-actions">
            <view class="review-action" @click="likeReview(ri)">
              <u-icon :name="review.isLiked ? 'heart-fill' : 'heart'" :size="28" :color="review.isLiked ? '#ff4d4f' : '#ccc'"></u-icon>
              <text :class="{ liked: review.isLiked }">{{ review.likeCount > 0 ? review.likeCount : '赞' }}</text>
            </view>
            <view class="review-action" @click="replyReview(review)">
              <u-icon name="chat" size="28" color="#ccc"></u-icon>
              <text>{{ review.replyCount > 0 ? review.replyCount : '回复' }}</text>
            </view>
          </view>
        </view>
      </view>

      <view class="load-more" v-if="reviewList.length > 0">
        <view class="load-status" v-if="loadStatus === 'loading'">
          <text>加载中...</text>
        </view>
        <view class="load-status" v-else-if="loadStatus === 'noMore'">
          <text>— 没有更多评价了 —</text>
        </view>
        <view class="load-status" v-else>
          <text>上拉加载更多</text>
        </view>
      </view>

      <view v-if="!loading && reviewList.length === 0" class="empty-state">
        <u-icon name="chat" size="120" color="#ddd"></u-icon>
        <text class="empty-title">暂无评价</text>
        <text class="empty-desc">成为第一个评价的用户吧</text>
      </view>
    </scroll-view>

    <uni-popup ref="writePopup" type="bottom" :safe-area="true">
      <view class="write-popup">
        <view class="write-header">
          <text class="write-title">写评价</text>
          <u-icon name="close" size="40" color="#999" @click="closeWrite"></u-icon>
        </view>
        <view class="write-score-row">
          <text class="write-score-label">评分</text>
          <uni-rate :value="writeScore" size="36" active-color="#ffc107" @change="onWriteScoreChange" />
        </view>
        <view class="write-input-wrap">
          <textarea
            class="write-input"
            v-model="writeContent"
            placeholder="分享您的充电体验..."
            maxlength="500"
            :auto-height="true"
          />
          <text class="write-count">{{ writeContent.length }}/500</text>
        </view>
        <button class="write-submit" @click="submitReview">提交评价</button>
      </view>
    </uni-popup>
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
      stationId: null,
      stationName: '',
      avgScore: '4.8',
      totalReviews: 128,
      scoreLevels: [
        { label: '5星', percent: 72, count: 92 },
        { label: '4星', percent: 18, count: 23 },
        { label: '3星', percent: 6, count: 8 },
        { label: '2星', percent: 3, count: 4 },
        { label: '1星', percent: 1, count: 1 }
      ],
      reviewTabs: [
        { key: 'all', label: '全部' },
        { key: 'good', label: '好评' },
        { key: 'medium', label: '中评' },
        { key: 'bad', label: '差评' },
        { key: 'image', label: '有图' }
      ],
      activeTab: 'all',
      reviewList: [],
      loading: false,
      isRefreshing: false,
      loadStatus: 'more',
      pageNum: 1,
      pageSize: 10,
      writeScore: 5,
      writeContent: ''
    }
  },

  onLoad(options) {
    this.stationId = options.stationId
    this.stationName = decodeURIComponent(options.name || '充电站')
    this.loadReviews()
  },

  methods: {
    goBack() {
      uni.navigateBack()
    },

    loadReviews(isRefresh = false) {
      if (this.loading) return
      this.loading = true

      setTimeout(() => {
        const mockReviews = this.generateMockReviews()
        if (isRefresh) {
          this.reviewList = mockReviews
          this.pageNum = 1
          this.isRefreshing = false
        } else {
          this.reviewList = [...this.reviewList, ...mockReviews]
        }
        this.loadStatus = this.reviewList.length >= 30 ? 'noMore' : 'more'
        this.loading = false
      }, 500)
    },

    generateMockReviews() {
      const samples = [
        { nickname: '新能源车主', score: 5, time: '2026-05-28', content: '充电速度非常快，120kW的快充桩半小时就充到80%了，环境也很干净整洁，位置好找，下次还会再来！', chargeType: '快充', likeCount: 12, replyCount: 3, isLiked: false, isVip: true, images: [] },
        { nickname: '绿色出行', score: 4, time: '2026-05-27', content: '价格实惠，服务态度好，就是车位有点紧张，高峰期可能需要排队等待。', chargeType: '快充', likeCount: 8, replyCount: 1, isLiked: false, isVip: false, images: [] },
        { nickname: '电动小白', score: 5, time: '2026-05-26', content: '第一次用充电桩，操作很简单，扫码就能充，还有免费停车2小时，太方便了！', chargeType: '慢充', likeCount: 15, replyCount: 5, isLiked: false, isVip: false, images: ['/static/images/tabbar/停车充电服务.png', '/static/images/tabbar/停车充电服务.png'] },
        { nickname: '老司机', score: 3, time: '2026-05-25', content: '价格适中，但部分充电桩维护不太及时，有2个慢充桩显示故障很久了还没修好。', chargeType: '慢充', likeCount: 6, replyCount: 2, isLiked: false, isVip: true, images: [] },
        { nickname: '低碳生活', score: 5, time: '2026-05-24', content: '强烈推荐！24小时营业，晚上来充电还能享受低谷电价，省钱又方便。', chargeType: '快充', likeCount: 22, replyCount: 7, isLiked: false, isVip: false, images: ['/static/images/tabbar/停车充电服务.png'] }
      ]
      return samples.map((s, i) => ({
        ...s,
        id: this.reviewList.length + i + 1,
        avatar: '',
        images: s.images || []
      }))
    },

    switchTab(tab) {
      this.activeTab = tab.key
      this.pageNum = 1
      this.reviewList = []
      this.loadReviews()
    },

    onRefresh() {
      this.isRefreshing = true
      this.pageNum = 1
      this.loadReviews(true)
    },

    loadMore() {
      if (this.loadStatus !== 'more') return
      this.loadStatus = 'loading'
      this.pageNum++
      this.loadReviews()
    },

    likeReview(index) {
      const review = this.reviewList[index]
      review.isLiked = !review.isLiked
      review.likeCount += review.isLiked ? 1 : -1
    },

    replyReview(review) {
      uni.showToast({ title: '回复功能开发中', icon: 'none' })
    },

    writeReview() {
      this.writeScore = 5
      this.writeContent = ''
      if (this.$refs.writePopup) this.$refs.writePopup.open()
    },

    closeWrite() {
      if (this.$refs.writePopup) this.$refs.writePopup.close()
    },

    onWriteScoreChange(e) {
      this.writeScore = e.value
    },

    submitReview() {
      if (!this.writeContent.trim()) {
        uni.showToast({ title: '请输入评价内容', icon: 'none' })
        return
      }
      const newReview = {
        id: Date.now(),
        nickname: '我',
        score: this.writeScore,
        time: new Date().toISOString().slice(0, 10),
        content: this.writeContent,
        chargeType: '快充',
        likeCount: 0,
        replyCount: 0,
        isLiked: false,
        isVip: false,
        images: [],
        avatar: ''
      }
      this.reviewList.unshift(newReview)
      this.totalReviews++
      this.closeWrite()
      uni.showToast({ title: '评价成功', icon: 'success' })
    },

    previewImage(images, index) {
      uni.previewImage({ urls: images, current: index })
    }
  }
}
</script>

<style lang="scss" scoped>
.reviews-page {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background: #f5f6fa;
}

.nav-bar {
  display: flex;
  align-items: center;
  padding: 14rpx 24rpx;
  background: #fff;

  .nav-back {
    width: 60rpx;
    height: 60rpx;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .nav-title {
    flex: 1;
    text-align: center;
    font-size: 32rpx;
    font-weight: 700;
    color: #1a1a1a;
  }

  .nav-right {
    .nav-write {
      width: 60rpx;
      height: 60rpx;
      display: flex;
      align-items: center;
      justify-content: center;
    }
  }
}

.review-summary {
  display: flex;
  align-items: center;
  background: #fff;
  padding: 28rpx 24rpx;
  margin: 16rpx 20rpx;
  border-radius: 16rpx;

  .rs-score {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-right: 32rpx;

    .rs-num {
      font-size: 60rpx;
      font-weight: 800;
      color: #ff6b00;
    }

    .rs-label {
      font-size: 22rpx;
      color: #999;
      margin-top: 4rpx;
    }
  }

  .rs-bars {
    flex: 1;

    .rs-bar-row {
      display: flex;
      align-items: center;
      margin-bottom: 6rpx;

      .rs-bar-label {
        font-size: 20rpx;
        color: #999;
        width: 36rpx;
      }

      .rs-bar-track {
        flex: 1;
        height: 8rpx;
        background: #f0f0f0;
        border-radius: 4rpx;
        margin: 0 8rpx;
        overflow: hidden;

        .rs-bar-fill {
          height: 100%;
          background: linear-gradient(90deg, #ffc107, #ff9800);
          border-radius: 4rpx;
        }
      }

      .rs-bar-num {
        font-size: 20rpx;
        color: #999;
        width: 30rpx;
        text-align: right;
      }
    }
  }

  .rs-total {
    margin-left: 20rpx;

    .rs-total-text {
      font-size: 22rpx;
      color: #07c160;
      white-space: nowrap;
    }
  }
}

.filter-tabs {
  display: flex;
  padding: 0 20rpx 12rpx;
  gap: 12rpx;

  .filter-tab {
    padding: 10rpx 28rpx;
    font-size: 24rpx;
    color: #666;
    background: #fff;
    border-radius: 28rpx;

    &.active {
      color: #07c160;
      background: #e8f8ee;
      font-weight: 500;
    }
  }
}

.review-list {
  flex: 1;
  padding: 0 20rpx 40rpx;
}

.review-card {
  background: #fff;
  border-radius: 16rpx;
  padding: 24rpx 24rpx 16rpx;
  margin-bottom: 16rpx;

  .review-user {
    display: flex;
    align-items: center;

    .review-avatar {
      width: 56rpx;
      height: 56rpx;
      border-radius: 50%;
      background: #f0f0f0;
      margin-right: 12rpx;
      flex-shrink: 0;
    }

    .review-user-info {
      flex: 1;

      .review-name-row {
        display: flex;
        align-items: center;
        gap: 8rpx;

        .review-nickname {
          font-size: 26rpx;
          color: #333;
          font-weight: 500;
        }

        .review-badge {
          padding: 0 10rpx;
          height: 28rpx;
          line-height: 28rpx;
          background: linear-gradient(135deg, #ff6b00, #ffa940);
          border-radius: 4rpx;

          text {
            font-size: 18rpx;
            color: #fff;
            font-weight: 600;
          }
        }
      }
    }

    .review-time {
      font-size: 20rpx;
      color: #bbb;
      flex-shrink: 0;
    }
  }

  .review-content {
    font-size: 26rpx;
    color: #444;
    line-height: 1.7;
    margin-top: 14rpx;
    display: block;
  }

  .review-imgs {
    display: flex;
    gap: 12rpx;
    margin-top: 14rpx;
    flex-wrap: wrap;

    .review-img {
      width: 180rpx;
      height: 180rpx;
      border-radius: 10rpx;
      background: #f5f5f5;
    }
  }

  .review-meta {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: 16rpx;
    padding-top: 16rpx;
    border-top: 1rpx solid #f5f5f5;

    .review-charge-type {
      font-size: 20rpx;
      color: #999;
      padding: 4rpx 14rpx;
      background: #f5f6fa;
      border-radius: 4rpx;
    }

    .review-actions {
      display: flex;
      gap: 24rpx;

      .review-action {
        display: flex;
        align-items: center;
        gap: 6rpx;

        text {
          font-size: 22rpx;
          color: #999;

          &.liked {
            color: #ff4d4f;
          }
        }
      }
    }
  }
}

.load-more {
  padding: 24rpx 0 60rpx;

  .load-status {
    display: flex;
    align-items: center;
    justify-content: center;

    text {
      font-size: 24rpx;
      color: #bbb;
    }
  }
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 120rpx;

  .empty-title {
    font-size: 32rpx;
    color: #333;
    font-weight: 500;
    margin-top: 20rpx;
  }

  .empty-desc {
    font-size: 24rpx;
    color: #aaa;
    margin-top: 12rpx;
  }
}

.write-popup {
  background: #fff;
  border-radius: 24rpx 24rpx 0 0;
  padding: 32rpx 32rpx 60rpx;

  .write-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 24rpx;

    .write-title {
      font-size: 34rpx;
      font-weight: 700;
      color: #1a1a1a;
    }
  }

  .write-score-row {
    display: flex;
    align-items: center;
    gap: 16rpx;
    margin-bottom: 24rpx;

    .write-score-label {
      font-size: 26rpx;
      color: #555;
    }
  }

  .write-input-wrap {
    position: relative;
    margin-bottom: 24rpx;

    .write-input {
      width: 100%;
      min-height: 200rpx;
      background: #f5f6fa;
      border-radius: 12rpx;
      padding: 20rpx;
      font-size: 26rpx;
      color: #333;
      box-sizing: border-box;
    }

    .write-count {
      position: absolute;
      bottom: 16rpx;
      right: 16rpx;
      font-size: 22rpx;
      color: #bbb;
    }
  }

  .write-submit {
    width: 100%;
    height: 80rpx;
    line-height: 80rpx;
    background: linear-gradient(135deg, #07c160, #06ad56);
    color: #fff;
    font-size: 30rpx;
    font-weight: 600;
    border-radius: 40rpx;
    border: none;
  }
}
</style>