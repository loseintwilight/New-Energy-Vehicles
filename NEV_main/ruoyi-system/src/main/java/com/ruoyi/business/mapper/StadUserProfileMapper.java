package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.StadUserProfile;

public interface StadUserProfileMapper {
    StadUserProfile selectStadUserProfileById(Long userId);
    List<StadUserProfile> selectStadUserProfileList(StadUserProfile profile);
    int insertStadUserProfile(StadUserProfile profile);
    int updateStadUserProfile(StadUserProfile profile);
    int deleteStadUserProfileById(Long userId);
    int deleteStadUserProfileByIds(Long[] userIds);
}