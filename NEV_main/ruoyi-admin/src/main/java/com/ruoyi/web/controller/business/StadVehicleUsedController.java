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
import com.ruoyi.business.domain.StadVehicleUsed;
import com.ruoyi.business.service.IStadVehicleUsedService;

@RestController
@RequestMapping("/business/vehicleused")
public class StadVehicleUsedController extends BaseController {

    @Autowired
    private IStadVehicleUsedService stadVehicleUsedService;

    @PreAuthorize("@ss.hasPermi('business:vehicleused:list')")
    @GetMapping("/list")
    public TableDataInfo list(StadVehicleUsed used) {
        startPage();
        List<StadVehicleUsed> list = stadVehicleUsedService.selectStadVehicleUsedList(used);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('business:vehicleused:query')")
    @GetMapping(value = "/{usedId}")
    public AjaxResult getInfo(@PathVariable("usedId") Long usedId) {
        return success(stadVehicleUsedService.selectStadVehicleUsedById(usedId));
    }

    @PreAuthorize("@ss.hasPermi('business:vehicleused:list')")
    @GetMapping(value = "/byVehicle/{vehicleId}")
    public AjaxResult getByVehicleId(@PathVariable("vehicleId") Long vehicleId) {
        return success(stadVehicleUsedService.selectStadVehicleUsedByVehicleId(vehicleId));
    }

    @PreAuthorize("@ss.hasPermi('business:vehicleused:add')")
    @Log(title = "二手车信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody StadVehicleUsed used) {
        return toAjax(stadVehicleUsedService.insertStadVehicleUsed(used));
    }

    @PreAuthorize("@ss.hasPermi('business:vehicleused:edit')")
    @Log(title = "二手车信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody StadVehicleUsed used) {
        return toAjax(stadVehicleUsedService.updateStadVehicleUsed(used));
    }

    @PreAuthorize("@ss.hasPermi('business:vehicleused:remove')")
    @Log(title = "二手车信息", businessType = BusinessType.DELETE)
    @DeleteMapping("/{usedIds}")
    public AjaxResult remove(@PathVariable Long[] usedIds) {
        return toAjax(stadVehicleUsedService.deleteStadVehicleUsedByIds(usedIds));
    }
}