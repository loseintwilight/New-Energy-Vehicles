<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="城市" prop="city"><el-input v-model="queryParams.city" placeholder="城市" clearable @keyup.enter.native="handleQuery" /></el-form-item>
      <el-form-item label="统计日期" prop="statDate"><el-date-picker v-model="queryParams.statDate" type="date" placeholder="选择日期" clearable value-format="yyyy-MM-dd" style="width:100%" /></el-form-item>
      <el-form-item><el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button><el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button></el-form-item>
    </el-form>
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5"><el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['business:govregistration:add']">新增</el-button></el-col>
      <el-col :span="1.5"><el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['business:govregistration:edit']">修改</el-button></el-col>
      <el-col :span="1.5"><el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['business:govregistration:remove']">删除</el-button></el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>
    <el-table v-loading="loading" :data="regList" @selection-change="handleSelectionChange" :default-sort="{prop: 'statDate', order: 'descending'}">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="编号" align="center" prop="regId" />
      <el-table-column label="统计日期" align="center" prop="statDate" width="120" />
      <el-table-column label="城市" align="center" prop="city" /><el-table-column label="区县" align="center" prop="district" />
      <el-table-column label="新登记数" align="center" prop="newRegistrations" />
      <el-table-column label="累计车辆" align="center" prop="totalVehicles" />
      <el-table-column label="纯电" align="center" prop="evCount" /><el-table-column label="插混" align="center" prop="phevCount" /><el-table-column label="氢燃料" align="center" prop="fcevCount" />
      <el-table-column label="数据来源" align="center" prop="dataSource" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['business:govregistration:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['business:govregistration:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
    <el-dialog :title="title" :visible.sync="open" width="800px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="统计日期" prop="statDate"><el-date-picker v-model="form.statDate" type="date" placeholder="选择日期" style="width:100%" value-format="yyyy-MM-dd" /></el-form-item>
        <el-row><el-col :span="12"><el-form-item label="城市" prop="city"><el-input v-model="form.city" /></el-form-item></el-col><el-col :span="12"><el-form-item label="区县" prop="district"><el-input v-model="form.district" /></el-form-item></el-col></el-row>
        <el-row>
          <el-col :span="12"><el-form-item label="新登记" prop="newRegistrations"><el-input-number v-model="form.newRegistrations" :min="0" style="width:100%" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="累计" prop="totalVehicles"><el-input-number v-model="form.totalVehicles" :min="0" style="width:100%" /></el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="12"><el-form-item label="纯电" prop="evCount"><el-input-number v-model="form.evCount" :min="0" style="width:100%" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="插混" prop="phevCount"><el-input-number v-model="form.phevCount" :min="0" style="width:100%" /></el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="12"><el-form-item label="氢燃料" prop="fcevCount"><el-input-number v-model="form.fcevCount" :min="0" style="width:100%" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="数据来源" prop="dataSource"><el-input v-model="form.dataSource" placeholder="数据来源" /></el-form-item></el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer"><el-button type="primary" @click="submitForm">确 定</el-button><el-button @click="cancel">取 消</el-button></div>
    </el-dialog>
  </div>
</template>
<script>
import { listGovRegistration, getGovRegistration, delGovRegistration, addGovRegistration, updateGovRegistration } from "@/api/business/govregistration"
export default {
  name: "GovRegistration",
  data() {
    return {
      loading: true, ids: [], single: true, multiple: true, showSearch: true, total: 0,
      regList: [], title: "", open: false,
      queryParams: { pageNum: 1, pageSize: 10, city: undefined, statDate: undefined },
      form: {}, rules: { statDate: [{ required: true, message: "统计日期不能为空", trigger: "blur" }] }
    }
  },
  created() { this.getList() },
  methods: {
    getList() { this.loading = true; listGovRegistration(this.queryParams).then(response => { this.regList = response.rows; this.total = response.total; this.loading = false }) },
    cancel() { this.open = false; this.reset() },
    reset() { this.form = { statDate: undefined, city: undefined, district: undefined, newRegistrations: 0, totalVehicles: 0, evCount: 0, phevCount: 0, fcevCount: 0, dataSource: undefined }; this.resetForm("form") },
    handleQuery() { this.queryParams.pageNum = 1; this.getList() },
    resetQuery() { this.resetForm("queryForm"); this.handleQuery() },
    handleSelectionChange(selection) { this.ids = selection.map(item => item.regId); this.single = selection.length != 1; this.multiple = !selection.length },
    handleAdd() { this.reset(); this.open = true; this.title = "添加上牌登记" },
    handleUpdate(row) { this.reset(); const regId = row.regId || this.ids; getGovRegistration(regId).then(response => { this.form = response.data; this.open = true; this.title = "修改上牌登记" }) },
    submitForm() { this.$refs["form"].validate(valid => { if (valid) { if (this.form.regId != undefined) { updateGovRegistration(this.form).then(() => { this.$modal.msgSuccess("修改成功"); this.open = false; this.getList() }) } else { addGovRegistration(this.form).then(() => { this.$modal.msgSuccess("新增成功"); this.open = false; this.getList() }) } } }) },
    handleDelete(row) { const regIds = row.regId || this.ids; this.$modal.confirm('是否确认删除登记编号为"' + regIds + '"的数据项？').then(function() { return delGovRegistration(regIds) }).then(() => { this.getList(); this.$modal.msgSuccess("删除成功") }).catch(() => {}) }
  }
}
</script>