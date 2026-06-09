package com.ruoyi.mine.mapper;

import java.util.List;
import com.ruoyi.mine.domain.MineStadUserProfile;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository("mineStadUserProfileMapper")
public interface StadUserProfileMapper {
    public MineStadUserProfile selectStadUserProfileById(Long userId);
    public List<MineStadUserProfile> selectStadUserProfileList(MineStadUserProfile profile);
    public int insertStadUserProfile(MineStadUserProfile profile);
    public int updateStadUserProfile(MineStadUserProfile profile);
    public int deleteStadUserProfileById(Long userId);
    public int deleteStadUserProfileByIds(Long[] userIds);
}
