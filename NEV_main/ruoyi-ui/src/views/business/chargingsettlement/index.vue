<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="商户ID" prop="merchantId">
        <el-input v-model="queryParams.merchantId" placeholder="请输入商户ID" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="结算日期" prop="settleDate">
        <el-date-picker v-model="queryParams.settleDate" type="date" placeholder="选择日期" clearable value-format="yyyy-MM-dd" style="width:100%" />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择" clearable>
          <el-option label="待结算" value="0" />
          <el-option label="已结算" value="1" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['business:chargingsettlement:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['business:chargingsettlement:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['business:chargingsettlement:remove']">删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="settlementList" @selection-change="handleSelectionChange" :default-sort="{prop: 'settleDate', order: 'descending'}">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="编号" align="center" prop="settlementId" />
      <el-table-column label="结算日期" align="center" prop="settleDate" width="120" />
      <el-table-column label="订单数" align="center" prop="totalOrders" />
      <el-table-column label="总电量" align="center" prop="totalEnergy" />
      <el-table-column label="总金额" align="center" prop="totalAmount" />
      <el-table-column label="平台佣金" align="center" prop="platformCommission" />
      <el-table-column label="结算金额" align="center" prop="settleAmount" />
      <el-table-column label="状态" align="center" prop="status">
        <template slot-scope="scope">
          <el-tag :type="scope.row.status === '1' ? 'success' : scope.row.status === '0' ? 'warning' : 'info'">
            {{ {'0':'待结算','1':'已结算'}[scope.row.status] || scope.row.status }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['business:chargingsettlement:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['business:chargingsettlement:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="700px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="商户ID" prop="merchantId">
          <el-input v-model="form.merchantId" placeholder="请输入商户ID" />
        </el-form-item>
        <el-form-item label="结算日期" prop="settleDate">
          <el-date-picker v-model="form.settleDate" type="date" placeholder="选择日期" style="width:100%" value-format="yyyy-MM-dd" />
        </el-form-item>
        <el-row>
          <el-col :span="8"><el-form-item label="订单数" prop="totalOrders"><el-input-number v-model="form.totalOrders" :min="0" style="width:100%" /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="总电量" prop="totalEnergy"><el-input-number v-model="form.totalEnergy" :min="0" :precision="2" style="width:100%" /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="总金额" prop="totalAmount"><el-input-number v-model="form.totalAmount" :min="0" :precision="2" style="width:100%" /></el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="12"><el-form-item label="平台佣金" prop="platformCommission"><el-input-number v-model="form.platformCommission" :min="0" :precision="2" style="width:100%" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="结算金额" prop="settleAmount"><el-input-number v-model="form.settleAmount" :min="0" :precision="2" style="width:100%" /></el-form-item></el-col>
        </el-row>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio label="0">待结算</el-radio>
            <el-radio label="1">已结算</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listChargingSettlement, getChargingSettlement, delChargingSettlement, addChargingSettlement, updateChargingSettlement } from "@/api/business/chargingsettlement"

export default {
  name: "ChargingSettlement",
  data() {
    return {
      loading: true, ids: [], single: true, multiple: true, showSearch: true, total: 0,
      settlementList: [], title: "", open: false,
      queryParams: { pageNum: 1, pageSize: 10, merchantId: undefined, settleDate: undefined, status: undefined },
      form: {},
      rules: {
        merchantId: [{ required: true, message: "商户ID不能为空", trigger: "blur" }]
      }
    }
  },
  created() { this.getList() },
  methods: {
    getList() { this.loading = true; listChargingSettlement(this.queryParams).then(response => { this.settlementList = response.rows; this.total = response.total; this.loading = false }) },
    cancel() { this.open = false; this.reset() },
    reset() { this.form = { merchantId: undefined, settleDate: undefined, totalOrders: 0, totalEnergy: undefined, totalAmount: undefined, platformCommission: undefined, settleAmount: undefined, status: "0" }; this.resetForm("form") },
    handleQuery() { this.queryParams.pageNum = 1; this.getList() },
    resetQuery() { this.resetForm("queryForm"); this.handleQuery() },
    handleSelectionChange(selection) { this.ids = selection.map(item => item.settlementId); this.single = selection.length != 1; this.multiple = !selection.length },
    handleAdd() { this.reset(); this.open = true; this.title = "添加结算" },
    handleUpdate(row) { this.reset(); const settlementId = row.settlementId || this.ids; getChargingSettlement(settlementId).then(response => { this.form = response.data; this.open = true; this.title = "修改结算" }) },
    submitForm() { this.$refs["form"].validate(valid => { if (valid) { if (this.form.settlementId != undefined) { updateChargingSettlement(this.form).then(() => { this.$modal.msgSuccess("修改成功"); this.open = false; this.getList() }) } else { addChargingSettlement(this.form).then(() => { this.$modal.msgSuccess("新增成功"); this.open = false; this.getList() }) } } }) },
    handleDelete(row) { const settlementIds = row.settlementId || this.ids; this.$modal.confirm('是否确认删除结算编号为"' + settlementIds + '"的数据项？').then(function() { return delChargingSettlement(settlementIds) }).then(() => { this.getList(); this.$modal.msgSuccess("删除成功") }).catch(() => {}) }
  }
}
</script>