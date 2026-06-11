package com.ruoyi.charging.controller;

import com.ruoyi.charging.domain.AppMerchant;
import com.ruoyi.charging.domain.MerchantProfileVO;
import com.ruoyi.charging.mapper.ChargingStationMapper;
import com.ruoyi.charging.service.IAppMerchantService;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.utils.SecurityUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 商户个人资料 Controller（按商家端逻辑实现）
 * 使用 VO 替代 Map 传参
 */
@RestController
@RequestMapping("/app/charge/merchant/profile")
public class AppMerchantProfileController extends BaseController {

    @Autowired
    private IAppMerchantService appMerchantService;

    @Autowired
    private ChargingStationMapper chargingStationMapper;

    /**
     * 获取商户个人资料
     */
    @GetMapping
    public AjaxResult getProfile() {
        Long userId = SecurityUtils.getUserId();
        AppMerchant merchant = appMerchantService.selectAppMerchantByUserId(userId);
        if (merchant == null) {
            return AjaxResult.error("商户信息不存在");
        }

        MerchantProfileVO vo = new MerchantProfileVO();
        BeanUtils.copyProperties(merchant, vo);

        // 补充用户信息
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (loginUser != null) {
            vo.setNickName(loginUser.getUser().getNickName());
            vo.setAvatar(loginUser.getUser().getAvatar());
            vo.setEmail(loginUser.getUser().getEmail());
        }

        // 统计信息
        vo.setStationCount(chargingStationMapper.selectChargingStationListByMerchantId(merchant.getMerchantId()).size());

        return AjaxResult.success(vo);
    }

    /**
     * 更新商户个人资料
     */
    @PutMapping
    public AjaxResult updateProfile(@RequestBody MerchantProfileVO vo) {
        Long userId = SecurityUtils.getUserId();
        AppMerchant merchant = appMerchantService.selectAppMerchantByUserId(userId);
        if (merchant == null) {
            return AjaxResult.error("商户信息不存在");
        }

        // 更新可编辑字段（商户表字段）
        if (vo.getMerchantName() != null) merchant.setMerchantName(vo.getMerchantName());
        if (vo.getContactName() != null) merchant.setContactName(vo.getContactName());
        if (vo.getContactPhone() != null) merchant.setContactPhone(vo.getContactPhone());
        if (vo.getProvince() != null) merchant.setProvince(vo.getProvince());
        if (vo.getCity() != null) merchant.setCity(vo.getCity());
        if (vo.getAddress() != null) merchant.setAddress(vo.getAddress());

        return toAjax(appMerchantService.updateAppMerchant(merchant));
    }
}
