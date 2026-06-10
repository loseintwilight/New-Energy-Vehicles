<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="车辆ID" prop="vehicleId">
        <el-input v-model="queryParams.vehicleId" placeholder="请输入车辆ID" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['business:vehicleused:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['business:vehicleused:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['business:vehicleused:remove']">删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="usedList" @selection-change="handleSelectionChange" :default-sort="{prop: 'createTime', order: 'descending'}">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="编号" align="center" prop="usedId" />
      <el-table-column label="车辆名称" align="center" prop="vehicleName" show-overflow-tooltip />
      <el-table-column label="上牌年份" align="center" prop="licenseYear" />
      <el-table-column label="上牌月份" align="center" prop="licenseMonth" />
      <el-table-column label="所在城市" align="center" prop="licenseCity" />
      <el-table-column label="里程(万km)" align="center" prop="mileage" />
      <el-table-column label="过户次数" align="center" prop="transferCount" />
      <el-table-column label="电池SOH" align="center" prop="batterySoh">
        <template slot-scope="scope">{{ scope.row.batterySoh }}%</template>
      </el-table-column>
      <el-table-column label="估价(万)" align="center" prop="valuationPrice" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['business:vehicleused:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['business:vehicleused:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="800px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="车辆ID" prop="vehicleId">
          <el-input v-model="form.vehicleId" placeholder="请输入车辆ID" />
        </el-form-item>
        <el-row>
          <el-col :span="12"><el-form-item label="上牌年份" prop="licenseYear"><el-input-number v-model="form.licenseYear" :min="2000" :max="2030" style="width:100%" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="上牌月份" prop="licenseMonth"><el-input-number v-model="form.licenseMonth" :min="1" :max="12" style="width:100%" /></el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="12"><el-form-item label="城市" prop="licenseCity"><el-input v-model="form.licenseCity" placeholder="城市" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="里程(万km)" prop="mileage"><el-input-number v-model="form.mileage" :min="0" :precision="1" style="width:100%" /></el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="12"><el-form-item label="过户次数" prop="transferCount"><el-input-number v-model="form.transferCount" :min="0" style="width:100%" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="电池SOH(%)" prop="batterySoh"><el-input-number v-model="form.batterySoh" :min="0" :max="100" style="width:100%" /></el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="12"><el-form-item label="电池循环" prop="batteryCycles"><el-input-number v-model="form.batteryCycles" :min="0" style="width:100%" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="电池诊断" prop="batteryDiagnosis"><el-input v-model="form.batteryDiagnosis" placeholder="诊断结果" /></el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="12"><el-form-item label="估价(万)" prop="valuationPrice"><el-input-number v-model="form.valuationPrice" :min="0" :precision="2" style="width:100%" /></el-form-item></el-col>
        </el-row>
        <el-form-item label="电池报告" prop="batteryReport">
          <el-input v-model="form.batteryReport" placeholder="电池检测报告URL" />
        </el-form-item>
        <el-form-item label="估价说明" prop="valuationInfo">
          <el-input v-model="form.valuationInfo" type="textarea" :rows="2" placeholder="估价说明" />
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
import { listVehicleUsed, getVehicleUsed, delVehicleUsed, addVehicleUsed, updateVehicleUsed } from "@/api/business/vehicleused"

export default {
  name: "VehicleUsed",
  data() {
    return {
      loading: true, ids: [], single: true, multiple: true, showSearch: true, total: 0,
      usedList: [], title: "", open: false,
      queryParams: { pageNum: 1, pageSize: 10, vehicleId: undefined },
      form: {},
      rules: {
        vehicleId: [{ required: true, message: "车辆ID不能为空", trigger: "blur" }]
      }
    }
  },
  created() { this.getList() },
  methods: {
    getList() { this.loading = true; listVehicleUsed(this.queryParams).then(response => { this.usedList = response.rows; this.total = response.total; this.loading = false }) },
    cancel() { this.open = false; this.reset() },
    reset() { this.form = { vehicleId: undefined, licenseYear: undefined, licenseMonth: undefined, licenseCity: undefined, mileage: undefined, transferCount: undefined, batterySoh: undefined, batteryCycles: undefined, batteryDiagnosis: undefined, batteryReport: undefined, valuationPrice: undefined, valuationInfo: undefined }; this.resetForm("form") },
    handleQuery() { this.queryParams.pageNum = 1; this.getList() },
    resetQuery() { this.resetForm("queryForm"); this.handleQuery() },
    handleSelectionChange(selection) { this.ids = selection.map(item => item.usedId); this.single = selection.length != 1; this.multiple = !selection.length },
    handleAdd() { this.reset(); this.open = true; this.title = "添加二手车信息" },
    handleUpdate(row) { this.reset(); const usedId = row.usedId || this.ids; getVehicleUsed(usedId).then(response => { this.form = response.data; this.open = true; this.title = "修改二手车信息" }) },
    submitForm() { this.$refs["form"].validate(valid => { if (valid) { if (this.form.usedId != undefined) { updateVehicleUsed(this.form).then(() => { this.$modal.msgSuccess("修改成功"); this.open = false; this.getList() }) } else { addVehicleUsed(this.form).then(() => { this.$modal.msgSuccess("新增成功"); this.open = false; this.getList() }) } } }) },
    handleDelete(row) { const usedIds = row.usedId || this.ids; this.$modal.confirm('是否确认删除二手车编号为"' + usedIds + '"的数据项？').then(function() { return delVehicleUsed(usedIds) }).then(() => { this.getList(); this.$modal.msgSuccess("删除成功") }).catch(() => {}) }
  }
}
</script>