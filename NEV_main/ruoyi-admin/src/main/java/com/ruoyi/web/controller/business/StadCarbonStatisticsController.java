package com.ruoyi.web.controller.business;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
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
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.business.domain.StadCarbonStatistics;
import com.ruoyi.business.service.IStadCarbonStatisticsService;

@RestController
@RequestMapping("/business/carbonstatistics")
public class StadCarbonStatisticsController extends BaseController {

    @Autowired
    private IStadCarbonStatisticsService stadCarbonStatisticsService;

    @PreAuthorize("@ss.hasPermi('business:carbonstatistics:list')")
    @GetMapping("/list")
    public TableDataInfo list(StadCarbonStatistics statistics) {
        startPage();
        List<StadCarbonStatistics> list = stadCarbonStatisticsService.selectStadCarbonStatisticsList(statistics);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('business:carbonstatistics:query')")
    @GetMapping(value = "/{statId}")
    public AjaxResult getInfo(@PathVariable("statId") Long statId) {
        return success(stadCarbonStatisticsService.selectStadCarbonStatisticsById(statId));
    }

    @PreAuthorize("@ss.hasPermi('business:carbonstatistics:add')")
    @Log(title = "碳减排统计", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody StadCarbonStatistics statistics) {
        return toAjax(stadCarbonStatisticsService.insertStadCarbonStatistics(statistics));
    }

    @PreAuthorize("@ss.hasPermi('business:carbonstatistics:edit')")
    @Log(title = "碳减排统计", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody StadCarbonStatistics statistics) {
        return toAjax(stadCarbonStatisticsService.updateStadCarbonStatistics(statistics));
    }

    @PreAuthorize("@ss.hasPermi('business:carbonstatistics:remove')")
    @Log(title = "碳减排统计", businessType = BusinessType.DELETE)
    @DeleteMapping("/{statIds}")
    public AjaxResult remove(@PathVariable Long[] statIds) {
        return toAjax(stadCarbonStatisticsService.deleteStadCarbonStatisticsByIds(statIds));
    }
}