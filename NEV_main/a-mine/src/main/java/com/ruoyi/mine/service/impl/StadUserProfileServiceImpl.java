package com.ruoyi.mine.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import com.ruoyi.mine.mapper.StadUserProfileMapper;
import com.ruoyi.mine.domain.MineStadUserProfile;
import com.ruoyi.mine.service.IStadUserProfileService;

@Service("mineStadUserProfileServiceImpl")
public class StadUserProfileServiceImpl implements IStadUserProfileService {

    @Autowired
    @Qualifier("mineStadUserProfileMapper")
    private StadUserProfileMapper stadUserProfileMapper;

    @Override
    public MineStadUserProfile selectStadUserProfileById(Long userId) {
        return stadUserProfileMapper.selectStadUserProfileById(userId);
    }

    @Override
    public List<MineStadUserProfile> selectStadUserProfileList(MineStadUserProfile profile) {
        return stadUserProfileMapper.selectStadUserProfileList(profile);
    }

    @Override
    public int insertStadUserProfile(MineStadUserProfile profile) {
        return stadUserProfileMapper.insertStadUserProfile(profile);
    }

    @Override
    public int updateStadUserProfile(MineStadUserProfile profile) {
        return stadUserProfileMapper.updateStadUserProfile(profile);
    }

    @Override
    public int deleteStadUserProfileById(Long userId) {
        return stadUserProfileMapper.deleteStadUserProfileById(userId);
    }

    @Override
    public int deleteStadUserProfileByIds(Long[] userIds) {
        return stadUserProfileMapper.deleteStadUserProfileByIds(userIds);
    }
}
