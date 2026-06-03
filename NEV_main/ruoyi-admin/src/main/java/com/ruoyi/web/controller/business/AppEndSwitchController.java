package com.ruoyi.web.controller.business;

import java.util.HashMap;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.business.domain.StadMerchant;
import com.ruoyi.business.service.IStadMerchantService;

/**
 * 小程序端 - 端切换 & 商户身份接口
 * 
 * 查询 stad_merchant 表判断用户身份/提交审核/取消申请
 */
@RestController
@RequestMapping("/app/user")
public class AppEndSwitchController extends BaseController {

    @Autowired
    private IStadMerchantService stadMerchantService;

    /**
     * 查询当前用户的维保商户身份
     * 
     * 后端查 stad_merchant 表：
     *   SELECT * FROM stad_merchant
     *   WHERE user_id = ? AND merchant_type = 'maintenance' AND status = '1'
     * 
     * @return { data: true/false }
     */
    @GetMapping("/merchant/identity")
    public AjaxResult getMerchantIdentity() {
        Long userId = SecurityUtils.getUserId();
        if (userId == null) {
            return error("未获取到用户信息");
        }

        // 查用户是否有已上线的维保商户身份
        StadMerchant merchant = stadMerchantService.selectStadMerchantByUserId(userId);
        boolean hasMaintenanceIdentity = merchant != null
                && "maintenance".equals(merchant.getMerchantType())
                && "1".equals(merchant.getStatus());

        return success(hasMaintenanceIdentity);
    }

    /**
     * 提交端切换申请
     * 
     * 将表单数据保存到 stad_merchant 表，status 设为 '0'（待审核）
     * 如果用户已有商户记录则更新，否则新增
     * PC 管理端通过现有审核流程处理
     *
     * @param params 表单数据 { endType, shopName/stationName/businessName, province, city, address, contactName, contactPhone }
     */
    @PostMapping("/end-switch/apply")
    public AjaxResult apply(@RequestBody Map<String, Object> params) {
        Long userId = SecurityUtils.getUserId();
        if (userId == null) {
            return error("未获取到用户信息");
        }

        String endType = (String) params.get("endType");
        if (StringUtils.isEmpty(endType)) {
            return error("请选择要切换的端");
        }

        // endType → merchant_type 映射
        String merchantType;
        switch (endType) {
            case "maintenance":
                merchantType = "maintenance";
                break;
            case "charging":
                merchantType = "charger";
                break;
            case "business":
                merchantType = "dealer";
                break;
            default:
                return error("无效的端类型: " + endType);
        }

        // 查找用户已有商户记录
        StadMerchant merchant = stadMerchantService.selectStadMerchantByUserId(userId);

        if (merchant == null) {
            // 新增商户记录
            merchant = new StadMerchant();
            merchant.setUserId(userId);
            merchant.setCreateBy(SecurityUtils.getUsername());
            merchant.setStatus("0"); // 待审核
        } else {
            // 更新已有记录，重新设为待审核
            merchant.setStatus("0");
            merchant.setUpdateBy(SecurityUtils.getUsername());
            merchant.setAuditRemark(null);
            merchant.setAuditTime(null);
        }

        // 设置商户类型
        merchant.setMerchantType(merchantType);

        // 设置商户名称：维保→shopName, 充电→stationName, 商家→businessName
        String merchantName = null;
        if ("maintenance".equals(endType)) {
            merchantName = (String) params.get("shopName");
        } else if ("charging".equals(endType)) {
            merchantName = (String) params.get("stationName");
        } else if ("business".equals(endType)) {
            merchantName = (String) params.get("businessName");
        }
        merchant.setMerchantName(merchantName);

        // 设置联系方式
        merchant.setContactName((String) params.get("contactName"));
        merchant.setContactPhone((String) params.get("contactPhone"));
        merchant.setProvince((String) params.get("province"));
        merchant.setCity((String) params.get("city"));
        merchant.setAddress((String) params.get("address"));

        if (merchant.getMerchantId() == null) {
            stadMerchantService.insertStadMerchant(merchant);
        } else {
            stadMerchantService.updateStadMerchant(merchant);
        }

        return success("提交成功，等待管理员审核");
    }

    /**
     * 取消端切换申请
     * 
     * 删除用户状态为"待审核"的商户申请记录
     */
    @PostMapping("/end-switch/cancel")
    public AjaxResult cancel() {
        Long userId = SecurityUtils.getUserId();
        if (userId == null) {
            return error("未获取到用户信息");
        }

        StadMerchant merchant = stadMerchantService.selectStadMerchantByUserId(userId);
        if (merchant != null && "0".equals(merchant.getStatus())) {
            stadMerchantService.deleteStadMerchantByIds(new Long[] { merchant.getMerchantId() });
            return success("取消申请成功");
        }

        return success("没有待取消的申请");
    }

    /**
     * 查询端切换申请审核状态
     * 
     * @return { auditStatus: "pending"/"approved"/"rejected", createTime, auditRemark }
     */
    @GetMapping("/end-switch/status")
    public AjaxResult getEndSwitchStatus() {
        Long userId = SecurityUtils.getUserId();
        if (userId == null) {
            return error("未获取到用户信息");
        }

        StadMerchant merchant = stadMerchantService.selectStadMerchantByUserId(userId);
        if (merchant == null) {
            return success(null);
        }

        Map<String, Object> result = new HashMap<>();
        // 状态映射：0→pending, 1→approved, 2→rejected
        String auditStatus;
        switch (merchant.getStatus()) {
            case "0":
                auditStatus = "pending";
                break;
            case "1":
                auditStatus = "approved";
                break;
            case "2":
                auditStatus = "rejected";
                break;
            default:
                auditStatus = "pending";
        }
        result.put("auditStatus", auditStatus);
        result.put("createTime", merchant.getCreateTime());
        result.put("auditRemark", merchant.getAuditRemark());

        return success(result);
    }
}