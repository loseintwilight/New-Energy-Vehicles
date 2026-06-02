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
import com.ruoyi.business.domain.StadChargingRatePeriod;
import com.ruoyi.business.service.IStadChargingRatePeriodService;

@RestController
@RequestMapping("/business/chargingrateperiod")
public class StadChargingRatePeriodController extends BaseController {

    @Autowired
    private IStadChargingRatePeriodService stadChargingRatePeriodService;

    @PreAuthorize("@ss.hasPermi('business:chargingrateperiod:list')")
    @GetMapping("/list")
    public TableDataInfo list(StadChargingRatePeriod period) {
        startPage();
        List<StadChargingRatePeriod> list = stadChargingRatePeriodService.selectStadChargingRatePeriodList(period);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('business:chargingrateperiod:query')")
    @GetMapping(value = "/{periodId}")
    public AjaxResult getInfo(@PathVariable("periodId") Long periodId) {
        return success(stadChargingRatePeriodService.selectStadChargingRatePeriodById(periodId));
    }

    @PreAuthorize("@ss.hasPermi('business:chargingrateperiod:list')")
    @GetMapping(value = "/byRate/{rateId}")
    public AjaxResult listByRateId(@PathVariable("rateId") Long rateId) {
        return success(stadChargingRatePeriodService.selectStadChargingRatePeriodByRateId(rateId));
    }

    @PreAuthorize("@ss.hasPermi('business:chargingrateperiod:add')")
    @Log(title = "费率时段", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody StadChargingRatePeriod period) {
        return toAjax(stadChargingRatePeriodService.insertStadChargingRatePeriod(period));
    }

    @PreAuthorize("@ss.hasPermi('business:chargingrateperiod:edit')")
    @Log(title = "费率时段", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody StadChargingRatePeriod period) {
        return toAjax(stadChargingRatePeriodService.updateStadChargingRatePeriod(period));
    }

    @PreAuthorize("@ss.hasPermi('business:chargingrateperiod:remove')")
    @Log(title = "费率时段", businessType = BusinessType.DELETE)
    @DeleteMapping("/{periodIds}")
    public AjaxResult remove(@PathVariable Long[] periodIds) {
        return toAjax(stadChargingRatePeriodService.deleteStadChargingRatePeriodByIds(periodIds));
    }
}