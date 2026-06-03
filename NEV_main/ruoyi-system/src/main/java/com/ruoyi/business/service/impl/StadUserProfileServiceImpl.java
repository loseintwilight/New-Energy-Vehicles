package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.mapper.StadUserProfileMapper;
import com.ruoyi.business.domain.StadUserProfile;
import com.ruoyi.business.service.IStadUserProfileService;

@Service
public class StadUserProfileServiceImpl implements IStadUserProfileService {

    @Autowired
    private StadUserProfileMapper stadUserProfileMapper;

    @Override
    public StadUserProfile selectStadUserProfileById(Long userId) {
        return stadUserProfileMapper.selectStadUserProfileById(userId);
    }

    @Override
    public List<StadUserProfile> selectStadUserProfileList(StadUserProfile profile) {
        return stadUserProfileMapper.selectStadUserProfileList(profile);
    }

    @Override
    public int insertStadUserProfile(StadUserProfile profile) {
        return stadUserProfileMapper.insertStadUserProfile(profile);
    }

    @Override
    public int updateStadUserProfile(StadUserProfile profile) {
        return stadUserProfileMapper.updateStadUserProfile(profile);
    }

    @Override
    public int deleteStadUserProfileByIds(Long[] userIds) {
        return stadUserProfileMapper.deleteStadUserProfileByIds(userIds);
    }
}