package com.ruoyi.charging.service;

import com.ruoyi.common.core.domain.AjaxResult;

/**
 * 商户端-充电站Service接口
 */
public interface IChargingStationService {

    /** 获取当前商户的充电站列表（含今日统计数据） */
    AjaxResult getMerchantStationList();
}
