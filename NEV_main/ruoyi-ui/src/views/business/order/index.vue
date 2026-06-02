<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="订单号" prop="orderNo">
        <el-input
          v-model="queryParams.orderNo"
          placeholder="请输入订单号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="充电桩" prop="pileCode">
        <el-input
          v-model="queryParams.pileCode"
          placeholder="请输入充电桩编号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="订单状态" prop="orderStatus">
        <el-select v-model="queryParams.orderStatus" placeholder="订单状态" clearable>
          <el-option label="充电中" value="充电中" />
          <el-option label="已完成" value="已完成" />
          <el-option label="已取消" value="已取消" />
        </el-select>
      </el-form-item>
      <el-form-item label="支付状态" prop="payStatus">
        <el-select v-model="queryParams.payStatus" placeholder="支付状态" clearable>
          <el-option label="未支付" value="未支付" />
          <el-option label="已支付" value="已支付" />
          <el-option label="已退款" value="已退款" />
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
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['business:order:remove']"
        >删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="orderList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="编号" align="center" prop="orderId" />
      <el-table-column label="订单号" align="center" prop="orderNo" show-overflow-tooltip width="200" />
      <el-table-column label="用户" align="center" prop="nickName" />
      <el-table-column label="充电站" align="center" prop="stationName" show-overflow-tooltip />
      <el-table-column label="充电桩" align="center" prop="pileCode" />
      <el-table-column label="充电度数" align="center" prop="totalEnergy" />
      <el-table-column label="总金额" align="center" prop="totalAmount" />
      <el-table-column label="订单状态" align="center" prop="orderStatus">
        <template slot-scope="scope">
          <el-tag :type="scope.row.orderStatus === '已完成' ? 'success' : scope.row.orderStatus === '充电中' ? 'primary' : 'info'">{{ scope.row.orderStatus }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="支付状态" align="center" prop="payStatus">
        <template slot-scope="scope">
          <el-tag :type="scope.row.payStatus === '已支付' ? 'success' : scope.row.payStatus === '未支付' ? 'danger' : 'warning'">{{ scope.row.payStatus }}</el-tag>
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
            v-hasPermi="['business:order:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['business:order:remove']"
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
        <el-form-item label="订单号" prop="orderNo">
          <el-input v-model="form.orderNo" placeholder="请输入订单号" :disabled="true" />
        </el-form-item>
        <el-row>
          <el-col :span="12">
            <el-form-item label="用户ID" prop="userId">
              <el-input v-model="form.userId" placeholder="用户ID" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="充电站" prop="stationId">
              <el-input v-model="form.stationId" placeholder="充电站ID" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="充电桩" prop="pileCode">
              <el-input v-model="form.pileCode" placeholder="充电桩编号" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="充电时长" prop="duration">
              <el-input-number v-model="form.duration" :min="0" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="开始电量" prop="startSoc">
              <el-input-number v-model="form.startSoc" :precision="1" :min="0" :max="100" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="结束电量" prop="endSoc">
              <el-input-number v-model="form.endSoc" :precision="1" :min="0" :max="100" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="充电度数" prop="totalEnergy">
              <el-input-number v-model="form.totalEnergy" :precision="2" :min="0" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="电费单价" prop="energyPrice">
              <el-input-number v-model="form.energyPrice" :precision="4" :min="0" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="服务费" prop="servicePrice">
              <el-input-number v-model="form.servicePrice" :precision="4" :min="0" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="总金额" prop="totalAmount">
              <el-input-number v-model="form.totalAmount" :precision="2" :min="0" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="订单状态" prop="orderStatus">
              <el-select v-model="form.orderStatus" placeholder="订单状态" style="width: 100%">
                <el-option label="充电中" value="充电中" />
                <el-option label="已完成" value="已完成" />
                <el-option label="已取消" value="已取消" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="支付状态" prop="payStatus">
              <el-select v-model="form.payStatus" placeholder="支付状态" style="width: 100%">
                <el-option label="未支付" value="未支付" />
                <el-option label="已支付" value="已支付" />
                <el-option label="已退款" value="已退款" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="支付方式" prop="paymentMethod">
          <el-input v-model="form.paymentMethod" placeholder="支付方式" />
        </el-form-item>
        <el-form-item label="交易编号" prop="transactionId">
          <el-input v-model="form.transactionId" placeholder="交易编号" />
        </el-form-item>
        <el-row>
          <el-col :span="12">
            <el-form-item label="开始时间" prop="startTime">
              <el-date-picker v-model="form.startTime" type="datetime" placeholder="开始时间" value-format="yyyy-MM-dd HH:mm:ss" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="结束时间" prop="endTime">
              <el-date-picker v-model="form.endTime" type="datetime" placeholder="结束时间" value-format="yyyy-MM-dd HH:mm:ss" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="碳积分" prop="carbonEarned">
          <el-input-number v-model="form.carbonEarned" :min="0" controls-position="right" />
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
import { listOrder, getOrder, delOrder, addOrder, updateOrder } from "@/api/business/order"

export default {
  name: "Order",
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      orderList: [],
      title: "",
      open: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        orderNo: undefined,
        pileCode: undefined,
        orderStatus: undefined,
        payStatus: undefined
      },
      form: {},
      rules: {
        orderNo: [
          { required: true, message: "订单号不能为空", trigger: "blur" }
        ],
        userId: [
          { required: true, message: "用户不能为空", trigger: "blur" }
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
      listOrder(this.queryParams).then(response => {
        this.orderList = response.rows
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
        orderId: undefined,
        orderNo: undefined,
        userId: undefined,
        stationId: undefined,
        pileId: undefined,
        pileCode: undefined,
        startTime: undefined,
        endTime: undefined,
        duration: 0,
        startSoc: undefined,
        endSoc: undefined,
        totalEnergy: undefined,
        energyPrice: undefined,
        servicePrice: undefined,
        totalAmount: undefined,
        orderStatus: "充电中",
        payStatus: "未支付",
        paymentMethod: undefined,
        transactionId: undefined,
        carbonEarned: 0
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
      this.ids = selection.map(item => item.orderId)
      this.single = selection.length != 1
      this.multiple = !selection.length
    },
    handleAdd() {
      this.reset()
      this.open = true
      this.title = "添加订单"
    },
    handleUpdate(row) {
      this.reset()
      const orderId = row.orderId || this.ids
      getOrder(orderId).then(response => {
        this.form = response.data
        this.open = true
        this.title = "修改订单"
      })
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.orderId != undefined) {
            updateOrder(this.form).then(() => {
              this.$modal.msgSuccess("修改成功")
              this.open = false
              this.getList()
            })
          } else {
            addOrder(this.form).then(() => {
              this.$modal.msgSuccess("新增成功")
              this.open = false
              this.getList()
            })
          }
        }
      })
    },
    handleDelete(row) {
      const orderIds = row.orderId || this.ids
      this.$modal.confirm('是否确认删除订单编号为"' + orderIds + '"的数据项？').then(function() {
        return delOrder(orderIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("删除成功")
      }).catch(() => {})
    }
  }
}
</script>