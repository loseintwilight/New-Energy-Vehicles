package com.ruoyi.charging.controller;

import com.ruoyi.charging.domain.ChargingRate;
import com.ruoyi.charging.service.IChargingRateService;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

/**
 * 充电费率Controller
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/app/charge/rate")
public class AppChargingRateController extends BaseController
{
    @Autowired
    private IChargingRateService chargingRateService;

    /**
     * 查询充电费率列表
     */
    @Anonymous
    @GetMapping("/list")
    public TableDataInfo list(ChargingRate rate)
    {
        startPage();
        List<ChargingRate> list = chargingRateService.selectChargingRateList(rate);
        return getDataTable(list);
    }

    /**
     * 获取充电费率详细信息
     */
    @Anonymous
    @GetMapping(value = "/{rateId}")
    public AjaxResult getInfo(@PathVariable("rateId") Long rateId)
    {
        return success(chargingRateService.selectChargingRateById(rateId));
    }

    /**
     * 根据站点ID查询充电费率列表
     */
    @Anonymous
    @GetMapping("/station/{stationId}")
    public AjaxResult listByStationId(@PathVariable("stationId") Long stationId)
    {
        return success(chargingRateService.selectChargingRateListByStationId(stationId));
    }

    /**
     * 新增充电费率
     */
    @PostMapping
    public AjaxResult add(@RequestBody ChargingRate rate)
    {
        return toAjax(chargingRateService.insertChargingRate(rate));
    }

    /**
     * 修改充电费率
     */
    @PutMapping
    public AjaxResult edit(@RequestBody ChargingRate rate)
    {
        return toAjax(chargingRateService.updateChargingRate(rate));
    }

    /**
     * 删除充电费率
     */
    @DeleteMapping("/{rateIds}")
    public AjaxResult remove(@PathVariable Long[] rateIds)
    {
        return toAjax(chargingRateService.deleteChargingRateByIds(rateIds));
    }
}
