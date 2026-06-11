package com.ruoyi.charging.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.charging.domain.CarbonLedger;
import com.ruoyi.charging.service.ICarbonLedgerService;

/**
 * 碳积分流水 信息操作处理
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/app/charge/carbon/ledger")
public class CarbonLedgerController extends BaseController
{
    @Autowired
    private ICarbonLedgerService ledgerService;

    /**
     * 获取碳积分流水列表
     */
    @PreAuthorize("@ss.hasPermi('carbon:ledger:list')")
    @GetMapping("/list")
    public TableDataInfo list(CarbonLedger ledger)
    {
        startPage();
        List<CarbonLedger> list = ledgerService.selectCarbonLedgerList(ledger);
        return getDataTable(list);
    }

    /**
     * 获取碳积分流水详情
     */
    @PreAuthorize("@ss.hasPermi('carbon:ledger:query')")
    @GetMapping(value = "/{ledgerId}")
    public AjaxResult getInfo(@PathVariable Long ledgerId)
    {
        return success(ledgerService.selectCarbonLedgerById(ledgerId));
    }

    /**
     * 删除碳积分流水
     */
    @PreAuthorize("@ss.hasPermi('carbon:ledger:remove')")
    @Log(title = "碳积分流水管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ledgerIds}")
    public AjaxResult remove(@PathVariable Long[] ledgerIds)
    {
        return toAjax(ledgerService.deleteCarbonLedgerByIds(ledgerIds));
    }
}
