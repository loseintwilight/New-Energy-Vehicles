<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="城市" prop="city"><el-input v-model="queryParams.city" placeholder="城市" clearable @keyup.enter.native="handleQuery" /></el-form-item>
      <el-form-item label="统计日期" prop="statDate"><el-date-picker v-model="queryParams.statDate" type="date" placeholder="选择日期" clearable value-format="yyyy-MM-dd" style="width:100%" /></el-form-item>
      <el-form-item><el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button><el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button></el-form-item>
    </el-form>
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5"><el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['business:carbonstatistics:add']">新增</el-button></el-col>
      <el-col :span="1.5"><el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['business:carbonstatistics:edit']">修改</el-button></el-col>
      <el-col :span="1.5"><el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['business:carbonstatistics:remove']">删除</el-button></el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>
    <el-table v-loading="loading" :data="statList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="编号" align="center" prop="statId" />
      <el-table-column label="统计日期" align="center" prop="statDate" width="120" />
      <el-table-column label="城市" align="center" prop="city" /><el-table-column label="区县" align="center" prop="district" />
      <el-table-column label="充电站" align="center" prop="totalChargeStations" />
      <el-table-column label="充电桩" align="center" prop="totalChargePiles" />
      <el-table-column label="订单数" align="center" prop="totalChargeOrders" />
      <el-table-column label="总电量" align="center" prop="totalEnergy" />
      <el-table-column label="碳减排" align="center" prop="carbonReduction" />
      <el-table-column label="新能源车" align="center" prop="totalNevCount" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['business:carbonstatistics:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['business:carbonstatistics:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
    <el-dialog :title="title" :visible.sync="open" width="750px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="统计日期" prop="statDate"><el-date-picker v-model="form.statDate" type="date" placeholder="选择日期" style="width:100%" value-format="yyyy-MM-dd" /></el-form-item>
        <el-row><el-col :span="12"><el-form-item label="城市" prop="city"><el-input v-model="form.city" /></el-form-item></el-col><el-col :span="12"><el-form-item label="区县" prop="district"><el-input v-model="form.district" /></el-form-item></el-col></el-row>
        <el-row>
          <el-col :span="8"><el-form-item label="充电站数" prop="totalChargeStations"><el-input-number v-model="form.totalChargeStations" :min="0" style="width:100%" /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="充电桩数" prop="totalChargePiles"><el-input-number v-model="form.totalChargePiles" :min="0" style="width:100%" /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="订单数" prop="totalChargeOrders"><el-input-number v-model="form.totalChargeOrders" :min="0" style="width:100%" /></el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="8"><el-form-item label="总电量" prop="totalEnergy"><el-input-number v-model="form.totalEnergy" :min="0" :precision="2" style="width:100%" /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="碳减排" prop="carbonReduction"><el-input-number v-model="form.carbonReduction" :min="0" :precision="2" style="width:100%" /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="等效树木" prop="equivalentTrees"><el-input-number v-model="form.equivalentTrees" :min="0" style="width:100%" /></el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="8"><el-form-item label="累计新能源车" prop="totalNevCount"><el-input-number v-model="form.totalNevCount" :min="0" style="width:100%" /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="新增新能源车" prop="newNevCount"><el-input-number v-model="form.newNevCount" :min="0" style="width:100%" /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="发放积分" prop="totalPointsIssued"><el-input-number v-model="form.totalPointsIssued" :min="0" style="width:100%" /></el-form-item></el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer"><el-button type="primary" @click="submitForm">确 定</el-button><el-button @click="cancel">取 消</el-button></div>
    </el-dialog>
  </div>
</template>
<script>
import { listCarbonStatistics, getCarbonStatistics, delCarbonStatistics, addCarbonStatistics, updateCarbonStatistics } from "@/api/business/carbonstatistics"
export default {
  name: "CarbonStatistics",
  data() {
    return {
      loading: true, ids: [], single: true, multiple: true, showSearch: true, total: 0,
      statList: [], title: "", open: false,
      queryParams: { pageNum: 1, pageSize: 10, city: undefined, statDate: undefined },
      form: {}, rules: { statDate: [{ required: true, message: "统计日期不能为空", trigger: "blur" }] }
    }
  },
  created() { this.getList() },
  methods: {
    getList() { this.loading = true; listCarbonStatistics(this.queryParams).then(response => { this.statList = response.rows; this.total = response.total; this.loading = false }) },
    cancel() { this.open = false; this.reset() },
    reset() { this.form = { statDate: undefined, city: undefined, district: undefined, totalChargeStations: 0, totalChargePiles: 0, totalChargeOrders: 0, totalEnergy: undefined, carbonReduction: undefined, equivalentTrees: 0, totalNevCount: 0, newNevCount: 0, totalPointsIssued: 0, totalPointsRedeemed: 0 }; this.resetForm("form") },
    handleQuery() { this.queryParams.pageNum = 1; this.getList() },
    resetQuery() { this.resetForm("queryForm"); this.handleQuery() },
    handleSelectionChange(selection) { this.ids = selection.map(item => item.statId); this.single = selection.length != 1; this.multiple = !selection.length },
    handleAdd() { this.reset(); this.open = true; this.title = "添加碳减排统计" },
    handleUpdate(row) { this.reset(); const statId = row.statId || this.ids; getCarbonStatistics(statId).then(response => { this.form = response.data; this.open = true; this.title = "修改碳减排统计" }) },
    submitForm() { this.$refs["form"].validate(valid => { if (valid) { if (this.form.statId != undefined) { updateCarbonStatistics(this.form).then(() => { this.$modal.msgSuccess("修改成功"); this.open = false; this.getList() }) } else { addCarbonStatistics(this.form).then(() => { this.$modal.msgSuccess("新增成功"); this.open = false; this.getList() }) } } }) },
    handleDelete(row) { const statIds = row.statId || this.ids; this.$modal.confirm('是否确认删除统计编号为"' + statIds + '"的数据项？').then(function() { return delCarbonStatistics(statIds) }).then(() => { this.getList(); this.$modal.msgSuccess("删除成功") }).catch(() => {}) }
  }
}
</script>