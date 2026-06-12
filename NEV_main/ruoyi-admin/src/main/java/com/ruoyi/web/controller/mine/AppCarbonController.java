package com.ruoyi.web.controller.mine;

import com.ruoyi.mine.domain.MineStadCarbonLedger;
import com.ruoyi.mine.domain.MineStadUserProfile;
import com.ruoyi.mine.service.IStadCarbonLedgerService;
import com.ruoyi.mine.service.IStadUserProfileService;
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

    @Autowired
    private IStadUserProfileService stadUserProfileService;

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

    /**
     * 订单支付完成后发放碳积分
     * @param sourceType 来源类型: 0=充电, 1=购车
     * @param sourceId 订单号（字符串类型，兼容充电单号如CO...）
     * @param points 获得的碳积分数
     */
    @Log(title = "碳积分", businessType = BusinessType.INSERT)
    @PostMapping("/award")
    public AjaxResult awardPoints(@RequestParam Integer sourceType,
                                   @RequestParam String sourceId,
                                   @RequestParam Integer points) {
        Long userId = SecurityUtils.getUserId();
        if (userId == null) {
            return AjaxResult.error("未获取到用户信息");
        }
        if (points == null || points <= 0) {
            return AjaxResult.error("积分数无效");
        }

        MineStadCarbonLedger ledger = new MineStadCarbonLedger();
        ledger.setUserId(userId);
        ledger.setRecordType(0); // 获得
        ledger.setPoints(points);
        ledger.setSourceType(sourceType);
        // sourceId是字符串（如订单号），尝试转Long，失败则存null
        try {
            ledger.setSourceId(Long.valueOf(sourceId));
        } catch (NumberFormatException e) {
            // 非数字订单号，sourceId留null，订单号记在remark中
        }

        String remark;
        if (sourceType == 0) {
            remark = "充电获得" + points + "积分";
        } else if (sourceType == 1) {
            remark = "购车奖励" + points + "积分";
        } else {
            remark = "获得" + points + "积分";
        }
        if (sourceId != null && sourceId.length() > 10) {
            remark += "(" + sourceId + ")";
        }
        ledger.setRemark(remark);

        // 记录碳积分流水
        stadCarbonLedgerService.insertStadCarbonLedger(ledger);

        // 更新用户碳积分余额
        MineStadUserProfile profile = stadUserProfileService.selectStadUserProfileById(userId);
        if (profile != null) {
            profile.setTotalEarned(profile.getTotalEarned() + points);
            profile.setBalance(profile.getBalance() + points);
            stadUserProfileService.updateStadUserProfile(profile);
        } else {
            profile = new MineStadUserProfile();
            profile.setUserId(userId);
            profile.setTotalEarned(points);
            profile.setTotalSpent(0);
            profile.setBalance(points);
            stadUserProfileService.insertStadUserProfile(profile);
        }

        return AjaxResult.success("获得" + points + "碳积分");
    }
}
