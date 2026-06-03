package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.StadUserFavorite;

public interface StadUserFavoriteMapper {
    StadUserFavorite selectStadUserFavoriteById(Long favoriteId);
    List<StadUserFavorite> selectStadUserFavoriteList(StadUserFavorite favorite);
    int insertStadUserFavorite(StadUserFavorite favorite);
    int updateStadUserFavorite(StadUserFavorite favorite);
    int deleteStadUserFavoriteById(Long favoriteId);
    int deleteStadUserFavoriteByIds(Long[] favoriteIds);
}