<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="用户ID" prop="userId">
        <el-input v-model="queryParams.userId" placeholder="请输入用户ID" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="收藏类型" prop="targetType">
        <el-select v-model="queryParams.targetType" placeholder="请选择" clearable>
          <el-option label="车辆" value="vehicle" />
          <el-option label="充电站" value="station" />
          <el-option label="文章" value="article" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['business:favorite:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['business:favorite:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['business:favorite:remove']">删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="favoriteList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="编号" align="center" prop="favoriteId" />
      <el-table-column label="用户ID" align="center" prop="userId" />
      <el-table-column label="收藏类型" align="center" prop="targetType" />
      <el-table-column label="收藏对象ID" align="center" prop="targetId" />
      <el-table-column label="收藏时间" align="center" prop="createTime" width="180">
        <template slot-scope="scope"><span>{{ parseTime(scope.row.createTime) }}</span></template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['business:favorite:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['business:favorite:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="用户ID" prop="userId">
          <el-input v-model="form.userId" placeholder="请输入用户ID" />
        </el-form-item>
        <el-form-item label="收藏类型" prop="targetType">
          <el-select v-model="form.targetType" placeholder="请选择" style="width:100%">
            <el-option label="车辆" value="vehicle" />
            <el-option label="充电站" value="station" />
            <el-option label="文章" value="article" />
          </el-select>
        </el-form-item>
        <el-form-item label="收藏对象ID" prop="targetId">
          <el-input v-model="form.targetId" placeholder="请输入收藏对象ID" />
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
import { listFavorite, getFavorite, delFavorite, addFavorite, updateFavorite } from "@/api/business/favorite"

export default {
  name: "Favorite",
  data() {
    return {
      loading: true, ids: [], single: true, multiple: true, showSearch: true, total: 0,
      favoriteList: [], title: "", open: false,
      queryParams: { pageNum: 1, pageSize: 10, userId: undefined, targetType: undefined },
      form: {},
      rules: {
        userId: [{ required: true, message: "用户ID不能为空", trigger: "blur" }]
      }
    }
  },
  created() { this.getList() },
  methods: {
    getList() { this.loading = true; listFavorite(this.queryParams).then(response => { this.favoriteList = response.rows; this.total = response.total; this.loading = false }) },
    cancel() { this.open = false; this.reset() },
    reset() { this.form = { favoriteId: undefined, userId: undefined, targetType: undefined, targetId: undefined }; this.resetForm("form") },
    handleQuery() { this.queryParams.pageNum = 1; this.getList() },
    resetQuery() { this.resetForm("queryForm"); this.handleQuery() },
    handleSelectionChange(selection) { this.ids = selection.map(item => item.favoriteId); this.single = selection.length != 1; this.multiple = !selection.length },
    handleAdd() { this.reset(); this.open = true; this.title = "添加收藏" },
    handleUpdate(row) { this.reset(); const favoriteId = row.favoriteId || this.ids; getFavorite(favoriteId).then(response => { this.form = response.data; this.open = true; this.title = "修改收藏" }) },
    submitForm() { this.$refs["form"].validate(valid => { if (valid) { if (this.form.favoriteId != undefined) { updateFavorite(this.form).then(() => { this.$modal.msgSuccess("修改成功"); this.open = false; this.getList() }) } else { addFavorite(this.form).then(() => { this.$modal.msgSuccess("新增成功"); this.open = false; this.getList() }) } } }) },
    handleDelete(row) { const favoriteIds = row.favoriteId || this.ids; this.$modal.confirm('是否确认删除收藏编号为"' + favoriteIds + '"的数据项？').then(function() { return delFavorite(favoriteIds) }).then(() => { this.getList(); this.$modal.msgSuccess("删除成功") }).catch(() => {}) }
  }
}
</script>