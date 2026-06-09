package com.ruoyi.charging.service.impl;

import com.ruoyi.business.domain.StadMerchant;
import com.ruoyi.business.mapper.StadMerchantMapper;
import com.ruoyi.charging.mapper.ChargingStationMapper;
import com.ruoyi.charging.service.IChargingStationService;
import com.ruoyi.charging.vo.MerchantStationVO;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class ChargingStationServiceImpl implements IChargingStationService {

    @Autowired
    private ChargingStationMapper chargingStationMapper;

    @Autowired
    private StadMerchantMapper stadMerchantMapper;

    @Override
    public AjaxResult getMerchantStationList() {
        Long userId = SecurityUtils.getUserId();
        if (userId == null) {
            return AjaxResult.error("用户未登录");
        }

        // 查找当前用户关联的商户
        StadMerchant merchant = stadMerchantMapper.selectStadMerchantByUserId(userId);
        if (merchant == null) {
            // 如果没有商户，返回空列表而不是报错
            Map<String, Object> result = new LinkedHashMap<>();
            result.put("rows", List.of());
            result.put("total", 0);
            return AjaxResult.success(result);
        }

        List<MerchantStationVO> list = chargingStationMapper.selectMerchantStationList(merchant.getMerchantId());

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("rows", list);
        result.put("total", list != null ? list.size() : 0);
        return AjaxResult.success(result);
    }
}
