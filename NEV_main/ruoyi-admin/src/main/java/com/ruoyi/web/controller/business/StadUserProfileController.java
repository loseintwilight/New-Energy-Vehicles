package com.ruoyi.web.controller.business;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
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
import com.ruoyi.business.domain.StadUserProfile;
import com.ruoyi.business.service.IStadUserProfileService;

@RestController
@RequestMapping("/business/profile")
public class StadUserProfileController extends BaseController {

    @Autowired
    private IStadUserProfileService stadUserProfileService;

    @PreAuthorize("@ss.hasPermi('business:profile:list')")
    @GetMapping("/list")
    public TableDataInfo list(StadUserProfile profile) {
        startPage();
        List<StadUserProfile> list = stadUserProfileService.selectStadUserProfileList(profile);
        return getDataTable(list);
    }

    @GetMapping(value = "/{userId}")
    public AjaxResult getInfo(@PathVariable Long userId) {
        return success(stadUserProfileService.selectStadUserProfileById(userId));
    }

    @PreAuthorize("@ss.hasPermi('business:profile:add')")
    @Log(title = "用户碳积分管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody StadUserProfile profile) {
        profile.setCreateBy(getUsername());
        return toAjax(stadUserProfileService.insertStadUserProfile(profile));
    }

    @PreAuthorize("@ss.hasPermi('business:profile:edit')")
    @Log(title = "用户碳积分管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody StadUserProfile profile) {
        profile.setUpdateBy(getUsername());
        return toAjax(stadUserProfileService.updateStadUserProfile(profile));
    }

    @PreAuthorize("@ss.hasPermi('business:profile:remove')")
    @Log(title = "用户碳积分管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{userIds}")
    public AjaxResult remove(@PathVariable Long[] userIds) {
        return toAjax(stadUserProfileService.deleteStadUserProfileByIds(userIds));
    }
}