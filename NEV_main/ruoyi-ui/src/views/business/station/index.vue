<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="站点名称" prop="stationName">
        <el-input
          v-model="queryParams.stationName"
          placeholder="请输入站点名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="站点编号" prop="stationCode">
        <el-input
          v-model="queryParams.stationCode"
          placeholder="请输入站点编号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="城市" prop="city">
        <el-input
          v-model="queryParams.city"
          placeholder="请输入城市"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="状态" prop="stationStatus">
        <el-select v-model="queryParams.stationStatus" placeholder="站点状态" clearable>
          <el-option label="待审核" value="0" />
          <el-option label="运营中" value="1" />
          <el-option label="维护中" value="2" />
          <el-option label="已停用" value="3" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['business:station:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['business:station:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['business:station:remove']"
        >删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="stationList" @selection-change="handleSelectionChange" :default-sort="{prop: 'createTime', order: 'descending'}">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="编号" align="center" prop="stationId" />
      <el-table-column label="站点名称" align="center" prop="stationName" show-overflow-tooltip />
      <el-table-column label="站点编号" align="center" prop="stationCode" />
      <el-table-column label="城市" align="center" prop="city" />
      <el-table-column label="地址" align="center" prop="address" show-overflow-tooltip />
      <el-table-column label="总桩数" align="center" prop="totalPiles" />
      <el-table-column label="可用" align="center" prop="availablePiles" />
      <el-table-column label="所属商户" align="center" prop="merchantName" />
      <el-table-column label="状态" align="center" prop="stationStatus">
        <template slot-scope="scope">
          <el-tag :type="scope.row.stationStatus === '1' ? 'success' : scope.row.stationStatus === '2' ? 'warning' : scope.row.stationStatus === '0' ? 'info' : 'danger'">
            {{ {'0':'待审核','1':'运营中','2':'维护中','3':'已停用'}[scope.row.stationStatus] || scope.row.stationStatus }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['business:station:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['business:station:remove']"
          >删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <el-dialog :title="title" :visible.sync="open" width="700px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="站点名称" prop="stationName">
          <el-input v-model="form.stationName" placeholder="请输入站点名称" />
        </el-form-item>
        <el-form-item label="站点编号" prop="stationCode">
          <el-input v-model="form.stationCode" placeholder="请输入站点编号" />
        </el-form-item>
        <el-form-item label="所属商户" prop="merchantId">
          <el-input v-model="form.merchantId" placeholder="请输入商户ID" />
        </el-form-item>
        <el-row>
          <el-col :span="8">
            <el-form-item label="省份" prop="province">
              <el-input v-model="form.province" placeholder="省份" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="城市" prop="city">
              <el-input v-model="form.city" placeholder="城市" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="区县" prop="district">
              <el-input v-model="form.district" placeholder="区县" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="详细地址" prop="address">
          <el-input v-model="form.address" placeholder="请输入详细地址" />
        </el-form-item>
        <el-row>
          <el-col :span="12">
            <el-form-item label="经度" prop="longitude">
              <el-input-number v-model="form.longitude" :precision="6" :step="0.01" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="纬度" prop="latitude">
              <el-input-number v-model="form.latitude" :precision="6" :step="0.01" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="总桩数" prop="totalPiles">
              <el-input-number v-model="form.totalPiles" :min="0" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="可用" prop="availablePiles">
              <el-input-number v-model="form.availablePiles" :min="0" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="占用" prop="occupyingPiles">
              <el-input-number v-model="form.occupyingPiles" :min="0" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="营业时间" prop="openTime">
              <el-time-picker v-model="form.openTime" placeholder="开始" format="HH:mm" value-format="HH:mm:ss" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="结束时间" prop="closeTime">
              <el-time-picker v-model="form.closeTime" placeholder="结束" format="HH:mm" value-format="HH:mm:ss" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="停车费用" prop="parkingFee">
          <el-input v-model="form.parkingFee" placeholder="请输入停车费用说明" />
        </el-form-item>
        <el-form-item label="服务电话" prop="servicePhone">
          <el-input v-model="form.servicePhone" placeholder="请输入服务电话" />
        </el-form-item>
        <el-form-item label="设施信息" prop="facilitiesInfo">
          <el-input v-model="form.facilitiesInfo" placeholder="请输入设施信息" />
        </el-form-item>
        <el-form-item label="站点状态" prop="stationStatus">
          <el-radio-group v-model="form.stationStatus">
            <el-radio label="0">待审核</el-radio>
            <el-radio label="1">运营中</el-radio>
            <el-radio label="2">维护中</el-radio>
            <el-radio label="3">已停用</el-radio>
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
import { listStation, getStation, delStation, addStation, updateStation } from "@/api/business/station"

export default {
  name: "Station",
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      stationList: [],
      title: "",
      open: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        stationName: undefined,
        stationCode: undefined,
        city: undefined,
        stationStatus: undefined
      },
      form: {},
      rules: {
        stationName: [
          { required: true, message: "站点名称不能为空", trigger: "blur" }
        ],
        stationCode: [
          { required: true, message: "站点编号不能为空", trigger: "blur" }
        ]
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      listStation(this.queryParams).then(response => {
        this.stationList = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    cancel() {
      this.open = false
      this.reset()
    },
    reset() {
      this.form = {
        stationId: undefined,
        stationName: undefined,
        stationCode: undefined,
        merchantId: undefined,
        province: undefined,
        city: undefined,
        district: undefined,
        address: undefined,
        longitude: undefined,
        latitude: undefined,
        totalPiles: 0,
        availablePiles: 0,
        occupyingPiles: 0,
        openTime: undefined,
        closeTime: undefined,
        parkingFee: undefined,
        servicePhone: undefined,
        facilitiesInfo: undefined,
        stationStatus: "1"
      }
      this.resetForm("form")
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.resetForm("queryForm")
      this.handleQuery()
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.stationId)
      this.single = selection.length != 1
      this.multiple = !selection.length
    },
    handleAdd() {
      this.reset()
      this.open = true
      this.title = "添加充电站"
    },
    handleUpdate(row) {
      this.reset()
      const stationId = row.stationId || this.ids
      getStation(stationId).then(response => {
        this.form = response.data
        this.open = true
        this.title = "修改充电站"
      })
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.stationId != undefined) {
            updateStation(this.form).then(() => {
              this.$modal.msgSuccess("修改成功")
              this.open = false
              this.getList()
            })
          } else {
            addStation(this.form).then(() => {
              this.$modal.msgSuccess("新增成功")
              this.open = false
              this.getList()
            })
          }
        }
      })
    },
    handleDelete(row) {
      const stationIds = row.stationId || this.ids
      this.$modal.confirm('是否确认删除充电站编号为"' + stationIds + '"的数据项？').then(function() {
        return delStation(stationIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("删除成功")
      }).catch(() => {})
    }
  }
}
</script>