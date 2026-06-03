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
      const colors = { '充电中': '#409eff', '已完成': '#67c23a', '已取消': '#f56c6c' }
      const pieData = (data || []).map(d => ({
        value: d.value,
        name: d.name,
        itemStyle: { color: colors[d.name] || '#c0c4cc' }
      }))
      this.chart.setOption({
        title: { text: '充电订单状态', left: 'center', textStyle: { fontSize: 14, color: '#303133' } },
        tooltip: { trigger: 'item', formatter: '{b}: {c} 单 ({d}%)' },
        legend: { bottom: '0%', textStyle: { fontSize: 11 } },
        series: [{
          name: '订单状态', type: 'pie',
          radius: ['45%', '70%'],
          center: ['50%', '50%'],
          data: pieData.length ? pieData : [{ value: 1, name: '暂无数据', itemStyle: { color: '#e0e0e0' } }],
          itemStyle: { borderRadius: 4, borderColor: '#fff', borderWidth: 2 },
          emphasis: { label: { fontSize: 14, fontWeight: 'bold' } },
          label: { show: true, position: 'outside', formatter: '{b}\n{d}%' }
        }]
      })
    }
  }
}
</script>