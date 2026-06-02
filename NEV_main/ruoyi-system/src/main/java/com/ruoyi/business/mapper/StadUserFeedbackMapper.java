package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.StadUserFeedback;

public interface StadUserFeedbackMapper {
    StadUserFeedback selectStadUserFeedbackById(Long feedbackId);
    List<StadUserFeedback> selectStadUserFeedbackList(StadUserFeedback feedback);
    int insertStadUserFeedback(StadUserFeedback feedback);
    int updateStadUserFeedback(StadUserFeedback feedback);
    int deleteStadUserFeedbackById(Long feedbackId);
    int deleteStadUserFeedbackByIds(Long[] feedbackIds);
}