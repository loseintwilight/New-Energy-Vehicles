package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.StadUserFavorite;

public interface IStadUserFavoriteService {
    StadUserFavorite selectStadUserFavoriteById(Long favoriteId);
    List<StadUserFavorite> selectStadUserFavoriteList(StadUserFavorite favorite);
    int insertStadUserFavorite(StadUserFavorite favorite);
    int updateStadUserFavorite(StadUserFavorite favorite);
    int deleteStadUserFavoriteByIds(Long[] favoriteIds);
}