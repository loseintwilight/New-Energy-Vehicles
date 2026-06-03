<template>
  <el-row :gutter="16" class="panel-group">
    <el-col :xs="24" :sm="12" :md="6" class="card-panel-col">
      <div class="card-panel" @click="navigateTo('/business/vehicle')">
        <div class="card-panel-icon-wrapper icon-vehicle">
          <svg-icon icon-class="car" class-name="card-panel-icon" />
        </div>
        <div class="card-panel-description">
          <div class="card-panel-num">
            <count-to :start-val="0" :end-val="safeNum(stats.vehicleCount)" :duration="1800" separator="," />
          </div>
          <div class="card-panel-text">车辆总数</div>
        </div>
        <div class="card-panel-sub">
          <span class="sub-label">在售</span>
          <span class="sub-value">{{ safeNum(stats.vehicleOnSaleCount) }}</span>
        </div>
      </div>
    </el-col>
    <el-col :xs="24" :sm="12" :md="6" class="card-panel-col">
      <div class="card-panel" @click="navigateTo('/business/station')">
        <div class="card-panel-icon-wrapper icon-station">
          <svg-icon icon-class="station" class-name="card-panel-icon" />
        </div>
        <div class="card-panel-description">
          <div class="card-panel-num">
            <count-to :start-val="0" :end-val="safeNum(stats.stationCount)" :duration="1900" separator="," />
          </div>
          <div class="card-panel-text">充电站</div>
        </div>
        <div class="card-panel-sub">
          <span class="sub-label">运营中</span>
          <span class="sub-value">{{ safeNum(stats.stationOnlineCount) }}</span>
        </div>
      </div>
    </el-col>
    <el-col :xs="24" :sm="12" :md="6" class="card-panel-col">
      <div class="card-panel" @click="navigateTo('/business/chargingpile')">
        <div class="card-panel-icon-wrapper icon-pile">
          <svg-icon icon-class="component" class-name="card-panel-icon" />
        </div>
        <div class="card-panel-description">
          <div class="card-panel-num">
            <count-to :start-val="0" :end-val="safeNum(stats.pileCount)" :duration="2000" separator="," />
          </div>
          <div class="card-panel-text">充电桩</div>
        </div>
        <div class="card-panel-sub">
          <span class="sub-label">空闲</span>
          <span class="sub-value green">{{ safeNum(stats.pileIdleCount) }}</span>
          <span class="sub-label">| 充电中</span>
          <span class="sub-value blue">{{ safeNum(stats.pileChargingCount) }}</span>
        </div>
      </div>
    </el-col>
    <el-col :xs="24" :sm="12" :md="6" class="card-panel-col">
      <div class="card-panel" @click="navigateTo('/business/merchant')">
        <div class="card-panel-icon-wrapper icon-merchant">
          <svg-icon icon-class="peoples" class-name="card-panel-icon" />
        </div>
        <div class="card-panel-description">
          <div class="card-panel-num">
            <count-to :start-val="0" :end-val="safeNum(stats.merchantCount)" :duration="2100" separator="," />
          </div>
          <div class="card-panel-text">商户</div>
        </div>
        <div class="card-panel-sub">
          <span class="sub-label">已上线</span>
          <span class="sub-value">{{ safeNum(stats.merchantActiveCount) }}</span>
        </div>
      </div>
    </el-col>
    <el-col :xs="24" :sm="12" :md="6" class="card-panel-col">
      <div class="card-panel" @click="navigateTo('/business/unified/order')">
        <div class="card-panel-icon-wrapper icon-order">
          <svg-icon icon-class="order" class-name="card-panel-icon" />
        </div>
        <div class="card-panel-description">
          <div class="card-panel-num">
            <count-to :start-val="0" :end-val="safeNum(stats.orderCount)" :duration="2200" separator="," />
          </div>
          <div class="card-panel-text">购车订单</div>
        </div>
        <div class="card-panel-sub">
          <span class="sub-label">总成交额</span>
          <span class="sub-value">¥{{ formatMoney(stats.orderRevenue) }}</span>
        </div>
      </div>
    </el-col>
    <el-col :xs="24" :sm="12" :md="6" class="card-panel-col">
      <div class="card-panel" @click="navigateTo('/business/order')">
        <div class="card-panel-icon-wrapper icon-charge">
          <svg-icon icon-class="international" class-name="card-panel-icon" />
        </div>
        <div class="card-panel-description">
          <div class="card-panel-num">
            <count-to :start-val="0" :end-val="safeNum(stats.chargeOrderCount)" :duration="2300" separator="," />
          </div>
          <div class="card-panel-text">充电订单</div>
        </div>
        <div class="card-panel-sub">
          <span class="sub-label">总营收</span>
          <span class="sub-value">¥{{ formatMoney(stats.totalRevenue) }}</span>
        </div>
      </div>
    </el-col>
    <el-col :xs="24" :sm="12" :md="6" class="card-panel-col">
      <div class="card-panel" @click="navigateTo('/business/carbonledger')">
        <div class="card-panel-icon-wrapper icon-carbon">
          <svg-icon icon-class="chart" class-name="card-panel-icon" />
        </div>
        <div class="card-panel-description">
          <div class="card-panel-num">
            <count-to :start-val="0" :end-val="stats.carbonTotal || 0" :duration="2400" :decimals="1" separator="," />
          </div>
          <div class="card-panel-text">碳减排(吨)</div>
        </div>
        <div class="card-panel-sub">
          <span class="sub-label">用户</span>
          <span class="sub-value">{{ safeNum(stats.userCount) }}</span>
        </div>
      </div>
    </el-col>
    <el-col :xs="24" :sm="12" :md="6" class="card-panel-col">
      <div class="card-panel" @click="navigateTo('/business/maintenance/order')">
        <div class="card-panel-icon-wrapper icon-maintain">
          <svg-icon icon-class="tool" class-name="card-panel-icon" />
        </div>
        <div class="card-panel-description">
          <div class="card-panel-num">
            <count-to :start-val="0" :end-val="safeNum(stats.maintenanceOrderCount)" :duration="2500" separator="," />
          </div>
          <div class="card-panel-text">维保订单</div>
        </div>
        <div class="card-panel-sub">
          <span class="sub-label">评价</span>
          <span class="sub-value">{{ safeNum(stats.reviewCount) }}</span>
          <span class="sub-label">| 反馈</span>
          <span class="sub-value">{{ safeNum(stats.feedbackCount) }}</span>
        </div>
      </div>
    </el-col>
  </el-row>
</template>

<script>
import CountTo from 'vue-count-to'

export default {
  components: { CountTo },
  props: {
    stats: { type: Object, default: () => ({}) }
  },
  methods: {
    safeNum(val) {
      return val || 0
    },
    formatMoney(val) {
      const num = Number(val || 0)
      return num.toLocaleString('en-US', { minimumFractionDigits: 0, maximumFractionDigits: 0 })
    },
    navigateTo(path) {
      this.$router.push(path)
    }
  }
}
</script>

<style lang="scss" scoped>
.panel-group {
  margin-top: 8px;
  .card-panel-col {
    margin-bottom: 16px;
  }
  .card-panel {
    height: 120px;
    cursor: pointer;
    font-size: 12px;
    position: relative;
    overflow: hidden;
    color: #333;
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, .06);
    transition: all .3s ease;
    display: flex;
    align-items: center;
    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 20px rgba(0, 0, 0, .12);
      .card-panel-icon-wrapper {
        transform: scale(1.1);
      }
    }
    .card-panel-icon-wrapper {
      display: flex;
      align-items: center;
      justify-content: center;
      width: 56px;
      height: 56px;
      border-radius: 12px;
      margin: 0 16px;
      transition: all .3s ease;
      flex-shrink: 0;
    }
    .icon-vehicle { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
    .icon-station { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
    .icon-pile { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
    .icon-merchant { background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); }
    .icon-order { background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); }
    .icon-charge { background: linear-gradient(135deg, #a18cd1 0%, #fbc2eb 100%); }
    .icon-carbon { background: linear-gradient(135deg, #fccb90 0%, #d57eeb 100%); }
    .icon-maintain { background: linear-gradient(135deg, #5ee7df 0%, #b490ca 100%); }
    .card-panel-icon {
      font-size: 28px;
      color: #fff;
    }
    .card-panel-description {
      flex: 1;
      min-width: 0;
      padding-right: 12px;
      .card-panel-num {
        font-size: 24px;
        font-weight: 700;
        color: #303133;
        line-height: 32px;
      }
      .card-panel-text {
        font-size: 13px;
        color: #909399;
        margin-top: 2px;
        line-height: 20px;
      }
    }
    .card-panel-sub {
      position: absolute;
      bottom: 10px;
      right: 16px;
      font-size: 12px;
      color: #909399;
      .sub-label {
        color: #c0c4cc;
      }
      .sub-value {
        color: #606266;
        font-weight: 600;
        &.green { color: #67c23a; }
        &.blue { color: #409eff; }
      }
    }
  }
}
@media (max-width: 768px) {
  .card-panel {
    height: 100px;
    .card-panel-description .card-panel-num {
      font-size: 20px;
    }
    .card-panel-icon-wrapper {
      width: 44px;
      height: 44px;
      margin: 0 12px;
    }
    .card-panel-icon {
      font-size: 22px;
    }
  }
}
</style>