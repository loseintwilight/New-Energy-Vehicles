<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="车辆类别" prop="vehicleType">
        <el-select v-model="queryParams.vehicleType" placeholder="请选择车辆类别" clearable>
          <el-option label="新车" value="new" />
          <el-option label="二手车" value="used" />
        </el-select>
      </el-form-item>
      <el-form-item label="型号名称" prop="modelName">
        <el-input
          v-model="queryParams.modelName"
          placeholder="请输入型号名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="标题" prop="title">
        <el-input
          v-model="queryParams.title"
          placeholder="请输入标题"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="车辆状态" clearable>
          <el-option label="待审核" value="0" />
          <el-option label="在售" value="1" />
          <el-option label="已售" value="2" />
          <el-option label="下架" value="3" />
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
          v-hasPermi="['business:vehicle:add']"
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
          v-hasPermi="['business:vehicle:edit']"
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
          v-hasPermi="['business:vehicle:remove']"
        >删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="vehicleList" @selection-change="handleSelectionChange" :default-sort="{prop: 'createTime', order: 'descending'}">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="编号" align="center" prop="vehicleId" />
      <el-table-column label="车辆类别" align="center" prop="vehicleType">
        <template slot-scope="scope">
          <span>{{ {'new':'新车','used':'二手车'}[scope.row.vehicleType] || scope.row.vehicleType }}</span>
        </template>
      </el-table-column>
      <el-table-column label="型号名称" align="center" prop="modelName" />
      <el-table-column label="标题" align="center" prop="title" show-overflow-tooltip />
      <el-table-column label="指导价" align="center" prop="guidePrice" />
      <el-table-column label="颜色" align="center" prop="color" />
      <el-table-column label="续航(km)" align="center" prop="rangeKm" width="100" />
      <el-table-column label="电池容量" align="center" prop="batteryCapacity" width="100" />
      <el-table-column label="年款" align="center" prop="modelYear" width="80" />
      <el-table-column label="库存" align="center" prop="stock" />
      <el-table-column label="所属商户" align="center" prop="merchantName" />
      <el-table-column label="状态" align="center" prop="status">
        <template slot-scope="scope">
          <el-tag :type="scope.row.status === '1' ? 'success' : scope.row.status === '0' ? 'warning' : scope.row.status === '2' ? 'info' : 'danger'">
            {{ {'0':'待审核','1':'在售','2':'已售','3':'下架'}[scope.row.status] || scope.row.status }}
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
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['business:vehicle:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-view" @click="handleDetail(scope.row)" v-hasPermi="['business:vehicle:query']">详情</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['business:vehicle:remove']">删除</el-button>
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

    <el-dialog :title="title" :visible.sync="open" width="800px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="车辆类别" prop="vehicleType">
              <el-select v-model="form.vehicleType" placeholder="请选择车辆类别">
                <el-option label="新车" value="new" />
                <el-option label="二手车" value="used" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="型号名称" prop="modelName">
              <el-input v-model="form.modelName" placeholder="请输入型号名称" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="标题" prop="title">
              <el-input v-model="form.title" placeholder="请输入标题" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="颜色" prop="color">
              <el-input v-model="form.color" placeholder="请输入颜色" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="指导价" prop="guidePrice">
              <el-input-number v-model="form.guidePrice" :min="0" :precision="2" :step="1000" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="原价" prop="originalPrice">
              <el-input-number v-model="form.originalPrice" :min="0" :precision="2" :step="1000" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="库存" prop="stock">
              <el-input-number v-model="form.stock" :min="0" controls-position="right" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="所属商户" prop="merchantId">
              <el-input v-model="form.merchantId" placeholder="请输入商户ID" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="标签" prop="tags">
          <el-input v-model="form.tags" placeholder="请输入标签，多个用逗号分隔" />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input v-model="form.description" type="textarea" placeholder="请输入描述" />
        </el-form-item>
        <el-divider content-position="left">车辆规格</el-divider>
        <el-row>
          <el-col :span="12">
            <el-form-item label="续航(km)" prop="rangeKm">
              <el-input-number v-model="form.rangeKm" :min="0" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="电池容量(kWh)" prop="batteryCapacity">
              <el-input-number v-model="form.batteryCapacity" :min="0" :precision="2" :step="10" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="年款" prop="modelYear">
              <el-input-number v-model="form.modelYear" :min="2000" :max="2030" :step="1" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="快充时间(h)" prop="chargeTimeFast">
              <el-input-number v-model="form.chargeTimeFast" :min="0" :precision="2" :step="0.5" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="慢充时间(h)" prop="chargeTimeSlow">
              <el-input-number v-model="form.chargeTimeSlow" :min="0" :precision="2" :step="0.5" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog :title="title" :visible.sync="openDetail" width="800px" append-to-body>
      <el-tabs v-model="detailTab">
        <el-tab-pane label="基本信息" name="base">
          <el-form ref="detailForm" :model="detailData" label-width="100px">
            <el-row>
              <el-col :span="12"><el-form-item label="编号">{{ detailData.vehicleId }}</el-form-item></el-col>
              <el-col :span="12"><el-form-item label="车辆类别">{{ {'new':'新车','used':'二手车'}[detailData.vehicleType] || detailData.vehicleType }}</el-form-item></el-col>
            </el-row>
            <el-row>
              <el-col :span="12"><el-form-item label="型号名称">{{ detailData.modelName }}</el-form-item></el-col>
              <el-col :span="12"><el-form-item label="标题">{{ detailData.title }}</el-form-item></el-col>
            </el-row>
            <el-row>
              <el-col :span="12"><el-form-item label="指导价">{{ detailData.guidePrice }}</el-form-item></el-col>
              <el-col :span="12"><el-form-item label="原价">{{ detailData.originalPrice }}</el-form-item></el-col>
            </el-row>
            <el-row>
              <el-col :span="12"><el-form-item label="颜色">{{ detailData.color }}</el-form-item></el-col>
              <el-col :span="12"><el-form-item label="库存">{{ detailData.stock }}</el-form-item></el-col>
            </el-row>
            <el-row>
              <el-col :span="12"><el-form-item label="商户">{{ detailData.merchantName }}</el-form-item></el-col>
              <el-col :span="12"><el-form-item label="标签">{{ detailData.tags }}</el-form-item></el-col>
            </el-row>
            <el-row>
              <el-col :span="8"><el-form-item label="续航(km)">{{ detailData.rangeKm }}</el-form-item></el-col>
              <el-col :span="8"><el-form-item label="电池容量(kWh)">{{ detailData.batteryCapacity }}</el-form-item></el-col>
              <el-col :span="8"><el-form-item label="年款">{{ detailData.modelYear }}</el-form-item></el-col>
            </el-row>
            <el-row>
              <el-col :span="12"><el-form-item label="快充时间(h)">{{ detailData.chargeTimeFast }}</el-form-item></el-col>
              <el-col :span="12"><el-form-item label="慢充时间(h)">{{ detailData.chargeTimeSlow }}</el-form-item></el-col>
            </el-row>
            <el-form-item label="描述">{{ detailData.description }}</el-form-item>
          </el-form>
        </el-tab-pane>
        <el-tab-pane label="车辆规格" name="spec">
          <el-table v-loading="specLoading" :data="detailData.vehicleSpec ? [detailData.vehicleSpec] : []" border>
            <el-table-column label="续航(km)" align="center" prop="rangeKm" />
            <el-table-column label="电池容量" align="center" prop="batteryCapacity" />
            <el-table-column label="快充(h)" align="center" prop="chargeTimeFast" />
            <el-table-column label="慢充(h)" align="center" prop="chargeTimeSlow" />
            <el-table-column label="年份" align="center" prop="modelYear" />
          </el-table>
        </el-tab-pane>
        <el-tab-pane label="金融方案" name="finance">
          <el-table v-loading="financeLoading" :data="detailData.financePlans || []" border>
            <el-table-column label="方案名称" align="center" prop="planName" />
            <el-table-column label="方案类型" align="center" prop="planType" />
            <el-table-column label="总价" align="center" prop="totalPrice" />
            <el-table-column label="首付" align="center" prop="downPayment" />
            <el-table-column label="月供" align="center" prop="monthlyPayment" />
            <el-table-column label="期数" align="center" prop="months" />
            <el-table-column label="利率" align="center" prop="interestRate" />
            <el-table-column label="机构" align="center" prop="provider" />
          </el-table>
        </el-tab-pane>
      </el-tabs>
    </el-dialog>
  </div>
</template>

<script>
import { listVehicle, getVehicle, delVehicle, addVehicle, updateVehicle, getVehicleDetail } from "@/api/business/vehicle"

export default {
  name: "Vehicle",
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      vehicleList: [],
      title: "",
      open: false,
      openDetail: false,
      detailTab: "base",
      detailData: {},
      specLoading: false,
      financeLoading: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        vehicleType: undefined,
        modelName: undefined,
        title: undefined,
        status: undefined
      },
      form: {},
      rules: {
        vehicleType: [
          { required: true, message: "车型不能为空", trigger: "change" }
        ],
        modelName: [
          { required: true, message: "型号名称不能为空", trigger: "blur" }
        ],
        title: [
          { required: true, message: "标题不能为空", trigger: "blur" }
        ],
        status: [
          { required: true, message: "状态不能为空", trigger: "blur" }
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
      listVehicle(this.queryParams).then(response => {
        this.vehicleList = response.rows
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
        vehicleId: undefined,
        vehicleType: "new",
        modelName: undefined,
        title: undefined,
        guidePrice: 0,
        originalPrice: 0,
        color: undefined,
        stock: 0,
        merchantId: undefined,
        description: undefined,
        tags: undefined,
        status: "1",
        rangeKm: undefined,
        batteryCapacity: undefined,
        chargeTimeFast: undefined,
        chargeTimeSlow: undefined,
        modelYear: undefined
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
      this.ids = selection.map(item => item.vehicleId)
      this.single = selection.length != 1
      this.multiple = !selection.length
    },
    handleAdd() {
      this.reset()
      this.open = true
      this.title = "添加车辆"
    },
    handleUpdate(row) {
      this.reset()
      const vehicleId = row.vehicleId || this.ids
      getVehicleDetail(vehicleId).then(response => {
        const data = response.data
        // 合并基础信息
        this.form = {
          vehicleId: data.vehicleId,
          vehicleType: data.vehicleType,
          modelName: data.modelName,
          title: data.title,
          guidePrice: data.guidePrice,
          originalPrice: data.originalPrice,
          color: data.color,
          stock: data.stock,
          merchantId: data.merchantId,
          description: data.description,
          tags: data.tags,
          status: data.status,
          // 合并规格信息
          rangeKm: data.vehicleSpec ? data.vehicleSpec.rangeKm : undefined,
          batteryCapacity: data.vehicleSpec ? data.vehicleSpec.batteryCapacity : undefined,
          chargeTimeFast: data.vehicleSpec ? data.vehicleSpec.chargeTimeFast : undefined,
          chargeTimeSlow: data.vehicleSpec ? data.vehicleSpec.chargeTimeSlow : undefined,
          modelYear: data.vehicleSpec ? data.vehicleSpec.modelYear : undefined
        }
        this.open = true
        this.title = "修改车辆"
      })
    },
    handleDetail(row) {
      this.detailTab = "base"
      this.detailData = {}
      getVehicleDetail(row.vehicleId).then(response => {
        this.detailData = response.data
        this.openDetail = true
        this.title = "车辆详情 - " + response.data.modelName
      })
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.vehicleId != undefined) {
            updateVehicle(this.form).then(() => {
              this.$modal.msgSuccess("修改成功")
              this.open = false
              this.getList()
            })
          } else {
            addVehicle(this.form).then(() => {
              this.$modal.msgSuccess("新增成功")
              this.open = false
              this.getList()
            })
          }
        }
      })
    },
    handleDelete(row) {
      const vehicleIds = row.vehicleId || this.ids
      this.$modal.confirm('是否确认删除车辆编号为"' + vehicleIds + '"的数据项？').then(function() {
        return delVehicle(vehicleIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("删除成功")
      }).catch(() => {})
    }
  }
}
</script>