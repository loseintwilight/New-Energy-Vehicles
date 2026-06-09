package com.ruoyi.web.controller.mine;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.mine.domain.MineStadWallet;
import com.ruoyi.mine.service.IStadWalletService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/app/wallet")
public class AppWalletController {

    @Autowired
    private IStadWalletService walletService;

    @GetMapping("/info")
    public AjaxResult getWalletInfo() {
        Long userId = SecurityUtils.getUserId();
        MineStadWallet wallet = walletService.getOrCreateWallet(userId);
        
        Map<String, Object> result = new HashMap<>();
        result.put("balance", wallet.getBalance());
        result.put("totalRecharge", wallet.getTotalRecharge());
        result.put("totalWithdraw", wallet.getTotalWithdraw());
        result.put("freezeAmount", wallet.getFreezeAmount());
        
        return AjaxResult.success(result);
    }

    @PostMapping("/recharge")
    public AjaxResult recharge(@RequestBody Map<String, Object> data) {
        Long userId = SecurityUtils.getUserId();
        BigDecimal amount = new BigDecimal(data.get("amount").toString());
        
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            return AjaxResult.error("充值金额必须大于0");
        }
        
        walletService.recharge(userId, amount);
        return AjaxResult.success("充值成功");
    }

    @PostMapping("/withdraw")
    public AjaxResult withdraw(@RequestBody Map<String, Object> data) {
        Long userId = SecurityUtils.getUserId();
        BigDecimal amount = new BigDecimal(data.get("amount").toString());
        
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            return AjaxResult.error("提现金额必须大于0");
        }
        
        try {
            walletService.withdraw(userId, amount);
            return AjaxResult.success("提现成功");
        } catch (RuntimeException e) {
            return AjaxResult.error(e.getMessage());
        }
    }
}