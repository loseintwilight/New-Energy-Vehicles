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
    title: { type: String, default: '日购车订单趋势' }
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
      const counts = (data || []).map(d => d.orderCount)
      const amounts = (data || []).map(d => Number(d.amount || 0))
      this.chart.setOption({
        title: { text: this.title, left: 'center', textStyle: { fontSize: 14, color: '#303133' } },
        tooltip: {
          trigger: 'axis',
          formatter: function(params) {
            let tip = params[0].axisValue + '<br/>'
            params.forEach(p => {
              tip += p.marker + p.seriesName + ': ' + (p.seriesName === '订单数' ? p.value + ' 单' : '¥' + p.value.toLocaleString()) + '<br/>'
            })
            return tip
          }
        },
        legend: { data: ['订单数', '金额(元)'], bottom: '0%', textStyle: { fontSize: 11 } },
        xAxis: { type: 'category', data: months.length ? months : ['暂无数据'], boundaryGap: false },
        yAxis: [
          { type: 'value', name: '订单数', min: 0 },
          { type: 'value', name: '金额(元)', min: 0 }
        ],
        series: [
          {
            name: '订单数', type: 'line', smooth: true, yAxisIndex: 0,
            data: counts.length ? counts : [0],
            itemStyle: { color: '#36a3f7' },
            areaStyle: { color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: 'rgba(54,163,247,0.3)' },
              { offset: 1, color: 'rgba(54,163,247,0.02)' }
            ]) }
          },
          {
            name: '金额(元)', type: 'bar', yAxisIndex: 1,
            data: amounts.length ? amounts : [0],
            itemStyle: { color: '#40c9c6', borderRadius: [4, 4, 0, 0] },
            barWidth: '40%'
          }
        ],
        grid: { left: '3%', right: '4%', bottom: '15%', containLabel: true }
      })
    }
  }
}
</script>