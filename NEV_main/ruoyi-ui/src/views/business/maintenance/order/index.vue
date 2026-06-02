<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="订单号" prop="orderNo">
        <el-input v-model="queryParams.orderNo" placeholder="请输入订单号" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="服务项目" prop="serviceItem">
        <el-input v-model="queryParams.serviceItem" placeholder="请输入服务项目" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="订单状态" prop="orderStatus">
        <el-select v-model="queryParams.orderStatus" placeholder="订单状态" clearable>
          <el-option label="待确认" value="0" />
          <el-option label="已确认" value="1" />
          <el-option label="服务中" value="2" />
          <el-option label="已完成" value="3" />
          <el-option label="已取消" value="4" />
        </el-select>
      </el-form-item>
      <el-form-item label="支付状态" prop="payStatus">
        <el-select v-model="queryParams.payStatus" placeholder="支付状态" clearable>
          <el-option label="未支付" value="0" />
          <el-option label="已支付" value="1" />
          <el-option label="已退款" value="2" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['business:morder:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['business:morder:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['business:morder:remove']">删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="orderList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="编号" align="center" prop="orderId" />
      <el-table-column label="订单号" align="center" prop="orderNo" show-overflow-tooltip width="200" />
      <el-table-column label="用户" align="center" prop="nickName" />
      <el-table-column label="门店" align="center" prop="shopName" show-overflow-tooltip />
      <el-table-column label="服务项目" align="center" prop="serviceItem" />
      <el-table-column label="金额" align="center" prop="totalAmount" />
      <el-table-column label="订单状态" align="center" prop="orderStatus">
        <template slot-scope="scope">
          <el-tag :type="scope.row.orderStatus === '3' ? 'success' : scope.row.orderStatus === '4' ? 'danger' : scope.row.orderStatus === '2' ? 'primary' : 'info'">
            {{ {'0':'待确认','1':'已确认','2':'服务中','3':'已完成','4':'已取消'}[scope.row.orderStatus] || scope.row.orderStatus }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="支付状态" align="center" prop="payStatus">
        <template slot-scope="scope">
          <el-tag :type="scope.row.payStatus === '1' ? 'success' : scope.row.payStatus === '2' ? 'warning' : 'danger'">
            {{ {'0':'未支付','1':'已支付','2':'已退款'}[scope.row.payStatus] || scope.row.payStatus }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="预约日期" align="center" prop="expectDate" width="120" />
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template slot-scope="scope"><span>{{ parseTime(scope.row.createTime) }}</span></template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['business:morder:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['business:morder:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="700px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="订单号" prop="orderNo">
          <el-input v-model="form.orderNo" placeholder="请输入订单号" />
        </el-form-item>
        <el-row>
          <el-col :span="12"><el-form-item label="用户ID" prop="userId"><el-input v-model="form.userId" placeholder="用户ID" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="门店ID" prop="shopId"><el-input v-model="form.shopId" placeholder="门店ID" /></el-form-item></el-col>
        </el-row>
        <el-form-item label="车辆ID" prop="vehicleId">
          <el-input v-model="form.vehicleId" placeholder="车辆ID" />
        </el-form-item>
        <el-form-item label="服务项目" prop="serviceItem">
          <el-input v-model="form.serviceItem" placeholder="请输入服务项目" />
        </el-form-item>
        <el-row>
          <el-col :span="8"><el-form-item label="服务价格" prop="servicePrice"><el-input-number v-model="form.servicePrice" :precision="2" :min="0" style="width:100%" /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="总金额" prop="totalAmount"><el-input-number v-model="form.totalAmount" :precision="2" :min="0" style="width:100%" /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="已付金额" prop="paidAmount"><el-input-number v-model="form.paidAmount" :precision="2" :min="0" style="width:100%" /></el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="12"><el-form-item label="期望日期" prop="expectDate"><el-date-picker v-model="form.expectDate" type="date" placeholder="期望日期" value-format="yyyy-MM-dd" style="width:100%" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="时间段" prop="expectTimeSlot">
            <el-select v-model="form.expectTimeSlot" placeholder="时间段" style="width:100%">
              <el-option label="上午" value="am" />
              <el-option label="下午" value="pm" />
            </el-select>
          </el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="12"><el-form-item label="订单状态" prop="orderStatus">
            <el-select v-model="form.orderStatus" placeholder="订单状态" style="width:100%">
              <el-option label="待确认" value="0" /><el-option label="已确认" value="1" />
              <el-option label="服务中" value="2" /><el-option label="已完成" value="3" /><el-option label="已取消" value="4" />
            </el-select>
          </el-form-item></el-col>
          <el-col :span="12"><el-form-item label="支付状态" prop="payStatus">
            <el-select v-model="form.payStatus" placeholder="支付状态" style="width:100%">
              <el-option label="未支付" value="0" /><el-option label="已支付" value="1" /><el-option label="已退款" value="2" />
            </el-select>
          </el-form-item></el-col>
        </el-row>
        <el-form-item label="支付方式" prop="paymentMethod">
          <el-input v-model="form.paymentMethod" placeholder="支付方式" />
        </el-form-item>
        <el-form-item label="完成时间" prop="finishTime">
          <el-date-picker v-model="form.finishTime" type="datetime" placeholder="完成时间" value-format="yyyy-MM-dd HH:mm:ss" style="width:100%" />
        </el-form-item>
        <el-form-item label="评价内容" prop="commentContent">
          <el-input v-model="form.commentContent" type="textarea" placeholder="评价内容" />
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
import { listMOrder, getMOrder, delMOrder, addMOrder, updateMOrder } from "@/api/business/mOrder"

export default {
  name: "MOrder",
  data() {
    return {
      loading: true, ids: [], single: true, multiple: true, showSearch: true, total: 0,
      orderList: [], title: "", open: false,
      queryParams: { pageNum: 1, pageSize: 10, orderNo: undefined, serviceItem: undefined, orderStatus: undefined, payStatus: undefined },
      form: {},
      rules: {
        orderNo: [{ required: true, message: "订单号不能为空", trigger: "blur" }],
        serviceItem: [{ required: true, message: "服务项目不能为空", trigger: "blur" }]
      }
    }
  },
  created() { this.getList() },
  methods: {
    getList() { this.loading = true; listMOrder(this.queryParams).then(response => { this.orderList = response.rows; this.total = response.total; this.loading = false }) },
    cancel() { this.open = false; this.reset() },
    reset() {
      this.form = { orderId: undefined, orderNo: undefined, userId: undefined, shopId: undefined, vehicleId: undefined, serviceItem: undefined, servicePrice: 0, totalAmount: 0, paidAmount: 0, expectDate: undefined, expectTimeSlot: "am", orderStatus: "0", payStatus: "0", paymentMethod: undefined, finishTime: undefined, cancelReason: undefined, commentContent: undefined }
      this.resetForm("form")
    },
    handleQuery() { this.queryParams.pageNum = 1; this.getList() },
    resetQuery() { this.resetForm("queryForm"); this.handleQuery() },
    handleSelectionChange(selection) { this.ids = selection.map(item => item.orderId); this.single = selection.length != 1; this.multiple = !selection.length },
    handleAdd() { this.reset(); this.open = true; this.title = "添加维保订单" },
    handleUpdate(row) { this.reset(); const orderId = row.orderId || this.ids; getMOrder(orderId).then(response => { this.form = response.data; this.open = true; this.title = "修改维保订单" }) },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.orderId != undefined) { updateMOrder(this.form).then(() => { this.$modal.msgSuccess("修改成功"); this.open = false; this.getList() }) }
          else { addMOrder(this.form).then(() => { this.$modal.msgSuccess("新增成功"); this.open = false; this.getList() }) }
        }
      })
    },
    handleDelete(row) { const orderIds = row.orderId || this.ids; this.$modal.confirm('是否确认删除维保订单编号为"' + orderIds + '"的数据项？').then(function() { return delMOrder(orderIds) }).then(() => { this.getList(); this.$modal.msgSuccess("删除成功") }).catch(() => {}) }
  }
}
</script>