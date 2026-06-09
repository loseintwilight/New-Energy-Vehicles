package com.ruoyi.web.controller.chargeMini;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.mapper.PileMapper;
import com.ruoyi.mapper.StationMapper;
import com.ruoyi.service.PileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 小程序端 - 充电桩接口
 */
@RestController
@RequestMapping("/app/charge/pile")
public class PileController {

    @Autowired
    private PileService pileService;

    @Autowired
    private PileMapper pileMapper;

    @Autowired
    private StationMapper stationMapper;

    /**
     * 2.1 获取充电桩列表
     */
    @GetMapping("/list")
    public AjaxResult list(@RequestParam Long stationId) {
        return pileService.getPileList(stationId);
    }

    /**
     * 2.2 重置所有异常占用的充电桩为空闲（管理用）
     * 同时重新计算所有充电站的可用/占用桩数
     */
    @PostMapping("/reset-all")
    public AjaxResult resetAllPiles() {
        int count = pileMapper.resetAllStuckPiles();
        // 重置后重新统计所有站的桩数
        for (long sid = 1; sid <= 28; sid++) {
            stationMapper.syncStationPileCounts(sid);
        }
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("resetCount", count);
        data.put("message", "已重置 " + count + " 个充电桩为空闲状态，并同步更新了充电站表");
        return AjaxResult.success(data);
    }
}