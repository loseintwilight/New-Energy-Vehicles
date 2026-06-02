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
import com.ruoyi.business.domain.StadVehicleFinancePlan;
import com.ruoyi.business.service.IStadVehicleFinancePlanService;

@RestController
@RequestMapping("/business/financeplan")
public class StadVehicleFinancePlanController extends BaseController {

    @Autowired
    private IStadVehicleFinancePlanService stadVehicleFinancePlanService;

    @PreAuthorize("@ss.hasPermi('business:financeplan:list')")
    @GetMapping("/list")
    public TableDataInfo list(StadVehicleFinancePlan plan) {
        startPage();
        List<StadVehicleFinancePlan> list = stadVehicleFinancePlanService.selectStadVehicleFinancePlanList(plan);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('business:financeplan:query')")
    @GetMapping(value = "/{planId}")
    public AjaxResult getInfo(@PathVariable("planId") Long planId) {
        return success(stadVehicleFinancePlanService.selectStadVehicleFinancePlanById(planId));
    }

    @PreAuthorize("@ss.hasPermi('business:financeplan:list')")
    @GetMapping(value = "/byVehicle/{vehicleId}")
    public AjaxResult listByVehicleId(@PathVariable("vehicleId") Long vehicleId) {
        return success(stadVehicleFinancePlanService.selectStadVehicleFinancePlanByVehicleId(vehicleId));
    }

    @PreAuthorize("@ss.hasPermi('business:financeplan:add')")
    @Log(title = "金融方案", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody StadVehicleFinancePlan plan) {
        return toAjax(stadVehicleFinancePlanService.insertStadVehicleFinancePlan(plan));
    }

    @PreAuthorize("@ss.hasPermi('business:financeplan:edit')")
    @Log(title = "金融方案", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody StadVehicleFinancePlan plan) {
        return toAjax(stadVehicleFinancePlanService.updateStadVehicleFinancePlan(plan));
    }

    @PreAuthorize("@ss.hasPermi('business:financeplan:remove')")
    @Log(title = "金融方案", businessType = BusinessType.DELETE)
    @DeleteMapping("/{planIds}")
    public AjaxResult remove(@PathVariable Long[] planIds) {
        return toAjax(stadVehicleFinancePlanService.deleteStadVehicleFinancePlanByIds(planIds));
    }
}