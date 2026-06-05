package com.ruoyi.service;

import com.ruoyi.common.core.domain.AjaxResult;

public interface PileService {

    /** 获取充电站下的充电桩列表 */
    AjaxResult getPileList(Long stationId);
}