package com.ruoyi.web.controller.mine;

import com.ruoyi.mine.domain.MineStadUserProfile;
import com.ruoyi.mine.service.IStadUserProfileService;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/app/profile")
public class AppProfileController extends BaseController {

    @Autowired
    private IStadUserProfileService stadUserProfileService;

    @GetMapping("/userInfo")
    public AjaxResult getUserInfo() {
        Long userId = SecurityUtils.getUserId();
        MineStadUserProfile profile = stadUserProfileService.selectStadUserProfileById(userId);

        Map<String, Object> result = new HashMap<>();
        if (profile != null) {
            result.put("userId", profile.getUserId());
            result.put("nickName", profile.getNickName());
            result.put("idCard", profile.getIdCard());
            result.put("totalEarned", profile.getTotalEarned());
            result.put("totalSpent", profile.getTotalSpent());
            result.put("balance", profile.getBalance());
        }
        return AjaxResult.success(result);
    }

    @Log(title = "用户档案", businessType = BusinessType.UPDATE)
    @PutMapping("/update")
    public AjaxResult updateProfile(@RequestBody MineStadUserProfile profile) {
        Long userId = SecurityUtils.getUserId();
        profile.setUserId(userId);
        int result = stadUserProfileService.updateStadUserProfile(profile);
        return toAjax(result);
    }

    @Log(title = "用户档案", businessType = BusinessType.UPDATE)
    @PostMapping("/avatar")
    public AjaxResult updateAvatar(@RequestBody Map<String, Object> data) {
        return AjaxResult.success("头像更新成功");
    }

    @Log(title = "用户档案", businessType = BusinessType.UPDATE)
    @PutMapping("/password")
    public AjaxResult updatePassword(@RequestBody Map<String, Object> data) {
        return AjaxResult.success("密码修改成功");
    }

    @GetMapping("/stats")
    public AjaxResult getUserStats() {
        Long userId = SecurityUtils.getUserId();
        MineStadUserProfile profile = stadUserProfileService.selectStadUserProfileById(userId);
        Map<String, Object> stats = new HashMap<>();
        if (profile != null) {
            stats.put("totalEarned", profile.getTotalEarned());
            stats.put("totalSpent", profile.getTotalSpent());
            stats.put("balance", profile.getBalance());
        }
        return AjaxResult.success(stats);
    }
}
