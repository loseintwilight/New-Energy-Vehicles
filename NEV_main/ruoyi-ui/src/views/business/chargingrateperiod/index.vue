<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="费率ID" prop="rateId">
        <el-input v-model="queryParams.rateId" placeholder="请输入费率ID" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['business:chargingrateperiod:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['business:chargingrateperiod:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['business:chargingrateperiod:remove']">删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="periodList" @selection-change="handleSelectionChange" :default-sort="{prop: 'periodId', order: 'ascending'}">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="编号" align="center" prop="periodId" />
      <el-table-column label="时段名称" align="center" prop="periodName" />
      <el-table-column label="开始" align="center" prop="startTime" width="80">
        <template slot-scope="scope"><span>{{ scope.row.startTime ? scope.row.startTime.substring(0, 5) : '' }}</span></template>
      </el-table-column>
      <el-table-column label="结束" align="center" prop="endTime" width="80">
        <template slot-scope="scope"><span>{{ scope.row.endTime ? scope.row.endTime.substring(0, 5) : '' }}</span></template>
      </el-table-column>
      <el-table-column label="电费(元)" align="center" prop="energyPrice" width="100" />
      <el-table-column label="服务费(元)" align="center" prop="serviceFee" width="100" />
      <el-table-column label="总价(元)" align="center" prop="totalPrice" width="100" />
      <el-table-column label="折扣率" align="center" prop="discountRate">
        <template slot-scope="scope">{{ scope.row.discountRate ? scope.row.discountRate * 100 + '%' : '-' }}</template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['business:chargingrateperiod:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['business:chargingrateperiod:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="800px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="110px">
        <el-form-item label="费率ID" prop="rateId">
          <el-input v-model="form.rateId" placeholder="请输入费率ID" />
        </el-form-item>
        <el-form-item label="时段名称" prop="periodName">
          <el-input v-model="form.periodName" placeholder="如高峰时段、平段、低谷" />
        </el-form-item>
        <el-row>
          <el-col :span="12"><el-form-item label="开始时间" prop="startTime"><el-time-picker v-model="form.startTime" placeholder="选择时间" style="width:100%" value-format="HH:mm:ss" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="结束时间" prop="endTime"><el-time-picker v-model="form.endTime" placeholder="选择时间" style="width:100%" value-format="HH:mm:ss" /></el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="12"><el-form-item label="电费" prop="energyPrice"><el-input-number v-model="form.energyPrice" :min="0" :precision="4" style="width:100%" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="服务费" prop="serviceFee"><el-input-number v-model="form.serviceFee" :min="0" :precision="4" style="width:100%" /></el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="12"><el-form-item label="总价" prop="totalPrice"><el-input-number v-model="form.totalPrice" :min="0" :precision="4" style="width:100%" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="折扣率" prop="discountRate"><el-input-number v-model="form.discountRate" :min="0" :max="1" :precision="2" :step="0.05" style="width:100%" /></el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="12"><el-form-item label="排序" prop="sortOrder"><el-input-number v-model="form.sortOrder" :min="0" style="width:100%" /></el-form-item></el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listChargingRatePeriod, getChargingRatePeriod, delChargingRatePeriod, addChargingRatePeriod, updateChargingRatePeriod } from "@/api/business/chargingrateperiod"

export default {
  name: "ChargingRatePeriod",
  data() {
    return {
      loading: true, ids: [], single: true, multiple: true, showSearch: true, total: 0,
      periodList: [], title: "", open: false,
      queryParams: { pageNum: 1, pageSize: 10, rateId: undefined },
      form: {},
      rules: {
        rateId: [{ required: true, message: "费率ID不能为空", trigger: "blur" }]
      }
    }
  },
  created() { this.getList() },
  methods: {
    getList() { this.loading = true; listChargingRatePeriod(this.queryParams).then(response => { this.periodList = response.rows; this.total = response.total; this.loading = false }) },
    cancel() { this.open = false; this.reset() },
    reset() { this.form = { rateId: undefined, periodName: undefined, startTime: undefined, endTime: undefined, energyPrice: undefined, serviceFee: undefined, totalPrice: undefined, discountRate: undefined, sortOrder: 0 }; this.resetForm("form") },
    handleQuery() { this.queryParams.pageNum = 1; this.getList() },
    resetQuery() { this.resetForm("queryForm"); this.handleQuery() },
    handleSelectionChange(selection) { this.ids = selection.map(item => item.periodId); this.single = selection.length != 1; this.multiple = !selection.length },
    handleAdd() { this.reset(); this.open = true; this.title = "添加费率时段" },
    handleUpdate(row) { this.reset(); const periodId = row.periodId || this.ids; getChargingRatePeriod(periodId).then(response => { this.form = response.data; this.open = true; this.title = "修改费率时段" }) },
    submitForm() { this.$refs["form"].validate(valid => { if (valid) { if (this.form.periodId != undefined) { updateChargingRatePeriod(this.form).then(() => { this.$modal.msgSuccess("修改成功"); this.open = false; this.getList() }) } else { addChargingRatePeriod(this.form).then(() => { this.$modal.msgSuccess("新增成功"); this.open = false; this.getList() }) } } }) },
    handleDelete(row) { const periodIds = row.periodId || this.ids; this.$modal.confirm('是否确认删除时段编号为"' + periodIds + '"的数据项？').then(function() { return delChargingRatePeriod(periodIds) }).then(() => { this.getList(); this.$modal.msgSuccess("删除成功") }).catch(() => {}) }
  }
}
</script>