<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="充电站" prop="stationId">
        <el-input v-model="queryParams.stationId" placeholder="请输入充电站ID" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="适用类型" prop="pileType">
        <el-select v-model="queryParams.pileType" placeholder="请选择" clearable>
          <el-option label="直流快充" value="DC" />
          <el-option label="交流慢充" value="AC" />
          <el-option label="全部" value="ALL" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['business:chargingrate:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['business:chargingrate:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['business:chargingrate:remove']">删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="rateList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="编号" align="center" prop="rateId" />
      <el-table-column label="充电站ID" align="center" prop="stationId" />
      <el-table-column label="费率名称" align="center" prop="rateName" show-overflow-tooltip />
      <el-table-column label="适用类型" align="center" prop="pileType" />
      <el-table-column label="启用" align="center" prop="isActive">
        <template slot-scope="scope"><el-tag :type="scope.row.isActive === 1 ? 'success' : 'info'">{{ scope.row.isActive === 1 ? '启用' : '停用' }}</el-tag></template>
      </el-table-column>
      <el-table-column label="生效时间" align="center" prop="effectiveFrom" width="140">
        <template slot-scope="scope"><span>{{ parseTime(scope.row.effectiveFrom, '{y}-{m}-{d}') }}</span></template>
      </el-table-column>
      <el-table-column label="失效时间" align="center" prop="effectiveTo" width="140">
        <template slot-scope="scope"><span>{{ parseTime(scope.row.effectiveTo, '{y}-{m}-{d}') }}</span></template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['business:chargingrate:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['business:chargingrate:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="600px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="110px">
        <el-form-item label="充电站ID" prop="stationId">
          <el-input v-model="form.stationId" placeholder="请输入充电站ID" />
        </el-form-item>
        <el-row>
          <el-col :span="12"><el-form-item label="费率名称" prop="rateName"><el-input v-model="form.rateName" placeholder="费率名称" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="适用类型" prop="pileType"><el-select v-model="form.pileType" placeholder="请选择" style="width:100%"><el-option label="直流快充" value="DC" /><el-option label="交流慢充" value="AC" /><el-option label="全部" value="ALL" /></el-select></el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="12"><el-form-item label="生效日期" prop="effectiveFrom"><el-date-picker v-model="form.effectiveFrom" type="date" placeholder="选择日期" style="width:100%" value-format="yyyy-MM-dd HH:mm:ss" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="失效日期" prop="effectiveTo"><el-date-picker v-model="form.effectiveTo" type="date" placeholder="选择日期" style="width:100%" value-format="yyyy-MM-dd HH:mm:ss" /></el-form-item></el-col>
        </el-row>
        <el-form-item label="描述" prop="description">
          <el-input v-model="form.description" type="textarea" :rows="2" placeholder="费率描述" />
        </el-form-item>
        <el-row>
          <el-col :span="12"><el-form-item label="状态" prop="isActive"><el-radio-group v-model="form.isActive"><el-radio :label="0">停用</el-radio><el-radio :label="1">启用</el-radio></el-radio-group></el-form-item></el-col>
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
import { listChargingRate, getChargingRate, delChargingRate, addChargingRate, updateChargingRate } from "@/api/business/chargingrate"

export default {
  name: "ChargingRate",
  data() {
    return {
      loading: true, ids: [], single: true, multiple: true, showSearch: true, total: 0,
      rateList: [], title: "", open: false,
      queryParams: { pageNum: 1, pageSize: 10, stationId: undefined, pileType: undefined },
      form: {},
      rules: {
        stationId: [{ required: true, message: "充电站ID不能为空", trigger: "blur" }],
        rateName: [{ required: true, message: "费率名称不能为空", trigger: "blur" }]
      }
    }
  },
  created() { this.getList() },
  methods: {
    getList() { this.loading = true; listChargingRate(this.queryParams).then(response => { this.rateList = response.rows; this.total = response.total; this.loading = false }) },
    cancel() { this.open = false; this.reset() },
    reset() { this.form = { stationId: undefined, rateName: undefined, pileType: "ALL", isActive: 1, effectiveFrom: undefined, effectiveTo: undefined, description: undefined, sortOrder: 0 }; this.resetForm("form") },
    handleQuery() { this.queryParams.pageNum = 1; this.getList() },
    resetQuery() { this.resetForm("queryForm"); this.handleQuery() },
    handleSelectionChange(selection) { this.ids = selection.map(item => item.rateId); this.single = selection.length != 1; this.multiple = !selection.length },
    handleAdd() { this.reset(); this.open = true; this.title = "添加费率" },
    handleUpdate(row) { this.reset(); const rateId = row.rateId || this.ids; getChargingRate(rateId).then(response => { this.form = response.data; this.open = true; this.title = "修改费率" }) },
    submitForm() { this.$refs["form"].validate(valid => { if (valid) { if (this.form.rateId != undefined) { updateChargingRate(this.form).then(() => { this.$modal.msgSuccess("修改成功"); this.open = false; this.getList() }) } else { addChargingRate(this.form).then(() => { this.$modal.msgSuccess("新增成功"); this.open = false; this.getList() }) } } }) },
    handleDelete(row) { const rateIds = row.rateId || this.ids; this.$modal.confirm('是否确认删除费率编号为"' + rateIds + '"的数据项？').then(function() { return delChargingRate(rateIds) }).then(() => { this.getList(); this.$modal.msgSuccess("删除成功") }).catch(() => {}) }
  }
}
</script>