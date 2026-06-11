package com.ruoyi.charging.controller;

import com.ruoyi.charging.domain.ChargingSettlement;
import com.ruoyi.charging.service.IChargingSettlementService;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

/**
 * 充电结算Controller
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/app/charge/settlement")
public class AppChargingSettlementController extends BaseController
{
    @Autowired
    private IChargingSettlementService chargingSettlementService;

    /**
     * 查询充电结算列表
     */
    @Anonymous
    @GetMapping("/list")
    public TableDataInfo list(ChargingSettlement settlement)
    {
        startPage();
        List<ChargingSettlement> list = chargingSettlementService.selectChargingSettlementList(settlement);
        return getDataTable(list);
    }

    /**
     * 获取充电结算详细信息
     */
    @Anonymous
    @GetMapping(value = "/{settlementId}")
    public AjaxResult getInfo(@PathVariable("settlementId") Long settlementId)
    {
        return success(chargingSettlementService.selectChargingSettlementById(settlementId));
    }

    /**
     * 根据商户ID查询结算列表
     */
    @Anonymous
    @GetMapping("/merchant/{merchantId}")
    public AjaxResult listByMerchantId(@PathVariable("merchantId") Long merchantId)
    {
        return success(chargingSettlementService.selectChargingSettlementListByMerchantId(merchantId));
    }

    /**
     * 新增充电结算
     */
    @PostMapping
    public AjaxResult add(@RequestBody ChargingSettlement settlement)
    {
        return toAjax(chargingSettlementService.insertChargingSettlement(settlement));
    }

    /**
     * 修改充电结算
     */
    @PutMapping
    public AjaxResult edit(@RequestBody ChargingSettlement settlement)
    {
        return toAjax(chargingSettlementService.updateChargingSettlement(settlement));
    }

    /**
     * 删除充电结算
     */
    @DeleteMapping("/{settlementIds}")
    public AjaxResult remove(@PathVariable Long[] settlementIds)
    {
        return toAjax(chargingSettlementService.deleteChargingSettlementByIds(settlementIds));
    }
}
