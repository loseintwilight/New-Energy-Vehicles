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
import com.ruoyi.business.domain.StadUserFeedback;
import com.ruoyi.business.service.IStadUserFeedbackService;

@RestController
@RequestMapping("/business/feedback")
public class StadUserFeedbackController extends BaseController {

    @Autowired
    private IStadUserFeedbackService stadUserFeedbackService;

    @PreAuthorize("@ss.hasPermi('business:feedback:list')")
    @GetMapping("/list")
    public TableDataInfo list(StadUserFeedback feedback) {
        startPage();
        List<StadUserFeedback> list = stadUserFeedbackService.selectStadUserFeedbackList(feedback);
        return getDataTable(list);
    }

    @GetMapping(value = "/{feedbackId}")
    public AjaxResult getInfo(@PathVariable Long feedbackId) {
        return success(stadUserFeedbackService.selectStadUserFeedbackById(feedbackId));
    }

    @PreAuthorize("@ss.hasPermi('business:feedback:add')")
    @Log(title = "用户反馈管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody StadUserFeedback feedback) {
        feedback.setCreateBy(getUsername());
        return toAjax(stadUserFeedbackService.insertStadUserFeedback(feedback));
    }

    @PreAuthorize("@ss.hasPermi('business:feedback:edit')")
    @Log(title = "用户反馈管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody StadUserFeedback feedback) {
        feedback.setUpdateBy(getUsername());
        return toAjax(stadUserFeedbackService.updateStadUserFeedback(feedback));
    }

    @PreAuthorize("@ss.hasPermi('business:feedback:remove')")
    @Log(title = "用户反馈管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{feedbackIds}")
    public AjaxResult remove(@PathVariable Long[] feedbackIds) {
        return toAjax(stadUserFeedbackService.deleteStadUserFeedbackByIds(feedbackIds));
    }
}