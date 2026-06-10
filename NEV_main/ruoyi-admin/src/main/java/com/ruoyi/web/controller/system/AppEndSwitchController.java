package com.ruoyi.web.controller.system;

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
            if (merchantName == null) merchantName = (String) params.get("shop_name");
        } else if ("charging".equals(endType)) {
            merchantName = (String) params.get("stationName");
            if (merchantName == null) merchantName = (String) params.get("station_name");
        } else if ("business".equals(endType)) {
            merchantName = (String) params.get("businessName");
            if (merchantName == null) merchantName = (String) params.get("business_name");
        }
        merchant.setMerchantName(merchantName);

        // ----- 校验所有必填字段（对照数据库 stad_merchant NOT NULL 列） -----

        if (StringUtils.isEmpty(merchant.getMerchantName())) {
            System.err.println("=== AppEndSwitchController.apply() 收到的参数: " + params);
            return error("商户名称不能为空");
        }

        // 营业执照 URL（必填）
        String businessLicense = (String) params.get("businessLicense");
        if (StringUtils.isEmpty(businessLicense)) {
            return error("营业执照不能为空，请先上传营业执照图片");
        }
        merchant.setBusinessLicense(businessLicense);

        // 联系方式（兼容 snake_case 和 camelCase）
        String contactName = (String) params.get("contactName");
        if (contactName == null) contactName = (String) params.get("contact_name");
        merchant.setContactName(contactName);
        if (StringUtils.isEmpty(merchant.getContactName())) {
            return error("联系人不能为空");
        }

        String contactPhone = (String) params.get("contactPhone");
        if (contactPhone == null) contactPhone = (String) params.get("contact_phone");
        merchant.setContactPhone(contactPhone);
        if (StringUtils.isEmpty(merchant.getContactPhone())) {
            return error("联系电话不能为空");
        }

        // 地址
        String province = (String) params.get("province");
        String city = (String) params.get("city");
        String address = (String) params.get("address");
        merchant.setProvince(province);
        merchant.setCity(city);
        merchant.setAddress(address);
        if (StringUtils.isEmpty(province) || StringUtils.isEmpty(city) || StringUtils.isEmpty(address)) {
            return error("省市区/地址不能为空");
        }

        // ----- 商户表额外必填字段 -----
        // 法人：表单没有单独传时，复用联系人名称
        String legalPerson = (String) params.get("legalPerson");
        if (legalPerson == null) legalPerson = (String) params.get("legal_person");
        if (StringUtils.isEmpty(legalPerson)) {
            legalPerson = merchant.getContactName();
        }
        merchant.setLegalPerson(legalPerson);

        // 法人身份证：表单没有传时，设为临时占位（PC管理端审核时可要求补充）
        String idCard = (String) params.get("idCard");
        if (idCard == null) idCard = (String) params.get("id_card");
        if (StringUtils.isEmpty(idCard)) {
            idCard = "待补充";
        }
        merchant.setIdCard(idCard);

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