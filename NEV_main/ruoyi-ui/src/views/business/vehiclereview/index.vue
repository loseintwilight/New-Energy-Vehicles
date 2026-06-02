<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="车辆ID" prop="vehicleId">
        <el-input v-model="queryParams.vehicleId" placeholder="请输入车辆ID" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="评分" prop="rating">
        <el-select v-model="queryParams.rating" placeholder="评分" clearable>
          <el-option label="1分" value="1" />
          <el-option label="2分" value="2" />
          <el-option label="3分" value="3" />
          <el-option label="4分" value="4" />
          <el-option label="5分" value="5" />
        </el-select>
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="审核状态" clearable>
          <el-option label="待审核" value="0" />
          <el-option label="已通过" value="1" />
          <el-option label="已拒绝" value="2" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['business:vehiclereview:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['business:vehiclereview:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['business:vehiclereview:remove']">删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="reviewList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="编号" align="center" prop="reviewId" />
      <el-table-column label="车辆ID" align="center" prop="vehicleId" />
      <el-table-column label="用户ID" align="center" prop="userId" />
      <el-table-column label="评分" align="center" prop="rating">
        <template slot-scope="scope"><el-rate :value="Number(scope.row.rating)" disabled /></template>
      </el-table-column>
      <el-table-column label="评价内容" align="center" prop="content" show-overflow-tooltip />
      <el-table-column label="匿名" align="center" prop="isAnonymous">
        <template slot-scope="scope"><el-tag :type="scope.row.isAnonymous === 1 ? 'info' : 'success'">{{ scope.row.isAnonymous === 1 ? '匿名' : '公开' }}</el-tag></template>
      </el-table-column>
      <el-table-column label="状态" align="center" prop="status">
        <template slot-scope="scope">
          <el-tag :type="scope.row.status === '1' ? 'success' : scope.row.status === '0' ? 'warning' : 'danger'">
            {{ {'0':'待审核','1':'已通过','2':'已拒绝'}[scope.row.status] || scope.row.status }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="评价时间" align="center" prop="createTime" width="180">
        <template slot-scope="scope"><span>{{ parseTime(scope.row.createTime) }}</span></template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['business:vehiclereview:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['business:vehiclereview:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="600px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="车辆ID" prop="vehicleId">
          <el-input v-model="form.vehicleId" placeholder="请输入车辆ID" />
        </el-form-item>
        <el-form-item label="用户ID" prop="userId">
          <el-input v-model="form.userId" placeholder="请输入用户ID" />
        </el-form-item>
        <el-form-item label="评分" prop="rating">
          <el-rate v-model="form.rating" />
        </el-form-item>
        <el-form-item label="评价内容" prop="content">
          <el-input v-model="form.content" type="textarea" :rows="3" placeholder="请输入评价内容" />
        </el-form-item>
        <el-form-item label="图片" prop="imageUrl">
          <el-input v-model="form.imageUrl" placeholder="图片URL" />
        </el-form-item>
        <el-form-item label="是否匿名" prop="isAnonymous">
          <el-radio-group v-model="form.isAnonymous">
            <el-radio :label="0">公开</el-radio>
            <el-radio :label="1">匿名</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="审核状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio label="0">待审核</el-radio>
            <el-radio label="1">已通过</el-radio>
            <el-radio label="2">已拒绝</el-radio>
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
import { listVehicleReview, getVehicleReview, delVehicleReview, addVehicleReview, updateVehicleReview } from "@/api/business/vehiclereview"

export default {
  name: "VehicleReview",
  data() {
    return {
      loading: true, ids: [], single: true, multiple: true, showSearch: true, total: 0,
      reviewList: [], title: "", open: false,
      queryParams: { pageNum: 1, pageSize: 10, vehicleId: undefined, rating: undefined, status: undefined },
      form: {},
      rules: {
        vehicleId: [{ required: true, message: "车辆ID不能为空", trigger: "blur" }],
        userId: [{ required: true, message: "用户ID不能为空", trigger: "blur" }]
      }
    }
  },
  created() { this.getList() },
  methods: {
    getList() { this.loading = true; listVehicleReview(this.queryParams).then(response => { this.reviewList = response.rows; this.total = response.total; this.loading = false }) },
    cancel() { this.open = false; this.reset() },
    reset() { this.form = { vehicleId: undefined, userId: undefined, orderId: undefined, rating: 5, content: undefined, imageUrl: undefined, isAnonymous: 0, status: "0" }; this.resetForm("form") },
    handleQuery() { this.queryParams.pageNum = 1; this.getList() },
    resetQuery() { this.resetForm("queryForm"); this.handleQuery() },
    handleSelectionChange(selection) { this.ids = selection.map(item => item.reviewId); this.single = selection.length != 1; this.multiple = !selection.length },
    handleAdd() { this.reset(); this.open = true; this.title = "添加车辆评价" },
    handleUpdate(row) { this.reset(); const reviewId = row.reviewId || this.ids; getVehicleReview(reviewId).then(response => { this.form = response.data; this.open = true; this.title = "修改车辆评价" }) },
    submitForm() { this.$refs["form"].validate(valid => { if (valid) { if (this.form.reviewId != undefined) { updateVehicleReview(this.form).then(() => { this.$modal.msgSuccess("修改成功"); this.open = false; this.getList() }) } else { addVehicleReview(this.form).then(() => { this.$modal.msgSuccess("新增成功"); this.open = false; this.getList() }) } } }) },
    handleDelete(row) { const reviewIds = row.reviewId || this.ids; this.$modal.confirm('是否确认删除评价编号为"' + reviewIds + '"的数据项？').then(function() { return delVehicleReview(reviewIds) }).then(() => { this.getList(); this.$modal.msgSuccess("删除成功") }).catch(() => {}) }
  }
}
</script>