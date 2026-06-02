<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="用户ID" prop="userId"><el-input v-model="queryParams.userId" placeholder="用户ID" clearable @keyup.enter.native="handleQuery" /></el-form-item>
      <el-form-item label="记录类型" prop="recordType">
        <el-select v-model="queryParams.recordType" placeholder="类型" clearable>
          <el-option label="获得" value="1" /><el-option label="消耗" value="2" /><el-option label="退款" value="3" />
        </el-select>
      </el-form-item>
      <el-form-item><el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button><el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button></el-form-item>
    </el-form>
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5"><el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['business:carbonledger:add']">新增</el-button></el-col>
      <el-col :span="1.5"><el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['business:carbonledger:edit']">修改</el-button></el-col>
      <el-col :span="1.5"><el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['business:carbonledger:remove']">删除</el-button></el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>
    <el-table v-loading="loading" :data="ledgerList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="编号" align="center" prop="ledgerId" />
      <el-table-column label="用户ID" align="center" prop="userId" />
      <el-table-column label="类型" align="center" prop="recordType">
        <template slot-scope="scope"><el-tag :type="scope.row.recordType === 1 ? 'success' : 'warning'">{{ {1:'获得',2:'消耗',3:'退款'}[scope.row.recordType] || scope.row.recordType }}</el-tag></template>
      </el-table-column>
      <el-table-column label="积分数" align="center" prop="points" />
      <el-table-column label="余额" align="center" prop="balanceAfter" />
      <el-table-column label="来源" align="center" prop="sourceType" />
      <el-table-column label="备注" align="center" prop="remark" show-overflow-tooltip />
      <el-table-column label="时间" align="center" prop="createTime" width="180"><template slot-scope="scope"><span>{{ parseTime(scope.row.createTime) }}</span></template></el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['business:carbonledger:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['business:carbonledger:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="用户ID" prop="userId"><el-input v-model="form.userId" /></el-form-item>
        <el-form-item label="记录类型" prop="recordType"><el-radio-group v-model="form.recordType"><el-radio :label="1">获得</el-radio><el-radio :label="2">消耗</el-radio><el-radio :label="3">退款</el-radio></el-radio-group></el-form-item>
        <el-row><el-col :span="12"><el-form-item label="积分数" prop="points"><el-input-number v-model="form.points" :min="0" style="width:100%" /></el-form-item></el-col><el-col :span="12"><el-form-item label="余额" prop="balanceAfter"><el-input-number v-model="form.balanceAfter" :min="0" style="width:100%" /></el-form-item></el-col></el-row>
        <el-form-item label="来源类型" prop="sourceType"><el-input v-model="form.sourceType" placeholder="来源类型：10-充电 20-回收 30-签到" /></el-form-item>
        <el-form-item label="备注" prop="remark"><el-input v-model="form.remark" type="textarea" :rows="2" /></el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer"><el-button type="primary" @click="submitForm">确 定</el-button><el-button @click="cancel">取 消</el-button></div>
    </el-dialog>
  </div>
</template>
<script>
import { listCarbonLedger, getCarbonLedger, delCarbonLedger, addCarbonLedger, updateCarbonLedger } from "@/api/business/carbonledger"
export default {
  name: "CarbonLedger",
  data() {
    return {
      loading: true, ids: [], single: true, multiple: true, showSearch: true, total: 0,
      ledgerList: [], title: "", open: false,
      queryParams: { pageNum: 1, pageSize: 10, userId: undefined, recordType: undefined },
      form: {},
      rules: { userId: [{ required: true, message: "用户ID不能为空", trigger: "blur" }] }
    }
  },
  created() { this.getList() },
  methods: {
    getList() { this.loading = true; listCarbonLedger(this.queryParams).then(response => { this.ledgerList = response.rows; this.total = response.total; this.loading = false }) },
    cancel() { this.open = false; this.reset() },
    reset() { this.form = { userId: undefined, recordType: 1, points: 0, balanceAfter: 0, sourceType: undefined, remark: undefined }; this.resetForm("form") },
    handleQuery() { this.queryParams.pageNum = 1; this.getList() },
    resetQuery() { this.resetForm("queryForm"); this.handleQuery() },
    handleSelectionChange(selection) { this.ids = selection.map(item => item.ledgerId); this.single = selection.length != 1; this.multiple = !selection.length },
    handleAdd() { this.reset(); this.open = true; this.title = "添加碳积分流水" },
    handleUpdate(row) { this.reset(); const ledgerId = row.ledgerId || this.ids; getCarbonLedger(ledgerId).then(response => { this.form = response.data; this.open = true; this.title = "修改碳积分流水" }) },
    submitForm() { this.$refs["form"].validate(valid => { if (valid) { if (this.form.ledgerId != undefined) { updateCarbonLedger(this.form).then(() => { this.$modal.msgSuccess("修改成功"); this.open = false; this.getList() }) } else { addCarbonLedger(this.form).then(() => { this.$modal.msgSuccess("新增成功"); this.open = false; this.getList() }) } } }) },
    handleDelete(row) { const ledgerIds = row.ledgerId || this.ids; this.$modal.confirm('是否确认删除流水编号为"' + ledgerIds + '"的数据项？').then(function() { return delCarbonLedger(ledgerIds) }).then(() => { this.getList(); this.$modal.msgSuccess("删除成功") }).catch(() => {}) }
  }
}
</script>