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
    chartData: { type: Array, default: () => [] },
    title: { type: String, default: '碳减排趋势' }
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
      const months = (data || []).map(d => d.month)
      const carbon = (data || []).map(d => (Number(d.carbon) / 1000).toFixed(2))
      const energy = (data || []).map(d => Number(d.energy))
      this.chart.setOption({
        title: { text: this.title, left: 'center', textStyle: { fontSize: 14, color: '#303133' } },
        tooltip: {
          trigger: 'axis',
          formatter: function(params) {
            let tip = params[0].axisValue + '<br/>'
            params.forEach(p => {
              tip += p.marker + p.seriesName + ': ' + p.value + (p.seriesName === '碳减排(吨)' ? ' t' : ' kWh') + '<br/>'
            })
            return tip
          }
        },
        legend: { data: ['碳减排(吨)', '充电量(kWh)'], bottom: '0%', textStyle: { fontSize: 11 } },
        xAxis: { type: 'category', data: months.length ? months : ['暂无'], boundaryGap: false },
        yAxis: [
          { type: 'value', name: '碳减排(t)', min: 0 },
          { type: 'value', name: '充电量(kWh)', min: 0 }
        ],
        series: [
          {
            name: '碳减排(吨)', type: 'line', smooth: true, yAxisIndex: 0,
            data: carbon.length ? carbon : [0],
            itemStyle: { color: '#67c23a' },
            areaStyle: { color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: 'rgba(103,194,58,0.3)' },
              { offset: 1, color: 'rgba(103,194,58,0.02)' }
            ]) }
          },
          {
            name: '充电量(kWh)', type: 'bar', yAxisIndex: 1,
            data: energy.length ? energy : [0],
            itemStyle: { color: '#409eff', borderRadius: [4, 4, 0, 0] },
            barWidth: '40%'
          }
        ],
        grid: { left: '3%', right: '4%', bottom: '15%', containLabel: true }
      })
    }
  }
}
</script>