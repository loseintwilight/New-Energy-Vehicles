package com.ruoyi.service.impl;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.mapper.PileMapper;
import com.ruoyi.service.PileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class PileServiceImpl implements PileService {

    @Autowired
    private PileMapper pileMapper;

    @Override
    public AjaxResult getPileList(Long stationId) {
        if (stationId == null) {
            return AjaxResult.error("充电站ID不能为空");
        }
        List<Map<String, Object>> list = pileMapper.selectPileListByStationId(stationId);
        return AjaxResult.success(list);
    }
}