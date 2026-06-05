package com.ruoyi.web.controller.chargeMini;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.service.StationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 小程序端 - 城市列表接口
 */
@RestController
@RequestMapping("/app/charge/city")
public class CityController {

    @Autowired
    private StationService stationService;

    /**
     * 4.1 获取城市列表
     */
    @GetMapping("/list")
    public AjaxResult list() {
        return stationService.getCityList();
    }
}