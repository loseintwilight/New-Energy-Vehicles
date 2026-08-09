<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="商户名称" prop="merchantName">
        <el-input
          v-model="queryParams.merchantName"
          placeholder="请输入商户名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="联系人" prop="contactName">
        <el-input
          v-model="queryParams.contactName"
          placeholder="请输入联系人"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="联系电话" prop="contactPhone">
        <el-input
          v-model="queryParams.contactPhone"
          placeholder="请输入联系电话"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="商户状态" clearable>
          <el-option label="待审核" value="0" />
          <el-option label="已入驻" value="1" />
          <el-option label="已驳回" value="2" />
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
          v-hasPermi="['business:merchant:add']"
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
          v-hasPermi="['business:merchant:edit']"
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
          v-hasPermi="['business:merchant:remove']"
        >删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="merchantList" @selection-change="handleSelectionChange" :default-sort="{prop: 'createTime', order: 'descending'}">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="编号" align="center" prop="merchantId" />
      <el-table-column label="商户名称" align="center" prop="merchantName" show-overflow-tooltip />
      <el-table-column label="商户类型" align="center" prop="merchantType" />
      <el-table-column label="联系人" align="center" prop="contactName" />
      <el-table-column label="联系电话" align="center" prop="contactPhone" width="130" />
      <el-table-column label="所在城市" align="center" prop="city" />
      <el-table-column label="营业时间" align="center" prop="openTime" width="100" />
      <el-table-column label="结束时间" align="center" prop="closeTime" width="100" />
      <el-table-column label="状态" align="center" prop="status">
          <template slot-scope="scope">
            <el-tag :type="scope.row.status === '1' ? 'success' : scope.row.status === '0' ? 'warning' : 'danger'">
              {{ {'0':'待审核','1':'已入驻','2':'已驳回'}[scope.row.status] || scope.row.status }}
            </el-tag>
          </template>
        </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="320">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-view"
            @click="handleDetail(scope.row)"
          >详情</el-button>
          <el-button
            v-if="scope.row.status === '0'"
            size="mini"
            type="text"
            icon="el-icon-circle-check"
            style="color: #67c23a"
            @click="handleApprove(scope.row)"
          >通过</el-button>
          <el-button
            v-if="scope.row.status === '0'"
            size="mini"
            type="text"
            icon="el-icon-circle-close"
            style="color: #f56c6c"
            @click="handleReject(scope.row)"
          >拒绝</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['business:merchant:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['business:merchant:remove']"
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
        <el-form-item label="商户名称" prop="merchantName">
          <el-input v-model="form.merchantName" placeholder="请输入商户名称" />
        </el-form-item>
        <el-form-item label="商户类型" prop="merchantType">
          <el-select v-model="form.merchantType" placeholder="请选择商户类型">
            <el-option label="个人" value="个人" />
            <el-option label="企业" value="企业" />
          </el-select>
        </el-form-item>
        <el-row>
          <el-col :span="12">
            <el-form-item label="联系人" prop="contactName">
              <el-input v-model="form.contactName" placeholder="请输入联系人" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="联系电话" prop="contactPhone">
              <el-input v-model="form.contactPhone" placeholder="请输入联系电话" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="省份" prop="province">
              <el-input v-model="form.province" placeholder="请输入省份" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="城市" prop="city">
              <el-input v-model="form.city" placeholder="请输入城市" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="详细地址" prop="address">
          <el-input v-model="form.address" placeholder="请输入详细地址" />
        </el-form-item>
        <el-row>
          <el-col :span="12">
            <el-form-item label="营业时间" prop="openTime">
              <el-time-picker v-model="form.openTime" placeholder="营业开始" format="HH:mm" value-format="HH:mm:ss" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="结束时间" prop="closeTime">
              <el-time-picker v-model="form.closeTime" placeholder="营业结束" format="HH:mm" value-format="HH:mm:ss" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="营业执照" prop="businessLicense">
              <el-input v-model="form.businessLicense" placeholder="请输入营业执照号" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="法人代表" prop="legalPerson">
              <el-input v-model="form.legalPerson" placeholder="请输入法人代表" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="身份证号" prop="idCard">
          <el-input v-model="form.idCard" placeholder="请输入身份证号" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio label="0">待审核</el-radio>
            <el-radio label="1">已入驻</el-radio>
            <el-radio label="2">已驳回</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-row>
          <el-col :span="12">
            <el-form-item label="开户银行" prop="bankName">
              <el-input v-model="form.bankName" placeholder="请输入开户银行" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="银行账号" prop="bankAccount">
              <el-input v-model="form.bankAccount" placeholder="请输入银行账号" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 商户详情对话框 -->
    <el-dialog title="商户详情" :visible.sync="detailOpen" width="750px" append-to-body>
      <el-descriptions :column="2" border size="medium" v-if="detailForm.merchantId">
        <el-descriptions-item label="商户名称">{{ detailForm.merchantName }}</el-descriptions-item>
        <el-descriptions-item label="商户类型">
          <el-tag :type="detailForm.merchantType === '企业' ? 'primary' : 'success'" size="small">{{ detailForm.merchantType }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="联系人">{{ detailForm.contactName }}</el-descriptions-item>
        <el-descriptions-item label="联系电话">{{ detailForm.contactPhone }}</el-descriptions-item>
        <el-descriptions-item label="所在省份">{{ detailForm.province }}</el-descriptions-item>
        <el-descriptions-item label="所在城市">{{ detailForm.city }}</el-descriptions-item>
        <el-descriptions-item label="详细地址" :span="2">{{ detailForm.address }}</el-descriptions-item>
        <el-descriptions-item label="营业执照">
          <img v-if="detailForm.businessLicense" :src="detailForm.businessLicense" style="max-width:200px;max-height:120px;border-radius:4px;cursor:pointer" @click="previewImg(detailForm.businessLicense)" />
          <span v-else>{{ detailForm.businessLicense || '-' }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="法人代表">{{ detailForm.legalPerson }}</el-descriptions-item>
        <el-descriptions-item label="身份证号">{{ detailForm.idCard }}</el-descriptions-item>
        <el-descriptions-item label="开户银行">{{ detailForm.bankName }}</el-descriptions-item>
        <el-descriptions-item label="银行账号">{{ detailForm.bankAccount }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="detailForm.status === '1' ? 'success' : detailForm.status === '0' ? 'warning' : 'danger'" size="small">
            {{ {'0':'待审核','1':'已入驻','2':'已驳回'}[detailForm.status] || detailForm.status }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="审核备注" :span="2">{{ detailForm.auditRemark || '-' }}</el-descriptions-item>
        <el-descriptions-item label="审核时间">{{ detailForm.auditTime ? parseTime(detailForm.auditTime) : '-' }}</el-descriptions-item>
        <el-descriptions-item label="提交时间">{{ parseTime(detailForm.createTime) }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer" v-if="detailForm.status === '0'">
        <el-button type="success" @click="handleApproveFromDetail">通 过</el-button>
        <el-button type="danger" @click="handleRejectFromDetail">拒 绝</el-button>
      </div>
    </el-dialog>

    <!-- 审核对话框 -->
    <el-dialog :title="auditTitle" :visible.sync="auditOpen" width="500px" append-to-body>
      <el-form ref="auditForm" :model="auditForm" :rules="auditRules" label-width="100px">
        <el-form-item label="商户名称">
          <el-input v-model="auditForm.merchantName" disabled />
        </el-form-item>
        <el-form-item label="审核结果">
          <el-tag :type="auditForm.status === '1' ? 'success' : 'danger'" size="medium">
            {{ {'0':'待审核','1':'已入驻','2':'已驳回'}[auditForm.status] || auditForm.status }}
          </el-tag>
        </el-form-item>
        <el-form-item label="审核备注" prop="auditRemark">
          <el-input
            v-model="auditForm.auditRemark"
            type="textarea"
            :rows="3"
            placeholder="请输入审核备注"
          />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitAudit">确 定</el-button>
        <el-button @click="auditOpen = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listMerchant, getMerchant, delMerchant, addMerchant, updateMerchant, auditMerchant } from "@/api/business/merchant"

export default {
  name: "Merchant",
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      merchantList: [],
      title: "",
      open: false,
      detailOpen: false,
      detailForm: {},
      auditOpen: false,
      auditTitle: "",
      auditForm: {
        merchantId: undefined,
        merchantName: "",
        status: "",
        auditRemark: ""
      },
      auditRules: {},
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        merchantName: undefined,
        contactName: undefined,
        contactPhone: undefined,
        status: undefined
      },
      form: {},
      rules: {
        merchantName: [
          { required: true, message: "商户名称不能为空", trigger: "blur" }
        ],
        contactName: [
          { required: true, message: "联系人不能为空", trigger: "blur" }
        ],
        contactPhone: [
          { required: true, message: "联系电话不能为空", trigger: "blur" }
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
      listMerchant(this.queryParams).then(response => {
        this.merchantList = response.rows
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
        merchantId: undefined,
        merchantName: undefined,
        merchantType: "个人",
        contactName: undefined,
        contactPhone: undefined,
        province: undefined,
        city: undefined,
        address: undefined,
        openTime: undefined,
        closeTime: undefined,
        businessLicense: undefined,
        legalPerson: undefined,
        idCard: undefined,
        status: "0",
        bankName: undefined,
        bankAccount: undefined
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
      this.ids = selection.map(item => item.merchantId)
      this.single = selection.length != 1
      this.multiple = !selection.length
    },
    handleAdd() {
      this.reset()
      this.open = true
      this.title = "添加商户"
    },
    handleUpdate(row) {
      this.reset()
      const merchantId = row.merchantId || this.ids
      getMerchant(merchantId).then(response => {
        this.form = response.data
        this.open = true
        this.title = "修改商户"
      })
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.merchantId != undefined) {
            updateMerchant(this.form).then(() => {
              this.$modal.msgSuccess("修改成功")
              this.open = false
              this.getList()
            })
          } else {
            addMerchant(this.form).then(() => {
              this.$modal.msgSuccess("新增成功")
              this.open = false
              this.getList()
            })
          }
        }
      })
    },
    // 查看详情
    handleDetail(row) {
      getMerchant(row.merchantId).then(response => {
        this.detailForm = response.data
        this.detailOpen = true
      })
    },
    // 审核通过
    handleApprove(row) {
      this.auditForm = {
        merchantId: row.merchantId,
        merchantName: row.merchantName,
        status: "1",
        auditRemark: ""
      }
      this.auditTitle = "审核通过"
      this.auditOpen = true
    },
    // 审核拒绝
    handleReject(row) {
      this.auditForm = {
        merchantId: row.merchantId,
        merchantName: row.merchantName,
        status: "2",
        auditRemark: ""
      }
      this.auditTitle = "审核拒绝"
      this.auditOpen = true
    },
    // 从详情弹窗中审核通过
    handleApproveFromDetail() {
      this.detailOpen = false
      this.auditForm = {
        merchantId: this.detailForm.merchantId,
        merchantName: this.detailForm.merchantName,
        status: "1",
        auditRemark: ""
      }
      this.auditTitle = "审核通过"
      this.auditOpen = true
    },
    // 从详情弹窗中审核拒绝
    handleRejectFromDetail() {
      this.detailOpen = false
      this.auditForm = {
        merchantId: this.detailForm.merchantId,
        merchantName: this.detailForm.merchantName,
        status: "2",
        auditRemark: ""
      }
      this.auditTitle = "审核拒绝"
      this.auditOpen = true
    },
    // 提交审核
    submitAudit() {
      auditMerchant(this.auditForm.merchantId, {
        status: this.auditForm.status,
        auditRemark: this.auditForm.auditRemark
      }).then(() => {
        this.$modal.msgSuccess("审核完成")
        this.auditOpen = false
        this.getList()
      })
    },
    // 预览图片
    previewImg(url) {
      window.open(url, '_blank')
    },
    handleDelete(row) {
      const merchantIds = row.merchantId || this.ids
      this.$modal.confirm('是否确认删除商户编号为"' + merchantIds + '"的数据项？').then(function() {
        return delMerchant(merchantIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("删除成功")
      }).catch(() => {})
    }
  }
}
</script>