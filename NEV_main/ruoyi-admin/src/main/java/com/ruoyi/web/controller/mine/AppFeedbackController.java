package com.ruoyi.web.controller.mine;

import com.ruoyi.business.domain.StadUserFeedback;
import com.ruoyi.business.service.IStadUserFeedbackService;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/app/feedback")
public class AppFeedbackController extends BaseController {

    @Autowired
    private IStadUserFeedbackService stadUserFeedbackService;

    @GetMapping("/list")
    public TableDataInfo list(StadUserFeedback feedback) {
        startPage();
        Long userId = SecurityUtils.getUserId();
        feedback.setUserId(userId);
        return getDataTable(stadUserFeedbackService.selectStadUserFeedbackList(feedback));
    }

    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable Long id) {
        return success(stadUserFeedbackService.selectStadUserFeedbackById(id));
    }

    @PostMapping
    public AjaxResult add(@RequestBody StadUserFeedback feedback) {
        Long userId = SecurityUtils.getUserId();
        feedback.setUserId(userId);
        return toAjax(stadUserFeedbackService.insertStadUserFeedback(feedback));
    }
}
