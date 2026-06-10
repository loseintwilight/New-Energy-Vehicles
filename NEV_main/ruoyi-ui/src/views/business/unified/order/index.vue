<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="订单号" prop="orderNo">
        <el-input v-model="queryParams.orderNo" placeholder="请输入订单号" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="订单类型" prop="orderType">
        <el-select v-model="queryParams.orderType" placeholder="订单类型" clearable>
          <el-option label="购车" value="purchase" />
          <el-option label="试驾" value="test_drive" />
          <el-option label="以旧换新" value="trade_in" />
        </el-select>
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="订单状态" clearable>
          <el-option label="待付款" value="0" />
          <el-option label="已付款" value="1" />
          <el-option label="已完成" value="2" />
          <el-option label="已取消" value="3" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['business:uorder:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['business:uorder:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['business:uorder:remove']">删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="orderList" @selection-change="handleSelectionChange" :default-sort="{prop: 'createTime', order: 'descending'}">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="编号" align="center" prop="orderId" />
      <el-table-column label="订单号" align="center" prop="orderNo" show-overflow-tooltip width="200" />
      <el-table-column label="类型" align="center" prop="orderType">
        <template slot-scope="scope">
          <el-tag :type="scope.row.orderType === 'purchase' ? 'success' : scope.row.orderType === 'test_drive' ? 'primary' : 'warning'">
            {{ {'purchase':'购车','test_drive':'试驾','trade_in':'以旧换新'}[scope.row.orderType] }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="用户" align="center" prop="nickName" />
      <el-table-column label="车辆价格" align="center" prop="vehiclePrice" />
      <el-table-column label="总金额" align="center" prop="totalAmount" />
      <el-table-column label="已付" align="center" prop="paidAmount" />
      <el-table-column label="联系人" align="center" prop="contactName" />
      <el-table-column label="联系电话" align="center" prop="contactPhone" width="130" />
      <el-table-column label="状态" align="center" prop="status">
        <template slot-scope="scope">
          <el-tag :type="scope.row.status === '2' ? 'success' : scope.row.status === '3' ? 'danger' : scope.row.status === '1' ? 'primary' : 'info'">
            {{ scope.row.orderType === 'test_drive' ? ({'0':'待确认','1':'已确认','2':'已完成','3':'已取消'}[scope.row.status] || '无') : ({'0':'待付款','1':'已付款','2':'已完成','3':'已取消'}[scope.row.status] || '无') }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template slot-scope="scope"><span>{{ parseTime(scope.row.createTime) }}</span></template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['business:uorder:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['business:uorder:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="800px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="订单号" prop="orderNo">
          <el-input v-model="form.orderNo" placeholder="请输入订单号" />
        </el-form-item>
        <el-form-item label="订单类型" prop="orderType">
          <el-select v-model="form.orderType" placeholder="订单类型">
            <el-option label="购车" value="purchase" />
            <el-option label="试驾" value="test_drive" />
            <el-option label="以旧换新" value="trade_in" />
          </el-select>
        </el-form-item>
        <el-row>
          <el-col :span="12"><el-form-item label="用户ID" prop="userId"><el-input v-model="form.userId" placeholder="用户ID" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="车辆ID" prop="vehicleId"><el-input v-model="form.vehicleId" placeholder="车辆ID" /></el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="12"><el-form-item label="商户ID" prop="merchantId"><el-input v-model="form.merchantId" placeholder="商户ID" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="地址ID" prop="addressId"><el-input v-model="form.addressId" placeholder="地址ID" /></el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="12"><el-form-item label="联系人" prop="contactName"><el-input v-model="form.contactName" placeholder="联系人" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="联系电话" prop="contactPhone"><el-input v-model="form.contactPhone" placeholder="联系电话" /></el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="12"><el-form-item label="车辆价格" prop="vehiclePrice"><el-input-number v-model="form.vehiclePrice" :precision="2" :min="0" style="width:100%" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="总金额" prop="totalAmount"><el-input-number v-model="form.totalAmount" :precision="2" :min="0" style="width:100%" /></el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="12"><el-form-item label="已付金额" prop="paidAmount"><el-input-number v-model="form.paidAmount" :precision="2" :min="0" style="width:100%" /></el-form-item></el-col>
        </el-row>
        <el-form-item label="支付方式" prop="paymentMethod">
          <el-input v-model="form.paymentMethod" placeholder="支付方式" />
        </el-form-item>
        <el-form-item label="保险信息" prop="insuranceInfo">
          <el-input v-model="form.insuranceInfo" type="textarea" placeholder="保险信息" />
        </el-form-item>
        <el-row>
          <el-col :span="12"><el-form-item label="期望日期" prop="expectDate"><el-date-picker v-model="form.expectDate" type="date" placeholder="期望日期" value-format="yyyy-MM-dd" style="width:100%" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="时间段" prop="expectTimeSlot">
            <el-select v-model="form.expectTimeSlot" placeholder="时间段" style="width:100%">
              <el-option label="上午" value="am" /><el-option label="下午" value="pm" />
            </el-select>
          </el-form-item></el-col>
        </el-row>
        <el-form-item label="以旧换新">
          <el-row>
            <el-col :span="12"><el-form-item label="旧车ID" prop="oldVehicleId"><el-input v-model="form.oldVehicleId" placeholder="旧车ID" /></el-form-item></el-col>
            <el-col :span="12"><el-form-item label="旧车估价" prop="oldValuation"><el-input-number v-model="form.oldValuation" :precision="2" :min="0" style="width:100%" /></el-form-item></el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="订单状态" prop="status">
          <el-select v-model="form.status" placeholder="订单状态">
            <el-option label="待付款" value="0" /><el-option label="已付款" value="1" />
            <el-option label="已完成" value="2" /><el-option label="已取消" value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="取消原因" prop="cancelReason">
          <el-input v-model="form.cancelReason" type="textarea" placeholder="取消原因" />
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
import { listUnifiedOrder, getUnifiedOrder, delUnifiedOrder, addUnifiedOrder, updateUnifiedOrder } from "@/api/business/unifiedOrder"

export default {
  name: "UnifiedOrder",
  data() {
    return {
      loading: true, ids: [], single: true, multiple: true, showSearch: true, total: 0,
      orderList: [], title: "", open: false,
      queryParams: { pageNum: 1, pageSize: 10, orderNo: undefined, orderType: undefined, status: undefined },
      form: {},
      rules: {
        orderNo: [{ required: true, message: "订单号不能为空", trigger: "blur" }],
        orderType: [{ required: true, message: "订单类型不能为空", trigger: "change" }]
      }
    }
  },
  created() { this.getList() },
  methods: {
    getList() { this.loading = true; listUnifiedOrder(this.queryParams).then(response => { this.orderList = response.rows; this.total = response.total; this.loading = false }) },
    cancel() { this.open = false; this.reset() },
    reset() {
      this.form = { orderId: undefined, orderNo: undefined, orderType: "purchase", userId: undefined, vehicleId: undefined, merchantId: undefined, contactName: undefined, contactPhone: undefined, addressId: undefined, vehiclePrice: 0, totalAmount: 0, paidAmount: 0, paymentMethod: undefined, insuranceInfo: undefined, expectDate: undefined, expectTimeSlot: "am", oldVehicleId: undefined, oldValuation: undefined, status: "0", cancelReason: undefined }
      this.resetForm("form")
    },
    handleQuery() { this.queryParams.pageNum = 1; this.getList() },
    resetQuery() { this.resetForm("queryForm"); this.handleQuery() },
    handleSelectionChange(selection) { this.ids = selection.map(item => item.orderId); this.single = selection.length != 1; this.multiple = !selection.length },
    handleAdd() { this.reset(); this.open = true; this.title = "添加购车订单" },
    handleUpdate(row) { this.reset(); const orderId = row.orderId || this.ids; getUnifiedOrder(orderId).then(response => { this.form = response.data; this.open = true; this.title = "修改购车订单" }) },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.orderId != undefined) { updateUnifiedOrder(this.form).then(() => { this.$modal.msgSuccess("修改成功"); this.open = false; this.getList() }) }
          else { addUnifiedOrder(this.form).then(() => { this.$modal.msgSuccess("新增成功"); this.open = false; this.getList() }) }
        }
      })
    },
    handleDelete(row) { const orderIds = row.orderId || this.ids; this.$modal.confirm('是否确认删除订单编号为"' + orderIds + '"的数据项？').then(function() { return delUnifiedOrder(orderIds) }).then(() => { this.getList(); this.$modal.msgSuccess("删除成功") }).catch(() => {}) }
  }
}
</script>