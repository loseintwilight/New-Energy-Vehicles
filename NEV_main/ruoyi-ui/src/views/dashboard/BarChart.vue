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
      const names = (data || []).map(d => d.name)
      const powers = (data || []).map(d => Number(d.power))
      this.chart.setOption({
        title: { text: '充电站功率排行', left: 'center', textStyle: { fontSize: 14, color: '#303133' } },
        tooltip: {
          trigger: 'axis',
          axisPointer: { type: 'shadow' },
          formatter: function(params) {
            const p = params[0]
            return p.name + '<br/>' + p.marker + '总功率: ' + p.value + ' kW'
          }
        },
        xAxis: { type: 'category', data: names.length ? names : ['暂无'], axisLabel: { rotate: 30, fontSize: 10 } },
        yAxis: { type: 'value', name: '总功率(kW)' },
        series: [{
          name: '总功率', type: 'bar',
          data: powers.length ? powers : [0],
          itemStyle: {
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: '#36a3f7' },
              { offset: 1, color: '#83bff6' }
            ]),
            borderRadius: [4, 4, 0, 0]
          },
          barWidth: '50%'
        }],
        grid: { left: '3%', right: '4%', bottom: '20%', containLabel: true }
      })
    }
  }
}
</script>