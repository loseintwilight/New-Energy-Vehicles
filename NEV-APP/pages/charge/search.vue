<template>
  <view class="search-page">
    <charge-header />
    <view class="search-bar">
      <view class="search-back" @click="goBack">
        <u-icon name="arrow-left" size="36" color="#333"></u-icon>
      </view>
      <input
        class="search-input"
        v-model="keyword"
        :focus="autoFocus"
        placeholder="搜索充电站、目的地"
        placeholder-style="color: #bfbfbf; font-size: 26rpx;"
        @confirm="doSearch"
        @input="onInput"
      />
      <view class="search-cancel" @click="goBack">
        <text>取消</text>
      </view>
    </view>

    <view v-if="!searched && !showSuggest" class="search-init">
      <view class="smart-recommend">
        <view class="section-header">
          <text class="section-title">智能推荐</text>
          <u-icon name="reload" size="26" color="#999" @click="refreshRecommend"></u-icon>
        </view>
        <scroll-view scroll-x class="recommend-scroll" :show-scrollbar="false">
          <view
            v-for="(rec, ri) in recommendList"
            :key="ri"
            class="recommend-card"
            @click="selectRecommend(rec)"
          >
            <view class="rec-icon-wrap" :style="{ background: rec.bgColor }">
              <u-icon :name="rec.icon" size="36" :color="rec.iconColor"></u-icon>
            </view>
            <text class="rec-name">{{ rec.name }}</text>
            <text class="rec-desc">{{ rec.desc }}</text>
          </view>
        </scroll-view>
      </view>

      <view class="history-section">
        <view class="section-header">
          <text class="section-title">搜索历史</text>
          <view class="history-actions">
            <text class="history-clear" @click="clearHistory" v-if="historyList.length > 0">清空</text>
          </view>
        </view>

        <view class="history-tags" v-if="historyList.length > 0">
          <text
            v-for="(h, hi) in historyList"
            :key="hi"
            class="history-tag"
            @click="doSearchWithKeyword(h)"
          >{{ h }}</text>
        </view>

        <view class="history-empty" v-else>
          <text class="empty-text">暂无搜索记录</text>
        </view>
      </view>

      <view class="hot-section">
        <view class="section-header">
          <text class="section-title">热门搜索</text>
        </view>
        <view class="hot-grid">
          <view
            v-for="(hot, hi) in hotList"
            :key="hi"
            class="hot-item"
            @click="doSearchWithKeyword(hot.name)"
          >
            <view class="hot-rank" :class="'rank-' + Math.min(hi + 1, 3)">{{ hi + 1 }}</view>
            <text class="hot-name">{{ hot.name }}</text>
            <text class="hot-count">{{ hot.count }}次搜索</text>
          </view>
        </view>
      </view>
    </view>

    <scroll-view
      v-if="searched"
      class="search-results"
      scroll-y
      @scrolltolower="loadMoreResults"
      :refresher-enabled="true"
      :refresher-triggered="isRefreshing"
      @refresherrefresh="onRefresh"
    >
      <view class="results-header">
        <text class="results-count">找到 {{ resultList.length }} 个充电站</text>
        <view class="results-actions">
          <view class="result-view-mode" @click="toggleViewMode">
            <u-icon :name="viewMode === 'list' ? 'list' : 'map'" size="28" color="#666"></u-icon>
          </view>
        </view>
      </view>

      <view
        v-for="(result, ri) in resultList"
        :key="ri"
        class="result-card"
        @click="goDetail(result)"
      >
        <view class="rc-left">
          <text class="rc-distance">{{ result.distance }}km</text>
          <view class="rc-distance-bar">
            <view class="rc-distance-fill" :style="{ width: Math.min(result.distance / 20 * 100, 100) + '%' }"></view>
          </view>
        </view>
        <view class="rc-body">
          <view class="rc-header">
            <text class="rc-name">{{ result.name }}</text>
            <text class="rc-price">¥{{ result.price }}/度</text>
          </view>
          <view class="rc-tags">
            <text
              v-for="(tag, ti) in result.tags"
              :key="ti"
              class="rc-tag"
              :class="'tag-' + tag.type"
            >{{ tag.text }}</text>
          </view>
          <view class="rc-meta">
            <text class="rc-address">{{ result.address }}</text>
            <view class="rc-status" :class="{ free: result.freePiles > 0 }">
              <view class="rc-status-dot"></view>
              <text>{{ result.statusText }}</text>
            </view>
          </view>
          <view class="rc-highlight" v-if="result.matchReason">
            <u-icon name="map-fill" size="22" color="#fa8c16"></u-icon>
            <text>{{ result.matchReason }}</text>
          </view>
        </view>
      </view>

      <view class="results-footer" v-if="loadStatus === 'noMore'">
        <text>— 已经显示全部结果 —</text>
      </view>
    </scroll-view>

    <view v-if="showSuggest && keyword.length > 0" class="suggest-list">
      <view
        v-for="(s, si) in suggestList"
        :key="si"
        class="suggest-item"
        @click="selectSuggest(s)"
      >
        <u-icon name="search" size="28" color="#bbb"></u-icon>
        <view class="suggest-content">
          <text class="suggest-name" v-html="highlightMatch(s.name)"></text>
          <text class="suggest-address">{{ s.address }}</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
import { searchStations, getHotSearches, getSuggestions } from '@/api/charge/station.js'
import safeAreaMixin from '@/mixins/safe-area.js'
import ChargeHeader from '@/components/charge-header/charge-header.vue'

export default {
  mixins: [safeAreaMixin],
  components: { ChargeHeader },
  data() {
    return {
      keyword: '',
      autoFocus: true,
      searched: false,
      showSuggest: false,
      viewMode: 'list',
      loading: false,
      isRefreshing: false,
      loadStatus: 'more',

      resultList: [],
      searchParams: { pageNum: 1, pageSize: 10, lat: 36.548, lng: 116.801 },

      historyList: [],
      hotList: [],
      suggestList: [],
      suggestTimer: null,
      recommendList: [
        { icon: 'map-fill', name: '附近最近', desc: '距离优先', bgColor: '#e8f8ee', iconColor: '#07c160' },
        { icon: 'star-fill', name: '价格最低', desc: '省钱首选', bgColor: '#fff7e6', iconColor: '#fa8c16' },
        { icon: 'car', name: '快充站点', desc: '极速充电', bgColor: '#e6f7ff', iconColor: '#1890ff' },
        { icon: 'star-fill', name: '高评分站', desc: '品质保障', bgColor: '#fff0f6', iconColor: '#eb2f96' }
      ],
    }
  },

  onLoad() {
    this.loadHistory()
    this.loadHotSearches()
    this.initLocation()
  },

  methods: {
    initLocation() {
      // 获取用户当前位置（来自 Sensor 面板或真实 GPS），替换硬编码坐标
      uni.getLocation({
        type: 'gcj02',
        timeout: 10000,
        success: (res) => {
          this.searchParams.lat = res.latitude
          this.searchParams.lng = res.longitude
          console.log('[search] 获取到位置:', res.latitude, res.longitude)
        },
        fail: (e) => {
          console.log('[search] 定位失败，使用默认坐标:', e.errMsg || e)
        }
      })
    },
    loadHistory() {
      const saved = uni.getStorageSync('searchHistory')
      this.historyList = saved || []
    },

    async loadHotSearches() {
      try {
        const res = await getHotSearches()
        this.hotList = res.data || []
      } catch (e) {
        this.hotList = []
      }
    },

    async loadSuggestions(keyword) {
      if (!keyword || keyword.trim().length === 0) {
        this.suggestList = []
        return
      }
      try {
        const res = await getSuggestions(keyword)
        this.suggestList = res.data || []
      } catch (e) {
        this.suggestList = []
      }
    },

    saveHistory(keyword) {
      if (!keyword.trim()) return
      let list = [keyword, ...this.historyList.filter(h => h !== keyword)]
      if (list.length > 10) list = list.slice(0, 10)
      this.historyList = list
      uni.setStorageSync('searchHistory', list)
    },

    clearHistory() {
      uni.showModal({
        title: '确认清空',
        content: '确定清空所有搜索历史吗？',
        success: (res) => {
          if (res.confirm) {
            this.historyList = []
            uni.setStorageSync('searchHistory', [])
            uni.showToast({ title: '已清空', icon: 'success' })
          }
        }
      })
    },

    onInput(e) {
      const val = e.detail.value
      this.keyword = val
      if (val.length > 0) {
        this.showSuggest = true
        this.searched = false
        // 防抖获取联想建议
        if (this.suggestTimer) clearTimeout(this.suggestTimer)
        this.suggestTimer = setTimeout(() => {
          this.loadSuggestions(val)
        }, 300)
      } else {
        this.showSuggest = false
        this.searched = false
        this.suggestList = []
      }
    },

    doSearch() {
      if (!this.keyword.trim()) {
        uni.showToast({ title: '请输入搜索关键词', icon: 'none' })
        return
      }

      this.searched = true
      this.showSuggest = false
      this.saveHistory(this.keyword)
      this.searchParams.pageNum = 1
      this.resultList = []
      this.fetchResults()
    },

    doSearchWithKeyword(keyword) {
      this.keyword = keyword
      this.doSearch()
    },

    selectSuggest(s) {
      this.keyword = s.name
      this.doSearch()
    },

    selectRecommend(rec) {
      this.keyword = rec.name
      this.doSearch()
    },

    async fetchResults(isRefresh = false) {
      if (this.loading && !isRefresh) return
      this.loading = true

      try {
        const res = await searchStations({
          ...this.searchParams,
          keyword: this.keyword
        })
        const list = res.data?.rows || res.rows || []

        if (isRefresh) {
          this.resultList = list
          this.isRefreshing = false
        } else {
          this.resultList = [...this.resultList, ...list]
        }

        this.loadStatus = list.length < this.searchParams.pageSize ? 'noMore' : 'more'
      } catch (e) {
        if (isRefresh) this.isRefreshing = false
        console.log('[fetchResults] API失败，使用兜底数据:', e)
        this.loadMockResults()
      }

      this.loading = false
    },

    loadMockResults() {
      const mockResults = [
        {
          stationId: 2001, name: '济南西站充电站', address: '济南市槐荫区日照路',
          distance: '6.7', price: '1.35', freePiles: 8, statusText: '空闲',
          lat: 36.668, lng: 116.896,
          tags: [{ text: '快充', type: 'blue' }, { text: '免费停车', type: 'orange' }],
          matchReason: '距您搜索的"济南西站"约200米'
        },
        {
          stationId: 2002, name: '济南西站公共充电站', address: '济南西站停车场B2层',
          distance: '6.8', price: '1.28', freePiles: 5, statusText: '空闲',
          lat: 36.670, lng: 116.898,
          tags: [{ text: '快充', type: 'blue' }, { text: '24小时', type: 'gray' }],
          matchReason: '位于济南西站内'
        },
        {
          stationId: 2003, name: '济南西部新城充电站', address: '济南市槐荫区青岛路',
          distance: '8.2', price: '1.18', freePiles: 12, statusText: '空闲',
          lat: 36.680, lng: 116.910,
          tags: [{ text: '慢充', type: 'purple' }, { text: '夜间优惠', type: 'green' }],
          matchReason: '相关推荐'
        },
        {
          stationId: 2004, name: '济南市图书馆充电站', address: '济南市槐荫区经六路',
          distance: '9.1', price: '1.42', freePiles: 3, statusText: '较紧张',
          lat: 36.650, lng: 116.920,
          tags: [{ text: '快充', type: 'blue' }],
          matchReason: ''
        }
      ]
      this.resultList = mockResults
      this.loadStatus = 'noMore'
    },

    loadMoreResults() {
      if (this.loadStatus !== 'more') return
      this.loadStatus = 'loading'
      this.searchParams.pageNum++
      this.fetchResults()
    },

    onRefresh() {
      this.isRefreshing = true
      this.searchParams.pageNum = 1
      this.fetchResults(true)
    },

    toggleViewMode() {
      uni.showToast({ title: '视图切换开发中', icon: 'none' })
    },

    refreshRecommend() {
      uni.showToast({ title: '推荐已更新', icon: 'none' })
    },

    goDetail(station) {
      uni.navigateTo({
        url: `/pages/charge/detail?stationId=${station.stationId}&name=${encodeURIComponent(station.name)}&lat=${station.lat}&lng=${station.lng}`
      })
    },

    goBack() {
      uni.navigateBack()
    },

    highlightMatch(text) {
      if (!this.keyword || !text) return text
      const idx = text.indexOf(this.keyword)
      if (idx === -1) return text
      return text.slice(0, idx) + '<text style="color:#07c160">' + text.slice(idx, idx + this.keyword.length) + '</text>' + text.slice(idx + this.keyword.length)
    }
  }
}
</script>

<style lang="scss" scoped>
.search-page {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background: #fff;
}

.search-bar {
  display: flex;
  align-items: center;
  padding: 16rpx 20rpx;
  background: #fff;

  .search-back {
    width: 56rpx;
    height: 56rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
  }

  .search-input {
    flex: 1;
    height: 68rpx;
    background: #f2f3f7;
    border-radius: 34rpx;
    padding: 0 32rpx;
    font-size: 26rpx;
    color: #333;
  }

  .search-cancel {
    margin-left: 16rpx;
    flex-shrink: 0;

    text {
      font-size: 28rpx;
      color: #666;
    }
  }
}

.smart-recommend {
  padding: 20rpx 0 12rpx;

  .section-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 20rpx 16rpx;

    .section-title {
      font-size: 28rpx;
      font-weight: 700;
      color: #1a1a1a;
    }
  }

  .recommend-scroll {
    white-space: nowrap;
    padding: 0 20rpx;

    .recommend-card {
      display: inline-flex;
      flex-direction: column;
      align-items: center;
      width: 160rpx;
      margin-right: 20rpx;
      padding: 20rpx 0;
      background: #fafafa;
      border-radius: 16rpx;

      .rec-icon-wrap {
        width: 72rpx;
        height: 72rpx;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 10rpx;
      }

      .rec-name {
        font-size: 24rpx;
        font-weight: 600;
        color: #333;
      }

      .rec-desc {
        font-size: 20rpx;
        color: #bbb;
        margin-top: 4rpx;
      }
    }
  }
}

.history-section {
  padding: 20rpx 20rpx;

  .section-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 16rpx;

    .section-title {
      font-size: 28rpx;
      font-weight: 700;
      color: #1a1a1a;
    }

    .history-actions {
      .history-clear {
        font-size: 24rpx;
        color: #999;
      }
    }
  }

  .history-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 16rpx;

    .history-tag {
      padding: 12rpx 24rpx;
      background: #f5f6fa;
      border-radius: 20rpx;
      font-size: 24rpx;
      color: #555;
    }
  }

  .history-empty {
    padding: 40rpx 0;
    text-align: center;

    .empty-text {
      font-size: 24rpx;
      color: #ccc;
    }
  }
}

.hot-section {
  padding: 0 20rpx 40rpx;

  .section-header {
    padding: 12rpx 0 16rpx;

    .section-title {
      font-size: 28rpx;
      font-weight: 700;
      color: #1a1a1a;
    }
  }

  .hot-grid {
    .hot-item {
      display: flex;
      align-items: center;
      padding: 20rpx 0;
      border-bottom: 1rpx solid #f9f9f9;

      .hot-rank {
        width: 36rpx;
        height: 36rpx;
        line-height: 36rpx;
        text-align: center;
        border-radius: 6rpx;
        font-size: 22rpx;
        font-weight: 700;
        color: #999;
        background: #f5f5f5;
        margin-right: 16rpx;

        &.rank-1 { color: #fff; background: linear-gradient(135deg, #ff4d4f, #ff7875); }
        &.rank-2 { color: #fff; background: linear-gradient(135deg, #fa8c16, #ffa940); }
        &.rank-3 { color: #fff; background: linear-gradient(135deg, #1890ff, #40a9ff); }
      }

      .hot-name {
        flex: 1;
        font-size: 28rpx;
        color: #333;
      }

      .hot-count {
        font-size: 20rpx;
        color: #bbb;
      }
    }
  }
}

.search-results {
  flex: 1;
  padding: 20rpx;
}

.results-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20rpx;

  .results-count {
    font-size: 24rpx;
    color: #888;
  }

  .results-actions {
    .result-view-mode {
      width: 56rpx;
      height: 56rpx;
      display: flex;
      align-items: center;
      justify-content: center;
    }
  }
}

.result-card {
  display: flex;
  background: #f8f9fc;
  border-radius: 16rpx;
  margin-bottom: 16rpx;
  overflow: hidden;

  .rc-left {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    width: 100rpx;
    background: #f0f2f5;
    padding: 16rpx 0;

    .rc-distance {
      font-size: 32rpx;
      font-weight: 800;
      color: #07c160;
    }

    .rc-distance-bar {
      width: 40rpx;
      height: 4rpx;
      background: rgba(7, 193, 96, 0.2);
      border-radius: 2rpx;
      margin-top: 8rpx;

      .rc-distance-fill {
        height: 100%;
        background: #07c160;
        border-radius: 2rpx;
      }
    }
  }

  .rc-body {
    flex: 1;
    padding: 20rpx 20rpx 16rpx;

    .rc-header {
      display: flex;
      align-items: center;
      justify-content: space-between;

      .rc-name {
        font-size: 28rpx;
        font-weight: 700;
        color: #1a1a1a;
        flex: 1;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        margin-right: 12rpx;
      }

      .rc-price {
        font-size: 32rpx;
        font-weight: 800;
        color: #ff6b00;
        flex-shrink: 0;
      }
    }

    .rc-tags {
      display: flex;
      flex-wrap: wrap;
      gap: 8rpx;
      margin-top: 10rpx;

      .rc-tag {
        padding: 2rpx 10rpx;
        font-size: 20rpx;
        border-radius: 4rpx;

        &.tag-green { color: #07c160; background: #e8f8ee; }
        &.tag-blue { color: #1890ff; background: #e6f7ff; }
        &.tag-orange { color: #fa8c16; background: #fff7e6; }
        &.tag-purple { color: #722ed1; background: #f9f0ff; }
        &.tag-gray { color: #8c8c8c; background: #fafafa; }
      }
    }

    .rc-meta {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-top: 12rpx;

      .rc-address {
        font-size: 22rpx;
        color: #999;
        flex: 1;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        margin-right: 12rpx;
      }

      .rc-status {
        display: flex;
        align-items: center;
        gap: 4rpx;
        flex-shrink: 0;
        font-size: 22rpx;
        color: #999;

        &.free { color: #07c160; }

        .rc-status-dot {
          width: 10rpx;
          height: 10rpx;
          border-radius: 50%;
          background: currentColor;
        }
      }
    }

    .rc-highlight {
      display: flex;
      align-items: center;
      gap: 6rpx;
      margin-top: 10rpx;
      padding: 8rpx 12rpx;
      background: #fff7e6;
      border-radius: 6rpx;

      text {
        font-size: 20rpx;
        color: #fa8c16;
      }
    }
  }
}

.results-footer {
  text-align: center;
  padding: 24rpx 0;

  text {
    font-size: 24rpx;
    color: #ccc;
  }
}

.suggest-list {
  flex: 1;
  padding: 10rpx 20rpx;

  .suggest-item {
    display: flex;
    align-items: center;
    padding: 24rpx 0;
    border-bottom: 1rpx solid #f9f9f9;

    .suggest-content {
      flex: 1;
      margin-left: 12rpx;

      .suggest-name {
        font-size: 28rpx;
        color: #333;
        display: block;
      }

      .suggest-address {
        font-size: 22rpx;
        color: #bbb;
        margin-top: 6rpx;
        display: block;
      }
    }
  }
}
</style>