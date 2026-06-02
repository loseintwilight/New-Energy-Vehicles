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
import com.ruoyi.business.domain.StadChargingRate;
import com.ruoyi.business.service.IStadChargingRateService;

@RestController
@RequestMapping("/business/chargingrate")
public class StadChargingRateController extends BaseController {

    @Autowired
    private IStadChargingRateService stadChargingRateService;

    @PreAuthorize("@ss.hasPermi('business:chargingrate:list')")
    @GetMapping("/list")
    public TableDataInfo list(StadChargingRate rate) {
        startPage();
        List<StadChargingRate> list = stadChargingRateService.selectStadChargingRateList(rate);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('business:chargingrate:query')")
    @GetMapping(value = "/{rateId}")
    public AjaxResult getInfo(@PathVariable("rateId") Long rateId) {
        return success(stadChargingRateService.selectStadChargingRateById(rateId));
    }

    @PreAuthorize("@ss.hasPermi('business:chargingrate:list')")
    @GetMapping(value = "/byStation/{stationId}")
    public AjaxResult listByStationId(@PathVariable("stationId") Long stationId) {
        return success(stadChargingRateService.selectStadChargingRateByStationId(stationId));
    }

    @PreAuthorize("@ss.hasPermi('business:chargingrate:add')")
    @Log(title = "充电费率", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody StadChargingRate rate) {
        return toAjax(stadChargingRateService.insertStadChargingRate(rate));
    }

    @PreAuthorize("@ss.hasPermi('business:chargingrate:edit')")
    @Log(title = "充电费率", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody StadChargingRate rate) {
        return toAjax(stadChargingRateService.updateStadChargingRate(rate));
    }

    @PreAuthorize("@ss.hasPermi('business:chargingrate:remove')")
    @Log(title = "充电费率", businessType = BusinessType.DELETE)
    @DeleteMapping("/{rateIds}")
    public AjaxResult remove(@PathVariable Long[] rateIds) {
        return toAjax(stadChargingRateService.deleteStadChargingRateByIds(rateIds));
    }
}