package com.ruoyi.web.controller.business;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
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
import com.ruoyi.business.domain.StadChargingStation;
import com.ruoyi.business.service.IStadChargingStationService;

@RestController
@RequestMapping("/business/station")
public class StadChargingStationController extends BaseController {

    @Autowired
    private IStadChargingStationService stadChargingStationService;

    @PreAuthorize("@ss.hasPermi('business:station:list')")
    @GetMapping("/list")
    public TableDataInfo list(StadChargingStation station) {
        startPage();
        List<StadChargingStation> list = stadChargingStationService.selectStadChargingStationList(station);
        return getDataTable(list);
    }

    @GetMapping(value = "/{stationId}")
    public AjaxResult getInfo(@PathVariable Long stationId) {
        return success(stadChargingStationService.selectStadChargingStationById(stationId));
    }

    @PreAuthorize("@ss.hasPermi('business:station:add')")
    @Log(title = "充电站管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody StadChargingStation station) {
        station.setCreateBy(getUsername());
        return toAjax(stadChargingStationService.insertStadChargingStation(station));
    }

    @PreAuthorize("@ss.hasPermi('business:station:edit')")
    @Log(title = "充电站管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody StadChargingStation station) {
        station.setUpdateBy(getUsername());
        return toAjax(stadChargingStationService.updateStadChargingStation(station));
    }

    @PreAuthorize("@ss.hasPermi('business:station:remove')")
    @Log(title = "充电站管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{stationIds}")
    public AjaxResult remove(@PathVariable Long[] stationIds) {
        return toAjax(stadChargingStationService.deleteStadChargingStationByIds(stationIds));
    }
}