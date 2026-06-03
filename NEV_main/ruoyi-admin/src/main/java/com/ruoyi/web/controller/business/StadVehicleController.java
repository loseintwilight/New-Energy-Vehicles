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
import com.ruoyi.business.domain.StadVehicle;
import com.ruoyi.business.service.IStadVehicleService;

@RestController
@RequestMapping("/business/vehicle")
public class StadVehicleController extends BaseController {

    @Autowired
    private IStadVehicleService stadVehicleService;

    @PreAuthorize("@ss.hasPermi('business:vehicle:list')")
    @GetMapping("/list")
    public TableDataInfo list(StadVehicle vehicle) {
        startPage();
        List<StadVehicle> list = stadVehicleService.selectStadVehicleList(vehicle);
        return getDataTable(list);
    }

    @GetMapping(value = "/{vehicleId}")
    public AjaxResult getInfo(@PathVariable Long vehicleId) {
        return success(stadVehicleService.selectStadVehicleById(vehicleId));
    }

    @PreAuthorize("@ss.hasPermi('business:vehicle:query')")
    @GetMapping(value = "/detail/{vehicleId}")
    public AjaxResult detail(@PathVariable Long vehicleId) {
        return success(stadVehicleService.selectStadVehicleDetailById(vehicleId));
    }

    @PreAuthorize("@ss.hasPermi('business:vehicle:add')")
    @Log(title = "车辆管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody StadVehicle vehicle) {
        vehicle.setCreateBy(getUsername());
        return toAjax(stadVehicleService.insertStadVehicle(vehicle));
    }

    @PreAuthorize("@ss.hasPermi('business:vehicle:edit')")
    @Log(title = "车辆管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody StadVehicle vehicle) {
        vehicle.setUpdateBy(getUsername());
        return toAjax(stadVehicleService.updateStadVehicle(vehicle));
    }

    @PreAuthorize("@ss.hasPermi('business:vehicle:remove')")
    @Log(title = "车辆管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{vehicleIds}")
    public AjaxResult remove(@PathVariable Long[] vehicleIds) {
        return toAjax(stadVehicleService.deleteStadVehicleByIds(vehicleIds));
    }
}