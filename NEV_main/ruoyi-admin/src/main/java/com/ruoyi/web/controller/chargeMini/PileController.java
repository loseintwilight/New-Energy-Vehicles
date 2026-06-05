package com.ruoyi.web.controller.chargeMini;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.service.PileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * 小程序端 - 充电桩接口
 */
@RestController
@RequestMapping("/app/charge/pile")
public class PileController {

    @Autowired
    private PileService pileService;

    /**
     * 2.1 获取充电桩列表
     */
    @GetMapping("/list")
    public AjaxResult list(@RequestParam Long stationId) {
        return pileService.getPileList(stationId);
    }
}