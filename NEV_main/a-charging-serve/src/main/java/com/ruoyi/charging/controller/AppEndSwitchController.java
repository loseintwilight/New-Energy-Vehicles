package com.ruoyi.charging.controller;

import com.ruoyi.charging.domain.AppMerchant;
import com.ruoyi.charging.domain.EndSwitchApply;
import com.ruoyi.charging.service.IAppMerchantService;
import com.ruoyi.charging.service.IEndSwitchApplyService;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * App端-端切换Controller
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/app/user")
public class AppEndSwitchController extends BaseController
{
    @Autowired
    private IAppMerchantService appMerchantService;

    @Autowired
    private IEndSwitchApplyService endSwitchApplyService;

    /**
     * 查询当前用户的商户身份
     */
    @GetMapping("/merchant/identity")
    public AjaxResult getMerchantIdentity()
    {
        LoginUser loginUser = getLoginUser();
        Long userId = loginUser.getUserId();

        AppMerchant merchant = appMerchantService.selectAppMerchantByUserId(userId);
        if (merchant == null)
        {
            return AjaxResult.success(null);
        }
        return AjaxResult.success(merchant);
    }

    /**
     * 提交端切换申请
     */
    @PostMapping("/end-switch/apply")
    public AjaxResult submitEndSwitchApply(@RequestBody Map<String, Object> params)
    {
        LoginUser loginUser = getLoginUser();
        Long userId = loginUser.getUserId();

        String endType = (String) params.get("endType");
        String endName = (String) params.get("endName");
        String username = (String) params.get("username");

        if (StringUtils.isEmpty(endType))
        {
            return AjaxResult.error("目标端类型不能为空");
        }

        // 提取表单数据中的额外字段（排除基础字段）
        Map<String, Object> formData = new HashMap<>();
        for (Map.Entry<String, Object> entry : params.entrySet())
        {
            String key = entry.getKey();
            if (!"userId".equals(key) && !"username".equals(key) && !"endType".equals(key) && !"endName".equals(key))
            {
                formData.put(key, entry.getValue());
            }
        }

        EndSwitchApply apply = new EndSwitchApply();
        apply.setUserId(userId);
        apply.setUsername(username);
        apply.setEndType(endType);
        apply.setEndName(endName);
        // 将表单数据转为JSON字符串存储
        apply.setFormData(com.alibaba.fastjson2.JSONObject.toJSONString(formData));

        int result = endSwitchApplyService.insertEndSwitchApply(apply);
        return toAjax(result);
    }

    /**
     * 取消端切换申请
     */
    @PostMapping("/end-switch/cancel")
    public AjaxResult cancelEndSwitchApply()
    {
        LoginUser loginUser = getLoginUser();
        Long userId = loginUser.getUserId();

        int result = endSwitchApplyService.cancelEndSwitchApply(userId);
        return toAjax(result);
    }

    /**
     * 查询端切换申请状态
     */
    @GetMapping("/end-switch/status")
    public AjaxResult getEndSwitchStatus()
    {
        LoginUser loginUser = getLoginUser();
        Long userId = loginUser.getUserId();

        EndSwitchApply apply = endSwitchApplyService.selectLatestByUserId(userId);
        if (apply == null)
        {
            return AjaxResult.success(null);
        }

        // 按前端expected格式返回：auditStatus, createTime, auditRemark
        Map<String, Object> result = new HashMap<>();
        result.put("auditStatus", apply.getAuditStatus());
        result.put("createTime", apply.getCreateTime());
        result.put("auditRemark", apply.getAuditRemark());

        return AjaxResult.success(result);
    }
}
