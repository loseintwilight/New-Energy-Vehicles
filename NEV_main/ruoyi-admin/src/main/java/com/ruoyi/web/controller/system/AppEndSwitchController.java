package com.ruoyi.web.controller.system;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
 * 一个用户可拥有多个身份（按 merchant_type 区分），互不干扰
 */
@RestController
@RequestMapping("/app/user")
public class AppEndSwitchController extends BaseController {

    @Autowired
    private IStadMerchantService stadMerchantService;

    /**
     * 端类型 → merchant_type 映射
     */
    private String toMerchantType(String endType) {
        if (endType == null) return null;
        switch (endType) {
            case "maintenance": return "maintenance";
            case "charging":    return "charger";
            case "business":    return "dealer";
            default:            return null;
        }
    }

    /**
     * merchant_type → 端类型 映射
     */
    private String toEndType(String merchantType) {
        if (merchantType == null) return null;
        switch (merchantType) {
            case "maintenance": return "maintenance";
            case "charger":     return "charging";
            case "dealer":      return "business";
            default:            return null;
        }
    }

    /**
     * 查询当前用户的所有商户身份
     *
     * 返回该用户所有 merchant 记录（每个 merchant_type 一条），含审核状态
     * 前端据此判断"当前端"和"可端切换"
     *
     * @return { identities: [{ merchantType, endType, status, merchantId, merchantName }], hasIdentity, merchantType }
     */
    @GetMapping("/merchant/identity")
    public AjaxResult getMerchantIdentity() {
        Long userId = SecurityUtils.getUserId();
        if (userId == null) {
            return error("未获取到用户信息");
        }

        List<StadMerchant> merchants = stadMerchantService.selectStadMerchantListByUserId(userId);
        List<Map<String, Object>> identityList = new ArrayList<>();
        String approvedType = null;

        for (StadMerchant m : merchants) {
            Map<String, Object> item = new HashMap<>();
            item.put("merchantType", m.getMerchantType());
            item.put("endType", toEndType(m.getMerchantType()));
            item.put("status", m.getStatus());
            item.put("merchantId", m.getMerchantId());
            item.put("merchantName", m.getMerchantName());
            identityList.add(item);

            if ("1".equals(m.getStatus())) {
                approvedType = m.getMerchantType();
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("identities", identityList);
        result.put("hasIdentity", approvedType != null);
        result.put("merchantType", approvedType);

        return success(result);
    }

    /**
     * 提交端切换申请
     * 
     * 按 userId + endType(merchantType) 查找，有则更新、无则新增
     * 不同端类型的申请互不干扰
     *
     * @param params { endType, businessLicense, shopName/stationName/businessName, province, city, address, contactName, contactPhone, ... }
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

        String merchantType = toMerchantType(endType);
        if (merchantType == null) {
            return error("无效的端类型: " + endType);
        }

        // 按 userId + merchantType 查找（各类型独立，互不影响）
        StadMerchant merchant = stadMerchantService.selectStadMerchantByUserIdAndType(userId, merchantType);

        if (merchant == null) {
            merchant = new StadMerchant();
            merchant.setUserId(userId);
            merchant.setMerchantType(merchantType);
            merchant.setCreateBy(SecurityUtils.getUsername());
            merchant.setStatus("0"); // 待审核
        } else {
            merchant.setStatus("0");
            merchant.setAuditRemark(null);
            merchant.setAuditTime(null);
            merchant.setUpdateBy(SecurityUtils.getUsername());
        }

        // 设置商户名称
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

        if (StringUtils.isEmpty(merchant.getMerchantName())) {
            return error("商户名称不能为空");
        }

        // 营业执照 URL
        String businessLicense = (String) params.get("businessLicense");
        if (StringUtils.isEmpty(businessLicense)) {
            return error("营业执照不能为空，请先上传营业执照图片");
        }
        merchant.setBusinessLicense(businessLicense);

        // 联系方式
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

        // 法人
        String legalPerson = (String) params.get("legalPerson");
        if (legalPerson == null) legalPerson = (String) params.get("legal_person");
        if (StringUtils.isEmpty(legalPerson)) {
            legalPerson = merchant.getContactName();
        }
        merchant.setLegalPerson(legalPerson);

        // 法人身份证
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
     * 取消端切换申请（按端类型）
     *
     * @param params { endType }
     */
    @PostMapping("/end-switch/cancel")
    public AjaxResult cancel(@RequestBody Map<String, Object> params) {
        Long userId = SecurityUtils.getUserId();
        if (userId == null) {
            return error("未获取到用户信息");
        }

        String endType = (String) params.get("endType");
        if (StringUtils.isEmpty(endType)) {
            return error("缺少端类型参数");
        }

        String merchantType = toMerchantType(endType);
        if (merchantType == null) {
            return error("无效的端类型: " + endType);
        }

        StadMerchant merchant = stadMerchantService.selectStadMerchantByUserIdAndType(userId, merchantType);
        if (merchant != null && ("0".equals(merchant.getStatus()) || "2".equals(merchant.getStatus()))) {
            stadMerchantService.deleteStadMerchantByIds(new Long[] { merchant.getMerchantId() });
            return success("取消申请成功");
        }

        return success("没有待取消的申请");
    }

    /**
     * 查询端切换申请审核状态（按端类型）
     *
     * @param endType 端类型: maintenance / charging / business
     * @return { auditStatus, createTime, auditRemark }
     */
    @GetMapping("/end-switch/status")
    public AjaxResult getEndSwitchStatus(@RequestParam("endType") String endType) {
        Long userId = SecurityUtils.getUserId();
        if (userId == null) {
            return error("未获取到用户信息");
        }

        String merchantType = toMerchantType(endType);
        if (merchantType == null) {
            return error("无效的端类型: " + endType);
        }

        StadMerchant merchant = stadMerchantService.selectStadMerchantByUserIdAndType(userId, merchantType);
        if (merchant == null) {
            return success(null);
        }

        Map<String, Object> result = new HashMap<>();
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