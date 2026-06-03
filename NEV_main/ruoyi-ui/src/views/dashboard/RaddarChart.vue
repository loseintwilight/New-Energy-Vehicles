<template>
  <div :class="className" :style="{height:height,width:width}" />
</template>

<script>
import * as echarts from 'echarts'
require('echarts/theme/macarons')
import resize from './mixins/resize'

export default {
  mixins: [resize],
  props: {
    className: { type: String, default: 'chart' },
    width: { type: String, default: '100%' },
    height: { type: String, default: '300px' },
    chartData: { type: Array, default: () => [] }
  },
  data() { return { chart: null } },
  watch: {
    chartData: { deep: true, handler(val) { this.setOptions(val) } }
  },
  mounted() { this.$nextTick(() => { this.initChart() }) },
  beforeDestroy() { if (this.chart) { this.chart.dispose(); this.chart = null } },
  methods: {
    initChart() {
      this.chart = echarts.init(this.$el, 'macarons')
      this.setOptions(this.chartData)
    },
    setOptions(data) {
      const indicators = (data || []).map(d => ({ name: d.name, max: d.max || 100 }))
      const values = (data || []).map(d => d.value || 0)
      this.chart.setOption({
        title: { text: '业务指标概览', left: 'center', textStyle: { fontSize: 14, color: '#303133' } },
        tooltip: {
          formatter: function(params) {
            return params.name + ': ' + params.value
          }
        },
        radar: {
          radius: '60%',
          center: ['50%', '55%'],
          indicator: indicators.length ? indicators : [{ name: '暂无', max: 100 }],
          axisName: { fontSize: 10 }
        },
        series: [{
          type: 'radar',
          data: [{
            value: values.length ? values : [0],
            name: '当前数据',
            areaStyle: { color: 'rgba(54,163,247,0.25)' }
          }],
          symbol: 'circle',
          symbolSize: 4,
          itemStyle: { color: '#36a3f7' },
          lineStyle: { color: '#36a3f7', width: 2 }
        }]
      })
    }
  }
}
</script>