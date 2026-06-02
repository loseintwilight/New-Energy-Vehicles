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
import com.ruoyi.business.domain.StadCarbonLedger;
import com.ruoyi.business.service.IStadCarbonLedgerService;

@RestController
@RequestMapping("/business/carbonledger")
public class StadCarbonLedgerController extends BaseController {

    @Autowired
    private IStadCarbonLedgerService stadCarbonLedgerService;

    @PreAuthorize("@ss.hasPermi('business:carbonledger:list')")
    @GetMapping("/list")
    public TableDataInfo list(StadCarbonLedger ledger) {
        startPage();
        List<StadCarbonLedger> list = stadCarbonLedgerService.selectStadCarbonLedgerList(ledger);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('business:carbonledger:query')")
    @GetMapping(value = "/{ledgerId}")
    public AjaxResult getInfo(@PathVariable("ledgerId") Long ledgerId) {
        return success(stadCarbonLedgerService.selectStadCarbonLedgerById(ledgerId));
    }

    @PreAuthorize("@ss.hasPermi('business:carbonledger:list')")
    @GetMapping(value = "/byUser/{userId}")
    public AjaxResult listByUserId(@PathVariable("userId") Long userId) {
        return success(stadCarbonLedgerService.selectStadCarbonLedgerByUserId(userId));
    }

    @PreAuthorize("@ss.hasPermi('business:carbonledger:add')")
    @Log(title = "碳积分流水", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody StadCarbonLedger ledger) {
        return toAjax(stadCarbonLedgerService.insertStadCarbonLedger(ledger));
    }

    @PreAuthorize("@ss.hasPermi('business:carbonledger:edit')")
    @Log(title = "碳积分流水", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody StadCarbonLedger ledger) {
        return toAjax(stadCarbonLedgerService.updateStadCarbonLedger(ledger));
    }

    @PreAuthorize("@ss.hasPermi('business:carbonledger:remove')")
    @Log(title = "碳积分流水", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ledgerIds}")
    public AjaxResult remove(@PathVariable Long[] ledgerIds) {
        return toAjax(stadCarbonLedgerService.deleteStadCarbonLedgerByIds(ledgerIds));
    }
}