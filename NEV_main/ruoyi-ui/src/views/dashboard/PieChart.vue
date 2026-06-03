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
      const pieData = (data || []).map(d => ({ value: d.value, name: d.name }))
      this.chart.setOption({
        title: { text: '车型分布', left: 'center', textStyle: { fontSize: 14, color: '#303133' } },
        tooltip: { trigger: 'item', formatter: '{b}: {c} 辆 ({d}%)' },
        series: [{
          name: '车型', type: 'pie',
          radius: ['40%', '70%'],
          center: ['50%', '55%'],
          roseType: 'radius',
          data: pieData.length ? pieData : [{ value: 1, name: '暂无数据' }],
          itemStyle: { borderRadius: 6, borderColor: '#fff', borderWidth: 2 },
          emphasis: { label: { fontSize: 14, fontWeight: 'bold' } },
          label: { show: false }
        }]
      })
    }
  }
}
</script>