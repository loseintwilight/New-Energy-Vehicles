<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="充电站" prop="stationId">
        <el-input v-model="queryParams.stationId" placeholder="请输入充电站ID" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="类型" prop="pileType">
        <el-select v-model="queryParams.pileType" placeholder="请选择" clearable>
          <el-option label="直流快充" value="DC" />
          <el-option label="交流慢充" value="AC" />
        </el-select>
      </el-form-item>
      <el-form-item label="状态" prop="pileStatus">
        <el-select v-model="queryParams.pileStatus" placeholder="请选择" clearable>
          <el-option label="空闲" value="0" />
          <el-option label="充电中" value="1" />
          <el-option label="离线" value="2" />
          <el-option label="故障" value="3" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['business:chargingpile:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['business:chargingpile:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['business:chargingpile:remove']">删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="pileList" @selection-change="handleSelectionChange" :default-sort="{prop: 'lastHeartbeat', order: 'descending'}">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="编号" align="center" prop="pileId" />
      <el-table-column label="桩编号" align="center" prop="pileCode" />
      <el-table-column label="类型" align="center" prop="pileType" />
      <el-table-column label="功率(kW)" align="center" prop="powerKw" />
      <el-table-column label="接口" align="center" prop="connectorType" />
      <el-table-column label="状态" align="center" prop="pileStatus">
        <template slot-scope="scope">
          <el-tag :type="scope.row.pileStatus === '0' ? 'success' : scope.row.pileStatus === '1' ? 'warning' : scope.row.pileStatus === '2' ? 'info' : 'danger'">
            {{ {'0':'空闲','1':'充电中','2':'离线','3':'故障'}[scope.row.pileStatus] || scope.row.pileStatus }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="最后心跳" align="center" prop="lastHeartbeat" width="180">
        <template slot-scope="scope"><span>{{ parseTime(scope.row.lastHeartbeat) }}</span></template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['business:chargingpile:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['business:chargingpile:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="700px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="110px">
        <el-form-item label="充电站ID" prop="stationId">
          <el-input v-model="form.stationId" placeholder="请输入充电站ID" />
        </el-form-item>
        <el-row>
          <el-col :span="12"><el-form-item label="桩编号" prop="pileCode"><el-input v-model="form.pileCode" placeholder="桩编号" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="类型" prop="pileType"><el-select v-model="form.pileType" placeholder="请选择" style="width:100%"><el-option label="直流快充" value="DC" /><el-option label="交流慢充" value="AC" /></el-select></el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="12"><el-form-item label="接入类型" prop="accessType"><el-select v-model="form.accessType" placeholder="请选择" style="width:100%"><el-option label="直流" value="DC" /><el-option label="交流" value="AC" /></el-select></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="功率(kW)" prop="powerKw"><el-input-number v-model="form.powerKw" :min="0" :precision="1" style="width:100%" /></el-form-item></el-col>
        </el-row>
        <el-form-item label="接口类型" prop="connectorType">
          <el-input v-model="form.connectorType" placeholder="如GB/T、CCS、CHAdeMO" />
        </el-form-item>
        <el-form-item label="状态" prop="pileStatus">
          <el-radio-group v-model="form.pileStatus">
            <el-radio label="0">空闲</el-radio>
            <el-radio label="1">充电中</el-radio>
            <el-radio label="2">离线</el-radio>
            <el-radio label="3">故障</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="排序" prop="sortOrder">
          <el-input-number v-model="form.sortOrder" :min="0" style="width:100%" />
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
import { listChargingPile, getChargingPile, delChargingPile, addChargingPile, updateChargingPile } from "@/api/business/chargingpile"

export default {
  name: "ChargingPile",
  data() {
    return {
      loading: true, ids: [], single: true, multiple: true, showSearch: true, total: 0,
      pileList: [], title: "", open: false,
      queryParams: { pageNum: 1, pageSize: 10, stationId: undefined, pileType: undefined, pileStatus: undefined },
      form: {},
      rules: {
        stationId: [{ required: true, message: "充电站ID不能为空", trigger: "blur" }],
        pileCode: [{ required: true, message: "桩编号不能为空", trigger: "blur" }]
      }
    }
  },
  created() { this.getList() },
  methods: {
    getList() { this.loading = true; listChargingPile(this.queryParams).then(response => { this.pileList = response.rows; this.total = response.total; this.loading = false }) },
    cancel() { this.open = false; this.reset() },
    reset() { this.form = { stationId: undefined, pileCode: undefined, pileType: "DC", accessType: "DC", powerKw: undefined, connectorType: undefined, pileStatus: "0", sortOrder: 0 }; this.resetForm("form") },
    handleQuery() { this.queryParams.pageNum = 1; this.getList() },
    resetQuery() { this.resetForm("queryForm"); this.handleQuery() },
    handleSelectionChange(selection) { this.ids = selection.map(item => item.pileId); this.single = selection.length != 1; this.multiple = !selection.length },
    handleAdd() { this.reset(); this.open = true; this.title = "添加充电桩" },
    handleUpdate(row) { this.reset(); const pileId = row.pileId || this.ids; getChargingPile(pileId).then(response => { this.form = response.data; this.open = true; this.title = "修改充电桩" }) },
    submitForm() { this.$refs["form"].validate(valid => { if (valid) { if (this.form.pileId != undefined) { updateChargingPile(this.form).then(() => { this.$modal.msgSuccess("修改成功"); this.open = false; this.getList() }) } else { addChargingPile(this.form).then(() => { this.$modal.msgSuccess("新增成功"); this.open = false; this.getList() }) } } }) },
    handleDelete(row) { const pileIds = row.pileId || this.ids; this.$modal.confirm('是否确认删除充电桩编号为"' + pileIds + '"的数据项？').then(function() { return delChargingPile(pileIds) }).then(() => { this.getList(); this.$modal.msgSuccess("删除成功") }).catch(() => {}) }
  }
}
</script>