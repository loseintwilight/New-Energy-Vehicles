package com.ruoyi.charging.service.impl;

import com.ruoyi.charging.domain.EndSwitchApply;
import com.ruoyi.charging.mapper.EndSwitchApplyMapper;
import com.ruoyi.charging.service.IEndSwitchApplyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 端切换申请Service业务层处理
 * 
 * @author ruoyi
 */
@Service
public class EndSwitchApplyServiceImpl implements IEndSwitchApplyService 
{
    @Autowired
    private EndSwitchApplyMapper endSwitchApplyMapper;

    @Override
    public EndSwitchApply selectLatestByUserId(Long userId)
    {
        return endSwitchApplyMapper.selectLatestByUserId(userId);
    }

    @Override
    public int insertEndSwitchApply(EndSwitchApply apply)
    {
        apply.setAuditStatus("pending");
        return endSwitchApplyMapper.insertEndSwitchApply(apply);
    }

    @Override
    public int cancelEndSwitchApply(Long userId)
    {
        EndSwitchApply latest = endSwitchApplyMapper.selectLatestByUserId(userId);
        if (latest == null) return 0;

        latest.setUserId(userId);
        return endSwitchApplyMapper.cancelEndSwitchApply(latest);
    }
}
