package com.ruoyi.charging.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.charging.domain.CarbonStatistics;
import com.ruoyi.charging.service.ICarbonStatisticsService;

/**
 * 碳排放统计 信息操作处理
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/app/charge/carbon/statistics")
public class CarbonStatisticsController extends BaseController
{
    @Autowired
    private ICarbonStatisticsService statisticsService;

    /**
     * 获取碳排放统计列表
     */
    @PreAuthorize("@ss.hasPermi('carbon:statistics:list')")
    @GetMapping("/list")
    public TableDataInfo list(CarbonStatistics statistics)
    {
        startPage();
        List<CarbonStatistics> list = statisticsService.selectCarbonStatisticsList(statistics);
        return getDataTable(list);
    }

    /**
     * 获取碳排放统计详情
     */
    @PreAuthorize("@ss.hasPermi('carbon:statistics:query')")
    @GetMapping(value = "/{statId}")
    public AjaxResult getInfo(@PathVariable Long statId)
    {
        return success(statisticsService.selectCarbonStatisticsById(statId));
    }

    /**
     * 新增碳排放统计
     */
    @PreAuthorize("@ss.hasPermi('carbon:statistics:add')")
    @Log(title = "碳排放统计管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody CarbonStatistics statistics)
    {
        statistics.setCreateBy(getUsername());
        return toAjax(statisticsService.insertCarbonStatistics(statistics));
    }

    /**
     * 修改碳排放统计
     */
    @PreAuthorize("@ss.hasPermi('carbon:statistics:edit')")
    @Log(title = "碳排放统计管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody CarbonStatistics statistics)
    {
        statistics.setUpdateBy(getUsername());
        return toAjax(statisticsService.updateCarbonStatistics(statistics));
    }
}
