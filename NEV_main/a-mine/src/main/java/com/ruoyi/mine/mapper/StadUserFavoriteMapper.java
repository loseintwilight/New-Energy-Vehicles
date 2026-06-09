package com.ruoyi.mine.mapper;

import java.util.List;
import com.ruoyi.mine.domain.MineStadUserFavorite;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository("mineStadUserFavoriteMapper")
public interface StadUserFavoriteMapper {
    public MineStadUserFavorite selectStadUserFavoriteById(Long favoriteId);
    public List<MineStadUserFavorite> selectStadUserFavoriteList(MineStadUserFavorite favorite);
    public int insertStadUserFavorite(MineStadUserFavorite favorite);
    public int updateStadUserFavorite(MineStadUserFavorite favorite);
    public int deleteStadUserFavoriteById(Long favoriteId);
    public int deleteStadUserFavoriteByIds(Long[] favoriteIds);
}
