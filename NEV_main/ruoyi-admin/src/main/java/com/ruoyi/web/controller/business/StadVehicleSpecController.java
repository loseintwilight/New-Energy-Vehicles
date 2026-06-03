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
import com.ruoyi.business.domain.StadVehicleSpec;
import com.ruoyi.business.service.IStadVehicleSpecService;

@RestController
@RequestMapping("/business/vehiclespec")
public class StadVehicleSpecController extends BaseController {

    @Autowired
    private IStadVehicleSpecService stadVehicleSpecService;

    @PreAuthorize("@ss.hasPermi('business:vehiclespec:list')")
    @GetMapping("/list")
    public TableDataInfo list(StadVehicleSpec spec) {
        startPage();
        List<StadVehicleSpec> list = stadVehicleSpecService.selectStadVehicleSpecList(spec);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('business:vehiclespec:query')")
    @GetMapping(value = "/{specId}")
    public AjaxResult getInfo(@PathVariable("specId") Long specId) {
        return success(stadVehicleSpecService.selectStadVehicleSpecById(specId));
    }

    @PreAuthorize("@ss.hasPermi('business:vehiclespec:list')")
    @GetMapping(value = "/byVehicle/{vehicleId}")
    public AjaxResult listByVehicleId(@PathVariable("vehicleId") Long vehicleId) {
        return success(stadVehicleSpecService.selectStadVehicleSpecByVehicleId(vehicleId));
    }

    @PreAuthorize("@ss.hasPermi('business:vehiclespec:add')")
    @Log(title = "车辆规格配置", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody StadVehicleSpec spec) {
        return toAjax(stadVehicleSpecService.insertStadVehicleSpec(spec));
    }

    @PreAuthorize("@ss.hasPermi('business:vehiclespec:edit')")
    @Log(title = "车辆规格配置", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody StadVehicleSpec spec) {
        return toAjax(stadVehicleSpecService.updateStadVehicleSpec(spec));
    }

    @PreAuthorize("@ss.hasPermi('business:vehiclespec:remove')")
    @Log(title = "车辆规格配置", businessType = BusinessType.DELETE)
    @DeleteMapping("/{specIds}")
    public AjaxResult remove(@PathVariable Long[] specIds) {
        return toAjax(stadVehicleSpecService.deleteStadVehicleSpecByIds(specIds));
    }
}