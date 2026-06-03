<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="方案类型" prop="planType">
        <el-select v-model="queryParams.planType" placeholder="请选择" clearable>
          <el-option label="贷款" value="loan" />
          <el-option label="租赁" value="lease" />
          <el-option label="分期" value="installment" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['business:financeplan:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['business:financeplan:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['business:financeplan:remove']">删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="planList" @selection-change="handleSelectionChange" :default-sort="{prop: 'planId', order: 'ascending'}">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="编号" align="center" prop="planId" />
      <el-table-column label="车辆名称" align="center" prop="vehicleName" show-overflow-tooltip />
      <el-table-column label="方案名称" align="center" prop="planName" show-overflow-tooltip />
      <el-table-column label="方案类型" align="center" prop="planType" />
      <el-table-column label="总价" align="center" prop="totalPrice" />
      <el-table-column label="首付" align="center" prop="downPayment">
        <template slot-scope="scope">{{ scope.row.planName === '全款购车' ? scope.row.totalPrice : scope.row.downPayment }}</template>
      </el-table-column>
      <el-table-column label="月供" align="center" prop="monthlyPayment">
        <template slot-scope="scope">{{ scope.row.planName === '全款购车' ? '0' : scope.row.monthlyPayment }}</template>
      </el-table-column>
      <el-table-column label="期数" align="center" prop="months">
        <template slot-scope="scope">{{ scope.row.planName === '全款购车' ? '1' : scope.row.months }}</template>
      </el-table-column>
      <el-table-column label="利率" align="center" prop="interestRate">
        <template slot-scope="scope">{{ scope.row.interestRate }}%</template>
      </el-table-column>
      <el-table-column label="状态" align="center" prop="isActive">
        <template slot-scope="scope">
          <el-tag :type="scope.row.isActive === 1 ? 'success' : 'info'">{{ scope.row.isActive === 1 ? '启用' : '停用' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['business:financeplan:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['business:financeplan:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="700px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="110px">
        <el-row>
          <el-col :span="12"><el-form-item label="方案名称" prop="planName"><el-input v-model="form.planName" placeholder="方案名称" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="方案类型" prop="planType"><el-select v-model="form.planType" placeholder="请选择" style="width:100%"><el-option label="贷款" value="loan" /><el-option label="租赁" value="lease" /><el-option label="分期" value="installment" /></el-select></el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="8"><el-form-item label="总价(万)" prop="totalPrice"><el-input-number v-model="form.totalPrice" :min="0" :precision="2" style="width:100%" /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="首付(万)" prop="downPayment"><el-input-number v-model="form.downPayment" :min="0" :precision="2" style="width:100%" /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="月供(元)" prop="monthlyPayment"><el-input-number v-model="form.monthlyPayment" :min="0" :precision="2" style="width:100%" /></el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="8"><el-form-item label="期数(月)" prop="months"><el-input-number v-model="form.months" :min="1" style="width:100%" /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="利率(%)" prop="interestRate"><el-input-number v-model="form.interestRate" :min="0" :precision="2" style="width:100%" /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="总利息" prop="totalInterest"><el-input-number v-model="form.totalInterest" :min="0" :precision="2" style="width:100%" /></el-form-item></el-col>
        </el-row>
        <el-form-item label="总应付" prop="totalPayable">
          <el-input-number v-model="form.totalPayable" :min="0" :precision="2" style="width:100%" />
        </el-form-item>
        <el-row>
          <el-col :span="12"><el-form-item label="金融机构" prop="provider"><el-input v-model="form.provider" placeholder="金融机构名称" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="排序" prop="sortOrder"><el-input-number v-model="form.sortOrder" :min="0" style="width:100%" /></el-form-item></el-col>
        </el-row>
        <el-form-item label="状态" prop="isActive">
          <el-radio-group v-model="form.isActive">
            <el-radio :label="0">停用</el-radio>
            <el-radio :label="1">启用</el-radio>
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
import { listFinancePlan, getFinancePlan, delFinancePlan, addFinancePlan, updateFinancePlan } from "@/api/business/financeplan"

export default {
  name: "FinancePlan",
  data() {
    return {
      loading: true, ids: [], single: true, multiple: true, showSearch: true, total: 0,
      planList: [], title: "", open: false,
      queryParams: { pageNum: 1, pageSize: 10, planType: undefined },
      form: {},
      rules: {
        planName: [{ required: true, message: "方案名称不能为空", trigger: "blur" }]
      }
    }
  },
  created() { this.getList() },
  methods: {
    getList() { this.loading = true; listFinancePlan(this.queryParams).then(response => { this.planList = response.rows; this.total = response.total; this.loading = false }) },
    cancel() { this.open = false; this.reset() },
    reset() { this.form = { planName: undefined, planType: "loan", totalPrice: undefined, downPayment: undefined, monthlyPayment: undefined, months: undefined, interestRate: undefined, totalInterest: undefined, totalPayable: undefined, provider: undefined, isActive: 1, sortOrder: 0 }; this.resetForm("form") },
    handleQuery() { this.queryParams.pageNum = 1; this.getList() },
    resetQuery() { this.resetForm("queryForm"); this.handleQuery() },
    handleSelectionChange(selection) { this.ids = selection.map(item => item.planId); this.single = selection.length != 1; this.multiple = !selection.length },
    handleAdd() { this.reset(); this.open = true; this.title = "添加金融方案" },
    handleUpdate(row) { this.reset(); const planId = row.planId || this.ids; getFinancePlan(planId).then(response => { this.form = response.data; this.open = true; this.title = "修改金融方案" }) },
    submitForm() { this.$refs["form"].validate(valid => { if (valid) { if (this.form.planId != undefined) { updateFinancePlan(this.form).then(() => { this.$modal.msgSuccess("修改成功"); this.open = false; this.getList() }) } else { addFinancePlan(this.form).then(() => { this.$modal.msgSuccess("新增成功"); this.open = false; this.getList() }) } } }) },
    handleDelete(row) { const planIds = row.planId || this.ids; this.$modal.confirm('是否确认删除金融方案编号为"' + planIds + '"的数据项？').then(function() { return delFinancePlan(planIds) }).then(() => { this.getList(); this.$modal.msgSuccess("删除成功") }).catch(() => {}) }
  }
}
</script>