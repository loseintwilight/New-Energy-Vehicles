package com.ruoyi.charging.controller;

import com.ruoyi.charging.domain.ChargingRatePeriod;
import com.ruoyi.charging.service.IChargingRatePeriodService;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

/**
 * 充电费率时段Controller
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/app/charge/rate/period")
public class AppChargingRatePeriodController extends BaseController
{
    @Autowired
    private IChargingRatePeriodService chargingRatePeriodService;

    /**
     * 查询充电费率时段列表
     */
    @Anonymous
    @GetMapping("/list")
    public TableDataInfo list(ChargingRatePeriod period)
    {
        startPage();
        List<ChargingRatePeriod> list = chargingRatePeriodService.selectChargingRatePeriodList(period);
        return getDataTable(list);
    }

    /**
     * 获取充电费率时段详细信息
     */
    @Anonymous
    @GetMapping(value = "/{periodId}")
    public AjaxResult getInfo(@PathVariable("periodId") Long periodId)
    {
        return success(chargingRatePeriodService.selectChargingRatePeriodById(periodId));
    }

    /**
     * 根据费率ID查询时段列表
     */
    @Anonymous
    @GetMapping("/rate/{rateId}")
    public AjaxResult listByRateId(@PathVariable("rateId") Long rateId)
    {
        return success(chargingRatePeriodService.selectChargingRatePeriodListByRateId(rateId));
    }

    /**
     * 新增充电费率时段
     */
    @PostMapping
    public AjaxResult add(@RequestBody ChargingRatePeriod period)
    {
        return toAjax(chargingRatePeriodService.insertChargingRatePeriod(period));
    }

    /**
     * 修改充电费率时段
     */
    @PutMapping
    public AjaxResult edit(@RequestBody ChargingRatePeriod period)
    {
        return toAjax(chargingRatePeriodService.updateChargingRatePeriod(period));
    }

    /**
     * 删除充电费率时段
     */
    @DeleteMapping("/{periodIds}")
    public AjaxResult remove(@PathVariable Long[] periodIds)
    {
        return toAjax(chargingRatePeriodService.deleteChargingRatePeriodByIds(periodIds));
    }

    /**
     * 根据费率ID删除所有关联时段（级联删除）
     */
    @DeleteMapping("/rate/{rateId}")
    public AjaxResult removeByRateId(@PathVariable("rateId") Long rateId)
    {
        return toAjax(chargingRatePeriodService.deleteChargingRatePeriodByRateId(rateId));
    }
}
