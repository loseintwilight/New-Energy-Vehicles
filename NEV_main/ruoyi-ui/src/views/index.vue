<template>
  <div class="dashboard-container">
    <div class="dashboard-header">
      <div class="header-left">
        <h2 class="page-title">新能源汽车综合服务平台</h2>
        <span class="page-subtitle">运营数据概览</span>
      </div>
      <div class="header-right">
        <span class="update-time">
          <i class="el-icon-time" />
          数据更新时间：{{ lastUpdateTime }}
        </span>
        <el-button type="primary" size="small" :loading="loading" icon="el-icon-refresh" @click="handleRefresh">
          刷新数据
        </el-button>
        <el-tooltip content="每5分钟自动刷新" placement="bottom">
          <el-switch
            v-model="autoRefresh"
            active-color="#409eff"
            inactive-color="#c0c4cc"
            @change="toggleAutoRefresh"
          />
        </el-tooltip>
      </div>
    </div>

    <div class="today-stats-bar">
      <div class="today-item">
        <span class="today-icon el-icon-s-order" />
        <span class="today-label">今日购车订单</span>
        <span class="today-value">{{ todayStats.newOrders || 0 }}</span>
      </div>
      <div class="today-divider" />
      <div class="today-item">
        <span class="today-icon el-icon-s-order" />
        <span class="today-label">今日充电订单</span>
        <span class="today-value">{{ todayStats.newChargeOrders || 0 }}</span>
      </div>
      <div class="today-divider" />
      <div class="today-item">
        <span class="today-icon el-icon-s-finance" />
        <span class="today-label">今日充电营收</span>
        <span class="today-value">¥{{ formatMoney(todayStats.todayRevenue) }}</span>
      </div>
      <div class="today-divider" />
      <div class="today-item">
        <span class="today-icon el-icon-s-data" />
        <span class="today-label">今日充电量</span>
        <span class="today-value">{{ formatMoney(todayStats.todayEnergy) }} kWh</span>
      </div>
      <div class="today-divider" />
      <div class="today-item">
        <span class="today-icon el-icon-user-solid" />
        <span class="today-label">今日新增用户</span>
        <span class="today-value">{{ todayStats.todayUsers || 0 }}</span>
      </div>
      <div class="today-divider" />
      <div class="today-item">
        <span class="today-icon el-icon-s-comment" />
        <span class="today-label">今日反馈</span>
        <span class="today-value">{{ todayStats.newFeedback || 0 }}</span>
      </div>
    </div>

    <panel-group :stats="totalStats" />

    <el-row :gutter="20">
      <el-col :xs="24" :lg="16">
        <div class="chart-card">
          <div class="chart-card-header">
            <el-date-picker
              v-model="selectedMonth"
              type="month"
              size="mini"
              placeholder="选择月份"
              value-format="yyyy-MM"
              :clearable="false"
              @change="handleMonthChange"
            />
          </div>
          <line-chart :chart-data="monthlyOrderTrend" :title="lineChartTitle" />
        </div>
      </el-col>
      <el-col :xs="24" :lg="8">
        <div class="chart-card">
          <pie-chart :chart-data="vehicleBrands" />
        </div>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <el-col :xs="24" :sm="12" :lg="8">
        <div class="chart-card">
          <order-type-chart :chart-data="orderTypeDistribution" />
        </div>
      </el-col>
      <el-col :xs="24" :sm="12" :lg="8">
        <div class="chart-card">
          <pile-status-chart :chart-data="pileStatusDistribution" />
        </div>
      </el-col>
      <el-col :xs="24" :sm="12" :lg="8">
        <div class="chart-card">
          <charge-order-status-chart :chart-data="chargeOrderStatusDistribution" />
        </div>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <el-col :xs="24" :lg="16">
        <div class="chart-card">
          <div class="chart-card-header">
            <el-date-picker
              v-model="selectedCarbonMonth"
              type="month"
              size="mini"
              placeholder="选择月份"
              value-format="yyyy-MM"
              :clearable="false"
              @change="handleCarbonMonthChange"
            />
          </div>
          <carbon-trend-chart :chart-data="carbonTrend" :title="carbonChartTitle" />
        </div>
      </el-col>
      <el-col :xs="24" :lg="8">
        <div class="chart-card">
          <bar-chart :chart-data="stationPowerRanking" />
        </div>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <el-col :xs="24" :lg="8">
        <div class="chart-card">
          <raddar-chart :chart-data="radarMetrics" />
        </div>
      </el-col>
      <el-col :xs="24" :lg="8">
        <div class="chart-card">
          <div class="list-card">
            <div class="list-card-header">
              <span class="list-title">最新购车订单</span>
            </div>
            <div class="list-body">
              <div v-for="(item, idx) in latestOrders" :key="idx" class="list-item">
                <div class="list-item-left">
                  <span class="list-item-no">{{ item.orderNo }}</span>
                  <span class="list-item-user">{{ item.userName || '匿名' }}</span>
                </div>
                <div class="list-item-right">
                  <span class="list-item-amount">¥{{ formatMoney(item.amount) }}</span>
                  <el-tag size="mini" :type="orderStatusType(item.orderType, item.status)">{{ orderStatusText(item.orderType, item.status) }}</el-tag>
                </div>
              </div>
              <el-empty v-if="!latestOrders || latestOrders.length === 0" :image-size="60" description="暂无订单数据" />
            </div>
          </div>
        </div>
      </el-col>
      <el-col :xs="24" :lg="8">
        <div class="chart-card">
          <div class="list-card">
            <div class="list-card-header">
              <span class="list-title">最新充电订单</span>
            </div>
            <div class="list-body">
              <div v-for="(item, idx) in latestChargeOrders" :key="idx" class="list-item">
                <div class="list-item-left">
                  <span class="list-item-no">{{ item.orderNo }}</span>
                  <span class="list-item-user">{{ item.stationName || '-' }}</span>
                </div>
                <div class="list-item-right">
                  <span class="list-item-amount">¥{{ formatMoney(item.amount) }}</span>
                  <el-tag size="mini" :type="chargeOrderStatusType(item.orderStatus)">{{ chargeOrderStatusText(item.orderStatus) }}</el-tag>
                </div>
              </div>
              <el-empty v-if="!latestChargeOrders || latestChargeOrders.length === 0" :image-size="60" description="暂无充电订单" />
            </div>
          </div>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import PanelGroup from './dashboard/PanelGroup'
import LineChart from './dashboard/LineChart'
import RaddarChart from './dashboard/RaddarChart'
import PieChart from './dashboard/PieChart'
import BarChart from './dashboard/BarChart'
import OrderTypeChart from './dashboard/OrderTypeChart'
import PileStatusChart from './dashboard/PileStatusChart'
import ChargeOrderStatusChart from './dashboard/ChargeOrderStatusChart'
import CarbonTrendChart from './dashboard/CarbonTrendChart'
import { getDashboardStatistics } from '@/api/dashboard'

export default {
  name: 'DashboardIndex',
  components: {
    PanelGroup,
    LineChart,
    RaddarChart,
    PieChart,
    BarChart,
    OrderTypeChart,
    PileStatusChart,
    ChargeOrderStatusChart,
    CarbonTrendChart
  },
  data() {
    const now = new Date()
    const defaultMonth = now.getFullYear() + '-' + String(now.getMonth() + 1).padStart(2, '0')
    return {
      loading: false,
      autoRefresh: true,
      refreshTimer: null,
      lastUpdateTime: '--',
      selectedMonth: defaultMonth,
      lineChartTitle: '日购车订单趋势',
      selectedCarbonMonth: defaultMonth,
      carbonChartTitle: '碳减排趋势',
      totalStats: {},
      vehicleBrands: [],
      orderTypeDistribution: [],
      monthlyOrderTrend: [],
      stationPowerRanking: [],
      pileStatusDistribution: [],
      chargeOrderStatusDistribution: [],
      carbonTrend: [],
      radarMetrics: [],
      latestOrders: [],
      latestChargeOrders: [],
      todayStats: {}
    }
  },
  created() {
    this.loadData()
  },
  mounted() {
    if (this.autoRefresh) {
      this.startAutoRefresh()
    }
  },
  beforeDestroy() {
    this.stopAutoRefresh()
  },
  methods: {
    loadData() {
      this.loading = true
      getDashboardStatistics(this.selectedMonth, this.selectedCarbonMonth).then(res => {
        const data = res.data || {}
        this.lineChartTitle = this.selectedMonth + ' 日购车订单趋势'
        this.carbonChartTitle = this.selectedCarbonMonth + ' 碳减排趋势'
        this.totalStats = data.totalStats || {}
        this.vehicleBrands = data.vehicleBrands || []
        this.orderTypeDistribution = data.orderTypeDistribution || []
        this.monthlyOrderTrend = data.monthlyOrderTrend || []
        this.stationPowerRanking = data.stationPowerRanking || []
        this.pileStatusDistribution = data.pileStatusDistribution || []
        this.chargeOrderStatusDistribution = data.chargeOrderStatusDistribution || []
        this.carbonTrend = data.carbonTrend || []
        this.radarMetrics = data.radarMetrics || []
        this.latestOrders = data.latestOrders || []
        this.latestChargeOrders = data.latestChargeOrders || []
        this.todayStats = data.todayStats || {}
        this.updateTime()
      }).catch(() => {
        this.$message.error('数据加载失败，请稍后重试')
      }).finally(() => {
        this.loading = false
      })
    },
    handleRefresh() {
      this.loadData()
      this.$message.success('数据刷新成功')
    },
    handleMonthChange(val) {
      if (val) {
        this.loadData()
      }
    },
    handleCarbonMonthChange(val) {
      if (val) {
        this.loadData()
      }
    },
    toggleAutoRefresh(val) {
      if (val) {
        this.startAutoRefresh()
        this.$message.success('已开启自动刷新（每5分钟）')
      } else {
        this.stopAutoRefresh()
        this.$message.info('已关闭自动刷新')
      }
    },
    startAutoRefresh() {
      this.stopAutoRefresh()
      this.refreshTimer = setInterval(() => {
        this.loadData()
      }, 5 * 60 * 1000)
    },
    stopAutoRefresh() {
      if (this.refreshTimer) {
        clearInterval(this.refreshTimer)
        this.refreshTimer = null
      }
    },
    updateTime() {
      const now = new Date()
      this.lastUpdateTime = now.getFullYear() + '-' +
        String(now.getMonth() + 1).padStart(2, '0') + '-' +
        String(now.getDate()).padStart(2, '0') + ' ' +
        String(now.getHours()).padStart(2, '0') + ':' +
        String(now.getMinutes()).padStart(2, '0') + ':' +
        String(now.getSeconds()).padStart(2, '0')
    },
    formatMoney(val) {
      const num = Number(val || 0)
      return num.toLocaleString('en-US', { minimumFractionDigits: 0, maximumFractionDigits: 0 })
    },
    navigateTo(path) {
      this.$router.push(path)
    },
    orderStatusType(orderType, status) {
      if (orderType === 'test_drive') {
        const map = { '0': 'info', '1': 'primary', '2': 'success', '3': 'danger' }
        return map[status] || 'info'
      }
      const map = { '0': 'warning', '1': 'primary', '2': 'success', '3': 'danger' }
      return map[status] || 'info'
    },
    orderStatusText(orderType, status) {
      if (orderType === 'test_drive') {
        const map = { '0': '待确认', '1': '已确认', '2': '已完成', '3': '已取消' }
        return map[status] || '无'
      }
      const map = { '0': '待付款', '1': '已付款', '2': '已完成', '3': '已取消' }
      return map[status] || '无'
    },
    chargeOrderStatusType(status) {
      const map = { '0': 'warning', '1': 'success', '2': 'info' }
      return map[status] || 'info'
    },
    chargeOrderStatusText(status) {
      const map = { '0': '充电中', '1': '已完成', '2': '已取消' }
      return map[status] || '未知'
    }
  }
}
</script>

<style lang="scss" scoped>
.dashboard-container {
  padding: 20px;
  background: #f0f2f5;
  min-height: 100%;
}

.dashboard-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  flex-wrap: wrap;
  gap: 12px;
  .header-left {
    display: flex;
    align-items: baseline;
    gap: 12px;
    .page-title {
      margin: 0;
      font-size: 20px;
      font-weight: 600;
      color: #303133;
    }
    .page-subtitle {
      font-size: 13px;
      color: #909399;
    }
  }
  .header-right {
    display: flex;
    align-items: center;
    gap: 12px;
    .update-time {
      font-size: 12px;
      color: #909399;
      i {
        margin-right: 4px;
      }
    }
  }
}

.today-stats-bar {
  display: flex;
  align-items: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 8px;
  padding: 0 20px;
  margin-bottom: 16px;
  height: 52px;
  overflow-x: auto;
  color: #fff;
  .today-item {
    display: flex;
    align-items: center;
    gap: 6px;
    white-space: nowrap;
    flex-shrink: 0;
    .today-icon {
      font-size: 16px;
      opacity: 0.8;
    }
    .today-label {
      font-size: 12px;
      opacity: 0.85;
    }
    .today-value {
      font-size: 15px;
      font-weight: 700;
    }
  }
  .today-divider {
    width: 1px;
    height: 24px;
    background: rgba(255, 255, 255, 0.3);
    margin: 0 16px;
    flex-shrink: 0;
  }
}

.chart-card {
  background: #fff;
  border-radius: 8px;
  padding: 16px;
  margin-bottom: 20px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, .06);
  transition: box-shadow .3s ease;
  &:hover {
    box-shadow: 0 4px 20px rgba(0, 0, 0, .1);
  }
  .chart-card-header {
    display: flex;
    justify-content: flex-end;
    align-items: center;
    margin-bottom: 8px;
  }
}

.list-card {
  .list-card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;
    padding-bottom: 8px;
    border-bottom: 1px solid #ebeef5;
    .list-title {
      font-size: 14px;
      font-weight: 600;
      color: #303133;
    }
  }
  .list-body {
    max-height: 300px;
    overflow-y: auto;
  }
  .list-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 0;
    border-bottom: 1px solid #f5f5f5;
    &:last-child {
      border-bottom: none;
    }
    .list-item-left {
      display: flex;
      flex-direction: column;
      gap: 2px;
      min-width: 0;
      .list-item-no {
        font-size: 12px;
        color: #909399;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }
      .list-item-user {
        font-size: 13px;
        color: #303133;
      }
    }
    .list-item-right {
      display: flex;
      align-items: center;
      gap: 8px;
      flex-shrink: 0;
      .list-item-amount {
        font-size: 13px;
        font-weight: 600;
        color: #f56c6c;
      }
    }
  }
}

@media (max-width: 768px) {
  .dashboard-container {
    padding: 12px;
  }
  .dashboard-header {
    .page-title {
      font-size: 16px;
    }
  }
  .today-stats-bar {
    padding: 0 12px;
    height: 44px;
    .today-label {
      font-size: 11px;
    }
    .today-value {
      font-size: 13px;
    }
    .today-divider {
      margin: 0 8px;
    }
  }
}
</style>