package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.StadUserFeedback;

public interface IStadUserFeedbackService {
    StadUserFeedback selectStadUserFeedbackById(Long feedbackId);
    List<StadUserFeedback> selectStadUserFeedbackList(StadUserFeedback feedback);
    int insertStadUserFeedback(StadUserFeedback feedback);
    int updateStadUserFeedback(StadUserFeedback feedback);
    int deleteStadUserFeedbackByIds(Long[] feedbackIds);
}