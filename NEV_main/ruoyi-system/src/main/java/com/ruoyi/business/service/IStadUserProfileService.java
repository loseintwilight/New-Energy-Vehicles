package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.StadUserProfile;

public interface IStadUserProfileService {
    StadUserProfile selectStadUserProfileById(Long userId);
    List<StadUserProfile> selectStadUserProfileList(StadUserProfile profile);
    int insertStadUserProfile(StadUserProfile profile);
    int updateStadUserProfile(StadUserProfile profile);
    int deleteStadUserProfileByIds(Long[] userIds);
}