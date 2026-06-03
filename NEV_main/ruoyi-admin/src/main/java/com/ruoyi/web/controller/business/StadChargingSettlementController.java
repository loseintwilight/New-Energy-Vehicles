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
import com.ruoyi.business.domain.StadChargingSettlement;
import com.ruoyi.business.service.IStadChargingSettlementService;

@RestController
@RequestMapping("/business/chargingsettlement")
public class StadChargingSettlementController extends BaseController {

    @Autowired
    private IStadChargingSettlementService stadChargingSettlementService;

    @PreAuthorize("@ss.hasPermi('business:chargingsettlement:list')")
    @GetMapping("/list")
    public TableDataInfo list(StadChargingSettlement settlement) {
        startPage();
        List<StadChargingSettlement> list = stadChargingSettlementService.selectStadChargingSettlementList(settlement);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('business:chargingsettlement:query')")
    @GetMapping(value = "/{settlementId}")
    public AjaxResult getInfo(@PathVariable("settlementId") Long settlementId) {
        return success(stadChargingSettlementService.selectStadChargingSettlementById(settlementId));
    }

    @PreAuthorize("@ss.hasPermi('business:chargingsettlement:add')")
    @Log(title = "充电结算", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody StadChargingSettlement settlement) {
        return toAjax(stadChargingSettlementService.insertStadChargingSettlement(settlement));
    }

    @PreAuthorize("@ss.hasPermi('business:chargingsettlement:edit')")
    @Log(title = "充电结算", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody StadChargingSettlement settlement) {
        return toAjax(stadChargingSettlementService.updateStadChargingSettlement(settlement));
    }

    @PreAuthorize("@ss.hasPermi('business:chargingsettlement:remove')")
    @Log(title = "充电结算", businessType = BusinessType.DELETE)
    @DeleteMapping("/{settlementIds}")
    public AjaxResult remove(@PathVariable Long[] settlementIds) {
        return toAjax(stadChargingSettlementService.deleteStadChargingSettlementByIds(settlementIds));
    }
}