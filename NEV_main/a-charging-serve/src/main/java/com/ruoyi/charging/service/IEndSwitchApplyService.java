package com.ruoyi.charging.service;

import com.ruoyi.charging.domain.EndSwitchApply;

/**
 * 端切换申请Service接口
 * 
 * @author ruoyi
 */
public interface IEndSwitchApplyService 
{
    public EndSwitchApply selectLatestByUserId(Long userId);

    public int insertEndSwitchApply(EndSwitchApply apply);

    public int cancelEndSwitchApply(Long userId);
}
