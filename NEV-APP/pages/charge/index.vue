<template>
  <view class="charge-page">
    <charge-header title="充电服务" />
    <view class="search-bar" :style="{ paddingRight: px2rpx(systemInfo.windowWidth - capsuleRight + 6) + 'rpx' }">
      <view class="sb-left">
      </view>
      <view class="sb-center">
        <view class="city-selector" @click="goCitySelect">
          <text class="city-name">{{ currentCity }}</text>
          <u-icon name="arrow-down-fill" size="20" color="#666"></u-icon>
        </view>
        <view class="search-input" @click="goSearch">
          <u-icon name="search" size="28" color="#bbb"></u-icon>
          <text class="search-placeholder">搜索充电站、目的地</text>
        </view>
      </view>
      <view class="sb-right">
        <view class="icon-btn" @click="goNotice">
          <u-icon name="bell" size="36" color="#333"></u-icon>
          <view v-if="noticeCount > 0" class="badge">
            <text>{{ noticeCount > 99 ? '99+' : noticeCount }}</text>
          </view>
        </view>
      </view>
    </view>

    <view class="map-container">
      <map
        id="chargeMap"
        class="charge-map"
        :latitude="mapCenter.lat"
        :longitude="mapCenter.lng"
        :scale="15"
        :show-location="true"
        :markers="mapMarkers"
        :enable-scroll="true"
        :enable-zoom="true"
        :enable-3D="true"
        @markertap="onMarkerTap"
        @regionchange="onMapMove"
      ></map>

      <view class="map-controls">
        <view class="ctrl-btn switch-loc-btn" @click="openLocationPicker">
          <image class="switch-loc-icon" src="/static/images/charge/修改定位.png" mode="aspectFit"></image>
        </view>
        <view class="ctrl-btn" @click="reLocate">
          <u-icon name="map" size="36" color="#07c160"></u-icon>
        </view>
      </view>
    </view>

    <scroll-view class="filter-bar" scroll-x enable-flex :show-scrollbar="false">
      <view
        v-for="(item, index) in filterTabs"
        :key="index"
        class="filter-tag"
        :class="{ active: activeFilter === item.key }"
        @click="onFilterChange(item)"
      >
        <text>{{ item.label }}</text>
        <u-icon v-if="item.hasDropdown" name="arrow-down" size="22" :color="activeFilter === item.key ? '#07c160' : '#999'" style="margin-left:4rpx"></u-icon>
      </view>
    </scroll-view>

    <view class="sort-bar">
      <view
        v-for="(s, i) in sortOptions"
        :key="i"
        class="sort-item"
        :class="{ active: currentSort === s.key }"
        @click="onSortChange(s)"
      >
        <text>{{ s.label }}</text>
        <view class="sort-arrows" v-if="s.key !== 'default'">
          <u-icon name="arrow-up" size="18" :color="currentSort === s.key && sortOrder === 'asc' ? '#07c160' : '#ccc'"></u-icon>
          <u-icon name="arrow-down" size="18" :color="currentSort === s.key && sortOrder === 'desc' ? '#07c160' : '#ccc'" style="margin-top:-6rpx"></u-icon>
        </view>
      </view>
    </view>

    <scroll-view
      class="station-list"
      scroll-y
      @scrolltolower="loadMore"
      :refresher-enabled="true"
      :refresher-triggered="isRefreshing"
      @refresherrefresh="onRefresh"
      :enhanced="true"
      :bounces="false"
      :style="{ paddingBottom: (16 + safeBottom) + 'px' }"
    >
      <view
        v-for="(station, idx) in stationList"
        :key="idx"
        class="station-card"
        :class="{ 'card-highlight': station.isNearest }"
        @click="goDetail(station)"
      >
        <view class="card-top">
          <view class="card-left">
            <image
              class="station-img"
              :src="station.imageUrl || '/static/images/tabbar/停车充电服务.png'"
              mode="aspectFill"
              lazy-load
            ></image>
            <view class="img-badge" v-if="station.isNearest">
              <text>最近</text>
            </view>
          </view>

          <view class="card-body">
            <view class="card-header">
              <text class="station-name">{{ station.name }}</text>
              <view v-if="station.discount > 0" class="discount-tag">
                <text>省¥{{ station.discount }}</text>
              </view>
            </view>

            <view class="tag-row">
              <text
                v-for="(tag, ti) in station.tags"
                :key="ti"
                class="station-tag"
                :class="'tag-' + tag.type"
              >{{ tag.text }}</text>
              <text v-if="station.plugAndPlay" class="mini-tag plug-tag">即插即充</text>
              <text v-if="station.selfService" class="mini-tag self-tag">自助</text>
            </view>

            <view class="info-row">
              <text class="info-item">
                <u-icon name="navigation" size="24" color="#333"></u-icon>
                距您{{ station.distance }}km
              </text>
              <text class="info-item">
                <u-icon name="wifi" size="24" color="#07c160"></u-icon>
                {{ station.lastChargeTime }}
              </text>
            </view>

          </view>
        </view>

        <view class="price-row">
          <view class="price-info">
            <view class="price-main">
              <text class="price-num">{{ station.price }}</text>
              <text class="price-unit">元/度 起(含服务费)</text>
              <u-icon name="info-circle" size="18" color="#ccc" style="margin-left:4rpx"></u-icon>
            </view>
          </view>

          <view class="status-box">
            <view class="speed-badge" :class="'speed-' + station.speedTypeKey">
              <text>{{ station.speedType }}</text>
            </view>
            <text class="pile-status-text" :class="{ free: station.freePiles > 0 }">
              {{ station.statusText }}
            </text>
          </view>
        </view>

        <view class="park-row-bottom">
          <image class="park-icon-b" src="/static/images/charge/停车场.png" mode="aspectFit"></image>
          <text class="park-text-b">{{ station.parkInfo || '免费' }}</text>
        </view>

      </view>

      <view class="load-more-area" v-if="stationList.length > 0">
        <view v-if="loadStatus === 'loading'" class="loading-row">
          <text class="load-text">加载中...</text>
        </view>
        <view v-else-if="loadStatus === 'noMore'" class="nomore-row">
          <view class="nomore-line"></view>
          <text class="nomore-text">— 已经到底了 —</text>
          <view class="nomore-line"></view>
        </view>
        <view v-else class="more-hint">
          <text>上拉加载更多</text>
        </view>
      </view>

      <view v-if="!loading && stationList.length === 0" class="empty-state">
        <view class="empty-img-wrap">
          <u-icon name="map" size="120" color="#ddd"></u-icon>
        </view>
        <text class="empty-title">附近暂无充电站</text>
        <text class="empty-desc">试试调整筛选条件或扩大搜索范围</text>
        <button class="empty-btn" @click="resetFilter">重置筛选</button>
      </view>
    </scroll-view>

    <uni-popup ref="pricePopup" type="center">
      <view class="price-tip-popup">
        <text class="popup-title">价格说明</text>
        <view class="tip-content">
          <view class="tip-row"><text class="t-label">电费单价</text><text class="t-val">¥{{ priceTipData.electric || '0.88' }}/度</text></view>
          <view class="tip-row"><text class="t-label">服务费</text><text class="t-val">¥{{ priceTipData.service || '0.40' }}/度</text></view>
          <view class="tip-divider"></view>
          <view class="tip-row total-row"><text class="t-label">合计</text><text class="t-val highlight">¥{{ priceTipData.total || '1.28' }}/度</text></view>
        </view>
        <text class="popup-note">* 价格可能因时段浮动，以实际结算为准</text>
        <button class="popup-close-btn" @click="closePricePopup">我知道了</button>
      </view>
    </uni-popup>

    <uni-popup ref="filterPopup" type="bottom" :safe-area="true">
      <view class="filter-panel">
        <view class="filter-header">
          <text class="filter-cancel" @click="resetMoreFilter">重置</text>
          <text class="filter-title">更多筛选</text>
          <text class="filter-confirm" @click="applyMoreFilter">确定</text>
        </view>
        <view class="filter-body">
          <view class="filter-section">
            <text class="filter-section-title">服务设施</text>
            <view class="filter-options">
              <view
                v-for="(opt, oi) in moreFilterOptions"
                :key="oi"
                class="filter-option"
                :class="{ selected: opt.selected }"
                @click="toggleMoreFilter(opt.key)"
              >
                <text>{{ opt.label }}</text>
              </view>
            </view>
          </view>
        </view>
      </view>
    </uni-popup>

    <uni-popup ref="locationPopup" type="center">
      <view class="loc-picker-popup">
        <text class="popup-title">修改当前位置</text>

        <picker mode="region" :value="selectedRegion" @change="onRegionChange">
          <view class="loc-region-picker">
            <u-icon name="map" size="32" color="#1989fa"></u-icon>
            <text v-if="regionText" class="region-text">{{ regionText }}</text>
            <text v-else class="region-placeholder">请选择省 / 市 / 区</text>
            <u-icon name="arrow-right" size="24" color="#999"></u-icon>
          </view>
        </picker>

        <input
          class="loc-addr-input"
          v-model="locationSearchKey"
          placeholder="输入街道/门牌号/地标名称，如：大学路3501号"
          @confirm="searchLocation"
        />

        <view class="loc-btn-row">
          <button class="loc-btn-primary" @click="searchLocation" :disabled="!canSearch">
            <u-icon name="search" size="28" color="#fff"></u-icon>
            <text>搜索</text>
          </button>
          <button class="loc-btn-secondary" @click="pickLocationOnMap">
            <u-icon name="map" size="28" color="#1989fa"></u-icon>
            <text>地图选点</text>
          </button>
        </view>

        <view v-if="searchingAddr" class="loc-status">
          <u-icon name="reload" size="28" color="#999"></u-icon>
          <text>搜索中...</text>
        </view>
        <view v-else-if="searchedAddr && searchResults.length > 0" class="loc-status">
          <text>搜索结果</text>
        </view>
        <scroll-view class="loc-city-list" scroll-y>
          <view
            v-for="(item, idx) in searchResults"
            :key="idx"
            class="loc-city-item"
            @click="selectSearchResult(item)"
          >
            <view class="city-info">
              <text class="city-name-text">{{ item.name }}</text>
              <text class="city-desc">{{ item.address }}</text>
            </view>
          </view>
          <view v-if="searchedAddr && searchResults.length === 0 && !searchingAddr" class="loc-empty">
            <text>未找到匹配的地址，请尝试更详细的地址</text>
          </view>
        </scroll-view>
        <button class="popup-close-btn" @click="closeLocationPicker">关闭</button>
      </view>
    </uni-popup>
  </view>
</template>

<script>
import { getStationList } from '../../api/charge/station.js'
import safeAreaMixin from '@/mixins/safe-area.js'
import amap from '@/utils/amap.js'

export default {
  mixins: [safeAreaMixin],
  data() {
    return {
      systemInfo: uni.getSystemInfoSync(),
      loading: false,
      isRefreshing: false,
      loadStatus: 'more',
      locating: true,
      locationReady: false,
      currentCity: uni.getStorageSync('selectedCity') || '济南市',
      noticeCount: uni.getStorageSync('unreadNotice') || 3,
      showMoreFilter: false,
      moreFilterOptions: [
        { key: 'freePark', label: '免费停车', selected: false },
        { key: 'highway', label: '高速路站', selected: false },
        { key: 'discount', label: '优惠活动', selected: false },
        { key: 'plugAndPlay', label: '即插即充', selected: false },
        { key: 'selfService', label: '自助服务', selected: false },
        { key: '24h', label: '24小时营业', selected: false }
      ],
      noticeList: [
        { id: 1, title: '系统通知', content: '济南东站充电站已上线，新站充电享8折优惠！', time: '2026-05-28 14:30', read: false },
        { id: 2, title: '优惠提醒', content: '您有2张限时活动券即将过期，请尽快使用', time: '2026-05-28 10:00', read: false },
        { id: 3, title: '充电提醒', content: '您的爱车已充电完成，请及时移车以免产生占位费', time: '2026-05-27 22:15', read: false },
        { id: 4, title: '订单通知', content: '充电订单已完成，本次充电花费 ¥35.60', time: '2026-05-26 18:30', read: true },
        { id: 5, title: '系统通知', content: '夜间错峰充电功能已上线，享受低谷电价更省钱', time: '2026-05-25 09:00', read: true }
      ],

      mapCenter: { lat: 36.548, lng: 116.801 },
      mapMarkers: [],
      mapCtx: null,

      filterTabs: [
        { key: 'distance', label: '距离近' },
        { key: 'freePark', label: '免费停车' },
        { key: 'fast', label: '快充优先' },
        { key: 'slow', label: '慢充优先' },
        { key: 'highway', label: '高速路站' },
        { key: 'discount', label: '优惠活动' },
        { key: 'more', label: '更多筛选', hasDropdown: true }
      ],
      activeFilter: 'distance',

      sortOptions: [
        { key: 'default', label: '综合排序' },
        { key: 'distance', label: '距离最近' },
        { key: 'price', label: '价格最低' },
        { key: 'score', label: '评分最高' }
      ],
      currentSort: 'default',
      sortOrder: 'asc',

      stationList: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        lat: 36.548,
        lng: 116.801
      },

      priceTipData: {},

      hotCities: [
        { code: '370100', name: '济南市', lat: 36.6512, lng: 117.1201, desc: '省会' },
        { code: '370200', name: '青岛市', lat: 36.0671, lng: 120.3826, desc: '沿海城市' },
        { code: '370600', name: '烟台市', lat: 37.4645, lng: 121.4479, desc: '沿海城市' },
        { code: '370300', name: '淄博市', lat: 36.8135, lng: 118.0548, desc: '工业城市' },
        { code: '371300', name: '临沂市', lat: 35.1047, lng: 118.3565, desc: '' }
      ],
      locationSearchKey: '',
      searchResults: [],
      searchingAddr: false,
      searchedAddr: false,
      selectedRegion: [],
      regionText: ''
    }
  },

  async onLoad() {
    await this.initLocation()
    this.fetchStationList()
  },

  onShow() {
    this.noticeCount = uni.getStorageSync('unreadNotice') || 0
    const savedCity = uni.getStorageSync('selectedCity')
    if (savedCity && savedCity !== this.currentCity) {
      this.currentCity = savedCity
      this.queryParams.pageNum = 1
      this.stationList = []
      if (!this.locationReady) {
        this.initLocation()
      }
      this.loadMockData()
    }
  },

  onReady() {
    this.mapCtx = uni.createMapContext('chargeMap', this)
    // 分多次调用 moveToLocation，确保地图组件已经拿到GPS蓝点位置
    // show-location=true 会让地图组件自己获取GPS位置显示蓝点
    // moveToLocation() 会把地图中心移动到蓝点位置
    const tryMoveToLocation = (delay) => {
      setTimeout(() => {
        if (this.mapCtx) {
          this.mapCtx.moveToLocation()
        }
      }, delay)
    }
    tryMoveToLocation(400)
    tryMoveToLocation(1000)
    tryMoveToLocation(2000)
  },

  methods: {
    async initLocation() {
      this.locating = true
      try {
        // 优先使用 isHighAccuracy 获取精准GPS
        const pos = await amap.getLocation()
        this.setLocation(pos.latitude, pos.longitude)
        this.locationReady = true
      } catch (e) {
        console.log('[locate] highAccuracy failed:', e.errMsg || e)
        // 退而求其次：不要求高精度，用网络定位
        try {
          const pos = await this.getNetworkLocation()
          this.setLocation(pos.latitude, pos.longitude)
          this.locationReady = true
        } catch (e2) {
          console.log('[locate] networkLocation failed:', e2.errMsg || e2)
          this.locationReady = false
        }
      }
      this.locating = false
    },

    getNetworkLocation() {
      return new Promise((resolve, reject) => {
        uni.getLocation({
          type: 'gcj02',
          timeout: 8000,
          success: (res) => resolve({ latitude: res.latitude, longitude: res.longitude }),
          fail: reject
        })
      })
    },

    setLocation(lat, lng) {
      this.queryParams.lat = lat
      this.queryParams.lng = lng
      this.mapCenter = { lat, lng }
    },

    reLocate() {
      if (this.locating) return
      this.locating = true
      // 先让地图的蓝点自己定位
      if (this.mapCtx) {
        this.mapCtx.moveToLocation()
      }
      // 同时获取GPS坐标用于数据查询和地图中心
      uni.getLocation({
        type: 'gcj02',
        isHighAccuracy: true,
        timeout: 10000,
        success: (res) => {
          this.setLocation(res.latitude, res.longitude)
          this.locationReady = true
          this.queryParams.pageNum = 1
          this.stationList = []
          this.fetchStationList(true)
          this.locating = false
        },
        fail: () => {
          // 尝试不要求高精度
          uni.getLocation({
            type: 'gcj02',
            timeout: 8000,
            success: (res) => {
              this.setLocation(res.latitude, res.longitude)
              this.locationReady = true
              this.queryParams.pageNum = 1
              this.stationList = []
              this.fetchStationList(true)
              this.locating = false
            },
            fail: () => {
              this.locating = false
              // 保持当前地图状态不变，提示用户
              uni.showModal({
                title: '定位失败',
                content: '请确保手机GPS已开启且在室外。您也可以手动搜索当前位置。',
                confirmText: '手动输入地址',
                cancelText: '取消',
                success: (res) => {
                  if (res.confirm) this.openLocationPicker()
                }
              })
            }
          })
        }
      })
    },

    openLocationPicker() {
      this.locationSearchKey = ''
      this.searchResults = []
      this.searchingAddr = false
      this.searchedAddr = false
      this.selectedRegion = []
      this.regionText = ''
      this.$refs.locationPopup.open()
    },

    closeLocationPicker() {
      this.$refs.locationPopup.close()
    },

    onRegionChange(e) {
      this.selectedRegion = e.detail.value
      this.regionText = e.detail.value.join('')
      this.searchResults = []
      this.searchedAddr = false
    },

    async searchLocation() {
      const detail = this.locationSearchKey.trim()
      if (!this.regionText || !detail) return
      const fullAddr = this.regionText + detail
      this.searchingAddr = true
      this.searchedAddr = false
      this.searchResults = []
      try {
        const result = await amap.geocode(fullAddr)
        if (result) {
          this.searchResults = [{
            name: result.address || fullAddr,
            address: result.district || result.city || '',
            lat: result.latitude,
            lng: result.longitude
          }]
        }
      } catch (e) {
        uni.showToast({ title: '搜索失败，请重试', icon: 'none' })
      }
      this.searchingAddr = false
      this.searchedAddr = true
    },

    selectSearchResult(item) {
      if (!item.lat || !item.lng) return
      this.setLocation(item.lat, item.lng)
      // 同时移动蓝点标记
      if (this.mapCtx) {
        this.mapCtx.moveToLocation({ latitude: item.lat, longitude: item.lng })
      }
      this.locationSearchKey = ''
      this.searchResults = []
      this.searchedAddr = false
      this.queryParams.pageNum = 1
      this.stationList = []
      this.$refs.locationPopup.close()
      this.fetchStationList(true)
    },

    pickLocationOnMap() {
      this.$refs.locationPopup.close()
      uni.chooseLocation({
        success: (res) => {
          if (res && res.latitude) {
            this.setLocation(res.latitude, res.longitude)
            if (this.mapCtx) {
              this.mapCtx.moveToLocation({ latitude: res.latitude, longitude: res.longitude })
            }
            if (res.name) {
              this.currentCity = res.name.includes('市') ? res.name.split('市')[0] + '市' :
                res.name.includes('县') ? res.name : this.currentCity
            }
            this.queryParams.pageNum = 1
            this.stationList = []
            this.fetchStationList(true)
          }
        },
        fail: () => {
          // 用户取消，重新打开弹窗
          this.$nextTick(() => this.openLocationPicker())
        }
      })
    },

    toggleMapType() {
      uni.showToast({ title: '卫星地图开发中', icon: 'none' })
    },

    async fetchStationList(isRefresh = false) {
      if (this.loading && !isRefresh) return
      this.loading = true

      try {
        const res = await getStationList(this.queryParams)
        const list = res.rows || []

        if (isRefresh) {
          this.stationList = list
          this.isRefreshing = false
          this.queryParams.pageNum = 1
        } else {
          this.stationList = [...this.stationList, ...list]
        }

        this.loadStatus = list.length < this.queryParams.pageSize ? 'noMore' : 'more'
        this.buildMarkers(this.stationList)
      } catch (e) {
        if (isRefresh) this.isRefreshing = false
        this.loadMockData()
      }

      this.loading = false
    },

    buildMarkers(list) {
      console.log('[DEBUG buildMarkers] 列表首个桩坐标:', list[0]?.lat, list[0]?.lng, '总数:', list.length)
      this.mapMarkers = list.slice(0, 25).map((item, i) => ({
        id: item.stationId || i + 1000,
        latitude: item.lat,
        longitude: item.lng,
        width: 30,
        height: 36,
        callout: {
          content: `¥${item.price}`,
          display: 'ALWAYS',
          fontSize: 11,
          borderRadius: 4,
          padding: 2,
          bgColor: '#ffffff',
          color: '#ff6b00',
          textAlign: 'center'
        }
      }))
    },

    loadMockData() {
      const baseLat = 36.672
      const baseLng = 116.981
      const offsetLat = this.mapCenter.lat - baseLat
      const offsetLng = this.mapCenter.lng - baseLng
      console.log('[DEBUG loadMockData] baseLat:', baseLat, 'baseLng:', baseLng,
        'mapCenter:', this.mapCenter.lat, this.mapCenter.lng,
        'offset:', offsetLat, offsetLng)
      const shiftCoord = (lat, lng) => ({
        lat: lat + offsetLat,
        lng: lng + offsetLng
      })

      const mockStations = [
        {
          stationId: 1001, name: '文常山公园充电站',
          distance: '3.7', price: '0.51', speedType: '快', speedTypeKey: 'fast',
          totalPiles: 17, freePiles: 12, statusText: '闲12/17',
          lastChargeTime: '1天前有人充电',
          tags: [{ text: '车电服务包更优惠', type: 'green' }, { text: '新人券可用', type: 'blue' }],
          plugAndPlay: true, selfService: true, isNearest: true, discount: 0.12, freeParkTime: 2,
          parkInfo: '免费',
          lat: 36.680, lng: 116.990, electricPrice: '0.88', servicePrice: '0.40',
          score: 4.8,
          fastCount: 11, slowCount: 6,
          piles: [
            { number: 'A01', type: '快充', status: 'free', power: '120kW' },
            { number: 'A02', type: '快充', status: 'free', power: '120kW' },
            { number: 'A03', type: '快充', status: 'charging', power: '120kW' },
            { number: 'A04', type: '快充', status: 'free', power: '120kW' },
            { number: 'A05', type: '快充', status: 'free', power: '120kW' },
            { number: 'A06', type: '快充', status: 'charging', power: '120kW' },
            { number: 'A07', type: '快充', status: 'free', power: '120kW' },
            { number: 'A08', type: '快充', status: 'free', power: '120kW' },
            { number: 'B01', type: '慢充', status: 'free', power: '7kW' },
            { number: 'B02', type: '慢充', status: 'fault', power: '7kW' },
            { number: 'B03', type: '慢充', status: 'free', power: '7kW' },
            { number: 'B04', type: '慢充', status: 'charging', power: '7kW' },
            { number: 'B05', type: '慢充', status: 'free', power: '7kW' },
            { number: 'B06', type: '慢充', status: 'free', power: '7kW' },
            { number: 'C01', type: '快充', status: 'free', power: '180kW' },
            { number: 'C02', type: '快充', status: 'free', power: '180kW' },
            { number: 'C03', type: '快充', status: 'charging', power: '180kW' }
          ]
        },
        {
          stationId: 1002, name: '西站公共充电站',
          distance: '6.7', price: '0.88', speedType: '快', speedTypeKey: 'fast',
          totalPiles: 12, freePiles: 8, statusText: '闲8/12',
          lastChargeTime: '10分钟前有人充电',
          tags: [{ text: '免费停车', type: 'orange' }],
          plugAndPlay: true, selfService: false, isNearest: false, discount: 0, freeParkTime: 4,
          parkInfo: '免费停车4小时',
          lat: 36.668, lng: 116.896, electricPrice: '0.95', servicePrice: '0.40',
          score: 4.6,
          piles: [
            { number: 'A01', type: '快充', status: 'free', power: '120kW' },
            { number: 'A02', type: '快充', status: 'charging', power: '120kW' },
            { number: 'A03', type: '快充', status: 'free', power: '120kW' },
            { number: 'A04', type: '快充', status: 'free', power: '120kW' },
            { number: 'B01', type: '慢充', status: 'offline', power: '7kW' },
            { number: 'B02', type: '慢充', status: 'free', power: '7kW' },
            { number: 'B03', type: '慢充', status: 'free', power: '7kW' },
            { number: 'B04', type: '慢充', status: 'charging', power: '7kW' },
            { number: 'B05', type: '慢充', status: 'free', power: '7kW' },
            { number: 'B06', type: '慢充', status: 'free', power: '7kW' },
            { number: 'B07', type: '慢充', status: 'fault', power: '7kW' },
            { number: 'B08', type: '慢充', status: 'free', power: '7kW' }
          ]
        },
        {
          stationId: 1003, name: '软件园充电站',
          distance: '5.1', price: '0.72', speedType: '慢', speedTypeKey: 'slow',
          totalPiles: 16, freePiles: 12, statusText: '闲12/16',
          lastChargeTime: '5分钟前有人充电',
          tags: [{ text: '夜间优惠', type: 'green' }],
          plugAndPlay: false, selfService: true, isNearest: false, discount: 0.20, freeParkTime: 0,
          parkInfo: '收费 5元/小时',
          lat: 36.685, lng: 117.130, electricPrice: '0.78', servicePrice: '0.40',
          score: 4.5,
          piles: this.generatePiles(16, '慢', '7kW')
        },
        {
          stationId: 1004, name: '奥体中心地下停车场充电站',
          distance: '8.2', price: '0.95', speedType: '快', speedTypeKey: 'fast',
          totalPiles: 20, freePiles: 14, statusText: '闲14/20',
          lastChargeTime: '刚刚有人充电',
          tags: [{ text: '24小时', type: 'gray' }, { text: '免费停车2小时', type: 'orange' }],
          plugAndPlay: true, selfService: false, isNearest: false, discount: 0, freeParkTime: 2,
          parkInfo: '免费停车2小时',
          lat: 36.690, lng: 117.120, electricPrice: '1.02', servicePrice: '0.40',
          score: 4.7,
          piles: this.generatePiles(20, '快', '120kW')
        },
        {
          stationId: 1005, name: '万达广场停车场充电站',
          distance: '9.5', price: '1.08', speedType: '快', speedTypeKey: 'fast',
          totalPiles: 10, freePiles: 3, statusText: '闲3/10',
          lastChargeTime: '1小时前有人充电',
          tags: [{ text: '购物满减', type: 'red' }],
          plugAndPlay: true, selfService: false, isNearest: false, discount: 0.30, freeParkTime: 1,
          parkInfo: '收费 8元/小时',
          lat: 36.658, lng: 117.020, electricPrice: '1.15', servicePrice: '0.40',
          score: 4.3,
          piles: this.generatePiles(10, '快', '120kW')
        },
        {
          stationId: 1006, name: '高新万达充电站',
          distance: '12.3', price: '0.82', speedType: '快', speedTypeKey: 'fast',
          totalPiles: 14, freePiles: 9, statusText: '闲9/14',
          lastChargeTime: '18分钟前有人充电',
          tags: [{ text: '车电服务包更优惠', type: 'green' }],
          plugAndPlay: true, selfService: true, isNearest: false, discount: 0.08, freeParkTime: 0,
          parkInfo: '收费 6元/小时',
          lat: 36.700, lng: 117.150, electricPrice: '0.90', servicePrice: '0.40',
          score: 4.4,
          piles: this.generatePiles(14, '快', '120kW')
        },
        {
          stationId: 1007, name: '东站充电站',
          distance: '15.6', price: '0.92', speedType: '快', speedTypeKey: 'fast',
          totalPiles: 24, freePiles: 18, statusText: '闲18/24',
          lastChargeTime: '刚刚有人充电',
          tags: [{ text: '高速路站', type: 'blue' }, { text: '24小时', type: 'gray' }],
          plugAndPlay: true, selfService: false, isNearest: false, discount: 0, freeParkTime: 3,
          parkInfo: '免费停车3小时',
          lat: 36.720, lng: 117.140, electricPrice: '0.98', servicePrice: '0.40'
        }
      ]

      const shifted = mockStations.map(s => {
        const { lat, lng } = shiftCoord(s.lat, s.lng)
        return { ...s, lat, lng }
      })
      this.stationList = this.applySort(this.applyFilter(shifted))
      this.loadStatus = 'noMore'
      this.buildMarkers(shifted)
    },

    generatePiles(count, type, power) {
      const statuses = ['free', 'free', 'free', 'free', 'free', 'charging', 'free', 'fault', 'free', 'offline']
      return Array.from({ length: count }, (_, i) => ({
        number: `${String.fromCharCode(65 + (i % 8))}${String(i + 1).padStart(2, '0')}`,
        type: type === '快' ? '快充' : '慢充',
        status: statuses[i % statuses.length],
        power: power
      }))
    },

    loadMore() {
      if (this.loadStatus !== 'more') return
      this.loadStatus = 'loading'
      this.queryParams.pageNum++
      this.fetchStationList()
    },

    onRefresh() {
      this.isRefreshing = true
      this.queryParams.pageNum = 1
      this.fetchStationList(true)
    },

    onFilterChange(item) {
      if (item.hasDropdown) {
        this.showMoreFilter = true
        if (this.$refs.filterPopup) this.$refs.filterPopup.open()
        return
      }
      this.activeFilter = item.key
      this.stationList = []
      this.loadMockData()
    },

    onSortChange(s) {
      if (s.key === 'default') {
        this.currentSort = 'default'
        this.sortOrder = 'asc'
        this.queryParams.orderByColumn = 'distance'
      } else {
        if (this.currentSort === s.key) {
          this.sortOrder = this.sortOrder === 'asc' ? 'desc' : 'asc'
        } else {
          this.currentSort = s.key
          this.sortOrder = 'asc'
        }
        this.queryParams.orderByColumn = s.key
        this.queryParams.isAsc = this.sortOrder
      }

      this.queryParams.pageNum = 1
      this.stationList = []
      this.loadMockData()
    },

    applySort(list) {
      const order = this.sortOrder === 'asc' ? 1 : -1
      const sorted = [...list]
      switch (this.currentSort) {
        case 'distance':
          sorted.sort((a, b) => (parseFloat(a.distance) - parseFloat(b.distance)) * order)
          break
        case 'price':
          sorted.sort((a, b) => (parseFloat(a.price) - parseFloat(b.price)) * order)
          break
        case 'score':
          sorted.sort((a, b) => (parseFloat(a.score || '0') - parseFloat(b.score || '0')) * -1)
          break
        default:
          sorted.sort((a, b) => (parseFloat(a.distance) - parseFloat(b.distance)) * order)
      }
      return sorted
    },

    applyFilter(list) {
      const filterKey = this.activeFilter
      if (filterKey === 'all' || filterKey === 'distance') return list
      if (filterKey === 'fast') return list.filter(s => s.speedTypeKey === 'fast')
      if (filterKey === 'slow') return list.filter(s => s.speedTypeKey === 'slow')
      if (filterKey === 'free') return list.filter(s => s.freePiles > 0)
      if (filterKey === 'freePark') return list.filter(s => s.freeParkTime > 0)
      if (filterKey === 'highway') return list.filter(s => s.tags.some(t => t.text.includes('高速')))
      if (filterKey === 'discount') return list.filter(s => s.discount > 0)
      if (filterKey === 'plugAndPlay') return list.filter(s => s.plugAndPlay)
      if (filterKey === 'selfService') return list.filter(s => s.selfService)
      if (filterKey === '24h') return list.filter(s => s.tags.some(t => t.text === '24小时'))
      return list
    },

    resetFilter() {
      this.activeFilter = 'distance'
      this.currentSort = 'default'
      this.queryParams = {
        pageNum: 1, pageSize: 10,
        lat: this.queryParams.lat, lng: this.queryParams.lng,
        orderByColumn: 'distance', isAsc: 'asc'
      }
      this.stationList = []
      this.loadMockData()
    },

    showPriceTip(station) {
      this.priceTipData = {
        electric: station.electricPrice,
        service: station.servicePrice,
        total: station.price
      }
      if (this.$refs.pricePopup) this.$refs.pricePopup.open()
    },

    closePricePopup() {
      if (this.$refs.pricePopup) this.$refs.pricePopup.close()
    },

    onMarkerTap(e) {
      const markerId = e.detail.markerId
      const target = this.stationList.find(s => s.stationId === markerId)
      if (target) this.goDetail(target)
    },

    onMapMove(e) {
      if (e.type === 'end') {
        if (this.mapCtx) {
          this.mapCtx.getCenterLocation({
            success: (res) => {
              this.queryParams.lat = res.latitude
              this.queryParams.lng = res.longitude
            }
          })
        }
      }
    },

    goDetail(station) {
      console.log('[DEBUG goDetail] 选中桩:', station.stationId, station.name,
        '坐标:', station.lat, station.lng,
        '类型:', typeof station.lat)
      uni.navigateTo({
        url: `/pages/charge/detail?stationId=${station.stationId}&name=${encodeURIComponent(station.name)}&lat=${station.lat}&lng=${station.lng}`
      })
    },

    goBack() {
      uni.switchTab({ url: '/pages/index' })
    },

    goSearch() {
      uni.navigateTo({ url: '/pages/charge/search' })
    },

    goCitySelect() {
      uni.navigateTo({ url: '/pages/charge/city-select' })
    },

    goNotice() {
      uni.navigateTo({ url: '/pages/mine/messages/index?tab=charge' })
    },

    toggleMoreFilter(key) {
      const opt = this.moreFilterOptions.find(o => o.key === key)
      if (opt) opt.selected = !opt.selected
    },

    applyMoreFilter() {
      const selected = this.moreFilterOptions.filter(o => o.selected).map(o => o.key)
      if (selected.length > 0) {
        this.activeFilter = selected[0]
      }
      if (this.$refs.filterPopup) this.$refs.filterPopup.close()
      this.stationList = []
      this.loadMockData()
    },

    resetMoreFilter() {
      this.moreFilterOptions.forEach(o => o.selected = false)
      this.activeFilter = 'distance'
      if (this.$refs.filterPopup) this.$refs.filterPopup.close()
      this.stationList = []
      this.loadMockData()
    },

  },

  computed: {
    canSearch() {
      return this.regionText && this.locationSearchKey.trim()
    },
    availableCount() {
      return this.stationList.filter(s => s.freePiles > 0).length
    },
    centerText() {
      const lat = this.mapCenter.lat != null ? this.mapCenter.lat.toFixed(5) : '--'
      const lng = this.mapCenter.lng != null ? this.mapCenter.lng.toFixed(5) : '--'
      return lat + ', ' + lng
    }
  }
}
</script>

<style lang="scss" scoped>
.charge-page {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background-color: #f5f6fa;
}

.search-bar {
  display: flex;
  align-items: center;
  padding: 14rpx 20rpx;
  background: #fff;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.03);
  box-sizing: content-box;
}

.sb-left {
  flex-shrink: 0;
  margin-right: 8rpx;

  .back-btn {
    width: 56rpx;
    height: 56rpx;
    display: flex;
    align-items: center;
    justify-content: center;
  }
}

.sb-center {
  flex: 1;
  display: flex;
  align-items: center;
  min-width: 0;
}

.city-selector {
  display: flex;
  align-items: center;
  flex-shrink: 0;
  padding: 6rpx 8rpx;

  .city-name {
    font-size: 28rpx;
    font-weight: 700;
    color: #1a1a1a;
  }
}

.search-input {
  flex: 1;
  display: flex;
  align-items: center;
  height: 60rpx;
  background: #f2f3f7;
  border-radius: 30rpx;
  padding: 0 20rpx;
  border: 1rpx solid #f0f0f0;

  .search-placeholder {
    font-size: 24rpx;
    color: #bfbfbf;
    margin-left: 10rpx;
  }
}

.sb-right {
  flex-shrink: 0;
  margin-left: 12rpx;

  .icon-btn {
    position: relative;
    width: 56rpx;
    height: 56rpx;
    display: flex;
    align-items: center;
    justify-content: center;

    .badge {
      position: absolute;
      top: 0;
      right: -2rpx;
      min-width: 30rpx;
      height: 30rpx;
      line-height: 30rpx;
      text-align: center;
      font-size: 18rpx;
      color: #fff;
      background: linear-gradient(135deg, #ff4d4f, #ff7875);
      border-radius: 15rpx;
      padding: 0 6rpx;
    }
  }
}

.map-container {
  position: relative;
  width: 100%;
  height: 400rpx;

  .charge-map {
    width: 100%;
    height: 100%;
  }

  .map-overlay-stats {
    position: absolute;
    top: 20rpx;
    left: 20rpx;
    display: flex;
    gap: 12rpx;
    z-index: 10;

    .stat-chip {
      display: flex;
      align-items: center;
      background: rgba(255, 255, 255, 0.95);
      backdrop-filter: blur(10px);
      padding: 12rpx 20rpx;
      border-radius: 24rpx;
      box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.08);

      .stat-num {
        font-size: 32rpx;
        font-weight: 700;
        color: #333;
        margin-right: 6rpx;

        &.green {
          color: #07c160;
        }
      }

      .stat-label {
        font-size: 22rpx;
        color: #888;
      }
    }
  }

  .map-controls {
    position: absolute;
    right: 20rpx;
    bottom: 20rpx;
    display: flex;
    flex-direction: column;
    gap: 16rpx;

    .ctrl-btn {
      width: 72rpx;
      height: 72rpx;
      background: #fff;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.06);
      border: 1rpx solid #f5f5f5;
      &:active { transform: scale(0.93); }

      .switch-loc-icon {
        width: 40rpx;
        height: 40rpx;
      }
    }
  }

  .map-pull-indicator {
    position: absolute;
    bottom: 0;
    left: 50%;
    transform: translateX(-50%);
    display: flex;
    flex-direction: column;
    align-items: center;
    padding-bottom: 12rpx;
    z-index: 10;

    .pull-bar {
      width: 48rpx;
      height: 6rpx;
      border-radius: 3rpx;
      background: #c0c4cc;
      margin-bottom: 8rpx;
    }

    .pull-text {
      font-size: 20rpx;
      color: #bbb;
    }
  }
}

.filter-bar {
  white-space: nowrap;
  padding: 16rpx 20rpx 8rpx;
  background: #fff;
  border-bottom: 1rpx solid #f8f8f8;

  .filter-tag {
    display: inline-flex;
    align-items: center;
    padding: 10rpx 24rpx;
    margin-right: 14rpx;
    font-size: 24rpx;
    color: #666;
    background: #f5f6fa;
    border-radius: 26rpx;
    transition: all 0.2s ease;

    &.active {
      color: #07c160;
      background: #e8f8ee;
      font-weight: 500;
    }
  }
}

.sort-bar {
  display: flex;
  align-items: center;
  padding: 4rpx 20rpx 10rpx;
  background: #fff;

  .sort-item {
    display: flex;
    align-items: center;
    padding: 8rpx 16rpx;
    font-size: 22rpx;
    color: #999;
    border-right: 1rpx solid #f0f0f0;

    &:last-child { border-right: none; }

    &.active {
      color: #07c160;
      font-weight: 500;
    }

    .sort-arrows {
      display: flex;
      flex-direction: column;
      margin-left: 2rpx;
    }
  }
}

.station-list {
  flex: 1;
  padding: 16rpx 20rpx;
}

.station-card {
  display: flex;
  flex-direction: column;
  background: #fff;
  border-radius: 16rpx;
  margin-bottom: 20rpx;
  overflow: hidden;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.04);

  &.card-highlight {
    border: 2rpx solid #07c160;
    box-shadow: 0 4rpx 20rpx rgba(7, 193, 96, 0.1);
  }

  .card-top {
    display: flex;
  }

  .card-left {
    position: relative;
    flex-shrink: 0;
    display: flex;
    flex-direction: column;

    .station-img {
      width: 160rpx;
      height: 170rpx;
      background: linear-gradient(145deg, #e8f4fd 0%, #d0e8f5 50%, #c4ddf0 100%);
      border-radius: 12rpx;
    }

    .img-badge {
      position: absolute;
      top: 0;
      left: 0;
      background: linear-gradient(135deg, #07c160, #06ad56);
      padding: 4rpx 14rpx;
      border-bottom-right-radius: 12rpx;

      text {
        font-size: 20rpx;
        color: #fff;
        font-weight: 500;
      }
    }
  }

  .card-body {
    flex: 1;
    padding: 14rpx 18rpx 8rpx;
    display: flex;
    flex-direction: column;
  }

  .card-header {
    display: flex;
    align-items: flex-start;

    .station-name {
      font-size: 28rpx;
      font-weight: 700;
      color: #1a1a1a;
      flex: 1;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      line-height: 1.4;
    }

    .discount-tag {
      flex-shrink: 0;
      margin-left: 10rpx;
      padding: 2rpx 12rpx;
      background: linear-gradient(135deg, #ff6b00, #ffa940);
      border-radius: 6rpx;

      text {
        font-size: 20rpx;
        color: #fff;
        font-weight: 500;
      }
    }
  }

  .tag-row {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    margin-top: 8rpx;
    gap: 8rpx;

    .station-tag {
      padding: 4rpx 14rpx;
      font-size: 20rpx;
      border-radius: 6rpx;
      line-height: 1.4;

      &.tag-green { color: #07c160; background: #e8f8ee; }
      &.tag-blue { color: #1890ff; background: #e6f7ff; }
      &.tag-orange { color: #fa8c16; background: #fff7e6; }
      &.tag-red { color: #f5222d; background: #fff1f0; }
      &.tag-gray { color: #8c8c8c; background: #fafafa; }
    }

    .mini-tag {
      font-size: 20rpx;
      padding: 2rpx 10rpx;
      border-radius: 4rpx;
      border: 1rpx solid #eee;
      color: #999;
    }
  }

  .info-row {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    margin-top: 6rpx;
    gap: 20rpx;

    .info-item {
      display: flex;
      align-items: center;
      font-size: 24rpx;
      color: #666;
      gap: 4rpx;
    }
  }

  .price-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 16rpx 18rpx 10rpx;

    .price-info {
      .price-main {
        display: flex;
        align-items: baseline;

        .price-num {
          font-size: 44rpx;
          font-weight: 800;
          color: #ff6b00;
          letter-spacing: -1rpx;
        }

        .price-unit {
          font-size: 24rpx;
          color: #666;
          margin-left: 2rpx;
        }
      }
    }

    .status-box {
      display: flex;
      align-items: center;
      gap: 10rpx;

      .speed-badge {
        padding: 6rpx 16rpx;
        border-radius: 8rpx;
        font-size: 24rpx;
        font-weight: 600;

        &.speed-fast { color: #fff; background: #ffa940; }
        &.speed-slow { color: #fff; background: #07c160; }
      }

      .pile-status-text {
        font-size: 26rpx;
        font-weight: 600;
        color: #999;

        &.free {
          color: #07c160;
        }
      }
    }
  }

  .park-row-bottom {
    display: flex;
    align-items: center;
    gap: 8rpx;
    padding: 10rpx 18rpx 14rpx;
    border-top: 1rpx solid #f5f5f5;

    .park-icon-b {
      width: 30rpx;
      height: 30rpx;
      flex-shrink: 0;
    }

    .park-text-b {
      font-size: 24rpx;
      color: #555;
      font-weight: 500;
      line-height: 1.4;
      word-break: break-all;
    }
  }
}


.load-more-area {
  padding: 24rpx 0;

  .loading-row, .more-hint {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 12rpx;
    .load-text { font-size: 24rpx; color: #999; }
    text { font-size: 24rpx; color: #bbb; }
  }

  .nomore-row {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 16rpx;

    .nomore-line {
      width: 80rpx;
      height: 1rpx;
      background: #eee;
    }

    .nomore-text {
      font-size: 22rpx;
      color: #ccc;
      white-space: nowrap;
    }
  }
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 120rpx;

  .empty-img-wrap {
    width: 180rpx;
    height: 180rpx;
    background: #fafafa;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 24rpx;
  }

  .empty-title {
    font-size: 32rpx;
    color: #333;
    font-weight: 500;
    margin-bottom: 12rpx;
  }

  .empty-desc {
    font-size: 24rpx;
    color: #aaa;
    margin-bottom: 32rpx;
  }

  .empty-btn {
    padding: 0 48rpx;
    height: 72rpx;
    line-height: 72rpx;
    background: #07c160;
    color: #fff;
    font-size: 28rpx;
    border-radius: 36rpx;
  }
}

.city-picker {
  background: #fff;
  border-radius: 24rpx 24rpx 0 0;
  max-height: 75vh;

  .picker-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 32rpx 32rpx 20rpx;

    .picker-title {
      font-size: 34rpx;
      font-weight: 700;
      color: #1a1a1a;
    }
  }

  .current-city-info {
    display: flex;
    align-items: center;
    gap: 8rpx;
    padding: 16rpx 32rpx;
    background: #f8fcf9;
    margin: 0 24rpx 16rpx;
    border-radius: 12rpx;
    text { font-size: 26rpx; color: #07c160; }
  }

  .city-list { padding: 0 24rpx 40rpx; }

  .city-section-title {
    font-size: 24rpx;
    color: #999;
    padding: 20rpx 8rpx 12rpx;
  }

  .city-grid {
    display: flex;
    flex-wrap: wrap;
    gap: 16rpx;

    .city-chip {
      padding: 14rpx 28rpx;
      background: #f5f6fa;
      border-radius: 28rpx;
      font-size: 26rpx;
      color: #555;

      &.selected {
        background: #e8f8ee;
        color: #07c160;
        font-weight: 500;
      }
    }
  }

  .city-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 26rpx 8rpx;
    border-bottom: 1rpx solid #f9f9f9;
    &:active { background: #fafafa; }
    .city-name-text { font-size: 30rpx; color: #333; }
    &.selected { .city-name-text { color: #07c160; font-weight: 500; } }
  }
}

.price-tip-popup {
  padding: 36rpx 32rpx;
  background: #fff;
  border-radius: 16rpx;

  .popup-title {
    font-size: 34rpx;
    font-weight: 700;
    color: #1a1a1a;
    display: block;
    text-align: center;
    margin-bottom: 28rpx;
  }

  .tip-content {
    .tip-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 16rpx 0;
      .t-label { font-size: 28rpx; color: #666; }
      .t-val { font-size: 28rpx; color: #333; font-weight: 500; &.highlight { color: #ff6b00; font-size: 32rpx; font-weight: 700; } }
    }
    .tip-divider { height: 1rpx; background: #f0f0f0; margin: 4rpx 0; }
  }

  .popup-note {
    font-size: 22rpx;
    color: #bbb;
    display: block;
    text-align: center;
    margin: 20rpx 0 28rpx;
  }

  .popup-close-btn {
    width: 100%;
    height: 80rpx;
    line-height: 80rpx;
    background: linear-gradient(135deg, #07c160, #06ad56);
    color: #fff;
    font-size: 30rpx;
    font-weight: 500;
    border-radius: 40rpx;
  }
}

.filter-panel {
  background: #fff;
  border-radius: 24rpx 24rpx 0 0;
  padding-bottom: 60rpx;

  .filter-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 28rpx 32rpx;
    border-bottom: 1rpx solid #f5f5f5;

    .filter-cancel {
      font-size: 28rpx;
      color: #999;
    }

    .filter-title {
      font-size: 32rpx;
      font-weight: 700;
      color: #1a1a1a;
    }

    .filter-confirm {
      font-size: 28rpx;
      color: #07c160;
      font-weight: 500;
    }
  }

  .filter-body {
    padding: 20rpx 32rpx;

    .filter-section {
      .filter-section-title {
        font-size: 26rpx;
        font-weight: 600;
        color: #555;
        margin-bottom: 16rpx;
        display: block;
      }

      .filter-options {
        display: flex;
        flex-wrap: wrap;
        gap: 16rpx;

        .filter-option {
          padding: 14rpx 32rpx;
          background: #f5f6fa;
          border-radius: 32rpx;
          font-size: 26rpx;
          color: #555;

          &.selected {
            background: #e8f8ee;
            color: #07c160;
            font-weight: 500;
            border: 1rpx solid #07c160;
          }

          &:active { opacity: 0.7; }
        }
      }
    }
  }
}

.loc-picker-popup {
  width: 660rpx;
  background: #fff;
  border-radius: 24rpx;
  padding: 36rpx 32rpx 24rpx;
  max-height: 80vh;
  display: flex;
  flex-direction: column;

  .popup-title {
    font-size: 34rpx;
    font-weight: 600;
    color: #333;
    text-align: center;
    margin-bottom: 20rpx;
  }

  .loc-region-picker {
    display: flex;
    align-items: center;
    height: 80rpx;
    background: #f5f6fa;
    border-radius: 12rpx;
    padding: 0 20rpx;
    margin-bottom: 24rpx;

    .region-text {
      flex: 1;
      font-size: 28rpx;
      color: #333;
      margin-left: 12rpx;
    }

    .region-placeholder {
      flex: 1;
      font-size: 28rpx;
      color: #bbb;
      margin-left: 12rpx;
    }
  }

  .loc-addr-input {
    width: 100%;
    height: 80rpx;
    background: #f5f6fa;
    border-radius: 12rpx;
    padding: 0 24rpx;
    font-size: 28rpx;
    color: #333;
    margin-bottom: 24rpx;
  }

  .loc-btn-row {
    display: flex;
    gap: 16rpx;
    margin-bottom: 24rpx;

    .loc-btn-primary {
      flex: 1;
      height: 76rpx;
      line-height: 76rpx;
      background: linear-gradient(135deg, #1989fa, #1558b0);
      color: #fff;
      font-size: 28rpx;
      border-radius: 40rpx;
      border: none;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 6rpx;

      text {
        color: #fff;
        font-size: 28rpx;
      }

      &[disabled] {
        opacity: 0.5;
      }
    }

    .loc-btn-secondary {
      flex: 1;
      height: 76rpx;
      line-height: 76rpx;
      background: #f5f6fa;
      color: #1989fa;
      font-size: 28rpx;
      border-radius: 40rpx;
      border: 1rpx solid #e0e0e0;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 6rpx;

      text {
        color: #1989fa;
        font-size: 26rpx;
      }
    }
  }

  .loc-status {
    padding: 0 0 12rpx 0;
    font-size: 24rpx;
    color: #999;
    display: flex;
    align-items: center;
    gap: 8rpx;
  }

  .loc-city-list {
    max-height: 360rpx;
    margin-bottom: 20rpx;
  }

  .loc-city-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 24rpx 16rpx;
    border-bottom: 1rpx solid #f5f5f5;
    transition: background 0.2s;

    &:active { background: #f5f6fa; }

    .city-info {
      flex: 1;
      display: flex;
      flex-direction: column;
      gap: 6rpx;
    }

    .city-name-text {
      font-size: 30rpx;
      color: #333;
      font-weight: 500;
    }

    .city-desc {
      font-size: 24rpx;
      color: #999;
    }
  }

  .loc-empty {
    padding: 60rpx 0;
    text-align: center;
    color: #999;
    font-size: 28rpx;
  }

  .popup-close-btn {
    width: 100%;
    height: 76rpx;
    line-height: 76rpx;
    background: #f5f6fa;
    color: #666;
    font-size: 30rpx;
    border-radius: 40rpx;
    border: none;
  }
}


</style>