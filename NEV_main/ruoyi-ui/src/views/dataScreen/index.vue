<template>
  <div class="data-screen-wrapper">
    <transition name="fade">
      <div v-if="loading" class="loading-overlay">
        <div class="loading-spinner">
          <div class="spinner-ring"></div>
          <div class="spinner-core"></div>
        </div>
        <p class="loading-title">数据大屏加载中</p>
        <p class="loading-text">{{ loadingText }}</p>
        <div class="loading-progress">
          <div class="progress-bar" :style="{ width: loadingProgress + '%' }"></div>
        </div>
      </div>
    </transition>

    <transition name="fade">
      <div v-if="error" class="error-overlay">
        <div class="error-box">
          <i class="el-icon-warning-outline"></i>
          <p>{{ error }}</p>
          <el-button type="primary" size="small" @click="retry">重试</el-button>
        </div>
      </div>
    </transition>

    <div v-show="!loading && !error" class="data-screen">
      <div class="bg-light-beam"></div>
      <div class="bg-particles">
        <span class="particle p1"></span>
        <span class="particle p2"></span>
        <span class="particle p3"></span>
        <span class="particle p4"></span>
        <span class="particle p5"></span>
        <span class="particle p6"></span>
        <span class="particle p7"></span>
        <span class="particle p8"></span>
        <span class="particle p9"></span>
        <span class="particle p10"></span>
        <span class="particle p11"></span>
        <span class="particle p12"></span>
        <span class="particle p13"></span>
        <span class="particle p14"></span>
        <span class="particle p15"></span>
      </div>
      <div class="bg-scanline"></div>
      <header class="screen-header">
        <div class="screen-title">
          <div class="title-deco">
            <span class="deco-bar"></span>
            <span class="deco-chevron"></span>
          </div>
          <span class="title-text">山东省新能源汽车综合数据大屏</span>
          <div class="title-deco">
            <span class="deco-chevron right"></span>
            <span class="deco-bar"></span>
          </div>
        </div>
        <div class="stats-row">
          <div class="stat-card card-carbon">
            <svg class="card-icon-svg" viewBox="0 0 48 48">
              <path d="M24 4c-3 8-8 14-8 22c0 5 3 10 8 12c5-2 8-7 8-12c0-8-5-14-8-22z" fill="none" stroke="#00E676" stroke-width="2.2" stroke-linejoin="round"/>
              <path d="M24 16v24" fill="none" stroke="#00E676" stroke-width="1.8" stroke-linecap="round"/>
              <path d="M18 28h12" fill="none" stroke="#00E676" stroke-width="1.5" stroke-linecap="round"/>
              <path d="M20 32h8" fill="none" stroke="#00E676" stroke-width="1" stroke-linecap="round" opacity="0.6"/>
            </svg>
            <div class="card-body">
              <span class="card-label">碳减排总量</span>
              <span class="card-value">
                <count-to :start-val="0" :end-val="totalReduction" :duration="2500" separator="," />
                <small>万吨</small>
              </span>
              <span class="card-trend up">同比 +12.5%</span>
            </div>
          </div>

          <div class="stat-card card-piles">
            <svg class="card-icon-svg" viewBox="0 0 48 48">
              <path d="M26 4l-8 16h7l-3 12l10-16h-7l3-12z" fill="none" stroke="#36A3F7" stroke-width="2.2" stroke-linejoin="round"/>
            </svg>
            <div class="card-body">
              <span class="card-label">充电桩总量</span>
              <span class="card-value">
                <count-to :start-val="0" :end-val="totalPiles" :duration="2500" separator="," />
                <small>个</small>
              </span>
              <span class="card-trend up">同比 +22.5%</span>
            </div>
          </div>

          <div class="stat-card card-ev">
            <svg class="card-icon-svg" viewBox="0 0 48 48">
              <path d="M10 30l5-12h18l5 12v4h-2v8h-8v-8h-8v8h-8v-8h-2v-4z" fill="none" stroke="#00E5FF" stroke-width="2.2" stroke-linejoin="round"/>
              <circle cx="16" cy="36" r="3" fill="none" stroke="#00E5FF" stroke-width="2"/>
              <circle cx="32" cy="36" r="3" fill="none" stroke="#00E5FF" stroke-width="2"/>
            </svg>
            <div class="card-body">
              <span class="card-label">新能源汽车保有量</span>
              <span class="card-value">
                <count-to :start-val="0" :end-val="totalEV" :duration="2500" separator="," />
                <small>辆</small>
              </span>
              <span class="card-trend up">同比 +15.8%</span>
            </div>
          </div>
        </div>
      </header>

      <section class="main-content">
        <div class="side-panel panel-left">
          <h4 class="panel-title">
            <i class="title-dot carbon-dot"></i>碳减排与植树排行
          </h4>
          <div class="table-scroll">
            <table class="data-table">
              <thead>
                <tr>
                  <th class="col-rank">#</th>
                  <th class="col-name">区县</th>
                  <th class="col-val">碳减排(吨)</th>
                  <th class="col-val">植树(棵)</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(row, i) in leftCityData" :key="row.city" :class="{ 'row-top3': i < 3 }">
                  <td class="col-rank">
                    <span class="rank-badge" :class="'rank-' + (i + 1)">{{ i + 1 }}</span>
                  </td>
                  <td class="col-name">{{ row.city }}</td>
                  <td class="col-val">{{ row.metric1.toFixed(0) }}</td>
                  <td class="col-val">{{ row.trees.toLocaleString() }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <div class="map-section">
          <div class="map-grid">
            <div class="floor-scene">
              <div class="grid-plane"></div>
              <div class="grid-fade"></div>
              <div class="horizon-glow"></div>
              <div class="horizon-line"></div>
            </div>
          </div>
          <div class="map-glow"></div>
          <div class="map-perspective">
            <div class="map-chart" ref="mapChart"></div>
          </div>
          <span class="breath-dot dot-tl"></span>
          <span class="breath-dot dot-tr"></span>
          <span class="breath-dot dot-bl"></span>
          <span class="breath-dot dot-br"></span>
          <div class="bottom-radar" :style="radarStyle">
            <span class="br-ring r1"></span>
            <span class="br-ring r2"></span>
            <span class="br-ring r3"></span>
            <span class="br-beam"></span>
          </div>
          <div class="map-legend">
            <span class="legend-item" @mouseenter="showLegendTip = true" @mouseleave="showLegendTip = false">
              <i class="legend-leaf-icon"></i>
              <span>综合环保指标</span>
              <transition name="tip-fade">
                <div class="legend-tooltip" v-show="showLegendTip">
                  <div class="tip-arrow"></div>
                  基于碳减排、新能源车、充电桩三指标综合评估
                </div>
              </transition>
            </span>
          </div>
        </div>

        <div class="side-panel panel-right">
          <h4 class="panel-title">
            <i class="title-dot pile-dot"></i>新能源车与充电桩排行
          </h4>
          <div class="table-scroll">
            <table class="data-table">
              <thead>
                <tr>
                  <th class="col-rank">#</th>
                  <th class="col-name">区县</th>
                  <th class="col-val">新能源车(辆)</th>
                  <th class="col-val">充电桩(个)</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(row, i) in rightCityData" :key="row.city" :class="{ 'row-top3': i < 3 }">
                  <td class="col-rank">
                    <span class="rank-badge" :class="'rank-' + (i + 1)">{{ i + 1 }}</span>
                  </td>
                  <td class="col-name">{{ row.city }}</td>
                  <td class="col-val">{{ row.ev.toLocaleString() }}</td>
                  <td class="col-val">{{ row.piles.toLocaleString() }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </section>

      <div class="action-buttons">
        <el-tooltip content="全屏展示" placement="left">
          <div class="action-btn" @click="toggleFullscreen">
            <svg-icon :icon-class="isFullscreen ? 'exit-fullscreen' : 'fullscreen'" />
          </div>
        </el-tooltip>
        <el-tooltip content="刷新数据" placement="left">
          <div class="action-btn" @click="refreshData">
            <i class="el-icon-refresh"></i>
          </div>
        </el-tooltip>
      </div>
    </div>
  </div>
</template>

<script>
import * as echarts from 'echarts'
import CountTo from 'vue-count-to'
import screenfull from 'screenfull'

const SHANDONG_GEOJSON_URL = 'https://geo.datav.aliyun.com/areas_v3/bound/370000_full.json'

const ICON_LEAF = 'path://M24 4 Q8 18 8 28 Q8 40 20 44 L24 38 L28 44 Q40 40 40 28 Q40 18 24 4 Z M24 38 L24 47'

const SHANDONG_CITIES = [
  ['历下区', 117.00, 36.65], ['市南区', 120.38, 36.07],
  ['张店区', 118.05, 36.78], ['薛城区', 117.32, 34.82],
  ['东营区', 118.50, 37.47], ['芝罘区', 121.43, 37.45],
  ['奎文区', 119.10, 36.70], ['任城区', 116.58, 35.42],
  ['泰山区', 117.08, 36.20], ['环翠区', 122.12, 37.52],
  ['东港区', 119.52, 35.42], ['兰山区', 118.35, 35.05],
  ['德城区', 116.30, 37.45], ['东昌府区', 115.98, 36.45],
  ['滨城区', 118.02, 37.38], ['牡丹区', 115.43, 35.25],
  ['莱芜区', 117.67, 36.20], ['滕州市', 117.17, 35.08],
  ['曲阜市', 116.98, 35.58], ['诸城市', 119.40, 35.98],
  ['寿光市', 118.73, 36.88], ['邹城市', 117.00, 35.40],
  ['新泰市', 117.77, 35.91], ['肥城市', 116.77, 36.18],
  ['平度市', 119.96, 36.78], ['莱州市', 119.94, 37.18],
  ['荣成市', 122.48, 37.17], ['沂水县', 118.63, 35.78]
]

// 为每个地级市生成3个模拟数据指标，按平均值映射绿色梯度
function generateCityMetrics(carbonData, evData, pilesData) {
  const cityCarbon = {}, cityEV = {}, cityPiles = {}
  carbonData.forEach(d => { cityCarbon[d.name] = d.value })
  evData.forEach(d => { cityEV[d.name] = d.value })
  pilesData.forEach(d => { cityPiles[d.name] = d.value })

  return SHANDONG_CITIES.map(([city, lng, lat]) => {
    const metric1 = cityCarbon[city] || Math.round(500 + Math.random() * 3000)
    const metric2 = cityEV[city] || Math.round(2000 + Math.random() * 8000)
    const metric3 = cityPiles[city] || Math.round(300 + Math.random() * 1500)
    return { city, lng, lat, metric1, metric2, metric3 }
  })
}

// 绿色梯度：平均值归一化 → 浅青(#80ffaa)到深绿(#006633)
function getGreenColor(avg, minAvg, maxAvg) {
  const t = maxAvg > minAvg ? (avg - minAvg) / (maxAvg - minAvg) : 0.5
  // t: 0=浅绿, 1=深绿
  const r = Math.round(128 * (1 - t))
  const g = Math.round(255 * (1 - t * 0.6))
  const b = Math.round(170 * (1 - t * 0.85))
  return `rgb(${r}, ${g}, ${b})`
}

export default {
  name: 'screen',
  components: { CountTo },
  data() {
    const carbonReductionData = [
      { name: '历下区', value: 12800, growth: 14.2 },
      { name: '市南区', value: 11500, growth: 18.5 },
      { name: '张店区', value: 9600, growth: 12.8 },
      { name: '薛城区', value: 5800, growth: 20.3 },
      { name: '东营区', value: 7200, growth: 11.6 },
      { name: '芝罘区', value: 10200, growth: 16.8 },
      { name: '奎文区', value: 10800, growth: 19.2 },
      { name: '任城区', value: 8500, growth: 22.1 },
      { name: '泰山区', value: 6800, growth: 15.4 },
      { name: '环翠区', value: 6200, growth: 13.5 },
      { name: '东港区', value: 5200, growth: 24.8 },
      { name: '兰山区', value: 11200, growth: 26.5 },
      { name: '德城区', value: 7800, growth: 17.2 },
      { name: '东昌府区', value: 6500, growth: 21.8 },
      { name: '滨城区', value: 5600, growth: 18.6 },
      { name: '牡丹区', value: 7200, growth: 28.3 },
      { name: '莱芜区', value: 3200, growth: 10.5 },
      { name: '滕州市', value: 4800, growth: 22.5 },
      { name: '曲阜市', value: 2800, growth: 16.2 },
      { name: '诸城市', value: 4200, growth: 19.8 },
      { name: '寿光市', value: 3500, growth: 15.6 },
      { name: '邹城市', value: 3800, growth: 20.5 },
      { name: '新泰市', value: 2600, growth: 14.8 },
      { name: '肥城市', value: 2400, growth: 12.5 },
      { name: '平度市', value: 3100, growth: 18.2 },
      { name: '莱州市', value: 2800, growth: 16.8 },
      { name: '荣成市', value: 2200, growth: 11.2 },
      { name: '沂水县', value: 1800, growth: 13.5 }
    ]
    const evData = [
      { name: '历下区', value: 285000, growth: 18.2 },
      { name: '市南区', value: 320000, growth: 22.5 },
      { name: '张店区', value: 168000, growth: 14.8 },
      { name: '薛城区', value: 95000, growth: 25.6 },
      { name: '东营区', value: 125000, growth: 16.2 },
      { name: '芝罘区', value: 245000, growth: 20.8 },
      { name: '奎文区', value: 210000, growth: 24.5 },
      { name: '任城区', value: 185000, growth: 28.3 },
      { name: '泰山区', value: 132000, growth: 19.6 },
      { name: '环翠区', value: 108000, growth: 15.2 },
      { name: '东港区', value: 92000, growth: 30.5 },
      { name: '兰山区', value: 258000, growth: 32.1 },
      { name: '德城区', value: 145000, growth: 21.8 },
      { name: '东昌府区', value: 118000, growth: 26.5 },
      { name: '滨城区', value: 98000, growth: 22.2 },
      { name: '牡丹区', value: 155000, growth: 35.6 },
      { name: '莱芜区', value: 62000, growth: 12.8 },
      { name: '滕州市', value: 88000, growth: 28.5 },
      { name: '曲阜市', value: 48000, growth: 18.6 },
      { name: '诸城市', value: 75000, growth: 24.2 },
      { name: '寿光市', value: 65000, growth: 18.8 },
      { name: '邹城市', value: 72000, growth: 25.5 },
      { name: '新泰市', value: 52000, growth: 16.5 },
      { name: '肥城市', value: 45000, growth: 14.2 },
      { name: '平度市', value: 58000, growth: 22.5 },
      { name: '莱州市', value: 50000, growth: 20.2 },
      { name: '荣成市', value: 42000, growth: 13.5 },
      { name: '沂水县', value: 35000, growth: 15.8 }
    ]
    const pilesData = [
      { name: '历下区', value: 32000, growth: 12.5 },
      { name: '市南区', value: 38000, growth: 16.8 },
      { name: '张店区', value: 18500, growth: 10.2 },
      { name: '薛城区', value: 10500, growth: 22.5 },
      { name: '东营区', value: 13800, growth: 11.8 },
      { name: '芝罘区', value: 28000, growth: 18.5 },
      { name: '奎文区', value: 25000, growth: 20.2 },
      { name: '任城区', value: 19800, growth: 25.6 },
      { name: '泰山区', value: 14200, growth: 14.8 },
      { name: '环翠区', value: 12500, growth: 12.5 },
      { name: '东港区', value: 9800, growth: 28.5 },
      { name: '兰山区', value: 29000, growth: 30.2 },
      { name: '德城区', value: 15800, growth: 18.6 },
      { name: '东昌府区', value: 12800, growth: 24.5 },
      { name: '滨城区', value: 10800, growth: 16.8 },
      { name: '牡丹区', value: 16800, growth: 32.5 },
      { name: '莱芜区', value: 6500, growth: 8.5 },
      { name: '滕州市', value: 9500, growth: 25.2 },
      { name: '曲阜市', value: 5200, growth: 15.6 },
      { name: '诸城市', value: 8200, growth: 22.5 },
      { name: '寿光市', value: 7200, growth: 16.2 },
      { name: '邹城市', value: 7800, growth: 22.8 },
      { name: '新泰市', value: 5800, growth: 14.2 },
      { name: '肥城市', value: 4800, growth: 11.5 },
      { name: '平度市', value: 6200, growth: 20.5 },
      { name: '莱州市', value: 5500, growth: 18.2 },
      { name: '荣成市', value: 4500, growth: 10.5 },
      { name: '沂水县', value: 3800, growth: 12.8 }
    ]

    return {
      loading: true,
      loadingText: '正在初始化数据大屏...',
      loadingProgress: 0,
      error: null,
      isFullscreen: false,

      mapChart: null,
      resizeTimer: null,

      showLegendTip: false,

      carbonReductionData,
      evData,
      pilesData,

      totalReduction: 0,
      totalPiles: 0,
      totalEV: 0,

      treeRatio: 85,

      radarStyle: { left: '50%', top: '50%' }
    }
  },
  computed: {
    cityData() {
      return generateCityMetrics(this.carbonReductionData, this.evData, this.pilesData)
    },
    cityScatterData() {
      const data = this.cityData
      const avgList = data.map(d => (d.metric1 + d.metric2 + d.metric3) / 3)
      const minAvg = Math.min(...avgList)
      const maxAvg = Math.max(...avgList)
      return data.map(d => {
        const avg = (d.metric1 + d.metric2 + d.metric3) / 3
        const color = getGreenColor(avg, minAvg, maxAvg)
        return {
          name: d.city,
          value: [d.lng, d.lat, Math.round(avg)],
          metric1: d.metric1,
          metric2: d.metric2,
          metric3: d.metric3,
          avg: Math.round(avg),
          itemStyle: { color, shadowBlur: 6, shadowColor: 'rgba(0,230,118,0.25)' }
        }
      })
    },
    leftCityData() {
      return [...this.cityData]
        .sort((a, b) => b.metric1 - a.metric1)
        .slice(0, 10)
        .map(d => ({
          ...d,
          trees: Math.round(d.metric1 * 12)
        }))
    },
    rightCityData() {
      return [...this.cityData]
        .sort((a, b) => (b.metric2 + b.metric3) - (a.metric2 + a.metric3))
        .slice(0, 10)
        .map(d => ({
          ...d,
          ev: Math.round(d.metric2 * 10),
          piles: Math.round(d.metric3 * 10)
        }))
    }
  },
  mounted() {
    this.initFullscreen()
    window.addEventListener('resize', this.handleResize)
    this.initScreen()
  },
  beforeDestroy() {
    if (this.resizeTimer) clearTimeout(this.resizeTimer)
    window.removeEventListener('resize', this.handleResize)
    if (screenfull.isEnabled) {
      screenfull.off('change', this.onFullscreenChange)
    }
    if (this.mapChart) { this.mapChart.dispose() }
    this.$store.dispatch('app/toggleSideBarHide', false)
  },
  methods: {
    async initScreen() {
      try {
        this.computeTotals()
        this.updateLoading('正在加载山东地图数据...', 20)

        const geoJson = await this.fetchShandongGeoJSON()
        echarts.registerMap('shandong', geoJson)

        this.updateLoading('正在初始化图表...', 80)
        this.loading = false
        await this.$nextTick()

        this.initMapChart()
      } catch (err) {
        console.error('数据大屏初始化失败：', err)
        this.error = '数据大屏初始化失败：' + (err.message || '未知错误')
        this.loading = false
      }
    },

    retry() {
      this.loading = true
      this.error = null
      this.loadingProgress = 0
      if (this.mapChart) { this.mapChart.dispose(); this.mapChart = null }
      this.initScreen()
    },

    updateLoading(text, progress) {
      this.loadingText = text
      this.loadingProgress = progress
    },

    computeTotals() {
      const sum = (arr) => arr.reduce((acc, item) => acc + item.value, 0)
      this.totalReduction = sum(this.carbonReductionData)
      this.totalPiles = sum(this.pilesData)
      this.totalEV = sum(this.evData)
    },

    async refreshData() {
      this.$message.success('数据已刷新（当前为模拟数据）')
      if (this.mapChart) this.mapChart.resize()
    },

    async fetchShandongGeoJSON() {
      const response = await fetch(SHANDONG_GEOJSON_URL)
      if (!response.ok) throw new Error('山东地图数据加载失败，HTTP ' + response.status)
      return response.json()
    },

    updateRadarPosition() {
      if (!this.mapChart) return
      const option = this.mapChart.getOption()
      if (!option.geo || !option.geo[0]) return
      const center = option.geo[0].center || [117.5, 36.3]
      const pixel = this.mapChart.convertToPixel({geoIndex: 0}, center)
      if (pixel) {
        this.radarStyle = { left: pixel[0] + 'px', top: pixel[1] + 'px' }
      }
    },

    initMapChart() {
      const dom = this.$refs.mapChart
      if (!dom || dom.clientWidth === 0) {
        setTimeout(() => this.initMapChart(), 200)
        return
      }
      this.mapChart = echarts.init(dom)
      this.mapChart.setOption(this.buildMapOption())
      this.updateRadarPosition()
      this.mapChart.on('georoam', () => { this.updateRadarPosition() })
      this.mapChart.on('click', (params) => {
        if (params.componentType === 'effectScatter' && params.data) {
          console.log('点击省份:', params.data.name)
        }
      })
    },

    buildMapOption() {
      const series = []

      series.push({
        name: 'cityScatter',
        type: 'effectScatter',
        coordinateSystem: 'geo',
        data: this.cityScatterData,
        symbol: ICON_LEAF,
        symbolSize: 12,
        itemStyle: {
          shadowBlur: 4,
          shadowColor: 'rgba(0,230,118,0.2)'
        },
        rippleEffect: {
          brushType: 'stroke',
          scale: 2.5,
          period: 4
        },
        label: { show: false },
        emphasis: {
          scale: 1.2,
          label: {
            show: true,
            formatter: (p) => p.data.name,
            color: '#fff',
            fontSize: 11,
            fontWeight: 'bold',
            backgroundColor: 'rgba(0,0,0,0.65)',
            padding: [2, 6],
            borderRadius: 3,
            position: 'top'
          },
          itemStyle: {
            shadowBlur: 18,
            shadowColor: 'rgba(0,230,118,0.6)'
          }
        },
        rippleEffect: { brushType: 'stroke', scale: 3, period: 4 },
        zlevel: 3
      })

      return {
        backgroundColor: 'transparent',
        tooltip: {
          trigger: 'item',
          backgroundColor: 'rgba(10,22,50,0.92)',
          borderColor: 'rgba(0,212,255,0.4)',
          extraCssText: 'box-shadow: 0 0 20px rgba(0,200,255,0.15); padding: 8px 12px;',
          textStyle: { color: '#fff', fontSize: 13 },
          formatter: (p) => {
            if (!p.data) return ''
            if (p.data.metric1 !== undefined) {
              const line1 = '<div style="font-size:14px;font-weight:bold;color:#00E676;margin-bottom:5px;border-bottom:1px solid rgba(255,255,255,0.1);padding-bottom:4px;">' + p.data.name + '</div>'
              const m1 = '<div style="display:flex;align-items:center;gap:6px;margin:2px 0;line-height:1.8;"><span style="display:inline-block;width:6px;height:6px;border-radius:50%;background:#00E676;"></span><span style="color:rgba(255,255,255,0.55);font-size:12px;">碳减排</span><span style="color:#fff;font-weight:600;margin-left:auto;">' + (p.data.metric1).toLocaleString() + ' 吨</span></div>'
              const m2 = '<div style="display:flex;align-items:center;gap:6px;margin:2px 0;line-height:1.8;"><span style="display:inline-block;width:6px;height:6px;border-radius:50%;background:#00E5FF;"></span><span style="color:rgba(255,255,255,0.55);font-size:12px;">新能源车</span><span style="color:#fff;font-weight:600;margin-left:auto;">' + (p.data.metric2).toLocaleString() + ' 辆</span></div>'
              const m3 = '<div style="display:flex;align-items:center;gap:6px;margin:2px 0;line-height:1.8;"><span style="display:inline-block;width:6px;height:6px;border-radius:50%;background:#36A3F7;"></span><span style="color:rgba(255,255,255,0.55);font-size:12px;">充电桩</span><span style="color:#fff;font-weight:600;margin-left:auto;">' + (p.data.metric3).toLocaleString() + ' 个</span></div>'
              return line1 + m1 + m2 + m3
            }
            return '<div style="font-size:14px;font-weight:bold;color:#00E5FF;margin-bottom:4px;">' + p.data.name + '</div>'
              + '<div style="color:#ccc;line-height:20px;">' + p.data.label + '</div>'
          }
        },
        geo: {
          map: 'shandong',
          roam: true,
          zoom: 1.4,
          center: [117.5, 36.3],
          aspectScale: 0.85,
          label: { show: false },
          itemStyle: {
            areaColor: {
              type: 'radial',
              x: 0.5, y: 0.5, r: 0.8,
              colorStops: [
                { offset: 0, color: 'rgba(28, 80, 155, 0.6)' },
                { offset: 1, color: 'rgba(14, 38, 80, 0.7)' }
              ]
            },
            borderColor: '#4FC3F7',
            borderWidth: 2,
            shadowBlur: 4,
            shadowOffsetY: 1,
            shadowColor: 'rgba(79, 195, 247, 0.08)'
          },
          emphasis: {
            label: {
              show: true,
              color: '#fff',
              fontSize: 10
            },
            itemStyle: { areaColor: 'rgba(40, 95, 175, 0.45)', borderColor: '#4FC3F7', borderWidth: 2.5 }
          }
        },
        series
      }
    },

    initFullscreen() {
      if (screenfull.isEnabled) {
        screenfull.on('change', this.onFullscreenChange)
      }
    },

    onFullscreenChange() {
      this.isFullscreen = screenfull.isFullscreen
      if (!this.isFullscreen) {
        this.$store.dispatch('app/toggleSideBarHide', false)
      }
      this.$nextTick(() => {
        if (this.mapChart && !this.mapChart.isDisposed()) this.mapChart.resize()
      })
    },

    toggleFullscreen() {
      if (!screenfull.isEnabled) {
        this.$message.warning('您的浏览器不支持全屏功能')
        return
      }
      if (!this.isFullscreen) {
        this.$store.dispatch('app/toggleSideBarHide', true)
        this.$nextTick(() => {
          screenfull.request(this.$el)
        })
      } else {
        screenfull.exit()
      }
    },

    handleResize() {
      if (this.resizeTimer) clearTimeout(this.resizeTimer)
      this.resizeTimer = setTimeout(() => {
        if (this.mapChart && !this.mapChart.isDisposed()) this.mapChart.resize()
      }, 300)
    }
  }
}
</script>

<style lang="scss" scoped>
.data-screen-wrapper {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  overflow: hidden;
  background: #0a1632;
  font-family: "Microsoft YaHei", "PingFang SC", "Helvetica Neue", sans-serif;
}

// ======== 加载动画 ========
.loading-overlay {
  position: absolute;
  inset: 0;
  z-index: 1000;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: radial-gradient(ellipse at center, #0d1a45 0%, #0a1632 70%);
}

.loading-spinner {
  position: relative;
  width: 80px;
  height: 80px;
  margin-bottom: 24px;
  .spinner-ring {
    position: absolute;
    inset: 0;
    border: 3px solid transparent;
    border-top-color: #36A3F7;
    border-right-color: #00E676;
    border-radius: 50%;
    animation: spin 1.2s linear infinite;
  }
  .spinner-core {
    position: absolute;
    inset: 15px;
    border: 2px solid transparent;
    border-bottom-color: #00E5FF;
    border-left-color: #36A3F7;
    border-radius: 50%;
    animation: spin 0.8s linear infinite reverse;
  }
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.loading-title {
  font-size: 20px;
  color: #00E5FF;
  margin: 0 0 8px;
  letter-spacing: 4px;
}

.loading-text {
  font-size: 13px;
  color: rgba(255, 255, 255, 0.5);
  margin: 0 0 24px;
}

.loading-progress {
  width: 240px;
  height: 3px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 2px;
  overflow: hidden;
  .progress-bar {
    height: 100%;
    background: linear-gradient(90deg, #36A3F7, #00E5FF, #00E676);
    border-radius: 2px;
    transition: width 0.4s ease;
  }
}

// ======== 错误提示 ========
.error-overlay {
  position: absolute;
  inset: 0;
  z-index: 1000;
  display: flex;
  align-items: center;
  justify-content: center;
  background: radial-gradient(ellipse at center, #0d1a45 0%, #0a1632 70%);
}

.error-box {
  text-align: center;
  color: #ff4d4f;
  i { font-size: 56px; display: block; margin-bottom: 16px; }
  p { font-size: 15px; margin: 0 0 20px; color: rgba(255, 255, 255, 0.7); }
}

// ======== 主屏幕 ========
.data-screen {
  position: relative;
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  background:
    linear-gradient(rgba(0, 212, 255, 0.025) 1px, transparent 1px),
    linear-gradient(90deg, rgba(0, 212, 255, 0.025) 1px, transparent 1px),
    radial-gradient(ellipse at 50% 30%, #0d1f50 0%, #0a1632 100%);
  background-size: 50px 50px, 50px 50px, 100% 100%;
}

// ======== 背景动态光晕 ========
.bg-light-beam {
  position: absolute;
  top: -20%;
  left: -20%;
  width: 60%;
  height: 140%;
  background: radial-gradient(ellipse at 30% 50%, rgba(0, 230, 118, 0.04) 0%, transparent 60%);
  transform: rotate(25deg);
  animation: lightSweep 8s ease-in-out infinite;
  pointer-events: none;
  z-index: 0;
}

@keyframes lightSweep {
  0%, 100% { transform: rotate(25deg) translateX(-10%); opacity: 0.3; }
  50% { transform: rotate(25deg) translateX(60%); opacity: 0.7; }
}

// ======== 背景浮动粒子 ========
.bg-particles {
  position: absolute;
  inset: 0;
  pointer-events: none;
  z-index: 0;
  overflow: hidden;
}

.particle {
  position: absolute;
  width: 3px;
  height: 3px;
  border-radius: 50%;
  background: rgba(0, 230, 118, 0.25);
  animation: floatParticle 12s ease-in-out infinite;
}

.particle.p1 { left: 10%; top: 20%; width: 2px; height: 2px; animation-duration: 14s; animation-delay: 0s; background: rgba(0, 230, 118, 0.2); }
.particle.p2 { left: 25%; top: 60%; width: 4px; height: 4px; animation-duration: 18s; animation-delay: 2s; background: rgba(0, 229, 255, 0.15); }
.particle.p3 { left: 45%; top: 10%; width: 3px; height: 3px; animation-duration: 16s; animation-delay: 4s; background: rgba(54, 163, 247, 0.2); }
.particle.p4 { left: 65%; top: 70%; width: 5px; height: 5px; animation-duration: 20s; animation-delay: 1s; background: rgba(0, 230, 118, 0.15); }
.particle.p5 { left: 80%; top: 30%; width: 2px; height: 2px; animation-duration: 13s; animation-delay: 5s; background: rgba(0, 229, 255, 0.2); }
.particle.p6 { left: 50%; top: 80%; width: 3px; height: 3px; animation-duration: 17s; animation-delay: 3s; background: rgba(54, 163, 247, 0.15); }
.particle.p7 { left: 90%; top: 15%; width: 4px; height: 4px; animation-duration: 15s; animation-delay: 6s; background: rgba(0, 230, 118, 0.18); }
.particle.p8 { left: 15%; top: 85%; width: 2px; height: 2px; animation-duration: 19s; animation-delay: 0.5s; background: rgba(0, 229, 255, 0.2); }
.particle.p9 { left: 72%; top: 50%; width: 3px; height: 3px; animation-duration: 14s; animation-delay: 3.2s; background: rgba(54, 163, 247, 0.22); }
.particle.p10 { left: 35%; top: 40%; width: 5px; height: 5px; animation-duration: 21s; animation-delay: 1.8s; background: rgba(0, 230, 118, 0.16); }
.particle.p11 { left: 88%; top: 75%; width: 2px; height: 2px; animation-duration: 16s; animation-delay: 4.5s; background: rgba(0, 229, 255, 0.18); }
.particle.p12 { left: 5%; top: 45%; width: 4px; height: 4px; animation-duration: 22s; animation-delay: 0.9s; background: rgba(0, 230, 118, 0.15); }
.particle.p13 { left: 55%; top: 90%; width: 3px; height: 3px; animation-duration: 18s; animation-delay: 5.5s; background: rgba(54, 163, 247, 0.2); }
.particle.p14 { left: 40%; top: 5%; width: 2px; height: 2px; animation-duration: 12s; animation-delay: 2.6s; background: rgba(0, 229, 255, 0.25); }
.particle.p15 { left: 78%; top: 8%; width: 3px; height: 3px; animation-duration: 20s; animation-delay: 7s; background: rgba(0, 230, 118, 0.17); }

@keyframes floatParticle {
  0% { transform: translateY(0) translateX(0) scale(1); opacity: 0; }
  15% { opacity: 1; }
  70% { opacity: 0.6; }
  100% { transform: translateY(-120vh) translateX(80px) scale(0.3); opacity: 0; }
}

// ======== 背景水平扫描线 ========
.bg-scanline {
  position: absolute;
  left: 0;
  right: 0;
  height: 1px;
  z-index: 0;
  pointer-events: none;
  background: linear-gradient(90deg, transparent 0%, rgba(0, 230, 118, 0.06) 20%, rgba(0, 229, 255, 0.08) 50%, rgba(0, 230, 118, 0.06) 80%, transparent 100%);
  animation: scanMove 10s linear infinite;
  top: 0;
}

@keyframes scanMove {
  0% { top: 0; opacity: 0; }
  5% { opacity: 1; }
  45% { opacity: 1; }
  50% { opacity: 0; }
  50.01% { top: 100%; opacity: 0; }
  55% { opacity: 1; }
  95% { opacity: 1; }
  100% { top: 0; opacity: 0; }
}

// ======== 顶部 KPI 卡片 ========
.screen-header {
  flex-shrink: 0;
  padding: 14px 20px 6px;
  text-align: center;
  position: relative;
  &::after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    height: 1px;
    background: linear-gradient(90deg,
      transparent 0%,
      rgba(79, 195, 247, 0.15) 10%,
      rgba(79, 195, 247, 0.3) 30%,
      rgba(79, 195, 247, 0.4) 50%,
      rgba(79, 195, 247, 0.3) 70%,
      rgba(79, 195, 247, 0.15) 90%,
      transparent 100%
    );
  }
}

.screen-title {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 16px;
  margin-bottom: 14px;
  height: 38px;

  .title-text {
    font-size: 26px;
    font-weight: 700;
    letter-spacing: 6px;
    color: #fff;
    text-shadow:
      0 0 12px rgba(100, 200, 255, 0.5),
      0 0 30px rgba(80, 180, 255, 0.3),
      0 0 60px rgba(60, 160, 255, 0.15);
    background: linear-gradient(180deg, #e3f2fd 0%, #64b5f6 50%, #1e88e5 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    line-height: 1.2;
    z-index: 1;
    position: relative;
    padding: 0 4px;
    &::after {
      content: '';
      position: absolute;
      bottom: -4px;
      left: 50%;
      transform: translateX(-50%);
      width: 60%;
      height: 2px;
      background: linear-gradient(90deg, transparent, rgba(79, 195, 247, 0.5), rgba(79, 195, 247, 0.8), rgba(79, 195, 247, 0.5), transparent);
      border-radius: 1px;
    }
  }
}

.title-deco {
  display: flex;
  align-items: center;
  gap: 6px;
}

.deco-bar {
  display: block;
  width: 32px;
  height: 2px;
  background: linear-gradient(90deg,
    rgba(79, 195, 247, 0.9),
    rgba(79, 195, 247, 0.3)
  );
  box-shadow: 0 0 6px rgba(79, 195, 247, 0.3);
  border-radius: 1px;
}

.title-deco:last-child .deco-bar {
  background: linear-gradient(90deg,
    rgba(79, 195, 247, 0.3),
    rgba(79, 195, 247, 0.9)
  );
}

.deco-chevron {
  display: block;
  width: 8px;
  height: 8px;
  border-left: 2px solid rgba(79, 195, 247, 0.8);
  border-top: 2px solid rgba(79, 195, 247, 0.8);
  transform: rotate(-45deg);
  box-shadow: -1px -1px 4px rgba(79, 195, 247, 0.2);
  border-radius: 1px;

  &.right {
    transform: rotate(135deg);
  }
}

.stats-row {
  display: flex;
  justify-content: center;
  gap: 16px;
}

.stat-card {
  display: flex;
  align-items: center;
  gap: 12px;
  flex: 0 1 290px;
  padding: 12px 20px;
  border-radius: 6px;
  background: linear-gradient(135deg, rgba(15, 33, 71, 0.9) 0%, rgba(10, 22, 50, 0.9) 100%);
  border: 1px solid rgba(0, 200, 255, 0.1);
  border-top-color: rgba(0, 220, 255, 0.18);
  transition: all 0.3s ease;
  cursor: default;
  box-shadow: 0 0 15px rgba(0, 180, 255, 0.04);

  &:hover {
    border-color: rgba(0, 220, 255, 0.35);
    box-shadow: 0 0 22px rgba(0, 220, 255, 0.12);
    transform: translateY(-1px);
  }

  &.card-carbon { border-left: 3px solid #00E676; }
  &.card-piles { border-left: 3px solid #36A3F7; }
  &.card-ev { border-left: 3px solid #00E5FF; }
}

.card-icon-svg {
  flex-shrink: 0;
  width: 42px;
  height: 42px;
}

.card-body {
  flex: 1;
  min-width: 0;
  .card-label {
    display: block;
    font-size: 11px;
    color: rgba(255, 255, 255, 0.45);
    margin-bottom: 2px;
  }
  .card-value {
    display: block;
    font-size: 22px;
    font-weight: 700;
    color: #fff;
    letter-spacing: 1px;
    line-height: 1.2;
    small {
      font-size: 11px;
      font-weight: 400;
      color: rgba(255, 255, 255, 0.35);
      margin-left: 3px;
    }
  }
  .card-trend {
    display: block;
    font-size: 10px;
    margin-top: 1px;
    &.up { color: #52c41a; }
    &.down { color: #ff4d4f; }
  }
}

// ======== 主内容：左右面板 + 地图 ========
.main-content {
  flex: 1;
  display: flex;
  gap: 10px;
  padding: 6px 14px 10px;
  min-height: 0;
  position: relative;
  z-index: 1;
}

// ======== 左右侧面表格面板 ========
.side-panel {
  width: 220px;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  background: linear-gradient(180deg, rgba(15, 29, 61, 0.95) 0%, rgba(10, 20, 45, 0.95) 100%);
  border: 1px solid rgba(0, 200, 255, 0.15);
  border-top-color: rgba(0, 220, 255, 0.25);
  border-radius: 4px;
  overflow: hidden;
  box-shadow:
    0 0 20px rgba(0, 180, 255, 0.05),
    inset 0 0 20px rgba(0, 150, 255, 0.02);
}

.panel-title {
  flex-shrink: 0;
  margin: 0;
  padding: 10px 12px;
  font-size: 13px;
  font-weight: 600;
  color: #fff;
  letter-spacing: 2px;
  display: flex;
  align-items: center;
  gap: 8px;
  background: linear-gradient(180deg, rgba(0, 200, 255, 0.1) 0%, rgba(0, 150, 255, 0.04) 100%);
  border-bottom: 1px solid rgba(0, 200, 255, 0.15);
}

.title-dot {
  display: inline-block;
  width: 6px;
  height: 6px;
  border-radius: 1px;
  &.carbon-dot { background: #00E676; }
  &.ev-dot { background: #00E5FF; }
  &.pile-dot { background: #36A3F7; }
}

.table-scroll {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;

  &::-webkit-scrollbar { width: 3px; }
  &::-webkit-scrollbar-thumb { background: rgba(0, 212, 255, 0.2); border-radius: 2px; }
  &::-webkit-scrollbar-track { background: transparent; }
}

.data-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 11px;

  thead {
    position: sticky;
    top: 0;
    z-index: 1;
    th {
      padding: 6px 4px;
      color: rgba(0, 210, 255, 0.75);
      font-weight: 500;
      font-size: 10px;
      text-align: center;
      background: linear-gradient(180deg, #0d2045 0%, #0c1d40 100%);
      border-bottom: 1px solid rgba(0, 200, 255, 0.18);
      white-space: nowrap;
    }
  }

  tbody {
    td {
      padding: 4px 4px;
      text-align: center;
      color: rgba(255, 255, 255, 0.65);
      border-bottom: 1px solid rgba(255, 255, 255, 0.04);
      white-space: nowrap;
    }

    tr {
      transition: background 0.2s;
      &:hover {
        background: rgba(0, 200, 255, 0.08);
      }
      &.row-top3 {
        td { color: #fff; }
        background: rgba(255, 255, 255, 0.03);
      }
    }
  }

  .col-rank { width: 28px; }
  .col-name { text-align: left; padding-left: 6px; }
  .col-val {
    text-align: right;
    padding-right: 6px;
    font-variant-numeric: tabular-nums;
    small {
      font-size: 9px;
      color: rgba(255, 255, 255, 0.35);
      margin-left: 1px;
    }
  }
}

.rank-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 18px;
  height: 18px;
  border-radius: 3px;
  font-size: 10px;
  font-weight: 700;
  color: rgba(255, 255, 255, 0.5);
  background: rgba(255, 255, 255, 0.06);

  &.rank-1 { background: #e6a817; color: #fff; }
  &.rank-2 { background: #8899aa; color: #fff; }
  &.rank-3 { background: #a0724a; color: #fff; }
}

// ======== 地图区域 ========
.map-section {
  flex: 1;
  position: relative;
  border-radius: 4px;
  overflow: hidden;
  border: 1px solid rgba(0, 220, 255, 0.28);
  border-top-color: rgba(0, 230, 255, 0.35);
  background:
    radial-gradient(ellipse at 55% 40%, rgba(14, 55, 115, 0.6) 0%, rgba(8, 28, 60, 0.75) 40%, rgba(4, 14, 35, 0.88) 100%);
  box-shadow:
    inset 0 0 80px rgba(0, 229, 255, 0.05),
    inset 0 0 30px rgba(54, 163, 247, 0.04),
    0 0 20px rgba(0, 229, 255, 0.08),
    0 0 40px rgba(54, 163, 247, 0.06);
  min-width: 0;
}

.map-glow {
  position: absolute;
  inset: 0;
  z-index: -1;
  pointer-events: none;
  background:
    radial-gradient(ellipse at 50% 40%, rgba(0, 150, 255, 0.04) 0%, transparent 50%),
    radial-gradient(ellipse at 30% 70%, rgba(0, 230, 118, 0.025) 0%, transparent 40%);
  animation: mapBreath 6s ease-in-out infinite;
}

@keyframes mapBreath {
  0%, 100% { opacity: 0.6; }
  50% { opacity: 1; }
}

.map-grid {
   position: absolute;
   inset: 0;
   z-index: -1;
   pointer-events: none;
   overflow: hidden;
}

// ======== 2.5D 透视网格地板 ========
.floor-scene {
  position: absolute;
  inset: 0;
  perspective: 900px;
  perspective-origin: 50% 0%;
  overflow: hidden;
}

.grid-plane {
  position: absolute;
  left: -80%;
  right: -80%;
  bottom: -20%;
  height: 220%;
  transform: rotateX(48deg);
  transform-origin: bottom center;
  background-image:
    radial-gradient(circle, rgba(0, 220, 255, 0.38) 2px, transparent 2px);
  background-size: 18px 18px;
  animation: gridMove 12s linear infinite;
  will-change: background-position;
}

@keyframes gridMove {
  0% { background-position: 0 0; }
  100% { background-position: 18px 18px; }
}

.grid-fade {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 38%;
  background: linear-gradient(180deg,
    rgba(5, 10, 31, 0.55) 0%,
    rgba(5, 10, 31, 0.15) 15%,
    transparent 38%
  );
  pointer-events: none;
}

.horizon-glow {
  position: absolute;
  top: 8%;
  left: 0;
  right: 0;
  height: 180px;
  background: radial-gradient(ellipse at center, rgba(0, 200, 255, 0.15) 0%, rgba(0, 150, 255, 0.05) 35%, transparent 70%);
  pointer-events: none;
}

.horizon-line {
  position: absolute;
  top: calc(8% + 88px);
  left: 10%;
  right: 10%;
  height: 1.5px;
  background: linear-gradient(90deg, transparent 0%, rgba(0, 220, 255, 0.25) 20%, rgba(0, 240, 255, 0.45) 50%, rgba(0, 220, 255, 0.25) 80%, transparent 100%);
  pointer-events: none;
  box-shadow: 0 0 15px rgba(0, 200, 255, 0.12), 0 0 40px rgba(0, 200, 255, 0.04);
}

.breath-dot {
  position: absolute;
  width: 6px;
  height: 6px;
  border-radius: 50%;
  z-index: 3;
  animation: breathe 2.5s ease-in-out infinite;
  &.dot-tl { top: 14px; left: 14px; background: #00E676; box-shadow: 0 0 6px #00E676, 0 0 14px #00E676; }
  &.dot-tr { top: 14px; right: 14px; background: #36A3F7; box-shadow: 0 0 6px #36A3F7, 0 0 14px #36A3F7; animation-delay: 0.8s; }
  &.dot-bl { bottom: 14px; left: 14px; background: #00E5FF; box-shadow: 0 0 6px #00E5FF, 0 0 14px #00E5FF; animation-delay: 1.6s; }
  &.dot-br { bottom: 14px; right: 14px; background: #36A3F7; box-shadow: 0 0 6px #36A3F7, 0 0 14px #36A3F7; animation-delay: 0.4s; }
}

@keyframes breathe {
  0%, 100% { opacity: 0.3; transform: scale(0.8); }
  50% { opacity: 1; transform: scale(1.4); }
}

// ======== 底部雷达扫描（跟随地图中心） ========
.bottom-radar {
  position: absolute;
  z-index: -1;
  pointer-events: none;
  transform: translate(-50%, -50%);
}

.br-ring {
  position: absolute;
  top: 50%;
  left: 50%;
  border-radius: 50%;
  border: 1px solid rgba(0, 230, 118, 0.35);
  animation: brExpand 5s ease-out infinite;
  transform-origin: center;
}
.br-ring.r1 { width: 10px; height: 10px; margin: -5px 0 0 -5px; animation-delay: 0s; }
.br-ring.r2 { width: 10px; height: 10px; margin: -5px 0 0 -5px; animation-delay: 1.2s; }
.br-ring.r3 { width: 10px; height: 10px; margin: -5px 0 0 -5px; animation-delay: 2.4s; }

.br-beam {
  position: absolute;
  top: 50%;
  left: 50%;
  width: 6px;
  height: 6px;
  margin: -3px 0 0 -3px;
  border-radius: 50%;
  background: rgba(0, 230, 118, 0.6);
  box-shadow: 0 0 12px rgba(0, 230, 118, 0.4), 0 0 40px rgba(0, 230, 118, 0.15);
  animation: brPulse 2s ease-in-out infinite;
}

@keyframes brExpand {
  0% {
    transform: scale(0.1);
    opacity: 0.8;
    border-width: 1.5px;
    border-color: rgba(0, 230, 118, 0.55);
  }
  50% {
    opacity: 0.35;
    border-color: rgba(0, 229, 255, 0.25);
  }
  100% {
    transform: scale(90);
    opacity: 0;
    border-width: 0.2px;
    border-color: rgba(0, 229, 255, 0);
  }
}

@keyframes brPulse {
  0%, 100% { transform: scale(0.8); opacity: 0.3; }
  50% { transform: scale(1.3); opacity: 0.7; }
}

// ======== 地图容器底部光晕 ========
.map-section::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 35%;
  background: linear-gradient(0deg, rgba(0, 230, 118, 0.035) 0%, transparent 100%);
  pointer-events: none;
  z-index: -1;
}

.map-perspective {
  width: 100%;
  height: 100%;
  perspective: 1200px;
}

.map-chart {
  width: 100%;
  height: 100%;
  transform: rotateX(8deg);
  transform-origin: center center;
  transition: transform 0.3s ease;
}

.map-legend {
  position: absolute;
  bottom: 10px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  gap: 16px;
  z-index: 2;
}

.legend-item {
  position: relative;
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 16px 6px 12px;
  background: rgba(10, 22, 50, 0.82);
  border: 1px solid rgba(0, 230, 118, 0.2);
  border-radius: 18px;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.85);
  cursor: default;
  letter-spacing: 0.5px;
  box-shadow: 0 0 12px rgba(0, 230, 118, 0.06);
  transition: all 0.3s;

  &:hover {
    background: rgba(10, 22, 50, 0.92);
    border-color: rgba(0, 230, 118, 0.4);
    box-shadow: 0 0 20px rgba(0, 230, 118, 0.12);
  }
}

.legend-leaf-icon {
  display: inline-block;
  width: 16px;
  height: 16px;
  background: currentColor;
  mask: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 48 48'%3E%3Cpath d='M24 4 Q8 18 8 28 Q8 40 20 44 L24 38 L28 44 Q40 40 40 28 Q40 18 24 4 Z M24 38 L24 47'/%3E%3C/svg%3E") no-repeat center/contain;
  -webkit-mask: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 48 48'%3E%3Cpath d='M24 4 Q8 18 8 28 Q8 40 20 44 L24 38 L28 44 Q40 40 40 28 Q40 18 24 4 Z M24 38 L24 47'/%3E%3C/svg%3E") no-repeat center/contain;
  color: #00E676;
  filter: drop-shadow(0 0 4px rgba(0, 230, 118, 0.35));
  flex-shrink: 0;
}

.legend-tooltip {
  position: absolute;
  bottom: calc(100% + 10px);
  left: 50%;
  transform: translateX(-50%);
  padding: 6px 12px;
  background: rgba(10, 22, 50, 0.94);
  border: 1px solid rgba(0, 230, 118, 0.25);
  border-radius: 6px;
  font-size: 11px;
  color: rgba(255, 255, 255, 0.8);
  white-space: nowrap;
  box-shadow: 0 0 12px rgba(0, 230, 118, 0.08);
  pointer-events: none;
}

.tip-arrow {
  position: absolute;
  bottom: -5px;
  left: 50%;
  transform: translateX(-50%) rotate(45deg);
  width: 8px;
  height: 8px;
  background: rgba(10, 22, 50, 0.94);
  border-right: 1px solid rgba(0, 230, 118, 0.25);
  border-bottom: 1px solid rgba(0, 230, 118, 0.25);
}

.tip-fade-enter-active, .tip-fade-leave-active {
  transition: opacity 0.2s ease, transform 0.2s ease;
}
.tip-fade-enter, .tip-fade-leave-to {
  opacity: 0;
  transform: translateX(-50%) translateY(4px);
}

// ======== 操作按钮 ========
.action-buttons {
  position: absolute;
  right: 14px;
  top: 14px;
  display: flex;
  flex-direction: column;
  gap: 6px;
  z-index: 10;
}

.action-btn {
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
  background: rgba(15, 33, 71, 0.8);
  border: 1px solid rgba(0, 212, 255, 0.12);
  color: rgba(255, 255, 255, 0.45);
  cursor: pointer;
  transition: all 0.3s;
  &:hover {
    color: #00E5FF;
    border-color: rgba(0, 229, 255, 0.45);
    box-shadow: 0 0 10px rgba(0, 229, 255, 0.15);
  }
  i { font-size: 14px; }
}

// ======== 过渡动画 ========
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.4s ease;
}
.fade-enter,
.fade-leave-to {
  opacity: 0;
}
</style>