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
      <el-form-item label="商户类型" prop="merchantType">
        <el-select v-model="queryParams.merchantType" placeholder="商户类型" clearable>
          <el-option label="个人" value="个人" />
          <el-option label="企业" value="企业" />
        </el-select>
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="审核状态" clearable>
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
        <el-tag type="warning" size="medium">{{ pendingCount }} 个待审核</el-tag>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="merchantList" @selection-change="handleSelectionChange" :default-sort="{prop: 'createTime', order: 'descending'}">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="编号" align="center" prop="merchantId" width="80" />
      <el-table-column label="商户名称" align="center" prop="merchantName" show-overflow-tooltip />
      <el-table-column label="商户类型" align="center" prop="merchantType" width="100">
        <template slot-scope="scope">
          <el-tag :type="scope.row.merchantType === '企业' ? 'primary' : 'success'" size="small">{{ scope.row.merchantType }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="联系人" align="center" prop="contactName" width="100" />
      <el-table-column label="联系电话" align="center" prop="contactPhone" width="130" />
      <el-table-column label="所在城市" align="center" prop="city" width="100" />
      <el-table-column label="营业执照" align="center" prop="businessLicense" width="100">
        <template slot-scope="scope">
          <el-image
            v-if="scope.row.businessLicense"
            :src="scope.row.businessLicense"
            fit="contain"
            style="width: 60px; height: 60px; cursor: pointer; border-radius: 4px;"
            :preview-src-list="[scope.row.businessLicense]"
            preview-teleported
          >
            <div slot="error" style="display:flex;align-items:center;justify-content:center;width:60px;height:60px;background:#f5f7fa;font-size:12px;color:#999;border-radius:4px;">无</div>
          </el-image>
        </template>
      </el-table-column>
      <el-table-column label="法人代表" align="center" prop="legalPerson" width="100" />
      <el-table-column label="状态" align="center" prop="status" width="90">
          <template slot-scope="scope">
            <el-tag :type="scope.row.status === '1' ? 'success' : scope.row.status === '0' ? 'warning' : 'danger'" size="small">
              {{ {'0':'待审核','1':'已入驻','2':'已驳回'}[scope.row.status] || scope.row.status }}
            </el-tag>
          </template>
        </el-table-column>
      <el-table-column label="提交时间" align="center" prop="createTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="280">
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
        <el-descriptions-item label="营业执照" :span="2">
          <el-image
            v-if="detailForm.businessLicense"
            :src="detailForm.businessLicense"
            fit="contain"
            style="max-width: 300px; max-height: 200px; cursor: pointer; border-radius: 4px; border: 1px solid #ebeef5;"
            :preview-src-list="[detailForm.businessLicense]"
            preview-teleported
          >
            <div slot="error" style="color:#999;">图片加载失败</div>
          </el-image>
          <span v-else>-</span>
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
import { listMerchant, getMerchant, auditMerchant } from "@/api/business/merchant"

export default {
  name: "MerchantAudit",
  data() {
    return {
      loading: true,
      showSearch: true,
      total: 0,
      pendingCount: 0,
      merchantList: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        merchantName: undefined,
        merchantType: undefined,
        status: undefined
      },
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
      auditRules: {}
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
        this.pendingCount = response.rows.filter(r => r.status === '0').length
        this.loading = false
      })
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
    },
    handleDetail(row) {
      getMerchant(row.merchantId).then(response => {
        this.detailForm = response.data
        this.detailOpen = true
      })
    },
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
    submitAudit() {
      auditMerchant(this.auditForm.merchantId, {
        status: this.auditForm.status,
        auditRemark: this.auditForm.auditRemark
      }).then(() => {
        this.$modal.msgSuccess("审核完成")
        this.auditOpen = false
        this.getList()
      })
    }
  }
}
</script>