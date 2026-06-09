package com.ruoyi.mine.service;

import java.util.List;
import com.ruoyi.mine.domain.MineStadUserProfile;

public interface IStadUserProfileService {
    public MineStadUserProfile selectStadUserProfileById(Long userId);
    public List<MineStadUserProfile> selectStadUserProfileList(MineStadUserProfile profile);
    public int insertStadUserProfile(MineStadUserProfile profile);
    public int updateStadUserProfile(MineStadUserProfile profile);
    public int deleteStadUserProfileById(Long userId);
    public int deleteStadUserProfileByIds(Long[] userIds);
}
