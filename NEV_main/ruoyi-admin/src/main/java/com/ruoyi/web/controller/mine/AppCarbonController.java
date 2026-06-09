package com.ruoyi.web.controller.mine;

import com.ruoyi.mine.domain.MineStadCarbonLedger;
import com.ruoyi.mine.service.IStadCarbonLedgerService;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/app/carbon")
public class AppCarbonController extends BaseController {

    @Autowired
    private IStadCarbonLedgerService stadCarbonLedgerService;

    /**
     * 获取碳积分概览
     */
    @GetMapping("/overview")
    public AjaxResult getCarbonOverview() {
        Long userId = SecurityUtils.getUserId();
        Map<String, Object> overview = stadCarbonLedgerService.getCarbonOverview(userId);
        return AjaxResult.success(overview);
    }

    /**
     * 获取碳积分获取方式
     */
    @GetMapping("/ways")
    public AjaxResult getCarbonEarnWays() {
        List<Map<String, Object>> ways = stadCarbonLedgerService.getCarbonEarnWays();
        return AjaxResult.success(ways);
    }

    /**
     * 获取碳积分记录列表
     */
    @GetMapping("/records")
    public TableDataInfo getCarbonRecords(MineStadCarbonLedger ledger) {
        startPage();
        Long userId = SecurityUtils.getUserId();
        List<Map<String, Object>> resultList = stadCarbonLedgerService.getFormattedCarbonRecords(userId, ledger);
        return getDataTable(resultList);
    }

    /**
     * 碳积分兑换
     */
    @Log(title = "碳积分", businessType = BusinessType.UPDATE)
    @PostMapping("/exchange")
    public AjaxResult exchangePoints(@RequestBody Map<String, Object> data) {
        Long userId = SecurityUtils.getUserId();
        boolean success = stadCarbonLedgerService.exchangePoints(userId, data);
        if (!success) {
            return AjaxResult.success("兑换功能开发中");
        }
        return AjaxResult.success("兑换成功");
    }

    /**
     * 获取兑换商品列表
     */
    @GetMapping("/products")
    public AjaxResult getExchangeProducts() {
        List<Map<String, Object>> products = stadCarbonLedgerService.getExchangeProducts();
        return AjaxResult.success(products);
    }

    /**
     * 碳积分签到
     */
    @Log(title = "碳积分", businessType = BusinessType.INSERT)
    @PostMapping("/checkin")
    public AjaxResult doCheckIn() {
        Long userId = SecurityUtils.getUserId();
        boolean success = stadCarbonLedgerService.doCheckIn(userId);
        if (!success) {
            return AjaxResult.error("签到失败");
        }
        return AjaxResult.success("签到成功，获得5积分");
    }
}
