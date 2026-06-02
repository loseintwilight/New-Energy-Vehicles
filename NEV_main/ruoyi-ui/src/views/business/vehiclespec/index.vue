<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="车辆ID" prop="vehicleId">
        <el-input v-model="queryParams.vehicleId" placeholder="请输入车辆ID" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="年款" prop="modelYear">
        <el-input v-model="queryParams.modelYear" placeholder="请输入年款" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['business:vehiclespec:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['business:vehiclespec:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['business:vehiclespec:remove']">删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="specList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="编号" align="center" prop="specId" />
      <el-table-column label="车辆ID" align="center" prop="vehicleId" />
      <el-table-column label="续航(km)" align="center" prop="rangeKm" />
      <el-table-column label="电池容量" align="center" prop="batteryCapacity" />
      <el-table-column label="快充时间" align="center" prop="chargeTimeFast" />
      <el-table-column label="慢充时间" align="center" prop="chargeTimeSlow" />
      <el-table-column label="年款" align="center" prop="modelYear" />
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template slot-scope="scope"><span>{{ parseTime(scope.row.createTime) }}</span></template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['business:vehiclespec:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['business:vehiclespec:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="600px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="车辆ID" prop="vehicleId">
          <el-input v-model="form.vehicleId" placeholder="请输入车辆ID" />
        </el-form-item>
        <el-row>
          <el-col :span="12"><el-form-item label="续航(km)" prop="rangeKm"><el-input-number v-model="form.rangeKm" :min="0" style="width:100%" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="电池容量(kWh)" prop="batteryCapacity"><el-input-number v-model="form.batteryCapacity" :min="0" :precision="1" style="width:100%" /></el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="12"><el-form-item label="快充时间(h)" prop="chargeTimeFast"><el-input-number v-model="form.chargeTimeFast" :min="0" :precision="1" style="width:100%" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="慢充时间(h)" prop="chargeTimeSlow"><el-input-number v-model="form.chargeTimeSlow" :min="0" :precision="1" style="width:100%" /></el-form-item></el-col>
        </el-row>
        <el-form-item label="年款" prop="modelYear">
          <el-input v-model="form.modelYear" placeholder="请输入年款，如2024" />
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
import { listVehicleSpec, getVehicleSpec, delVehicleSpec, addVehicleSpec, updateVehicleSpec } from "@/api/business/vehiclespec"

export default {
  name: "VehicleSpec",
  data() {
    return {
      loading: true, ids: [], single: true, multiple: true, showSearch: true, total: 0,
      specList: [], title: "", open: false,
      queryParams: { pageNum: 1, pageSize: 10, vehicleId: undefined, modelYear: undefined },
      form: {},
      rules: {
        vehicleId: [{ required: true, message: "车辆ID不能为空", trigger: "blur" }]
      }
    }
  },
  created() { this.getList() },
  methods: {
    getList() { this.loading = true; listVehicleSpec(this.queryParams).then(response => { this.specList = response.rows; this.total = response.total; this.loading = false }) },
    cancel() { this.open = false; this.reset() },
    reset() { this.form = { vehicleId: undefined, rangeKm: undefined, batteryCapacity: undefined, chargeTimeFast: undefined, chargeTimeSlow: undefined, modelYear: undefined }; this.resetForm("form") },
    handleQuery() { this.queryParams.pageNum = 1; this.getList() },
    resetQuery() { this.resetForm("queryForm"); this.handleQuery() },
    handleSelectionChange(selection) { this.ids = selection.map(item => item.specId); this.single = selection.length != 1; this.multiple = !selection.length },
    handleAdd() { this.reset(); this.open = true; this.title = "添加车辆规格配置" },
    handleUpdate(row) { this.reset(); const specId = row.specId || this.ids; getVehicleSpec(specId).then(response => { this.form = response.data; this.open = true; this.title = "修改车辆规格配置" }) },
    submitForm() { this.$refs["form"].validate(valid => { if (valid) { if (this.form.specId != undefined) { updateVehicleSpec(this.form).then(() => { this.$modal.msgSuccess("修改成功"); this.open = false; this.getList() }) } else { addVehicleSpec(this.form).then(() => { this.$modal.msgSuccess("新增成功"); this.open = false; this.getList() }) } } }) },
    handleDelete(row) { const specIds = row.specId || this.ids; this.$modal.confirm('是否确认删除规格编号为"' + specIds + '"的数据项？').then(function() { return delVehicleSpec(specIds) }).then(() => { this.getList(); this.$modal.msgSuccess("删除成功") }).catch(() => {}) }
  }
}
</script>