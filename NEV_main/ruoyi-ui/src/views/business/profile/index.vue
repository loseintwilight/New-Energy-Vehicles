<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="用户ID" prop="userId">
        <el-input v-model="queryParams.userId" placeholder="请输入用户ID" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['business:profile:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['business:profile:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['business:profile:remove']">删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="profileList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="用户ID" align="center" prop="userId" />
      <el-table-column label="身份证号" align="center" prop="idCard" show-overflow-tooltip />
      <el-table-column label="总获得积分" align="center" prop="totalEarned" />
      <el-table-column label="总消耗积分" align="center" prop="totalSpent" />
      <el-table-column label="当前余额" align="center" prop="balance" />
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template slot-scope="scope"><span>{{ parseTime(scope.row.createTime) }}</span></template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['business:profile:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['business:profile:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="用户ID" prop="userId">
          <el-input v-model="form.userId" placeholder="请输入用户ID" :disabled="form.userId != undefined" />
        </el-form-item>
        <el-form-item label="身份证号" prop="idCard">
          <el-input v-model="form.idCard" placeholder="请输入身份证号" />
        </el-form-item>
        <el-form-item label="总获得积分" prop="totalEarned">
          <el-input-number v-model="form.totalEarned" :min="0" style="width:100%" />
        </el-form-item>
        <el-form-item label="总消耗积分" prop="totalSpent">
          <el-input-number v-model="form.totalSpent" :min="0" style="width:100%" />
        </el-form-item>
        <el-form-item label="当前余额" prop="balance">
          <el-input-number v-model="form.balance" :min="0" style="width:100%" />
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
import { listProfile, getProfile, delProfile, addProfile, updateProfile } from "@/api/business/profile"

export default {
  name: "Profile",
  data() {
    return {
      loading: true, ids: [], single: true, multiple: true, showSearch: true, total: 0,
      profileList: [], title: "", open: false,
      queryParams: { pageNum: 1, pageSize: 10, userId: undefined },
      form: {},
      rules: {
        userId: [{ required: true, message: "用户ID不能为空", trigger: "blur" }]
      }
    }
  },
  created() { this.getList() },
  methods: {
    getList() { this.loading = true; listProfile(this.queryParams).then(response => { this.profileList = response.rows; this.total = response.total; this.loading = false }) },
    cancel() { this.open = false; this.reset() },
    reset() { this.form = { userId: undefined, idCard: undefined, totalEarned: 0, totalSpent: 0, balance: 0 }; this.resetForm("form") },
    handleQuery() { this.queryParams.pageNum = 1; this.getList() },
    resetQuery() { this.resetForm("queryForm"); this.handleQuery() },
    handleSelectionChange(selection) { this.ids = selection.map(item => item.userId); this.single = selection.length != 1; this.multiple = !selection.length },
    handleAdd() { this.reset(); this.open = true; this.title = "添加用户碳积分" },
    handleUpdate(row) { this.reset(); const userId = row.userId || this.ids; getProfile(userId).then(response => { this.form = response.data; this.open = true; this.title = "修改用户碳积分" }) },
    submitForm() { this.$refs["form"].validate(valid => { if (valid) { if (this.form.userId != undefined) { updateProfile(this.form).then(() => { this.$modal.msgSuccess("修改成功"); this.open = false; this.getList() }) } else { addProfile(this.form).then(() => { this.$modal.msgSuccess("新增成功"); this.open = false; this.getList() }) } } }) },
    handleDelete(row) { const userIds = row.userId || this.ids; this.$modal.confirm('是否确认删除用户碳积分编号为"' + userIds + '"的数据项？').then(function() { return delProfile(userIds) }).then(() => { this.getList(); this.$modal.msgSuccess("删除成功") }).catch(() => {}) }
  }
}
</script>