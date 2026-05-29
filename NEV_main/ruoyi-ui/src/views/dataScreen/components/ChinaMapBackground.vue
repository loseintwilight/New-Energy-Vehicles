<template>
  <div class="china-map-bg" ref="mapContainer">
    <div class="map-grid-overlay"></div>
    <div class="radar-scan">
      <span class="radar-ring r1"></span>
      <span class="radar-ring r2"></span>
      <span class="radar-ring r3"></span>
      <span class="radar-ring r4"></span>
      <span class="radar-ring r5"></span>
      <span class="radar-ring r6"></span>
      <span class="radar-dot"></span>
    </div>
  </div>
</template>

<script>
import * as echarts from 'echarts'

const CHINA_GEOJSON_URL = 'https://geo.datav.aliyun.com/areas_v3/bound/100000.json'

export default {
  name: 'ChinaMapBackground',
  props: {
    width: { type: [Number, String], default: '100%' },
    height: { type: [Number, String], default: '100%' },
    zoom: { type: Number, default: 1.12 },
    center: { type: Array, default: () => [105, 36] }
  },
  data() {
    return {
      chart: null,
      loaded: false
    }
  },
  mounted() {
    this.init()
    window.addEventListener('resize', this.handleResize)
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize)
    if (this.chart) {
      this.chart.dispose()
      this.chart = null
    }
  },
  methods: {
    handleResize() {
      if (this.chart) this.chart.resize()
    },
    async init() {
      try {
        const geoJson = await this.fetchGeoJSON()
        echarts.registerMap('china', geoJson)
        this.loaded = true
        this.$nextTick(() => this.renderChart())
      } catch (err) {
        console.warn('GeoJSON 加载失败，使用内置地图：', err.message)
        this.$nextTick(() => this.renderChart())
      }
    },
    async fetchGeoJSON() {
      const res = await fetch(CHINA_GEOJSON_URL)
      if (!res.ok) throw new Error('HTTP ' + res.status)
      return res.json()
    },
    renderChart() {
      const dom = this.$refs.mapContainer
      if (!dom) return
      this.chart = echarts.init(dom)
      this.chart.setOption(this.buildOption())
    },
    buildOption() {
      return {
        backgroundColor: 'transparent',
        geo: {
          map: 'china',
          roam: false,
          zoom: this.zoom,
          center: this.center,
          aspectScale: 0.82,
          label: { show: false },
          itemStyle: {
            areaColor: {
              type: 'radial',
              x: 0.5, y: 0.5, r: 0.8,
              colorStops: [
                { offset: 0, color: 'rgba(20, 60, 120, 0.75)' },
                { offset: 1, color: 'rgba(8, 26, 56, 0.85)' }
              ]
            },
            borderColor: '#FFD700',
            borderWidth: 1.5,
            shadowColor: 'rgba(255, 215, 0, 0.08)',
            shadowBlur: 6,
            shadowOffsetX: 0,
            shadowOffsetY: 2
          },
          emphasis: {
            itemStyle: {
              areaColor: 'rgba(30, 75, 150, 0.6)',
              borderColor: '#FFD700',
              borderWidth: 2.2
            }
          },
          regions: [
            {
              name: '南海诸岛',
              itemStyle: {
                areaColor: 'rgba(10, 32, 60, 0.8)',
                borderColor: '#FFD700',
                borderWidth: 1.2
              },
              label: { show: false }
            }
          ]
        }
      }
    }
  }
}
</script>

<style scoped>
.china-map-bg {
  position: relative;
  width: 100%;
  height: 100%;
  background:
    radial-gradient(ellipse at center, rgba(8, 30, 65, 0.9) 0%, rgba(2, 10, 28, 0.95) 70%);
  overflow: hidden;
}

.map-grid-overlay {
  position: absolute;
  inset: 0;
  z-index: 0;
  background:
    repeating-linear-gradient(0deg, transparent, transparent 29px, rgba(0, 180, 255, 0.025) 29px, rgba(0, 180, 255, 0.025) 30px),
    repeating-linear-gradient(90deg, transparent, transparent 29px, rgba(0, 180, 255, 0.025) 29px, rgba(0, 180, 255, 0.025) 30px);
  pointer-events: none;
}

.map-grid-overlay::after {
  content: '';
  position: absolute;
  inset: 0;
  background: radial-gradient(ellipse at center, transparent 30%, rgba(0, 0, 0, 0.25) 100%);
  pointer-events: none;
}

.radar-scan {
  position: absolute;
  bottom: 10%;
  left: 50%;
  transform: translateX(-50%);
  width: 50vw;
  height: 50vw;
  max-width: 700px;
  max-height: 700px;
  z-index: 0;
  pointer-events: none;
}

.radar-dot {
  position: absolute;
  top: 50%;
  left: 50%;
  width: 3px;
  height: 3px;
  margin: -1.5px 0 0 -1.5px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.9);
  box-shadow: 0 0 4px rgba(255, 255, 255, 0.6), 0 0 12px rgba(255, 255, 255, 0.2);
}

.radar-ring {
  position: absolute;
  top: 50%;
  left: 50%;
  border-radius: 50%;
  border: 1px solid rgba(255, 255, 255, 0.15);
  animation: radarExpand 6s ease-out infinite;
  transform-origin: center;
}
.radar-ring.r1 { width: 10px; height: 10px; margin: -5px 0 0 -5px; animation-delay: 0s; }
.radar-ring.r2 { width: 10px; height: 10px; margin: -5px 0 0 -5px; animation-delay: 1s; }
.radar-ring.r3 { width: 10px; height: 10px; margin: -5px 0 0 -5px; animation-delay: 2s; }
.radar-ring.r4 { width: 10px; height: 10px; margin: -5px 0 0 -5px; animation-delay: 3s; }
.radar-ring.r5 { width: 10px; height: 10px; margin: -5px 0 0 -5px; animation-delay: 4s; }
.radar-ring.r6 { width: 10px; height: 10px; margin: -5px 0 0 -5px; animation-delay: 5s; }

@keyframes radarExpand {
  0% {
    transform: scale(0.3);
    opacity: 0.7;
    border-width: 2px;
    border-color: rgba(255, 255, 255, 0.25);
  }
  40% {
    opacity: 0.5;
    border-color: rgba(255, 255, 255, 0.15);
  }
  100% {
    transform: scale(35);
    opacity: 0;
    border-width: 0.5px;
    border-color: rgba(255, 255, 255, 0);
  }
}
</style>