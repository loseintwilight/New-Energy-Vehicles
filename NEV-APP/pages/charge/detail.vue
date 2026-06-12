<template>
  <view class="detail-page">
    <charge-header />
    <view class="nav-bar">
      <view class="nav-back" @click="goBack">
        <u-icon name="arrow-left" size="36" color="#333"></u-icon>
      </view>
      <view class="nav-left-pad"></view>
      <text class="nav-title">站点详情</text>
      <view class="nav-right-btns">
        <view class="nav-icon-btn" @click="toggleFavorite">
          <uni-icons :type="isFavorite ? 'star-filled' : 'star'" size="28" :color="isFavorite ? '#ffc107' : '#999'"></uni-icons>
        </view>
        <view class="nav-icon-btn" @click="shareStation">
          <u-icon name="share" size="36" color="#333"></u-icon>
        </view>
      </view>
    </view>

    <scroll-view class="detail-scroll" scroll-y show-scrollbar="false">
      <view class="station-header">
        <view class="sh-name-row">
          <text class="sh-type-tag">{{ stationType }}</text>
          <text class="sh-station-name">{{ stationName }}</text>
        </view>

        <view class="sh-status-row">
          <text class="sh-status-text status-open">正常运营</text>
          <text class="sh-time-text">开放时间：{{ openTime || '周一至周日 00:00-23:59' }}</text>
        </view>

        <view class="sh-operator-row">
          <text class="sh-operator-label">运营商：</text>
          <text class="sh-operator-val">{{ operatorName || '国家电网' }}</text>
        </view>

        <view class="header-tags">
          <text v-for="(t, ti) in tagList" :key="ti" class="tag-item" :class="'tag-' + t.type">{{ t.text }}</text>
          <text v-if="plugAndPlay" class="tag-item tag-gray">即插即充</text>
          <text v-if="selfService" class="tag-item tag-gray">自助</text>
        </view>

        <view class="sh-gallery-row">
          <view class="gallery-card" v-for="(img, gi) in stationImages" :key="gi">
            <image class="gallery-img" :src="img" mode="aspectFill"></image>
          </view>
        </view>

        <view class="sh-address-row">
          <view class="address-left" @click="goNavi">
            <text class="addr-text">{{ stationAddress || '山东省济南市长清区文常山公园停车场' }}</text>
            <u-icon name="arrow-right" size="20" color="#999"></u-icon>
          </view>
          <view class="distance-chip" @click="goNavi">
            <image src="/static/images/charge/导航.png" mode="aspectFit" style="width:36rpx;height:36rpx;"></image>
            <text>距您{{ distanceVal }}km</text>
          </view>
        </view>
      </view>

      <view class="section-block price-section">
        <view class="section-header">
          <text class="section-title">充电价格</text>
          <text class="section-more" @click="showAllPrices">查看时段详情 <u-icon name="arrow-right" size="20" color="#07c160"></u-icon></text>
        </view>
        <view class="price-grid">
          <view class="price-card main">
            <text class="pc-label">当前电价</text>
            <text class="pc-price">¥{{ currentPrice }}</text>
            <text class="pc-unit">/度</text>
          </view>
          <view class="price-card">
            <text class="pc-label">电费</text>
            <text class="pc-price sub">¥{{ electricPrice }}</text>
            <text class="pc-unit">/度</text>
          </view>
          <view class="price-card">
            <text class="pc-label">服务费</text>
            <text class="pc-price sub">¥{{ servicePrice }}</text>
            <text class="pc-unit">/度</text>
          </view>
          <view class="price-card">
            <text class="pc-label">停车费</text>
            <text class="pc-price sub">{{ parkFee || '免费' }}</text>
            <text class="pc-unit"></text>
          </view>
        </view>
      </view>

      <view class="section-block pile-section">
       
        <view v-if="pileTab === 'pile'" class="pile-content">
          <view class="pile-list-header">
            <text class="pile-list-title">桩列表({{ totalPiles }})</text>
            <text class="pile-more" @click="onViewMore">查看更多 <u-icon name="arrow-right" size="18" color="#999"></u-icon></text>
          </view>
          <scroll-view class="pile-filter-bar" scroll-x enable-flex :show-scrollbar="false">
            <view class="pf-tag" @click="onViewMore"><text>全部</text></view>
            <view class="pf-tag" :class="{ active: !showLimited && pileFilter === 'fast' }" @click="onFilterClick('fast')"><text>快充 {{ fastCount }}</text></view>
            <view class="pf-tag" :class="{ active: !showLimited && pileFilter === 'slow' }" @click="onFilterClick('slow')"><text>慢充 {{ slowCount }}</text></view>
          </scroll-view>
          <view class="pile-detail-list">
            <view
              v-for="(pile, pi) in filteredPileList"
              :key="pi"
              class="pile-detail-card"
            >
              <view class="pdc-left">
                <view class="pdc-icon-wrap" :class="'icon-' + pile.status">
                  <image class="pdc-icon-img" :src="pile.status === 'free' ? '/static/images/charge/free.png' : pile.status === 'fault' ? '/static/images/charge/error.png' : '/static/images/charge/charging.png'" mode="aspectFit"></image>
                </view>
                <text class="pdc-badge" :class="'badge-' + pile.status">{{ pile.status === 'free' ? '空闲' : pile.status === 'charging' ? '充电中' : pile.statusText }}</text>
              </view>
              <view class="pdc-right">
                <view class="pdc-row">
                  <text class="pdc-label">桩 编 号</text>
                  <text class="pdc-value">{{ pile.pileCode }}</text>
                  <image class="pdc-copy-img" src="/static/images/charge/copy.png" mode="aspectFit" @click="copyPileCode(pile.pileCode)"></image>
                </view>
                <view class="pdc-row">
                  <text class="pdc-label">桩 名 称</text>
                  <text class="pdc-value bold">{{ pile.name }}</text>
                </view>
                <view class="pdc-row">
                  <text class="pdc-label">枪 编 号</text>
                  <text class="pdc-value">{{ pile.gunCode }}</text>
                </view>
                <view class="pdc-row price-row">
                  <text class="pdc-label">充电价格</text>
                  <text class="pdc-price">{{ priceRangeMin }}~{{ priceRangeMax }}元/度</text>
                  <text class="pdc-price-link" @click="showAllPrices">价格详情 <u-icon name="arrow-right" size="16" color="#1b8e67" bold></u-icon></text>
                </view>
                <view class="pdc-spec-row">
                  <text class="spec-tag">{{ pile.type }}</text>
                  <text class="spec-info">{{ pile.power }}</text>
                  <text class="spec-info">{{ pile.voltage }}</text>
                  <text class="spec-info">{{ pile.standard }}</text>
                </view>
                <view class="pdc-realtime-row" v-if="pile.status === 'charging'">
                  <text class="rt-item">实时SOC {{ pile.soc }}%</text>
                  <text class="rt-divider">|</text>
                  <text class="rt-item">电流 {{ pile.current }}A</text>
                  <text class="rt-divider">|</text>
                  <text class="rt-item">电压 {{ pile.voltageReal }}V</text>
                  <text class="rt-divider">|</text>
                  <text class="rt-item remain">预计剩余 {{ pile.remainTime }}</text>
                </view>
                <view class="pdc-realtime-row free-row" v-else-if="pile.status === 'free'">
                  <text class="rt-item remain">空闲中 可扫码充电</text>
                </view>
                <view class="pdc-realtime-row" v-else>
                  <text class="rt-item">{{ pile.statusText }}</text>
                </view>
              </view>
            </view>
          </view>
        </view>
      </view>

      <view class="section-block calculator-section">
        <view class="section-header">
          <text class="section-title">充电预估</text>
          <text class="calc-result">预计花费: <text class="calc-price">¥{{ estimatedCost }}</text></text>
        </view>
        <view class="calculator-body">
          <view class="calc-item">
            <text class="calc-label">当前电量</text>
            <view class="calc-slider-wrap">
              <slider
                :value="currentSOC"
                :min="0"
                :max="100"
                :step="5"
                activeColor="#07c160"
                backgroundColor="#f0f0f0"
                block-size="20"
                @change="onSOCChange"
              />
              <text class="calc-value">{{ currentSOC }}%</text>
            </view>
          </view>
          <view class="calc-item">
            <text class="calc-label">目标电量</text>
            <view class="calc-slider-wrap">
              <slider
                :value="targetSOC"
                :min="0"
                :max="100"
                :step="5"
                activeColor="#07c160"
                backgroundColor="#f0f0f0"
                block-size="20"
                @change="onTargetChange"
              />
              <text class="calc-value">{{ targetSOC }}%</text>
            </view>
          </view>
          <view class="calc-summary">
            <view class="summary-item">
              <text class="s-label">预计充电</text>
              <text class="s-value">{{ chargeEnergy }}度</text>
            </view>
            <view class="summary-item">
              <text class="s-label">预计时长</text>
              <text class="s-value">{{ estimatedTime }}</text>
            </view>
            <view class="summary-item highlight">
              <text class="s-label">预计费用</text>
              <text class="s-value">¥{{ estimatedCost }}</text>
            </view>
          </view>
        </view>
      </view>

      <view class="section-block review-section">
        <view class="section-header">
          <text class="section-title">用户评价</text>
          <text class="section-more" @click="goReview">查看全部 {{ reviewCount }} 条 <u-icon name="arrow-right" size="20" color="#07c160"></u-icon></text>
        </view>
        <view class="review-card" v-for="(review, ri) in reviewList" :key="ri">
          <view class="review-user">
            <image :src="review.avatar || '/static/images/tabbar/我的.png'" class="review-avatar"></image>
            <view class="review-user-info">
              <text class="review-nickname">{{ review.nickname }}</text>
              <uni-rate :value="review.score" readonly size="20" active-color="#ffc107" inactive-color="#eee" />
            </view>
            <text class="review-time">{{ review.time }}</text>
          </view>
          <text class="review-content">{{ review.content }}</text>
          <view class="review-imgs" v-if="review.images && review.images.length > 0">
            <image v-for="(img, ii) in review.images.slice(0, 3)" :key="ii" :src="img" mode="aspectFill"></image>
          </view>
        </view>
      </view>
    </scroll-view>

    <view class="bottom-bar" :style="{ paddingBottom: (16 + safeBottom) + 'px' }">
      <view class="bb-left" @click="goNavi">
        <u-icon name="map" size="36" color="#07c160"></u-icon>
        <text>导航</text>
      </view>
      <view class="bb-left" @click="callStation">
        <u-icon name="phone" size="36" color="#1890ff"></u-icon>
        <text>电话</text>
      </view>
      <view class="bb-right" @click="startCharging">
        <u-icon name="scan" size="28" color="#fff"></u-icon>
        <text class="bb-text">扫码充电</text>
      </view>
    </view>

    <uni-popup ref="priceDetailPopup" type="bottom" :safe-area="true">
      <view class="price-detail-popup">
        <view class="popup-header">
          <text class="popup-title">时段电价详情</text>
          <u-icon name="close" size="40" color="#999" @click="closePriceDetail"></u-icon>
        </view>
        <view class="price-time-grid">
          <view class="pt-row header">
            <text class="pt-cell">时段</text>
            <text class="pt-cell">电费</text>
            <text class="pt-cell">服务费</text>
            <text class="pt-cell">合计</text>
          </view>
          <view v-for="(tp, tpi) in timePrices" :key="tpi" class="pt-row" :class="{ active: tp.isCurrent }">
            <text class="pt-cell">{{ tp.timeRange }}</text>
            <text class="pt-cell">¥{{ tp.electric }}/度</text>
            <text class="pt-cell">¥{{ tp.service }}/度</text>
            <text class="pt-cell highlight">¥{{ tp.total }}/度</text>
          </view>
        </view>
      </view>
    </uni-popup>

    <uni-popup ref="scanPopup" type="center">
      <view class="scan-charge-popup">
        <!-- 输入状态：扫码或手动输入 -->
        <block v-if="connectionStep === 'input'">
          <view class="scp-header">
            <text class="scp-title">扫描充电桩二维码</text>
            <text class="scp-subtitle">请将充电桩屏幕上的二维码对准扫描框</text>
          </view>
          <view class="scp-scan-area" @click="doScanCode">
            <view class="scan-frame"></view>
            <u-icon name="scan" size="80" color="#07c160" style="opacity:0.3"></u-icon>
          </view>
          <text class="scp-divider-text">或将充电桩编号输入下方</text>
          <input
            class="scp-input"
            v-model="manualPileNumber"
            placeholder="如：SD-JN-001-A03"
            placeholder-style="color: #bfbfbf; font-size: 26rpx;"
            maxlength="20"
          />
          <button class="scp-connect-btn" :class="{ disabled: !manualPileNumber }" :disabled="!manualPileNumber" @click="confirmManualStart">
            手动连接充电桩
          </button>
        </block>

        <!-- 连接中状态：绿色小车动画 -->
        <block v-if="connectionStep === 'connecting'">
          <view class="connection-state-box">
            <view class="conn-car-scene">
              <view class="conn-car">
                <view class="conn-car-top"></view>
                <view class="conn-car-body">
                  <view class="conn-car-window"></view>
                </view>
                <view class="conn-car-wheels">
                  <view class="conn-wheel"></view>
                  <view class="conn-wheel"></view>
                </view>
              </view>
              <view class="conn-road">
                <view class="conn-road-dash"></view>
              </view>
            </view>
            <text class="conn-title">正在连接充电桩...</text>
            <text class="conn-sub">请确保车辆已停稳，充电枪已插入车辆接口</text>
          </view>
        </block>

        <!-- 连接成功状态 -->
        <block v-if="connectionStep === 'connected'">
          <view class="connection-state-box">
            <view class="conn-success-icon">
              <u-icon name="checkmark-circle" size="80" color="#07c160"></u-icon>
            </view>
            <text class="conn-title success">连接成功</text>
            <text class="conn-sub">即将跳转到充电页面...</text>
          </view>
        </block>

        <!-- 连接失败状态 -->
        <block v-if="connectionStep === 'failed'">
          <view class="connection-state-box">
            <view class="conn-fail-icon">
              <u-icon name="close-circle" size="80" color="#f5222d"></u-icon>
            </view>
            <text class="conn-title fail">连接失败</text>
            <text class="conn-sub">{{ connectionError || '连接超时，请检查充电桩状态后重试' }}</text>
            <button class="retry-btn" @click="retryConnect">重新连接</button>
          </view>
        </block>
      </view>
    </uni-popup>

    <!-- ========== 导航地图弹窗 ========== -->
    <view class="navi-map-overlay" :class="{ 'navi-map-active': showNaviMap }">
      <view class="navi-map-header">
        <view class="navi-back-btn" @click="closeNaviMap">
          <u-icon name="arrow-left" size="36" color="#333"></u-icon>
        </view>
        <text class="navi-map-title">{{ stationName }}</text>
        <view style="width:80rpx;"></view>
      </view>

      <map
        id="naviMap"
        class="navi-map-body"
        :latitude="naviMapCenter.lat"
        :longitude="naviMapCenter.lng"
        :markers="naviMarkers"
        :polyline="naviPolylines"
        :scale="14"
        show-location
        @error="onNaviMapError"
      ></map>

      <!-- 路线选择器（仿高德APP） -->
      <view class="navi-routes" v-if="naviRoutes.length > 0">
        <scroll-view class="navi-routes-scroll" scroll-x show-scrollbar="false">
          <view
            v-for="(r, ri) in naviRoutes"
            :key="ri"
            class="navi-route-card"
            :class="{ 'navi-route-active': ri === naviSelectedIdx }"
            @click="selectRoute(ri)"
          >
            <view class="nrc-header">
              <text class="nrc-label" :class="'nrc-label-' + (r.tag || 'normal')">{{ r.label }}</text>
              <text class="nrc-time">{{ formatDuration(r.duration) }}</text>
            </view>
            <view class="nrc-detail">
              <text class="nrc-dist">{{ (r.distance / 1000).toFixed(1) }}公里</text>
              <text class="nrc-dot">·</text>
              <text class="nrc-tolls" v-if="r.tolls > 0">{{ r.tolls.toFixed(0) }}元</text>
              <text class="nrc-tolls" v-else>免费</text>
            </view>
          </view>
        </scroll-view>
      </view>

      <view class="navi-map-actions">
        <view class="navi-action-btn" @click="openExternalMap">
          <u-icon name="map" size="32" color="#07c160"></u-icon>
          <text>使用外部地图</text>
        </view>
        <view class="navi-action-btn primary" @click="closeNaviMap">
          <u-icon name="checkmark" size="32" color="#fff"></u-icon>
          <text>我知道了</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
import { getStationDetail, getPileList } from '@/api/charge/station.js'
import { addCollection, getFavoriteStatus, cancelCollectionByTarget } from '@/api/mine/collection'
import safeAreaMixin from '@/mixins/safe-area.js'
import amap from '@/utils/amap.js'
import ChargeHeader from '@/components/charge-header/charge-header.vue'

export default {
  mixins: [safeAreaMixin],
  components: { ChargeHeader },
  data() {
    return {
      stationId: null,
      stationName: '',
      stationAddress: '',
      stationScore: 4.8,
      openTime: '',
      freeParkTime: 2,
      stationType: '公用',
      operatorName: '国家电网',
      distanceVal: '3.7',
      plugAndPlay: true,
      selfService: true,
      isFavorite: false,
      tagList: [],
      currentPrice: '1.28',
      electricPrice: '0.88',
      servicePrice: '0.40',
      parkFee: '免费',
      freePiles: 5,
      totalPiles: 8,
      pileList: [],
      stationImages: [],
      currentSOC: 20,
      targetSOC: 80,
      batteryCapacity: 60,
      lat: 36.548,
      lng: 116.801,
      // 导航地图相关
      showNaviMap: false,
      naviRoutes: [],
      naviSelectedIdx: 0,
      naviMarkers: [],
      naviPolylines: [],
      naviMapCenter: { lat: 36.548, lng: 116.801 },
      naviUserLat: null,
      naviUserLng: null,
      reviewList: [
        {
          avatar: '', nickname: '新能源车主', score: 5,
          time: '2026-05-28',
          content: '充电速度很快，环境整洁，位置好找！',
          images: []
        },
        {
          avatar: '', nickname: '绿色出行', score: 4,
          time: '2026-05-27',
          content: '价格实惠，就是车位有点紧张。',
          images: []
        }
      ],
      reviewCount: 128,
      manualPileNumber: '',
      connectionStep: 'input', // 'input' | 'connecting' | 'connected' | 'failed'
      connectionError: '',
      pileTab: 'pile',
      pileFilter: 'all',
      showLimited: true,
      timePrices: [
        { timeRange: '00:00-08:00', electric: '0.52', service: '0.30', total: '0.82', isCurrent: false },
        { timeRange: '08:00-12:00', electric: '0.88', service: '0.40', total: '1.28', isCurrent: true },
        { timeRange: '12:00-17:00', electric: '0.78', service: '0.35', total: '1.13', isCurrent: false },
        { timeRange: '17:00-21:00', electric: '1.02', service: '0.45', total: '1.47', isCurrent: false },
        { timeRange: '21:00-24:00', electric: '0.62', service: '0.30', total: '0.92', isCurrent: false }
      ]
    }
  },

  onLoad(options) {
    this.stationId = options.stationId
    this.stationName = decodeURIComponent(options.name || '充电站')
    if (options.lat) this.lat = Number(options.lat)
    if (options.lng) this.lng = Number(options.lng)
    if (options.distance) this.distanceVal = options.distance
    console.log('[DEBUG onLoad] 传入参数:', options, '→ this.lat:', this.lat, 'this.lng:', this.lng, 'distance:', this.distanceVal)
    if (options.pileFilter) {
      this.pileFilter = options.pileFilter
      this.showLimited = false
    }
    this.fetchDetail()
  },

  methods: {
    async fetchDetail() {
      try {
        const res = await getStationDetail(this.stationId)
        const data = res.data || {}
        console.log('[DEBUG fetchDetail] API返回:', data)
        this.stationName = data.name || this.stationName
        this.stationAddress = data.address || ''
        this.openTime = data.openTime || ''
        this.stationType = data.stationType || '公用'
        this.operatorName = data.operatorName || '新能源充电'
        this.currentPrice = data.price || '1.28'
        this.electricPrice = data.electricPrice || '0.88'
        this.servicePrice = data.servicePrice || '0.40'
        this.freePiles = data.freePiles || 0
        this.totalPiles = data.totalPiles || 0
        this.parkFee = data.parkFee || '免费'
        this.stationScore = data.score || 4.8
        if (data.lat) this.lat = Number(data.lat)
        if (data.lng) this.lng = Number(data.lng)
        if (data.distance) this.distanceVal = data.distance
        if (data.tags) this.tagList = data.tags
        // 解析逗号分隔的充电站图片
        if (data.images) {
          this.stationImages = data.images.split(',').map(s => s.trim()).filter(Boolean)
        }
        if (data.timePrices && data.timePrices.length > 0) {
          this.timePrices = data.timePrices.map(p => ({
            timeRange: p.timeRange || (p.startTime + '-' + p.endTime),
            electric: p.electricPrice || '0',
            service: p.servicePrice || '0',
            total: p.totalPrice || '0',
            isCurrent: p.isCurrent || false
          }))
          // 设置当前电价
          const current = this.timePrices.find(p => p.isCurrent) || this.timePrices[0]
          this.currentPrice = current.total || this.currentPrice
          this.electricPrice = current.electric || this.electricPrice
          this.servicePrice = current.service || this.servicePrice
        }
        this.tagList = [
          { text: this.freePiles > 0 ? (this.freePiles + '个空闲' + (this.totalPiles > 0 ? '/' + this.totalPiles + '总' : '')) : '暂无空闲', type: 'green' },
          { text: this.parkFee === '免费' ? '免费停车' : '停车收费', type: 'orange' },
          { text: '新人券可用', type: 'blue' }
        ]
        // 获取收藏状态
        this.loadFavoriteStatus()
        // 获取充电桩列表
        this.fetchPileList()
      } catch (e) {
        console.log('[DEBUG fetchDetail] API失败，使用兜底数据:', e)
        this.loadMockDetail()
        this.loadFavoriteStatus()
      }
    },

    async fetchPileList() {
      try {
        const res = await getPileList(this.stationId)
        const piles = res.data || []
        if (piles && piles.length > 0) {
          this.pileList = piles.map(p => ({
            number: p.pileCode || p.number || '',
            type: p.pileType === 'dc' ? '快充' : (p.pileType === 'ac' ? '慢充' : (p.type || '快充')),
            status: p.pileStatus === '0' ? 'free' : (p.pileStatus === '1' ? 'charging' : (p.pileStatus === '3' ? 'fault' : (p.status || 'free'))),
            power: p.powerKw ? p.powerKw + 'kW' : (p.power || '120kW'),
            statusText: p.pileStatus === '0' ? '空闲' : (p.pileStatus === '1' ? '使用中' : (p.pileStatus === '3' ? '故障维护' : (p.statusText || '空闲'))),
            connectorType: p.connectorType || 'GB/T直流',
            online: p.pileStatus !== '2',
            position: p.position || '',
            floor: p.floor || '',
            pileCode: p.pileCode || '',
            name: p.name || '',
            gunCode: p.gunCode || '',
            voltage: p.voltage || '',
            standard: p.standard || '',
            soc: p.soc || 0,
            current: p.current || 0,
            voltageReal: p.voltageReal || 0,
            remainTime: p.remainTime || ''
          }))
          this.totalPiles = this.pileList.length
          return
        }
      } catch (e) {
        console.log('[DEBUG fetchPileList] API失败，使用兜底数据:', e)
      }
      // API 无数据或失败时，使用部分模拟桩数据补充（不覆盖已有详情数据）
      if (!this.pileList.length) {
        this.pileList = this.getMockPileList()
      }
    },

    getMockPileList() {
      return [
  { number: 'A01', type: '快充', status: 'free', power: '120kW', statusText: '空闲', connectorType: 'GB/T直流', floor: 'B1', position: 'A区-01号', online: true,
    pileCode: '3740190000020104', name: '3号桩', gunCode: '3740190000020104001', voltage: '750V', standard: '国标2015', soc: 89, current: 18.9, voltageReal: 406.5 },
  { number: 'A02', type: '快充', status: 'free', power: '120kW', statusText: '空闲', connectorType: 'GB/T直流', floor: 'B1', position: 'A区-02号', online: true,
    pileCode: '3740190000020105', name: '1号桩', gunCode: '3740190000020105001', voltage: '750V', standard: '国标2015', soc: 100, current: 3.6, voltageReal: 395.5 },
  { number: 'A03', type: '快充', status: 'charging', power: '120kW', statusText: '使用中', connectorType: 'GB/T直流', floor: 'B1', position: 'A区-03号', online: true,
    pileCode: '3740190000020103', name: '7号桩', gunCode: '3740190000020103001', voltage: '750V', standard: '国标2015', soc: 40, current: 44.5, voltageReal: 414.0, remainTime: '35分钟' },
  { number: 'A04', type: '快充', status: 'free', power: '120kW', statusText: '空闲', connectorType: 'GB/T直流', floor: 'B1', position: 'A区-04号', online: true,
    pileCode: '3740190000020106', name: '2号桩', gunCode: '3740190000020106001', voltage: '750V', standard: '国标2015', soc: 75, current: 0, voltageReal: 400.0 },
  { number: 'A05', type: '快充', status: 'free', power: '120kW', statusText: '空闲', connectorType: 'GB/T直流', floor: 'B1', position: 'A区-05号', online: true,
    pileCode: '3740190000020107', name: '4号桩', gunCode: '3740190000020107001', voltage: '750V', standard: '国标2015', soc: 60, current: 0, voltageReal: 408.0 },
  { number: 'A06', type: '快充', status: 'charging', power: '120kW', statusText: '使用中', connectorType: 'GB/T直流', floor: 'B1', position: 'A区-06号', online: true,
    pileCode: '3740190000020108', name: '5号桩', gunCode: '3740190000020108001', voltage: '750V', standard: '国标2015', soc: 35, current: 52.3, voltageReal: 410.2, remainTime: '45分钟' },
  { number: 'A07', type: '快充', status: 'free', power: '120kW', statusText: '空闲', connectorType: 'GB/T直流', floor: 'B1', position: 'A区-07号', online: true,
    pileCode: '3740190000020109', name: '6号桩', gunCode: '3740190000020109001', voltage: '750V', standard: '国标2015', soc: 95, current: 0, voltageReal: 398.5 },
  { number: 'A08', type: '快充', status: 'free', power: '120kW', statusText: '空闲', connectorType: 'GB/T直流', floor: 'B1', position: 'A区-08号', online: true,
    pileCode: '3740190000020110', name: '8号桩', gunCode: '3740190000020110001', voltage: '750V', standard: '国标2015', soc: 20, current: 0, voltageReal: 402.0 },
  { number: 'B01', type: '慢充', status: 'free', power: '7kW', statusText: '空闲', connectorType: 'GB/T交流', floor: 'B2', position: 'B区-01号', online: true,
    pileCode: '3740190000020201', name: '慢充1号', gunCode: '3740190000020201001', voltage: '220V', standard: '国标2015', soc: 55, current: 12.0, voltageReal: 220.0 },
  { number: 'B02', type: '慢充', status: 'fault', power: '7kW', statusText: '故障维护', connectorType: 'GB/T交流', floor: 'B2', position: 'B区-02号', online: false,
    pileCode: '3740190000020202', name: '慢充2号', gunCode: '3740190000020202001', voltage: '220V', standard: '国标2015', soc: 0, current: 0, voltageReal: 0 },
  { number: 'B03', type: '慢充', status: 'free', power: '7kW', statusText: '空闲', connectorType: 'GB/T交流', floor: 'B2', position: 'B区-03号', online: true,
    pileCode: '3740190000020203', name: '慢充3号', gunCode: '3740190000020203001', voltage: '220V', standard: '国标2015', soc: 0, current: 0, voltageReal: 0 },
  { number: 'B04', type: '慢充', status: 'charging', power: '7kW', statusText: '使用中', connectorType: 'GB/T交流', floor: 'B2', position: 'B区-04号', online: true,
    pileCode: '3740190000020204', name: '慢充4号', gunCode: '3740190000020204001', voltage: '220V', standard: '国标2015', soc: 68, current: 10.5, voltageReal: 218.0, remainTime: '55分钟' },
  { number: 'B05', type: '慢充', status: 'free', power: '7kW', statusText: '空闲', connectorType: 'GB/T交流', floor: 'B2', position: 'B区-05号', online: true,
    pileCode: '3740190000020205', name: '慢充5号', gunCode: '3740190000020205001', voltage: '220V', standard: '国标2015', soc: 82, current: 0, voltageReal: 221.0 },
  { number: 'B06', type: '慢充', status: 'free', power: '7kW', statusText: '空闲', connectorType: 'GB/T交流', floor: 'B2', position: 'B区-06号', online: true,
    pileCode: '3740190000020206', name: '慢充6号', gunCode: '3740190000020206001', voltage: '220V', standard: '国标2015', soc: 45, current: 0, voltageReal: 219.5 },
  { number: 'C01', type: '快充', status: 'free', power: '180kW', statusText: '空闲', connectorType: 'GB/T直流', floor: 'B1', position: 'C区超充-01号', online: true,
    pileCode: '3740190000020301', name: '超充1号', gunCode: '3740190000020301001', voltage: '1000V', standard: '国标2015+', soc: 70, current: 0, voltageReal: 800.0 },
  { number: 'C02', type: '快充', status: 'free', power: '180kW', statusText: '空闲', connectorType: 'GB/T直流', floor: 'B1', position: 'C区超充-02号', online: true,
    pileCode: '3740190000020302', name: '超充2号', gunCode: '3740190000020302001', voltage: '1000V', standard: '国标2015+', soc: 88, current: 0, voltageReal: 795.0 },
  { number: 'C03', type: '快充', status: 'charging', power: '180kW', statusText: '使用中', connectorType: 'GB/T直流', floor: 'B1', position: 'C区超充-03号', online: true,
    pileCode: '3740190000020303', name: '超充3号', gunCode: '3740190000020303001', voltage: '1000V', standard: '国标2015+', soc: 25, current: 98.6, voltageReal: 788.0, remainTime: '25分钟' }
]
    },

    async loadFavoriteStatus() {
      try {
        const res = await getFavoriteStatus('station', this.stationId)
        this.isFavorite = res.data === true
      } catch (e) {
        this.isFavorite = false
      }
    },

    loadMockDetail() {
      this.stationAddress = '山东省济南市长清区文常山公园停车场'
      this.openTime = '24小时营业'
      this.freeParkTime = 2
      this.stationScore = 4.8
      this.stationImages = [
        '/static/images/chargeStation/5f9f5475a6cb848c0476e859b7930c2f.jpg',
        '/static/images/chargeStation/OIP-C.webp'
      ]
      this.tagList = [
        { text: '新人券可用', type: 'blue' },
        { text: '免费停车2小时', type: 'orange' }
      ]
      this.freePiles = 12
      this.totalPiles = 17
      this.pileList = this.getMockPileList()
    },

    goBack() {
      uni.navigateBack()
    },

    shareStation() {
      // 【功能待完善】分享充电站信息
      uni.showToast({ title: '分享功能开发中', icon: 'none' })
    },

    showAllPrices() {
      if (this.$refs.priceDetailPopup) this.$refs.priceDetailPopup.open()
    },

    closePriceDetail() {
      if (this.$refs.priceDetailPopup) this.$refs.priceDetailPopup.close()
    },

    selectPile(pile) {
      if (pile.status === 'fault') {
        uni.showToast({ title: '该充电桩故障中', icon: 'none' })
        return
      }
      if (pile.status === 'charging') {
        uni.showToast({ title: '该充电桩使用中', icon: 'none' })
        return
      }
      uni.showActionSheet({
        itemList: [`开始使用 ${pile.number} 充电桩`],
        success: () => {
          this.$emit('startCharge', pile)
        }
      })
    },

    onSOCChange(e) {
      this.currentSOC = e.detail.value
      if (this.currentSOC >= this.targetSOC) {
        this.targetSOC = Math.min(100, this.currentSOC + 10)
      }
    },

    onTargetChange(e) {
      this.targetSOC = e.detail.value
      if (this.targetSOC <= this.currentSOC) {
        this.currentSOC = Math.max(0, this.targetSOC - 10)
      }
    },

    startCharging() {
      const energy = parseFloat(this.chargeEnergy)
      if (energy <= 0) {
        uni.showToast({ title: '电量已满或设置不合理', icon: 'none' })
        return
      }
      // 重置连接状态
      this.connectionStep = 'input'
      this.connectionError = ''
      this.manualPileNumber = ''
      if (this.$refs.scanPopup) this.$refs.scanPopup.open()
    },

    doScanCode() {
      uni.scanCode({
        onlyFromCamera: true,
        success: (res) => {
          this.manualPileNumber = res.result || ''
        },
        fail: (err) => {
          console.log('扫码失败', err)
          uni.showToast({ title: '扫码失败，请手动输入', icon: 'none' })
        }
      })
    },

    confirmManualStart() {
      if (!this.manualPileNumber || this.manualPileNumber.trim() === '') {
        this.connectionError = '请输入充电桩编号'
        this.connectionStep = 'failed'
        return
      }
      var input = this.manualPileNumber.trim()
      // 立即显示小车加载动画（1.5秒），同时在列表中查桩
      this.connectionStep = 'connecting'
      this.connectionError = ''
      var self = this
      setTimeout(function() {
        var matched = false
        for (var i = 0; i < self.pileList.length; i++) {
          var pile = self.pileList[i]
          if (pile.pileCode === input || pile.number === input || pile.gunCode === input) {
            matched = true
            break
          }
        }
        if (matched) {
          self.connectionStep = 'connected'
          // 0.8秒后跳转充电页面（关闭弹窗）
          setTimeout(function() {
            if (self.$refs.scanPopup) self.$refs.scanPopup.close()
            self.connectionStep = 'input'
            self.manualPileNumber = ''
            self.doNavigateToCharge(input)
          }, 800)
        } else {
          self.connectionError = '未找到该编号的充电桩'
          self.connectionStep = 'failed'
        }
      }, 1500)
    },

    /** 重试连接 */
    retryConnect() {
      this.connectionStep = 'input'
      this.connectionError = ''
    },

    doNavigateToCharge(pileNumber) {
      const energy = parseFloat(this.chargeEnergy)
      uni.navigateTo({
        url: `/pages/charge/charging?stationId=${this.stationId}&stationName=${encodeURIComponent(this.stationName)}&pileNumber=${pileNumber}&targetEnergy=${energy}&price=${this.currentPrice}`
      })
    },

    onViewMore() {
      uni.navigateTo({
        url: `/pages/charge/pile-list?stationId=${this.stationId}&name=${encodeURIComponent(this.stationName)}&currentPrice=${this.currentPrice}&pileFilter=all`
      })
    },

    onFilterClick(filter) {
      uni.navigateTo({
        url: `/pages/charge/pile-list?stationId=${this.stationId}&name=${encodeURIComponent(this.stationName)}&currentPrice=${this.currentPrice}&pileFilter=${filter}`
      })
    },

    goReview() {
      uni.navigateTo({
        url: `/pages/charge/reviews?stationId=${this.stationId}&name=${encodeURIComponent(this.stationName)}`
      })
    },

    goNavi() {
      console.log('[DEBUG goNavi] this.lat:', this.lat, 'this.lng:', this.lng,
        '| stationName:', this.stationName)
      if (!this.lat || !this.lng) {
        uni.showToast({ title: '暂无位置信息', icon: 'none' })
        return
      }

      uni.showLoading({ title: '规划路线中...', mask: true })

      // 先获取用户当前位置
      uni.getLocation({
        type: 'gcj02',
        isHighAccuracy: true,
        timeout: 5000,
        success: (loc) => {
          const fromLat = loc.latitude
          const fromLng = loc.longitude
          this.naviUserLat = fromLat
          this.naviUserLng = fromLng

          // 调用高德驾车路径规划（多条路线）
          amap.getDrivingRoutes({
            fromLat,
            fromLng,
            toLat: parseFloat(this.lat),
            toLng: parseFloat(this.lng)
          }).then(routes => {
            uni.hideLoading()
            this.naviRoutes = routes
            this.naviSelectedIdx = 0

            // 先显示空地图
            this.showNaviMap = true

            // 绘制第0条路线
            this.$nextTick(() => {
              setTimeout(() => this.drawNaviRoute(0), 200)
            })
          }).catch(err => {
            uni.hideLoading()
            console.error('[goNavi] 路线规划失败:', err)
            // 降级：打开外部地图
            this.openExternalMap()
          })
        },
        fail: (err) => {
          uni.hideLoading()
          console.error('[goNavi] 获取位置失败:', err)
          this.openExternalMap()
        }
      })
    },

    /** 选择路线 */
    selectRoute(idx) {
      if (idx === this.naviSelectedIdx) return
      this.naviSelectedIdx = idx
      this.drawNaviRoute(idx)
    },

    /** 在地图上绘制指定路线 */
    drawNaviRoute(idx) {
      const route = this.naviRoutes[idx]
      if (!route) return

      const fromLat = this.naviUserLat
      const fromLng = this.naviUserLng

      // 计算地图中心
      this.naviMapCenter = {
        lat: (fromLat + parseFloat(this.lat)) / 2,
        lng: (fromLng + parseFloat(this.lng)) / 2
      }

      // 起点标记（汽车图标）
      this.naviMarkers = [
        {
          id: 1,
          latitude: fromLat,
          longitude: fromLng,
          width: 32,
          height: 40,
          iconPath: '/static/images/charge/car-marker.svg',
          anchor: { x: 0.5, y: 1 },
          callout: {
            content: '我的位置',
            display: 'ALWAYS',
            fontSize: 11,
            bgColor: '#fff',
            color: '#333',
            padding: '6rpx 12rpx'
          }
        },
        {
          id: 2,
          latitude: parseFloat(this.lat),
          longitude: parseFloat(this.lng),
          width: 30,
          height: 36,
          iconPath: '/static/images/charge/location-pin-blue.svg',
          anchor: { x: 0.5, y: 1 },
          callout: {
            content: this.stationName || '充电站',
            display: 'ALWAYS',
            fontSize: 11,
            bgColor: '#07c160',
            color: '#fff',
            padding: '6rpx 12rpx'
          }
        }
      ]

      // 路线折线（选中路线蓝色实线，其他灰色虚线）
      this.naviPolylines = [{
        points: route.points,
        color: '#3c96f3',
        width: 6,
        arrowLine: true,
        dottedLine: false
      }]

      // 调整视野
      setTimeout(() => {
        const mapCtx = uni.createMapContext('naviMap', this)
        if (mapCtx) {
          try {
            mapCtx.includePoints({
              points: [
                { latitude: fromLat, longitude: fromLng },
                { latitude: parseFloat(this.lat), longitude: parseFloat(this.lng) }
              ],
              padding: [180, 80, 180, 80]
            })
          } catch (e) {
            console.error('[naviMap] includePoints error:', e)
          }
        }
      }, 300)
    },

    /** 关闭导航地图 */
    closeNaviMap() {
      this.showNaviMap = false
      this.naviRoutes = []
      this.naviSelectedIdx = 0
      this.naviMarkers = []
      this.naviPolylines = []
    },

    /** 地图渲染出错回调 */
    onNaviMapError(e) {
      console.error('[naviMap] map error:', e.detail || e)
      uni.showToast({ title: '地图加载失败', icon: 'none' })
    },

    /** 打开外部地图导航（降级方案） */
    openExternalMap() {
      if (!this.lat || !this.lng) {
        uni.showToast({ title: '暂无位置信息', icon: 'none' })
        return
      }
      amap.navigateTo({
        lat: parseFloat(this.lat),
        lng: parseFloat(this.lng),
        name: this.stationName,
        address: this.stationAddress
      })
    },

    /** 格式化时长（秒 → 中文） */
    formatDuration(seconds) {
      if (!seconds) return '--'
      const mins = Math.round(seconds / 60)
      if (mins < 60) return mins + '分钟'
      const h = Math.floor(mins / 60)
      const m = mins % 60
      return h + '小时' + (m > 0 ? m + '分钟' : '')
    },

    callStation() {
      uni.makePhoneCall({ phoneNumber: '0531-88886666' })
    },

    /** 复制充电桩编号到剪贴板 */
    copyPileCode(code) {
      uni.setClipboardData({
        data: code,
        success: () => {
          uni.showToast({ title: '已复制', icon: 'success' })
        }
      })
    },

    toggleFavorite() {
      if (this.isFavorite) {
        cancelCollectionByTarget('station', this.stationId).then(() => {
          this.isFavorite = false
        }).catch(() => {
          console.error('取消收藏失败')
        })
      } else {
        addCollection({ targetType: 'station', targetId: this.stationId }).then(() => {
          this.isFavorite = true
        }).catch(() => {
          console.error('收藏失败')
        })
      }
    },

    showCert() {
      uni.showToast({ title: '资质公示功能开发中', icon: 'none' })
    }
  },

  computed: {
    priceRangeMin() {
      if (!this.timePrices || this.timePrices.length === 0) return this.currentPrice
      const prices = this.timePrices.map(p => parseFloat(p.total))
      return Math.min(...prices).toFixed(2)
    },
    priceRangeMax() {
      if (!this.timePrices || this.timePrices.length === 0) return this.currentPrice
      const prices = this.timePrices.map(p => parseFloat(p.total))
      return Math.max(...prices).toFixed(2)
    },
    fastCount() {
      return this.pileList.filter(p => p.type === '快充').length
    },
    slowCount() {
      return this.pileList.filter(p => p.type === '慢充').length
    },
    filteredPileList() {
      if (this.showLimited) return this.pileList.filter(p => p.status === 'free').slice(0, 2)
      if (this.pileFilter === 'fast') return this.pileList.filter(p => p.type === '快充')
      if (this.pileFilter === 'slow') return this.pileList.filter(p => p.type === '慢充')
      return this.pileList
    },
    chargeEnergy() {
      const energy = (this.targetSOC - this.currentSOC) * this.batteryCapacity / 100
      return Math.max(0, energy).toFixed(1)
    },
    estimatedCost() {
      const cost = parseFloat(this.chargeEnergy) * parseFloat(this.currentPrice)
      return cost.toFixed(2)
    },
    estimatedTime() {
      const energy = parseFloat(this.chargeEnergy)
      if (energy <= 0) return '0分钟'
      const avgPower = 60
      const hours = energy / avgPower
      if (hours < 1) return `${Math.ceil(hours * 60)}分钟`
      if (hours < 24) return `${Math.floor(hours)}小时${Math.round((hours % 1) * 60)}分钟`
      return `${Math.floor(hours)}小时+`
    },
    locationMarkers() {
      return [{
        id: 1,
        latitude: parseFloat(this.lat || 36.548),
        longitude: parseFloat(this.lng || 116.801),
        width: 30,
        height: 36,
        title: this.stationName,
        iconPath: '/static/images/tabbar/停车充电服务.png'
      }]
    }
  }
}
</script>

<style lang="scss" scoped>
.detail-page {
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
    flex-shrink: 0;
  }

  .nav-left-pad {
    width: 76rpx;
    flex-shrink: 0;
  }

  .nav-title {
    flex: 1;
    text-align: center;
    font-size: 34rpx;
    font-weight: 700;
    color: #1a1a1a;
  }

  .nav-right-btns {
    display: flex;
    align-items: center;
    gap: 16rpx;
    flex-shrink: 0;

    .nav-icon-btn {
      width: 60rpx;
      height: 60rpx;
      display: flex;
      align-items: center;
      justify-content: center;
    }
  }
}

.detail-scroll {
  flex: 1;
  padding-bottom: 120rpx;
}

.section-block {
  background: #fff;
  margin: 16rpx 20rpx;
  border-radius: 16rpx;
  overflow: hidden;

  .section-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 28rpx 24rpx 20rpx;

    .section-title {
      font-size: 30rpx;
      font-weight: 700;
      color: #1a1a1a;
    }

    .section-more {
      font-size: 24rpx;
      color: #07c160;
      display: flex;
      align-items: center;
    }

    .section-count {
      font-size: 24rpx;
      color: #07c160;
      font-weight: 500;
    }

    .calc-result {
      font-size: 24rpx;
      color: #666;

      .calc-price {
        font-size: 30rpx;
        font-weight: 700;
        color: #ff6b00;
      }
    }
  }
}

.station-header {
  background: #fff;
  margin: 0 20rpx;
  border-radius: 16rpx;
  padding: 24rpx;

  .sh-name-row {
    display: flex;
    align-items: center;
    gap: 12rpx;

    .sh-type-tag {
      font-size: 22rpx;
      color: #07c160;
      background: #e8f8ee;
      padding: 4rpx 14rpx;
      border-radius: 6rpx;
      font-weight: 500;
    }

    .sh-station-name {
      font-size: 32rpx;
      font-weight: 800;
      color: #1a1a1a;
      flex: 1;
    }
  }

  .sh-status-row {
    display: flex;
    align-items: center;
    margin-top: 16rpx;
    gap: 12rpx;

    .sh-status-text {
      font-size: 24rpx;
      font-weight: 600;

      &.status-open { color: #07c160; }
      &.status-closed { color: #999; }
    }

    .sh-time-text {
      font-size: 22rpx;
      color: #666;
    }
  }

  .sh-operator-row {
    display: flex;
    align-items: center;
    margin-top: 12rpx;
    gap: 6rpx;

    .sh-operator-label { font-size: 22rpx; color: #888; }
    .sh-operator-val { font-size: 22rpx; color: #333; font-weight: 500; flex: 1; }

    .sh-cert-btn {
      display: flex;
      align-items: center;
      gap: 2rpx;
      padding: 4rpx 12rpx;
      border: 1rpx solid #eee;
      border-radius: 6rpx;

      text { font-size: 20rpx; color: #999; }
    }
  }

  .header-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 8rpx;
    margin-top: 14rpx;

    .tag-item {
      padding: 4rpx 14rpx;
      font-size: 22rpx;
      border-radius: 6rpx;

      &.tag-green { color: #07c160; background: #e8f8ee; }
      &.tag-blue { color: #1890ff; background: #e6f7ff; }
      &.tag-orange { color: #fa8c16; background: #fff7e6; }
      &.tag-gray { color: #8c8c8c; background: #fafafa; }
    }
  }

  .sh-gallery-row {
    display: flex;
    gap: 16rpx;
    margin-top: 20rpx;

    .gallery-card {
      flex: 1;
      height: 200rpx;
      border-radius: 12rpx;
      overflow: hidden;
      position: relative;

      .gallery-img {
        width: 100%;
        height: 100%;
        background: linear-gradient(145deg, #e8f4fd, #d0e8f5);
      }

      .gallery-overlay {
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        padding: 10rpx 16rpx;
        display: flex;
        align-items: center;
        gap: 6rpx;
        background: rgba(0,0,0,0.35);

        &.photo-overlay {
          justify-content: flex-end;
          background: transparent;
          padding-bottom: 14rpx;
        }

        .overlay-label {
          font-size: 22rpx;
          color: #fff;
          font-weight: 500;
        }
      }
    }
  }

  .sh-address-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: 16rpx;
    padding-top: 16rpx;
    border-top: 1rpx solid #f5f5f5;

    .address-left {
      display: flex;
      align-items: center;
      gap: 4rpx;
      flex: 1;
      overflow: hidden;

      .addr-text {
        font-size: 24rpx;
        color: #333;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }
    }

    .distance-chip {
      display: flex;
      align-items: center;
      gap: 4rpx;
      padding: 6rpx 18rpx;
      border: 1rpx solid #07c160;
      border-radius: 30rpx;
      flex-shrink: 0;
      margin-left: 12rpx;

      text {
        font-size: 22rpx;
        color: #07c160;
        font-weight: 600;
      }
    }
  }
}

.price-section {
  .price-grid {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr 1fr;
    gap: 12rpx;
    padding: 0 24rpx 28rpx;

    .price-card {
      background: #f8f9fc;
      border-radius: 12rpx;
      padding: 20rpx 12rpx;
      text-align: center;

      &.main {
        background: linear-gradient(145deg, #fff3e6, #ffe8cc);

        .pc-price {
          color: #ff6b00;
          font-size: 44rpx;
        }
        .pc-unit { color: #ff6b00; }
      }

      .pc-label {
        font-size: 20rpx;
        color: #888;
        display: block;
        margin-bottom: 8rpx;
      }

      .pc-price {
        font-size: 32rpx;
        font-weight: 700;
        color: #1a1a1a;

        &.sub { font-size: 28rpx; color: #333; }
      }

      .pc-unit {
        font-size: 20rpx;
        color: #888;
        display: block;
        margin-top: 4rpx;
      }
    }
  }
}

.pile-section {
  .pile-tabs {
    display: flex;
    border-bottom: 1rpx solid #eee;
    margin: 0 24rpx;

    .pile-tab {
      flex: 1;
      text-align: center;
      padding: 24rpx 0;
      position: relative;
      text { font-size: 28rpx; color: #666; }

      &.active {
        text { color: #1a1a1a; font-weight: 700; font-size: 30rpx; }
        &::after {
          content: '';
          position: absolute;
          bottom: 0;
          left: 50%;
          transform: translateX(-50%);
          width: 48rpx;
          height: 4rpx;
          background: #07c160;
          border-radius: 2rpx;
        }
      }
    }
  }

  .pile-content {
    .pile-list-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 24rpx 24rpx 16rpx;

      .pile-list-title { font-size: 30rpx; font-weight: 700; color: #1a1a1a; }
      .pile-more { font-size: 24rpx; color: #999; }
    }

    .pile-filter-bar {
      white-space: nowrap;
      padding: 0 24rpx 20rpx;

      .pf-tag {
        display: inline-block;
        padding: 10rpx 32rpx;
        border-radius: 28rpx;
        font-size: 24rpx;
        margin-right: 16rpx;
        background: #f5f6fa;
        color: #666;

        &.active {
          background: #07c160;
          color: #fff;
        }
      }
    }

    .pile-detail-list {
      padding: 0 24rpx 28rpx;

      .pile-detail-card {
        display: flex;
        gap: 24rpx;
        padding: 28rpx 24rpx;
        background: #fff;
        border-radius: 16rpx;
        margin-bottom: 16rpx;
        border: 1rpx solid #f0f0f0;

        .pdc-left {
          flex-shrink: 0;
          display: flex;
          flex-direction: column;
          align-items: center;
          gap: 10rpx;

          .pdc-icon-wrap {
            width: 88rpx;
            height: 100rpx;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 16rpx;

            &.icon-charging { background: #fff7e6; }
            &.icon-free { background: #e8f8ee; }
            &.icon-fault { background: #fff1f0; }

            .pdc-icon-img {
              width: 72rpx;
              height: 84rpx;
            }
          }

          .pdc-badge {
            font-size: 22rpx;
            border-radius: 20rpx;
            padding: 4rpx 22rpx;
            background: #fff;

            &.badge-charging {
              color: #ff9500;
              border: 1rpx solid #ff9500;
            }

            &.badge-free {
              color: #07c160;
              border: 1rpx solid #07c160;
            }

            &.badge-fault {
              color: #f5222d;
              border: 1rpx solid #f5222d;
            }
          }
        }

        .pdc-right {
          flex: 1;
          min-width: 0;

          .pdc-row {
            display: flex;
            align-items: center;
            gap: 8rpx;
            line-height: 1.8;

            .pdc-label {
              font-size: 24rpx;
              color: #999;
              flex-shrink: 0;
              letter-spacing: 4rpx;
            }

            .pdc-value {
              font-size: 28rpx;
              color: #333;
              flex: 1;
              overflow: hidden;
              text-overflow: ellipsis;
              white-space: nowrap;

              &.bold { font-weight: 700; }
            }

            .pdc-copy-img {
              width: 32rpx;
              height: 32rpx;
              flex-shrink: 0;
            }

            &.price-row {
              .pdc-price { font-size: 28rpx; color: #333; font-weight: 500; }
              .pdc-price-link { font-size: 28rpx; color: #1b8e67; flex-shrink: 0; margin-left: auto; }
            }
          }

          .pdc-spec-row {
            display: flex;
            align-items: center;
            gap: 16rpx;
            margin-top: 6rpx;

            .spec-tag {
              font-size: 24rpx;
              color: #ff9500;
              background: #fff7e6;
              padding: 6rpx 18rpx;
              border-radius: 8rpx;
              font-weight: 500;
            }

            .spec-info { font-size: 24rpx; color: #888; }
          }

          .pdc-realtime-row {
            display: flex;
            align-items: center;
            gap: 8rpx;
            margin-top: 12rpx;
            padding-top: 12rpx;
            border-top: 1rpx dashed #eee;

            .rt-item { font-size: 24rpx; color: #666; }
            .rt-divider { font-size: 24rpx; color: #ddd; }

            .rt-item.remain { font-size: 24rpx; color: #ff9500; font-weight: 500; }

            &.free-row {
              .rt-item { font-size: 24rpx; color: #07c160; font-weight: 500; }
            }
          }
        }
      }
    }
  }
}

.calculator-section {
  .calculator-body {
    padding: 0 24rpx 28rpx;

    .calc-item {
      margin-bottom: 20rpx;

      .calc-label {
        font-size: 26rpx;
        color: #555;
        margin-bottom: 12rpx;
        display: block;
      }

      .calc-slider-wrap {
        display: flex;
        align-items: center;
        gap: 20rpx;

        slider {
          flex: 1;
        }

        .calc-value {
          font-size: 32rpx;
          font-weight: 700;
          color: #07c160;
          min-width: 56rpx;
          text-align: center;
        }
      }
    }

    .calc-summary {
      display: flex;
      background: #f8f9fc;
      border-radius: 12rpx;
      padding: 24rpx 0;
      margin-top: 12rpx;

      .summary-item {
        flex: 1;
        text-align: center;
        border-right: 1rpx solid #eee;

        &:last-child { border-right: none; }

        &.highlight { .s-value { color: #ff6b00; } }

        .s-label {
          font-size: 22rpx;
          color: #888;
          display: block;
          margin-bottom: 8rpx;
        }

        .s-value {
          font-size: 32rpx;
          font-weight: 700;
          color: #333;
        }
      }
    }
  }
}

.review-section {
  margin-bottom: 30rpx;

  .review-card {
    padding: 20rpx 24rpx;
    border-bottom: 1rpx solid #f9f9f9;

    .review-user {
      display: flex;
      align-items: center;

      .review-avatar {
        width: 56rpx;
        height: 56rpx;
        border-radius: 50%;
        background: #f0f0f0;
        margin-right: 12rpx;
      }

      .review-user-info {
        flex: 1;

        .review-nickname {
          font-size: 24rpx;
          color: #333;
          font-weight: 500;
        }
      }

      .review-time {
        font-size: 20rpx;
        color: #bbb;
      }
    }

    .review-content {
      font-size: 26rpx;
      color: #555;
      line-height: 1.6;
      margin-top: 12rpx;
      display: block;
    }

    .review-imgs {
      display: flex;
      gap: 12rpx;
      margin-top: 12rpx;

      image {
        width: 140rpx;
        height: 140rpx;
        border-radius: 8rpx;
        background: #f5f5f5;
      }
    }
  }
}

.bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  align-items: center;
  padding: 16rpx 24rpx;
  background: #fff;
  box-shadow: 0 -4rpx 20rpx rgba(0, 0, 0, 0.04);
  gap: 20rpx;

  .bb-left {
    flex-shrink: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    width: 100rpx;
    gap: 4rpx;

    text {
      font-size: 22rpx;
      color: #666;
    }
  }

  .bb-right {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8rpx;
    height: 80rpx;
    background: linear-gradient(135deg, #07c160, #06ad56);
    border-radius: 40rpx;
    box-shadow: 0 4rpx 16rpx rgba(7, 193, 96, 0.3);

    .bb-icon {
      font-size: 28rpx;
      color: #fff;
    }

    .bb-text {
      font-size: 30rpx;
      font-weight: 700;
      color: #fff;
    }

    &:active { opacity: 0.9; }
  }
}

.scan-charge-popup {
  background: #fff;
  border-radius: 24rpx;
  padding: 48rpx 40rpx 44rpx;
  width: 600rpx;

  .scp-header {
    text-align: center;

    .scp-title {
      font-size: 34rpx;
      font-weight: 700;
      color: #1a1a1a;
      display: block;
    }

    .scp-subtitle {
      font-size: 24rpx;
      color: #999;
      margin-top: 10rpx;
      display: block;
    }
  }

  .scp-scan-area {
    position: relative;
    width: 380rpx;
    height: 380rpx;
    margin: 36rpx auto 0;
    display: flex;
    align-items: center;
    justify-content: center;

    .scan-frame {
      position: absolute;
      width: 100%;
      height: 100%;
      border: 4rpx dashed #07c160;
      border-radius: 24rpx;
    }
  }

  .scp-divider-text {
    display: block;
    text-align: center;
    font-size: 24rpx;
    color: #999;
    margin-top: 28rpx;
  }

  .scp-input {
    height: 84rpx;
    background: #f5f6fa;
    border-radius: 12rpx;
    padding: 0 28rpx;
    font-size: 28rpx;
    color: #333;
    text-align: center;
    letter-spacing: 2rpx;
    margin-top: 20rpx;
  }

  .scp-connect-btn {
    width: 100%;
    height: 88rpx;
    line-height: 88rpx;
    background: linear-gradient(135deg, #07c160, #06ad56);
    color: #fff;
    font-size: 30rpx;
    font-weight: 700;
    border-radius: 44rpx;
    margin-top: 28rpx;
    border: none;

    &.disabled {
      opacity: 0.45;
    }

    &:active { transform: scale(0.98); }
  }
}

/* ========== 连接状态样式 ========== */
.connection-state-box {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 60rpx 40rpx 50rpx;
  min-width: 480rpx;

  /* 小车动画场景 */
  .conn-car-scene {
    position: relative;
    width: 360rpx;
    height: 120rpx;
    overflow: hidden;
    margin-bottom: 28rpx;

    .conn-road {
      position: absolute;
      bottom: 10rpx;
      left: 0;
      right: 0;
      height: 4rpx;
      background: rgba(0, 0, 0, 0.06);
      border-radius: 2rpx;

      .conn-road-dash {
        position: absolute;
        top: 0;
        left: 0;
        height: 100%;
        width: 200%;
        background: repeating-linear-gradient(
          90deg,
          rgba(7, 193, 96, 0.5) 0rpx,
          rgba(7, 193, 96, 0.5) 20rpx,
          transparent 20rpx,
          transparent 40rpx
        );
        animation: connRoadMove 0.6s linear infinite;
      }
    }

    .conn-car {
      position: absolute;
      bottom: 16rpx;
      left: -160rpx;
      width: 120rpx;
      height: 60rpx;
      animation: connCarDrive 2s ease-in-out infinite;

      .conn-car-top {
        position: absolute;
        top: 0;
        left: 24rpx;
        right: 24rpx;
        height: 22rpx;
        background: linear-gradient(135deg, #07c160, #5ae09e);
        border-radius: 12rpx 12rpx 0 0;
        z-index: 2;
      }

      .conn-car-body {
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        height: 38rpx;
        background: linear-gradient(135deg, #07c160, #06ad56);
        border-radius: 8rpx 8rpx 12rpx 12rpx;
        z-index: 1;
        display: flex;
        align-items: center;
        justify-content: flex-end;

        .conn-car-window {
          width: 24rpx;
          height: 16rpx;
          background: rgba(255, 255, 255, 0.3);
          border-radius: 3rpx;
          margin-right: 10rpx;
        }
      }

      .conn-car-wheels {
        position: absolute;
        bottom: -8rpx;
        left: 0;
        right: 0;
        display: flex;
        justify-content: space-around;

        .conn-wheel {
          width: 16rpx;
          height: 16rpx;
          background: #333;
          border: 3rpx solid #555;
          border-radius: 50%;

          &:first-child { margin-left: 16rpx; }
          &:last-child { margin-right: 16rpx; }
        }
      }
    }
  }

  .conn-spinner {
    width: 100rpx;
    height: 100rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 28rpx;
  }

  .conn-success-icon,
  .conn-fail-icon {
    width: 100rpx;
    height: 100rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 28rpx;
  }

  .conn-title {
    font-size: 34rpx;
    font-weight: 700;
    color: #1a1a1a;
    margin-bottom: 12rpx;

    &.success { color: #07c160; }
    &.fail { color: #f5222d; }
  }

  .conn-sub {
    font-size: 26rpx;
    color: #999;
    text-align: center;
    line-height: 1.5;
  }

  .retry-btn {
    margin-top: 40rpx;
    width: 80%;
    height: 80rpx;
    line-height: 80rpx;
    background: linear-gradient(135deg, #07c160, #06ad56);
    color: #fff;
    font-size: 30rpx;
    font-weight: 600;
    border-radius: 40rpx;
    border: none;

    &:active { opacity: 0.85; }
  }
}

.price-detail-popup {
  background: #fff;
  border-radius: 24rpx 24rpx 0 0;
  padding: 32rpx 24rpx 60rpx;

  .popup-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 24rpx;

    .popup-title {
      font-size: 34rpx;
      font-weight: 700;
      color: #1a1a1a;
    }
  }

  .price-time-grid {
    .pt-row {
      display: grid;
      grid-template-columns: 1fr 1fr 1fr 1fr;
      padding: 20rpx 8rpx;
      border-bottom: 1rpx solid #f5f5f5;

      &.header {
        .pt-cell {
          font-size: 22rpx;
          color: #999;
          font-weight: 500;
        }
      }

      &.active {
        background: #f0fff4;
        border-radius: 8rpx;
      }

      .pt-cell {
        font-size: 26rpx;
        color: #555;
        text-align: center;

        &.highlight {
          color: #ff6b00;
          font-weight: 700;
        }
      }
    }
  }
}

/* 小车行驶动画 */
@keyframes connCarDrive {
  0%   { transform: translateX(-160rpx); }
  50%  { transform: translateX(calc(100% + 160rpx)); }
  100% { transform: translateX(-160rpx); }
}

/* 公路虚线移动 */
@keyframes connRoadMove {
  0%   { transform: translateX(0); }
  100% { transform: translateX(-50%); }
}

/* ========== 导航地图弹窗 ========== */
.navi-map-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 999;
  background: #fff;
  display: none;
  flex-direction: column;
}

.navi-map-overlay.navi-map-active {
  display: flex;
}

.navi-map-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12rpx 20rpx;
  background: #fff;
  border-bottom: 1rpx solid #f0f0f0;
  position: relative;
  z-index: 10;
}

.navi-back-btn {
  width: 80rpx;
  height: 80rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.navi-map-title {
  font-size: 30rpx;
  font-weight: 600;
  color: #333;
  flex: 1;
  text-align: center;
}

.navi-map-info {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16rpx 30rpx;
  background: #f5f7fa;
  gap: 20rpx;
}

.navi-info-item {
  font-size: 26rpx;
  color: #666;
}

.navi-info-divider {
  color: #ddd;
  font-size: 24rpx;
}

.navi-map-body {
  flex: 1;
  width: 100%;
  min-height: 0;
}

.navi-map-actions {
  display: flex;
  align-items: center;
  justify-content: space-around;
  padding: 20rpx 30rpx;
  padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
  background: #fff;
  border-top: 1rpx solid #f0f0f0;
  gap: 20rpx;
}

.navi-action-btn {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8rpx;
  height: 88rpx;
  border-radius: 44rpx;
  border: 2rpx solid #07c160;
  background: #fff;
  color: #07c160;
  font-size: 28rpx;
  font-weight: 500;
}

.navi-action-btn.primary {
  background: #07c160;
  color: #fff;
  border: none;
}

/* ========== 路线选择器（仿高德APP） ========== */
.navi-routes {
  background: #fff;
  padding: 16rpx 0;
  border-top: 1rpx solid #f0f0f0;
}

.navi-routes-scroll {
  white-space: nowrap;
  padding: 0 20rpx;
}

.navi-route-card {
  display: inline-flex;
  flex-direction: column;
  background: #f5f7fa;
  border-radius: 16rpx;
  padding: 14rpx 22rpx;
  margin-right: 16rpx;
  min-width: 200rpx;
  cursor: pointer;
  position: relative;
  border: 3rpx solid transparent;
  transition: all 0.2s;
}

.navi-route-card:last-child {
  margin-right: 0;
}

.navi-route-active {
  background: #e8f7ff;
  border-color: #3c96f3;
}

.nrc-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12rpx;
  margin-bottom: 6rpx;
}

.nrc-label {
  font-size: 24rpx;
  font-weight: 700;
  color: #333;
  padding: 2rpx 10rpx;
  border-radius: 6rpx;
  background: #e0e0e0;
}

.nrc-label-primary {
  background: #3c96f3;
  color: #fff;
}

.nrc-time {
  font-size: 30rpx;
  font-weight: 700;
  color: #1a1a1a;
}

.navi-route-active .nrc-time {
  color: #3c96f3;
}

.nrc-detail {
  display: flex;
  align-items: center;
  gap: 8rpx;
}

.nrc-dist,
.nrc-tolls {
  font-size: 22rpx;
  color: #999;
}

.nrc-dot {
  font-size: 22rpx;
  color: #ccc;
}

.navi-route-active .nrc-dist,
.navi-route-active .nrc-tolls {
  color: #666;
}
</style>