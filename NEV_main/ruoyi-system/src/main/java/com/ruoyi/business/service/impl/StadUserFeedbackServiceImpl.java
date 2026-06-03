package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.mapper.StadUserFeedbackMapper;
import com.ruoyi.business.domain.StadUserFeedback;
import com.ruoyi.business.service.IStadUserFeedbackService;

@Service
public class StadUserFeedbackServiceImpl implements IStadUserFeedbackService {

    @Autowired
    private StadUserFeedbackMapper stadUserFeedbackMapper;

    @Override
    public StadUserFeedback selectStadUserFeedbackById(Long feedbackId) {
        return stadUserFeedbackMapper.selectStadUserFeedbackById(feedbackId);
    }

    @Override
    public List<StadUserFeedback> selectStadUserFeedbackList(StadUserFeedback feedback) {
        return stadUserFeedbackMapper.selectStadUserFeedbackList(feedback);
    }

    @Override
    public int insertStadUserFeedback(StadUserFeedback feedback) {
        return stadUserFeedbackMapper.insertStadUserFeedback(feedback);
    }

    @Override
    public int updateStadUserFeedback(StadUserFeedback feedback) {
        return stadUserFeedbackMapper.updateStadUserFeedback(feedback);
    }

    @Override
    public int deleteStadUserFeedbackByIds(Long[] feedbackIds) {
        return stadUserFeedbackMapper.deleteStadUserFeedbackByIds(feedbackIds);
    }
}