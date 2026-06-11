package com.ruoyi.charging.mapper;

import com.ruoyi.charging.domain.EndSwitchApply;
import java.util.List;

/**
 * 端切换申请Mapper接口
 * 
 * @author ruoyi
 */
public interface EndSwitchApplyMapper 
{
    public EndSwitchApply selectEndSwitchApplyById(Long applyId);

    public List<EndSwitchApply> selectEndSwitchApplyList(EndSwitchApply apply);

    public EndSwitchApply selectLatestByUserId(Long userId);

    public int insertEndSwitchApply(EndSwitchApply apply);

    public int updateEndSwitchApply(EndSwitchApply apply);

    public int cancelEndSwitchApply(EndSwitchApply apply);
}
